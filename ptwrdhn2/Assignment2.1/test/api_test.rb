require 'test-unit'
require 'rack/test'
# require 'sinatra'
require_relative '../src/api'

class APITest < Test::Unit::TestCase

  include Rack::Test::Methods
  def app
    Sinatra::Application
  end

  def test_get_actor
    result = put '/actors?name="Bruce"'
    assert last_response.status
    assert result.body
  end

  def test_gett_movie
    result = put '/movies?name="Pulp"'
    assert last_response.status
    assert result.body
  end

  def test_put_actor
    json_payload = '{"total_gross":500}'
    result = put '/actors/bruce_willis', json_payload
    assert result.body
  end

  def test_put_movie
    json_payload = '{"box_office":500}'
    result = put '/movies/pulp_fiction', json_payload
    assert result.body
  end

  def test_post_actor
    json_payload = '{"name":"Billy Joe"}'
    result = post '/actors', json_payload
    assert result.body
  end

  def test_post_movie
    json_payload = '{"title":"Captain America"}'
    result = post '/movies', json_payload
    assert result.body
  end

  def test_get_delete_actor
    get '/actors/bruce_willis'
    assert last_response.status == 200

    get '/actors/laidfliserbvzfshbrbg'
    assert last_response.status == 404

    delete '/actors/bruce_willis'
    assert last_response.status == 200

    get '/actors/bruce_willis'
    assert last_response.status == 404
  end

  def test_get_delete_movie
    get '/movies/pulp_fiction'
    assert last_response.status == 200

    get '/movies/laidfliserbvzfshbrbg'
    assert last_response.status == 404

    delete '/movies/pulp_fiction'
    assert last_response.status == 200

    get '/movies/pulp_fiction'
    assert last_response.status == 404
  end

end