class PostsController < ApplicationController
  def new
    @topic = Topic.find(topic_id)
    @post = @topic.posts.new
  end

  def create
    @topic = Topic.find(topic_id)
    @post = @topic.posts.new(post_params)

    if @post.save
      redirect_to topic_path(@topic), notice: t('flash_message.post.create.success')
    else
      render :new
    end
  end

  protected

    def post_params
      params.require(:post).permit(:content)
    end

    def topic_id
      params.require(:topic_id)
    end
end
