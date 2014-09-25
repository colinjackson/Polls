class User < ActiveRecord::Base
  validates :user_name, uniqueness: true, presence: true

  has_many :authored_polls,
  class_name: "Poll",
  foreign_key: :author_id,
  primary_key: :id

  has_many :responses,
  class_name: "Response",
  foreign_key: :user_id,
  primary_key: :id

  has_many :authored_poll_responses,
  through: :authored_polls,
  source: :responses

  has_many :questions, through: :authored_polls, source: :questions
  has_many :answer_choices, through: :questions, source: :answer_choices

end
