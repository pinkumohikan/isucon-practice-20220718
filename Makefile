.PHONY: *

gogo: stop-services build truncate-logs start-services

build:
	cd go && make all

stop-services:
	sudo systemctl stop nginx
	sudo systemctl stop isuumo.go.service
	sudo systemctl stop mysql

start-services:
	sudo systemctl start mysql
	sleep 5
	sudo systemctl start isuumo.go.service
	sudo systemctl start nginx

truncate-logs:
	sudo truncate --size 0 /var/log/nginx/access.log
	sudo truncate --size 0 /var/log/nginx/error.log
	sudo truncate --size 0 /var/log/mysql/mysql-slow.log
	sudo chmod 777 /var/log/mysql/mysql-slow.log
	sudo journalctl --vacuum-size=1K

bench:
	cd bench && ./bench -target-url http://52.194.190.164