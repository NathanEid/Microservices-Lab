resource "aws_sqs_queue" "first_sqs" {
  name = var.sqs_name[0]
  visibility_timeout_seconds = var.sqs_visibility_timeout_seconds[0]

  redrive_policy    = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dead_letter_queue.arn
    maxReceiveCount    = 1
})
}

resource "aws_sqs_queue" "dead_letter_queue" {
  name              = "dead-letter-queue"
  visibility_timeout_seconds = var.sqs_visibility_timeout_seconds[1]
}

resource "aws_sqs_queue_policy" "sqs_policy_first" {
  queue_url = aws_sqs_queue.first_sqs.id
  policy = <<POLICY
            {
            "Version": "2012-10-17",
            "Id": "sqspolicy",
            "Statement": [
                {
                "Sid": "First",
                "Effect": "Allow",
                "Principal": "*",
                "Action": "sqs:SendMessage",
                "Resource": "${aws_sqs_queue.first_sqs.arn}",
                "Condition": {
                    "ArnEquals": {
                    "aws:SourceArn": "${aws_sns_topic.topic.arn}"
                    }
                }
                }
            ]
            }
            POLICY
}

resource "aws_sqs_queue" "second_sqs" {
  name = var.sqs_name[1]
  visibility_timeout_seconds = var.sqs_visibility_timeout_seconds[1]
}

resource "aws_sqs_queue_policy" "sqs_policy_second" {
  queue_url = aws_sqs_queue.second_sqs.id
  policy = <<POLICY
            {
            "Version": "2012-10-17",
            "Id": "sqspolicy",
            "Statement": [
                {
                "Sid": "First",
                "Effect": "Allow",
                "Principal": "*",
                "Action": "sqs:SendMessage",
                "Resource": "${aws_sqs_queue.second_sqs.arn}",
                "Condition": {
                    "ArnEquals": {
                    "aws:SourceArn": "${aws_sns_topic.topic.arn}"
                    }
                }
                }
            ]
            }
            POLICY
}

resource "aws_sns_topic_subscription" "first_sqs_target" {
  topic_arn = aws_sns_topic.topic.arn
  protocol  = var.sns_topic_subscription_protocol
  endpoint  = aws_sqs_queue.first_sqs.arn
}

resource "aws_sns_topic_subscription" "second_sqs_target" {
  topic_arn = aws_sns_topic.topic.arn
  protocol  = var.sns_topic_subscription_protocol
  endpoint  = aws_sqs_queue.second_sqs.arn
}
