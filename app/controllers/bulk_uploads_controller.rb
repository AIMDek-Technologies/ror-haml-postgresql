class BulkUploadsController < ApplicationController
  before_filter :login_required, :load_uploader_service
  helper_method :sort_column, :sort_direction
  require 'UploaderService'

  def index
    @bulk_uploads = BulkUpload.text_search(params[:search]).order("#{sort_column} #{sort_direction}").paginate(:page => params[:page])
    respond_to do |format|
      format.js
      format.html
      format.json { render :json => @bulk_uploads }
    end
  end

  def new
    render 'bulk_uploads/new', layout: nil
  end

  # upload the records from the selected file
  # supported file is .csv or .xlsx file
  def upload
    upload_type = bulk_upload_params[:type]
    if upload_type == 'customers'
      flag = upload_customers(bulk_upload_params[:file])
      render :text => flag
    elsif upload_type == 'transactions'
      flag = upload_transactions(bulk_upload_params[:file])
      render :text => flag
    end
  end

  private

  # upload customers from the selected file
  def upload_customers(uploadedFile)
    case uploadedFile.content_type
      when 'application/vnd.ms-excel'
        flag = @uploader_service.upload_customers_from_csv(uploadedFile,session[:user_id])
        if flag == true
          'success'
        elsif flag == false
          Rails.logger.error 'Error occurred while uploading data from the excel file'
          t('errors.fileError')
        else
          flag
        end
      when 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
       flag = @uploader_service.upload_customers_from_excel(uploadedFile,session[:user_id])
       if flag == true
         'success'
       elsif flag == false
         Rails.logger.error 'Error occurred while uploading data from the CSV file'
         t('errors.fileError')
       else
         flag
       end
      else
        Rails.logger.error 'Unsupported file is uploaded by user'
        t('errors.unsupported_format')
    end
  end

  # upload transactions from the selected file
  def upload_transactions(uploadedFile)
    case uploadedFile.content_type
      when 'application/vnd.ms-excel'
        flag = @uploader_service.upload_transactions_from_csv(uploadedFile,session[:user_id])
        if flag == true
          'success'
        elsif flag == false
          Rails.logger.error 'Error occurred while uploading data from the CSV file'
          t('errors.fileError')
        else
          flag
        end
      when 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
        flag = @uploader_service.upload_transactions_from_excel(uploadedFile,session[:user_id])
        if flag == true
          'success'
        elsif flag == false
          Rails.logger.error 'Error occurred while uploading data from the CSV file'
          t('errors.fileError')
        else
          flag
        end
      else
        Rails.logger.error 'Unsupported file is uploaded by user'
        t('errors.unsupported_format')
    end
  end

  def bulk_upload_params
    params.require(:bulk_upload).permit(
        :file,
        :type
    )
  end

  def sort_column
    BulkUpload.column_names.include?(params[:sort]) ? params[:sort] : 'updated_at'
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'desc'
  end

  def load_uploader_service(service = UploaderService.new)
    @uploader_service ||= service
  end

end
