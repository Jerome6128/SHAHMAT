class InfogreffeScraperService
  def initialize(siren)
    @siren = siren
  end

  def scrape(competitor)
    # retriev informatiton from infogreffe
    browser = Ferrum::Browser.new(timeout: 240)
    url = "https://www.infogreffe.com/entreprise-societe/#{@siren}"
    browser.goto(url)
    html_doc = Nokogiri::HTML(browser.body)
    # retrieve the name of the company
    element = html_doc.search('//*[@id="identification"]/h1').text.split(" ")
    brand_name = element.take(element.index("Partager")).join(" ")

    # retrieve the address of the company
    element = html_doc.search('//*[@id="showHideContent"]/div[1]/div[2]/table/tbody/tr/td[1]/div[1]').text.split(" ")
    address = element.drop(element.index("-") + 1).join(" ")

    # retrieve the naf code of the company
    naf = html_doc.search('//*[@id="showHideContent"]/div[1]/div[2]/table/tbody/tr/td[2]/div[1]/p[1]').text

    # retrieve the key figures of the company
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
    # retrieve information from Linkedin
    # browser = Ferrum::Browser.new(timeout: 120)
    # browser.cookies.set(name: "li_at", value: "AQEDATNdIgUAe_AjAAABdgABqPMAAAF2JA4s800AAMIjJHsB8ZR2lPvSnI-bWiY53hXNc58va8lrzrb7-oqC3xKydKR8fxxYk-DV1TJzfJg5a2Itt1ftUPrKKJf5cd9za5jp25Mj_FhgQil2U2xivIPI", domain: "linkedin.com")
    # url = "https://fr.linkedin.com/company/#{brand_name}"
    # browser.goto(url)
    # html_doc = Nokogiri::HTML(browser.body)
    # logo_url = html_doc.search('/html/body/main/section[1]/section[1]/div/img').attribute("src").value
    # file = URI.open(logo_url)

    # retrieve logo from Google
    browser = Ferrum::Browser.new(timeout: 120)
    url = "https://www.google.com/search?q=#{brand_name}+logo&tbm=isch"
    browser.goto(url)
    html_doc = Nokogiri::HTML(browser.body)
    logo_data = html_doc.search('//*[@id="islrg"]/div[1]/div[1]/a[1]/div[1]/img').attribute('src').value
    base64_image = logo_data.split(",")[1]
    img_from_base64 = Base64.decode64(base64_image)
    filetype = /(png|jpg|jpeg|gif|PNG|JPG|JPEG|GIF)/.match(img_from_base64[0,16])[0]
    filename = brand_name
    file = "#{filename}.#{filetype}"
    File.open(file, 'wb') { |f| f.write(img_from_base64) }
    competitor.photo.attach(io: URI.open(file), filename: filename, content_type: "image/#{filetype}")
    File.delete(file)
    { brand_name: brand_name, address: address, naf: naf, key_figures: key_figures }
  end
end
