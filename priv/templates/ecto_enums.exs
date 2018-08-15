import EctoEnum
<%= for {k, v} <- enums do %>defenum(<%= inspect Module.concat([Atom.to_string(k)]) %>Enum, <%= inspect k |> Atom.to_string |> Inflex.underscore |> String.downcase |> String.to_atom %>, <%= inspect Enum.map(v, fn el -> el |> String.downcase() |> String.to_atom end) %>)
<% end %>
