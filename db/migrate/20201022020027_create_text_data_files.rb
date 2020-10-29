class CreateTextDataFiles < ActiveRecord::Migration[6.0]
  def change # migration file to create necessary table on the database
    create_table :text_data_files do |t|
      t.string :id_column
      t.string :name_column
      t.string :timestamp_column
      t.string :link
    end
  end
end
