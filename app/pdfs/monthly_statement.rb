class MonthlyStatement < Prawn::Document

  def initialize(transactions,view,credit_card,duration)
    super()
    @view = view
    @credit_card = credit_card
    @duration = duration
    @transaction_line_items = transactions
    @total = 0
    set_logo
    header_text
    credit_card_details
    set_statement_summary
    create_transactions
    set_total_amount
  end

  def header_text
    font 'Helvetica'
    move_up 40
    font_size 15
    text 'AIMDEK CREDIT CARD APPLICATION'
    duration_text
  end

  def bank_details
    font_size 6
    text '203, Shivam Complex, Opp. Hetarth Party Plot, Science city road, Sola, Ahmedabad - 380060'
  end

  def duration_text
    bank_details
    move_down 5
    font_size 9
    text "STATEMENT OF CARD NUMBER #{@credit_card.card_number}"
    font 'Courier'
    move_down 1
    text "FROM <color rgb='0000FF'> #{@duration.at(0).strftime('%d-%m-%Y')} </color> TO  <color rgb='0000FF'>#{@duration.at(1).strftime('%d-%m-%Y')} </color>",:inline_format => true
    move_down 2
    stroke_color "#3188EC"
    stroke_horizontal_rule
  end

  def set_logo
    move_up 10
    image "#{Rails.root}/public/images/aimdek-logo.png", :position => :right, :width => 50, :height => 50
  end

  def create_transactions
    move_down 20
    font 'Helvetica'
    font_size 8
    text "This month's activity:"
    move_down 5
    table line_item_rows do
      row(0).font_style = :bold
      # self.row_colors = ["F0F0F0","FFFFFF"]
      self.columns(3).align = :right
      self.columns(0..1).align = :center
      self.row(0).background_color = "F0F0F0"
      self.width = 540
      self.column_widths = [50, 70, 320, 100]
      self.header = true
      self.cell_style = {:border_width => 0.5, :border_color => "DDDDDD"}
      self.position = :center
    end
  end

  def line_item_rows
    font_size 8
    [['DATE', 'TRASACTION#', 'DESCRIPTION', 'AMOUNT']] +
    @transaction_line_items.map do |transaction|
      ["#{transaction.transaction_date.strftime('%d-%m-%Y')}","#{transaction.transaction_id}", "#{transaction.description}", "#{price(transaction.amount)}"]
    end
  end

  def price(number)
    @view.number_to_currency(number, :unit => "Rs.")
  end

  def credit_card_details
    move_down 10
    font_size 8
    font 'Helvetica'
    text "ACCOUNT DETAILS" , :align => :left, :color => "0000FF"
    font_size 8
    move_down 2
    text "NAME: #{@credit_card.user.full_name}", :align => :left
    move_down 1
    text "CARD NUMBER: #{@credit_card.card_number}", :align => :left
    move_down 1
    text "STATEMENT DATE: #{@credit_card.statement_date.strftime('%d-%m-%Y')}", :align => :left
    move_down 1
    text "CREDIT LIMIT: #{price(@credit_card.credit_limit)}", :align => :left
    move_down 1
    text "AVAILABLE CREDIT: #{price(@credit_card.available_credit_limit)}", :align => :left
  end

  def set_total_amount
    move_down 10
    font_size 10
    text "TOTAL AMOUNT: #{price(get_total)}", :align => :right, :color => "0000FF", :inline_format => true
  end

  def get_total
    @total = 0
    @transaction_line_items.each do |transaction|
      @total = @total.to_f + transaction.amount
    end
    @total
  end

  def set_statement_summary
    move_up 60
    font_size 8
    font 'Helvetica'
    text "STATEMENT SUMMARY" , :align => :right, :color => "0000FF"
    font_size 8
    move_down 1
    text "PAYMENT DUE: #{price(get_total)}", :align => :right
    move_down 1
    text "PAYMENT DUE DATE: #{(1.day.ago + 14.days).strftime('%d-%m-%Y')}", :align => :right
    move_down 1
    text "CREDIT LIMIT: #{price(@credit_card.credit_limit)}", :align => :right
    move_down 1
    text "AVAILABLE CREDIT: #{price(@credit_card.available_credit_limit)}", :align => :right
  end

end