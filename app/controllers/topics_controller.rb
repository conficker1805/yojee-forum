class TopicsController < ApplicationController
  def index
    @topics = Topic.last(20)
  end

  def new
    @topic = Topic.new
  end

  def create
    @topic = Topic.new(topic_params)

    if @topic.save
      redirect_to topic_path(@topic), notice: t('flash_message.topic.create.success')
    else
      render :new
    end
  end

  def show
    @topic = Topic.includes(:posts).find(id)
    @posts = @topic.posts.order(id: :desc).paginate(page: page, per_page: 5)
  end

  def search
    @topics = keyword.present? ? Topic.search(keyword) : []
    @topics = @topics.paginate(page: page, per_page: 5)

    render :index
  end

  protected

  def keyword
    params.fetch(:search, {}).fetch(:keyword, '').downcase
  end

  def topic_params
    params.require(:topic).permit(:title)
  end

  def id
    params.require(:id)
  end
end
