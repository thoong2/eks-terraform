output "namespaces" {
  description = "Map of created namespaces"
  value       = {
                  for ns in kubernetes_namespace.namespace :
                  ns.metadata[0].name => ns.metadata[0].name
                }
}
