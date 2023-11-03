# == Schema Information
#
# Table name: languages
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Language < ApplicationRecord
  has_many  :words, class_name: "Word", foreign_key: "language_id", dependent: :destroy
  has_many  :learning_paths, class_name: "LearningPath", foreign_key: "target_language_id", dependent: :destroy
  has_many  :learning_paths_base, class_name: "LearningPath", foreign_key: "base_language_id", dependent: :destroy
end
