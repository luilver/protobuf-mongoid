# protobuf-mongoid

protobuf-mongoid is a Ruby gem that integrates Protocol Buffers with Mongoid, allowing for efficient serialization and deserialization of Mongoid documents using Protocol Buffers.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'protobuf-mongoid'
```

And then execute:

```
bundle install
```

Or install it yourself as:

```
gem install protobuf-mongoid
```

## Usage

To use protobuf-mongoid, include the necessary modules in your Mongoid models. Here is a basic example:

```ruby
class User
  include Mongoid::Document
  include Protobuf::Mongoid

  field :name, type: String
  field :email, type: String

  # Define your Protocol Buffers message here
end
```

### Tests

To test protobuf-mongoid, run:

```bash
rake
```

## Contributing

1. Fork it ( https://github.com/luilver/protobuf-mongoid/fork )
2. Create your feature branch (git checkout -b feature/my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin feature/my-new-feature)
5. Create a new Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE.txt) file for details.
