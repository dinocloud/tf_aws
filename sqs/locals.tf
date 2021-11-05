locals {
  default_queue_config = {
    visibility_timeout_seconds        = 30
    message_retention_seconds         = 345600
    max_message_size                  = 262144
    delay_seconds                     = 0
    receive_wait_time_seconds         = 0
    policy                            = ""
    redrive_policy                    = ""
    fifo_queue                        = false
    content_based_deduplication       = false
    kms_master_key_id                 = null
    kms_data_key_reuse_period_seconds = 300
  }

  queues_expanded = { for k, v in var.queues : k => merge({
    visibility_timeout_seconds        = local.default_queue_config.visibility_timeout_seconds
    message_retention_seconds         = local.default_queue_config.message_retention_seconds
    max_message_size                  = local.default_queue_config.max_message_size
    delay_seconds                     = local.default_queue_config.delay_seconds
    receive_wait_time_seconds         = local.default_queue_config.receive_wait_time_seconds
    policy                            = local.default_queue_config.policy
    redrive_policy                    = local.default_queue_config.redrive_policy
    fifo_queue                        = local.default_queue_config.fifo_queue
    content_based_deduplication       = local.default_queue_config.content_based_deduplication
    kms_master_key_id                 = local.default_queue_config.kms_master_key_id
    kms_data_key_reuse_period_seconds = local.default_queue_config.kms_data_key_reuse_period_seconds
  }, v) }
}