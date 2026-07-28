class ProjectsController < ApplicationController
  before_action :set_project, only: %i[show analyze]

  def index
    @projects = Project.order(created_at: :desc)
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)

    if @project.save
      redirect_to @project, notice: "Project created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def analyze
  @project = Project.find(params[:id])

  StartAnalysisService.new(@project).call

  redirect_to @project,
              notice: "Repository analysis started."
end

  private

  def set_project
    @project = Project.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:name, :github_url)
  end
end