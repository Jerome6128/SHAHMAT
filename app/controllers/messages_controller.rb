class MessagesController < ApplicationController
  def new
    @competitor = Competitor.find(params[:competitor_id])
    @message = Message.new
  end

  def create
    @message = Message.new(message_params)
    @competitor = Competitor.find(params[:competitor_id])
    @message.competitor_id = @competitor.id
    @message.user = current_user
    if @message.save
      redirect_to competitor_path(@competitor, section: @message.category)
    else
      render 'new'
    end
  end

  private
  def message_params
    params.require(:message).permit(:content, :category)
  end
end
