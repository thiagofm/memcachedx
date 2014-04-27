# Memcachedx [in development]

I want to make this the default choice for memcached in elixir. Feel
free to help or to get in touch.

## Roadmap

- Connection pools
- Rewrite parser to use directly binary instead of converting it to a
  list

## Usage

### For single connections:
Read https://github.com/thiagofm/memcachedx/blob/master/test/connection_test.exs

### With a connection pool:

## Generating docs

Yes, there's decent docs for this library.

    mix docs

## Contributing

### Running tests

Make sure you have memcached installed and running in host `localhost` and
port `11211`.

    mix test

### Dedication

I dedicate this project to [ericmj](http://www.github.com/ericmj) for his patience in teaching me elixir!

### Making a pull request?

* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Docs are important.
