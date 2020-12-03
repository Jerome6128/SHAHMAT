class ClearbitJob < ApplicationJob
  queue_as :default

  def perform(competitor_id)
    competitor = Competitor.find(competitor_id)
    url = "https://autocomplete.clearbit.com/v1/companies/suggest?query=#{competitor.trading_name}"
    competitor_autocomplete = HTTParty.get(url).first
    competitor.website = "https://www.#{competitor_autocomplete['domain']}"
    competitor.save
    CompetitorChannel.broadcast_to(
      competitor,
      {html: ApplicationController.renderer.render(partial: "competitors/id_card", locals: { competitor: competitor, visible: true }), trading_name: competitor.trading_name }
    )
    JobscraperJob.perform_later(competitor.id)
  end
end
