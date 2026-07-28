require "open3"

module Git
  class CommandRunner
    class CommandFailed < StandardError; end

    def self.run(*command, chdir: nil)
      options = {}
      options[:chdir] = chdir.to_s if chdir.present?

      stdout, stderr, status = Open3.capture3(
        *command,
        **options
      )

      unless status.success?
        raise CommandFailed, <<~ERROR
          Command Failed

          Command:
          #{command.join(" ")}

          Directory:
          #{chdir || Dir.pwd}

          Error:
          #{stderr}
        ERROR
      end

      stdout.strip
    end
  end
end