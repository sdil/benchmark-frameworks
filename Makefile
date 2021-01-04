start_db:
	docker run -it --rm --name postgres -e POSTGRES_PASSWORD=postgres -e POSTGRES_DB=todo_django -p 5432:5432 postgres

start_phoenix:
	cd todo_phoenix && mix ecto.create && mix ecto.migrate && mix phx.server

start_django:
	cd todo_django && python3 manage.py migrate && python3 manage.py runserver

seed_phoenix:
	cd todo_phoenix && mix run priv/repo/seeds.exs

seed_django:
	cd todo_django && python3 manage.py shell < seeds.py
