class LogoJob < ApplicationJob
  queue_as :default

  def perform(competitor_id)
    competitor = Competitor.find(competitor_id)
    browser = Ferrum::Browser.new({ timeout: 60, headless: true, process_timeout: 60 })
    url = "https://www.google.com/search?q=logo+#{competitor.trading_name}&tbm=isch&nfpr=1"
    browser.goto(url)
    html_doc = Nokogiri::HTML(browser.body)
    browser.quit
    logo_data = html_doc.search('//*[@id="islrg"]/div[1]/div[1]/a[1]/div[1]/img').attribute('src').value

    base64_image = logo_data.split(",").last
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
    ClearbitJob.perform_later(competitor.id)
  end
end
