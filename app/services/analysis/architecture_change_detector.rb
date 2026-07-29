module Analysis
  class ArchitectureChangeDetector
    ARCHITECTURE_RULES = {
      "app/models/" => :model,
      "app/controllers/" => :controller,
      "app/jobs/" => :job,
      "app/mailers/" => :mailer,
      "app/services/" => :service,
      "app/helpers/" => :helper,
      "app/concerns/" => :concern,
      "db/migrate/" => :migration,
      "config/routes.rb" => :route
    }.freeze

    def self.call(commit)
      new(commit).call
    end

    def initialize(commit)
      @commit = commit
    end

    def call
      summary = Hash.new(0)

      commit.commit_files.find_each do |file|
        type = artifact_type(file.path)

        next unless type

        summary[type] += 1
      end

      commit.update!(
        architecture_change: summary.any?,
        change_summary: summary
      )
    end

    private

    attr_reader :commit

    def artifact_type(path)
      ARCHITECTURE_RULES.each do |prefix, type|
        return type if path.start_with?(prefix)
      end

      nil
    end
  end
end