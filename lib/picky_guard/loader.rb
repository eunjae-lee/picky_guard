# frozen_string_literal: true

require 'cancancan'

module PickyGuard
  class Loader
    include CanCan::Ability

    def adjust(user, user_role_checker_class, role_policies_class, resource_actions_class)
      validate_parameters(user_role_checker_class, role_policies_class, resource_actions_class)
      policies = gather_policies(user, user_role_checker_class, role_policies_class.new)
      statements = gather_statements(user, policies, resource_actions_class.new)
      adjust_statements(statements)
    end

    private

    def validate_parameters(user_role_checker_class, role_policies_class, resource_actions_class)
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
        rule = build_rule(action, statement.effect, statement.conditions,
                          statement.resource)
        add_rule(rule)
      end
    end

    def build_rule(action, effect, conditions, resource)
      CanCan::Rule.new(positive?(effect), action, resource, conditions, nil)
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
                validate_policy(policy, resource_actions)
                policy.statements
              end.flatten
    end

    def validate_policy(policy, resource_actions)
      policy.statements.each do |statement|
        validate_statement(resource_actions, statement)
      end
    end

    def validate_statement(resource_actions, statement)
      statement.actions.each do |action|
        valid = resource_actions.action_exist?(statement.resource, action)
        raise 'Unknown action!' unless valid
      end
    end
  end
end
