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
    id_scraping

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

  def id_scraping
    browser = Ferrum::Browser.new(timeout: 120)
    url = "https://www.infogreffe.com/entreprise-societe/#{@competitor.siren}"
    browser.goto(url)
    html_doc = Nokogiri::HTML(browser.body)
    html_doc.search('//*[@id="identification"]/h1').each do |element|
      @competitor.brand_name = element.text.split(" ").first
    end
    html_doc.search('//*[@id="showHideContent"]/div[1]/div[2]/table/tbody/tr/td[1]/div[1]').each do |element|
      @competitor.address = element.text
    end
    html_doc.search('//*[@id="showHideContent"]/div[1]/div[2]/table/tbody/tr/td[2]/div[1]/p[1]').each do |element|
      @competitor.naf = element.text
    end
    key_figures = []
    i = 0
    html_doc.search('//*[@id="chiffresCles"]/tbody/tr').each do |row|
      year = []
      row.search('td').each do |column|
        year << column.text
      end
      key_figures << {
        close: year[0],
        turnover: year[1],
        profit: year[2],
        workforce: year[3]
      }
      i += 1
    end
    @competitor.siret = key_figures

  end
end
