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
end
