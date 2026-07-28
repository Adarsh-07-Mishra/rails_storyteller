module ProjectsHelper
  def project_status_class(project)
    case project.status
    when "pending"
      "bg-gray-100 text-gray-700"
    when "analyzing"
      "bg-yellow-100 text-yellow-700"
    when "completed"
      "bg-green-100 text-green-700"
    when "failed"
      "bg-red-100 text-red-700"
    else
      "bg-gray-100 text-gray-700"
    end
  end
end