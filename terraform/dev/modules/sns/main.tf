resource "aws_sns_topic" "dailyge_event_topic" {
  name = "dailyge-event"
}

resource "aws_sns_topic_subscription" "dailyge_event_subscription" {
  topic_arn = aws_sns_topic.dailyge_event_topic.arn
  protocol  = "sqs"
  endpoint  = var.dailyge_sqs_event_queue_arn
}
