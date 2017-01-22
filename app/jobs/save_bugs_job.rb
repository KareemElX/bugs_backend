require 'elasticsearch'

$client = Elasticsearch::Client.new host: 'elastic', log: true 
$client.transport.reload_connections!

class SaveBugsJob < ActiveJob::Base
  queue_as :default


  def perform(bug)
    bug = eval(bug)
    bug = Bug.new(bug)
    begin
      bug.app_token = bug['app_token']
      max_id = Bug.where(app_token: bug['app_token']).maximum("number") || 0
      bug.number = max_id + 1
    end until bug.save
    $client.index  index: bug['app_token'], type: 'bugs', id: bug['number'], body: bug.to_json()
  end
end

