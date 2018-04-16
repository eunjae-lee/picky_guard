# frozen_string_literal: true

module PickyGuard
  class PathHelper
    def self.user_project_path
      Dir.pwd
    end

    def self.lib_path
      File.expand_path(File.join(project_root, 'lib'))
    end

    def self.project_root
      File.expand_path(File.join(File.dirname(__FILE__), '../..'))
    end
  end
end
