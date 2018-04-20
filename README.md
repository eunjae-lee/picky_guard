# PickyGuard

PickyGuard is a wrapper library for [CanCanCan](https://github.com/CanCanCommunity/cancancan) with an opinionated hierarchy.

Briefly,
* *User* has many *roles*.
* Each *role* has many *policies*.
* Each *policy* has many *statements* describing which *actions* has what *effect* on which *resources*.

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

This class defines the way to check if user has specific role. It assumes you already have received some roles before.

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
    map(Report, %w[Create Read Update Delete])
  end
end
```

This class defines which resource can have which actions. Actions can be either `String` or `Symbol`.

By defining this, you can explicitly manage list of actions per resource and filter out unexpected and unknown actions.

### role_policies.rb

The generated file is like this:

```ruby
class RolePolicies < PickyGuard::RolePolicies
  def initialize
    map(:role_report_manager, [ManageAllReports])
    # map(:role_report_reader, [AnotherPolicy])
  end
end
```

This class defines which role has which policies. From the code above, there is a role named `:role_report_manager` and it has one policy named `ManageAllReports`.

Then how do we define policy?

## Defining Policies

To generate new policy, execute this:

```
$ rails generate picky_guard:policy manage_all_reports
```

From the command line, name should be underscored. Otherwise, it will raise an error.

If you get to have many policies, you can group them into a folder like this:

```
$ rails generate picky_guard:policy reports/manage_all_reports
```

Once created, you will find the policy file under `app/picky_guard/policies/`.

The generated file is like this:

```ruby
class ManageAllReports < PickyGuard::Policy
  def initialize(current_user)
    register(Campaign, PickyGuard::StatementBuilder.new
                                                   .allow
                                                   .actions(%w[Create])
                                                   .resource(Campaign)
                                                   .conditions({})
                                                   .build)
    register(Campaign, PickyGuard::StatementBuilder.new
                                                   .allow
                                                   .actions(%w[Create])
                                                   .class_resource(Campaign)
                                                   .build)
  end
end
```

`register` method takes two parameters
* A Resource class. It should be a class extending `ActiveRecord::Base`.
* An instance of `PickyGuard::Statement`. It's built by `PickyGuard::StatementBuilder`.

### Building Statement

There are two types of resources: instance resource and class resource.

```ruby
can? :read, Campaign.first    # Checking permission against an instance resource

can? :create, Campaign        # Checking permission against a class resource
```

We use `instance resource` a lot more than `class resource`, so let's just call it `resource`.

In case of `resource`, we need
* effect(allow or deny)
* actions
* resource
* conditions

In case of `class resource`, we need
* effect
* actions
* class_resource

### `conditions` on resource

`conditions` is a hash. This is directly used to query database, so it should be real database column names. You can refer to `Hash of Conditions` section from [Defining Abilities - CanCanCan](https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities#hash-of-conditions).

When conditions are too complicated and you cannot express it in a hash, then there's another option.

```ruby
ids = extract_campaign_ids_somehow
register(Campaign, PickyGuard::StatementBuilder.new
                                               .allow
                                               .actions(%w[Create])
                                               .resource(Campaign)
                                               .conditions({ id: ids })
                                               .build)
```

First, you can extract ids or other values through some complicated business logic of yours. Then, pass it to conditions like the above.

However we can make this better by wrapping the statement building code with `proc`. This enables lazy-loading.

```ruby
register(Campaign, proc {
  ids = extract_campaign_ids_somehow
  PickyGuard::StatementBuilder.new
                              .allow
                              .actions(%w[Create])
                              .resource(Campaign)
                              .conditions({ id: ids })
                              .build
})
```

So basically this `register` method takes `a statement` or `a proc returning statement` as 2nd parameter.

## Using `Ability`

You can use `Ability` class just as you did with `CanCanCan`. The constructor takes one parameter of `user`.

With `PickyGuard`, you can pass optional second parameter which is `resource`.

```ruby
Ability.new(user, Campaign).can? :read, Campaign.first
```

This will load only relevant policies.

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/eunjae-lee/picky_guard.
