class Api::Issues::IssuesJson
  def self.to_json(issues)
    issues.map { |i| Api::Issues::IssueJson.to_json(i) }
  end
end