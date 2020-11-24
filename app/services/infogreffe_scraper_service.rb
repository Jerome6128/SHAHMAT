class InfogreffeScraperService
  def initialize(siren)
    @siren = siren
  end

  def scrape
    browser = Ferrum::Browser.new(timeout: 120)
    url = "https://www.infogreffe.com/entreprise-societe/#{@siren}"
    raise
    browser.goto(url)
    html_doc = Nokogiri::HTML(browser.body)
    element = html_doc.search('//*[@id="identification"]/h1').text.split(" ")
    element = element.take(element.index("Partager")).join(" ")
    html_doc.search('//*[@id="showHideContent"]/div[1]/div[2]/table/tbody/tr/td[1]/div[1]').each do |element|
      address = element.text
    end
    html_doc.search('//*[@id="showHideContent"]/div[1]/div[2]/table/tbody/tr/td[2]/div[1]/p[1]').each do |element|
      naf = element.text
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
    siret = key_figures
  end
end
