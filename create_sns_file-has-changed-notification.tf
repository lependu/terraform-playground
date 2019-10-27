resource "aws_sns_topic" "file-has-changed-notification" {
  name = "file-has-changed-notification"

  policy = <<POLICY
{
    "Version":"2012-10-17",
    "Statement":[{
        "Effect": "Allow",
        "Principal": {"AWS":"*"},
        "Action": "SNS:Publish",
        "Resource": "arn:aws:sns:*:*:s3-event-notification-topic",
        "Condition":{
            "ArnLike":{"aws:SourceArn":"${aws_s3_bucket.bucket.arn}"}
        }
    }]
}
POLICY
}

resource "aws_s3_bucket" "bucket" {
  bucket = "terraform-playground-bucket"
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = "${aws_s3_bucket.bucket.id}"

  topic {
    topic_arn     = "${aws_sns_topic.file-has-changed-notification.arn}"
    events        = ["s3:ObjectCreated:*"]
    filter_suffix = ".log"
  }
}
