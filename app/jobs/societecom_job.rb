class SocietecomJob < ApplicationJob
  queue_as :default

  def perform(competitor_id)
    competitor = Competitor.find(competitor_id)
    browser = Ferrum::Browser.new(timeout: 120)
    url = "https://www.societe.com/societe/#{competitor.brand_name}-#{competitor.siren}.html"
    browser.goto(url)
    html_doc = Nokogiri::HTML(browser.body)
    # retrieve the name of the company
    element = html_doc.search('/html/body/div[2]/div[12]/div[1]/div/section/div[1]/div[2]').text
    competitor.summary = element.gsub("\n", "")
    competitor.save
    competitor.reload
    LogoJob.perform_later(competitor.id)
  end
end
