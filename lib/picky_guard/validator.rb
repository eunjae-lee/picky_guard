# frozen_string_literal: true

require 'picky_guard/statement'
require 'picky_guard/policy'

module PickyGuard
  class Validator
    def self.valid_resource_class?(resource)
      child_and_parent?(resource, ActiveRecord::Base)
    end

    def self.valid_role?(role)
      role.is_a?(Symbol) || role.is_a?(String)
    end

    def self.valid_statement?(statement)
      statement.is_a? PickyGuard::Statement
    end

    def self.valid_action?(action)
      action.is_a?(Symbol) || action.is_a?(String)
    end

    def self.all_valid_actions?(actions)
      return false unless actions.is_a? Array
      actions.all? do |action|
        valid_action?(action)
      end
    end

    def self.valid_policy?(policy)
      child_and_parent?(policy, PickyGuard::Policy)
    end

    def self.all_valid_policy_classes?(policies)
      return false unless policies.is_a? Array
      policies.all? do |policy|
        valid_policy?(policy)
      end
    end

    def self.valid_conditions?(conditions)
      conditions.instance_of?(Hash) || conditions.instance_of?(Proc)
    end

    def self.child_and_parent?(child_class, parent_class)
      child_class < parent_class
    end

    def self.valid_effect?(effect)
      PickyGuard::Statement::EFFECTS.include? effect
    end

    def self.validate_statement!(statement)
      raise ArgumentError, 'Invalid Statement' unless Validator.valid_statement?(statement)
      statement
    end

    def self.validate_resource_class!(resource)
      raise ArgumentError, 'Invalid Resource' unless Validator.valid_resource_class?(resource)
      resource
    end

    def self.validate_all_actions!(actions)
      raise ArgumentError, 'Invalid actions' unless Validator.all_valid_actions?(actions)
      actions
    end

    def self.validate_all_policy_classes!(policies)
      raise ArgumentError, 'Invalid policies' unless Validator.all_valid_policy_classes?(policies)
      policies
    end

    def self.validate_role!(role)
      raise ArgumentError, 'Invalid roles' unless Validator.valid_role?(role)
      role
    end

    def self.validate_conditions!(conditions)
      raise ArgumentError, 'Invalid conditions' unless Validator.valid_conditions?(conditions)
      conditions
    end

    def self.validate_effect!(effect)
      raise ArgumentError, 'Invalid effect' unless Validator.valid_effect?(effect)
      effect
    end
  end
end
