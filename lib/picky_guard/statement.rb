# frozen_string_literal: true

require 'picky_guard/validator'

module PickyGuard
  class Statement
    attr_reader :effect, :actions, :resource, :conditions

    EFFECT_ALLOW = :allow
    EFFECT_DENY = :deny
    EFFECTS = [EFFECT_ALLOW, EFFECT_DENY].freeze

    RESOURCE_TYPE_INSTANCE = :instance
    RESOURCE_TYPE_CLASS = :class

    def initialize(effect, actions, resource, conditions)
      @effect = effect
      @actions = actions
      @resource = resource
      @conditions = conditions
    end

    def allow?
      @effect == EFFECT_ALLOW
    end

    def deny?
      @effect == EFFECT_DENY
    end
  end
end
