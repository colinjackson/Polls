class AnswerChoice < ActiveRecord::Base
  validates :answer, presence: true

  belongs_to :question,
  class_name: "Question",
  foreign_key: :question_id,
  primary_key: :id

  has_many :responses,
  class_name: "Response",
  foreign_key: :answer_choice_id,
  primary_key: :id

  has_one :poll, through: :question, source: :poll
  has_one :author, through: :poll, source: :author

end