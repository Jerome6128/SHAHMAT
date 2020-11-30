class CompetitorChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    competitor = Competitor.find(params[:id])
    stream_for competitor
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
