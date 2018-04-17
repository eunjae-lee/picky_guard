# PickyGuard

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/picky_guard`. To experiment with that code, run `bin/console` for an interactive prompt.

```
* role : can be symbol or string
* action : can be symbol or string

# file tree
app
  - picky_guard
    - policies
      - policy_a.rb
      - policy_b.rb
      - policy_c.rb
    - role_policies.rb
    - resource_actions.rb
    - user_role_checker.rb

# role_policies.rb
class RolePolicies < PickyGuard::RolePolicies
  def initialize
    map(:role_a, [PolicyA, PolicyB])
    map(:role_b, [PolicyB])
  end
end

# resource_actions.rb
class ResourceActions < PickyGuard::ResourceActions
  def initialize
    map(Report, ['Read'])
    
    [App, Campaign].each do |resource|
      map(resource, ['Create', 'Read', 'Update'])
    end
  end
end

# user_role_checker.rb
class UserRoleChecker < PickyGuard::UserRoleChecker
  def self.check(user, role)
    # ...
  end
end

# policy_a.rb
class PolicyA < PickyGuard::Policy
  def initialize(current_user)
    add_statement(
      PickyGuard::Statement.allow(
        ['Create', 'Read', 'Update'],
        App,
        proc { App.where(company: current_user.company) }
      )
    )
    
    add_statement(
      PickyGuard::Statement.deny(
        ['Read'],
        App,
        { company: current_user.company, deleted: true }
      )
    )
  end
end
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'picky_guard'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install picky_guard

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/eunjae-lee/picky_guard.
