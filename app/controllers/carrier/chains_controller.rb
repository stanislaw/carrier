# encoding: UTF-8
module Carrier
  class ChainsController < ApplicationController
    def archive
      @chain = Chain.find(params[:chain_id])
      @user = User.find(params[:user_id])
      @chain.archive_for!(@user)
    end

    def unarchive
      @chain = Chain.find(params[:chain_id])
      @user = User.find(params[:user_id])
      @chain.unarchive_for!(@user)
    end
  end
end
