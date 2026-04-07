# Developer Documentation

## Prerequisites

Make sure the following tools are installed on your machine before starting:

- **Docker** — Container engine
- **Docker Compose** — Multi-container orchestration

On Debian/Ubuntu:
```bash
sudo apt update
sudo apt install docker.io docker-compose
```

Add your user to the docker group to run Docker without sudo:
```bash
sudo usermod -aG docker $USER
```
Then restart your session.

---

## Project structure

```
inception/
├── Makefile
└── srcs/
    ├── .env
    ├── docker-compose.yml
    └── requirements/
        ├── nginx/
        │   ├── Dockerfile
        │   └── conf/
        ├── wordpress/
        │   ├── Dockerfile
        │   └── conf/
        └── mariadb/
            ├── Dockerfile
            └── conf/
```

---

## Environment configuration

All credentials and settings are stored in `srcs/.env`. Create it from scratch with the following variables:

```bash
# Domain
DOMAIN_NAME=your_login.42.fr

# MariaDB
MYSQL_DATABASE=wordpress
MYSQL_USER=wpuser
MYSQL_PASSWORD=yourpassword
MYSQL_ROOT_PASSWORD=yourrootpassword

# WordPress
WP_TITLE=My WordPress Site
WP_ADMIN_USER=admin
WP_ADMIN_PASSWORD=adminpassword
WP_ADMIN_EMAIL=admin@example.com
WP_USER=author
WP_USER_PASSWORD=authorpassword
WP_USER_EMAIL=author@example.com
```

> Never commit the `.env` file to your repository. Make sure it is listed in your `.gitignore`.

---

## Service configuration

Each service has its own `Dockerfile` and a `conf/` folder containing its configuration file.

**Nginx** requires a `.conf` file that defines the server block: the port to listen on (443 for HTTPS), the TLS certificate and key paths, and the FastCGI pass to forward PHP requests to WordPress on port 9000.

**WordPress** requires a `www.conf` file for PHP-FPM that defines how PHP processes requests, in particular `listen = 0.0.0.0:9000` to accept connections from Nginx. It also uses an entrypoint script that automatically installs WordPress and creates the users on first startup using WP-CLI and the variables from the `.env` file.

**MariaDB** requires a `50-server.cnf` file to configure the database server (bind address, socket path). It also uses an initialization script that creates the database, the WordPress user, sets the root password and shuts down cleanly before the final server start.

---

## Docker Compose

The `srcs/docker-compose.yml` file is the central piece of the project. It describes all the services, how they are built, how they communicate, and where their data is stored.

For each service it defines:
- **build** — the path to the `Dockerfile` to build the image from
- **container_name** — the name used to reference the container
- **env_file** — the `.env` file to inject variables from
- **networks** — the Docker network the container joins so services can talk to each other
- **volumes** — the Docker volumes mounted into the container for data persistence
- **depends_on** — the service that must start before this one (e.g. WordPress waits for MariaDB)

All services share the same custom bridge network so they can reach each other by container name (e.g. WordPress connects to MariaDB using the hostname `mariadb`).

### Dockerfiles

For each service, Docker Compose uses the `Dockerfile` located in the service folder to build the image. A Dockerfile describes how to build the container image step by step: it starts from a base OS image, installs the required packages, copies the configuration files, and defines the command to run when the container starts.

**Nginx Dockerfile** — starts from Debian/Alpine, installs Nginx, copies the `.conf` file and the TLS certificate, then starts Nginx in the foreground.

**WordPress Dockerfile** — starts from Debian/Alpine, installs PHP-FPM and WP-CLI, copies the `www.conf` and the entrypoint script, then runs the entrypoint which installs WordPress automatically on first start.

**MariaDB Dockerfile** — starts from Debian/Alpine, installs MariaDB, copies the server config and the initialization script, then runs the script to set up the database before starting the MariaDB server.

To use Docker Compose directly without Make:
```bash
docker compose -f srcs/docker-compose.yml up -d --build   # start
docker compose -f srcs/docker-compose.yml down -v         # stop and remove volumes
docker compose -f srcs/docker-compose.yml ps              # list containers
docker compose -f srcs/docker-compose.yml logs <service>  # view logs
```

---

## Build and launch the project

**Build images and start all containers:**
```bash
make
# runs: mkdir -p /home/your_login/data/mariadb && mkdir -p /home/your_login/data/wordpress
#       docker compose -f srcs/docker-compose.yml up -d --build
```

**Stop containers and remove volumes:**
```bash
make clean
# runs: docker compose -f srcs/docker-compose.yml down -v
```

**Stop containers and remove everything (images, volumes, data folders included):**
```bash
make fclean
# runs: docker compose -f srcs/docker-compose.yml down -v
#       docker system prune -af
#       sudo rm -rf /home/your_login/data/mariadb/*
#       sudo rm -rf /home/your_login/data/wordpress/*
```

**Full rebuild from scratch:**
```bash
make re
# runs: fclean then all
```

---

## Manage containers

**List running containers:**
```bash
make status
# runs: docker compose -f srcs/docker-compose.yml ps
```

**View logs per service:**
```bash
make logs_nginx
make logs_wordpress
make logs_mariadb
# runs: docker compose -f srcs/docker-compose.yml logs <service>
```

**Enter a container:**
```bash
docker exec -it nginx bash
docker exec -it wordpress bash
docker exec -it mariadb bash
```

**Rebuild a single service:**
```bash
docker compose -f srcs/docker-compose.yml up -d --build nginx
docker compose -f srcs/docker-compose.yml up -d --build wordpress
docker compose -f srcs/docker-compose.yml up -d --build mariadb
```

---

## Manage containers

Project data is stored in Docker Volumes, managed automatically by Docker. Unlike regular container storage which is lost when a container is removed, volumes exist independently from containers. This means that even if you stop or rebuild a container, all the data written inside the volume (articles, images, database records) is still there when the container starts again.

Each volume is linked to a specific folder inside the container. Any file written by the container in that folder is automatically saved in the volume on the host machine in real time.

| Volume | Mount point in container | Content |
|--------|--------------------------|---------|
| `wordpress_data` | `/var/www/html` | WordPress files, themes, uploads |
| `mariadb_data` | `/var/lib/mysql` | Database files |

Volumes are stored on the host machine at:
```
/home/your_login/data/
```

Data persists across container restarts as long as volumes are not deleted. Running `make fclean` will delete the volumes and all data will be lost.

**Inspect a volume:**
```bash
docker volume inspect srcs_wordpress_data
docker volume inspect srcs_mariadb_data
```

**List all volumes:**
```bash
docker volume ls
```

---

## Connect to the database

Connecting to MariaDB is useful during development to verify that the database and users were correctly created, to inspect the WordPress tables and their content, or to debug issues related to data (missing users, wrong credentials, corrupted tables).

Enter the MariaDB container and connect as root:
```bash
docker exec -it mariadb mysql -u root
```

Useful SQL commands:
```sql
SHOW DATABASES;        -- list all databases
USE wordpress;         -- select the wordpress database
SHOW TABLES;           -- list all tables
SELECT * FROM wp_users; -- show all WordPress users
```
