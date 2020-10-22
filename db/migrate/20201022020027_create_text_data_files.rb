class CreateTextDataFiles < ActiveRecord::Migration[6.0]
  def change
    create_table :text_data_files, :id => false do |t|
      t.string :id
      t.string :name
      t.datetime :timestamp
      t.string :link
    end
  end
end
