class CompetitorsController < ApplicationController
  def index
    @competitors = Competitor.all
    @user = User.new
  end

  def show
    @competitor = Competitor.find(params[:id])
  end
 
end
