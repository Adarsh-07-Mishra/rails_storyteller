module Analysis
  class ArchitectureAnalyzer
    def self.call(repository)
      repository.commits.find_each do |commit|
        ArchitectureChangeDetector.call(commit)
      end
    end
  end
end