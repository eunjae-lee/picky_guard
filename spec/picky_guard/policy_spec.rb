# frozen_string_literal: true

require 'picky_guard/policy'
require 'picky_guard/validator'

class App < ActiveRecord::Base
end

class PolicyA < PickyGuard::Policy
  def initialize(current_user)
    PickyGuard::StatementBuilder.new
                                .allow
                                .actions(%w[])
                                .resource(App)
                                .conditions(status1: 2)
                                .build_and_add_to(self)
  end
end

module PickyGuard
  describe Policy do
    before(:all) do
      @current_user = OpenStruct.new
    end

    it 'contains statements' do
      policy = Policy.new(@current_user)
      PickyGuard::StatementBuilder.new
                                  .allow
                                  .actions(%w[])
                                  .resource(App)
                                  .conditions({})
                                  .build_and_add_to(policy)
      expect(policy.instance_variable_get(:@statements).size).to eq(1)

      PickyGuard::StatementBuilder.new
                                  .allow
                                  .actions(%w[])
                                  .resource(App)
                                  .conditions({})
                                  .build_and_add_to(policy)
      expect(policy.instance_variable_get(:@statements).size).to eq(2)
    end

    it 'passes validator' do
      expect(Validator.valid_policy?(PolicyA)).to be_truthy
    end
  end
end
