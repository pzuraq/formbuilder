class ResponsesController < ApplicationController
  include HandlebarsSupport

  before_action :set_parents
  before_action :set_response, only: [:show, :edit, :update, :destroy]


  # GET /responses
  # GET /responses.json
  def index
    @responses = Response.all
  end

  # GET /responses/1
  # GET /responses/1.json
  def show
    @form = @response.form
    @group = @form.group
  end

  # GET /responses/new
  def new
    begin
      @compiled = compile_template(@form.template)
      @response = Response.new

      render layout: 'response'
    rescue V8::Error
       redirect_to group_form_path(@form.group, @form), notice: 'Your template syntax has a problem!'
    end
  end

  # GET /responses/1/edit
  def edit
    unless can_edit?
      redirect_to group_form_url(@response.form.group, @response.form), notice: "I'm sorry Dave, I can't let you do that."
    end
  end

  # POST /responses
  # POST /responses.json
  def create
    @response = Response.new
    @response.form = @form
    @response.respondent = current_user
    @response.answers = params[:ans].merge(params[:ans]) { |k,v| v.is_a?(Array) ? v.join(',') : v }

    respond_to do |format|
      if @response.save
        format.html { redirect_to group_form_response_path(@group, @form, @response), notice: 'Response was successfully submitted.' }
        format.json { render :show, status: :created, location: @response }
      else
        format.html { render :new }
        format.json { render json: @response.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /responses/1
  # PATCH/PUT /responses/1.json
  def update
    unless can_edit?
      redirect_to group_url(@form.group), notice: "I'm sorry Dave, I can't let you do that."
    end
    respond_to do |format|
      if @response.update(response_params)
        format.html { redirect_to @response, notice: 'Response was successfully updated.' }
        format.json { render :show, status: :ok, location: @response }
      else
        format.html { render :edit }
        format.json { render json: @response.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /responses/1
  # DELETE /responses/1.json
  def destroy
    @response.destroy

    respond_to do |format|
      format.html { redirect_to responses_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_parents
      @group = Group.find params[:group_id]
      @form  = Form.find params[:form_id]
    end

    def set_response
      @response = Response.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def response_params
      params.require(:response).permit(:user_id, :answers, :form_id)
    end
end
