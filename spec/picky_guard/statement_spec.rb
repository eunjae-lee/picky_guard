# frozen_string_literal: true

require 'active_record'
require 'picky_guard/statement'

class App < ActiveRecord::Base
end

class App2
end

module PickyGuard
  describe Statement do
    it 'accept three parameters at `allow`' do
      Statement.allow(%w[Create Read Update], App, {})
    end

    it 'only accepts an array as 1st parameter' do
      expect do
        Statement.allow('', App, {})
      end.to raise_error(ArgumentError)

      expect do
        Statement.allow([], App, {})
      end.not_to raise_error
    end

    it 'only accepts an activerecord as 2nd parameter' do
      expect do
        Statement.allow([], App2, {})
      end.to raise_error(ArgumentError)

      expect do
        Statement.allow([], App, {})
      end.not_to raise_error
    end

    it 'only accepts hash as 3rd parameter' do
      expect do
        Statement.allow(['Create'], App, App.where(status1: 1))
      end.to raise_error(ArgumentError)

      expect do
        Statement.allow(['Create'], App, status1: 1)
      end.not_to raise_error
    end
  end
end
