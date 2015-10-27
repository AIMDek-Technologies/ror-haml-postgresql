class StatementsController < ApplicationController
  before_filter :login_required
  helper_method :sort_column, :sort_direction
  include StatementsHelper

  def index
    @statements = Statement.text_search(params[:search]).order("#{sort_column} #{sort_direction}").paginate(:page => params[:page])
    respond_to do |format|
      format.js
      format.html
      format.json { render :json => @statements }
    end
  end


  # generate monthly statements
  # this is cron job, for more detail check config/initializers/scheduler.rb
  def generate_monthly_statements
    StatementsHelper::generate_statements(view_context)
  end


  private

  def sort_column
    Statement.column_names.include?(params[:sort]) ? params[:sort] : 'updated_at'
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'desc'
  end

end
