.PHONY: *

gogo: stop-services build truncate-logs start-services bench

build:
	cd webapp/go && make all

stop-services:
	sudo systemctl stop nginx
	sudo systemctl stop isuumo.go.service
	ssh isucon-app2 "sudo systemctl stop mysql"

start-services:
	ssh isucon-app2 "sudo systemctl start mysql"
	sleep 5
	sudo systemctl start isuumo.go.service
	sudo systemctl start nginx

truncate-logs:
	sudo truncate --size 0 /var/log/nginx/access.log
	sudo truncate --size 0 /var/log/nginx/error.log
	ssh isucon-app2 "sudo truncate --size 0 /var/log/mysql/mysql-slow.log"
	ssh isucon-app2 "sudo chmod 777 /var/log/mysql/mysql-slow.log"
	sudo journalctl --vacuum-size=1K

bench:
	cd bench && ./bench -target-url http://52.194.190.164

kataribe:
	sudo cat /var/log/nginx/access.log | ./kataribe -conf kataribe.toml
save-log: TS=$(shell date "+%Y%m%d_%H%M%S")
save-log: 
	mkdir /home/isucon/logs/$(TS)
	sudo  cp -p /var/log/nginx/access.log  /home/isucon/logs/$(TS)/access.log
	ssh isucon-app2 "sudo  cp -p /var/log/mysql/mysql-slow.log  /home/isucon/mysql-slow.log && sudo chmod 777 /home/isucon/mysql-slow.log "
	scp isucon-app2:/home/isucon/mysql-slow.log /home/isucon/logs/$(TS)/mysql-slow.log
	sudo chmod -R 777 /home/isucon/logs/*
sync-log:
	scp -C kataribe.toml isucon-tool:~/
	rsync -av -e ssh /home/isucon/logs isucon-tool:/home/ubuntu  
analysis-log:
	ssh isucon-tool "sh push_github.sh"
pt-log:
	ssh isucon-tool "sh start_pt.sh"
gogo-log: save-log sync-log analysis-log
gogo-pt:  save-log sync-log pt-log
