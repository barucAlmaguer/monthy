defmodule ValiotAppWeb.Schema do
  use Absinthe.Schema
  import Kronky.Payload
  import_types(ValiotAppWeb.Schema.Types)
  import_types(Absinthe.Type.Custom)
  import_types(Kronky.ValidationMessageTypes)

  query do

    @desc "Get all profiles"
    field :profiles, list_of(:profile) do
      arg(:filter, :filters_profile)
      arg(:order_by, :order_profile)
      arg(:limit, :integer)
      arg(:offset, :integer)
      resolve(&ValiotApp.ProfileResolver.all/2)
    end

    @desc "Get info for profile"
    field :profile, type: :profile do
      arg(:id, non_null(:id))
      resolve(&ValiotApp.ProfileResolver.find/2)
    end

    @desc "Get all roles"
    field :roles, list_of(:role) do
      arg(:filter, :filters_role)
      arg(:order_by, :order_role)
      arg(:limit, :integer)
      arg(:offset, :integer)
      resolve(&ValiotApp.RoleResolver.all/2)
    end

    @desc "Get info for role"
    field :role, type: :role do
      arg(:id, non_null(:id))
      resolve(&ValiotApp.RoleResolver.find/2)
    end

    @desc "Get all projects"
    field :projects, list_of(:project) do
      arg(:filter, :filters_project)
      arg(:order_by, :order_project)
      arg(:limit, :integer)
      arg(:offset, :integer)
      resolve(&ValiotApp.ProjectResolver.all/2)
    end

    @desc "Get info for project"
    field :project, type: :project do
      arg(:id, non_null(:id))
      resolve(&ValiotApp.ProjectResolver.find/2)
    end

    @desc "Get all issues"
    field :issues, list_of(:issue) do
      arg(:filter, :filters_issue)
      arg(:order_by, :order_issue)
      arg(:limit, :integer)
      arg(:offset, :integer)
      resolve(&ValiotApp.IssueResolver.all/2)
    end

    @desc "Get info for issue"
    field :issue, type: :issue do
      arg(:id, non_null(:id))
      resolve(&ValiotApp.IssueResolver.find/2)
    end

    @desc "Get all areas"
    field :areas, list_of(:area) do
      arg(:filter, :filters_area)
      arg(:order_by, :order_area)
      arg(:limit, :integer)
      arg(:offset, :integer)
      resolve(&ValiotApp.AreaResolver.all/2)
    end

    @desc "Get info for area"
    field :area, type: :area do
      arg(:id, non_null(:id))
      resolve(&ValiotApp.AreaResolver.find/2)
    end

    @desc "Get all project_profiles"
    field :project_profiles, list_of(:project_profile) do
      arg(:filter, :filters_project_profile)
      arg(:order_by, :order_project_profile)
      arg(:limit, :integer)
      arg(:offset, :integer)
      resolve(&ValiotApp.ProjectProfileResolver.all/2)
    end

    @desc "Get info for project_profile"
    field :project_profile, type: :project_profile do
      arg(:id, non_null(:id))
      resolve(&ValiotApp.ProjectProfileResolver.find/2)
    end

    @desc "Get all area_issues"
    field :area_issues, list_of(:area_issue) do
      arg(:filter, :filters_area_issue)
      arg(:order_by, :order_area_issue)
      arg(:limit, :integer)
      arg(:offset, :integer)
      resolve(&ValiotApp.AreaIssueResolver.all/2)
    end

    @desc "Get info for area_issue"
    field :area_issue, type: :area_issue do
      arg(:id, non_null(:id))
      resolve(&ValiotApp.AreaIssueResolver.find/2)
    end

    @desc "Get all permissions"
    field :permissions, list_of(:permission) do
      arg(:filter, :filters_permission)
      arg(:order_by, :order_permission)
      arg(:limit, :integer)
      arg(:offset, :integer)
      resolve(&ValiotApp.PermissionResolver.all/2)
    end

    @desc "Get info for permission"
    field :permission, type: :permission do
      arg(:id, non_null(:id))
      resolve(&ValiotApp.PermissionResolver.find/2)
    end
end

  input_object :update_user_params do
    field(:username, :string)
    field(:password, :string)

  end

  input_object :update_profile_params do

    field(:description, :string)
    field(:main, :string)
    field(:name, :string)
    field(:picture, :string)


  end

  input_object :update_role_params do
    field(:name, :string)

  end

  input_object :update_project_params do

    field(:description, :string)

    field(:name, :string)
    field(:tag, :string)

  end

  input_object :update_issue_params do

    field(:description, :string)
    field(:name, :string)
    field(:profile_id, :integer)
    field(:project_id, :integer)

  end

  input_object :update_area_params do

    field(:name, :string)



  end

  input_object :update_project_profile_params do
    field(:profile_id, :integer)
    field(:project_id, :integer)
    field(:role_id, :integer)

  end

  input_object :update_area_issue_params do
    field(:area_id, :integer)
    field(:issue_id, :integer)

  end

  input_object :update_permission_params do
    field(:create, :boolean)
    field(:delete, :boolean)
    field(:read, :boolean)
    field(:relation, :relation)
field(:token_id, :integer)
    field(:update, :boolean)

  end



    input_object :order_profile do
      field(:asc , :profile_attributes)
      field(:desc , :profile_attributes)
    end

    input_object :order_role do
      field(:asc , :role_attributes)
      field(:desc , :role_attributes)
    end

    input_object :order_project do
      field(:asc , :project_attributes)
      field(:desc , :project_attributes)
    end

    input_object :order_issue do
      field(:asc , :issue_attributes)
      field(:desc , :issue_attributes)
    end

    input_object :order_area do
      field(:asc , :area_attributes)
      field(:desc , :area_attributes)
    end

    input_object :order_project_profile do
      field(:asc , :project_profile_attributes)
      field(:desc , :project_profile_attributes)
    end

    input_object :order_area_issue do
      field(:asc , :area_issue_attributes)
      field(:desc , :area_issue_attributes)
    end

    input_object :order_permission do
      field(:asc , :permission_attributes)
      field(:desc , :permission_attributes)
    end



  @desc "Filtering profiles"
  input_object :filters_profile do
    @desc "Matching id"
    field(:id, :id)
    @desc "filter of datetime before and including date"
    field(:before, :naive_datetime)
    @desc "filter of datetime after and including date"
    field(:after, :naive_datetime)
    @desc "Filter of list of ids"
    field(:ids, list_of(:integer))



    @desc "Matching description"
    field(:description, :string)

    @desc "Matching main"
    field(:main, :string)

    @desc "Matching name"
    field(:name, :string)

    @desc "Matching picture"
    field(:picture, :string)



  end

  @desc "Filtering roles"
  input_object :filters_role do
    @desc "Matching id"
    field(:id, :id)
    @desc "filter of datetime before and including date"
    field(:before, :naive_datetime)
    @desc "filter of datetime after and including date"
    field(:after, :naive_datetime)
    @desc "Filter of list of ids"
    field(:ids, list_of(:integer))

    @desc "Matching name"
    field(:name, :string)

  end

  @desc "Filtering projects"
  input_object :filters_project do
    @desc "Matching id"
    field(:id, :id)
    @desc "filter of datetime before and including date"
    field(:before, :naive_datetime)
    @desc "filter of datetime after and including date"
    field(:after, :naive_datetime)
    @desc "Filter of list of ids"
    field(:ids, list_of(:integer))



    @desc "Matching description"
    field(:description, :string)



    @desc "Matching name"
    field(:name, :string)

    @desc "Matching tag"
    field(:tag, :string)

  end

  @desc "Filtering issues"
  input_object :filters_issue do
    @desc "Matching id"
    field(:id, :id)
    @desc "filter of datetime before and including date"
    field(:before, :naive_datetime)
    @desc "filter of datetime after and including date"
    field(:after, :naive_datetime)
    @desc "Filter of list of ids"
    field(:ids, list_of(:integer))



    @desc "Matching description"
    field(:description, :string)

    @desc "Matching name"
    field(:name, :string)





  end

  @desc "Filtering areas"
  input_object :filters_area do
    @desc "Matching id"
    field(:id, :id)
    @desc "filter of datetime before and including date"
    field(:before, :naive_datetime)
    @desc "filter of datetime after and including date"
    field(:after, :naive_datetime)
    @desc "Filter of list of ids"
    field(:ids, list_of(:integer))



    @desc "Matching name"
    field(:name, :string)





  end

  @desc "Filtering project_profiles"
  input_object :filters_project_profile do
    @desc "Matching id"
    field(:id, :id)
    @desc "filter of datetime before and including date"
    field(:before, :naive_datetime)
    @desc "filter of datetime after and including date"
    field(:after, :naive_datetime)
    @desc "Filter of list of ids"
    field(:ids, list_of(:integer))







  end

  @desc "Filtering area_issues"
  input_object :filters_area_issue do
    @desc "Matching id"
    field(:id, :id)
    @desc "filter of datetime before and including date"
    field(:before, :naive_datetime)
    @desc "filter of datetime after and including date"
    field(:after, :naive_datetime)
    @desc "Filter of list of ids"
    field(:ids, list_of(:integer))





  end

  @desc "Filtering permissions"
  input_object :filters_permission do
    @desc "Matching id"
    field(:id, :id)
    @desc "filter of datetime before and including date"
    field(:before, :naive_datetime)
    @desc "filter of datetime after and including date"
    field(:after, :naive_datetime)
    @desc "Filter of list of ids"
    field(:ids, list_of(:integer))

    @desc "Matching create"
    field(:create, :boolean)

    @desc "Matching delete"
    field(:delete, :boolean)

    @desc "Matching read"
    field(:read, :boolean)

    @desc "Matching relation"
    field(:relation, :relation)

    @desc "Matching token_id"
    field(:token_id, :integer)

    @desc "Matching update"
    field(:update, :boolean)

  end


payload_object(:profile_payload, :profile)
payload_object(:role_payload, :role)
payload_object(:project_payload, :project)
payload_object(:issue_payload, :issue)
payload_object(:area_payload, :area)
payload_object(:project_profile_payload, :project_profile)
payload_object(:area_issue_payload, :area_issue)
payload_object(:permission_payload, :permission)

  mutation do
    @desc "Update user"
    field :update_user, type: :user do
      arg(:id, non_null(:integer))
      arg(:user, :update_user_params)

      resolve(&ValiotApp.UserResolver.update/2)
    end

    @desc "Login"
    field :login, type: :session do
      arg(:email, non_null(:string))
      arg(:password, non_null(:string))

      resolve(&ValiotApp.UserResolver.login/2)
    end

    @desc "Create user"
    field :create_user, type: :user do
      arg(:email, non_null(:string))
      arg(:password, non_null(:string))

      resolve(&ValiotApp.UserResolver.create/2)
    end

    @desc "Delete user"
    field :delete_user, type: :user do
      arg(:id, non_null(:id))

      resolve(&ValiotApp.UserResolver.delete/2)
    end

    @desc "Update profile"
    field :update_profile, type: :profile_payload do
      arg(:id, non_null(:integer))
      arg(:profile, :update_profile_params)

      resolve(&ValiotApp.ProfileResolver.update/2)
      middleware &build_payload/2
    end

    @desc "Create profile"
    field :create_profile, type: :profile_payload do

      arg(:description, :string)
      arg(:main, :string)
      arg(:name, :string)
      arg(:picture, :string)



      resolve(&ValiotApp.ProfileResolver.create/2)
      middleware &build_payload/2
    end

    @desc "Delete profile"
    field :delete_profile, type: :profile_payload do
      arg(:id, non_null(:id))

      resolve(&ValiotApp.ProfileResolver.delete/2)
      middleware &build_payload/2
    end

    @desc "Update role"
    field :update_role, type: :role_payload do
      arg(:id, non_null(:integer))
      arg(:role, :update_role_params)

      resolve(&ValiotApp.RoleResolver.update/2)
      middleware &build_payload/2
    end

    @desc "Create role"
    field :create_role, type: :role_payload do
      arg(:name, :string)


      resolve(&ValiotApp.RoleResolver.create/2)
      middleware &build_payload/2
    end

    @desc "Delete role"
    field :delete_role, type: :role_payload do
      arg(:id, non_null(:id))

      resolve(&ValiotApp.RoleResolver.delete/2)
      middleware &build_payload/2
    end

    @desc "Update project"
    field :update_project, type: :project_payload do
      arg(:id, non_null(:integer))
      arg(:project, :update_project_params)

      resolve(&ValiotApp.ProjectResolver.update/2)
      middleware &build_payload/2
    end

    @desc "Create project"
    field :create_project, type: :project_payload do

      arg(:description, :string)

      arg(:name, :string)
      arg(:tag, :string)


      resolve(&ValiotApp.ProjectResolver.create/2)
      middleware &build_payload/2
    end

    @desc "Delete project"
    field :delete_project, type: :project_payload do
      arg(:id, non_null(:id))

      resolve(&ValiotApp.ProjectResolver.delete/2)
      middleware &build_payload/2
    end

    @desc "Update issue"
    field :update_issue, type: :issue_payload do
      arg(:id, non_null(:integer))
      arg(:issue, :update_issue_params)

      resolve(&ValiotApp.IssueResolver.update/2)
      middleware &build_payload/2
    end

    @desc "Create issue"
    field :create_issue, type: :issue_payload do

      arg(:description, :string)
      arg(:name, :string)
      arg(:profile_id, :integer)
      arg(:project_id, :integer)


      resolve(&ValiotApp.IssueResolver.create/2)
      middleware &build_payload/2
    end

    @desc "Delete issue"
    field :delete_issue, type: :issue_payload do
      arg(:id, non_null(:id))

      resolve(&ValiotApp.IssueResolver.delete/2)
      middleware &build_payload/2
    end

    @desc "Update area"
    field :update_area, type: :area_payload do
      arg(:id, non_null(:integer))
      arg(:area, :update_area_params)

      resolve(&ValiotApp.AreaResolver.update/2)
      middleware &build_payload/2
    end

    @desc "Create area"
    field :create_area, type: :area_payload do

      arg(:name, :string)




      resolve(&ValiotApp.AreaResolver.create/2)
      middleware &build_payload/2
    end

    @desc "Delete area"
    field :delete_area, type: :area_payload do
      arg(:id, non_null(:id))

      resolve(&ValiotApp.AreaResolver.delete/2)
      middleware &build_payload/2
    end

    @desc "Update project_profile"
    field :update_project_profile, type: :project_profile_payload do
      arg(:id, non_null(:integer))
      arg(:project_profile, :update_project_profile_params)

      resolve(&ValiotApp.ProjectProfileResolver.update/2)
      middleware &build_payload/2
    end

    @desc "Create project_profile"
    field :create_project_profile, type: :project_profile_payload do
      arg(:profile_id, :integer)
      arg(:project_id, :integer)
      arg(:role_id, :integer)


      resolve(&ValiotApp.ProjectProfileResolver.create/2)
      middleware &build_payload/2
    end

    @desc "Delete project_profile"
    field :delete_project_profile, type: :project_profile_payload do
      arg(:id, non_null(:id))

      resolve(&ValiotApp.ProjectProfileResolver.delete/2)
      middleware &build_payload/2
    end

    @desc "Update area_issue"
    field :update_area_issue, type: :area_issue_payload do
      arg(:id, non_null(:integer))
      arg(:area_issue, :update_area_issue_params)

      resolve(&ValiotApp.AreaIssueResolver.update/2)
      middleware &build_payload/2
    end

    @desc "Create area_issue"
    field :create_area_issue, type: :area_issue_payload do
      arg(:area_id, :integer)
      arg(:issue_id, :integer)


      resolve(&ValiotApp.AreaIssueResolver.create/2)
      middleware &build_payload/2
    end

    @desc "Delete area_issue"
    field :delete_area_issue, type: :area_issue_payload do
      arg(:id, non_null(:id))

      resolve(&ValiotApp.AreaIssueResolver.delete/2)
      middleware &build_payload/2
    end

    @desc "Update permission"
    field :update_permission, type: :permission_payload do
      arg(:id, non_null(:integer))
      arg(:permission, :update_permission_params)

      resolve(&ValiotApp.PermissionResolver.update/2)
      middleware &build_payload/2
    end

    @desc "Create permission"
    field :create_permission, type: :permission_payload do
      arg(:create, :boolean)
      arg(:delete, :boolean)
      arg(:read, :boolean)
      arg(:relation, :relation)
arg(:token_id, :integer)
      arg(:update, :boolean)


      resolve(&ValiotApp.PermissionResolver.create/2)
      middleware &build_payload/2
    end

    @desc "Delete permission"
    field :delete_permission, type: :permission_payload do
      arg(:id, non_null(:id))

      resolve(&ValiotApp.PermissionResolver.delete/2)
      middleware &build_payload/2
    end
end

  subscription do

    field :profile_updated, :profile_payload do
      config(fn _args, _info ->
        {:ok, topic: "*"}
      end)
      resolve(&ValiotApp.SubscriptionResolver.subscribe/3)
      middleware &build_payload/2
    end

    field :profile_created, :profile_payload do
      config(fn _args, _info ->
        {:ok, topic: "*"}
      end)
      resolve(&ValiotApp.SubscriptionResolver.subscribe/3)
      middleware &build_payload/2
    end

    field :profile_deleted, :profile_payload do
      config(fn _args, _info ->
        {:ok, topic: "*"}
      end)
      resolve(&ValiotApp.SubscriptionResolver.subscribe/3)
      middleware &build_payload/2
    end

    field :role_updated, :role_payload do
      config(fn _args, _info ->
        {:ok, topic: "*"}
      end)
      resolve(&ValiotApp.SubscriptionResolver.subscribe/3)
      middleware &build_payload/2
    end

    field :role_created, :role_payload do
      config(fn _args, _info ->
        {:ok, topic: "*"}
      end)
      resolve(&ValiotApp.SubscriptionResolver.subscribe/3)
      middleware &build_payload/2
    end

    field :role_deleted, :role_payload do
      config(fn _args, _info ->
        {:ok, topic: "*"}
      end)
      resolve(&ValiotApp.SubscriptionResolver.subscribe/3)
      middleware &build_payload/2
    end

    field :project_updated, :project_payload do
      config(fn _args, _info ->
        {:ok, topic: "*"}
      end)
      resolve(&ValiotApp.SubscriptionResolver.subscribe/3)
      middleware &build_payload/2
    end

    field :project_created, :project_payload do
      config(fn _args, _info ->
        {:ok, topic: "*"}
      end)
      resolve(&ValiotApp.SubscriptionResolver.subscribe/3)
      middleware &build_payload/2
    end

    field :project_deleted, :project_payload do
      config(fn _args, _info ->
        {:ok, topic: "*"}
      end)
      resolve(&ValiotApp.SubscriptionResolver.subscribe/3)
      middleware &build_payload/2
    end

    field :issue_updated, :issue_payload do
      config(fn _args, _info ->
        {:ok, topic: "*"}
      end)
      resolve(&ValiotApp.SubscriptionResolver.subscribe/3)
      middleware &build_payload/2
    end

    field :issue_created, :issue_payload do
      config(fn _args, _info ->
        {:ok, topic: "*"}
      end)
      resolve(&ValiotApp.SubscriptionResolver.subscribe/3)
      middleware &build_payload/2
    end

    field :issue_deleted, :issue_payload do
      config(fn _args, _info ->
        {:ok, topic: "*"}
      end)
      resolve(&ValiotApp.SubscriptionResolver.subscribe/3)
      middleware &build_payload/2
    end

    field :area_updated, :area_payload do
      config(fn _args, _info ->
        {:ok, topic: "*"}
      end)
      resolve(&ValiotApp.SubscriptionResolver.subscribe/3)
      middleware &build_payload/2
    end

    field :area_created, :area_payload do
      config(fn _args, _info ->
        {:ok, topic: "*"}
      end)
      resolve(&ValiotApp.SubscriptionResolver.subscribe/3)
      middleware &build_payload/2
    end

    field :area_deleted, :area_payload do
      config(fn _args, _info ->
        {:ok, topic: "*"}
      end)
      resolve(&ValiotApp.SubscriptionResolver.subscribe/3)
      middleware &build_payload/2
    end

    field :project_profile_updated, :project_profile_payload do
      config(fn _args, _info ->
        {:ok, topic: "*"}
      end)
      resolve(&ValiotApp.SubscriptionResolver.subscribe/3)
      middleware &build_payload/2
    end

    field :project_profile_created, :project_profile_payload do
      config(fn _args, _info ->
        {:ok, topic: "*"}
      end)
      resolve(&ValiotApp.SubscriptionResolver.subscribe/3)
      middleware &build_payload/2
    end

    field :project_profile_deleted, :project_profile_payload do
      config(fn _args, _info ->
        {:ok, topic: "*"}
      end)
      resolve(&ValiotApp.SubscriptionResolver.subscribe/3)
      middleware &build_payload/2
    end

    field :area_issue_updated, :area_issue_payload do
      config(fn _args, _info ->
        {:ok, topic: "*"}
      end)
      resolve(&ValiotApp.SubscriptionResolver.subscribe/3)
      middleware &build_payload/2
    end

    field :area_issue_created, :area_issue_payload do
      config(fn _args, _info ->
        {:ok, topic: "*"}
      end)
      resolve(&ValiotApp.SubscriptionResolver.subscribe/3)
      middleware &build_payload/2
    end

    field :area_issue_deleted, :area_issue_payload do
      config(fn _args, _info ->
        {:ok, topic: "*"}
      end)
      resolve(&ValiotApp.SubscriptionResolver.subscribe/3)
      middleware &build_payload/2
    end

    field :permission_updated, :permission_payload do
      config(fn _args, _info ->
        {:ok, topic: "*"}
      end)
      resolve(&ValiotApp.SubscriptionResolver.subscribe/3)
      middleware &build_payload/2
    end

    field :permission_created, :permission_payload do
      config(fn _args, _info ->
        {:ok, topic: "*"}
      end)
      resolve(&ValiotApp.SubscriptionResolver.subscribe/3)
      middleware &build_payload/2
    end

    field :permission_deleted, :permission_payload do
      config(fn _args, _info ->
        {:ok, topic: "*"}
      end)
      resolve(&ValiotApp.SubscriptionResolver.subscribe/3)
      middleware &build_payload/2
    end

  end

end
