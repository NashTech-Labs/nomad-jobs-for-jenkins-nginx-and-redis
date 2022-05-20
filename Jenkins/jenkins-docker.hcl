job "jenkins-master" {

  datacenters = ["dc1"]
  type        = "service"
  priority    = 50

  update {
    stagger      = "10s"
    max_parallel = 1
  }

  group "jenkins-master" {
    count = 1

    network {
        mode = "bridge"

        port "http" {
        static = 8080
        to     = 8080
        }

        port "jnlp" {
        static = 50000
        to     = 50000
        }
    }

    service {
        name = "jenkins-master"
        port = "8080"
        connect {
            sidecar_service {}
        }        
    }

    restart {
      attempts = 10
      interval = "5m"
      delay    = "25s"
      mode     = "delay"
    }

    task "jenkins-master" {
      driver = "docker"

      config {
        image = "jenkins/jenkins:latest-jdk11"
        ports = ["http","jnlp"]
      }

      service {
        name = "jenkins-master"
        tags = ["global", "jenkins", "master"]
        port = "http"

        check {
          name     = "alive"
          type     = "tcp"
          interval = "10s"
          timeout  = "2s"
        }
      }

      resources {
        cpu    = 2000
        memory = 2048
      }

      logs {
        max_files     = 10
        max_file_size = 15
      }
    }
  }
}