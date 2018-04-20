# frozen_string_literal: true

#
# statement_for Campaign do
#   allow
#   actions %w[Read]
#   class_resource
# end
#
# statement_for Campaign do
#   allow
#   actions %w[Create]
#   instance_resource
#   conditions {}
# end
#
# statement_for Campaign do
#   allow
#   actions %w[Create]
#   instance_resource
#   conditions proc {
#     ids = make_ids_somehow
#     return { id: ids }
#   }
# end

require 'picky_guard/statement_proxy'

class App < ActiveRecord::Base
end

class Campaign < ActiveRecord::Base
end

module PickyGuard
  describe StatementProxy do
    it 'works with class_resource' do
      expect do
        proxy = StatementProxy.new(Campaign)
        proxy.allow
        proxy.actions(%w[Read])
        proxy.class_resource
        proxy.validate!
      end.not_to raise_error
    end

    it 'works without allow' do
      expect do
        proxy = StatementProxy.new(Campaign)
        proxy.actions(%w[Read])
        proxy.class_resource
        proxy.validate!
      end.not_to raise_error
    end

    it 'works with instance_resource' do
      expect do
        proxy = StatementProxy.new(App)
        proxy.actions(%w[Read])
        proxy.instance_resource
        proxy.conditions status1: 1
        proxy.validate!
      end.not_to raise_error
    end

    it 'works with proc condition' do
      expect do
        proxy = StatementProxy.new(App)
        proxy.actions(%w[Read])
        proxy.instance_resource
        proxy.conditions(proc {
          # do something...
          { status1: 1 }
        })
        proxy.validate!
      end.not_to raise_error
    end
  end
end
