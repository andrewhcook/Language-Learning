# == Schema Information
#
# Table name: words
#
#  id          :integer          not null, primary key
#  word        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  language_id :integer
#
class Word < ApplicationRecord
  belongs_to :language, required: true, class_name: "Language", foreign_key: "language_id"
  has_many  :base_translations, class_name: "Translation", foreign_key: "word_in_base_language_id", dependent: :destroy
  has_many  :target_translations, class_name: "Translation", foreign_key: "word_in_target_language_id", dependent: :destroy
end
