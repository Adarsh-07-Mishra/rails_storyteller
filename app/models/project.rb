class Project < ApplicationRecord
  enum :status, {
    pending: 0,
    analyzing: 1,
    completed: 2,
    failed: 3
  }

  validates :name, presence: true

  validates :github_url,
            presence: true,
            uniqueness: true
end