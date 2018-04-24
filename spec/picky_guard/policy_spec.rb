# frozen_string_literal: true

require 'picky_guard/policy'
require 'picky_guard/validator'

class App < ActiveRecord::Base
end

class PolicyA < PickyGuard::Policy
  def initialize(_current_user)
    statement_for App do
      actions %w[]
      conditions status1: 2
    end
  end
end

module PickyGuard
  describe Policy do
    before(:all) do
      @current_user = OpenStruct.new
    end

    it 'contains statements' do
      policy = Policy.new(@current_user)
      policy.statement_for App do
        actions %w[]
        conditions({})
      end
      expect(policy.send(:statements, []).size).to eq(1)

      policy.statement_for App do
        actions %w[]
        conditions({})
      end
      expect(policy.send(:statements, []).size).to eq(2)
    end

    it 'passes validator' do
      expect(Validator.valid_policy?(PolicyA)).to be_truthy
    end
  end
end
