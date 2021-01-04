start_db:
	docker run -it --rm --name postgres -e POSTGRES_PASSWORD=postgres -e POSTGRES_DB=todo_django -p 5432:5432 postgres
