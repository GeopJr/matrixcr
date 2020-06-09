# matrixcr

A Work In Progress [Matrix](https://matrix.org/) API wrapper for Crystal

Heavily inspired by [discordcr](https://github.com/discordcr/discordcr)

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     matrixcr:
       github: GeopJr/matrixcr
   ```

2. Run `shards install`

## Usage

```crystal
require "matrixcr"

client = Matrix::Client.new(access_token: "2QuhNoIMU2lI5ZZZAx5G8XZ9GlddNVBg02QpYGctxTgnMMWwzPj5GBPUkalZGDIMCpkuXRVJST1HMXpu4V99HFYVN2m1amzx7l2oZ4DeD25-3w9vDZ2Vf1bkYcuKSgjgMWIkS0OaZC3ZDq0ZWlHSRbwZ12SPgSK2Q5pk5XgHIAJycwZWIGhcHB62LBBFAY0lMMRWxMCyyEAca7wy4JMDpBIMaEWtmC0DZDCMBMnAvnQw9ZohBJ0W2lj8E6Zcbo2giAIAh2K")
```

```crystal
require "matrixcr"

client = Matrix::Client.new(user: "matrixcr", password: "u4V99HFYVN2m1amz")
```

## Contributing

1. Fork it (<https://github.com/GeopJr/matrixcr/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [GeopJr](https://github.com/GeopJr) - creator and maintainer
