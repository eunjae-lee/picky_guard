# frozen_string_literal: true

require 'picky_guard/path_helper'

module PickyGuard
  describe PathHelper do
    it 'gets project_root correctly' do
      path = "#{PathHelper.project_root}/db/schema.rb"
      expect(File.exist?(path)).to be_truthy
    end

    it 'gets lib_path correctly' do
      expect(PathHelper.lib_path).to eq(PathHelper.project_root + '/lib')
    end
  end
end
