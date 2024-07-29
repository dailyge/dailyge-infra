resource "aws_sqs_queue" "dailyge_event_queue" {
  name = "dailyge-event-queue"
}

resource "aws_sqs_queue" "dailyge_event_dead_letter_queue" {
  name = "dailyge-event-dead-letter-queue"
}
