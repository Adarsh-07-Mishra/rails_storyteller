class Commit < ApplicationRecord
  belongs_to :repository

  validates :sha, presence: true
end