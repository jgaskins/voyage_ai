# voyage_ai

Use the VoyageAI API to generate vectors from text for embeddings/semantic search.

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     voyage_ai:
       github: jgaskins/voyage_ai
   ```

2. Run `shards install`

## Usage

```crystal
require "voyage_ai"
require "voyage_ai"

voyage = VoyageAI::Client.new

pp voyage.embed [
    "Sample text 1",
    "Sample text 2",
  ],
  model: "voyage-large-2",
  input_type: :document
```

## Contributing

1. Fork it (<https://github.com/jgaskins/voyage_ai/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Jamie Gaskins](https://github.com/jgaskins) - creator and maintainer
