# frozen_string_literal: true

require 'picky_guard/role_policies'
require 'picky_guard/policy'

class PolicyA < PickyGuard::Policy
end

class PolicyB < PickyGuard::Policy
end

module PickyGuard
  describe RolePolicies do
    it 'maps role and policies' do
      class MyRolePolicies < PickyGuard::RolePolicies
        def initialize
          map(:role_a, [PolicyA, PolicyB])
          map(:role_b, [PolicyB])
        end
      end

      role_policies = MyRolePolicies.new
      expect(role_policies.instance_variable_get(:@map).keys.size).to eq(2)
    end
  end
end