#
# Containers
#

# Run all containers
.PHONY: up
up:
	@docker-compose up -d --build

# Stop all containers
down:
	@docker-compose down

#
# Tools
#

# Runs tool container
.PHONY: tools
tools:
	@docker-compose run tools bash

#
# MySQL
#

# show processlist
.PHONY: mysql-process-list
mysql-process-list:
	@docker-compose exec mysql sh -c 'mysql -u$${MYSQL_USER} -p$${MYSQL_PASSWORD} -e "show processlist;"'

# dump database
.PHONY: mysqldump
mysqldump:
	@docker-compose exec mysql sh -c 'mysqldump $${MYSQL_DATABASE} --routines --triggers -u$${MYSQL_USER} -p$${MYSQL_PASSWORD}' > _logs/dump.sql

#
# Apache
#

# reload
.PHONY: apache-reload
apache-reload:
	@docker-compose exec apache service apache2 reload

# apache error log
.PHONY: apache-error
apache-error:
	@docker-compose exec apache tail /var/log/apache2/error.log

# apache access log
.PHONY: apache-access
apache-access:
	@docker-compose exec apache tail /var/log/apache2/access.log

# apache time log
.PHONY: apache-time
apache-time:
	@docker-compose exec apache tail -f /var/log/apache2/time.log



.PHONY: clean
clean:
	@docker-compose down
	sudo rm -rf mysql/var/*
