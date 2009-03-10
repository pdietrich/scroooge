# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  
  # If you want "remember me" functionality, add this before_filter to Application Controller
  before_filter :login_from_cookie
  
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery :secret => 'e754a694e012d5e531fe6a23f7bec87b'
  
  # disable side wide? :
  # self.allow_forgery_protection = false

  # you can disable csrf protection on controller-by-controller basis:
  # skip_before_filter :verify_authenticity_token

  
  before_filter :set_current_currency

private
  def set_current_currency
    if logged_in?
      session[:currency] ||= current_person.currency
    else
      session[:currency] = nil
    end
    $current_currency = session[:currency]
    return true # just in case
  end
end
