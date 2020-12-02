class SocietecomJob < ApplicationJob
  queue_as :default

  def perform(competitor_id)
    competitor = Competitor.find(competitor_id)
    browser = Ferrum::Browser.new(timeout: 60, headless: true, process_timeout: 60)
    url = "https://www.societe.com/societe/#{competitor.brand_name}-#{competitor.siren}.html"
    browser.goto(url)
    html_doc = Nokogiri::HTML(browser.body)
    browser.quit
    # retrieve the summary of the company
    element = html_doc.search('#synthese').text
    competitor.summary = element.gsub("\n", "")
    # retrieve the name of the CEO
    element = html_doc.search('//*[@id="dir0"]/tbody/tr/td[2]/a').text
    competitor.ceo = element.gsub("\t", "").gsub("\n", "")
    # retrieve the equity
    element = html_doc.search('//*[@id="capital-histo-description"]').text
    competitor.equity = element.gsub("\n", "")
    CompetitorChannel.broadcast_to(
      competitor,
      {html: ApplicationController.renderer.render(partial: "competitors/id_card", locals: { competitor: competitor, visible: true }), trading_name: competitor.trading_name }
    )
    competitor.save
    competitor.reload
    LogoJob.perform_later(competitor.id)
  end
end
