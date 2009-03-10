require File.dirname(__FILE__) + '/../spec_helper'

describe CurrenciesController do
  describe "handling GET /currencies" do

    before(:each) do
      @currency = mock_model(Currency)
      Currency.stub!(:find).and_return([@currency])
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
  
    it "should find all currencies" do
      Currency.should_receive(:find).with(:all).and_return([@currency])
      do_get
    end
  
    it "should assign the found currencies for the view" do
      do_get
      assigns[:currencies].should == [@currency]
    end
  end

  describe "handling GET /currencies.xml" do

    before(:each) do
      @currency = mock_model(Currency, :to_xml => "XML")
      Currency.stub!(:find).and_return(@currency)
    end
  
    def do_get
      @request.env["HTTP_ACCEPT"] = "application/xml"
      get :index
    end
  
    it "should be successful" do
      do_get
      response.should be_success
    end

    it "should find all currencies" do
      Currency.should_receive(:find).with(:all).and_return([@currency])
      do_get
    end
  
    it "should render the found currencies as xml" do
      @currency.should_receive(:to_xml).and_return("XML")
      do_get
      response.body.should == "XML"
    end
  end

  describe "handling GET /currencies/1" do

    before(:each) do
      @currency = mock_model(Currency)
      Currency.stub!(:find).and_return(@currency)
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
  
    it "should find the currency requested" do
      Currency.should_receive(:find).with("1").and_return(@currency)
      do_get
    end
  
    it "should assign the found currency for the view" do
      do_get
      assigns[:currency].should equal(@currency)
    end
  end

  describe "handling GET /currencies/1.xml" do

    before(:each) do
      @currency = mock_model(Currency, :to_xml => "XML")
      Currency.stub!(:find).and_return(@currency)
    end
  
    def do_get
      @request.env["HTTP_ACCEPT"] = "application/xml"
      get :show, :id => "1"
    end

    it "should be successful" do
      do_get
      response.should be_success
    end
  
    it "should find the currency requested" do
      Currency.should_receive(:find).with("1").and_return(@currency)
      do_get
    end
  
    it "should render the found currency as xml" do
      @currency.should_receive(:to_xml).and_return("XML")
      do_get
      response.body.should == "XML"
    end
  end

  describe "handling GET /currencies/new" do

    before(:each) do
      @currency = mock_model(Currency)
      Currency.stub!(:new).and_return(@currency)
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
  
    it "should create an new currency" do
      Currency.should_receive(:new).and_return(@currency)
      do_get
    end
  
    it "should not save the new currency" do
      @currency.should_not_receive(:save)
      do_get
    end
  
    it "should assign the new currency for the view" do
      do_get
      assigns[:currency].should equal(@currency)
    end
  end

  describe "handling GET /currencies/1/edit" do

    before(:each) do
      @currency = mock_model(Currency)
      Currency.stub!(:find).and_return(@currency)
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
  
    it "should find the currency requested" do
      Currency.should_receive(:find).and_return(@currency)
      do_get
    end
  
    it "should assign the found Currency for the view" do
      do_get
      assigns[:currency].should equal(@currency)
    end
  end

  describe "handling POST /currencies" do

    before(:each) do
      @currency = mock_model(Currency, :to_param => "1")
      Currency.stub!(:new).and_return(@currency)
    end
    
    describe "with successful save" do
  
      def do_post
        @currency.should_receive(:save).and_return(true)
        post :create, :currency => {}
      end
  
      it "should create a new currency" do
        Currency.should_receive(:new).with({}).and_return(@currency)
        do_post
      end

      it "should redirect to the new currency" do
        do_post
        response.should redirect_to(currency_url("1"))
      end
      
    end
    
    describe "with failed save" do

      def do_post
        @currency.should_receive(:save).and_return(false)
        post :create, :currency => {}
      end
  
      it "should re-render 'new'" do
        do_post
        response.should render_template('new')
      end
      
    end
  end

  describe "handling PUT /currencies/1" do

    before(:each) do
      @currency = mock_model(Currency, :to_param => "1")
      Currency.stub!(:find).and_return(@currency)
    end
    
    describe "with successful update" do

      def do_put
        @currency.should_receive(:update_attributes).and_return(true)
        put :update, :id => "1"
      end

      it "should find the currency requested" do
        Currency.should_receive(:find).with("1").and_return(@currency)
        do_put
      end

      it "should update the found currency" do
        do_put
        assigns(:currency).should equal(@currency)
      end

      it "should assign the found currency for the view" do
        do_put
        assigns(:currency).should equal(@currency)
      end

      it "should redirect to the currency" do
        do_put
        response.should redirect_to(currency_url("1"))
      end

    end
    
    describe "with failed update" do

      def do_put
        @currency.should_receive(:update_attributes).and_return(false)
        put :update, :id => "1"
      end

      it "should re-render 'edit'" do
        do_put
        response.should render_template('edit')
      end

    end
  end

  describe "handling DELETE /currencies/1" do

    before(:each) do
      @currency = mock_model(Currency, :destroy => true)
      Currency.stub!(:find).and_return(@currency)
    end
  
    def do_delete
      delete :destroy, :id => "1"
    end

    it "should find the currency requested" do
      Currency.should_receive(:find).with("1").and_return(@currency)
      do_delete
    end
  
    it "should call destroy on the found currency" do
      @currency.should_receive(:destroy)
      do_delete
    end
  
    it "should redirect to the currencies list" do
      do_delete
      response.should redirect_to(currencies_url)
    end
  end
end