class MongodbCollection
  def initialize(app)
    @app = app
  end

  def with_collection(collection_name, require_collection = true)
    with_client do |client|
      yield client[collection_name]
    end
  end

  private

  def database_has_collection?(database, collection_name)
    database.collection_names.include?(collection_name)
  end

  def with_database
    begin
      client = Mongo::Client.new(ENV['MONGO'], {ssl_verify: false})
      app.logger.info(ENV['MONGO'])
      yield client.database
    rescue CloudFoundryEnvironment::NoMongodbBoundError
      app.tell_user_how_to_bind
    # rescue Mongo::AuthenticationError => e
    #   app.logger.info(e)
    ensure
      client.close if client
    end
  end

  def with_client
    begin
      client = Mongo::Client.new(ENV['MONGO'], {ssl_verify: false})
      app.logger.info(ENV['MONGO'])
      yield client
    rescue CloudFoundryEnvironment::NoMongodbBoundError
      app.tell_user_how_to_bind
    # rescue Mongo::AuthenticationError => e
    #   app.logger.info(e)
    ensure
      client.close if client
    end
  end

  attr_reader :app

  def mongo_uri
    cloud_foundry_environment.mongo_uri
  end

  def cloud_foundry_environment
    @cloud_foundry_environment ||= CloudFoundryEnvironment.new
  end
end
