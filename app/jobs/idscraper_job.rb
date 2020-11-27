class IdscraperJob < ApplicationJob
  queue_as :default

  def perform(competitor_id)
    competitor = Competitor.find(competitor_id)
    # retriev informatiton from infogreffe
    browser = Ferrum::Browser.new(timeout: 120)
    url = "https://www.infogreffe.com/entreprise-societe/#{competitor.siren}"
    browser.goto(url)
    html_doc = Nokogiri::HTML(browser.body)
    # retrieve the name of the company
    element = html_doc.search('//*[@id="identification"]/h1').text.split(" ")
    competitor.brand_name = element.take(element.index("Partager")).join(" ")
    # retrieve the address of the company
    element = html_doc.search('//*[@id="showHideContent"]/div[1]/div[2]/table/tbody/tr/td[1]/div[1]').text.split(" ")
    competitor.address = element.drop(element.index("-") + 1).join(" ")
    # retrieve the naf code of the company
    competitor.naf = html_doc.search('//*[@id="showHideContent"]/div[1]/div[2]/table/tbody/tr/td[2]/div[1]/p[1]').text
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
    competitor.reload
    p competitor
    # retrieve logo from Google
    browser = Ferrum::Browser.new(timeout: 120)
    url = "https://www.google.com/search?q=#{competitor.brand_name}+logo&tbm=isch"
    browser.goto(url)
    html_doc = Nokogiri::HTML(browser.body)
    logo_data = html_doc.search('//*[@id="islrg"]/div[1]/div[1]/a[1]/div[1]/img').attribute('src').value
    base64_image = logo_data.split(",")[1]
    img_from_base64 = Base64.decode64(base64_image)
    filetype = /(png|jpg|jpeg|gif|PNG|JPG|JPEG|GIF)/.match(img_from_base64[0,16])[0]
    filename = competitor.brand_name
    file = "#{filename}.#{filetype}"
    File.open(file, 'wb') { |f| f.write(img_from_base64) }
    competitor.photo.attach(io: URI.open(file), filename: filename, content_type: "image/#{filetype}")
    competitor.save
    File.delete(file)
    JobscraperJob.perform_later(competitor.id)
  end
end
