# frozen_string_literal: true

module PickyGuard
  module Generators
    class PolicyGenerator < Rails::Generators::NamedBase
      source_root File.expand_path('../templates', __FILE__)

      desc 'Generates a policy with the given NAME'

      def generate_policy
        return unless validate_name(name)
        create_file dest_path(name), content(name)
      end

      private

      def dest_path(name)
        "app/picky_guard/#{name}.rb"
      end

      def content(name)
        class_name = class_name(name)
        puts "class_name : #{class_name}"
        path = File.join(File.expand_path('../templates', __FILE__), 'policy.rb.erb')
        ERB.new(File.read(path)).result binding
      end

      def class_name(name)
        name.split('/').last.camelize
      end

      def validate_name(name)
        return true if underscored?(name)
        puts_name_requirement(name)
      end

      def puts_name_requirement(name)
        puts ''
        puts 'Name should be underscored'
        puts "Expected : #{name.underscore}"
        puts "Actual : #{name}"
      end

      def underscored?(name)
        name.underscore == name
      end
    end
  end
end
