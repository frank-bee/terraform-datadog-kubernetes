locals {
  node_diskpressure_filter = coalesce(
    var.node_diskpressure_filter_override,
    var.filter_str
  )
}

module "node_diskpressure" {
  source = "git@github.com:kabisa/terraform-datadog-generic-monitor.git?ref=0.6.2"

  name             = "Nodes with Diskpressure"
  query            = "avg(${var.node_diskpressure_evaluation_period}):max:kubernetes_state.nodes.by_condition{${local.node_diskpressure_filter} AND condition:diskpressure AND (status:true OR status:unknown)} by {cluster_name,host} > ${var.node_diskpressure_critical}"
  alert_message    = "Kubernetes cluster node {{node}} has diskpressure. Meaning it is low on disk space (Logging, emptydir volumes, caching, etc)"
  recovery_message = "Kubernetes cluster node {{node}} no longer has problems with DiskPressure."

  # monitor level vars
  enabled            = var.state_metrics_monitoring && var.node_diskpressure_enabled
  alerting_enabled   = var.node_diskpressure_alerting_enabled
  critical_threshold = var.node_diskpressure_critical
  # no warning threshold for this monitor
  priority = var.node_diskpressure_priority
  docs     = var.node_diskpressure_docs
  note     = var.node_diskpressure_note

  # module level vars
  env                  = var.alert_env
  service              = var.service
  notification_channel = var.notification_channel
  additional_tags      = var.additional_tags
  locked               = var.locked
  name_prefix          = var.name_prefix
  name_suffix          = var.name_suffix
}
