ExUnit.start

Mix.Task.run "ecto.create", ~w(-r PanelDemon.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r PanelDemon.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(PanelDemon.Repo)

