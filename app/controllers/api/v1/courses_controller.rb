class Api::V1::CoursesController < ApplicationController
  before_action :set_course, only: [:show, :update, :destroy]

  # GET /courses
  def index
    @courses = Course.all

    render json: @courses
  end

  # GET /courses/1
  def show
    render json: @course
  end

  # POST /courses
  def create
    params["Courses"].each do |course|
      type = Type.find_by(name: course[:type]) if course[:type]
      if type and course[:name]
        @course = Course.new(name: course[:name], type_id: type.id)
        @course.save
      end
    end

    if @course
      render json: {success: true, message: "Se ha creado correctmente el cursp" }, status: :ok
    else
      render json: @course.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /courses/1
  def update
    if @course.update(course_params)
      render json: @course
    else
      render json: @course.errors, status: :unprocessable_entity
    end
  end

  # DELETE /courses/1
  def destroy
    @course.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course
      @course = Course.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def course_params
      params.require(:course).permit(:name, :type_id)
    end
end
