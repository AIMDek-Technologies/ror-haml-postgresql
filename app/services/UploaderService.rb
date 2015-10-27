class UploaderService

  # upload customers from the csv file
  def upload_customers_from_csv(file,user_id)
    uploaded_file = file
    puts "#{uploaded_file}"
    file_content = uploaded_file.read
    csv = CSV.parse(file_content, :headers => true)
    success_count = 0
    time_start = Time.now
    flag = false
    csv.each do |row|
      flag = BulkUpload.create_customer(row)
      success_count += 1
    end
    difference = Time.now - time_start
    if flag
      BulkUpload.set_bulk_upload(csv.length, difference.ceil,success_count, file.original_filename,user_id)
      true
    end
  end

  # upload transactions from the csv file
  def upload_transactions_from_csv(file,user_id)
    uploaded_file = file
    file_content = uploaded_file.read
    csv = CSV.parse(file_content, :headers => true)
    success_count = 0
    time_start = Time.now
    flag = false
    csv.each do |row|
      flag = BulkUpload.create_transaction(row)
      success_count += 1
    end
    difference = Time.now - time_start
    if flag
      BulkUpload.set_bulk_upload(csv.length, difference.ceil,success_count, file.original_filename,user_id)
      true
    else
      flag
    end
  end

  # upload customers from the excel file
  def upload_customers_from_excel(file,user_id)
    excel = Roo::Spreadsheet.open(file,extension: :xlsx)
    sheet  = excel.sheet(0)
    headers = sheet.row(1)
    success_count = 0
    time_start = Time.now
    flag = false
    (2..sheet.last_row).each do |i|
      row = Hash[[headers, sheet.row(i)].transpose]
      flag = BulkUpload.create_customer(row)
      success_count += 1
    end
    difference = Time.now - time_start
    if flag
      BulkUpload.set_bulk_upload(sheet.last_row - 1, difference.ceil,success_count, file.original_filename,user_id)
      true
    end
  end

  # upload transactions from the excel file
  def upload_transactions_from_excel(file,user_id)
    excel = Roo::Spreadsheet.open(file,extension: :xlsx)
    sheet  = excel.sheet(0)
    headers = sheet.row(1)
    success_count = 0
    time_start = Time.now
    flag = false
    (2..sheet.last_row).each do |i|
      row = Hash[[headers, sheet.row(i)].transpose]
      flag = BulkUpload.create_transaction(row)
      success_count += 1
    end
    difference = Time.now - time_start
    if flag == true
      BulkUpload.set_bulk_upload(sheet.last_row - 1, difference.ceil,success_count, file.original_filename,user_id)
      true
    else
      flag
    end
  end

end