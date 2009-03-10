require File.dirname(__FILE__) + '/../spec_helper'

describe ParticipationsController do
  describe "route generation" do

    it "should map { :controller => 'participations', :action => 'index' } to /participations" do
      route_for(:controller => "participations", :action => "index").should == "/participations"
    end
  
    it "should map { :controller => 'participations', :action => 'new' } to /participations/new" do
      route_for(:controller => "participations", :action => "new").should == "/participations/new"
    end
  
    it "should map { :controller => 'participations', :action => 'show', :id => 1 } to /participations/1" do
      route_for(:controller => "participations", :action => "show", :id => 1).should == "/participations/1"
    end
  
    it "should map { :controller => 'participations', :action => 'edit', :id => 1 } to /participations/1/edit" do
      route_for(:controller => "participations", :action => "edit", :id => 1).should == "/participations/1/edit"
    end
  
    it "should map { :controller => 'participations', :action => 'update', :id => 1} to /participations/1" do
      route_for(:controller => "participations", :action => "update", :id => 1).should == "/participations/1"
    end
  
    it "should map { :controller => 'participations', :action => 'destroy', :id => 1} to /participations/1" do
      route_for(:controller => "participations", :action => "destroy", :id => 1).should == "/participations/1"
    end
  end

  describe "route recognition" do

    it "should generate params { :controller => 'participations', action => 'index' } from GET /participations" do
      params_from(:get, "/participations").should == {:controller => "participations", :action => "index"}
    end
  
    it "should generate params { :controller => 'participations', action => 'new' } from GET /participations/new" do
      params_from(:get, "/participations/new").should == {:controller => "participations", :action => "new"}
    end
  
    it "should generate params { :controller => 'participations', action => 'create' } from POST /participations" do
      params_from(:post, "/participations").should == {:controller => "participations", :action => "create"}
    end
  
    it "should generate params { :controller => 'participations', action => 'show', id => '1' } from GET /participations/1" do
      params_from(:get, "/participations/1").should == {:controller => "participations", :action => "show", :id => "1"}
    end
  
    it "should generate params { :controller => 'participations', action => 'edit', id => '1' } from GET /participations/1;edit" do
      params_from(:get, "/participations/1/edit").should == {:controller => "participations", :action => "edit", :id => "1"}
    end
  
    it "should generate params { :controller => 'participations', action => 'update', id => '1' } from PUT /participations/1" do
      params_from(:put, "/participations/1").should == {:controller => "participations", :action => "update", :id => "1"}
    end
  
    it "should generate params { :controller => 'participations', action => 'destroy', id => '1' } from DELETE /participations/1" do
      params_from(:delete, "/participations/1").should == {:controller => "participations", :action => "destroy", :id => "1"}
    end
  end
end