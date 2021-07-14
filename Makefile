#!make
include .env

postgres:
	docker run --name postgres12 -p 2345:5432 -e POSTGRES_USER=${POSTGRES_USER} -e POSTGRES_PASSWORD=${POSTGRES_PASSWORD} -d postgres:12-alpine

createdb:
	docker exec -it postgres12 createdb --username=${POSTGRES_USER} --owner=${POSTGRES_USER} ${POSTGRES_DB}

dropdb:
	docker exec -it postgres12 dropdb --username=${POSTGRES_USER} --owner=${POSTGRES_USER} ${POSTGRES_DB}

migrateup:
	migrate -path db/migrations -database "postgresql://${POSTGRES_USER}:${POSTGRES_PASSWORD}@localhost:2345/${POSTGRES_DB}?sslmode=disable" -verbose up 

migratedown:
	migrate -path db/migrations -database "postgresql://${POSTGRES_USER}:${POSTGRES_PASSWORD}@localhost:2345/${POSTGRES_DB}?sslmode=disable" -verbose down

sqlc:
	sqlc generate

.PHONY:	createdb dropdb postgres migratedown migrateup sqlc