# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     PanelDemon.Repo.insert!(%PanelDemon.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

#PanelDemon.Repo.insert!(%PanelDemon.Process{name: "AT&T", is_active: false, mps: 0, num_workers: 0, i_queue: "Q.Prod.Input", r_queue: "Q.Prod.Retry"})
#PanelDemon.Repo.insert!(%PanelDemon.Process{name: "Verizon", is_active: false, mps: 0, num_workers: 0, i_queue: "Q.Prod.Input", r_queue: "Q.Prod.Retry"})

#PanelDemon.Repo.insert!(%PanelDemon.Tag{name: "Offer"})
#PanelDemon.Repo.insert!(%PanelDemon.Tag{name: "Proposal"})

PanelDemon.Repo.insert!(%PanelDemon.Message{status: true})
PanelDemon.Repo.insert!(%PanelDemon.Message{status: true})
PanelDemon.Repo.insert!(%PanelDemon.Message{status: false})
PanelDemon.Repo.insert!(%PanelDemon.Message{status: false})


