[![Gem Version](https://badge.fury.io/rb/picky_guard.svg)](https://badge.fury.io/rb/picky_guard)
[![Build Status](https://travis-ci.org/eunjae-lee/picky_guard.svg?branch=master)](https://travis-ci.org/eunjae-lee/picky_guard)

# PickyGuard

PickyGuard is an opinionated authorization library which wraps [CanCanCan](https://github.com/CanCanCommunity/cancancan).

This library helps to write authorization policies in an opinionated hierarchy.

Briefly,
* **User** has many **roles**.
* Each **role** has many **policies**.
* Each **policy** has many **statements** describing which **actions** has what **effect** on which **resources**.

For example,
* User `Paul` has a role named `CampaignManager`.
* The role `CampaignManager` has a policy named `crud_all_campaigns`.
* The policy `crud_all_campaigns` means,
  * Actions : `[:read, :update, :create, :delete]` are
  * Effect : `Allow`ed
  * Resources : for `All campaigns under user's company`.

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

To generate initial files, execute:

```
$ rails generate picky_guard:install
```

This will create the following files:

```
app/
  - models/
    - ability.rb
  - picky_guard/
    - role_policies.rb
    - resource_actions.rb
    - user_role_checker.rb
```

## Generated Files

### ability.rb

The generated file is like this:

```ruby
class Ability < PickyGuard::Loader
  def initialize(user)
    adjust(user, UserRoleChecker, ResourceActions, RolePolicies)
  end
end
```

Normally, you don't have to do anything about it.

### user_role_checker.rb

The generated file is like this:

```ruby
class UserRoleChecker < PickyGuard::UserRoleChecker
  def self.check(user, role)
    # ...
  end
end
```

This class defines the way to check if user has specific role. It assumes some roles already have been given to the user somehow.

You can implement this on your own, or if you're using a gem like [rolify](https://github.com/RolifyCommunity/rolify), then it should be like this:

```ruby
class UserRoleChecker < PickyGuard::UserRoleChecker
  def self.check(user, role)
    user.has_role? role
  end
end
```

### resource_actions.rb

The generated file is like this:

```ruby
class ResourceActions < PickyGuard::ResourceActions
  def initialize
    map(Report, [:create, :read, :update, :delete])
  end
end
```

This class defines which resource can have which actions. Actions can be an array of either `String` or `Symbol`.

By defining this, you can explicitly manage list of actions per resource and filter out unexpected and unknown actions.

### role_policies.rb

The generated file is like this:

```ruby
class RolePolicies < PickyGuard::RolePolicies
  def initialize
    map(:report_manager, [ManageAllReports])
    # map(:report_reader, [AnotherPolicy])
  end
end
```

This class defines which role has which policies. The method `map` takes two parameters.

1. `role` : It can be a string or a symbol
2. `policies` : An array of policies

From the example code above, we could assume there is a role named `:report_manager` and it has one policy named `ManageAllReports`.

Then how do we define policy?

## Defining Policies

To generate new policy, execute this:

```
$ rails generate picky_guard:policy manage_all_reports
```

From the command line, name should be underscored. Otherwise, it will raise an error.

Once created, you will find the policy file under `app/picky_guard/policies/`.

If you get to have many policies, you can group them into a folder like this:

```
$ rails generate picky_guard:policy reports/manage_all_reports
```

Then it will generate `app/picky_guard/policies/reports/manage_all_reports.rb`.

The generated file is like this:

```ruby
class ManageAllReports < PickyGuard::Policy
  def initialize(current_user)
    statement_for Campaign do
      allow
      actions [:create]
      conditions({})
    end

    statement_for Campaign do
      allow
      actions [:create]
      class_resource
    end
  end
end
```

`register` method takes a parameter and a block.
* The parameter is a resource class. It should extend `ActiveRecord::Base`.
* The block consists of simple DSL, describing the statement.

### Building Statement

There are two types of resources: `instance resource` and `class resource`.

```ruby
can? :read, Campaign.first    # Checking permission against an instance resource

can? :create, Campaign        # Checking permission against a class resource
```

### Instance Resource

In case of `instance resource`, we need
* effect(`allow` or `deny`)
* actions
* conditions

```ruby
statement_for Campaign do  # Instances of `Campaign` are the resources.
  allow                    # Possibly `deny` instead of `allow`. If omitted, it's `allow` by default.
  actions [:create]        # Array of `string` or `symbol`.
  instance_resource        # If omitted, it's an instance resource by default.
  conditions({})
end
```

In a short way,

```ruby
statement_for Campaign do
  actions [:create]
  conditions({})
end
```

### Class Resource

In case of `class resource`, we need
* effect
* actions
* class_resource

```ruby
statement_for Campaign do  # `Campaign` is the resource.
  allow                    # Possibly `deny` instead of `allow`. If omitted, it's `allow` by default.
  actions [:create]        # Array of `string` or `symbol`.
  class_resource           # You need this explicit declaration when it comes to a class resource.
end
```

You cannot specify any conditions on class resource.

In a short way,

```ruby
statement_for Campaign do
  actions [:create]
  class_resource
end
```

### `conditions` on instance resource

`conditions` is a hash. This is directly used to query database, so it should be real database column names. You can refer to `Hash of Conditions` section from [Defining Abilities - CanCanCan](https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities#hash-of-conditions).

When things are too complicated and it's hard to express it a hash, then there's a little detour.

```ruby
ids = extract_campaign_ids_somehow
statement_for Campaign do
  actions [:create]
  conditions({ id: ids })
end
```

First, you can extract ids or other values through some complicated business logic of yours. Then, pass it to conditions like the above.

However we can make this better by wrapping the conditions with `proc`. This enables lazy-loading.

```ruby
statement_for Campaign do
  actions [:create]
  conditions(proc {
    ids = extract_campaign_ids_somehow

    { id: ids }
  })
end
```

So basically this `conditions` method takes `a hash` or `a proc returning a hash` as a parameter.

## Using `Ability`

You can use `Ability` class just as you did with `CanCanCan`. The constructor takes one parameter: `user`.

With `PickyGuard`, you can pass optional second parameter which is `resource`.

```ruby
Ability.new(user, Campaign).can? :read, Campaign.first
```

This will load only relevant policies.

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

or

```
gem install gem-release
gem bump --version NEW_VERSION
gem release
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/eunjae-lee/picky_guard.
