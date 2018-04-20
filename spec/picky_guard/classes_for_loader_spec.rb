# frozen_string_literal: true

require 'picky_guard/loader'
require 'picky_guard/role_policies'
require 'picky_guard/user_role_checker'
require 'picky_guard/resource_actions'
require 'picky_guard/policy'
require 'picky_guard/statement_builder'

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
    register(App, proc {
      PickyGuard::StatementBuilder.new
                                  .allow
                                  .actions(%w[Create Read Update Delete])
                                  .resource(App)
                                  .conditions({})
                                  .build
    })
  end
end

class AppReadAccess < PickyGuard::Policy
  def initialize(current_user)
    register(App, proc {
      PickyGuard::StatementBuilder.new
                                  .allow
                                  .actions(%w[Read])
                                  .resource(App)
                                  .conditions({})
                                  .build
    })
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
    register(App, proc {
      PickyGuard::StatementBuilder.new
                                  .allow
                                  .actions(%w[Create Read Update Delete])
                                  .resource(App)
                                  .conditions({})
                                  .build
    })
  end
end

class AppReadAccess2 < PickyGuard::Policy
  def initialize(current_user)
    register(App, proc {
      PickyGuard::StatementBuilder.new
                                  .allow
                                  .actions(%w[Read])
                                  .resource(App)
                                  .conditions({})
                                  .build
    })
  end
end

class MyRolePolicies3 < PickyGuard::RolePolicies
  def initialize
    map(:role_manager, [AppFullAccess3])
  end
end

class AppFullAccess3 < PickyGuard::Policy
  def initialize(current_user)
    register(App, proc {
      PickyGuard::StatementBuilder.new
                                  .allow
                                  .actions(%w[Create Read Update Delete UnknownWeirdAction])
                                  .resource(App)
                                  .conditions({})
                                  .build
    })
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
    register(App, proc {
      PickyGuard::StatementBuilder.new
                                  .allow
                                  .actions(%w[Create Read Update Delete])
                                  .resource(App)
                                  .conditions(status1: current_user.val)
                                  .build
    })
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
    register(App, proc {
      PickyGuard::StatementBuilder.new
                                  .allow
                                  .actions(%w[Create Read Update Delete])
                                  .resource(App)
                                  .conditions({})
                                  .build
    })

    register(App, proc {
      PickyGuard::StatementBuilder.new
                                  .allow
                                  .actions(%w[Create Read Update Delete])
                                  .resource(Campaign)
                                  .conditions({})
                                  .build
    })
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
    register(App, PickyGuard::StatementBuilder.new
                                              .allow
                                              .actions(%w[Read])
                                              .class_resource(App)
                                              .build)

    register(App, proc {
      PickyGuard::StatementBuilder.new
                                  .allow
                                  .actions(%w[Create])
                                  .class_resource(Campaign)
                                  .build
    })
  end
end
