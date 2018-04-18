# frozen_string_literal: true

require 'picky_guard/resource_actions'

class ResourceActions < PickyGuard::ResourceActions
  def initialize
    # map(Report, %w[Create Read Update Delete])

    # [App, Campaign].each do |resource|
    #   map(resource, %w[Create Read Update])
    # end
  end
end
