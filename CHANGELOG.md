# Master

# 0.4.0
- [New Feature] Use valiot-auth for tokens.
- [New Feature] Remove ValiotRepo

# 0.3.0
- [Bug Fix] Fix missing underscore on list_ belongs to.
- [New feature] Filter by strings can now use POSIX (Regex)

# 0.2.1
- [New feature] Added Text type for longer than 255 strings.
- [New feature] Query association id in belongs_to
- [New feature] Use Jason instead of Poison
- [New feature] Added One to One relationships

# 0.2.0
- [New feature] Added kronky for better error responses on mutations
- [New feature] Changed subscriptions names
- [New feature] Add unique field support on generator
- [New feature] Add filter by list of ids
- [Bug Fix] Subscriptions now require authorization
- [Maintance] Update dependencies, elixir, and erlang

# 0.1.0
- [Bug Fix] Enum with multiple words works now
- [Bug Fix] Queries for inserted_at and created_at work now
- [New feature] Limit, offset and orderBy can be used on a has_many relationship
- [New feature] All tables have CRUD permissions by default false
- [Bug Fix] Warning type unused variable fixed.
