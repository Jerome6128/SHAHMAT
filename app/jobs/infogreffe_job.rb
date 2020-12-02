class InfogreffeJob < ApplicationJob
  queue_as :default

  def perform(competitor_id)
    competitor = Competitor.find(competitor_id)
    browser = Ferrum::Browser.new(timeout: 60)
    url = "https://www.infogreffe.com/entreprise-societe/#{competitor.siren}"
    browser.goto(url)
    html_doc = Nokogiri::HTML(browser.body)
    browser.quit
    # retrieve the name of the company
    element = html_doc.search('//*[@id="identification"]/h1').text.split(" ")
    competitor.brand_name = element.take(element.index("Partager")).join(" ")
    # retrieve the address of the company
    element = html_doc.search('//*[@id="showHideContent"]/div[1]/div[2]/table/tbody/tr/td[1]/div[1]').text.split(" ")
    competitor.address = element.drop(element.index("-") + 1).join(" ")
    # retrieve the SIRET code of the company
    competitor.siret = html_doc.search('//*[@id="showHideContent"]/div[1]/div[2]/table/tbody/tr/td[1]/div[2]/text()').text
    # retrieve the naf code of the company
    competitor.naf = html_doc.search('//*[@id="showHideContent"]/div[1]/div[2]/table/tbody/tr/td[2]/div[1]/p[1]').text
    # retrieve the rcs code of the company
    competitor.rcs = html_doc.search('/html/body/div[3]/div/div/div[1]/div[1]/div[2]/div/div/div/div[2]/div/div/div/div[3]/div/div[1]/div[2]/table/tbody/tr/td[2]/div[2]/div[1]/p/text()').text
    # retrieve the trading name of the company
    competitor.trading_name = html_doc.search('/html/body/div[3]/div/div/div[1]/div[1]/div[2]/div/div/div/div[2]/div/div/div/div[3]/div/div[1]/div[2]/table/tbody/tr/td[1]/div[4]/text()').text.strip
    competitor.trading_name = competitor.brand_name if competitor.trading_name == "null"
    # retrieve the legal form of the company
    competitor.legal_form = html_doc.search('/html/body/div[3]/div/div/div[1]/div[1]/div[2]/div/div/div/div[2]/div/div/div/div[3]/div/div[1]/div[2]/table/tbody/tr/td[1]/div[7]/p').text
    # retrieve the key figures of the company
    html_doc.search('//*[@id="chiffresCles"]/tbody/tr').each do |row|
      year = []
      row.search('td').each do |column|
        year << column.text
      end
      key_figure = KeyFigure.new({
        close: year[0],
        turnover: year[1],
        profit: year[2],
        workforce: year[3]
        })
      key_figure.competitor = competitor
      key_figure.save
    end
    competitor.save
    CompetitorChannel.broadcast_to(
      competitor,
      { html: ApplicationController.renderer.render(partial: "competitors/id_card", locals: { competitor: competitor, visible: true }), trading_name: competitor.trading_name }
    )
    competitor.reload
    SocietecomJob.perform_later(competitor.id)
  end
end
