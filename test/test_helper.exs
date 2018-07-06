ExUnit.start()
Mix.Tasks.Valiot.Gen.Api.run(["#{File.cwd!()}/schema.graphql"])
IEx.Helpers.recompile()
System.cmd("mix", ["ecto.migrate"], env: [{"MIX_ENV", "test"}])
:ok
Ecto.Adapters.SQL.Sandbox.mode(ValiotApp.Repo, :manual)
