helpers do
  def base_url
    @base_url ||= "http://localhost:4567/api/v1/"
  end

  def json_params
    begin
      JSON.parse(request.body.read)
    rescue
      halt 400, {message: 'Invalid JSON'}.to_json
    end
  end
end
