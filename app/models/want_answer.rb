class WantAnswer < ActiveRecord::Base
  validates :asker, :question, presence: true
  validates :asker, uniqueness: {scope: [:question, :answerer]}

  belongs_to(
    :asker,
    class_name: "User",
    foreign_key: :asker_id,
    inverse_of: :wanted_answers
  )

  belongs_to(
    :answerer,
    class_name: "User",
    foreign_key: :answerer_id,
    inverse_of: :requested_answers
  )

  belongs_to :question, inverse_of: :answer_requests

  def self.requests_hash(current)
    want_answers = WantAnswer.all.includes(:asker, :answerer, :question)
    requests = {
      specific: Array.new,
      total_requests: Hash.new { |hash, key| hash[key] = 0}
    }

    want_answers.count

    want_answers.each_with_index do |want_answer, index|
      if current && want_answer.answerer_id == current.id
        requests[:specific] << [want_answer.asker, want_answer.question]
      end
        requests[:total_requests][want_answer.question] += 1
    end

    return requests
  end

end
