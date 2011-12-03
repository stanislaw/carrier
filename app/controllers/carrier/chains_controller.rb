# encoding: UTF-8
module Carrier
  class ChainsController < Carrier::ApplicationController

    before_filter :only => %w[archive unarchive] do
      @user = User.send find_method_for_user, params[:user_id]
      @chain = Carrier::Chain.find(params[:chain_id])
    end
    
    def archive
      @chain.archive_for!(@user)
    end

    def unarchive
      @chain.unarchive_for!(@user)
    end
  end
end
