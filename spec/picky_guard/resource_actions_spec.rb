# frozen_string_literal: true

require 'picky_guard/resource_actions'

class App < ActiveRecord::Base
end

module PickyGuard
  describe ResourceActions do
    it 'map actions to resource' do
      resource_actions = PickyGuard::ResourceActions.new
      resource_actions.map(App, ['Read'])
      map = resource_actions.instance_variable_get(:@map)
      expect(map.keys.size).to eq(1)
    end

    it 'map actions to resource in different way' do
      class MyResourceActions < PickyGuard::ResourceActions
        def initialize
          map(App, ['Read'])
        end
      end

      resource_actions = MyResourceActions.new
      map = resource_actions.instance_variable_get(:@map)
      expect(map.keys.size).to eq(1)
    end
  end
end
