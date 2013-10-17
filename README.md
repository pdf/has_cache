HasCache
========
Adds easy to access Rails caching to any class.

Using `has_cache` in your classes provides a `cached` method that allows
chaining of a method that is normally available on the class, and automatically
caching the result.

Usage
-----
Simply call `has_cache` in your class, for example in a model:

```ruby
class User < ActiveRecord::Base
  has_many :posts, inverse_of: :user

  has_cache
end

class Post < ActiveRecord::Base
  belongs_to :user, inverse_of: :posts
end
```

Now you can call:

```ruby
user = User.first
user_posts = user.cached.posts
```

And the result of `user.posts` will be cached using the Rails Cache Store, so
that the next time you call `user.cached.posts`, the result will be returned
from the cache, rather than the model.

You may chain any method that the class would normally respond to, for example,
caching all records via `ActiveRecord::Base.all`:

```ruby
all_users = User.cached.all
```

License
=======
This project rocks and uses the `MIT-LICENSE`.
