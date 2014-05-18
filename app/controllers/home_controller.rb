class HomeController < ApplicationController

  def index
    # The user's personal group (user_group) is the only group with both their ID, and a null group_id
    @user_group = Group.where(:user_id => session[:user_id], :group_id => [false, nil]).first! # First ensures a single record

    # Gather all groups and forms that belong to the user_group into instance variables
    @groups = Group.where(:group_id => @user_group.id)
    @forms = Form.where(:group_id => @user_group.id)
    
  end
  
end
