bootstrap: clean images deps db_migrate

clean:
	docker-compose rm -fv

images:
	docker-compose pull
	docker-compose build

db_create:
	docker-compose run --rm api ecto.create

db_migrate:
	docker-compose run --rm api ecto.migrate

db_prepare: db_create db_migrate

db_drop:
	docker-compose run --rm api ecto.drop

ui_deps:
	docker-compose run --rm --entrypoint npm ui install

api_deps:
	docker-compose run --rm api deps.get

deps: ui_deps api_deps

up:
	docker-compose rm -f consul-server
	docker-compose up

build: vm_up
	docker-compose build
