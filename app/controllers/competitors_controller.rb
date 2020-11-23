class CompetitorsController < ApplicationController
  def index
    @competitors = Competitor.all
  end

  def show
    @competitor = Competitor.find(params[:id])
  end

  def new
    @competitor = Competitor.new
  end

  def create
    @competitor = Competitor.new(competitor_params)
    @competitor.user = current_user
    if @competitor.save
      redirect_to competitor_path(@competitor)
    else
      render 'new'
    end
  end

  private

  def competitor_params
    params.require(:competitor).permit(:siren)
  end
end
