module UserServices
  class GetIps
    def self.call
      sql = <<-SQL
          SELECT posts.ip, array_agg(DISTINCT users.login) AS logins
          FROM users RIGHT JOIN posts ON users.id = posts.user_id
          GROUP BY posts.ip
          ORDER BY posts.ip
      SQL
      ActiveRecord::Base.connection.execute(sql).to_a.map do |record|
        { record['ip'] => record['logins'][1..-2].split(',') }
      end
    end
  end
end
