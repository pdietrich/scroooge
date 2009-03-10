require File.dirname(__FILE__) + '/../../spec_helper'

describe "/participations/new.html.erb" do
  include ParticipationsHelper
  
  before(:each) do
    @participation = mock_model(Participation)
    @participation.stub!(:new_record?).and_return(true)
    @participation.stub!(:bill_id).and_return("1")
    @participation.stub!(:participant_id).and_return("1")
    @participation.stub!(:factor).and_return("1")
    @participation.stub!(:creator_id).and_return("1")
    @participation.stub!(:created_at).and_return(Time.now)
    @participation.stub!(:updated_at).and_return(Time.now)
    assigns[:participation] = @participation
  end

  it "should render new form" do
    render "/participations/new.html.erb"
    
    response.should have_tag("form[action=?][method=post]", participations_path) do
      with_tag("input#participation_factor[name=?]", "participation[factor]")
    end
  end
end


