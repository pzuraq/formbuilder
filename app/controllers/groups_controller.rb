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
  end

  # GET /groups/1/edit
  def edit
  end

  # POST /groups
  def create
    @group = Group.new(group_params)
    @group.parent_id = params[:parent_id]
    @group.owner = @group.parent.owner
    if @group.save
      redirect_to @group, notice: 'Group was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /groups/1
  def update
    if @group.update(group_params)
      redirect_to @group, notice: 'Group was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /groups/1
  def destroy
    @group.destroy
    redirect_to groups_url, notice: 'Group was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def group_params
      params.require(:group).permit(:owner_id, :parent_id, :name)
    end
end
