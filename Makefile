setup-pg-container:
	SHELL=bash
	docker run --name go-migrate-test-pg -e POSTGRES_PASSWORD=password123 -p 5432:5432 -d postgres:14.5
	docker exec go-migrate-test-pg   mkdir -p /var/lib/postgresql/tablespaces/pgdata/example_data
	docker exec go-migrate-test-pg   mkdir -p /var/lib/postgresql/tablespaces/pgdata/example_index
	docker exec go-migrate-test-pg   chown postgres -R /var/lib/postgresql/tablespaces

	echo "waiting for when db is up..."
	while ! lsof -i -P -n | grep LISTEN | grep 5432 1> /dev/null; do sleep 1; echo "."; done;
	echo "running database init script"
	psql "postgresql://postgres:password123@localhost:5432/postgres" -a -f init.sql -v ON_ERROR_STOP=1

clean-up-pg-container:
	docker stop go-migrate-test-pg
	echo "waiting for existing container to be destroyed..."
	while lsof -i -P -n | grep LISTEN | grep 5432 1> /dev/null; do sleep 1; echo "."; done;
	docker rm go-migrate-test-pg


reset-example-pg-database: clean-up-pg-container setup-pg-container


.PHONY: setup-pg-container clean-up-pg-container reset-example-pg-database
