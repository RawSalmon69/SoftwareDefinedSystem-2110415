terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.2"
    }
  }
}

provider "docker" {}

# Create a custom network for container communication
resource "docker_network" "todo_network" {
  name = "todo-network"
}

# Redis container for caching
resource "docker_image" "redis" {
  name         = "redis:7-alpine"
  keep_locally = false
}

resource "docker_container" "redis" {
  image = docker_image.redis.image_id
  name  = "redis"
  
  restart = "unless-stopped"
  
  ports {
    internal = 6379
    external = 6379
  }
  
  networks_advanced {
    name = docker_network.todo_network.name
  }
}

# Build and run the todo backend service (version 3.0)
resource "docker_image" "todo_backend" {
  name = "todo-backend:3.0"
  build {
    context = "./todo-release-3"
    tag     = ["todo-backend:3.0"]
  }
  keep_locally = true
}

resource "docker_container" "todo_backend" {
  image = docker_image.todo_backend.image_id
  name  = "todo"
  
  restart = "unless-stopped"
  
  ports {
    internal = 8000
    external = 8000
  }
  
  env = [
    "REDIS_HOST=redis",
    "REDIS_PORT=6379"
  ]
  
  networks_advanced {
    name = docker_network.todo_network.name
  }
  
  depends_on = [
    docker_container.redis
  ]
}

# Build and run the notification service (version 1.1)
resource "docker_image" "notification" {
  name = "todo-notification:1.1"
  build {
    context = "./todo-notification-release1.1"
    tag     = ["todo-notification:1.1"]
  }
  keep_locally = true
}

resource "docker_container" "notification" {
  image = docker_image.notification.image_id
  name  = "notification"
  
  restart = "unless-stopped"
  
  ports {
    internal = 8080
    external = 8080
  }
  
  env = [
    "REDIS_HOST=redis",
    "REDIS_PORT=6379"
  ]
  
  networks_advanced {
    name = docker_network.todo_network.name
  }
  
  depends_on = [
    docker_container.redis
  ]
}

# Build and run the todo webapp frontend (version 3.0)
resource "docker_image" "todo_webapp" {
  name = "todo-webapp:3.0"
  build {
    context = "./todo-webapp-release-3"
    tag     = ["todo-webapp:3.0"]
  }
  keep_locally = true
}

resource "docker_container" "todo_webapp" {
  image = docker_image.todo_webapp.image_id
  name  = "todo-webapp"
  
  restart = "unless-stopped"
  
  ports {
    internal = 3000
    external = 3000
  }
  
  env = [
    "TODO_ENDPOINT=http://todo:8000/",
    "NOTIFICATION_ENDPOINT=http://notification:8080/"
  ]
  
  networks_advanced {
    name = docker_network.todo_network.name
  }
  
  depends_on = [
    docker_container.todo_backend,
    docker_container.notification
  ]
}

# Outputs
output "application_urls" {
  value = {
    webapp       = "http://localhost:3000"
    api          = "http://localhost:8000"
    notification = "http://localhost:8080"
    redis        = "localhost:6379"
  }
  description = "URLs to access the application components"
}

output "container_info" {
  value = {
    todo_webapp = {
      id   = docker_container.todo_webapp.id
      name = docker_container.todo_webapp.name
    }
    todo_backend = {
      id   = docker_container.todo_backend.id
      name = docker_container.todo_backend.name
    }
    notification = {
      id   = docker_container.notification.id
      name = docker_container.notification.name
    }
    redis = {
      id   = docker_container.redis.id
      name = docker_container.redis.name
    }
  }
  description = "Container information"
}