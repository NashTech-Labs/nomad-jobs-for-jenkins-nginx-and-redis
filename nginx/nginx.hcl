job "nginx" {
    datacenters = ["dc1"]

    type = "service"

    group "frontend" {
        count = 1
    
        network {
            port "http" {
                static = "8081"
                to = "80"
            }
        }   

        task "frontend" {
            driver = "docker"

            config {
                image = "himanshuchaudhary/mywebapp:v2"
                ports = ["http"]
            }

            resources {
                cpu    = 500 # MHz
                memory = 128 # MB
            }        
        }
    }
}