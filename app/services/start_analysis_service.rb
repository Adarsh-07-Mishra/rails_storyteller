class StartAnalysisService
  def initialize(project)
    @project = project
  end

  def call
    project.analyzing!
  end

  private

  attr_reader :project
end