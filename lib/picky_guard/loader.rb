# frozen_string_literal: true

require 'cancancan'

module PickyGuard
  class Loader
    include CanCan::Ability

    def initialize(_user, *resources_whitelist)
      @resources_whitelist = resources_whitelist
    end

    def adjust(user, user_role_checker_class, resource_actions_class, role_policies_class)
      validate_parameters(user_role_checker_class, resource_actions_class, role_policies_class)
      policies = gather_policies(user, user_role_checker_class, role_policies_class.new)
      statements = gather_statements(user, policies, resource_actions_class.new)
      adjust_statements(statements)
    end

    def can(_action = nil, _subject = nil, _conditions = nil, &_block)
      raise 'You cannot use `can` method directly with PickyGuard.'
    end

    def cannot(_action = nil, _subject = nil, _conditions = nil, &_block)
      raise 'You cannot use `cannot` method directly with PickyGuard.'
    end

    private

    def validate_parameters(user_role_checker_class, resource_actions_class, role_policies_class)
      raise ArgumentError unless user_role_checker_class < PickyGuard::UserRoleChecker
      raise ArgumentError unless role_policies_class < PickyGuard::RolePolicies
      raise ArgumentError unless resource_actions_class < PickyGuard::ResourceActions
    end

    def adjust_statements(statements)
      statements.each do |statement|
        adjust_statement(statement)
      end
    end

    def adjust_statement(statement)
      statement.actions.each do |action|
        rule = build_rule(action, statement)
        add_rule(rule)
      end
    end

    def build_rule(action, statement)
      conditions = eval_conditions_if_needed(statement)
      CanCan::Rule.new(positive?(statement.effect), action, statement.resource, conditions, nil)
    end

    def eval_conditions_if_needed(statement)
      if statement.conditions.is_a? Proc
        statement.conditions.call
      else
        statement.conditions
      end
    end

    def positive?(effect)
      effect == Statement::EFFECT_ALLOW
    end

    def gather_policies(user, user_role_checker_class, role_policies)
      role_policies.roles
                   .select { |role| user_role_checker_class.check(user, role) }
                   .map { |role| role_policies.policies_for(role) }
                   .flatten
    end

    def gather_statements(user, policies, resource_actions)
      policies.map { |policy_class| policy_class.new(user) }
              .map do |policy|
                statements = policy.statements(@resources_whitelist)
                validate_statements!(resource_actions, statements)
              end.flatten
    end

    def validate_statements!(resource_actions, statements)
      statements.each do |statement|
        validate_statement!(resource_actions, statement)
      end
      statements
    end

    def validate_statement!(resource_actions, statement)
      statement.actions.each do |action|
        valid = resource_actions.action_exist?(statement.resource, action)
        raise 'Unknown action!' unless valid
      end
      statement
    end
  end
end
