module PostServices
  class Top
    attr_accessor :success, :errors, :count, :posts

    def initialize(top_count)
      @count = top_count.to_i || 5
      @errors = []
    end

    def call
      if validation
        sql = <<-SQL
          SELECT posts.id, posts.title, posts.body, round(AVG(rates.value)) AS rate
          FROM posts RIGHT JOIN rates ON rates.post_id = posts.id
          GROUP BY posts.id
          ORDER BY rate DESC
          LIMIT :count
        SQL
        query = ActiveRecord::Base.send(:sanitize_sql_array, [sql.squish, count: @count])
        @posts = ActiveRecord::Base.connection.execute(query).to_a

        @success = true
      else
        @success = false
      end
    end

    private

    def validation
      @errors << 'Top count should be a number' if @count < 1
      @errors.empty?
    end
  end
end
