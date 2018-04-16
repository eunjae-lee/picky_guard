# frozen_string_literal: true

require 'picky_guard/validator'

module PickyGuard
  class RolePolicies
    def map(role, policies)
      validate_parameters(policies, role)
      (@map ||= {})[role] = policies
    end

    private

    def validate_parameters(policies, role)
      Validator.validate_all_policy_classes!(policies)
      Validator.validate_role!(role)
    end
  end
end
