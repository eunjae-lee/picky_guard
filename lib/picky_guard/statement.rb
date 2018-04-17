# frozen_string_literal: true

require 'picky_guard/validator'

module PickyGuard
  class Statement
    attr_reader :effect, :actions, :resource, :conditions

    EFFECT_ALLOW = :allow
    EFFECT_DENY = :deny

    def initialize(effect, actions, resource, conditions)
      @effect = effect
      @actions = actions
      @resource = resource
      @conditions = conditions
    end

    def self.allow(actions, resource, conditions)
      make_statement(EFFECT_ALLOW, actions, conditions, resource)
    end

    def self.deny(actions, resource, conditions)
      make_statement(EFFECT_DENY, actions, conditions, resource)
    end

    def allow?
      @effect == EFFECT_ALLOW
    end

    def deny?
      @effect == EFFECT_DENY
    end

    def self.make_statement(effect, actions, conditions, resource)
      validate_parameters(actions, conditions, resource)
      Statement.new(effect, actions, resource, conditions)
    end

    def self.validate_parameters(actions, conditions, resource)
      Validator.validate_all_actions!(actions)
      Validator.validate_resource_class!(resource)
      Validator.validate_conditions!(conditions)
    end
  end
end
