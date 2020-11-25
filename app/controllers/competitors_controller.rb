require_relative '../services/infogreffe_scraper_service.rb'
require_relative '../services/wttj_scraper_service.rb'
class CompetitorsController < ApplicationController
  def index
    @competitors = Competitor.all
    @user = User.new

    if params[:query].present?
      sql_query = " \
        competitors.brand_name @@ :query \
        OR competitors.siren @@ :query \
      "
      @competitors = Competitor.where(sql_query, query: "%#{params[:query]}%")
    else
      @competitors = Competitor.all
    end
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
    search = InfogreffeScraperService.new(@competitor.siren)
    results = search.scrape
    @competitor.brand_name = results[:brand_name]
    @competitor.address = results[:address]
    @competitor.naf = results[:naf]
    results[:key_figures].each do |key_figure|
      @key_figure = KeyFigure.new(key_figure)
      @key_figure.competitor = @competitor
      @key_figure.save
    end
    if @competitor.save
      redirect_to competitor_path(@competitor)
    else
      render 'new'
    end
  end

  def update
    @competitor = Competitor.find(params[:id])
    @job_search = WttjScraperService.new(@competitor.brand_name)
    @jobs_result = @job_search.scrape
    @jobs_result.each do |job|
      @job_offer = JobOffer.new(job)
      @job_offer.competitor = @competitor
      @job_offer.save
    end
    raise
    redirect_to competitor_path(@competitor)
  end

  private

  def competitor_params
    params.require(:competitor).permit(:siren)
  end
end
