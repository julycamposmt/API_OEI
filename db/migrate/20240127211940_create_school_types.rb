class CreateSchoolTypes < ActiveRecord::Migration[5.0]
  def change
    create_table :school_types do |t|
      t.references :school, foreign_key: true
      t.references :type, foreign_key: true

      t.timestamps
    end
  end
end
