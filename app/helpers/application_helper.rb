# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def container( &block )
    start = <<-HTML
      <div class="pd_container">
        <div class="pd_containerTop"></div>
        <div class="pd_containerContent">
    HTML
    stop = <<-HTML
        </div>
        <div class="pd_containerBottom"></div>
      </div>
    HTML
    
    concat( start, block.binding )
    concat( capture( &block ), block.binding )
    concat( stop, block.binding )
  end
  
  def price( amount, options = {} )
    currency = options[:currency]
    currency ||= $current_currency # this needs to be accessible from the mailer  model # current_person.currency
    
    res = number_to_currency( amount, currency.format_options )
    
    unless options[:no_colour]
      res = '<span class="' + ( amount < 0 ? 'minus' : 'plus' ) + '">' + res + '</span>'
    end
    
    return res
  end
  
  def bill_list( bills )
    res = ''
    for bill in bills
      creation_time = bill.created_at
      res += render :partial => 'bills/list_item', :locals => { :date => "#{bill.created_at.day}/#{bill.created_at.month}/#{bill.created_at.year}", :description => h(bill.name), :total_amount => price( bill.amount, :currency => bill.currency, :no_colour => true ), :amount => price( bill.amount_for( current_person ), :currency => bill.currency ) }
    end
    return res
  end
  
  # def friends
  #     Person.find(:all, :order => "name")
  #   end
  # 
  
  def friend_select_box( options )
    res = "<select id=\"#{options[:name]}\" name=\"#{options[:name]}\">\n"
    res += "\t<option>#{options[:blank_text]||''}</option>\n" if options[:blank] 
    for p in current_person.known_people
      res += <<-HTML
        <option value="#{p.id}" class="#{p.grade}" style="background-image:url(#{ p.gravatar_url( :size => 20) })" #{options[:selected] == p.id ? 'selected="selected"' : ''}>
              #{p.name}
        </option>
      HTML
    end
    res += "</select>"
  end
  
  def people_select_box( f, method, html_options = {} )
    html_options[:class] ||= 'autoselect'
    
    f.select( method, current_person.known_people.map{|p| [p.name, p.id]}, {:include_blank => true}, html_options )
  end

#  def people_select_box( html_options = {} )
#    html_options[:class] ||= 'autoselect'
#    
#    select( :person, :id, current_person.known_people.map{|p| [p.name, p.id]}, {:include_blank => true}, html_options )
#  end

  
  def table_error_message_on( object, method )
    obj = ( object.respond_to?(:errors) ? object : instance_variable_get("@#{object}") )
    errors = obj.errors.on( method )
    
    if obj && errors
      return render( :partial => 'layouts/table_error_message', :locals => { :error_message => (errors.is_a?(Array) ? errors.first : errors) } )
    else
      return ''
    end
  end
  
end
