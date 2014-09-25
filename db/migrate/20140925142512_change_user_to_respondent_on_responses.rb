class ChangeUserToRespondentOnResponses < ActiveRecord::Migration
  def change
    rename_column :responses, :user_id, :respondent_id
  end
end
