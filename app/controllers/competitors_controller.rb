class CompetitorsController < ApplicationController
  def index
    @competitors = Competitor.all
  end

  def show
    @competitor = Competitor.find(params[:id])
  end

  def 
end
