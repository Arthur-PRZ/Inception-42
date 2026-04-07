*This project has been created as part of the 42 curriculum by artperez.*

# Inception

## Description

Inception is a project from the 42 curriculum. The goal is to set up a small infrastructure composed of different services running inside Docker containers, all orchestrated with Docker Compose.

The infrastructure includes:
- A WordPress website with PHP-FPM
- An Nginx web server as a reverse proxy (with TLS)
- A MariaDB database to store WordPress data

Each service runs in its own dedicated container, built from a custom Dockerfile based on the penultimate stable version of Debian or Alpine.

### Use of Docker

Instead of running services directly on a host machine, this project uses Docker to isolate each service in its own container. Each container is built from a custom Dockerfile and configured via environment variables. Docker Compose orchestrates all containers, networks, and volumes from a single `docker-compose.yml` file.

### Design Choices

**Virtual Machines vs Docker**
Virtual Machines emulate an entire operating system with its own kernel, which is heavy and slow to start. Docker containers share the host kernel and only isolate the application layer, making them much lighter, faster to start, and easier to replicate. For this project, Docker is the right choice since we just need isolated, reproducible services — not full OS emulation.

**Secrets vs Environment Variables**
Environment variables are simple key-value pairs passed to containers at runtime. They are convenient but can be exposed in logs or inspected with `docker inspect`. Docker Secrets store sensitive data (passwords, tokens) securely and only make them available to authorized services as files. In this project we use environment variables via a `.env` file for simplicity, but in a production environment secrets would be the safer choice for passwords.

**Docker Network vs Host Network**
With Host Network, the container shares the host's network directly (no isolation). With Docker Network, each container gets its own virtual network interface and can only communicate with other containers on the same network. This project uses a custom Docker bridge network so that Nginx, WordPress, and MariaDB can communicate with each other internally while remaining isolated from the outside.

**Docker Volumes vs Bind Mounts**
Bind Mounts link a specific folder from the host machine directly into the container. Docker Volumes are managed by Docker and stored in a dedicated location on the host. This project uses Docker Volumes for the MariaDB data and WordPress files to ensure data persists across container restarts, while keeping the data management under Docker's control.

## Instructions

### Installation & Execution

1. Clone the repository:
```bash
git clone <repository_url>
cd inception
```

2. Configure environment variables by editing the `.env` file at the root of the `srcs/` directory with your own values:
```
DOMAIN_NAME=artperez.42.fr
MYSQL_DATABASE=wordpress
MYSQL_USER=wpuser
MYSQL_PASSWORD=yourpassword
WP_TITLE=My WordPress Site
WP_ADMIN_USER=admin
WP_ADMIN_PASSWORD=adminpassword
WP_ADMIN_EMAIL=admin@example.com
```

3. Build and start the containers:
```bash
make
```

4. Access the WordPress site at:
```
https://artperez.42.fr
```

### Useful Commands

```bash
make        # Build and start all containers
make clean  # Stop and remove containers and volumes
make fclean # Stop and remove all containers, volumes and images
make re     # Full rebuild
```

## Resources

### References & Tutorials

- [Inception 42 Tips](https://tuto.grademe.fr/inception/) — A comprehensive guide with tips and explanations specifically made for the 42 Inception project. Very helpful for understanding the overall architecture and solving common issues.

### Use of AI

Claude (claude.ai) was used throughout this project for:
- **Explanations** — Understanding Docker concepts and the configuration of the different services (Nginx, PHP-FPM, MariaDB, WordPress).
- **Debugging** — Solving configuration issues in scripts and Dockerfiles.

AI was used as a learning and support tool, not to generate the project code directly.
