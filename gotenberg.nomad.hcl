job "gotenberg" {
  datacenters = ["dc1"]
  type        = "service"

  group "pdf-converter" {
    count          = 1
    shutdown_delay = "5s"

    network {
      mode = "host"
      port "http" {
        static = 3000
      }
    }

    service {
      name     = "gotenberg"
      port     = "http"
      provider = "consul"

      check {
        name     = "gotenberg-health"
        type     = "http"
        path     = "/health"
        interval = "10s"
        timeout  = "5s"
      }
    }

    task "gotenberg" {
      driver = "docker"

      config {
        image = "gotenberg/gotenberg:9.6.0"
        ports = ["http"]
        shm_size = 512
        network_mode = "host"
      }

      resources {
        cpu    = 1000
        memory = 1024
      }
    }
  }
}
