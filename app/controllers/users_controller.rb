class UsersController < ApplicationController
  before_filter :login_required
  helper_method :sort_column, :sort_direction
  layout nil, only: [:new, :edit]


  # action for customers home page
  def index
    @customers = User.text_search(query).customers.order("#{sort_column} #{sort_direction}").paginate(:page => params[:page])
    respond_to do |format|
      format.js
      format.html
      format.json { render :json => @customers }
    end
    
  end

  # action for adding new customer
  def new
    @customer = User.new
    @customer.build_address
    @customer.credit_cards.build
    render 'users/new', :layout => nil
  end

  # action to create new customer
  def create
    if (customer_params[:address_attributes][:geographic_id].blank?)
      geographic = Geographic.create(geographic_params)
      if geographic.save!
        customer_params[:address_attributes][:geographic_id] = geographic.id
      end
    end
       @customer = User.create(customer_params)
      if @customer.save
        Rails.logger.info "Customer created successfully with id #{@customer.id}"
        # Sign up email will be sent to user on sign up
        # CustomerMailer.account_creation_notification(@customer, customer_params[:password])
        render :text => 'success'
      else
        @geographic = !@customer.address.geographic_id.nil? ? Geographic.find(@customer.address.geographic_id) : nil
        Rails.logger.info 'Unable to save the customer'
        render :new, layout: nil
      end
  end

  # action to edit the customer
  def edit
    @customer = get_customer(params[:id])
    @customer.build_address if @customer.address.nil?
    @customer.credit_cards.build if @customer.credit_cards.nil?
    @geographic = !@customer.address.geographic_id.nil? ? Geographic.find(@customer.address.geographic_id) : nil
    render 'users/edit', layout: nil
  end

  # action to update the customer
  def update
    @customer = User.find(params[:id])
    if customer_params[:address_attributes][:geographic_id].blank? && !geographic_params.blank?
      geographic = Geographic.create(geographic_params)
      if geographic.update_attributes!(geographic_params)
        customer_params[:address_attributes][:geographic_id] = geographic.id
      end
    end
    key = "#{AWS_CONFIG['default_key']}/#{@customer.id}/#{session[:file_name]}"
    if !session[:file_name].blank?
      @customer.profile_pic_path = key
    end
    if @customer.update_attributes(customer_params)
      Thread.new do
          begin
            if !session[:file_name].blank?
              file_path = "#{Rails.root}/public/#{session[:file_name]}"
              if File.exists?(file_path)
                object = $BUCKET.object(key)
                object.put(
                    :body => File.open(file_path)
                )
              end
            end
             Rails.logger.info "Customer details updated successfully for customer with id #{@customer.id}"
          rescue
            Rails.logger.error "Errors occured while uploading profile pic for customer with id #{@customer.id}"
          end
      end
      # File.delete("#{Rails.root}/public/#{session[:file_name]}") if File.exists?("#{Rails.root}/public/#{session[:file_name]}")
      render :text => 'success'
    else
      @geographic = !@customer.address.geographic_id.nil? ? Geographic.find(@customer.address.geographic_id) : nil
      render :edit, layout: nil
    end
  end

  def destroy
    @customer = get_customer(params[:id])
    if @customer.destroy!
      render :index
    end
  end

  def find_geographic
    geographic = Geographic.find_by_zip_code(params[:zip_code])
    if !geographic.nil?
      render :json => geographic
    else
      render :nothing => true
    end
  end

  def get_states_from_country
    geographics = Geographic.select(:state).where(:country => params[:country]).uniq
    if !geographics.nil?
      render :json => geographics
    else
      render :nothing => true
    end
  end

  def get_cities_from_state
    geographics = Geographic.select(:city).where(:state => params[:state]).uniq
    if !geographics.nil?
      render :json => geographics
    else
      render :nothing => true
    end
  end

  def file_upload
    file = params[:file]
    case file.content_type
      when "image/jpeg"
        file_name = "profile_pic.jpg"
      when "image/png"
        file_name = "profile_pic.png"
      when "image/gif"
        file_name = "profile_pic.gif"
      when "image/bmp"
        file_name = "profile_pic.bmp"
    end
    file_path = "#{Rails.root}/public/#{file_name}"
    File.open(file_path, "wb") do |f|
      f.write file.read
    end

    if(File.exists?(file_path))
      if(!file_name.blank?)
        session[:file_name] = file_name
      end
    end

    render :text => file
  end

  private

  def customer_params
    params.require(:user).permit(
        :email,
        :password,
        :first_name,
        :last_name,
        :phone_number,
        :date_of_birth,
        :profile_pic_path,
        address_attributes: [
            :id,
            :user_id ,
            :geographic_id,
            :house_name,
            :street,
            :area
        ],
        credit_cards_attributes: [
            :id,
            :user_id,
            :card_number,
            :name_on_card,
            :valid_from_date,
            :valid_to_date,
            :cvv,
            :credit_limit,
            :available_credit_limit,
            :statement_date,
            :_destroy
        ]
    )
  end

  def geographic_params
    params.require(:geographic).permit(
        :zip_code,
        :country,
        :state,
        :city
    )
  end

  def get_customer(id)
    User.find(id)
  end

  def sort_column
    User.column_names.include?(params[:sort]) ? params[:sort] : "updated_at"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end

  def query
    params[:search].present? ? params[:search] : ""
  end

end
