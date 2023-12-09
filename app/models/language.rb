# == Schema Information
#
# Table name: languages
#
#  id         :integer          not null, primary key
#  name       :string
#  shortcode  :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Language < ApplicationRecord
  has_many  :learning_paths, class_name: 'LearningPath', foreign_key: 'base_language_id', dependent: :destroy
  has_many  :learning_path_as_target, class_name: 'LearningPath', foreign_key: 'target_language_id', dependent: :destroy
  has_many  :expressions, class_name: 'Expression', foreign_key: 'language_id', dependent: :destroy
end
