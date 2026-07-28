module Git
  class RepositoryPersister
    def self.call(project, metadata)
      Repository.create!(
        project: project,
        local_path: RepositoryPath.for(project).to_s,
        default_branch: metadata[:default_branch],
        head_sha: metadata[:head_sha],
        commit_count: metadata[:commit_count],
        repository_size: metadata[:repository_size]
      )
    end
  end
end