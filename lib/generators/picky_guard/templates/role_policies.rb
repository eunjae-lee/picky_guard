# frozen_string_literal: true

require 'picky_guard/role_policies'

class RolePolicies < PickyGuard::RolePolicies
  def initialize
    map(:role_report_manager, [ManageAllReports])
    # map(:role_report_reader, [AnotherPolicy])
  end
end
