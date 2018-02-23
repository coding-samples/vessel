class Api::Issues::IssueJson
  def self.to_json(issue)
    {
        id: issue.id,
        title: issue.title
    }
  end
end