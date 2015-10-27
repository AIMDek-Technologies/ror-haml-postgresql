class CreditCardsController < ApplicationController

  def index
  end

  def new
    @credit_card = CreditCard.new
    render 'credit_cards/new', :layout => nil
  end

  def create
    @credit_card = CreditCard.create!(credit_card_params)
    if @credit_card.save
      render :text => 'success'
    else
      render :new
    end
  end


  def user_credit_cards
    @credit_cards = CreditCard.where(:user_id => params[:user_id])
    render :json => @credit_cards
  end


  private
  def credit_card_params
    params.require(:credit_card).permit(
        :card_number,
        :name_on_card,
        :cvv,
        :credit_limit,
        :valid_from_date,
        :valid_to_date,
        :user_id
    )
  end
end
