class ClearbitJob < ApplicationJob
  queue_as :default

  def perform(competitor_id)
    competitor = Competitor.find(competitor_id)
    url = "https://autocomplete.clearbit.com/v1/companies/suggest?query=#{competitor.trading_name.encode("ASCII", "UTF-8", undef: :replace)}"
    competitor_autocomplete = HTTParty.get(url)
    if competitor_autocomplete.size == 1
      competitor_select = competitor_autocomplete.first
    else
      competitor_select = competitor_autocomplete.select { |item| item["name"].capitalize == competitor.trading_name.capitalize }
      competitor_select = competitor_select.first
    end
    competitor.website = "https://www.#{competitor_select['domain']}"
    file = URI.open(competitor_select['logo'])
    competitor.photo.attach(io: file, filename: competitor.trading_name, content_type: "image/png")

    competitor.save
    CompetitorChannel.broadcast_to(
      competitor,
      {html: ApplicationController.renderer.render(partial: "competitors/id_card", locals: { competitor: competitor, visible: true }), trading_name: competitor.trading_name }
    )
    JobscraperJob.perform_later(competitor.id)
  end
end
