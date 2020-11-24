class WttjScraperService
  def initialize(brand_name)
    @brand_name = brand_name.parameterize
  end

  def scrape
    browser = Ferrum::Browser.new(timeout: 30)
    url = "https://www.welcometothejungle.com/fr/companies/#{@brand_name}/jobs"
    browser.goto(url)

    ## wait until full loading of the webpage
    loop do
      break if browser.evaluate("document.readyState") == "complete"
    end
    ## then you have the doc to nokogirize

    html_doc = Nokogiri::HTML(browser.body)

    jobs = []
    infos_array = []
    html_doc.search(".sc-1flb27e-5").each do |element|
      infos_array = []
      job = {}

      element.search("h3").each do |title|
        job[:title] = title.content
        # p job[:title]
      end

      element.search(".sc-1qc42fc-2").each do |info|
        infos_array << info.content
      end
      job[:location] = infos_array[1]
      date = posting_date_into_date(infos_array[2])

      if date.respond_to?(:strftime)
        job[:posting_date] = date
      else
        job[:posting_date] = nil
      end
      jobs << job
    end
    return jobs
  end

  def posting_date_into_date(string_date)
  # p string_date.include? "heure"
    if (string_date.include? "heure") || (string_date.include? "minute")
      date = Date.today
    # p "je suis ici"
    elsif string_date == "hier"
      date = (Date.today - 1)
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
end
