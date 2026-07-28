module Git
  class CommandRunner
    class CommandFailed < StandardError; end

    def self.run(*command, chdir: nil)
      output = +""

      status = nil

      Dir.chdir(chdir || Dir.pwd) do
        output = `#{command.join(" ")} 2>&1`
        status = $?
      end

      raise CommandFailed, output unless status.success?

      output.strip
    end
  end
end