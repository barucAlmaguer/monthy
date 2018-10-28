defmodule ValiotApp.Api do
  import Ecto.Query, warn: false
  alias ValiotApp.Repo
  alias ValiotApp.Api
  alias ValiotApp.Api.User

  def store_token(%User{} = user, token) do
    user
    |> User.store_token_changeset(%{token: token})
    |> Repo.update()
  end

  def revoke_token(%User{} = user, token) do
    user
    |> User.store_token_changeset(%{token: token})
    |> Repo.update()
  end

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)
  def get_user(id), do: Repo.get(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.update_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  def list_profiles do
    Repo.all(Api.Profile)
  end

  def list_profiles(filters) do
    filters
    |> Enum.reduce(Api.Profile, fn
      {_, nil}, query ->
        query
      {:filter, filter}, query ->
        query |> filter_profiles(filter)
      {:limit, limit}, query ->
        from q in query, limit: ^limit
      {:offset, offset}, query ->
        from q in query, offset: ^offset
      {:order_by, order}, query ->
        case order do
          %{asc: asc} ->
            from(q in query, order_by: field(q, ^asc))
          %{desc: desc}->
            from(q in query, order_by: [desc: field(q, ^desc)])
        end
    end)
    |> Repo.all()
  end

  def list_profiles(filters, item) do
    field_belong = item.__struct__ |> to_string() |> Inflex.underscore |> String.split(".") |> List.last |>
    String.downcase |> Kernel.<>("_id") |>String.to_atom
    query = filters
    |> Enum.reduce(Api.Profile, fn
      {_, nil}, query ->
        query

      {:filter, filter}, query ->
        query |> filter_profiles(filter)
      {:limit, limit}, query ->
        from q in query, limit: ^limit
      {:offset, offset}, query ->
        from q in query, offset: ^offset
      {:order_by, order}, query ->
        case order do
          %{asc: asc} ->
            from(q in query, order_by: field(q, ^asc))
          %{desc: desc}->
            from(q in query, order_by: [desc: field(q, ^desc)])
        end
    end)
    from(q in query, where: field(q, ^field_belong) == ^item.id) |>
    Repo.all()
  end

  def get_profile!(id), do: Repo.get!(Api.Profile, id)
  def get_profile(id), do: Repo.get(Api.Profile, id)

  def create_profile(attrs \\ %{}) do
    %Api.Profile{}
    |> Api.Profile.changeset(attrs)
    |> Repo.insert()
  end

  def update_profile(%Api.Profile{} = profile, attrs) do
    profile
    |> Api.Profile.changeset(attrs)
    |> Repo.update()
  end

  def delete_profile(%Api.Profile{} = profile) do
    Repo.delete(profile)
  end

  def change_profile(%Api.Profile{} = profile) do
    Api.Profile.changeset(profile, %{})
  end

  def filter_profiles(query, filter) do
    Enum.reduce(filter, query, fn
      {:id, id}, query ->
        from(q in query, where: q.id == ^id)
      {:before, date}, query ->
        from q in query, where: q.inserted_at <= ^date
      {:after, date}, query ->
        from q in query, where: q.inserted_at >= ^date
      {:ids, ids}, query ->
          from q in query, where: q.id in ^ids




        {:description, description}, query ->

              from q in query, where: fragment("? ~ ?", q.description, ^"#{description}")



        {:main, main}, query ->

              from q in query, where: fragment("? ~ ?", q.main, ^"#{main}")



        {:name, name}, query ->

              from q in query, where: fragment("? ~ ?", q.name, ^"#{name}")



        {:picture, picture}, query ->

              from q in query, where: fragment("? ~ ?", q.picture, ^"#{picture}")






    end)
  end

  def list_roles do
    Repo.all(Api.Role)
  end

  def list_roles(filters) do
    filters
    |> Enum.reduce(Api.Role, fn
      {_, nil}, query ->
        query
      {:filter, filter}, query ->
        query |> filter_roles(filter)
      {:limit, limit}, query ->
        from q in query, limit: ^limit
      {:offset, offset}, query ->
        from q in query, offset: ^offset
      {:order_by, order}, query ->
        case order do
          %{asc: asc} ->
            from(q in query, order_by: field(q, ^asc))
          %{desc: desc}->
            from(q in query, order_by: [desc: field(q, ^desc)])
        end
    end)
    |> Repo.all()
  end

  def list_roles(filters, item) do
    field_belong = item.__struct__ |> to_string() |> Inflex.underscore |> String.split(".") |> List.last |>
    String.downcase |> Kernel.<>("_id") |>String.to_atom
    query = filters
    |> Enum.reduce(Api.Role, fn
      {_, nil}, query ->
        query

      {:filter, filter}, query ->
        query |> filter_roles(filter)
      {:limit, limit}, query ->
        from q in query, limit: ^limit
      {:offset, offset}, query ->
        from q in query, offset: ^offset
      {:order_by, order}, query ->
        case order do
          %{asc: asc} ->
            from(q in query, order_by: field(q, ^asc))
          %{desc: desc}->
            from(q in query, order_by: [desc: field(q, ^desc)])
        end
    end)
    from(q in query, where: field(q, ^field_belong) == ^item.id) |>
    Repo.all()
  end

  def get_role!(id), do: Repo.get!(Api.Role, id)
  def get_role(id), do: Repo.get(Api.Role, id)

  def create_role(attrs \\ %{}) do
    %Api.Role{}
    |> Api.Role.changeset(attrs)
    |> Repo.insert()
  end

  def update_role(%Api.Role{} = role, attrs) do
    role
    |> Api.Role.changeset(attrs)
    |> Repo.update()
  end

  def delete_role(%Api.Role{} = role) do
    Repo.delete(role)
  end

  def change_role(%Api.Role{} = role) do
    Api.Role.changeset(role, %{})
  end

  def filter_roles(query, filter) do
    Enum.reduce(filter, query, fn
      {:id, id}, query ->
        from(q in query, where: q.id == ^id)
      {:before, date}, query ->
        from q in query, where: q.inserted_at <= ^date
      {:after, date}, query ->
        from q in query, where: q.inserted_at >= ^date
      {:ids, ids}, query ->
          from q in query, where: q.id in ^ids

        {:name, name}, query ->

              from q in query, where: fragment("? ~ ?", q.name, ^"#{name}")



    end)
  end

  def list_projects do
    Repo.all(Api.Project)
  end

  def list_projects(filters) do
    filters
    |> Enum.reduce(Api.Project, fn
      {_, nil}, query ->
        query
      {:filter, filter}, query ->
        query |> filter_projects(filter)
      {:limit, limit}, query ->
        from q in query, limit: ^limit
      {:offset, offset}, query ->
        from q in query, offset: ^offset
      {:order_by, order}, query ->
        case order do
          %{asc: asc} ->
            from(q in query, order_by: field(q, ^asc))
          %{desc: desc}->
            from(q in query, order_by: [desc: field(q, ^desc)])
        end
    end)
    |> Repo.all()
  end

  def list_projects(filters, item) do
    field_belong = item.__struct__ |> to_string() |> Inflex.underscore |> String.split(".") |> List.last |>
    String.downcase |> Kernel.<>("_id") |>String.to_atom
    query = filters
    |> Enum.reduce(Api.Project, fn
      {_, nil}, query ->
        query

      {:filter, filter}, query ->
        query |> filter_projects(filter)
      {:limit, limit}, query ->
        from q in query, limit: ^limit
      {:offset, offset}, query ->
        from q in query, offset: ^offset
      {:order_by, order}, query ->
        case order do
          %{asc: asc} ->
            from(q in query, order_by: field(q, ^asc))
          %{desc: desc}->
            from(q in query, order_by: [desc: field(q, ^desc)])
        end
    end)
    from(q in query, where: field(q, ^field_belong) == ^item.id) |>
    Repo.all()
  end

  def get_project!(id), do: Repo.get!(Api.Project, id)
  def get_project(id), do: Repo.get(Api.Project, id)

  def create_project(attrs \\ %{}) do
    %Api.Project{}
    |> Api.Project.changeset(attrs)
    |> Repo.insert()
  end

  def update_project(%Api.Project{} = project, attrs) do
    project
    |> Api.Project.changeset(attrs)
    |> Repo.update()
  end

  def delete_project(%Api.Project{} = project) do
    Repo.delete(project)
  end

  def change_project(%Api.Project{} = project) do
    Api.Project.changeset(project, %{})
  end

  def filter_projects(query, filter) do
    Enum.reduce(filter, query, fn
      {:id, id}, query ->
        from(q in query, where: q.id == ^id)
      {:before, date}, query ->
        from q in query, where: q.inserted_at <= ^date
      {:after, date}, query ->
        from q in query, where: q.inserted_at >= ^date
      {:ids, ids}, query ->
          from q in query, where: q.id in ^ids




        {:description, description}, query ->

              from q in query, where: fragment("? ~ ?", q.description, ^"#{description}")






        {:name, name}, query ->

              from q in query, where: fragment("? ~ ?", q.name, ^"#{name}")



        {:tag, tag}, query ->

              from q in query, where: fragment("? ~ ?", q.tag, ^"#{tag}")



    end)
  end

  def list_issues do
    Repo.all(Api.Issue)
  end

  def list_issues(filters) do
    filters
    |> Enum.reduce(Api.Issue, fn
      {_, nil}, query ->
        query
      {:filter, filter}, query ->
        query |> filter_issues(filter)
      {:limit, limit}, query ->
        from q in query, limit: ^limit
      {:offset, offset}, query ->
        from q in query, offset: ^offset
      {:order_by, order}, query ->
        case order do
          %{asc: asc} ->
            from(q in query, order_by: field(q, ^asc))
          %{desc: desc}->
            from(q in query, order_by: [desc: field(q, ^desc)])
        end
    end)
    |> Repo.all()
  end

  def list_issues(filters, item) do
    field_belong = item.__struct__ |> to_string() |> Inflex.underscore |> String.split(".") |> List.last |>
    String.downcase |> Kernel.<>("_id") |>String.to_atom
    query = filters
    |> Enum.reduce(Api.Issue, fn
      {_, nil}, query ->
        query

      {:filter, filter}, query ->
        query |> filter_issues(filter)
      {:limit, limit}, query ->
        from q in query, limit: ^limit
      {:offset, offset}, query ->
        from q in query, offset: ^offset
      {:order_by, order}, query ->
        case order do
          %{asc: asc} ->
            from(q in query, order_by: field(q, ^asc))
          %{desc: desc}->
            from(q in query, order_by: [desc: field(q, ^desc)])
        end
    end)
    from(q in query, where: field(q, ^field_belong) == ^item.id) |>
    Repo.all()
  end

  def get_issue!(id), do: Repo.get!(Api.Issue, id)
  def get_issue(id), do: Repo.get(Api.Issue, id)

  def create_issue(attrs \\ %{}) do
    %Api.Issue{}
    |> Api.Issue.changeset(attrs)
    |> Repo.insert()
  end

  def update_issue(%Api.Issue{} = issue, attrs) do
    issue
    |> Api.Issue.changeset(attrs)
    |> Repo.update()
  end

  def delete_issue(%Api.Issue{} = issue) do
    Repo.delete(issue)
  end

  def change_issue(%Api.Issue{} = issue) do
    Api.Issue.changeset(issue, %{})
  end

  def filter_issues(query, filter) do
    Enum.reduce(filter, query, fn
      {:id, id}, query ->
        from(q in query, where: q.id == ^id)
      {:before, date}, query ->
        from q in query, where: q.inserted_at <= ^date
      {:after, date}, query ->
        from q in query, where: q.inserted_at >= ^date
      {:ids, ids}, query ->
          from q in query, where: q.id in ^ids




        {:description, description}, query ->

              from q in query, where: fragment("? ~ ?", q.description, ^"#{description}")



        {:name, name}, query ->

              from q in query, where: fragment("? ~ ?", q.name, ^"#{name}")









    end)
  end

  def list_areas do
    Repo.all(Api.Area)
  end

  def list_areas(filters) do
    filters
    |> Enum.reduce(Api.Area, fn
      {_, nil}, query ->
        query
      {:filter, filter}, query ->
        query |> filter_areas(filter)
      {:limit, limit}, query ->
        from q in query, limit: ^limit
      {:offset, offset}, query ->
        from q in query, offset: ^offset
      {:order_by, order}, query ->
        case order do
          %{asc: asc} ->
            from(q in query, order_by: field(q, ^asc))
          %{desc: desc}->
            from(q in query, order_by: [desc: field(q, ^desc)])
        end
    end)
    |> Repo.all()
  end

  def list_areas(filters, item) do
    field_belong = item.__struct__ |> to_string() |> Inflex.underscore |> String.split(".") |> List.last |>
    String.downcase |> Kernel.<>("_id") |>String.to_atom
    query = filters
    |> Enum.reduce(Api.Area, fn
      {_, nil}, query ->
        query

      {:filter, filter}, query ->
        query |> filter_areas(filter)
      {:limit, limit}, query ->
        from q in query, limit: ^limit
      {:offset, offset}, query ->
        from q in query, offset: ^offset
      {:order_by, order}, query ->
        case order do
          %{asc: asc} ->
            from(q in query, order_by: field(q, ^asc))
          %{desc: desc}->
            from(q in query, order_by: [desc: field(q, ^desc)])
        end
    end)
    from(q in query, where: field(q, ^field_belong) == ^item.id) |>
    Repo.all()
  end

  def get_area!(id), do: Repo.get!(Api.Area, id)
  def get_area(id), do: Repo.get(Api.Area, id)

  def create_area(attrs \\ %{}) do
    %Api.Area{}
    |> Api.Area.changeset(attrs)
    |> Repo.insert()
  end

  def update_area(%Api.Area{} = area, attrs) do
    area
    |> Api.Area.changeset(attrs)
    |> Repo.update()
  end

  def delete_area(%Api.Area{} = area) do
    Repo.delete(area)
  end

  def change_area(%Api.Area{} = area) do
    Api.Area.changeset(area, %{})
  end

  def filter_areas(query, filter) do
    Enum.reduce(filter, query, fn
      {:id, id}, query ->
        from(q in query, where: q.id == ^id)
      {:before, date}, query ->
        from q in query, where: q.inserted_at <= ^date
      {:after, date}, query ->
        from q in query, where: q.inserted_at >= ^date
      {:ids, ids}, query ->
          from q in query, where: q.id in ^ids




        {:name, name}, query ->

              from q in query, where: fragment("? ~ ?", q.name, ^"#{name}")









    end)
  end

  def list_project_profiles do
    Repo.all(Api.ProjectProfile)
  end

  def list_project_profiles(filters) do
    filters
    |> Enum.reduce(Api.ProjectProfile, fn
      {_, nil}, query ->
        query
      {:filter, filter}, query ->
        query |> filter_project_profiles(filter)
      {:limit, limit}, query ->
        from q in query, limit: ^limit
      {:offset, offset}, query ->
        from q in query, offset: ^offset
      {:order_by, order}, query ->
        case order do
          %{asc: asc} ->
            from(q in query, order_by: field(q, ^asc))
          %{desc: desc}->
            from(q in query, order_by: [desc: field(q, ^desc)])
        end
    end)
    |> Repo.all()
  end

  def list_project_profiles(filters, item) do
    field_belong = item.__struct__ |> to_string() |> Inflex.underscore |> String.split(".") |> List.last |>
    String.downcase |> Kernel.<>("_id") |>String.to_atom
    query = filters
    |> Enum.reduce(Api.ProjectProfile, fn
      {_, nil}, query ->
        query

      {:filter, filter}, query ->
        query |> filter_project_profiles(filter)
      {:limit, limit}, query ->
        from q in query, limit: ^limit
      {:offset, offset}, query ->
        from q in query, offset: ^offset
      {:order_by, order}, query ->
        case order do
          %{asc: asc} ->
            from(q in query, order_by: field(q, ^asc))
          %{desc: desc}->
            from(q in query, order_by: [desc: field(q, ^desc)])
        end
    end)
    from(q in query, where: field(q, ^field_belong) == ^item.id) |>
    Repo.all()
  end

  def get_project_profile!(id), do: Repo.get!(Api.ProjectProfile, id)
  def get_project_profile(id), do: Repo.get(Api.ProjectProfile, id)

  def create_project_profile(attrs \\ %{}) do
    %Api.ProjectProfile{}
    |> Api.ProjectProfile.changeset(attrs)
    |> Repo.insert()
  end

  def update_project_profile(%Api.ProjectProfile{} = project_profile, attrs) do
    project_profile
    |> Api.ProjectProfile.changeset(attrs)
    |> Repo.update()
  end

  def delete_project_profile(%Api.ProjectProfile{} = project_profile) do
    Repo.delete(project_profile)
  end

  def change_project_profile(%Api.ProjectProfile{} = project_profile) do
    Api.ProjectProfile.changeset(project_profile, %{})
  end

  def filter_project_profiles(query, filter) do
    Enum.reduce(filter, query, fn
      {:id, id}, query ->
        from(q in query, where: q.id == ^id)
      {:before, date}, query ->
        from q in query, where: q.inserted_at <= ^date
      {:after, date}, query ->
        from q in query, where: q.inserted_at >= ^date
      {:ids, ids}, query ->
          from q in query, where: q.id in ^ids










    end)
  end

  def list_area_issues do
    Repo.all(Api.AreaIssue)
  end

  def list_area_issues(filters) do
    filters
    |> Enum.reduce(Api.AreaIssue, fn
      {_, nil}, query ->
        query
      {:filter, filter}, query ->
        query |> filter_area_issues(filter)
      {:limit, limit}, query ->
        from q in query, limit: ^limit
      {:offset, offset}, query ->
        from q in query, offset: ^offset
      {:order_by, order}, query ->
        case order do
          %{asc: asc} ->
            from(q in query, order_by: field(q, ^asc))
          %{desc: desc}->
            from(q in query, order_by: [desc: field(q, ^desc)])
        end
    end)
    |> Repo.all()
  end

  def list_area_issues(filters, item) do
    field_belong = item.__struct__ |> to_string() |> Inflex.underscore |> String.split(".") |> List.last |>
    String.downcase |> Kernel.<>("_id") |>String.to_atom
    query = filters
    |> Enum.reduce(Api.AreaIssue, fn
      {_, nil}, query ->
        query

      {:filter, filter}, query ->
        query |> filter_area_issues(filter)
      {:limit, limit}, query ->
        from q in query, limit: ^limit
      {:offset, offset}, query ->
        from q in query, offset: ^offset
      {:order_by, order}, query ->
        case order do
          %{asc: asc} ->
            from(q in query, order_by: field(q, ^asc))
          %{desc: desc}->
            from(q in query, order_by: [desc: field(q, ^desc)])
        end
    end)
    from(q in query, where: field(q, ^field_belong) == ^item.id) |>
    Repo.all()
  end

  def get_area_issue!(id), do: Repo.get!(Api.AreaIssue, id)
  def get_area_issue(id), do: Repo.get(Api.AreaIssue, id)

  def create_area_issue(attrs \\ %{}) do
    %Api.AreaIssue{}
    |> Api.AreaIssue.changeset(attrs)
    |> Repo.insert()
  end

  def update_area_issue(%Api.AreaIssue{} = area_issue, attrs) do
    area_issue
    |> Api.AreaIssue.changeset(attrs)
    |> Repo.update()
  end

  def delete_area_issue(%Api.AreaIssue{} = area_issue) do
    Repo.delete(area_issue)
  end

  def change_area_issue(%Api.AreaIssue{} = area_issue) do
    Api.AreaIssue.changeset(area_issue, %{})
  end

  def filter_area_issues(query, filter) do
    Enum.reduce(filter, query, fn
      {:id, id}, query ->
        from(q in query, where: q.id == ^id)
      {:before, date}, query ->
        from q in query, where: q.inserted_at <= ^date
      {:after, date}, query ->
        from q in query, where: q.inserted_at >= ^date
      {:ids, ids}, query ->
          from q in query, where: q.id in ^ids







    end)
  end

  def list_permissions do
    Repo.all(Api.Permission)
  end

  def list_permissions(filters) do
    filters
    |> Enum.reduce(Api.Permission, fn
      {_, nil}, query ->
        query
      {:filter, filter}, query ->
        query |> filter_permissions(filter)
      {:limit, limit}, query ->
        from q in query, limit: ^limit
      {:offset, offset}, query ->
        from q in query, offset: ^offset
      {:order_by, order}, query ->
        case order do
          %{asc: asc} ->
            from(q in query, order_by: field(q, ^asc))
          %{desc: desc}->
            from(q in query, order_by: [desc: field(q, ^desc)])
        end
    end)
    |> Repo.all()
  end

  def list_permissions(filters, item) do
    field_belong = item.__struct__ |> to_string() |> Inflex.underscore |> String.split(".") |> List.last |>
    String.downcase |> Kernel.<>("_id") |>String.to_atom
    query = filters
    |> Enum.reduce(Api.Permission, fn
      {_, nil}, query ->
        query

      {:filter, filter}, query ->
        query |> filter_permissions(filter)
      {:limit, limit}, query ->
        from q in query, limit: ^limit
      {:offset, offset}, query ->
        from q in query, offset: ^offset
      {:order_by, order}, query ->
        case order do
          %{asc: asc} ->
            from(q in query, order_by: field(q, ^asc))
          %{desc: desc}->
            from(q in query, order_by: [desc: field(q, ^desc)])
        end
    end)
    from(q in query, where: field(q, ^field_belong) == ^item.id) |>
    Repo.all()
  end

  def get_permission!(id), do: Repo.get!(Api.Permission, id)
  def get_permission(id), do: Repo.get(Api.Permission, id)

  def create_permission(attrs \\ %{}) do
    %Api.Permission{}
    |> Api.Permission.changeset(attrs)
    |> Repo.insert()
  end

  def update_permission(%Api.Permission{} = permission, attrs) do
    permission
    |> Api.Permission.changeset(attrs)
    |> Repo.update()
  end

  def delete_permission(%Api.Permission{} = permission) do
    Repo.delete(permission)
  end

  def change_permission(%Api.Permission{} = permission) do
    Api.Permission.changeset(permission, %{})
  end

  def filter_permissions(query, filter) do
    Enum.reduce(filter, query, fn
      {:id, id}, query ->
        from(q in query, where: q.id == ^id)
      {:before, date}, query ->
        from q in query, where: q.inserted_at <= ^date
      {:after, date}, query ->
        from q in query, where: q.inserted_at >= ^date
      {:ids, ids}, query ->
          from q in query, where: q.id in ^ids

        {:create, create}, query ->

              from(q in query, where: q.create == ^create)



        {:delete, delete}, query ->

              from(q in query, where: q.delete == ^delete)



        {:read, read}, query ->

              from(q in query, where: q.read == ^read)



        {:relation, relation}, query ->
          from(q in query, where: q.relation == ^relation)


        {:token_id, token_id}, query ->

              from(q in query, where: q.token_id == ^token_id)



        {:update, update}, query ->

              from(q in query, where: q.update == ^update)



    end)
  end
end
