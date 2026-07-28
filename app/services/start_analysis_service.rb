class StartAnalysisService
  def initialize(project)
    @project = project
  end

  def call
    project.analyzing!

    Git::RepositoryCloner.call(project)

    project.completed!
  rescue StandardError => e
    project.failed!

    Rails.logger.error(e.message)
  end

  private

  attr_reader :project
end