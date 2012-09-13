class GithubApiMethods

  def self.get_github_user(user)
    if !user.github_user.blank? && (Time.now < user.github_user.updated_at + 1.hour)
      return false
    end
    api_uri = get_api_uri(user.member_info.github_homepage)

    return http_connection(api_uri)
  end


  def self.get_github_project(github_url, uri_params)
    api_uri = get_api_uri(github_url)

    return http_connection(api_uri, uri_params)
  end


  def self.get_api_uri(github_url)
    uri = URI.parse(ARGV[0] || github_url)
    api_uri = "https://" + uri.host.gsub(/github.com/, "api.github.com/repos") + uri.path + "/commits"
    return URI.parse(api_uri)
  end


  def self.http_connection(api_uri, uri_params = '')
    http = Net::HTTP.new(api_uri.host, api_uri.port)
    http.use_ssl = true if api_uri.scheme == "https"  # enable SSL/TLS 

    http.start {
      http.request_get(api_uri.path + uri_params) {|res|
        # print res.body
        return JSON.parse res.body
      }
    }
  end

end