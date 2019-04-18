# Solidus Product Feed

[![Build Status](https://travis-ci.org/solidusio-contrib/solidus_product_feed.svg?branch=master)](https://travis-ci.org/solidusio-contrib/solidus_product_feed)

An extension that provides an RSS feed for products. Google Merchant Feed attributes are also
implemented. An RSS link is automatically appended to the `<head>` tag in the
`layouts/spree_application` file.

## Note on Versions

The master branch tracks the 1.0 version of this gem, which has some major changes from its
predecessor `spree_product_feed`. The 1.0 version is cleaner, more extensible, and more correct at 
the expense of compatibility.

We also have a [`~> 0.1.0` version](https://github.com/solidusio-contrib/solidus_product_feed/tree/v0.1) 
which is a direct port of `spree_product_feed` with minimal changes.

## Installation

Add the gem to your `Gemfile`:

```ruby
gem 'solidus_product_feed'
````

Install the gem:

```console
$ bundle install
```

You're done! You can now see your RSS feed at `/products.rss`.

## Usage

The RSS feed is configured wih some sensible defaults, but you can easily change them by putting
the following in your Rails initializer:

```ruby
SolidusProductFeed.configure do |config|
  config.title = 'My Awesome Store'
  config.link = 'https://www.awesomestore.com'
  config.description = 'Find out about new products on https://www.awesomestore.com first!'
  config.language = 'en-us'
end
```

Note that you can also pass a Proc for each of these options. The Proc will be passed the view
context as its only argument, so that you can use any helpers:

```ruby
SolidusProductFeed.configure do |config|
  config.title = -> (view) { view.current_store.name }
  config.link = -> (view) { "http://#{view.current_store.url}" }
  config.description = -> (view) { "Find out about new products on http://#{view.current_store.url} first!" }
  config.language = -> (view) { view.lang_from_store(current_store.language) }
end
```

## Testing

Be sure to add the `rspec-rails` gem to your Gemfile and then create a dummy test app for the specs 
to run against.

```console
$ bundle exec rake test app
$ bundle exec rspec spec
```

Copyright (c) 2011 Joshua Nussbaum, released under the New BSD License
