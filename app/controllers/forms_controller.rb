class FormsController < ApplicationController
  before_action :set_group
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
  end

  # GET /forms/1/edit
  def edit
  end

  # POST /forms
  def create
    @form = Form.new(form_params)
    @form.group = @group
    @form.owner = current_user

    unless can_edit?
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
      redirect_to [@group, @form], notice: 'Form was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /forms/1
  def destroy
    @form.destroy
    redirect_to group_url(@group), notice: 'Form was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.find(params[:group_id])
    end

    def set_form
      @form = Form.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def form_params
      params.require(:form).permit(:owner_id, :group_id, :name, :template, :render_options)
    end
end
