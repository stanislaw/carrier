Message = Carrier::Message
Chain = Carrier::Chain

describe Carrier::Message do
  context "Scopes" do

    let(:user) do
      singleton(:user)
    end
    
    specify {
      Message.count.should == 0
      Chain.count.should == 0
      Message.for_or_by(user).size.should == 0
      
      create(:message, :sender_user => user)
      
      Message.for(user).size.should == 0
      Message.by(user).size.should == 1
      Message.for_or_by(user).size.should == 1

      create(:second_message)
      
      Message.for(user).size.should == 1
      Message.by(user).size.should == 1
      Message.for_or_by(user).size.should == 2
    }
  end
end
