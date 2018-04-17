# frozen_string_literal: true

require 'cancancan'

module PickyGuard
  class Loader
    include CanCan::Ability

    def adjust(user, user_role_checker_class, role_policies_class, resource_actions_class)
      role_policies = role_policies_class.new

      policies = filter_policies(user, user_role_checker_class, role_policies)
      adjust_policies(user, policies)
    end

    private

    def adjust_policies(user, policies)
      policies.each do |policy|
        adjust_policy(user, policy)
      end
    end

    def adjust_policy(user, policy_class)
      policy_class.new(user).statements.each do |statement|
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
      if conditions.is_a? Proc
        CanCan::Rule.new(positive?(effect), action, conditions.call, nil, nil)
      else
        CanCan::Rule.new(positive?(effect), action, resource, conditions, nil)
      end
    end

    def positive?(effect)
      effect == Statement::EFFECT_ALLOW
    end

    def filter_policies(user, user_role_checker_class, role_policies)
      role_policies
        .roles
        .select { |role| user_role_checker_class.check(user, role) }
        .map { |role| role_policies.policies_for(role) }
        .flatten
    end
  end
end
