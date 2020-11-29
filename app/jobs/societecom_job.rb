class SocietecomJob < ApplicationJob
  queue_as :default

  def perform(competitor_id)
    competitor = Competitor.find(competitor_id)
    browser = Ferrum::Browser.new(timeout: 120)
    url = "https://www.societe.com/societe/#{competitor.brand_name}-#{competitor.siren}.html"
    browser.goto(url)
    html_doc = Nokogiri::HTML(browser.body)
    # retrieve the summary of the company
    element = html_doc.search('/html/body/div[2]/div[12]/div[1]/div/section/div[1]/div[2]').text
    competitor.summary = element.gsub("\n", "")
    # retrieve the name of the CEO
    element = html_doc.search('/html/body/div[2]/div[12]/div[1]/div/section/div[3]/div/div[1]/div[1]/table[1]/tbody/tr/td[2]/a').text
    competitor.ceo = element.gsub("\t", "").gsub("\n", "")
    # retrieve the equity
    element = html_doc.search('/html/body/div[2]/div[12]/div[1]/div/section/div[2]/table[1]/tbody/tr[14]/td/div/div[1]/div[3]').text
    competitor.equity = element.gsub("\n", "")
    competitor.save
    competitor.reload
    LogoJob.perform_later(competitor.id)
  end
end
