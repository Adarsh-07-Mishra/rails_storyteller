class Project < ApplicationRecord
  has_one :repository, dependent: :destroy

  enum :status,
       {
         pending: 0,
         analyzing: 1,
         completed: 2,
         failed: 3
       }

  validates :name, presence: true

  validates :github_url,
            presence: true,
            uniqueness: true

  before_validation :normalize_github_url

  private

  def normalize_github_url
    self.github_url = github_url.to_s.strip
  end
end