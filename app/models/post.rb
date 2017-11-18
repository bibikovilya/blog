class Post < ApplicationRecord
  belongs_to :user
  has_many :rates

  def average_rate
    rates.average('value').to_f.round(2)
  end

  def as_json
    {
      id: id,
      user_id: user_id,
      title: title,
      body: body,
      ip: ip.to_s
    }
  end
end
