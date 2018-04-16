# frozen_string_literal: true

require 'picky_guard/validator'

module PickyGuard
  class ResourceActions
    def map(resource, actions)
      Validator.validate_resource_class!(resource)
      Validator.validate_all_actions!(actions)
      (@map ||= {})[resource] = actions
    end
  end
end
