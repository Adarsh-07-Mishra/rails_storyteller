module Git
  class CommitImporter
    DELIMITER = "__STORYTELLER__".freeze

    def self.call(repository)
      new(repository).call
    end

    def initialize(repository)
      @repository = repository
      @repository_path = Pathname.new(repository.local_path)
    end

    def call
      output = Git::CommandRunner.run(
        "git",
        "log",
        "--reverse",
        "--pretty=format:%H#{DELIMITER}%an#{DELIMITER}%ae#{DELIMITER}%ad#{DELIMITER}%s",
        "--date=iso-strict",
        chdir: repository_path
      )

      output.each_line do |line|
        import_commit(line)
      end
    end

    private

    attr_reader :repository, :repository_path

    def import_commit(line)
      sha,
      author_name,
      author_email,
      committed_at,
      message = line.strip.split(DELIMITER, 5)

      repository.commits.create!(
        sha: sha,
        author_name: author_name,
        author_email: author_email,
        committed_at: Time.zone.parse(committed_at),
        message: message
      )
    end
  end
end