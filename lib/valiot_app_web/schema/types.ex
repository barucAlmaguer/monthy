defmodule ValiotAppWeb.Schema.Types do
  use Absinthe.Schema.Notation
  use Absinthe.Ecto, repo: ValiotApp.Repo

  scalar :text do
    description("Text field")
    parse(fn %Absinthe.Blueprint.Input.String{value: value} -> {:ok, value} end)
    serialize(fn str -> str end)
  end

  # Enums
  
  enum :relation do
    value(:profile)
    value(:role)
    value(:project)
    value(:issue)
    value(:area)
    value(:project_profile)
    value(:area_issue)
    value(:permission)
  end
  

    
    enum :profile_attributes do
      value(:id)
      value(:inserted_at)
      value(:updated_at)
      
       value(:description)
         value(:main)
         value(:name)
         value(:picture)
        
      
    end
    
    enum :role_attributes do
      value(:id)
      value(:inserted_at)
      value(:updated_at)
       value(:name)
        
    end
    
    enum :project_attributes do
      value(:id)
      value(:inserted_at)
      value(:updated_at)
      
       value(:description)
        
       value(:name)
         value(:tag)
        
    end
    
    enum :issue_attributes do
      value(:id)
      value(:inserted_at)
      value(:updated_at)
      
       value(:description)
         value(:name)
        
        
        
    end
    
    enum :area_attributes do
      value(:id)
      value(:inserted_at)
      value(:updated_at)
      
       value(:name)
        
      
      
    end
    
    enum :project_profile_attributes do
      value(:id)
      value(:inserted_at)
      value(:updated_at)
      
        
        
        
    end
    
    enum :area_issue_attributes do
      value(:id)
      value(:inserted_at)
      value(:updated_at)
      
        
        
    end
    
    enum :permission_attributes do
      value(:id)
      value(:inserted_at)
      value(:updated_at)
       value(:create)
         value(:delete)
         value(:read)
         value(:relation)
         value(:token_id)
         value(:update)
        
    end
    
  # Objects

  
  object :profile do
    field(:id, :id)
    field(:inserted_at, :naive_datetime)
    field(:updated_at, :naive_datetime)
    field(:areas, list_of(:area))do
      arg(:filter, :filters_area)
      arg(:limit, :integer)
      arg(:offset, :integer)
      arg(:order_by, :order_area)
      resolve(&ValiotApp.AreaResolver.all/3)
    end
    field(:description, :string)
    field(:main, :string)
    field(:name, :string)
    field(:picture, :string)
    field(:projects, list_of(:project))do
      arg(:filter, :filters_project)
      arg(:limit, :integer)
      arg(:offset, :integer)
      arg(:order_by, :order_project)
      resolve(&ValiotApp.ProjectResolver.all/3)
    end
    end

  object :role do
    field(:id, :id)
    field(:inserted_at, :naive_datetime)
    field(:updated_at, :naive_datetime)
    field(:name, :string)
    end

  object :project do
    field(:id, :id)
    field(:inserted_at, :naive_datetime)
    field(:updated_at, :naive_datetime)
    field(:areas, list_of(:area))do
      arg(:filter, :filters_area)
      arg(:limit, :integer)
      arg(:offset, :integer)
      arg(:order_by, :order_area)
      resolve(&ValiotApp.AreaResolver.all/3)
    end
    field(:description, :string)
    field(:issues, list_of(:issue))do
      arg(:filter, :filters_issue)
      arg(:limit, :integer)
      arg(:offset, :integer)
      arg(:order_by, :order_issue)
      resolve(&ValiotApp.IssueResolver.all/3)
    end
    field(:name, :string)
    field(:tag, :string)
    end

  object :issue do
    field(:id, :id)
    field(:inserted_at, :naive_datetime)
    field(:updated_at, :naive_datetime)
    field(:areas, list_of(:area))do
      arg(:filter, :filters_area)
      arg(:limit, :integer)
      arg(:offset, :integer)
      arg(:order_by, :order_area)
      resolve(&ValiotApp.AreaResolver.all/3)
    end
    field(:description, :string)
    field(:name, :string)
    field(:profile_id, :id)
    field(:profile, :profile, resolve: assoc(:profile))
    field(:project_id, :id)
    field(:project, :project, resolve: assoc(:project))
    end

  object :area do
    field(:id, :id)
    field(:inserted_at, :naive_datetime)
    field(:updated_at, :naive_datetime)
    field(:issue, list_of(:issue))do
      arg(:filter, :filters_issue)
      arg(:limit, :integer)
      arg(:offset, :integer)
      arg(:order_by, :order_issue)
      resolve(&ValiotApp.IssueResolver.all/3)
    end
    field(:name, :string)
    field(:profiles, list_of(:profile))do
      arg(:filter, :filters_profile)
      arg(:limit, :integer)
      arg(:offset, :integer)
      arg(:order_by, :order_profile)
      resolve(&ValiotApp.ProfileResolver.all/3)
    end
    field(:projects, list_of(:project))do
      arg(:filter, :filters_project)
      arg(:limit, :integer)
      arg(:offset, :integer)
      arg(:order_by, :order_project)
      resolve(&ValiotApp.ProjectResolver.all/3)
    end
    end

  object :project_profile do
    field(:id, :id)
    field(:inserted_at, :naive_datetime)
    field(:updated_at, :naive_datetime)
    field(:profile_id, :id)
    field(:profile, :profile, resolve: assoc(:profile))
    field(:project_id, :id)
    field(:project, :project, resolve: assoc(:project))
    field(:role_id, :id)
    field(:role, :role, resolve: assoc(:role))
    end

  object :area_issue do
    field(:id, :id)
    field(:inserted_at, :naive_datetime)
    field(:updated_at, :naive_datetime)
    field(:area_id, :id)
    field(:area, :area, resolve: assoc(:area))
    field(:issue_id, :id)
    field(:issue, :issue, resolve: assoc(:issue))
    end

  object :permission do
    field(:id, :id)
    field(:inserted_at, :naive_datetime)
    field(:updated_at, :naive_datetime)
    field(:create, :boolean)
    field(:delete, :boolean)
    field(:read, :boolean)
    field(:relation, :relation)
field(:token_id, :integer)
    field(:update, :boolean)
    end

end
