class CreateEditions < ActiveRecord::Migration[5.0]
  def change
    create_table :editions do |t|
      t.date :date
      t.references :course, foreign_key: true

      t.timestamps
    end
  end
end
