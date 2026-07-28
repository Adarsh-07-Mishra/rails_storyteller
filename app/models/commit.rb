class Commit < ApplicationRecord
  belongs_to :repository
  has_many :commit_files,
         dependent: :destroy

  validates :sha, presence: true
end