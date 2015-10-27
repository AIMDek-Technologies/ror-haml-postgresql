class TransactionsController < ApplicationController
  before_filter :login_required
  helper_method :sort_column, :sort_direction

   def index
    @transaction = Transaction.new
    @transactions = Transaction.text_search(params[:search]).order("#{sort_column} #{sort_direction}").paginate(:page => params[:page])
    respond_to do |format|
      format.js
      format.html
      format.json { render :json => @transactions }
    end
  end

  # create new transaction
  def new
    @transaction = Transaction.new
    render 'transactions/new', :layout => nil
  end

  # save new transaction
  def create
    @transaction = Transaction.create(transaction_params)
    @transaction.transaction_date = @transaction.transaction_date.blank? ? Time.now : @transaction.transaction_date
    update_credit_limit(@transaction.balance, @transaction.credit_card_id)
    if @transaction.save
      Rails.logger.info "Transaction saved successfully for transaction with id #{@transaction.id}"
      render :text => 'success'
    else
      Rails.logger.error "Unable to save transaction with id #{@transaction.id}"
      render :new
    end
  end

  private

  # update available credit limit on transaction save
  def update_credit_limit(amount,id)
    credit_card = CreditCard.find(id)
    if !credit_card.nil?
      credit_card.update_attributes!(:available_credit_limit => amount)
      Rails.logger.info "Updated credit limit with #{amount} for credit card id #{id}"
    end
  end

  # strict parameters for the transaction entry
  def transaction_params
    params.require(:transaction)
      .permit(
        :user_id,
        :credit_card_id,
        :amount,
        :transaction_date,
        :balance,
        :description
    )
  end

  def sort_column
    Transaction.column_names.include?(params[:sort]) ? params[:sort] : 'updated_at'
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'desc'
  end
end
