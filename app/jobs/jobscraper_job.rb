class JobscraperJob < ApplicationJob
  queue_as :default


  def posting_date_into_date(string_date)
    if (string_date.include? "heure") || (string_date.include? "minute")
      date = Date.today
      # p "je suis ici"
    elsif string_date == "hier"
      date = (Date.today - 1)
    elsif string_date == "avant-hier"
      date = (Date.today - 2)
    elsif string_date == "la semaine dernière"
      date = (Date.today - 7)
    elsif string_date == "le mois dernier"
      date = (Date.today - 30)

    elsif
      matches = string_date.match(/(?<number>\d) (?<time>.*)/)
      # it gives me the matches[:number] and the matches[:time]
      if matches[:time].include? "semaine"
        date = (Date.today - (matches[:number].to_i * 7))
      elsif matches[:time].include? "mois"
        date = (Date.today - (matches[:number].to_i * 30))
      elsif matches[:time].include? "jour"
        date = (Date.today - (matches[:number].to_i))
      end
    end
  end

  def perform(competitor_id)
    competitor = Competitor.find(competitor_id)
    browser = Ferrum::Browser.new(timeout: 60)
    url = "https://www.welcometothejungle.com/fr/companies/#{competitor.brand_name.parameterize}/jobs"
    browser.goto(url)
    browser.mouse.scroll_to(0, 400)
    # p competitor.brand_name
    ## wait until full loading of the webpage
    loop do
      break if browser.evaluate("document.readyState") == "complete"
    end

    html_doc = Nokogiri::HTML(browser.body)
    browser.quit
    # p html_doc
    jobs = []
    html_doc.search(".sc-1flb27e-5").each do |element|
      infos_array = []
      job = {
        source: "WTTJ"
      }
      element.search("h3").each do |title|
        job[:title] = title.content
      end
      element.search('a').each do |link|
        suffix_url = link.attribute("href").value
        job[:job_url] = "https://www.welcometothejungle.com#{suffix_url}"
      end

      element.search(".sc-1qc42fc-2").each do |info|
        infos_array << info.content
      end
      job[:location] = infos_array[1]
      # p infos_array[2]
      date = posting_date_into_date(infos_array[2])

      if date.respond_to?(:strftime)
        job[:posting_date] = date
      else
        job[:posting_date] = nil
      end
      jobs << job
    end
    jobs.each do |job|
      @job_offer = JobOffer.new(job)
      @job_offer.competitor = competitor
      @job_offer.save!
    end
    competitor.save
    CompetitorChannel.broadcast_to(
      competitor,
      {html: ApplicationController.renderer.render(partial: "competitors/id_card", locals: { competitor: competitor, visible: true }), trading_name: competitor.trading_name }
    )
  end
end
