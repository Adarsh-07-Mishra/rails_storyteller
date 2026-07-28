require "fileutils"

module Git
  class RepositoryCloner
    def self.call(project)
      new(project).call
    end

    def initialize(project)
      @project = project
      @repository_path = RepositoryPath.for(project)
    end

    def call
      cleanup_existing_repository

      clone_repository

      repository_path
    end

    private

    attr_reader :project, :repository_path

    def cleanup_existing_repository
      FileUtils.rm_rf(repository_path) if Dir.exist?(repository_path)
    end

    def clone_repository
      Git::CommandRunner.run(
        "git",
        "clone",
        "--quiet",
        project.github_url,
        repository_path.to_s
      )
    end
  end
end