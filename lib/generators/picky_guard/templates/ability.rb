# frozen_string_literal: true

# This file is auto-generated.
# If you need to add things, modify this class.
# The following will do the magic.

require 'picky_guard/loader'


class Ability < PickyGuard::Loader
  def initialize(user)
    adjust(user, UserRoleChecker, RolePolicies, ResourceActions)
  end
end
