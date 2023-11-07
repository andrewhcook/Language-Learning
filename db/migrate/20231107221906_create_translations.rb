class CreateTranslations < ActiveRecord::Migration[7.0]
  def change
    create_table :translations do |t|
      t.integer :expression_in_base_language_id
      t.integer :expression_in_target_language_id
      t.integer :learning_path_id

      t.timestamps
    end
  end
end
