resource "aws_sns_topic" "topic" {
  name = var.sns_topic_name
  policy = <<POLICY
            {
                "Version":"2012-10-17",
                "Statement":[{
                    "Effect": "Allow",
                    "Principal": { "Service": "s3.amazonaws.com" },
                    "Action": "SNS:Publish",
                    "Resource": "arn:aws:sns:*:*:s3-event-notification-topic",
                    "Condition":{
                        "ArnLike":{"aws:SourceArn":"${aws_s3_bucket.first-s3.arn}"}
                    }
                }]
            }
            POLICY
}

resource "aws_sns_topic_subscription" "email-target" {
  topic_arn = aws_sns_topic.topic.arn
  protocol  = var.sns_topic_sub_protocol
  endpoint  = var.sns_topic_sub_endpoint
}
