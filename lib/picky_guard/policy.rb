# frozen_string_literal: true

require 'picky_guard/validator'

module PickyGuard
  class Policy
    def initialize(current_user)
      # do nothing here
    end

    def register(resource, statement_or_proc)
      safe_array << [resource, statement_or_proc]
      @cached_statements = nil
    end

    def statements
      @cached_statements ||= gather_statements
    end

    private

    def gather_statements
      safe_array.map do |resource, statement_or_proc|
        statement = get_statement(statement_or_proc)
        Validator.validate_statement!(statement)
      end
    end

    def get_statement(statement_or_proc)
      if statement_or_proc.is_a? Proc
        statement_or_proc.call
      else
        statement_or_proc
      end
    end

    def safe_array
      (@statement_or_procs ||= [])
    end
  end
end
