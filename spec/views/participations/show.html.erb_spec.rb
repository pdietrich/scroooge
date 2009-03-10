require File.dirname(__FILE__) + '/../../spec_helper'

describe "/participations/show.html.erb" do
  include ParticipationsHelper
  
  before(:each) do
    @participation = mock_model(Participation)
    @participation.stub!(:bill_id).and_return("1")
    @participation.stub!(:participant_id).and_return("1")
    @participation.stub!(:factor).and_return("1")
    @participation.stub!(:creator_id).and_return("1")
    @participation.stub!(:created_at).and_return(Time.now)
    @participation.stub!(:updated_at).and_return(Time.now)

    assigns[:participation] = @participation
  end

  it "should render attributes in <p>" do
    render "/participations/show.html.erb"
    response.should have_text(/1/)
  end
end

