require "net/http"
require "json"

module Github
  class GithubRepositoryValidator
    GITHUB_REPO_REGEX = %r{\Ahttps://github\.com/[^/]+/[^/]+/?\z}

    def initialize(url)
      @url = url.strip
    end

    def call
      return failure("Invalid GitHub URL") unless valid_format?

      response = Net::HTTP.get_response(api_uri)

      case response
      when Net::HTTPSuccess
        body = JSON.parse(response.body)

        return failure("Repository is private") if body["private"]
        return failure("Repository is archived") if body["archived"]

        success(body)

      when Net::HTTPNotFound
        failure("Repository not found")

      else
        failure("Unable to reach GitHub")
      end
    end

    private

    attr_reader :url

    def valid_format?
      url.match?(GITHUB_REPO_REGEX)
    end

    def api_uri
      owner, repo = url.split("/")[-2, 2]

      URI("https://api.github.com/repos/#{owner}/#{repo}")
    end

    def success(data)
      {
        success: true,
        data: data
      }
    end

    def failure(message)
      {
        success: false,
        error: message
      }
    end
  end
end