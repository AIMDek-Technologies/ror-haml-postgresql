require 'rufus-scheduler'
  # starting Rufus scheduler in new thread
  Thread.new do
    scheduler = Rufus::Scheduler.new
    statement_generator = StatementsController.new
    
    # code to run scheduler at 04:00 of every day
    scheduler.cron '00 04 * * *' do
      statement_generator.generate_monthly_statements
    end

    # testing scheduler
    # scheduler.every '1m' do
    #   # statement_generator.generate_monthly_statements
    # end
  end