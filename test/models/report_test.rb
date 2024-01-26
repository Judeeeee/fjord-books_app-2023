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
    my_report = reports(:my_report)
    expect_date = Date.new(2023, 11, 29)
    assert_equal expect_date, my_report.created_on
  end

  test '本文に他日報のリンクがある場合、言及先日報に言及元日報リンクが表示される' do
    link_included_report = Report.create!(user_id: 3, title: 'include other report link', content: 'http://localhost:3000/reports/1')
    expect = 1
    assert_equal expect, link_included_report.mentioning_report_ids[0]
  end

  test '言及元日報が削除された場合、言及先日報から言及元日報リンクが消される' do
    my_report = reports(:my_report)
    link_included_report = Report.create!(user_id: 3, title: 'include other report link', content: "http://localhost:3000/reports/#{my_report.id}")
    link_included_report.destroy
    expect = []
    assert_equal expect, my_report.mentioned_report_ids
  end
end
