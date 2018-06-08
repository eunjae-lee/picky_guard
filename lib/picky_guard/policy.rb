# frozen_string_literal: true

require 'picky_guard/validator'
require 'picky_guard/statement_proxy'

module PickyGuard
  class Policy
    def initialize(current_user)
      # do nothing here
    end

    def statements(resource_whitelist)
      filtered_array(resource_whitelist).map do |_resource, statement|
        Validator.validate_statement!(statement)
      end
    end

    def statement_for(resource, &statement_definition)
      proxy = StatementProxy.new(resource)
      proxy.instance_eval(&statement_definition)
      register(resource, proxy.build)
    end

    private

    def register(resource, statement)
      safe_array << [resource, statement]
    end

    def filtered_array(resource_whitelist)
      return safe_array if resource_whitelist.nil? || resource_whitelist.empty?

      safe_array.select { |item| resource_whitelist.include? item[0] }
    end

    def safe_array
      (@safe_array ||= [])
    end
  end
end
