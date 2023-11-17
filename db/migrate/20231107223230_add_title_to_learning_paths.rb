class AddTitleToLearningPaths < ActiveRecord::Migration[7.0]
  def change
    add_column(:learning_paths, :title, :string)
  end
end
