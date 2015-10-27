module StatementsHelper

  # statement generator interface
  def StatementsHelper.generate_statements(view_context)
    # getting credit cards which have statement date equal to yesterday's date with respect to current date.
    credit_cards = CreditCard.where(:statement_date => 1.day.ago.strftime('%d-%m-%Y'))

    # setting the dates to get the transactions of fetched credit cards
    # fetching the transactions of last month from the current date
    from_date = Time.new(1.month.ago.year, 1.month.ago.month, 1.month.ago.day, 00, 00, 01)
    to_date = Time.new(1.day.ago.year, 1.day.ago.month, 1.day.ago.day, 23, 59, 59)
    duration = [from_date, to_date]
    if !credit_cards.blank?
      credit_cards.each do |credit_card|
        amount_due = 0
        required_transactions = credit_card.transactions.where('transaction_date >= ? and transaction_date <= ?', from_date, to_date)
        if !required_transactions.blank?
          required_transactions.each do |transaction|
            amount_due += transaction.amount
          end

          # Using tempfile to store the document till it uploaded to AWS S3
          require 'tempfile'
          @file = Tempfile.new("#{1.month.ago.strftime('%B-%Y')}.pdf")
          # generate statement report using the transactions
          pdf = MonthlyStatement.new(required_transactions,view_context,credit_card,duration)
          pdf.render_file("#{@file.path}")
          contents = File.open("#{@file.path}")
          # uploading statements to AWS S3 bucket
          if File.exists?("#{@file.path}")
            key = "#{AWS_CONFIG['default_key']}/#{credit_card.user.id}/statements/#{credit_card.id}/#{1.month.ago.strftime('%B-%Y')}.pdf"
            if StatementsHelper.create_new_statement(credit_card,1.month.ago,1.day.ago,amount_due, key)
              begin
                @file.rewind
                object = $BUCKET.object(key)
                object.put(
                    :body =>  contents
                )
              rescue
                retry
              ensure
                next_statement_date = to_date + 1.month
                credit_card.update_attribute(:statement_date, next_statement_date)
                contents.close
                @file.close
                @file.unlink
              end
            else
              Rails.logger.error 'Statement cannot be saved'
            end
          else
            Rails.logger.error 'Error occured while generating statement as temp file does not exist.'
          end
        end
      end
    end
  end

  # create new statement and save it to database
  # this method is called in statement generator interface cron job
  def StatementsHelper.create_new_statement(credit_card, from_date, to_date, amount_due, file_path)
    statement = Statement.new
    statement.credit_card_id = credit_card.id
    statement.user_id = credit_card.user.id
    statement.from_date = from_date
    statement.amount_due = amount_due
    statement.file_path = file_path
    statement.to_date = to_date
    statement.statement_date = Time.now.to_date
    statement.save ? true : false
  end

end
