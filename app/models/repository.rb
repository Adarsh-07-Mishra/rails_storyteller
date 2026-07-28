class Repository < ApplicationRecord
  belongs_to :project

  has_many :commits,
           dependent: :destroy
end