require File.dirname(__FILE__) + '/../spec_helper'

describe ParticipationsController do
  describe "handling GET /participations" do

    before(:each) do
      @participation = mock_model(Participation)
      Participation.stub!(:find).and_return([@participation])
    end
  
    def do_get
      get :index
    end
  
    it "should be successful" do
      do_get
      response.should be_success
    end

    it "should render index template" do
      do_get
      response.should render_template('index')
    end
  
    it "should find all participations" do
      Participation.should_receive(:find).with(:all).and_return([@participation])
      do_get
    end
  
    it "should assign the found participations for the view" do
      do_get
      assigns[:participations].should == [@participation]
    end
  end

  describe "handling GET /participations.xml" do

    before(:each) do
      @participation = mock_model(Participation, :to_xml => "XML")
      Participation.stub!(:find).and_return(@participation)
    end
  
    def do_get
      @request.env["HTTP_ACCEPT"] = "application/xml"
      get :index
    end
  
    it "should be successful" do
      do_get
      response.should be_success
    end

    it "should find all participations" do
      Participation.should_receive(:find).with(:all).and_return([@participation])
      do_get
    end
  
    it "should render the found participations as xml" do
      @participation.should_receive(:to_xml).and_return("XML")
      do_get
      response.body.should == "XML"
    end
  end

  describe "handling GET /participations/1" do

    before(:each) do
      @participation = mock_model(Participation)
      Participation.stub!(:find).and_return(@participation)
    end
  
    def do_get
      get :show, :id => "1"
    end

    it "should be successful" do
      do_get
      response.should be_success
    end
  
    it "should render show template" do
      do_get
      response.should render_template('show')
    end
  
    it "should find the participation requested" do
      Participation.should_receive(:find).with("1").and_return(@participation)
      do_get
    end
  
    it "should assign the found participation for the view" do
      do_get
      assigns[:participation].should equal(@participation)
    end
  end

  describe "handling GET /participations/1.xml" do

    before(:each) do
      @participation = mock_model(Participation, :to_xml => "XML")
      Participation.stub!(:find).and_return(@participation)
    end
  
    def do_get
      @request.env["HTTP_ACCEPT"] = "application/xml"
      get :show, :id => "1"
    end

    it "should be successful" do
      do_get
      response.should be_success
    end
  
    it "should find the participation requested" do
      Participation.should_receive(:find).with("1").and_return(@participation)
      do_get
    end
  
    it "should render the found participation as xml" do
      @participation.should_receive(:to_xml).and_return("XML")
      do_get
      response.body.should == "XML"
    end
  end

  describe "handling GET /participations/new" do

    before(:each) do
      @participation = mock_model(Participation)
      Participation.stub!(:new).and_return(@participation)
    end
  
    def do_get
      get :new
    end

    it "should be successful" do
      do_get
      response.should be_success
    end
  
    it "should render new template" do
      do_get
      response.should render_template('new')
    end
  
    it "should create an new participation" do
      Participation.should_receive(:new).and_return(@participation)
      do_get
    end
  
    it "should not save the new participation" do
      @participation.should_not_receive(:save)
      do_get
    end
  
    it "should assign the new participation for the view" do
      do_get
      assigns[:participation].should equal(@participation)
    end
  end

  describe "handling GET /participations/1/edit" do

    before(:each) do
      @participation = mock_model(Participation)
      Participation.stub!(:find).and_return(@participation)
    end
  
    def do_get
      get :edit, :id => "1"
    end

    it "should be successful" do
      do_get
      response.should be_success
    end
  
    it "should render edit template" do
      do_get
      response.should render_template('edit')
    end
  
    it "should find the participation requested" do
      Participation.should_receive(:find).and_return(@participation)
      do_get
    end
  
    it "should assign the found Participation for the view" do
      do_get
      assigns[:participation].should equal(@participation)
    end
  end

  describe "handling POST /participations" do

    before(:each) do
      @participation = mock_model(Participation, :to_param => "1")
      Participation.stub!(:new).and_return(@participation)
    end
    
    describe "with successful save" do
  
      def do_post
        @participation.should_receive(:save).and_return(true)
        post :create, :participation => {}
      end
  
      it "should create a new participation" do
        Participation.should_receive(:new).with({}).and_return(@participation)
        do_post
      end

      it "should redirect to the new participation" do
        do_post
        response.should redirect_to(participation_url("1"))
      end
      
    end
    
    describe "with failed save" do

      def do_post
        @participation.should_receive(:save).and_return(false)
        post :create, :participation => {}
      end
  
      it "should re-render 'new'" do
        do_post
        response.should render_template('new')
      end
      
    end
  end

  describe "handling PUT /participations/1" do

    before(:each) do
      @participation = mock_model(Participation, :to_param => "1")
      Participation.stub!(:find).and_return(@participation)
    end
    
    describe "with successful update" do

      def do_put
        @participation.should_receive(:update_attributes).and_return(true)
        put :update, :id => "1"
      end

      it "should find the participation requested" do
        Participation.should_receive(:find).with("1").and_return(@participation)
        do_put
      end

      it "should update the found participation" do
        do_put
        assigns(:participation).should equal(@participation)
      end

      it "should assign the found participation for the view" do
        do_put
        assigns(:participation).should equal(@participation)
      end

      it "should redirect to the participation" do
        do_put
        response.should redirect_to(participation_url("1"))
      end

    end
    
    describe "with failed update" do

      def do_put
        @participation.should_receive(:update_attributes).and_return(false)
        put :update, :id => "1"
      end

      it "should re-render 'edit'" do
        do_put
        response.should render_template('edit')
      end

    end
  end

  describe "handling DELETE /participations/1" do

    before(:each) do
      @participation = mock_model(Participation, :destroy => true)
      Participation.stub!(:find).and_return(@participation)
    end
  
    def do_delete
      delete :destroy, :id => "1"
    end

    it "should find the participation requested" do
      Participation.should_receive(:find).with("1").and_return(@participation)
      do_delete
    end
  
    it "should call destroy on the found participation" do
      @participation.should_receive(:destroy)
      do_delete
    end
  
    it "should redirect to the participations list" do
      do_delete
      response.should redirect_to(participations_url)
    end
  end
end