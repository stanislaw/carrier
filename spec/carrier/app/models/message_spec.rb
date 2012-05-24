require 'dummy_spec_helper'

describe Carrier::Message do
  describe 'Carrier::Message class' do
    subject {Carrier::Message}
    its(:table_name) { should == Carrier.config.models.table_for(:message) }
     
    describe "#find_recipients" do
      it "should return all recipients" do
        pending
      end
    end
  end 
  
  [:chain, :sender_user].each do |as| 
    it { should belong_to(as) }
  end

  it "should serialize .recipients field" do
    subject.recipients.should == []
  end

  context "#recipients_names" do
    it "should return recipients names joined by ', '" do
      message = singleton :message
      message.recipients_names.should == "miloviza, marixa"
    end
  end

end
