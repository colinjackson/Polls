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

  def completed_polls
    Poll.find_by_sql([<<-SQL, self.id])
      SELECT
        polls.*,
        COUNT(*) AS questions_count,
        SUM(answers_tally.response_tally) AS answers_count
      FROM
        polls
      JOIN (#{answers_tally.to_sql}) AS answers_tally
      ON
        polls.id = answers_tally.poll_id
      GROUP BY
        polls.id
      HAVING
        COUNT(*) = SUM(answers_tally.response_tally)
    SQL
  end

  private
    def answers_tally
      Question
        .select("questions.*, COUNT(response_sql.id) AS response_tally")
        .joins(:answer_choices)
        .joins(<<-SQL)
          LEFT OUTER JOIN (#{responses_sql})
          AS response_sql
          ON response_sql.answer_choice_id = answer_choices.id
        SQL
        .group("questions.id")
    end

    def responses_sql
      Response
        .where(respondent_id: self.id).to_sql
    end
end
