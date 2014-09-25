class Response < ActiveRecord::Base
  validates :respondent_id, :answer_choice_id, presence: true
  validate :respondent_has_not_already_answered_question
  validate :respondent_is_not_poll_author

  belongs_to :user,
  class_name: "User",
  foreign_key: :user_id,
  primary_key: :id

  belongs_to :answer_choice,
  class_name: "AnswerChoice",
  foreign_key: :answer_choice_id,
  primary_key: :id

  has_one :question, through: :answer_choice, source: :question
  has_one :question_poll, through: :question, source: :poll
  has_one :poll_author, through: :question_poll, source: :author

  def sibling_responses
    siblings = self.question.responses
    unless self.id.nil?
      siblings = siblings.where("responses.id != ?", self.id)
    end

    siblings
  end

  def respondent_has_not_already_answered_question
    if sibling_responses.exists?(respondent_id: self.respondent_id)
      errors[:respondent_id] << "is already in responses"
    end
  end

  def respondent_is_not_poll_author
    if answer_choice.author.id == self.respondent_id
      errors[:respondent_id] << "is the author, dum-dum!"
    end
  end

end