defmodule ValiotApp.FilterVal do
  def validate(filter) when is_integer(filter) do
    filter.to_string()
  end

  def validate(filter) when is_float(filter) do
    filter.to_string()
  end

  def validate(filter) when is_binary(filter) do
    filter
  end
end
