require 'rubygems'
require 'json'

class BillsController < ApplicationController
  before_filter :login_required
  
  # GET /bills
  # GET /bills.xml
  def index
#    @bills = []
#    @payed_bills = current_person.payed_bills
#    @participated_bills = current_person.participated_bills
#    @bills += @participated_bills
#    @bills += @payed_bills
#    @bills.sort!{ |bill, other_bill| other_bill.created_at <=> bill.created_at }
    @bills = current_person.involved_bills
    puts 'bills'
    puts @bills.inspect
  end

  # GET /bills/1
  # GET /bills/1.xml
  def show
    @bill = Bill.find( :first, :conditions => {:id => params[:id]}, :include => ['participations'])
    unless access_allowed?( @bill )
      flash[:error] = "Sorry, you are not allowed to view this bill"
      redirect_to :action => 'index'
    end
  end

  def add_by_email
    # check if there is a person with the given email in the DB
    person = Person.find_by_email( params[:email] )
    if person
      # return the existing person's data
      render :text => <<-JSON
        { "member": true,
          "id": #{person.id},
          "name": "#{person.name}",
          "avatar_url": "/stylesheets/images/img_gravatar.png"
        }
      JSON
    else
      # no person found. return what we got
      render :text => <<-JSON
        { "member": false,
          "name": "#{params[:name]}",
          "email": "#{params[:email]}"
        }
      JSON
    end
  end

  # GET /bills/new
  # GET /bills/new.xml
  def new
    @bill = Bill.new()
    @bill.currency_id = $current_currency.id
    # @bill.participations.build()
    @first_display = true
  end

#  # GET /bills/1/edit
#  def edit
#    @bill = Bill.find(params[:id])
#  end

  # POST /bills
  # POST /bills.xml
  def create
    puts params.inspect
    
    @people_by_email = {}

    Bill.transaction do
      @bill = Bill.new
      @bill.amount = params['bill_amount']
      @bill.name = params['bill_name']
      @bill.payer_id = params['payer_id']
      
      # unless params[:bill][:payer_id] and params[:bill][:payer_id] != ''
      #         @bill.payer = find_or_create_person_by_email( params[:bill][:payer_email], params[:bill][:payer_name] )
      #       end
      
      @bill.creator_id = current_person.id
      @bill.currency_id = current_person.currency_id
    
      for id, factor in params[:factors]        
        participation = @bill.participations.build()
        participation.creator_id = current_person.id
        
        if id and id =~ /^\d+$/
          # TODO: foreign key constraint for this!
          participation.participant_id = id
          participation.factor = factor
        # else
        #   raise 'no valid id or email found' unless p['email']
        #   participation.participant = find_or_create_person_by_email( p['email'], p['name'] )
        end
      end
      
      puts 'saving bill'
      if @bill.save
        puts "@bill = #{@bill.inspect}"
        puts "bill saved"
        for participant in @bill.participants
          InvoiceMailer.deliver_bill_creation_notification( participant, @bill, current_person )
        end

        flash[:notice] = 'Bill was successfully created.'
        redirect_to :action => 'index'
      else
        render :action => 'new'
      end
    end # of transaction
  end

#  # PUT /bills/1
#  # PUT /bills/1.xml
#  def update
#    @bill = Bill.find(params[:id])
#
#    respond_to do |format|
#      if @bill.update_attributes(params[:bill])
#        flash[:notice] = 'Bill was successfully updated.'
#        format.html { redirect_to(@bill) }
#        format.xml  { head :ok }
#      else
#        format.html { render :action => "edit" }
#        format.xml  { render :xml => @bill.errors, :status => :unprocessable_entity }
#      end
#    end
#  end

  # DELETE /bills/1
  # DELETE /bills/1.xml
  def destroy
    if request.post?
      @bill = Bill.find(:first, :conditions => {:id => params[:id]}, :include => ['participations'])
      
      unless access_allowed?( @bill )
        flash[:error] = "Sorry, you are not allowed to delete this bill"
        redirect_to :action => 'index'
      end
      
      Bill.transaction do
        for participation in @bill.participations
          participation.destroy
        end
        @bill.destroy
      end
    end
    redirect_to :action => 'index'
  end

private

  def access_allowed?( bill )
    return true if @bill.creator_id == current_person.id
    return true if @bill.payer_id == current_person.id
    for participation in @bill.participations
      return true if participation.participant_id == current_person.id
    end
    return false
  end

  def find_or_create_person_by_email( email, name )
    puts 'find_or_create_person_by_email'
    if @people_by_email.has_key?( email )
      return @people_by_email[email]
    end
    
    res = nil
    if email and email != ''
      # TODO: DRY up email format checking!
      if email =~ /\A[^@\s]+@(?:[-a-z0-9]+\.)+[a-z]{2,}\Z/i
        puts 'matched email'
        person = Person.find_by_email( email )
        if person
          res = person
        else
          # create a new account
          puts 'creating account'
          new_account = Person.build_for_invitation( email, name, current_person )
          puts "new_account: #{new_account.inspect}"
          res = new_account
        end
      else
        puts 'wrong format'
        res = nil
      end
    else
      puts 'no email or participant'
      res = nil
    end
    
    @people_by_email[email] = res
    return res
  end
  
end
