require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ChoicesController do
  
     def sign_in_as(user)
       @controller.current_user = user
       return user
     end
  #   
     before(:each) do
       sign_in_as(@user = Factory(:email_confirmed_user))
     end
  # 
     def mock_question(stubs={})
       @mock_question ||= mock_model(Question, stubs)
     end
     
     def mock_prompt(stubs={})
       @mock_prompt ||= mock_model(Prompt, stubs)
     end
     
     def mock_appearance(stubs={})
       @mock_appearance||= mock_model(Appearance, stubs)
     end
     
     def mock_visitor(stubs={})
       @mock_visitor||= mock_model(Visitor, stubs)
     end
     
     def mock_choice(stubs={})
       @mock_choice||= mock_model(Choice, stubs)
     end
     
     def mock_flag(stubs={})
       @mock_flag ||= mock_model(Flag, stubs)
     end
     
     describe "PUT flag" do
       before(:each) do
	  question_list = [mock_question]
	  @user.stub!(:questions).and_return(question_list)
	  question_list.stub!(:find).with("37").and_return(mock_question)

	  choice_list = [mock_choice]
	  mock_question.stub!(:choices).and_return(choice_list)
	  choice_list.stub!(:find).with("123").and_return(mock_choice)
	  mock_choice.should_receive(:deactivate!).and_return(true)


       end

       it "deactives a choice when a flag request is sent" do
	    Flag.should_receive(:create!).with({:choice_id => 123, :question_id => 37, :site_id => @user.id})
	    put :flag, :id => 123, :question_id => 37   

	    assigns[:choice].should == mock_choice
       end
       
       it "adds explanation params to flag if sent" do
	    Flag.should_receive(:create!).with({:choice_id => 123, :question_id => 37, :site_id => @user.id, :explanation => "This is offensive"})
	    put :flag, :id => 123, :question_id => 37 , :explanation => "This is offensive"

	    assigns[:choice].should == mock_choice
       end
       
       it "adds visitor_id params to flag if sent" do
	    @visitor_identifier = "somelongunique32charstring"
	    visitor_list = [mock_visitor]
            @user.stub!(:visitors).and_return(visitor_list)
            visitor_list.should_receive(:find_or_create_by_identifier).with(@visitor_identifier).and_return(mock_visitor)

	    Flag.should_receive(:create!).with({:choice_id => 123, :question_id => 37, :site_id => @user.id, :explanation => "This is offensive", :visitor_id => mock_visitor.id})   

	    put :flag, :id => 123, :question_id => 37 , :explanation => "This is offensive", :visitor_identifier => @visitor_identifier

	    assigns[:choice].should == mock_choice
       end
     end
  
end
