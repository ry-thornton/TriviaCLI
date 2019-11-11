require 'pry'
require 'rest-client'

#Below is the GENERAL KNOWLEDGE api pull

response_string = RestClient.get("https://opentdb.com/api.php?amount=50&category=9&difficulty=easy&type=multiple")

response_hash = JSON.parse(response_string)

response_hash["results"].each do |hash|
    
    if !Question.exists?(:question_text => hash["question"])
        q = Question.new
        q.question_text = hash["question"]
        q.correct_answer = hash["correct_answer"]
        q.incorrect_answer1 = hash["incorrect_answers"][0]
        q.incorrect_answer2 = hash["incorrect_answers"][1]
        q.incorrect_answer3 = hash["incorrect_answers"][2]
        q.save
     end
end

#Below is the GEOGRAPHY api pull

response_string = RestClient.get("https://opentdb.com/api.php?amount=50&category=22&difficulty=easy&type=multiple")

response_hash = JSON.parse(response_string)

response_hash["results"].each do |hash|
    if !Question.exists?(:question_text => hash["question"])
        q = Question.new
        q.question_text = hash["question"]
        q.correct_answer = hash["correct_answer"]
        q.incorrect_answer1 = hash["incorrect_answers"][0]
        q.incorrect_answer2 = hash["incorrect_answers"][1]
        q.incorrect_answer3 = hash["incorrect_answers"][2]
        q.save
     end
end

#Below is the SPORTS api pull


response_string = RestClient.get("https://opentdb.com/api.php?amount=50&category=21&type=multiple")

response_hash = JSON.parse(response_string)

response_hash["results"].each do |hash|
    if !Question.exists?(:question_text => hash["question"])
        q = Question.new
        q.question_text = hash["question"]
        q.correct_answer = hash["correct_answer"]
        q.incorrect_answer1 = hash["incorrect_answers"][0]
        q.incorrect_answer2 = hash["incorrect_answers"][1]
        q.incorrect_answer3 = hash["incorrect_answers"][2]
        q.save
     end
end


#Below is the Science/Nature api pull

response_string = RestClient.get("https://opentdb.com/api.php?amount=50&category=17&type=multiple")

response_hash = JSON.parse(response_string)

response_hash["results"].each do |hash|
    if !Question.exists?(:question_text => hash["question"])
        q = Question.new
        q.question_text = hash["question"]
        q.correct_answer = hash["correct_answer"]
        q.incorrect_answer1 = hash["incorrect_answers"][0]
        q.incorrect_answer2 = hash["incorrect_answers"][1]
        q.incorrect_answer3 = hash["incorrect_answers"][2]
        q.save
     end
end

