require File.dirname(__FILE__) + '/../spec_helper'

describe CurrenciesController do
  describe "route generation" do

    it "should map { :controller => 'currencies', :action => 'index' } to /currencies" do
      route_for(:controller => "currencies", :action => "index").should == "/currencies"
    end
  
    it "should map { :controller => 'currencies', :action => 'new' } to /currencies/new" do
      route_for(:controller => "currencies", :action => "new").should == "/currencies/new"
    end
  
    it "should map { :controller => 'currencies', :action => 'show', :id => 1 } to /currencies/1" do
      route_for(:controller => "currencies", :action => "show", :id => 1).should == "/currencies/1"
    end
  
    it "should map { :controller => 'currencies', :action => 'edit', :id => 1 } to /currencies/1/edit" do
      route_for(:controller => "currencies", :action => "edit", :id => 1).should == "/currencies/1/edit"
    end
  
    it "should map { :controller => 'currencies', :action => 'update', :id => 1} to /currencies/1" do
      route_for(:controller => "currencies", :action => "update", :id => 1).should == "/currencies/1"
    end
  
    it "should map { :controller => 'currencies', :action => 'destroy', :id => 1} to /currencies/1" do
      route_for(:controller => "currencies", :action => "destroy", :id => 1).should == "/currencies/1"
    end
  end

  describe "route recognition" do

    it "should generate params { :controller => 'currencies', action => 'index' } from GET /currencies" do
      params_from(:get, "/currencies").should == {:controller => "currencies", :action => "index"}
    end
  
    it "should generate params { :controller => 'currencies', action => 'new' } from GET /currencies/new" do
      params_from(:get, "/currencies/new").should == {:controller => "currencies", :action => "new"}
    end
  
    it "should generate params { :controller => 'currencies', action => 'create' } from POST /currencies" do
      params_from(:post, "/currencies").should == {:controller => "currencies", :action => "create"}
    end
  
    it "should generate params { :controller => 'currencies', action => 'show', id => '1' } from GET /currencies/1" do
      params_from(:get, "/currencies/1").should == {:controller => "currencies", :action => "show", :id => "1"}
    end
  
    it "should generate params { :controller => 'currencies', action => 'edit', id => '1' } from GET /currencies/1;edit" do
      params_from(:get, "/currencies/1/edit").should == {:controller => "currencies", :action => "edit", :id => "1"}
    end
  
    it "should generate params { :controller => 'currencies', action => 'update', id => '1' } from PUT /currencies/1" do
      params_from(:put, "/currencies/1").should == {:controller => "currencies", :action => "update", :id => "1"}
    end
  
    it "should generate params { :controller => 'currencies', action => 'destroy', id => '1' } from DELETE /currencies/1" do
      params_from(:delete, "/currencies/1").should == {:controller => "currencies", :action => "destroy", :id => "1"}
    end
  end
end