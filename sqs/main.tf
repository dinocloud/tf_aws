resource "aws_sqs_queue" "default" {
  for_each                          = local.queues_expanded
  name                              = each.value.fifo_queue ? "${each.key}.fifo" : each.key
  visibility_timeout_seconds        = each.value.visibility_timeout_seconds
  message_retention_seconds         = each.value.message_retention_seconds
  max_message_size                  = each.value.max_message_size
  delay_seconds                     = each.value.delay_seconds
  receive_wait_time_seconds         = each.value.receive_wait_time_seconds
  policy                            = each.value.policy
  redrive_policy                    = each.value.redrive_policy
  fifo_queue                        = each.value.fifo_queue
  content_based_deduplication       = each.value.content_based_deduplication
  kms_master_key_id                 = each.value.kms_master_key_id
  kms_data_key_reuse_period_seconds = each.value.kms_data_key_reuse_period_seconds
  tags                              = var.tags
}

# module "sqs" {
#   source = "../../infrastructure-modules/aws/sqs"
#   tags   = local.tags
#   queues = {
#     # test = {
#     #   visibility_timeout_seconds = 30
#     #   message_retention_seconds = 345600
#     #   max_message_size = 262144
#     #   delay_seconds = 0
#     #   receive_wait_time_seconds = 0
#     #   policy = ""
#     #   redrive_policy = ""
#     #   fifo_queue = false
#     #   content_based_deduplication = false
#     #   kms_master_key_id = null
#     #   kms_data_key_reuse_period_seconds = 300
#     # }
#   }
# }