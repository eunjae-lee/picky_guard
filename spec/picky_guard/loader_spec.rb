# frozen_string_literal: true

require 'picky_guard/loader'
require 'picky_guard/role_policies'
require 'picky_guard/user_role_checker'
require 'picky_guard/resource_actions'
require 'picky_guard/policy'

class MyAbility < PickyGuard::Loader
end

class App < ActiveRecord::Base
end

class MyRolePolicies < PickyGuard::RolePolicies
  def initialize
    map(:role_manager, [AppFullAccess])
    map(:role_reader, [AppReadAccess])
  end
end

class MyUserRoleChecker < PickyGuard::UserRoleChecker
  def self.check(user, role)
    {
      a: [:role_manager],
      b: [:role_reader]
    }[user].include? role
  end
end

class MyResourceActions < PickyGuard::ResourceActions
  def initialize
    map(App, %w[Create Read Update Delete])
  end
end

class AppFullAccess < PickyGuard::Policy
  def initialize(current_user)
    add_statement(
      PickyGuard::Statement.allow(
        %w[Create Read Update Delete],
        App,
        {}
      )
    )
  end
end

class AppReadAccess < PickyGuard::Policy
  def initialize(current_user)
    add_statement(
      PickyGuard::Statement.allow(
        %w[Read],
        App,
        {}
      )
    )
  end
end

class MyRolePolicies2 < PickyGuard::RolePolicies
  def initialize
    map(:role_manager, [AppFullAccess2])
    map(:role_reader, [AppReadAccess2])
  end
end

class AppFullAccess2 < PickyGuard::Policy
  def initialize(current_user)
    add_statement(
      PickyGuard::Statement.allow(
        %w[Create Read Update Delete],
        App,
        proc { App.all }
      )
    )
  end
end

class AppReadAccess2 < PickyGuard::Policy
  def initialize(current_user)
    add_statement(
      PickyGuard::Statement.allow(
        %w[Read],
        App,
        proc { App.all }
      )
    )
  end
end

class MyRolePolicies3 < PickyGuard::RolePolicies
  def initialize
    map(:role_manager, [AppFullAccess3])
  end
end

class AppFullAccess3 < PickyGuard::Policy
  def initialize(current_user)
    add_statement(
      PickyGuard::Statement.allow(
        %w[Create Read Update Delete UnknownWeirdAction],
        App,
        proc { App.all }
      )
    )
  end
end

module PickyGuard
  describe Loader do
    before(:each) do
      App.destroy_all
      3.times do
        App.create
      end
    end

    it 'works with manager' do
      ability = MyAbility.new
      ability.adjust(:a, MyUserRoleChecker, MyRolePolicies, MyResourceActions)
      %w[Create Read Update Delete].each do |action|
        App.all.each do |app|
          expect(ability.can?(action, app)).to be_truthy
        end
      end
    end

    it 'works with reader' do
      ability = MyAbility.new
      ability.adjust(:b, MyUserRoleChecker, MyRolePolicies, MyResourceActions)
      %w[Read].each do |action|
        App.all.each do |app|
          expect(ability.can?(action, app)).to be_truthy
        end
      end
      %w[Create Update Delete].each do |action|
        App.all.each do |app|
          expect(ability.can?(action, app)).to be_falsey
        end
      end
    end

    it 'works with manager (with proc conditions)' do
      ability = MyAbility.new
      ability.adjust(:a, MyUserRoleChecker, MyRolePolicies2, MyResourceActions)
      %w[Create Read Update Delete].each do |action|
        App.all.each do |app|
          expect(ability.can?(action, app)).to be_truthy
        end
      end
    end

    it 'works with reader (with proc conditions)' do
      ability = MyAbility.new
      ability.adjust(:b, MyUserRoleChecker, MyRolePolicies2, MyResourceActions)
      %w[Read].each do |action|
        App.all.each do |app|
          expect(ability.can?(action, app)).to be_truthy
        end
      end
      %w[Create Update Delete].each do |action|
        App.all.each do |app|
          expect(ability.can?(action, app)).to be_falsey
        end
      end
    end

    it 'should deny unknown action' do
      ability = MyAbility.new
      expect do
        ability.adjust(:a, MyUserRoleChecker, MyRolePolicies3,
                       MyResourceActions)
      end.to raise_error(RuntimeError)
    end
  end
end
