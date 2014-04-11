# Memcachedx [in development]

I want to make this the default choice for memcached in elixir. Feel
free to help or to get in touch.

## Roadmap

- Commands builder for binary protocol with full compatibility/test coverage for http://code.google.com/p/memcached/wiki/BinaryProtocolRevamped
- TCP socket connection I/O
- Connection pools

## Usage

Work in progress

## Generating docs

Yes, there's decent docs for this library.

    mix docs

## Contributing

### Running tests

Make sure you have memcached installed and running in host `localhost` and
port `11211`.

    mix test

### Making a pull request?
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Docs are important.
