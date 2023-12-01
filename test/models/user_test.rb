# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'ユーザーの名前が登録されていない場合は、emailアドレスが期待される' do
    user = users(:no_name_user)
    assert_equal user.email, user.name_or_email
  end

  test 'ユーザーの名前が登録されている場合は、名前がある場合は名前が期待される' do
    user = users(:have_name_user)
    assert_equal user.name, user.name_or_email
  end
end
