class TopicsController < ApplicationController
  before_action :fetch_popular_toptics, only: %i[index search]

  def index
    @topics = Topic.where(created_at: 1.month.ago..Time.current)
                   .order(created_at: :desc)
                   .paginate(page: 1, per_page: 20)
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
    @posts = @topic.posts.order(id: :desc).paginate(page: page)
  end

  def search
    @topics = keyword.present? ? Topic.search(keyword) : []
    @topics = @topics.paginate(page: page, per_page: 5)

    render :index
  end

  protected

    def fetch_popular_toptics
      topics_attrs = Rails.cache.fetch('topics:popular', expires_in: 1.minute) do
        Topic.order(posts_count: :desc, created_at: :desc).limit(10).map(&:attributes)
      end

      @popular_topics = topics_attrs.map { |attrs| Topic.new(attrs) }
    end

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
