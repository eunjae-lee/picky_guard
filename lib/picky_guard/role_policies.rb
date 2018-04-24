# frozen_string_literal: true

require 'picky_guard/validator'

module PickyGuard
  class RolePolicies
    def map(role, policies)
      validate_parameters(policies, role)
      safe_map[role] = policies
    end

    def roles
      safe_map.keys
    end

    def policies_for(role)
      safe_map[role]
    end

    private

    def safe_map
      (@safe_map ||= {})
    end

    def validate_parameters(policies, role)
      Validator.validate_all_policy_classes!(policies)
      Validator.validate_role!(role)
    end
  end
end
