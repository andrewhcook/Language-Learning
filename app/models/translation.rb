# == Schema Information
#
# Table name: translations
#
#  id                               :integer          not null, primary key
#  created_at                       :datetime         not null
#  updated_at                       :datetime         not null
#  expression_in_base_language_id   :integer
#  expression_in_target_language_id :integer
#  learning_path_id                 :integer
#
class Translation < ApplicationRecord
  belongs_to :learning_path, required: true, class_name: "LearningPath", foreign_key: "learning_path_id"
  belongs_to :expression_in_base_language, required: true, class_name: "Expression", foreign_key: "expression_in_base_language_id"
  belongs_to :expression_in_target_language, required: true, class_name: "Expression", foreign_key: "expression_in_target_language_id"

end
