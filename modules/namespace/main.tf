resource "kubernetes_namespace" "namespace" {
  for_each = {
    for func in  var.services : 
    "${var.environment}-${func}" => {
      environment = var.environment
      function    = func
    }
  }

  metadata {
    name = each.key
  }

  lifecycle {
    create_before_destroy = true
  }
}
