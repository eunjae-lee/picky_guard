# frozen_string_literal: true

require 'picky_guard/loader'
require 'picky_guard/role_policies'
require 'picky_guard/user_role_checker'
require 'picky_guard/resource_actions'
require 'picky_guard/policy'
require_relative './classes_for_loader_spec'

module PickyGuard
  describe Loader do
    before(:each) do
      App.destroy_all
      3.times do
        App.create(status1: 1)
      end

      Campaign.destroy_all
      4.times do
        Campaign.create
      end
    end

    it 'works with manager' do
      ability = MyAbility.new(:a)
      ability.adjust(:a, MyUserRoleChecker, MyResourceActions, MyRolePolicies)
      %w[Create Read Update Delete].each do |action|
        App.all.each do |app|
          expect(ability.can?(action, app)).to be_truthy
        end
      end
    end

    it 'fetches records for manager' do
      ability = MyAbility.new(:a)
      ability.adjust(:a, MyUserRoleChecker, MyResourceActions, MyRolePolicies)
      expect(App.accessible_by(ability, 'Read').count).to eq(3)
    end

    it 'works with reader' do
      ability = MyAbility.new(:b)
      ability.adjust(:b, MyUserRoleChecker, MyResourceActions, MyRolePolicies)
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
      ability = MyAbility.new(:a)
      expect do
        ability.adjust(:a, MyUserRoleChecker, MyResourceActions, MyRolePolicies3)
      end.to raise_error(RuntimeError)
    end

    it 'works with values from current_user' do
      user = OpenStruct.new(val: 1)
      ability = MyAbility.new(user)
      ability.adjust(user, MyUserRoleChecker4, MyResourceActions, MyRolePolicies4)
      %w[Create Update Delete Read].each do |action|
        App.all.each do |app|
          expect(ability.can?(action, app)).to be_truthy
        end
      end
      expect(App.accessible_by(ability, 'Read').count).to eq(3)
    end

    it 'loads all resources without whitelist' do
      ability = MyAbility.new(:a)
      ability.adjust(:a, MyUserRoleChecker5, MyResourceActions, MyRolePolicies5)
      expect(App.accessible_by(ability, 'Read').count).to eq(3)
      expect(Campaign.accessible_by(ability, 'Read').count).to eq(4)
    end

    it 'does not load resources which is not on whitelist' do
      ability = MyAbility.new(:a, App)
      ability.adjust(:a, MyUserRoleChecker5, MyResourceActions, MyRolePolicies5)
      expect(App.accessible_by(ability, 'Read').count).to eq(3)
      expect(Campaign.accessible_by(ability, 'Read').count).to eq(0)
    end

    it 'does not have permission on resource class without any config' do
      ability = MyAbility.new(:a)
      ability.adjust(:a, MyUserRoleChecker6, MyResourceActions, MyRolePolicies6)
      expect(ability.can?('Create', App)).to be_falsey
      expect(ability.can?('Create', App.first)).to be_falsey
      expect(ability.can?('Create', Campaign)).to be_truthy
      expect(ability.can?('Create', Campaign.first)).to be_truthy
      expect(ability.can?('Create', Campaign.second)).to be_truthy
    end

    it 'loads apps with condition of proc' do
      ability = MyAbility.new(:a)
      ability.adjust(:a, MyUserRoleChecker7, MyResourceActions, MyRolePolicies7)
      expect(App.accessible_by(ability, 'Read').size).to eq(3)
    end
  end
end
