class Api::V1::SchoolTypesController < ApplicationController
  before_action :set_school_type, only: [:show, :update, :destroy]
  require 'json'
  # GET /school_types
  def index
    @school_types = SchoolType.all

    render json: @school_types
  end

  # GET /school_types/1
  def show
    render json: @school_type
  end

  # POST /school_types
  def create

    params["SchoolTypes"].each do |school_type|
      school = School.find_by(name: school_type[:school_name]) if school_type[:school_name]
      type = Type.find_by(name: school_type[:type_name]) if school_type[:type_name]
      if school.present? and type.present?
        @school_type = SchoolType.new()
        @school_type.school_id = school.id
        @school_type.type_id = type.id
        @school_type.save
      end
    end
    if @school_type
      render json: {success: true, message: "Se ha creado correctmente la asociación de escuela-temáticas" }, status: :ok
    else
      render json: @school_type.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /school_types/1
  def update
    if @school_type.update(school_type_params)
      render json: @school_type
    else
      render json: @school_type.errors, status: :unprocessable_entity
    end
  end

  # DELETE /school_types/1
  def destroy
    @school_type.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_school_type
      @school_type = SchoolType.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def school_type_params
      params.require(:school_type).permit(:school_id, :type_id)
    end
end
