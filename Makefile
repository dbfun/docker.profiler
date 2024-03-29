#################################
# Application workflow
#################################

# Run all containers
.PHONY: up
up:
	@docker-compose up -d --build

# Stop all containers
down:
	@docker-compose down

# Reload all services
.PHONY: reload
reload: nginx-reload apache-reload

# Apache reload
.PHONY: apache-reload
apache-reload:
	@docker-compose exec apache service apache2 reload

# Nginx reload
.PHONY: nginx-reload
nginx-reload:
	@docker-compose exec nginx sh -c 'nginx -s reload'

#################################
# Reconfigure
#################################

.PHONY: reconfigure-bitrix
reconfigure-bitrix:
	@docker-compose exec apache php /srv/bitrix-reconfigure.php
	@docker-compose exec mysql bash /srv/bitrix-reconfigure.sh

#################################
# Test and debug
#################################

# Runs tool container
.PHONY: tools
tools:
	@docker-compose run tools bash

# Runs mysql
.PHONY: mysql
mysql:
	@docker-compose exec mysql mysql

.PHONY: mysql-cache-enable
mysql-cache-enable:
	@docker-compose exec mysql mysql -e 'SET GLOBAL query_cache_size = 134217728; SET GLOBAL query_cache_type = "ON"'

.PHONY: mysql-cache-disable
mysql-cache-disable:
	@docker-compose exec mysql mysql -e 'SET GLOBAL query_cache_size = 0; SET GLOBAL query_cache_type = "OFF"'

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

# Clean
.PHONY: clean
clean:
	@docker-compose down
	sudo rm -rf mysql/var/*
