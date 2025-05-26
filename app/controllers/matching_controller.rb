class MatchingController < ApplicationController

  before_action :authenticate_user!

  def index
    @match_users = current_user
    @user = User.find(current_user.id)
  end
end
