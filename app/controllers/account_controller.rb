class AccountController < ApplicationController

  before_filter :login_required, :only => ['preferences']

  # say something nice, you goof!  something sweet.
  def index
    redirect_to(:action => 'signup') unless logged_in? || Person.count > 0
  end

  def login
    unless request.post?
      if logged_in?
        redirect_to :controller => 'people', :action => 'index'
      end
      return
    end
    
    self.current_person = Person.authenticate( params[:login], params[:password] )
    if logged_in?
      if params[:remember_me] == "1"
        self.current_person.remember_me
        cookies[:auth_token] = { :value => self.current_person.remember_token , :expires => self.current_person.remember_token_expires_at }
      end
      redirect_back_or_default(:controller => 'people', :action => 'index')
      flash[:notice] = "Logged in successfully"
    else
      @error_message = 'Sorry, login or password unknown.'
    end
  end

  def signup
    @person = Person.new(params[:person])
    return unless request.post?
    
    if params[:person] and params[:person][:email] and params[:person][:email] =~ /^.+?@.+?\.(.{2,})$/
      tld = $1
      if tld =~ /^(?:de|at|fr|it|es|nl|be|fn|sl)$/i
        @person.currency = Currency.find_by_short_code( 'EUR' )
      elsif tld =~ /^(?:uk)$/i
        @person.currency = Currency.find_by_short_code( 'GBP' )
      elsif tld =~ /^(?:us|gov)$/i
        @person.currency = Currency.find_by_short_code( 'USD' )
      else
        @person.currency = Currency.find_by_short_code( 'GBP' )
      end
    else
      @person.currency_id = 1
    end
    
    @person.save!
    self.current_person = @person
    redirect_back_or_default(:controller => 'account', :action => 'preferences')
    flash[:notice] = "Thanks for signing up!"
    
  rescue ActiveRecord::RecordInvalid
    logger.info "login failed: #{@person.errors.inspect}"
    render :action => 'signup'
  end
  
  def logout
    self.current_person.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "You have been logged out."
    redirect_back_or_default( '/' )
  end
  
  def preferences
    return unless request.post?    
    current_person.attributes = params[:person]
    if params[:currency]
      currency = Currency.find(:first, :conditions => [ 'currencies.id = ?', params[:person][:currency_id] ])
      session[:currency] = currency
      current_person.currency_id = currency.id
    end
    
    if current_person.save
      flash[:notice] = "Your properties have been saved successfully!"
      redirect_to :action => 'preferences'
    else
      render :action => 'preferences'
    end
  end
end
