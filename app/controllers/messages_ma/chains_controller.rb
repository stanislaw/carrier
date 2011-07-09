# encoding: UTF-8
module MessagesMa
  class ChainsController < ApplicationController
    def archive
      @chain = Chain.find(params[:chain_id])
      @user = User.find(params[:user_id])
      @chain.archive_for!(@user)
      respond_to do |format|
        format.js
      end
    end

    def unarchive
      @chain = Chain.find(params[:chain_id])
      @user = User.find(params[:user_id])
      @chain.unarchive_for!(@user)
      respond_to do |format|
        format.js
      end
    end
  end
end
