# SearchworksMarcIndexing

## Installation

Clone this repository. And then execute:

    $ bundle

## Usage

```console
$ traject -c indexers/searchworks.rb
          -s solr_writer.batch_size=100 \
          -s log.level=debug
          -w Traject::DebugWriter
          path/to/marc/data.mrc
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/sul-dlss/searchworks_marc_indexing.

## License

The gem is available as open source under the terms of the [Apache 2.0 License](http://opensource.org/licenses/Apache-2.0).
