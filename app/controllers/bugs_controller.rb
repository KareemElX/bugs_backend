require 'elasticsearch'

$client = Elasticsearch::Client.new host: 'elastic', log: true 
$client.transport.reload_connections!

class BugsController < ApplicationController
  
  def create
    if params['bug']
      SaveBugsJob.perform_later(params['bug'].to_json)
      render body: 'Bug will be saved'
    else
      render body: 'no bug to save'
    end
  end
  
  def show
    es_response = $client.search index: params['app_token'], body: { query: { query_string: { query: 'number: ' + params[:id] } } }
    if es_response['hits']['hits'].length > 0
      @bug = es_response['hits']['hits'][0]
      render body: @bug
    else
      render body: 'Bug Not Found'
    end
  end

  def index
    es_response = $client.search index: params['app_token'], body: { query: { query_string: { query: 'created: * TO *' } } }
    if es_response['hits']['hits'].length > 0
      bugs = es_response['hits']['hits']
      render body: bugs
    else
      render body: 'No Bugs Found'
    end
  end

  private
  def bug_params
    params.require(:bug).permit(:status, :priority, :comment)
  end

end