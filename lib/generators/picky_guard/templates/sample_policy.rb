# frozen_string_literal: true

require 'picky_guard/policy'

class ManageAllReports < PickyGuard::Policy
  def initialize(current_user)
    # add_statement(
    #   PickyGuard::Statement.allow(
    #       %w(Create Read Update Delete),
    #       Report,
    #       proc { Report.where(company: current_user.company) }
    #   )
    # )
  end
end
