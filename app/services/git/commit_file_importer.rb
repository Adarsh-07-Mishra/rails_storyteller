module Git
  class CommitFileImporter
    CHANGE_TYPES = {
      "A" => :added,
      "M" => :modified,
      "D" => :deleted,
      "R" => :renamed
    }.freeze

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
        "--name-status",
        '--format=COMMIT:%H',
        chdir: repository_path
      )

      parse(output)
    end

    private

    attr_reader :repository, :repository_path

    def parse(output)
      current_commit = nil
      batch = []

      output.each_line do |line|
        line = line.strip

        next if line.blank?

        if line.start_with?("COMMIT:")
          insert_batch(batch)

          sha = line.delete_prefix("COMMIT:")

          current_commit = repository.commits.find_by!(sha: sha)

          batch = []

          next
        end

        batch << build_commit_file(current_commit, line)
      end

      insert_batch(batch)
    end

    def build_commit_file(commit, line)
      status, *paths = line.split("\t")

      path =
        if status.start_with?("R")
          paths.last
        else
          paths.first
        end

      {
        commit_id: commit.id,
        path: path,
        change_type: change_type(status),
        created_at: Time.current,
        updated_at: Time.current
      }
    end

    def change_type(status)
      case
      when status.start_with?("A")
        CommitFile.change_types[:added]
      when status.start_with?("M")
        CommitFile.change_types[:modified]
      when status.start_with?("D")
        CommitFile.change_types[:deleted]
      when status.start_with?("R")
        CommitFile.change_types[:renamed]
      else
        CommitFile.change_types[:modified]
      end
    end

    def insert_batch(batch)
      return if batch.empty?

      CommitFile.insert_all(batch)

      batch.clear
    end
  end
end