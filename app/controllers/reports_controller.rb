# frozen_string_literal: true

class ReportsController < ApplicationController
  before_action :set_report, only: %i[edit update destroy]

  def index
    @reports = Report.includes(:user).order(id: :desc).page(params[:page])
  end

  def show
    @report = Report.find(params[:id])
    mentioning_reports = @report.mentioning

    # # 言及元のレポートのリンク存在チェック
    # # 本文にリンクがあればその組みを中間テーブルに保存する
    if mentioning_reports.any?
      mentioning_reports.each do |mentioning_report|
        mention =  Mention.new(mentioned_id: @report.id, mentioning_id: mentioning_report)
        mention.save
      end
    end

    # # 言及先のチェック
    # # 表示してある日報がどこかから言及されていたら、言及元のリンクを表示する
    if Mention.where(mentioning_id: @report.id)
      @mentioned_reports = Mention.where(mentioning_id: @report.id)
    end
  end

  # GET /reports/new
  def new
    @report = current_user.reports.new
  end

  def edit; end

  def create
    @report = current_user.reports.new(report_params)
    if @report.save
      redirect_to @report, notice: t('controllers.common.notice_create', name: Report.model_name.human)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @report.update(report_params)
      if  Mention.where(mentioned_id: @report.id).size > @report.mentioning.size
        # 中間テーブルに保存されているレコードから言及先の日報IDを取得する。
        db_ids = Mention.where(mentioned_id: @report.id).map{|mention| mention.mentioning_id}
        deletable_items = db_ids - @report.mentioning
        deletable_items.each do |deletable_item|
          foo = Mention.where(mentioned_id: @report.id, mentioning: deletable_item).first.id
          Mention.delete(foo)
        end
      end
      redirect_to @report, notice: t('controllers.common.notice_update', name: Report.model_name.human)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @report.destroy

    redirect_to reports_url, notice: t('controllers.common.notice_destroy', name: Report.model_name.human)
  end

  private

  def set_report
    @report = current_user.reports.find(params[:id])
  end

  def report_params
    params.require(:report).permit(:title, :content)
  end
end
