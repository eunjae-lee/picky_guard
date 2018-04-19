# frozen_string_literal: true

require 'picky_guard/statement_builder'

class App < ActiveRecord::Base
end

module PickyGuard
  describe StatementBuilder do
    it 'checks validation with instance resource' do
      expect do
        PickyGuard::StatementBuilder.new
                                    .allow
                                    .actions([])
                                    .resource(App)
                                    .conditions({})
                                    .validate!
      end.not_to raise_error
    end

    it 'checks validation with class resource' do
      expect do
        PickyGuard::StatementBuilder.new
                                    .allow
                                    .actions([])
                                    .class_resource(App)
                                    .validate!
      end.not_to raise_error
    end

    it 'gives error when both instance and class resources are given' do
      expect do
        PickyGuard::StatementBuilder.new
                                    .allow
                                    .actions([])
                                    .resource(App)
                                    .conditions({})
                                    .class_resource(App)
                                    .validate!
      end.to raise_error(ArgumentError)
    end

    it 'gives error when effect is missing' do
      expect do
        PickyGuard::StatementBuilder.new
                                    .actions([])
                                    .resource(App)
                                    .conditions({})
                                    .validate!
      end.to raise_error(ArgumentError)
    end

    it 'gives error when actions are missing' do
      expect do
        PickyGuard::StatementBuilder.new
                                    .deny
                                    .resource(App)
                                    .conditions({})
                                    .validate!
      end.to raise_error(ArgumentError)
    end

    it 'gives error when resource is missing' do
      expect do
        PickyGuard::StatementBuilder.new
                                    .deny
                                    .actions([])
                                    .conditions({})
                                    .validate!
      end.to raise_error(ArgumentError)
    end

    it 'gives error when conditions are missing' do
      expect do
        PickyGuard::StatementBuilder.new
                                    .deny
                                    .actions([])
                                    .resource(App)
                                    .validate!
      end.to raise_error(ArgumentError)
    end

    it 'gives error when both resource and class_resource are missing' do
      expect do
        PickyGuard::StatementBuilder.new
                                    .deny
                                    .actions([])
                                    .conditions({})
                                    .validate!
      end.to raise_error(ArgumentError)
    end

    it 'gives error when all of resource and class_resource and conditions are missing' do
      expect do
        PickyGuard::StatementBuilder.new
                                    .deny
                                    .actions([])
                                    .validate!
      end.to raise_error(ArgumentError)
    end
  end
end
