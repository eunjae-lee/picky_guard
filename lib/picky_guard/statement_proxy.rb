# frozen_string_literal: true

require 'picky_guard/statement'

module PickyGuard
  class StatementProxy
    def initialize(resource)
      @resource = resource
      allow
      instance_resource
    end

    def allow
      @effect = PickyGuard::Statement::EFFECT_ALLOW
    end

    def deny
      @effect = PickyGuard::Statement::EFFECT_DENY
    end

    # rubocop:disable Style/TrivialAccessors
    def actions(actions)
      @actions = actions
    end

    def conditions(conditions)
      @conditions = conditions
    end
    # rubocop:enable Style/TrivialAccessors

    def instance_resource
      @resource_type = PickyGuard::Statement::RESOURCE_TYPE_INSTANCE
    end

    def class_resource
      @resource_type = PickyGuard::Statement::RESOURCE_TYPE_CLASS
    end

    def validate!
      Validator.validate_effect!(@effect)
      Validator.validate_all_actions!(@actions)
      Validator.validate_resource_class!(@resource)
      Validator.validate_conditions!(@conditions) if instance_resource?
    end

    def build
      validate!
      build_statement
    end

    private

    def build_statement
      PickyGuard::Statement.new(@effect, @actions, @resource, conditions_or_nil)
    end

    def conditions_or_nil
      @conditions if instance_resource?
    end

    def instance_resource?
      @resource_type == PickyGuard::Statement::RESOURCE_TYPE_INSTANCE
    end
  end
end
