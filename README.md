# activerecord-scripts

Using ActiveRecord and PostgreSQL from Ruby scripts.

## Usage

Clone the repository:

```
$ git clone git@github.com:frodsan/activerecord-scripts.git
```

Install ActiveRecord and the PG adapter with Bundler:

```
$ bundle install
```

Create a script and require the `helper` file:

```
$ cat myscript.rb
require_relative "helper"
require "faker"

ActiveRecord::Schema.define do
  enable_extension :pg_stat_statements
  enable_extension :citext

  create_table :users, id: :bigserial, force: true do |t|
    t.citext :username, null: false

    t.timestamps
  end
end

class User < ActiveRecord::Base
end

User.create!(username: "frodsan")

100.times do |i|
  User.create!(username: Faker::Internet.user_name.prepend(i.to_s))
end

ActiveRecord::Schema.define do
  add_index :users, :username, unique: true
end

ActiveRecord::Base.connection.execute("ANALYZE users")

Benchmark.ips do |x|
  x.report("find_by") { User.find_by(username: "frodsan") }
  x.report("where")   { User.where(username: "frodsan").first }
  x.compare!
end
```

Run the script with:

```
$ ruby myscript.rb
```

To see the SQL queries, use:

```
$ LOG=1 ruby myscript.rb
```
