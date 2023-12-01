# frozen_string_literal: true

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  test '自分が書いた日報なら、日報を編集・削除できる' do
    my_user = users(:my_user)
    my_report =  reports(:my_report)
    assert my_report.editable?(my_user)
  end

  test '自分以外が書いた日報は、編集・削除できない' do
    my_user = users(:my_user)
    other_report = reports(:other_report)
    assert_not other_report.editable?(my_user)
  end

  test '作成日時のフォーマットを変更する' do
    #   my_user = users(:my_user)
    my_report = reports(:my_report)
    expect_date = Date.new(2023, 11, 29)
    assert_equal expect_date, my_report.created_on
  end
end
