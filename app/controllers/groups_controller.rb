class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :edit, :update, :destroy]


  # GET /groups
  def index
    # The user's personal group (user_group) is the only group with both their ID, and a null group_id
    @user_group = Group.where(:user_id => session[:user_id], :group_id => [false, nil]).first! # First ensures a single record
    redirect_to(@user_group)
  end

  # GET /groups/1
  def show
    @groups = Group.where(:group_id => params[:id])
    @forms = Form.where(:group_id => params[:id])
  end

  # GET /groups/new
  def new
    @group = Group.new
    @group.group_id = params[:group_id]
    @group.user_id = session[:user_id]
  end

  # GET /groups/1/edit
  def edit
  end

  # POST /groups
  def create
    @group = Group.new(group_params)
    @group.group_id = params[:group_id]
    @group.user_id = session[:user_id]
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
      params.require(:group).permit(:user_id, :group_id, :name)
    end
end
