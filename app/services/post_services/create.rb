module PostServices
  class Create
    attr_reader :title, :body, :login, :ip
    attr_accessor :success, :post, :errors

    def initialize(params = {})
      @title = params[:title]
      @body = params[:body]
      @login = params[:login]
      @ip = params[:ip]
      @errors = []
    end

    def call
      if validation
        author = User.find_or_create_by(login: @login)
        @post = Post.create(user: author, title: @title, body: @body, ip: @ip)
        @success = true
      else
        @success = false
      end
    end

    private

    def validation
      @errors << "Title can't be empty" if @title.blank?
      @errors << "Body can't be empty" if @body.blank?
      @errors << 'IP address must be present' if @ip.blank?
      @errors << 'Login must be present' if @login.blank?

      @errors.empty?
    end
  end
end
