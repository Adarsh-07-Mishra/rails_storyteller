module Git
  class MetadataExtractor
    def self.call(project)
      new(project).call
    end

    def initialize(project)
      @project = project
      @repository_path = RepositoryPath.for(project)
    end

    def call
      {
        default_branch: default_branch,
        head_sha: head_sha,
        commit_count: commit_count,
        repository_size: repository_size
      }
    end

    private

    attr_reader :project, :repository_path

    def default_branch
      Git::CommandRunner.run(
        "git",
        "branch",
        "--show-current",
        chdir: repository_path
      )
    end

    def head_sha
      Git::CommandRunner.run(
        "git",
        "rev-parse",
        "HEAD",
        chdir: repository_path
      )
    end

    def commit_count
      Git::CommandRunner.run(
        "git",
        "rev-list",
        "--count",
        "HEAD",
        chdir: repository_path
      ).to_i
    end

    def repository_size
      directory_size(repository_path)
    end

    def directory_size(path)
      Dir.glob("#{path}/**/*", File::FNM_DOTMATCH)
         .select { |f| File.file?(f) }
         .sum { |f| File.size(f) }
    end
  end
end