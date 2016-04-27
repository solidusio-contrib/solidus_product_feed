Solidus Product Feed
================

An extension that provides an RSS feed for products. Google Shopper attributes are also implemented.
An RSS link is automatically appended to the `<head>` tag in the `layouts/spree_application` file.


Installation
===============

1) add the gem to your `Gemfile`:

`gem 'solidus_product_feed'`

2) run bundler:

`bundle install`

3) BOOOM, you're done

Viewing Product RSS
============

`http://yourdomain.tld/products.rss`

Testing
=======

Be sure to add the rspec-rails gem to your Gemfile and then create a dummy test app for the specs to run against.

    $ bundle exec rake test app
    $ bundle exec rspec spec

Copyright (c) 2011 Joshua Nussbaum, released under the New BSD License
