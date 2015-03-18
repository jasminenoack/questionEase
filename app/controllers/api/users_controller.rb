class Api::UsersController < ApplicationController
  before_action :require_login, only: :update

  def index
    @users = User.all.includes(:users_following)
  end

  def show
    @user = User
      .where(id: params[:id])
      .includes(
        {followed_topics: :users_following},
        {known_topics: :users_following},
        {users_following: :users_following},
        {followed_users: :users_following},
        {comments: :author},
        {questions:
          [:users_following,
          :answer_requesters,
          {answers: :author}
          ]
        },
        {answers:
          [{question:
            [:users_following,
            :answer_requesters,
            {answers: :author}
            ]
          },
          :author]
        },
        {followed_questions:
          [:users_following,
          :answer_requesters,
          {answers: :author}]
        }
      )
      .first
    render :show
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in(@user)
      render :show
    else
      render json: @user.errors.full_messages, status: 422
    end
  end

  def update
    @user = User.where(id: params[:id]).includes(:questions, :answers).first
    if @user.update(user_params)
      log_in(@user)
      @user.update_search_documents
      render :show
    else
      render json: @user.errors.full_messages, status: 422
    end
  end

  def remove_knows_about
    known_topics = KnowsAbout.where(
      user_id: current_user.id)

    if params[:topic_id]
      @knows_about = known_topics.where(topic_id: params[:topic_id]).first
    else
      topic = Topic.find_by(title: params[:title])
      @knows_about = known_topics.where(topic_id: topic.id).first
    end

    if @knows_about
      @knows_about.destroy
    end


    p @knows_about
    render json: @knows_about
  end

  def add_knows_about
    @knows_about = KnowsAbout.new(
      user_id: params[:user_id],
      topic_id: params[:topic_id])
    if @knows_about.save
      render json: @knows_about
    else
      render json: @knows_about.errors.full_messages, status: 422
    end
  end

  private
  def require_login
    if current_user.id != params[:id].to_i
      not_found
    end
  end

  def user_params
    params.require(:user).permit(
      :email,
      :first_name,
      :last_name,
      :username,
      :location,
      :biography,
      :password,
      :password_confirmation,
      set_known_topics: []
    )
  end
end
