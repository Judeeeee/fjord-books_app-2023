class MentionsController < ApplicationController
  def create
    @mention = current_user.reports.new(report_params)
    @mention.save
  end

  def destroy
  end
end
