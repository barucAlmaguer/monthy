defmodule ValiotAppWeb.Schema do
  use Absinthe.Schema
  import Kronky.Payload
  import_types(ValiotAppWeb.Schema.Types)
  import_types(Absinthe.Type.Custom)
  import_types(Kronky.ValidationMessageTypes)

  query do
  end
end
