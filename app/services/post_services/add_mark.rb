module PostServices
  class AddMark
    attr_reader :post, :mark
    attr_accessor :success, :average_rate, :errors

    def initialize(params = {})
      @post = Post.find_by(id: params[:post_id])
      @mark = params[:mark].to_i
      @errors = []
    end

    def call
      if validation
        Rate.create(post: @post, value: @mark)
        @average_rate = @post.average_rate
        @success = true
      else
        @success = false
      end
    end

    private

    def validation
      @errors << 'Post must be present' if @post.blank?
      @errors << 'Mark must be from 1 to 5' if @mark.present? && !@mark.between?(1,5)

      @errors.empty?
    end
  end
end
