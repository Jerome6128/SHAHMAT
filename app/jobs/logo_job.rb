class LogoJob < ApplicationJob
  queue_as :default

  def perform(competitor_id)
    competitor = Competitor.find(competitor_id)
    browser = Ferrum::Browser.new(timeout: 120)
    url = "https://www.google.com/search?q=#{competitor.trading_name}+logo&tbm=isch"
    browser.goto(url)
    html_doc = Nokogiri::HTML(browser.body)
    logo_data = html_doc.search('//*[@id="islrg"]/div[1]/div[1]/a[1]/div[1]/img').attribute('src').value
    base64_image = logo_data.split(",")[1]
    img_from_base64 = Base64.decode64(base64_image)
    filetype = /(png|jpg|jpeg|gif|PNG|JPG|JPEG|GIF)/.match(img_from_base64[0,16])[0]
    filename = competitor.trading_name
    file = "#{filename}.#{filetype}"
    File.open(file, 'wb') { |f| f.write(img_from_base64) }
    competitor.photo.attach(io: URI.open(file), filename: filename, content_type: "image/#{filetype}")
    competitor.save
    CompetitorChannel.broadcast_to(
      competitor,
      {html: ApplicationController.renderer.render(partial: "competitors/id_card", locals: { competitor: competitor, visible: true }), trading_name: competitor.trading_name }
    )
    File.delete(file)
    JobscraperJob.perform_later(competitor.id)
  end
end
