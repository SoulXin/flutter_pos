setup:
	docker volume create --name=backend-mysql-data
	cd container && docker-compose -p backend-container up -d

build:
	cd container && docker-compose build

down:
	cd container && docker-compose -p backend-container down

remove-data:
	docker volume rm backend-mysql-data

create-db:
	docker exec -i mariadb sh -c 'exec mysql -uroot -proot' < container/mysql/database.sql

init:
	docker exec -ti backend make _init

_init:
	composer install
	php artisan migrate
	php artisan db:seed

