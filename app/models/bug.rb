class Bug < ApplicationRecord
  has_one :state
  validates :app_token, uniqueness: { scope: :number }
end
