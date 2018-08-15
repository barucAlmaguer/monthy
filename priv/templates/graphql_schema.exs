defmodule ValiotAppWeb.Schema do
  use Absinthe.Schema
  import_types(ValiotAppWeb.Schema.Types)
  import_types(ValiotAppWeb.Schema.ValiotTypes)
  import_types(Absinthe.Type.Custom)

  query do
    # Users

    @desc "Logout"
    field :sign_out, type: :user do
      resolve(&ValiotApp.UserResolver.logout/2)
    end

    @desc "Get all users"
    field :users, list_of(:user) do
      resolve(&ValiotApp.UserResolver.all/2)
    end

    @desc "Get info for user"
    field :user, type: :user do
      arg(:id, non_null(:id))
      resolve(&ValiotApp.UserResolver.find/2)
    end
    <%= for {schema, values} <- types do %>
    @desc <%= inspect "Get all #{schema |> Inflex.pluralize |> Inflex.underscore}" %>
    field <%= inspect schema |> Inflex.pluralize |> Inflex.underscore |> String.to_atom %>, list_of(<%= inspect schema |> Inflex.underscore |> String.to_atom %>) do
      arg(:filter, :filters_<%= schema |> Inflex.underscore %>)
      arg(:order_by, :order_<%= schema |> Inflex.underscore %>)
      arg(:limit, :integer)
      arg(:offset, :integer)
      resolve(&ValiotApp.<%= inspect [Atom.to_string(schema)] |> Module.concat %>Resolver.all/2)
    end

    @desc <%= inspect "Get info for #{schema |> Inflex.underscore}" %>
    field <%= inspect schema |> Inflex.underscore |> String.to_atom %>, type: <%= inspect schema |> Inflex.underscore |> String.to_atom %> do
      arg(:id, non_null(:id))
      resolve(&ValiotApp.<%= inspect [Atom.to_string(schema)] |> Module.concat %>Resolver.find/2)
    end
<% end %>end

  <%= for {schema, values} <- types do %>
  input_object :update_<%= schema |> Inflex.underscore %>_params do
    <%= for {type, attrs} <- values do %><%= case Map.get(attrs, :database) do %>
    <% :normal -> %>field(<%= inspect type |> Inflex.underscore |> String.to_atom %>, <%= inspect Map.get(attrs, :type) |> Inflex.underscore |> String.to_atom %>)
    <% :has_many -> %>
    <% :belongs_to -> %>field(<%= inspect type |> Inflex.underscore |> String.to_atom %>_id, :integer)
    <% :enum -> %>field(<%= inspect type |> Inflex.underscore |> String.to_atom %>, <%= inspect Map.get(attrs, :type)  |> Inflex.underscore |> String.downcase |> String.to_atom %>)
<% end %><% end %>
  end
<% end %>

  <%= for {schema, values} <- types do %>
    input_object :order_<%= schema |> Inflex.underscore %> do
      field(:asc , :<%= schema |> Inflex.underscore |> Kernel.<>("_atributes")|> String.to_atom %>)
      field(:desc , :<%= schema |> Inflex.underscore |> Kernel.<>("_atributes")|> String.to_atom %>)
    end
  <% end %>

  <%= for {schema, values} <- types do %>
  @desc <%= inspect "Filtering #{schema |> Inflex.underscore |> Inflex.pluralize}" %>
  input_object :filters_<%= schema |> Inflex.underscore %> do
    @desc "Matching id"
    field(:id, :id)
    @desc "filter of datetime before and including date"
    field(:before, :naive_datetime)
    @desc "filter of datetime after and including date"
    field(:after, :naive_datetime)
    <%= for {type, attrs} <- values do %>
    <%= case Map.get(attrs, :database) do %>
    <% :normal -> %>@desc <%= inspect "Matching #{type |> Inflex.underscore }" %>
    field(<%= inspect type |> Inflex.underscore |> String.to_atom %>, <%= inspect Map.get(attrs, :type) |> Inflex.underscore |> String.to_atom %>)
    <% :has_many -> %>
    <% :belongs_to -> %>
    <% :enum -> %>@desc <%= inspect "Matching #{type |> Inflex.underscore }" %>
    field(<%= inspect type |> Inflex.underscore |> String.to_atom %>, <%= inspect Map.get(attrs, :type) |> Inflex.underscore |> String.to_atom %>)
    <% end %><% end %>
  end
<% end %>

  mutation do
    <%= for {schema, values} <- types do %>
    @desc <%= inspect "Update #{schema |> Inflex.underscore}" %>
    field :update_<%= schema |> Inflex.underscore %>, type: <%= inspect schema |> Inflex.underscore |> String.to_atom %> do
      arg(:id, non_null(:integer))
      arg(<%= inspect schema |> Inflex.underscore |> String.to_atom %>, :update_<%= schema |> Inflex.underscore %>_params)

      resolve(&ValiotApp.<%= inspect [Atom.to_string(schema)] |> Module.concat %>Resolver.update/2)
    end

    @desc <%= inspect "Create #{schema |> Inflex.underscore}" %>
    field :create_<%= schema |> Inflex.underscore %>, type: <%= inspect schema |> Inflex.underscore |> String.to_atom %> do
      <%= for {type, attrs} <- values do %><%= case Map.get(attrs, :database) do %>
      <% :normal -> %>arg(<%= inspect type |> Inflex.underscore |> String.to_atom %>, <%= inspect Map.get(attrs, :type) |> Inflex.underscore |> String.to_atom %>)
      <% :has_many -> %>
      <% :belongs_to -> %>arg(<%= inspect type |> Inflex.underscore |> String.to_atom %>_id, :integer)
      <% :enum -> %>arg(<%= inspect type |> Inflex.underscore |> String.to_atom %>, <%= inspect Map.get(attrs, :type)  |> Inflex.underscore |> String.downcase |> String.to_atom %>)
<% end %><% end %>

      resolve(&ValiotApp.<%= inspect [Atom.to_string(schema)] |> Module.concat %>Resolver.create/2)
    end

    @desc <%= inspect "Delete #{schema |> Inflex.underscore}" %>
    field :delete_<%= schema |> Inflex.underscore %>, type: <%= inspect schema |> Inflex.underscore |> String.to_atom %> do
      arg(:id, non_null(:id))

      resolve(&ValiotApp.<%= inspect [Atom.to_string(schema)] |> Module.concat %>Resolver.delete/2)
    end
<% end %>end

  subscription do
    <%= for {schema, values} <- types do %>
    field :update_<%= schema |> Inflex.underscore %>, <%= inspect schema |> Inflex.underscore |> String.to_atom %> do
      config(fn _args, _info ->
        {:ok, topic: "*"}
      end)
    end

    field :create_<%= schema |> Inflex.underscore %>, <%= inspect schema |> Inflex.underscore |> String.to_atom %> do
      config(fn _args, _info ->
        {:ok, topic: "*"}
      end)
    end

    field :delete_<%= schema |> Inflex.underscore %>, <%= inspect schema |> Inflex.underscore |> String.to_atom %> do
      config(fn _args, _info ->
        {:ok, topic: "*"}
      end)
    end
  <% end %>
  end

end
