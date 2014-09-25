class Question < ActiveRecord::Base
  validates :question, presence: true

  belongs_to :poll,
  class_name: "Poll",
  foreign_key: :poll_id,
  primary_key: :id

  has_many :answer_choices,
  class_name: "AnswerChoice",
  foreign_key: :question_id,
  primary_key: :id

  has_many :responses, through: :answer_choices, source: :responses

  def results

    results = self.answer_choices
      .select("answer_choices.*, COUNT(responses.id) AS response_count")
      .joins("LEFT OUTER JOIN responses ON answer_choices.id = " +
        "responses.answer_choice_id")
      .group("answer_choices.id")

    response_hash = Hash.new(0)
    results.each do |answer_choice|
      response_hash[answer_choice.answer] = answer_choice.response_count
    end

    response_hash
  end

end