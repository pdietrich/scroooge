require 'active_record'
require 'app/models/person'
require 'app/models/bill'
require 'app/models/participation'
require 'app/models/currency'
require 'lib/round_to'

namespace :scroooge_setup do

  task :sanitise_db do
    ActiveRecord::Base.establish_connection(
         :adapter => 'mysql',
         :encoding => 'utf8',  # use "unicode" for postgresql
         :host => 'localhost',
         :database => 'scroooge_development',
         :username => 'root',
         :password => ''
    )
    
    for bill in Bill.find(:all)
      bill.save!
      for p in bill.participations
        p.save!
      end
    end
  end
  
  task :copy_old_scrooge_data do
    ActiveRecord::Base.establish_connection(
         :adapter => 'mysql',
         :encoding => 'utf8',  # use "unicode" for postgresql
         :host => 'localhost',
         :database => 'scroooge_development',
         :username => 'root',
         :password => ''
    )

    class MyConnectionHelper < ActiveRecord::Base
      establish_connection(
         :adapter => 'mysql',
         :encoding => 'utf8',  # use "unicode" for postgresql
         :host => 'localhost',
         :database => 'old_scrooge',
         :username => 'root',
         :password => ''
      )
    end
    $old_scrooge_db = MyConnectionHelper.connection # warum einfach, wenns auch umständlich geht?  
    # $old_scrooge_db.rename_table( :scrooge_part, :scrooge_parts )
    
    
    class ScroogeUser < ActiveRecord::Base
      self.connection = $old_scrooge_db
    end
    
    puts 2
    class ScroogeTran < ActiveRecord::Base
      self.connection = $old_scrooge_db
      
      has_many :scrooge_parts, :class_name => 'ScroogePart', :foreign_key => 'trans'
    end
    puts 3
    class ScroogePart < ActiveRecord::Base
      self.connection = $old_scrooge_db
      
      belongs_to :scrooge_tran, :class_name => 'ScroogeTran', :foreign_key => 'trans'
    end
    
    puts 4
    gbp = Currency.find( :first, :conditions => {:short_code => 'GBP'} )
    gbp_id = gbp ? gbp.id : 1
    
    puts 5
    for user in ScroogeUser.find( :all )
      next if user.fullname == 'Martin Kleppmann' or user.fullname == 'Michael Arnold' or user.fullname == 'Patrick Dietrich'
      puts user.inspect
      person = Person.new
      person.name = user.fullname
      person.email = user.email
      person.currency_id = gbp_id
      person.password = '30scbadger'
      person.password_confirmation = '30scbadger'
      person.save!
    end
    
    puts "--------------------------------------------------------------"
    
    for tran in ScroogeTran.find(:all)
      puts tran.inspect
      bill = Bill.new
      bill.payer = Person.find_by_name( ScroogeUser.find(:first, :conditions => { :name => tran.spender } ).fullname )
      bill.amount = tran.amount
      bill.name = tran.subject
      bill.currency_id = gbp_id
      bill.creator_id = bill.payer.id
      puts bill.inspect
      for part in tran.scrooge_parts
        puts "\t" + part.inspect
        participation = bill.participations.build
        participation.factor = part.weight
        participation.currency_id = gbp_id
        participation.participant = Person.find_by_name( ScroogeUser.find(:first, :conditions => { :name => part.receiver } ).fullname )
        puts "\t" + participation.inspect
      end
      bill.save!
      bill.created_at = tran.add_date
      bill.save_without_validation!
    end
  end
end