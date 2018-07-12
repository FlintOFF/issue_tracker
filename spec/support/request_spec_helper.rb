module RequestSpecHelper
  # Parse JSON response to ruby hash
  def json
    JSON.parse(response.body)
  end

  def auth_headers(id)
    { 'Authorization' => "Bearer #{Knock::AuthToken.new(payload: { sub: id }).token}" }
  end

end