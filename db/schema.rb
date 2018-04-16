# frozen_string_literal: true

ActiveRecord::Schema.define do
  create_table 'apps', force: true do |t|
    t.integer 'status1'
    t.integer 'status2'
    t.integer 'status3'
  end
end
