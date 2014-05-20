class FormsController < ApplicationController
  before_action :set_form, only: [:show, :edit, :update, :destroy]

  # GET /forms
  def index
    @forms = Form.all
  end

  # GET /forms/1
  def show
  end

  # GET /forms/new
  def new
    @form = Form.new
    @form.group_id = params[:group_id]
    @form.owner_id = session[:user_id]
  end

  # GET /forms/1/edit
  def edit
  end

  # POST /forms
  def create
    @form = Form.new(form_params)
    @form.group_id = params[:group_id]
    @form.owner_id = @form.group.owner_id

    unless @form.group.moderators.find(current_user)
      redirect_to group_url(@form.group), notice: "I'm sorry Dave, I can't let you do that."
    end
      
    if @form.save
      redirect_to [@form.group,@form], notice: 'Form was successfully created.'
    else
      render :new
    end    
  end

  # PATCH/PUT /forms/1
  def update
    if @form.update(form_params)
      redirect_to [@form.group,@form], notice: 'Form was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /forms/1
  def destroy

    @group = @form.group
    @form.destroy
    redirect_to group_url(@group), notice: 'Form was successfully destroyed.'

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_form
      @form = Form.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def form_params
      params.require(:form).permit(:owner_id, :group_id, :name, :template, :render_options)
    end
end
