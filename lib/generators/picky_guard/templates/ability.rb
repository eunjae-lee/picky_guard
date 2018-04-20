# frozen_string_literal: true

require 'picky_guard/loader'

class Ability < PickyGuard::Loader
  def initialize(user)
    adjust(user, UserRoleChecker, ResourceActions, RolePolicies)
  end
end
