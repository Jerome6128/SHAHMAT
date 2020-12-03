require_relative '../services/infogreffe_scraper_service.rb'
require_relative '../services/wttj_scraper_service.rb'
class CompetitorsController < ApplicationController
  def index
    # @competitors = Competitor.all
    # @user = User.new
    @company = current_user.company

    if params[:query].present?
      sql_query = " \
        competitors.trading_name @@ :query \
        OR competitors.siren @@ :query \
      "
      @competitors = Competitor.where(sql_query, query: "%#{params[:query]}%")
      @competitors = @competitors.where(company: current_user.company)
    else
      @competitors = Competitor.all
      @competitors = @competitors.where(company: current_user.company)
    end
  end

  def show
    @competitor = Competitor.find(params[:id])
    @message = Message.new
  end

  def new
    @competitor = Competitor.new
    @competitor.siren = nil
  end

  def create
    @competitor = Competitor.new(competitor_params)
    @competitor.siren = @competitor.siren.gsub(" ", "")
    @competitor.company = current_user.company
    if @competitor.save
      flash[:notice] = "Collecting information..."
      InfogreffeJob.perform_later(@competitor.id)
      redirect_to competitor_path(@competitor, section: "ID")
    else
      render 'new'
    end
  end

  def update

  end

  private

  def competitor_params
    params.require(:competitor).permit(:siren)
  end
end
