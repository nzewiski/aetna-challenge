resource "kubernetes_deployment" "nginx_deployment" {
  depends_on = [module.eks-cluster]
  metadata {
    name = "nginx"
    labels = {
      app = "nginx"
    }
  }
  spec {
    replicas = 3
    selector {
      match_labels = {
        app = "nginx"
      }
    }
    template {
      metadata {
        labels = {
          app = "nginx"
        }
      }
      spec {
        container {
          image = "nginx:1.7.8"
          name  = "nginx"
          resources {
            limits {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
          liveness_probe {
            http_get {
              path = "/nginx_status"
              port = 80
            }
            initial_delay_seconds = 3
            period_seconds        = 3
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "nginx_service" {
  depends_on = [module.eks-cluster]
  metadata {
    name = "nginx-service"
    labels = {
      app = "nginx"
    }
  }
  spec {
    type = "NodePort"
    selector = {
      app = kubernetes_deployment.nginx_deployment.metadata[0].labels.app
    }
    port {
      protocol    = "TCP"
      port        = 8080
      target_port = kubernetes_deployment.nginx_deployment.spec[0].template[0].spec[0].container[0].liveness_probe[0].http_get[0].port
    }
  }
}
