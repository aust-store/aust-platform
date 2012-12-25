=== Testing Guidelines

*Architecture*

There are different kinds of tests: Acceptance, Integration, Unit and Javascript.

For a new story, write an Acceptance test, then proceed to write Unit tests,
following the TDD cycle until you have your Acceptance test passing.

If you need to test something that depends on Rails, like a before_filter or
a scope, write the simplest Integration test possible.

We're avoiding Integration tests at all costs, writing Unit tests and Contract
tests instead. For further information on the reasons, see 
[this article](http://alexsquest.com/texts/1)

*Running the tests*

If you want to run the tests, do the following:

    $ bundle exec rake konacha:run
    $ bundle exec rspec spec
    $ bundle exec rspec spec_integration

If you want to run all specs at once, use

    $ bundle exec rake
