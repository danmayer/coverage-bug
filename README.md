Ruby coverage-bug
============

This shows a bug with Ruby's Coverage, as tracked on [ruby bug tracker #9572](https://bugs.ruby-lang.org/issues/9572).

to execute just run: `ruby ./example.rb`

This demonstrates why Coverage from the ruby std-lib isn't useful for the kind of data I want to get from coverband.

previous output (Ruby <= 2.1.1)

```ruby
method_a called
{"/Users/danmayer/projects/coverage-bug/covercheck.rb"=>[1, 1, nil, nil, 1, 0, nil, nil, 1, 1, nil, 0, nil, 0, 0, 0, nil, nil, nil, nil, nil, nil, nil, nil, nil]}
this doesn't matter and is between coverage
method_b_called
{"/Users/danmayer/projects/coverage-bug/covercheck.rb"=>[]}
```

current output:

```ruby
method_a called
{"/Users/danmayer/projects/coverage-bug/covercheck.rb"=>[1, 1, nil, nil, 1, 0, nil, nil, 1, 1, nil, 0, nil, 0, 0, 0, nil, nil, nil, nil, nil, nil, nil, nil, nil]}
this doesn't matter and is between coverage
method_b_called
{}
```

desired output:

```ruby
method_a called
{"/Users/danmayer/projects/coverage-bug/covercheck.rb"=>[1, 1, nil, nil, 1, 0, nil, nil, 1, 1, nil, 0, nil, 0, 0, 0, nil, nil, nil, nil, nil, nil, nil, nil, nil]}
this doesn't matter and is between coverage
method_b_called
{"/Users/danmayer/projects/coverage-bug/covercheck.rb"=>[0, 0, nil, nil, 1, 1, nil, nil, 0, 0, nil, 0, nil, 1, 1, 1, nil, nil, nil, nil, nil, nil, nil, nil, nil]}
```

# Proposal

I would still like to have access to a re-entrant coverage, but given upstream chances since this initial bug, Ruby no longer returns `{'file.rb' => []}` as it was inaccurate to say the file had nothing. Currently, Ruby has removed all the files that were required prior to the initial coverage.start call. The method is re-entrant, but only works for **newly required** files.

I am thinking perhaps that functionality is intended and used for some use cases. It doesn't fit my use case or expectations. I am now considering a different approach to achieve what I would like. I think my needs would be better met with a new API with additional functionality for the Coverage object. This is similar to how `peek_result` was added to coverage. That didn't change the current expectations of any of the existing public API.

Thoughts are we could add the below methods to the public API:

```ruby 
Coverage.pause # removes event hooks, leaving data intact
Coverage.reset # leaves all data tracking, but resets counts to 0
Coverage.resume # adds back event hooks
```

Which could be used to collect coverage results on demand over time, enabling and disabling as needed. The example below illustrates basic usage

`example.rb`

```ruby
require 'coverage'
Coverage.start
require './covercheck'
```

`covercheck.rb`

```ruby
def method_a
  puts "method_a called"
end
 
def method_b
  puts "method_b_called"
end

method_a

puts Coverage.pause
puts Coverage.peek_result
puts Coverage.reset
 
puts "this line is run between coverage being enabled and shouldn't get tracked"
 
Coverage.resume
method_b
puts Coverage.result
```

The expected results would be something like below:

```ruby
method_a called
{"/Users/danmayer/projects/coverage-bug/covercheck.rb"=>[1, 1, nil, nil, 1, 0, nil, nil, 1, 1, nil, 0, nil, 0, 0, 0]}
puts "this line is run between coverage being enabled and shouldn't get tracked"
method_b_called
{"/Users/danmayer/projects/coverage-bug/covercheck.rb"=>[0, 0, nil, nil, 1, 1, nil, nil, 1, 1, nil, 0, nil, 1, 1, 1]}
```

This could allow some extremely interesting code usage tracking, such as pausing and resuming in before / after hooks in Rails to track usage only in particular routes, controllers, modules, or etc. Using reset you could get just changes during a given run, or user could not reset the data and build up a results set over time, but still only incur the performance overhead on a very specific section of code.

I intend to be able to expand the capabilities of [Coverband](https://github.com/danmayer/coverband) using this feature as well as reduce the performance costs it currently incurs to run it.