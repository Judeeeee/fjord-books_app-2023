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
        mention =  Mention.new(mentioned_report_id: @report.id, mentioning_report_id: mentioning_report)
        mention.save
      end
    end

    # # 言及先のチェック
    # # 表示してある日報がどこかから言及されていたら、言及元のリンクを表示する
    if Mention.where(mentioning_report_id: @report.id)
      @mentioned_reports = Mention.where(mentioning_report_id: @report.id)
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
    Report.delete_relationship

    if @report.update(report_params)
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
