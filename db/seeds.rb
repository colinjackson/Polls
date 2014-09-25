# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


john = User.create!(user_name: "johnthebestest")
colin = User.create!(user_name: "vistalover")
tommy = User.create!(user_name: "tommyD")

poll = Poll.create!(title: "How is barbies made?", author_id: john.id)

question = Question.create!(
  question: "Do you know how barbies are made? Ive alrways been super" +
  " syupser curious", poll_id: poll.id)

answer1 = AnswerChoice.create!(question_id: question.id, answer: " I don't know")
answer2 = AnswerChoice.create!(question_id: question.id, answer: "I know but not telling")

resp1 = Response.create!(answer_choice_id: answer2.id, respondent_id: colin.id)
resp2 = Response.create!(answer_choice_id: answer2.id, respondent_id: tommy.id)