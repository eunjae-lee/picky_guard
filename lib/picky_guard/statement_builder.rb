# frozen_string_literal: true

require 'picky_guard/statement'
require 'picky_guard/validator'

module PickyGuard
  class StatementBuilder
    def allow
      @effect = Statement::EFFECT_ALLOW
      self
    end

    def deny
      @effect = Statement::EFFECT_DENY
      self
    end

    def actions(actions)
      @actions = actions
      self
    end

    def resource(resource)
      @resource = resource
      self
    end

    def conditions(conditions)
      @conditions = conditions
      self
    end

    def class_resource(class_resource)
      @class_resource = class_resource
      self
    end

    def validate!
      validate_effect!
      validate_actions!
      validate_existence_of_resource_and_class_resource!
      validate_resource_and_conditions!
      validate_resource_or_class_resource!
    end

    def build
      validate!
      PickyGuard::Statement.new(@effect, @actions, _resource, _conditions, _resource_type)
    end

    def build_and_add_to(policy)
      policy.add_statement(build)
    end

    private

    def validate_resource_and_conditions!
      raise ArgumentError, 'Resource without conditions' if @resource && @conditions.nil?
      raise ArgumentError, 'Conditions without resource' if @resource.nil? && @conditions
    end

    def validate_existence_of_resource_and_class_resource!
      raise ArgumentError, 'Choose between resource and class_resource' if @resource && @class_resource
      raise ArgumentError, 'Choose between resource and class_resource' if @resource.nil? && @class_resource.nil?
    end

    def validate_actions!
      Validator.validate_all_actions!(@actions)
    end

    def validate_effect!
      Validator.validate_effect!(@effect)
    end

    def validate_resource_or_class_resource!
      if @resource
        Validator.validate_resource_class!(@resource)
        Validator.validate_conditions!(@conditions)
      else
        Validator.validate_resource_class!(@class_resource)
      end
    end

    def _resource
      if @resource
        @resource
      else
        @class_resource
      end
    end

    def _conditions
      @conditions if @resource
    end

    def _resource_type
      if @resource
        PickyGuard::Statement::RESOURCE_TYPE_INSTANCE
      else
        PickyGuard::Statement::RESOURCE_TYPE_CLASS
      end
    end
  end
end
