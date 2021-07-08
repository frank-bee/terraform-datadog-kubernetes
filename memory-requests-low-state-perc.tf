locals {
  memory_requests_low_perc_state_filter = coalesce(
    var.memory_requests_low_perc_state_filter_override,
    var.filter_str
  )
}

module "memory_requests_low_perc_state" {
  source = "git@github.com:kabisa/terraform-datadog-generic-monitor.git?ref=0.6.0"

  name             = "Available Memory for Requests in percentage Low"
  query            = "max(${var.memory_requests_low_perc_state_evaluation_period}):( max:kubernetes_state.container.memory_requested{${local.memory_requests_low_perc_state_filter}} / max:kubernetes_state.node.memory_allocatable{${local.memory_requests_low_perc_state_filter}} ) * 100 > ${var.memory_requests_low_perc_state_critical}"
  alert_message    = "Kubernetes cluster memory room for Requests in percentage is too low"
  recovery_message = "Kubernetes cluster memory Requests in percentage has recovered"

  # monitor level vars
  enabled            = var.memory_requests_low_perc_state_enabled
  alerting_enabled   = var.memory_requests_low_perc_state_alerting_enabled
  critical_threshold = var.memory_requests_low_perc_state_critical
  warning_threshold  = var.memory_requests_low_perc_state_warning
  priority           = var.memory_requests_low_perc_state_priority
  severity           = var.memory_requests_low_perc_state_severity
  docs               = var.memory_requests_low_perc_state_docs
  note               = var.memory_requests_low_perc_state_note

  # module level vars
  env                  = var.alert_env
  service              = var.service
  notification_channel = var.notification_channel
  additional_tags      = var.additional_tags
  locked               = var.locked
  name_prefix          = var.name_prefix
  name_suffix          = var.name_suffix
}
