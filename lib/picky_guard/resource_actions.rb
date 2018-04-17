# frozen_string_literal: true

require 'picky_guard/validator'

module PickyGuard
  class ResourceActions
    def map(resource, actions)
      validate_parameters(actions, resource)
      safe_hash[resource] = actions
    end

    def action_exist?(resource, action)
      raise 'Unknown resource!' if safe_hash[resource].nil?
      safe_hash[resource].include? action
    end

    private

    def safe_hash
      (@map ||= {})
    end

    def validate_parameters(actions, resource)
      Validator.validate_resource_class!(resource)
      Validator.validate_all_actions!(actions)
    end
  end
end
