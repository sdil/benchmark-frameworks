start-phoenix:
	cd todo_phoenix && docker-compose build && docker-compose down && docker-compose up -d && sleep 5 && docker-compose exec web mix ecto.create && docker-compose exec web mix ecto.migrate

start-django:
	cd todo_django && docker-compose build && docker-compose down && docker-compose up -d && sleep 5 && docker-compose exec web python manage.py migrate &&  docker-compose exec web python manage.py runserver

stop:
	cd todo_django && docker-compose down
	cd todo_phoenix && docker-compose down

seed-phoenix:
	cd todo_phoenix && docker-compose exec web mix run priv/repo/seeds.exs

seed-django:
	# This doesnt work. Need to manually get into the container and run this command
	cd todo_django && docker-compose exec web python3 manage.py shell < seeds.py

run-benchmark:
	ab -n 1000 -c 100 localhost:8000/api/todos/

run-curl:
	curl -i localhost:8000/api/todos/
