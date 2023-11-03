class CreateLearningPaths < ActiveRecord::Migration[7.0]
  def change
    create_table :learning_paths do |t|
      t.integer :user_id
      t.string :title
      t.integer :target_language_id
      t.integer :base_language_id

      t.timestamps
    end
  end
end
