class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :edit, :update, :destroy]
  skip_before_filter :require_login, except: [:index, :show]

  # GET /groups
  def index
    if logged_in?
      # The user's personal group (user_group) is the only group with both their ID, and a null group_id
      @user_group = Group.where(:owner_id => session[:user_id], :parent_id => [false, nil]).first! # First ensures a single record
      redirect_to :action => 'show', :id => @user_group.id
    else
      # If a user is not logged in, the Group index will show all user's personal groups.
      @top_level_groups = Group.where(:parent_id => [false, nil])
    end
  end

  # GET /groups/1
  def show
  end

  # GET /groups/new
  def new
    @group = Group.new
    @group.parent_id = params[:parent_id]
    @group.owner = @group.parent.owner
    unless can_edit?
      redirect_to group_url(@group.parent), notice: "I'm sorry Dave, I can't let you do that."
    end
  end

  # GET /groups/1/edit
  def edit
    @user ||= current_user
    get_permission_variables
    unless can_edit?
      redirect_to group_url(@group), notice: "I'm sorry Dave, I can't let you do that."
    end
  end

  # POST /groups
  def create
    @group = Group.new(group_params)
    @group.parent_id = params[:parent_id]
    @group.owner = @group.parent.owner
    unless can_edit?
      redirect_to group_url(@group.parent), notice: "I'm sorry Dave, I can't let you do that."
    end
    if @group.save
      redirect_to @group, notice: 'Group was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /groups/1
  def update
    unless can_edit?
      redirect_to group_url(@group), notice: "I'm sorry Dave, I can't let you do that."
    else
      if (is_moderator? || is_super?)
        if !params[:new_editor_id].blank? then @group.permissions.create(:user_id => params[:new_editor_id], :group_id => @group.id, :role_rank => 1) end
        if !params[:new_moderator_id].blank? then @group.permissions.create(:user_id => params[:new_moderator_id], :group_id => @group.id, :role_rank => 0) end
      end
      get_permission_variables
      if @group.update(group_params)
        redirect_to edit_group_url(@group), notice: 'Group was successfully updated.'
      else
        redirect_to edit_group_url(@group), notice: 'Something went wrong!'
      end
    end
  end

  # DELETE /groups/1
  def destroy
    unless (can_delete? && !@group.parent.nil?)
      redirect_to group_url(@group), notice: "I'm sorry Dave, I can't let you do that."
    else
      @redirect = @group.parent
      @group.destroy
      redirect_to group_url(@redirect), notice: 'Group was successfully deleted.'
    end
  end

  def remove_permission
    @group = Group.find(params[:id])
    unless can_edit?
      redirect_to edit_group_url(@group), notice: "I'm sorry Dave, I can't let you do that."
    else
      @user = User.find(params[:remove_id])
      @permission = Permission.where(:user => @user, :group => @group)
      @permission.destroy_all
      get_permission_variables
      redirect_to edit_group_url(@group)
    end
  end

  def add_permission
    @group = Group.find(params[:id])
    unless is_moderator? || is_super?
      redirect_to edit_group_url(@group), notice: "I'm sorry Dave, I can't let you do that."
    else
      if !params[:new_editor_id].blank?
        @group.permissions.create(:user_id => params[:new_editor_id], :group_id => @group.id, :role_rank => 1) 
      end
      if !params[:new_moderator_id].blank?
        @group.permissions.create(:user_id => params[:new_moderator_id], :group_id => @group.id, :role_rank => 0)
      end
      get_permission_variables
      redirect_to edit_group_url(@group)
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def group_params
      params.require(:group).permit(:owner_id, :parent_id, :name, :permissions)
    end

    def get_permission_variables
      @moderators = @group.moderators
      @editors = @group.editors
      @users = User.all
      @users = @users.reject{ |r| @moderators.include? r }
      @users = @users.reject{ |r| @editors.include? r }
      @options = @users.map{ |u| [u.username, u.id] }
    end
end
