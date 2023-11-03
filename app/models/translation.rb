# == Schema Information
#
# Table name: translations
#
#  id                         :integer          not null, primary key
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  learning_path_id           :integer
#  word_in_base_language_id   :integer
#  word_in_target_language_id :integer
#
class Translation < ApplicationRecord
  belongs_to :word_in_base_language, required: true, class_name: "Word", foreign_key: "word_in_base_language_id"
  belongs_to :word_in_target_language, required: true, class_name: "Word", foreign_key: "word_in_target_language_id"
  belongs_to :learning_path, required: true, class_name: "LearningPath", foreign_key: "learning_path_id"
end
