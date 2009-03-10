require File.dirname(__FILE__) + '/../../spec_helper'

describe "/participations/index.html.erb" do
  include ParticipationsHelper
  
  before(:each) do
    participation_98 = mock_model(Participation)
    participation_98.should_receive(:bill_id).and_return("1")
    participation_98.should_receive(:participant_id).and_return("1")
    participation_98.should_receive(:factor).and_return("1")
    participation_98.should_receive(:creator_id).and_return("1")
    participation_98.should_receive(:created_at).and_return(Time.now)
    participation_98.should_receive(:updated_at).and_return(Time.now)
    participation_99 = mock_model(Participation)
    participation_99.should_receive(:bill_id).and_return("1")
    participation_99.should_receive(:participant_id).and_return("1")
    participation_99.should_receive(:factor).and_return("1")
    participation_99.should_receive(:creator_id).and_return("1")
    participation_99.should_receive(:created_at).and_return(Time.now)
    participation_99.should_receive(:updated_at).and_return(Time.now)

    assigns[:participations] = [participation_98, participation_99]
  end

  it "should render list of participations" do
    render "/participations/index.html.erb"
    response.should have_tag("tr>td", "1", 2)
  end
end

