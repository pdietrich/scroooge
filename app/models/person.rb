require 'digest/sha1'
require 'gravtastic'

class Person < ActiveRecord::Base
  
  belongs_to :currency
  has_many :direct_login_identifiers, :class_name => 'DirectLoginIdentifier', :foreign_key => 'identified_person_id'

  def participations
    Participation.scoped(:conditions => { 'participations.currency_id' => self.currency_id, :participant_id => self.id })
  end
  
  # Virtual attribute for the unencrypted password
  attr_accessor :password

  attr_accessible :name, :email, :gravatar_email,
                  :password, :password_confirmation, :currency_id

  validates_presence_of     :currency_id
  validates_presence_of     :name
  validates_length_of       :name,    :within => 3..100
  # validates_format_of       :name, :with => /\A[a-z0-9_- ]\Z/i, :if => :name
  validates_presence_of     :email
  validates_presence_of     :password,                   :if => :password_required?
  validates_presence_of     :password_confirmation,      :if => :password_required?
  validates_length_of       :password, :within => 4..40, :if => :password_required?
  validates_confirmation_of :password,                   :if => :password_required?
  validates_length_of       :email,    :within => 3..100
  validates_format_of       :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  validates_uniqueness_of   :email, :case_sensitive => false
  before_save :encrypt_password


  is_gravtastic :with => :gravatar_email, :default => 'wavatar'
  def gravatar_email
    return self.read_attribute(:gravatar_email) || self.email
  end

# # never tested!
#  named_scope( :with_balance,
#    :select => 'people.*, SUM(IF(participations.participant_id = people.id,-participations.amount,participations.amount)) AS balance',
#    :joins => '
#      JOIN participations
#      ON participations.participant_id = people.id AND participations.payer_id <> people.id
#      OR participations.participant_id <> people.id AND participations.payer_id = people.id
#    ',
#    :group => 'people.id'
#  )

  def self.find_by_id_with_balance( id )
    logger.debug "find_by_id_with_( #{id} )"
    people = Person.find_by_sql <<-SQL
      SELECT people.*, SUM(IF(participations.participant_id = #{id},-participations.amount,participations.amount)) AS balance
      FROM people
      JOIN participations
      ON participations.participant_id = #{id} AND participations.payer_id <> #{id}
      OR participations.participant_id <> #{id} AND participations.payer_id = #{id}
      WHERE participations.currency_id = people.currency_id AND people.id = #{id}
      GROUP BY people.id
    SQL
    person = people[0]
    unless person
      logger.debug "getting person manually..."
      person = Person.find_by_id( id )
      person.write_attribute(:balance, '0.0')
      logger.debug '  done! person = ' + person.inspect
    end
    return person
  end

#  def self.find_all_with_balance
#    Person.find_by_sql <<-SQL
#      SELECT people.*, SUM(IF(participations.participant_id = people.id,-participations.amount,participations.amount)) AS balance
#      FROM people
#      JOIN participations
#      ON participations.participant_id = people.id AND participations.payer_id <> people.id
#      OR participations.participant_id <> people.id AND participations.payer_id = people.id
#      WHERE participations.currency_id = people.currency_id
#      GROUP BY people.id
#      ORDER BY people.id
#    SQL
#  end

  def self.build_for_invitation( email, name, invitor )
    logger.debug 'build_for_invitation'
    person = Person.new
    person.email = email
    person.currency_id = $current_currency.id
    
    if name and name != ''
      person.name = name
    else
      person.name = "invited user"
      if email =~ /^(.+?)@(.+?)$/
        mail_name = $1
        domain = $2
        if mail_name =~ /^(?:mail|email|admin|correspondence|public|friends|info)$/
          person.name = person.name + " (...@#{domain})"
        else
          person.name = person.name + " (#{mail_name}@...)"
        end
      end
    end
    
    return person
  end
  
  def avatar_url
    '/images/default.png'
  end
  
  def has_logged_in_before?
    logger.debug "Person#has_logged_in_before"
    has_proper_name?
  end
  
  def has_proper_name?
    logger.debug "Person#has_proper_name?"
    not (name =~ /^invited user/)
  end

  def known_people
    return @known_people if @known_people
    
    first_grade_people ||= Person.find_by_sql <<-SQL
      SELECT DISTINCT people.*, "first" AS grade
      FROM people
      WHERE id IN (
        SELECT DISTINCT participant_id
          FROM participations
          WHERE payer_id = #{self.id}
        UNION
        SELECT DISTINCT payer_id
          FROM participations
          WHERE participant_id = #{self.id}
      )
    SQL
    
    first_grade_ids = first_grade_people.map{|p| p.id}.join(',')
    
    unless first_grade_ids.nil? or first_grade_ids.empty?
      second_grade_people ||= Person.find_by_sql <<-SQL
        SELECT DISTINCT people.*, "second" AS grade
        FROM people
        WHERE id in (
          SELECT DISTINCT participant_id
            FROM participations
            WHERE payer_id IN (#{first_grade_ids})
            AND participant_id NOT IN (#{first_grade_ids})
          UNION
          SELECT DISTINCT payer_id
            FROM participations
            WHERE participant_id IN (#{first_grade_ids})
            AND payer_id NOT IN (#{first_grade_ids})
        )
      SQL
    end
    
    @known_people = (first_grade_people||[]) + (second_grade_people||[])
    @known_people.sort!{|p1,p2| p1.name.downcase <=> p2.name.downcase }
    return @known_people
    
    @known_people ||= Person.find_by_sql <<-SQL
      SELECT DISTINCT person.*
      FROM participations AS part1
      JOIN participations AS part2
        ON part2.participant_id = part1.participant_id
        OR part2.participant_id = part1.payer_id
        OR part2.payer_id = part1.payer_id
        OR part2.payer_id = part1.participant_id
      JOIN people AS person
        ON part2.participant_id = person.id
        OR part2.payer_id = person.id
      WHERE (part1.payer_id = #{self.id} OR part1.participant_id = #{self.id})
      ORDER BY name
    SQL
  end

  def picture_url
    '/public/stylesheets/images/dummyavatar01.jpg'
  end

  def involved_bills
    bills = Bill.find_by_sql <<-SQL
      SELECT bills.*, SUM(IF(participations.participant_id=#{self.id},-participations.amount,participations.amount)) AS owed
      FROM bills
      JOIN participations
      ON participations.bill_id = bills.id
      WHERE participations.currency_id = #{self.currency_id}
      AND (participations.payer_id = #{self.id} XOR participations.participant_id = #{self.id})
      GROUP BY bills.id
      ORDER BY bills.created_at DESC
    SQL
    
    for bill in bills
      bill.ower_id = self.id
    end
    
    return bills
  end

  def bills_shared_with( other_person_id )
    bills = Bill.find_by_sql <<-SQL
      SELECT bills.*, SUM(IF(participations.payer_id=#{self.id},participations.amount,-participations.amount)) AS owed
      FROM bills
      JOIN participations
      ON participations.bill_id = bills.id
      WHERE participations.currency_id = #{self.currency_id}
      AND (
        (participations.payer_id = #{self.id} AND participations.participant_id = #{other_person_id} )
        OR
        (participations.payer_id = #{other_person_id} AND participations.participant_id = #{self.id} )
      )
      GROUP BY bills.id
      ORDER BY bills.created_at DESC
    SQL
      
    for bill in bills
      bill.ower_id = self.id
    end
    
    return bills
  end

  def payed_bills
    Bill.scoped(:conditions => { 'bills.currency_id' => self.currency_id, :payer_id => self.id })
  end

  def participated_bills( options={} )
    sql = "SELECT bills.*
      FROM bills
      JOIN participations ON participations.bill_id = bills.id
      WHERE participations.participant_id = #{self.id} AND participations.currency_id = #{self.currency_id}"
    
    if options[:include_own_bills]
      return @participated_bills_with_own_bills ||= Bill.find_by_sql( sql )
    else
      return @participated_bills_without_own_bills ||= Bill.find_by_sql( sql + " AND bills.payer_id <> #{self.id}" )
    end
  end


  attr_accessor :ower_id
  
  def deptors_and_creditors
    @deptors_and_creditors ||= Person.find_by_sql <<-SQL
      SELECT people.*, SUM(IF(participations.participant_id=#{self.id},-participations.amount,participations.amount)) AS owed
      FROM people
      JOIN participations
      ON (participations.participant_id = people.id AND participations.payer_id = #{self.id})
      OR (participations.payer_id = people.id AND participations.participant_ID = #{self.id})
      WHERE participations.currency_id = #{self.currency_id} AND people.id <> #{self.id}
      GROUP BY people.id
      ORDER BY people.name
    SQL
    logger.debug 'deptors_and_creditors:'
    for person in @deptors_and_creditors
      person.ower_id = self.id
      logger.debug person.inspect
      logger.debug person.owed
    end
    
    
    return @deptors_and_creditors
  end

#  def participants( options={} )
#    @deptors ||= {}
#    return @deptors[options[:include_self]] ||= Person.find_by_sql( participants_sql( options ) )
#  end
#
#  def payers( options={} )
#    @creditors ||= {}
#    return @creditors[options[:include_self]] ||= Person.find_by_sql( payers_sql( options ) )
#  end

  def amount_owed_to( other_person_id, currency_id )
    @amount_owed_to ||= {}
    return @amount_owed_to[other_person_id] if @amount_owed_to[other_person_id]
    
    res = 0.0
    if( self.ower_id and self.ower_id == other_person_id )
      # puts "amount_owed_to( #{other_person_id} ): from SQL: self.owed = #{self.owed}"
      res = self.owed.to_f # from SQL request
    else
      # puts "amount_owed_to( #{other_person_id} ): calculating"
      my_participations =            Participation.find( :all, :joins => [:bill], :conditions => ['participant_id = ? AND bills.payer_id = ? AND bills.currency_id = ?', self.id, other_person_id, currency_id] )
      other_persons_participations = Participation.find( :all, :joins => [:bill], :conditions => ['participant_id = ? AND bills.payer_id = ? AND bills.currency_id = ?', other_person_id, self.id, currency_id] )
  
      for p in my_participations
        # puts "my_participation:            bill: #{p.bill.name} amount:#{p.amount}"
        res += p.amount
      end
      for p in other_persons_participations
        # puts "other_persons_participation: bill: #{p.bill.name} amount: #{p.amount}"
        res -= p.amount
      end
    end
    
    return @amount_owed_to[other_person_id] = res
  end

  def balance
    return @balance if @balance
    
    balance_string = read_attribute( :balance )
    if balance_string and balance_string != ''
      @balance = balance_string.to_f
      logger.debug "balance: read from db: #{@balance} (balance_string = #{balance_string.inspect})"
    else
      logger.debug "balance: calculating (balance_string = #{balance_string.inspect})"
      @balance = 0.0
      for p in participations
        @balance -= p.amount
      end
      
      for bill in payed_bills
        @balance += bill.amount
      end
      @balance = @balance.round_to(2)
    end
    
    return @balance
  end

private
  def participants_sql( options={} )
    "SELECT DISTINCT p1.*
     FROM people AS p1
     JOIN participations ON participations.participant_id = p1.id
     JOIN bills ON bills.id = participations.bill_id
     JOIN people AS me ON me.id = bills.payer_id AND participations.currency_id = me.currency_id
     WHERE me.id = #{self.id}" + ( options[:include_self] ? '' : " AND p1.id <> #{self.id}" )
  end

  def payers_sql( options={} )
    "SELECT DISTINCT p2.*
     FROM people AS me
     JOIN participations ON participations.participant_id = me.id AND participations.currency_id = me.currency_id
     JOIN bills ON bills.id = participations.bill_id
     JOIN people AS p2 ON p2.id = bills.payer_id
     WHERE me.id = #{self.id}" + ( options[:include_self] ? '' : " AND p2.id <> #{self.id}" )
  end    

# methods of auth system:

public
  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  def self.authenticate( email_or_name, password )
    u = find( :first, :conditions => ["( email = ? )", email_or_name] ) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  # Encrypts some data with the salt.
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end

  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end

  def authenticated?(password)
    crypted_password == encrypt(password)
  end

  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at 
  end

  # These create and unset the fields required for remembering users between browser closes
  def remember_me
    self.remember_token_expires_at = 2.weeks.from_now.utc
    self.remember_token            = encrypt("#{email}--#{remember_token_expires_at}")
    save(false)
  end

  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    save(false)
  end

  protected
    # before filter 
    def encrypt_password
      return if password.blank?
      self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{name}--") if new_record?
      self.crypted_password = encrypt(password)
    end
    
    def password_required?
      # crypted_password.blank? || !password.blank?
      !password.blank?
    end
end
