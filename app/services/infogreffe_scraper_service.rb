class InfogreffeScraperService
  def initialize(siren)
    @siren = siren
  end

  def scrape
    browser = Ferrum::Browser.new(timeout: 120)
    url = "https://www.infogreffe.com/entreprise-societe/#{@siren}"
    browser.goto(url)
    html_doc = Nokogiri::HTML(browser.body)
    #retrieve the name of the company
    element = html_doc.search('//*[@id="identification"]/h1').text.split(" ")
    brand_name = element.take(element.index("Partager")).join(" ")

    #retrieve the address of the company
    element = html_doc.search('//*[@id="showHideContent"]/div[1]/div[2]/table/tbody/tr/td[1]/div[1]').text.split(" ")
    address = element.drop(element.index("-") + 1).join(" ")

    #retrieve the naf code of the company
    naf = html_doc.search('//*[@id="showHideContent"]/div[1]/div[2]/table/tbody/tr/td[2]/div[1]/p[1]').text

    #retrieve the key figures of the company
    key_figures = []
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
    end

    { brand_name: brand_name, address: address, naf: naf, key_figures: key_figures }
  end
end
