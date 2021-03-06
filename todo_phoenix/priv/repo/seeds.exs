# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     TodoPhoenix.Repo.insert!(%TodoPhoenix.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias TodoPhoenix.Todos

for _ <- 1..10, do:
  Todos.create_todo(%{title: "test", description: "test"})
