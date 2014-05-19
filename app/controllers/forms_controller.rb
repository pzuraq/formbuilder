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
    @form.user_id = session[:user_id]
  end

  # GET /forms/1/edit
  def edit
  end

  # POST /forms
  def create
    @form = Form.new(form_params)
    @form.group_id = params[:group_id]
    @form.user_id = session[:user_id]

    if @form.save
      redirect_to [@form.group,@form], notice: 'Form was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /forms/1
  def update
    @form = Form.new(params[:form])
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
      params.require(:form).permit(:user_id, :group_id, :name, :template, :render_options)
    end
end
