module Git
  class RepositoryPath
    def self.for(project)
      Rails.root.join("storage", "repos", "project_#{project.id}")
    end
  end
end