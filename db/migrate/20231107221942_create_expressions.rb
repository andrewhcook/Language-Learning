class CreateExpressions < ActiveRecord::Migration[7.0]
  def change
    create_table :expressions do |t|
      t.string :body
      t.integer :language_id

      t.timestamps
    end
  end
end
