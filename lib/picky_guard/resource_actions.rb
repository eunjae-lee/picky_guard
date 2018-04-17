# frozen_string_literal: true

require 'picky_guard/validator'

module PickyGuard
  class ResourceActions
    def map(resource, actions)
      validate_parameters(actions, resource)
      (@map ||= {})[resource] = actions
    end

    private

    def validate_parameters(actions, resource)
      Validator.validate_resource_class!(resource)
      Validator.validate_all_actions!(actions)
    end
  end
end
