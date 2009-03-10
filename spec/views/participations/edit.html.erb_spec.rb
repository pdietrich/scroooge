require File.dirname(__FILE__) + '/../../spec_helper'

describe "/participations/edit.html.erb" do
  include ParticipationsHelper
  
  before do
    @participation = mock_model(Participation)
    @participation.stub!(:bill_id).and_return("1")
    @participation.stub!(:participant_id).and_return("1")
    @participation.stub!(:factor).and_return("1")
    @participation.stub!(:creator_id).and_return("1")
    @participation.stub!(:created_at).and_return(Time.now)
    @participation.stub!(:updated_at).and_return(Time.now)
    assigns[:participation] = @participation
  end

  it "should render edit form" do
    render "/participations/edit.html.erb"
    
    response.should have_tag("form[action=#{participation_path(@participation)}][method=post]") do
      with_tag('input#participation_factor[name=?]', "participation[factor]")
    end
  end
end


