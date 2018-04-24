# frozen_string_literal: true

require 'picky_guard/user_role_checker'

module PickyGuard
  describe UserRoleChecker do
    it 'raises when not overriding it' do
      expect do
        UserRoleChecker.check(nil, nil)
      end.to raise_error(RuntimeError)
    end

    it 'passes when overridden' do
      class MyUserRoleChecker < UserRoleChecker
        def self.check(_user, _role)
          true
        end
      end

      expect(MyUserRoleChecker.check(nil, nil)).to be_truthy
    end
  end
end
