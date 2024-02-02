# frozen_string_literal: true

require 'application_system_test_case'

class ReportsTest < ApplicationSystemTestCase
  setup do
    @report = reports(:my_report)
    @user = users(:my_user)

    # !ログイン処理 => 日報一覧ページへの遷移は共通なので、setupに定義
    visit reports_url
    assert_selector 'h2', text: 'ログイン'
    fill_in 'Eメール', with: @user.email
    fill_in 'パスワード', with: 'password'
    click_button 'ログイン'
    click_on '日報'
  end

  test 'should create report' do
    click_on '日報の新規作成'
    assert_selector 'h1', text: '日報の新規作成'

    fill_in 'report[title]', with: '日報テスト'
    fill_in 'report[content]', with: '日報本文テスト'
    click_button '登録する'

    assert_text '日報が作成されました。'
    click_on '日報の一覧に戻る'
    assert_selector 'h1', text: '日報の一覧'
    assert_text '日報テスト'
  end

  test 'should update Report' do
    assert_text 'My Report'

    click_on 'この日報を表示', match: :first
    assert_selector 'h1', text: '日報の詳細'
    click_on 'この日報を編集'

    fill_in 'report[title]', with: 'Title Update'
    fill_in 'report[content]', with: 'Content Update'
    click_button '更新する'

    assert_text '日報が更新されました。'
    click_on '日報の一覧に戻る'
    assert_text 'Title Update'
  end

  test 'should destroy Report' do
    # 新たに日報を追加したため、日報の順序が入れ替わった。
    assert_text 'include other report link'
    click_on 'この日報を表示', match: :first
    assert_selector 'h1', text: '日報の詳細'
    click_button 'この日報を削除'
    assert_text '日報が削除されました。'
    assert_no_text 'include other report link'
  end
end
