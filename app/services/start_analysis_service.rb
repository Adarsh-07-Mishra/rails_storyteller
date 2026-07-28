class StartAnalysisService
  def initialize(project)
    @project = project
  end

  def call
    project.analyzing!

    Git::RepositoryCloner.call(project)

    metadata = Git::MetadataExtractor.call(project)

    Git::RepositoryPersister.call(project, metadata)

    project.update!(
      default_branch: metadata[:default_branch]
    )

    project.completed!
  rescue StandardError => e
    project.failed!

    Rails.logger.error(e.full_message)

    raise e if Rails.env.development?
  end

  private

  attr_reader :project
end