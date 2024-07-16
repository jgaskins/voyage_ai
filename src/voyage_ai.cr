require "db/pool"
require "http/client"
require "json"

# TODO: Write documentation for `VoyageAi`
module VoyageAI
  VERSION = "0.1.0"

  class Client
    @api_key : String

    def initialize(@api_key = ENV["VOYAGE_AI_API_KEY"])
      authorization = "Bearer #{api_key}"

      @pool = DB::Pool(HTTP::Client).new do
        http = HTTP::Client.new(URI.parse("https://api.voyageai.com"))
        http.before_request do |request|
          request.headers["authorization"] = authorization
          request.headers["content-type"] = "application/json"
        end
        http
      end
    end

    def embed(
      input : Array(String),
      model : String,
      input_type : InputType? = nil,
      truncation : Bool? = nil,
      # encoding_format : EncodingFormat? = nil,
    )
      response = @pool.checkout &.post "/v1/embeddings", body: EmbeddingRequest.new(
        input: input,
        model: model,
        input_type: input_type,
        truncation: truncation,
        # encoding_format: encoding_format,
      ).to_json

      if response.success?
        List(Embedding).from_json(response.body)
      else
        raise Error.new(response.body)
      end
    end
  end

  class Error < Exception
  end

  struct EmbeddingRequest
    include JSON::Serializable

    getter input : Array(String)
    getter model : String
    getter input_type : InputType?
    getter truncation : Bool?
    getter encoding_format : EncodingFormat?

    def initialize(
      @input,
      @model,
      @input_type = nil,
      @truncation = nil,
      @encoding_format = nil,
    )
    end
  end

  enum EncodingFormat
    Base64
  end

  enum InputType
    Document
    Query
  end

  struct List(T)
    include JSON::Serializable
    include Enumerable(T)

    getter data : Array(T)
    getter model : String
    getter usage : Usage

    def each
      data.each { |item| yield item }
    end
  end

  struct Embedding
    include JSON::Serializable

    getter embedding : Array(Float64)
    getter index : Int64
  end

  struct Usage
    include JSON::Serializable

    getter total_tokens : Int64
  end
end
