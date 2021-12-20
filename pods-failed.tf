locals {
  pods_failed_filter = coalesce(
    var.pods_failed_filter_override,
    var.filter_str
  )
}

module "pods_failed" {
  source = "git@github.com:kabisa/terraform-datadog-generic-monitor.git?ref=0.7.0.rc1"

  name  = "Pods Failed"
  query = "min(${var.pods_failed_evaluation_period}):default_zero(max:kubernetes_state.pod.status_phase{${local.pods_failed_filter}} by {namespace}) > ${var.pods_failed_critical}"

  # alert specific configuration
  require_full_window = true
  alert_message       = "Kubernetes pods failed ({{ value }}) in {{ service }} exceeds {{ threshold }}"
  recovery_message    = "Kubernetes pods failed ({{ value }}) in {{ service }} has recovered"

  # monitor level vars
  enabled            = var.pods_failed_enabled
  alerting_enabled   = var.pods_failed_alerting_enabled
  warning_threshold  = var.pods_failed_warning
  critical_threshold = var.pods_failed_critical
  priority           = var.pods_failed_priority
  docs               = var.pods_failed_docs
  note               = var.pods_failed_note

  # module level vars
  env                  = var.env
  service              = var.service
  service_display_name = var.service_display_name
  notification_channel = var.notification_channel
  additional_tags      = var.additional_tags
  locked               = var.locked
  name_prefix          = var.name_prefix
  name_suffix          = var.name_suffix
}
