class AddReviewStatusToTranslations < ActiveRecord::Migration[7.0]
  def change
    add_column :translations, :review_status, :integer, :default => 0
  end
end
