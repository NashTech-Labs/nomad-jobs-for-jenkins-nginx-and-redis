job "jenkins" {
  type = "service"
    datacenters = ["dc1"]
    update {
      stagger      = "30s"
        max_parallel = 1
    }

# java version should be installed on your client

  constraint {
    attribute = "${driver.java.version}"
    operator  = ">"
    value     = "1.7.0"
  }
  group "web" {
    count = 1
      # Size of the ephemeral storage for Jenkins. Consider that depending
      # on job count and size it could require larger storage.
      ephemeral_disk {
       migrate = true
       size    = "500"
       sticky  = true
       
     }
    network {
      port "http" {
          static = 8080
          to     = 8080
      }
      port "slave" {
        static = 5050
      }
    }
    task "frontend" {
      env {
        # Use ephemeral storage for Jenkins data.
        JENKINS_HOME = "/alloc/data"
        JENKINS_SLAVE_AGENT_PORT = 5050
      }
      driver = "java"
      config {
        jar_path    = "local/jenkins.war"
        jvm_options = ["-Xmx768m", "-Xms384m"]
        args        = ["--httpPort=8080"]
      }
      artifact {
        source = "https://updates.jenkins.io/download/war/2.348/jenkins.war"

        options {
          # Checksum will change depending on the Jenkins Version.
          checksum = "sha256:5b2622ca85894010a76b6136e68d0ce85d5249e11f24571f03cf5f7cd7e7c569"
        }
      }
      service {
        # This tells Consul to monitor the service on the port
        # labeled "http". If you don't want to health check and don't have consul installed, then you can comment this service section.
        port = "http"
        name = "jenkins"

        check {
          type     = "http"
          path     = "/login"
          interval = "10s"
          timeout  = "2s"
        }
    }

      resources {
          cpu    = 1000 
          memory = 2048
        }
      }
    }
}
