class Api::V1::EditionsController < ApplicationController
  before_action :set_edition, only: [:show, :update, :destroy]

  # GET /editions
  def index
    @editions = Edition.all

    render json: @editions
  end

  # GET /editions/1
  def show
    render json: @edition
  end

  # POST /editions
  def create
    hash_data = []
    date_closest = nil
    date_latest = nil
    errors = []
    hash = Hash.new
    params["criteria"].each do |criteria_json|
      #validar que el criterio enviado exista
      if criteria_json == "closest" or criteria_json == "latest"
        criterion = Criterion.find_by(name: criteria_json)
      else
        value_first  =  criteria_json.to_s.split('-').first
        criterion = Criterion.find_by("name LIKE ?", "%#{value_first}%" )
      end

      if criterion.present? and errors.empty?
        params["editions"].each do |edition|
          edition["courses"].each do |course|
            if course["name"] and course["type"]
              if criterion.name == "closest"
                if (date_closest.nil? or date_closest >= edition["date"])
                  if date_closest == edition["date"] and course["name"] != hash['courses']
                    hash_data << hash
                    hash = Hash.new
                  end
                  date_closest = edition["date"]
                  hash['date']= edition["date"]
                  hash['courses'] = course["name"]
                end
              elsif criterion.name == "latest"
                if (date_latest.nil? or date_latest <= edition["date"])
                  if date_latest == edition["date"] and course["name"] != hash['courses']
                    hash_data << hash
                    hash = Hash.new
                  end
                  date_latest = edition["date"]
                  hash['date']= edition["date"]
                  hash['courses'] = course["name"]
                end
              elsif criterion.name == "type-name"
                value_second  =  criteria_json[value_first.length+1, criteria_json.length]
                type = Type.find_by(name: value_second)
                if type.present?
                    if course["type"]
                      if course["type"] == type.name
                        hash['date']   = edition["date"]
                        hash['courses'] = course["name"]
                        hash_data << hash
                        hash = Hash.new
                      end
                    else
                      errors << "Falta el type en la estructura para el curso  #{course["name"]}. "
                      break
                    end
                end
              elsif criterion.name == "school-name"
                value_second  =  criteria_json[value_first.length+1, criteria_json.length]
                school = School.find_by(name: value_second)
                school_types = SchoolType.where(school_id: school.id) if school
                school_types.each do |school_type|
                  type = Type.find_by(id: school_type)
                  if type.present?
                    if course["type"] == type.name
                      hash['date']   = edition["date"]
                      hash['courses'] = course["name"]
                      hash_data << hash
                      hash = Hash.new
                    end
                  end
                end
              end
            else
              if course["name"].nil? and course["type"].nil?
                errors << "Falta el name y el type en la estructura para la editions #{edition["date"]}. "
                break
              elsif course["name"].nil?
                errors << "Falta el name en la estructura para la editions #{edition["date"]}. "
                break
              elsif course["type"].nil?
                errors << "Falta el type en la estructura para el curso  #{course["name"]}. "
                break
              end
            end
          end

        end
      end
    end

    hash_data << hash

    if !hash_data.empty? and errors.empty?
      render json:  hash_data.to_json, status: :ok
    else
      render json: {success: false, message: errors }, status: :not_found
    end
  end

  # PATCH/PUT /editions/1
  def update
    if @edition.update(edition_params)
      render json: @edition
    else
      render json: @edition.errors, status: :unprocessable_entity
    end
  end

  # DELETE /editions/1
  def destroy
    @edition.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_edition
      @edition = Edition.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def edition_params
      params.require(:edition).permit(:date, :course_id)
    end
end
