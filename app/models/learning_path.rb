# == Schema Information
#
# Table name: learning_paths
#
#  id                 :integer          not null, primary key
#  title              :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  base_language_id   :integer
#  target_language_id :integer
#  user_id            :integer
#
class LearningPath < ApplicationRecord
  belongs_to :user, required: true, class_name: "User", foreign_key: "user_id"
  belongs_to :base_language, required: true, class_name: "Language", foreign_key: "base_language_id"
  belongs_to :target_language, required: true, class_name: "Language", foreign_key: "target_language_id"
  has_many  :translations, class_name: "Translation", foreign_key: "learning_path_id", dependent: :destroy
end
