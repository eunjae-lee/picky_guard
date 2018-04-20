# frozen_string_literal: true

require 'picky_guard/validator'

module PickyGuard
  class Policy
    def initialize(current_user)
      # do nothing here
    end

    def register(resource, proc)
      safe_procs << [resource, proc]
      @cached_statements = nil
    end

    def statements
      @cached_statements ||= gather_statements
    end

    private

    def gather_statements
      safe_procs.map do |resource, proc|
        Validator.validate_statement!(proc.call)
      end
    end

    def safe_procs
      (@procs_of_statements ||= [])
    end
  end
end
