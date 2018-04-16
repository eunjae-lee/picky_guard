# frozen_string_literal: true

require 'picky_guard/policy'
require 'picky_guard/validator'

class App < ActiveRecord::Base
end

class PolicyA < PickyGuard::Policy
  def initialize(current_user)
    add_statement(
      PickyGuard::Statement.allow(
        %w[Create Read Update],
        App,
        proc { App.where(status1: 2) }
      )
    )
  end
end

module PickyGuard
  describe Policy do
    before(:all) do
      @current_user = OpenStruct.new
    end

    it 'contains statements' do
      policy = Policy.new(@current_user)
      statement1 = Statement.allow([], App, {})
      policy.add_statement(statement1)
      expect(policy.instance_variable_get(:@statements).size).to eq(1)

      statement2 = Statement.allow([], App, {})
      policy.add_statement(statement2)
      expect(policy.instance_variable_get(:@statements).size).to eq(2)
    end

    it 'contains statements - class style' do
      policy = PolicyA.new(@current_user)
      expect(policy.instance_variable_get(:@statements).size).to eq(1)
    end

    it 'passes validator' do
      expect(Validator.valid_policy?(PolicyA)).to be_truthy
    end
  end
end
