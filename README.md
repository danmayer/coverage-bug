coverage-bug
============

This shows a bug with Ruby's Coverage, as tracked on [ruby bug tracker #9572](https://bugs.ruby-lang.org/issues/9572)

to execute just run: `ruby ./example.rb`

This demonstrates why Coverage from the ruby std-lib isn't useful for the kind of data I want to get from coverband.

output:

```
method_a called
{"/Users/danmayer/projects/coverage-bug/covercheck.rb"=>[1, 1, nil, nil, 1, 0, nil, nil, 1, 1, nil, 0, nil, 0, 0, 0, nil, nil, nil, nil, nil, nil, nil, nil, nil]}
this doesn't matter and is between coverage
method_b_called
{}
```

expected output:

```
method_a called
{"/Users/danmayer/projects/coverage-bug/covercheck.rb"=>[1, 1, nil, nil, 1, 0, nil, nil, 1, 1, nil, 0, nil, 0, 0, 0, nil, nil, nil, nil, nil, nil, nil, nil, nil]}
this doesn't matter and is between coverage
method_b_called
{"/Users/danmayer/projects/coverage-bug/covercheck.rb"=>[0, 0, nil, nil, 1, 1, nil, nil, 0, 0, nil, 0, nil, 1, 1, 1, nil, nil, nil, nil, nil, nil, nil, nil, nil]}
```