class Api::Users::UserJson
  def self.to_json(user)
    { id: user.id, name: user.name, login: user.login }
  end
end