# == Schema Information
#
# Table name: expressions
#
#  id          :integer          not null, primary key
#  body        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  language_id :integer
#
class Expression < ApplicationRecord
  belongs_to :language, required: true, class_name: 'Language', foreign_key: 'language_id'
  has_many  :translations_as_base, class_name: 'Translation', foreign_key: 'expression_in_base_language_id',
                                   dependent: :destroy
  has_many  :translations, class_name: 'Translation', foreign_key: 'expression_in_target_language_id',
                           dependent: :destroy
end
