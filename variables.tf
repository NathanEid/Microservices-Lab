#S3 Variables
variable "first_bucket_name" {
  default = "first-s3-95724"
}
variable "second_bucket_name" {
  default = "second-s3-95724"
}

#SNS Variables
variable "sns_topic_name" {
  default = "s3-event-notification-topic"
}
variable "sns_topic_sub_protocol" {
  default = "email"
}
variable "sns_topic_sub_endpoint" {
  default = "nesoeid4@gmail.com"
}

#SQS Variable
variable "sqs_name" {
    default = ["first_sqs", "second_sqs"]
}
variable "sqs_visibility_timeout_seconds" {
  default = [30, 300]
}
variable "sns_topic_subscription_protocol" {
  default = "sqs"
}