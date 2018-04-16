# frozen_string_literal: true

require 'picky_guard/validator'

module PickyGuard
  class Policy
    def initialize(current_user); end

    def add_statement(statement)
      Validator.validate_statement!(statement)
      (@statements ||= []) << statement
    end
  end
end
