# frozen_string_literal: true

require 'picky_guard/validator'

module PickyGuard
  class Policy
    attr_reader :statements

    def initialize(current_user)
      # do nothing here
    end

    def add_statement(statement)
      Validator.validate_statement!(statement)
      (@statements ||= []) << statement
    end
  end
end
