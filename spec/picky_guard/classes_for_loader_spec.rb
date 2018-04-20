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

class Campaign < ActiveRecord::Base
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
    [App, Campaign].each do |resource|
      map resource, %w[Create Read Update Delete]
    end
  end
end

class AppFullAccess < PickyGuard::Policy
  def initialize(current_user)
    statement_for App do
      actions %w[Create Read Update Delete]
      conditions({})
    end
  end
end

class AppReadAccess < PickyGuard::Policy
  def initialize(current_user)
    statement_for App do
      actions %w[Read]
      conditions({})
    end
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
    statement_for App do
      actions %w[Create Read Update Delete]
      conditions({})
    end
  end
end

class AppReadAccess2 < PickyGuard::Policy
  def initialize(current_user)
    statement_for App do
      actions %w[Read]
      conditions({})
    end
  end
end

class MyRolePolicies3 < PickyGuard::RolePolicies
  def initialize
    map(:role_manager, [AppFullAccess3])
  end
end

class AppFullAccess3 < PickyGuard::Policy
  def initialize(current_user)
    statement_for App do
      actions %w[Create Read Update Delete UnknownWeirdAction]
      conditions({})
    end
  end
end

class MyUserRoleChecker4 < PickyGuard::UserRoleChecker
  def self.check(user, role)
    true
  end
end

class MyRolePolicies4 < PickyGuard::RolePolicies
  def initialize
    map(:role_manager, [AppFullAccess4])
  end
end

class AppFullAccess4 < PickyGuard::Policy
  def initialize(current_user)
    statement_for App do
      actions %w[Create Read Update Delete]
      conditions status1: current_user.val
    end
  end
end

class MyUserRoleChecker5 < PickyGuard::UserRoleChecker
  def self.check(user, role)
    true
  end
end

class MyRolePolicies5 < PickyGuard::RolePolicies
  def initialize
    map(:role_manager, [AppFullAccess5])
  end
end

class AppFullAccess5 < PickyGuard::Policy
  def initialize(current_user)
    statement_for App do
      actions %w[Create Read Update Delete]
      conditions({})
    end

    statement_for Campaign do
      actions %w[Create Read Update Delete]
      conditions({})
    end
  end
end

class MyUserRoleChecker6 < PickyGuard::UserRoleChecker
  def self.check(user, role)
    true
  end
end

class MyRolePolicies6 < PickyGuard::RolePolicies
  def initialize
    map(:role_manager, [AppFullAccess6])
  end
end

class AppFullAccess6 < PickyGuard::Policy
  def initialize(current_user)
    statement_for App do
      actions %w[Read]
      conditions({})
    end

    statement_for Campaign do
      actions %w[Create]
      class_resource
      conditions({})
    end
  end
end

class MyUserRoleChecker7 < PickyGuard::UserRoleChecker
  def self.check(user, role)
    true
  end
end

class MyRolePolicies7 < PickyGuard::RolePolicies
  def initialize
    map(:role_manager, [AppFullAccess7])
  end
end

class AppFullAccess7 < PickyGuard::Policy
  def initialize(current_user)
    statement_for App do
      actions %w[Read]
      conditions(proc {
        { status1: 1 }
      })
    end
  end
end
