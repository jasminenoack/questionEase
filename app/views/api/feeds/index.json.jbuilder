json.array! @feed do |item|

  if item.relation == "User"
    json.follow_message "<a href='#/users/#{item.author.id}'>#{item.author.name}</a> asked:"
    json.time time_ago_in_words(item.time)
    json.partial! "api/questions/nude", question: item
  end

  if item.relation == "UserAnswer"
    json.follow_message "<a href='#/users/#{item.author.id}'>#{item.author.name}</a> answered:"
    json.time time_ago_in_words(item.time)
    json.partial! "api/questions/nude", question: item.question
    json.answers do
      json.partial! "api/answers/answer", answer: item
    end
  end

  if item.relation == "Topic"
    json.follow_message "<a href='#/topics/#{item.relation_id}'> #{item.title}</a>: New Question:"
    json.time time_ago_in_words(item.time)
    json.partial! "api/questions/nude", question: item
  end

  if item.relation == "TopicAnswer"
    json.follow_message "<a href='#/topics/#{item.relation_id}'>#{item.title}</a>: Question answered:"
    json.time time_ago_in_words(item.time)
    json.partial! "api/questions/nude", question: item.question
    json.answers do
      json.partial! "api/answers/answer", answer: item
    end
  end

  if item.relation == "QuestionAnswer"
    json.follow_message "New Answer:"
    json.time time_ago_in_words(item.time)
    json.partial! "api/questions/nude", question: item.question
    json.answers do
      json.partial! "api/answers/answer", answer: item
    end
  end
end
