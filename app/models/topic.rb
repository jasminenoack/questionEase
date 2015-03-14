class Topic < ActiveRecord::Base
   validates :title, presence: true

   has_many :knows_abouts, inverse_of: :topic
   has_many :knowledgable_users, through: :knows_abouts, source: :user
   has_many :topicings, inverse_of: :topics
   has_many :questions, through: :topicings
end
