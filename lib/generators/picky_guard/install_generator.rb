# frozen_string_literal: true

module PickyGuard
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      # rubocop:disable Metrics/LineLength
      def generate_install
        copy_file 'ability.rb', 'app/models/ability.rb'
        copy_file 'role_policies.rb', 'app/picky_guard/role_policies.rb'
        copy_file 'resource_actions.rb', 'app/picky_guard/resource_actions.rb'
        copy_file 'user_role_checker.rb', 'app/picky_guard/user_role_checker.rb'
      end
      # rubocop:enable Metrics/LineLength
    end
  end
end
