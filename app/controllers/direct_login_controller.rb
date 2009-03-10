class DirectLoginController < ApplicationController

  def login
    code = params[:code]
    unless code and code != ''
      flash[:error] = 'code required'
      raise 'no code supplied!'
    end
    
    direct_login_information = DirectLoginIdentifier.find_by_code( code )
    if direct_login_information
      self.current_person = direct_login_information.identified_person
      direct_login_information.destroy
      if current_person.has_proper_name?
        redirect_to $home
      else
        flash[:notice] = 'Please enter your name'
        redirect_to :controller => 'account', :action => 'preferences'
      end
    else
      flash[:error] = "Sorry, this login link has probably been used already. Please log in using your email address and password."
      redirect_to :controller => 'account', :action => 'login'
    end
  end

end
