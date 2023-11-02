class CreateWords < ActiveRecord::Migration[7.0]
  def change
    create_table :words do |t|
      t.integer :language_id
      t.string :word

      t.timestamps
    end
  end
end
