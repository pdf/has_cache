# HasCache
Convenience wrapper for the [Rails Cache Store](http://guides.rubyonrails.org/caching_with_rails.html#cache-stores)

Using `has_cache` in your classes provides a `cached` method that allows
automatic caching of the result of a method that is normally available on
the class, or an instance of the class.

It mitigates the hassle of creating and tracking keys as you would with
the standard Cache Store interface, by inferring keys from the location
`cached` is invoked.

## Usage
### Enable caching on your class/model
Include `has_cache` in your Rails project's `Gemfile`:

```ruby
gem 'has_cache'
```

Call `has_cache` in your class, for example in a model:

```ruby
class User < ActiveRecord::Base
  has_many :posts, inverse_of: :user

  has_cache
end

class Post < ActiveRecord::Base
  belongs_to :user, inverse_of: :posts
end
```

### Populate and retrieve cached entities
Having enabled caching on your class, you can call:

```ruby
user = User.first
user_posts = user.cached.posts
```

And the result of `user.posts` will be cached using the [Rails Cache Store](http://guides.rubyonrails.org/caching_with_rails.html#cache-stores),
so that the next time you call `user.cached.posts`, the result will be returned
from the cache, rather than the model.

You may call any method that the class would normally respond to, for example,
caching all records via `ActiveRecord::Base.all`:

```ruby
all_users = User.cached.all
```

If you wish to cache the result of chained methods, you may use block syntax,
as follows:

```ruby
first_user = User.first
first_users_first_post = user.cached{ posts.first }
```

### Delete cached entities
To delete cached entities, simply replace the `cached` method with `delete_cached`:

```ruby
user = User.first
# Cache some entities
user_posts = user.cached.posts
# Delete the cache
user.delete_cached.posts
```

The `delete_cached` method takes all the same arguments as the `cached` method, and
to ensure that the correct cache key is deleted, you must pass the exact same
arguments, and chain the same methods, as the original call to `cached`.

## Options
### Cache options
The `has_cache` method can take any options that are supported by your [Rails Cache Store](http://guides.rubyonrails.org/caching_with_rails.html#cache-stores).
These options will be used as defaults for calls to the `cached` method on both
the class and it's instances.

For example, with our `User` model:

```ruby
class User < ActiveRecord::Base
  ...

  has_cache expires_in: 1.hour
end
```

All calls to `User.cached` would store items in the cache with expiry of one
hour.

You can also specify Cache Store options when calling `cached` to override
any default options, ie:

```ruby
User.cached(expires_in: 1.day).all
```

The above would cause the cache to store that particular result with an
expiry of one day, rather than the default one hour we specified above.

### Custom keys
Much of the convenience of `has_cache` comes from it's ability to automatically
generate keys for the Cache Store, however sometimes you may need to generate
keys by some other means.

Generated key names take the form of:

| Called on object | Example call                             | Generated key             |
|------------------|------------------------------------------|---------------------------|
| Class            | `User.cached.all`                        | `'User/class/all'`        |
| Instance         | `user = User.find(1); user.cached.posts` | `'User/instance/1/posts'` |

There are a number of ways to customize keys in `has_cache`.

#### As an argument to #cached
Firstly, you may specify a key in the call to `cached`:

```ruby
User.cached(key: 'widget').all
```

Would result in a key of: `User/class/widget/all`

```ruby
user = User.find(1)
user_posts = user.cached(key: 'widget').posts
```

Would result in a key of: `User/instance/widget/posts`

If for some reason you need to drop the method name or arguments from the key,
you may add `canonical_key` to the arguments, like so:

```ruby
User.cached(key: 'widget', canonical_key: true)
```

Would result in a key of: `User/class/widget`

If the passed key is a `Proc` or `lambda`, it will be executed in the scope of
the caller:

```ruby
user = User.create(email: 'user@example.com')
user_posts = user.cached(key: lambda { email }).posts
```

Would result in a key of: `User/instance/user@example.com/posts`

Be careful of scope here though, as obviously using the same lambda on the class
would fail:

```ruby
User.cached(key: lambda { email }).find(1)
=> Exception: NoMethodError: undefined method `email' for User:Class`
```

#### As a method
Next, you may generate the key by implementing a `has_cache_key` class or
instance method.  This is quite powerful, so let's look at a somewhat
involved example.

Assuming our `User` class allows versioning, and when viewing a versioned
instance (retrieved via `#get_version`), it responds `true` to `#versioned?`
and returns the version number via `#version_number`, our `#has_cache_key`
method might look like the following:

```ruby
class User < ActiveRecord::Base
  has_many :posts, inverse_of: :user

  has_cache

  def has_cache_key
    key = [id]
    key += [{ version: version_number }] if versioned?
  end
end
```

Now, if we're looking the original user:

```ruby
user = User.find(1)
user_posts = user.cached.posts
```

Our generated key would be: `User/instance/1/posts`

However, if we're looking at a versioned instance:

```ruby
user = User.find(1)
versioned_user = user.get_version(7)
versioned_user_posts = versioned_user.cached.posts
```

Our generated key would be: `User/instance/1/version=7/posts`

It is important to not that as we've only defined `has_cache_key` as an
instance method, calls to `cached` on the class remain unaffected, however
defining a `has_cache_key` class method is also supported.

## Caveats
### Chained methods
As mentioned briefly above, only the first method following `cached` is stored
in the cache, so in a prior example, if you call:

```ruby
first_user = User.cached.all.first
```

The cache will be populated with the result from `User.all`, which will then
have `#first` called on it.  This may not be what you expect, in which case
the block notation should be used, ie:

```ruby
first_user = User.cached{ all.first }
```

In which case, the result from `User.all.first` will be cached as expected.

### Block notation keys
Currently, when using block notation as above, we generate keys by converting
the block to source using the `sourcify` gem.  This is not an optimal solution
as it's slow and gets easily confused by nested blocks.  Sometimes, it simply
fails to generate keys entirely, requiring the user to specify a custom key,
which is far from optimal.  I'm investigating alternatives, but don't have a
better solution at this stage.

# TODO
- Needs more specs, particularly custom key handling is untested currently.
- Documentation - the code is appallingly light on comments
- Block parsing using `sourcify` seems like a really hacky solution, would
  welcome pull requests for a better solution.

# License
This project rocks and uses the `MIT-LICENSE`.
