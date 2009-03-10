class PeopleController < ApplicationController
  before_filter :login_required
  
  def index
    # puts "PeopleController#index"
    @deptors_and_creditors = current_person.deptors_and_creditors
  end
  
  def show
    @person = Person.find( params[:id] )
    @bills = current_person.bills_shared_with( @person.id )
    # @owed = 0.0
    # for bill in @bills
    #   puts "amount:#{bill.amount} payer: #{bill.payer.name} currency_id: #{bill.currency_id}"
    #   @owed += bill.amount_for( current_person.id )
    # end
  end

end
