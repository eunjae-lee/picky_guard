# frozen_string_literal: true

require 'picky_guard/policy'

class ManageAllReports < PickyGuard::Policy
  def initialize(current_user)
    # add_statement(
    #   PickyGuard::Statement.allow(
    #       %w(Create Read Update Delete),
    #       Report,
    #       { company: current_user.company }
    #   )
    # )
  end
end
