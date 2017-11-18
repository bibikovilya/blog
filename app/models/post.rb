class Post < ApplicationRecord
  belongs_to :user
  has_many :rates

  def average_rate
    rates.average('value')
  end
end
