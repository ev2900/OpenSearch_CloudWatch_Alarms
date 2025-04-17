provider "aws" {}

data "aws_caller_identity" "current" {}

variable "email" {
  description = "Email address for SNS subscription"
  type        = string
}

variable "opensearch_cluster_name" {
  description = "Name of the OpenSearch domain"
  type        = string
}

variable "number_of_nodes_in_cluster" {
  description = "The expected number of nodes in the OpenSearch cluster"
  type        = number
}

variable "is_old_gen_instances_master_node" {
  description = "Indicates if the instances are old gen (true for old gen, false for current gen)"
  type        = bool
}

variable "is_old_gen_instances_data_node" {
  description = "Indicates if the instances are old gen (true for old gen, false for current gen)"
  type        = bool
}

# -----------------
# SNS Topic
# -----------------
resource "aws_sns_topic" "os_alert_topic" {
  name         = "os-alert-topic"
  display_name = "os-alert-topic"
  fifo_topic   = false
}

# -----------------
# SNS Subscription
# -----------------
resource "aws_sns_topic_subscription" "email_alert_subscription" {
  topic_arn = aws_sns_topic.os_alert_topic.arn
  protocol  = "email"
  endpoint  = var.email
}

# -----------------
# CloudWatch Alarm - ClusterStatus.red
# -----------------
resource "aws_cloudwatch_metric_alarm" "cluster_status_red" {
  alarm_name          = "ClusterStatus.red >= 1"
  alarm_description   = "Email when ClusterStatus.red >=1, 1 time within 1 minutes"
  namespace           = "AWS/ES"
  metric_name         = "ClusterStatus.red"
  statistic           = "Maximum"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  threshold           = 1
  period              = 60
  evaluation_periods  = 1

  dimensions = {
    ClientId   = data.aws_caller_identity.current.account_id
    DomainName = var.opensearch_cluster_name
  }

  alarm_actions = [aws_sns_topic.os_alert_topic.arn]
  ok_actions    = [aws_sns_topic.os_alert_topic.arn]
}

# -----------------
# CloudWatch Alarm - ClusterStatus.yellow
# -----------------
resource "aws_cloudwatch_metric_alarm" "cluster_status_yellow" {
  alarm_name          = "ClusterStatus.yellow >= 1"
  alarm_description   = "ClusterStatus.yellow maximum is >= 1 for 1 minute, 5 consecutive times"
  namespace           = "AWS/ES"
  metric_name         = "ClusterStatus.yellow"
  statistic           = "Maximum"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  threshold           = 1
  period              = 60
  evaluation_periods  = 5

  dimensions = {
    ClientId   = data.aws_caller_identity.current.account_id
    DomainName = var.opensearch_cluster_name
  }

  alarm_actions = [aws_sns_topic.os_alert_topic.arn]
  ok_actions    = [aws_sns_topic.os_alert_topic.arn]
}

# -----------------
# CloudWatch Alarm - FreeStorageSpace
# -----------------
resource "aws_cloudwatch_metric_alarm" "free_storage_space" {
  alarm_name          = "FreeStorageSpace <= 20480"
  alarm_description   = "Email when FreeStorageSpace <= 20480, 1 time within 1 minute"
  namespace           = "AWS/ES"
  metric_name         = "FreeStorageSpace"
  statistic           = "Minimum"
  comparison_operator = "LessThanOrEqualToThreshold"
  threshold           = 20480
  period              = 60
  evaluation_periods  = 1

  dimensions = {
    ClientId   = data.aws_caller_identity.current.account_id
    DomainName = var.opensearch_cluster_name
  }

  alarm_actions = [aws_sns_topic.os_alert_topic.arn]
  ok_actions    = [aws_sns_topic.os_alert_topic.arn]
}

# -----------------
# CloudWatch Alarm - ClusterIndexWritesBlocked
# -----------------
resource "aws_cloudwatch_metric_alarm" "cluster_index_writes_blocked" {
  alarm_name          = "ClusterIndexWritesBlocked >= 1"
  alarm_description   = "Email when ClusterIndexWritesBlocked >=1, 1 time within 5 minutes"
  namespace           = "AWS/ES"
  metric_name         = "ClusterIndexWritesBlocked"
  statistic           = "Maximum"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  threshold           = 1
  period              = 300
  evaluation_periods  = 1

  dimensions = {
    ClientId   = data.aws_caller_identity.current.account_id
    DomainName = var.opensearch_cluster_name
  }

  alarm_actions = [aws_sns_topic.os_alert_topic.arn]
  ok_actions    = [aws_sns_topic.os_alert_topic.arn]
}

# -----------------
# CloudWatch Alarm - AutomatedSnapshotFailure
# -----------------
resource "aws_cloudwatch_metric_alarm" "automated_snapshot_failure" {
  alarm_name          = "AutomatedSnapshotFailure >= 1"
  alarm_description   = "Email when AutomatedSnapshotFailure >=1, 1 time within 1 minute"
  namespace           = "AWS/ES"
  metric_name         = "AutomatedSnapshotFailure"
  statistic           = "Maximum"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  threshold           = 1
  period              = 60
  evaluation_periods  = 1

  dimensions = {
    ClientId   = data.aws_caller_identity.current.account_id
    DomainName = var.opensearch_cluster_name
  }

  alarm_actions = [aws_sns_topic.os_alert_topic.arn]
  ok_actions    = [aws_sns_topic.os_alert_topic.arn]
}

# -----------------
# CloudWatch Alarm - CPUUtilization
# -----------------
resource "aws_cloudwatch_metric_alarm" "cpu_utilization" {
  alarm_name          = "CPUUtilization >= 80"
  alarm_description   = "Email when CPUUtilization >=80, 3 times within 15 minutes"
  namespace           = "AWS/ES"
  metric_name         = "CPUUtilization"
  statistic           = "Maximum"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  threshold           = 80
  period              = 900
  evaluation_periods  = 3

  dimensions = {
    ClientId   = data.aws_caller_identity.current.account_id
    DomainName = var.opensearch_cluster_name
  }

  alarm_actions = [aws_sns_topic.os_alert_topic.arn]
  ok_actions    = [aws_sns_topic.os_alert_topic.arn]
}

# -----------------
# CloudWatch Alarm - JVMMemoryPressure
# -----------------
resource "aws_cloudwatch_metric_alarm" "jvm_memory_pressure" {
  alarm_name          = "JVMMemoryPressure >= 80 (old gen instance) / 95 (current gen instance)"
  alarm_description   = "Email when JVMMemoryPressure >= 80 (old gen instance) / 95 (current gen instance), 3 times within 5 minutes"
  namespace           = "AWS/ES"
  metric_name         = "JVMMemoryPressure"
  statistic           = "Maximum"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  threshold           = var.is_old_gen_instances_data_node ? 80 : 95
  period              = 60
  evaluation_periods  = 3

  dimensions = {
    ClientId   = data.aws_caller_identity.current.account_id
    DomainName = var.opensearch_cluster_name
  }

  alarm_actions = [aws_sns_topic.os_alert_topic.arn]
  ok_actions    = [aws_sns_topic.os_alert_topic.arn]
}

# -----------------
# CloudWatch Alarm - MasterCPUUtilization
# -----------------
resource "aws_cloudwatch_metric_alarm" "master_cpu_utilization" {
  alarm_name          = "MasterCPUUtilization >= 50"
  alarm_description   = "Email when MasterCPUUtilization >= 50, 3 times within 15 minutes"
  namespace           = "AWS/ES"
  metric_name         = "MasterCPUUtilization"
  statistic           = "Maximum"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  threshold           = 50
  period              = 300
  evaluation_periods  = 3

  dimensions = {
    ClientId   = data.aws_caller_identity.current.account_id
    DomainName = var.opensearch_cluster_name
  }

  alarm_actions = [aws_sns_topic.os_alert_topic.arn]
  ok_actions    = [aws_sns_topic.os_alert_topic.arn]
}

# -----------------
# CloudWatch Alarm - MasterJVMMemoryPressure
# -----------------
resource "aws_cloudwatch_metric_alarm" "master_jvm_memory_pressure" {
  alarm_name          = "MasterJVMMemoryPressure >= 80 (old gen instance) / 95 (current gen instance)"
  alarm_description   = "Email when MasterJVMMemoryPressure >= 80 (old gen instance) / 95 (current gen instance), 1 time within 15 minutes"
  namespace           = "AWS/ES"
  metric_name         = "MasterJVMMemoryPressure"
  statistic           = "Maximum"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  threshold           = var.is_old_gen_instances_master_node ? 80 : 95
  period              = 60
  evaluation_periods  = 3

  dimensions = {
    ClientId   = data.aws_caller_identity.current.account_id
    DomainName = var.opensearch_cluster_name
  }

  alarm_actions = [aws_sns_topic.os_alert_topic.arn]
  ok_actions    = [aws_sns_topic.os_alert_topic.arn]
}

# -----------------
# CloudWatch Alarm - KMSKeyError
# -----------------
resource "aws_cloudwatch_metric_alarm" "kms_key_error" {
  alarm_name          = "KMSKeyError >= 1"
  alarm_description   = "Email when KMSKeyError >= 1, 1 time within 1 minute"
  namespace           = "AWS/ES"
  metric_name         = "KMSKeyError"
  statistic           = "Maximum"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  threshold           = 1
  period              = 60
  evaluation_periods  = 1

  dimensions = {
    ClientId   = data.aws_caller_identity.current.account_id
    DomainName = var.opensearch_cluster_name
  }

  alarm_actions = [aws_sns_topic.os_alert_topic.arn]
  ok_actions    = [aws_sns_topic.os_alert_topic.arn]
}

# -----------------
# CloudWatch Alarm - KMSKeyInaccessible
# -----------------
resource "aws_cloudwatch_metric_alarm" "kms_key_inaccessible" {
  alarm_name          = "KMSKeyInaccessible >= 1"
  alarm_description   = "Email when KMSKeyInaccessible >= 1, 1 time within 1 minute"
  namespace           = "AWS/ES"
  metric_name         = "KMSKeyInaccessible"
  statistic           = "Maximum"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  threshold           = 1
  period              = 60
  evaluation_periods  = 1

  dimensions = {
    ClientId   = data.aws_caller_identity.current.account_id
    DomainName = var.opensearch_cluster_name
  }

  alarm_actions = [aws_sns_topic.os_alert_topic.arn]
  ok_actions    = [aws_sns_topic.os_alert_topic.arn]
}

# -----------------
# CloudWatch Alarm - Shards.active
# -----------------
resource "aws_cloudwatch_metric_alarm" "shards_active" {
  alarm_name          = "ShardsActive >= 30000"
  alarm_description   = "Email when ShardsActive >= 30000, 1 time within 1 minute"
  namespace           = "AWS/ES"
  metric_name         = "Shards.active"
  statistic           = "Maximum"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  threshold           = 30000
  period              = 60
  evaluation_periods  = 1

  dimensions = {
    ClientId   = data.aws_caller_identity.current.account_id
    DomainName = var.opensearch_cluster_name
  }

  alarm_actions = [aws_sns_topic.os_alert_topic.arn]
  ok_actions    = [aws_sns_topic.os_alert_topic.arn]
}

# -----------------
# CloudWatch Alarm - MasterReachableFromNode
# -----------------
resource "aws_cloudwatch_metric_alarm" "master_reachable_from_node" {
  alarm_name          = "MasterReachableFromNode < 1"
  alarm_description   = "Email when MasterReachableFromNode < 1, 1 time within 1 day"
  namespace           = "AWS/ES"
  metric_name         = "MasterReachableFromNode"
  statistic           = "Maximum"
  comparison_operator = "LessThanThreshold"
  threshold           = 1
  period              = 86400
  evaluation_periods  = 1

  dimensions = {
    ClientId   = data.aws_caller_identity.current.account_id
    DomainName = var.opensearch_cluster_name
  }

  alarm_actions = [aws_sns_topic.os_alert_topic.arn]
  ok_actions    = [aws_sns_topic.os_alert_topic.arn]
}

# -----------------
# CloudWatch Alarm - ThreadpoolWriteQueue
# -----------------
resource "aws_cloudwatch_metric_alarm" "threadpool_write_queue" {
  alarm_name          = "ThreadpoolWriteQueue average >= 100"
  alarm_description   = "Email when average ThreadpoolWriteQueue >= 100, 1 time within 1 minute"
  namespace           = "AWS/ES"
  metric_name         = "ThreadpoolWriteQueue"
  statistic           = "Average"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  threshold           = 100
  period              = 60
  evaluation_periods  = 1

  dimensions = {
    ClientId   = data.aws_caller_identity.current.account_id
    DomainName = var.opensearch_cluster_name
  }

  alarm_actions = [aws_sns_topic.os_alert_topic.arn]
  ok_actions    = [aws_sns_topic.os_alert_topic.arn]
}

# -----------------
# CloudWatch Alarm - ThreadpoolSearchQueue
# -----------------
resource "aws_cloudwatch_metric_alarm" "threadpool_search_queue_500" {
  alarm_name          = "ThreadpoolSearchQueue average >= 500"
  alarm_description   = "Email when average ThreadpoolSearchQueue >= 500, 1 time within 1 minute"
  namespace           = "AWS/ES"
  metric_name         = "ThreadpoolSearchQueue"
  statistic           = "Average"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  threshold           = 500
  period              = 60
  evaluation_periods  = 1

  dimensions = {
    ClientId   = data.aws_caller_identity.current.account_id
    DomainName = var.opensearch_cluster_name
  }

  alarm_actions = [aws_sns_topic.os_alert_topic.arn]
  ok_actions    = [aws_sns_topic.os_alert_topic.arn]
}

# -----------------
# CloudWatch Alarm - ThreadpoolSearchQueue
# -----------------
resource "aws_cloudwatch_metric_alarm" "threadpool_search_queue" {
  alarm_name          = "ThreadpoolSearchQueue >= 5000"
  alarm_description   = "Email when ThreadpoolSearchQueue >= 5000, 1 time within 1 minute"
  namespace           = "AWS/ES"
  metric_name         = "ThreadpoolSearchQueue"
  statistic           = "Maximum"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  threshold           = 5000
  period              = 60
  evaluation_periods  = 1

  dimensions = {
    ClientId   = data.aws_caller_identity.current.account_id
    DomainName = var.opensearch_cluster_name
  }

  alarm_actions = [aws_sns_topic.os_alert_topic.arn]
  ok_actions    = [aws_sns_topic.os_alert_topic.arn]
}

# -----------------
# CloudWatch Alarm - ThreadpoolWriteRejected
# -----------------
resource "aws_cloudwatch_metric_alarm" "threadpool_write_rejected_diff" {
  alarm_name          = "DIFF(ThreadpoolWriteRejected) >= 1"
  alarm_description   = "Alarm when difference in ThreadpoolWriteRejected is greater than or equal to 1"
  evaluation_periods  = 1
  threshold           = 1
  comparison_operator = "GreaterThanThreshold"
  alarm_actions       = [aws_sns_topic.os_alert_topic.arn]
  ok_actions          = [aws_sns_topic.os_alert_topic.arn]

  metric_query {
    id          = "threadpoolWriteRejected"
    return_data = false

    metric {
      metric_name = "ThreadpoolWriteRejected"
      namespace   = "AWS/ES"
      period      = 60
      stat        = "Sum"
      unit        = "Count"

      dimensions = {
        ClientId   = data.aws_caller_identity.current.account_id
        DomainName = var.opensearch_cluster_name
      }
    }
  }

  metric_query {
    id          = "dIFF_threadpoolWriteRejected"
    expression  = "DIFF(threadpoolWriteRejected)"
    label       = "Difference in ThreadpoolWriteRejected"
    return_data = true
  }
}

# -----------------
# CloudWatch Alarm - ThreadpoolSearchRejected 
# -----------------
resource "aws_cloudwatch_metric_alarm" "threadpool_search_rejected_diff" {
  alarm_name          = "DIFF(ThreadpoolSearchRejected) >= 1"
  alarm_description   = "Alarm when difference in ThreadpoolSearchRejected is greater than or equal to 1"
  evaluation_periods  = 1
  threshold           = 1
  comparison_operator = "GreaterThanThreshold"
  alarm_actions       = [aws_sns_topic.os_alert_topic.arn]
  ok_actions          = [aws_sns_topic.os_alert_topic.arn]

  metric_query {
    id          = "threadpoolSearchRejected"
    return_data = false

    metric {
      metric_name = "ThreadpoolSearchRejected"
      namespace   = "AWS/ES"
      period      = 60
      stat        = "Sum"
      unit        = "Count"

      dimensions = {
        ClientId   = data.aws_caller_identity.current.account_id
        DomainName = var.opensearch_cluster_name
      }
    }
  }

  metric_query {
    id          = "dIFF_threadpoolSearchRejected"
    expression  = "DIFF(threadpoolSearchRejected)"
    label       = "Difference in ThreadpoolSearchRejected"
    return_data = true
  }
}

# -----------------
# CloudWatch Alarm - Nodes  
# -----------------
resource "aws_cloudwatch_metric_alarm" "nodes_less_than_expected" {
  alarm_name          = "Nodes < NumberOfNodesInCluster, 1 time within 1 day"
  alarm_description   = "Email when Nodes < NumberOfNodesInCluster (the number of nodes that are supposed to be in the cluster), 1 time within 1 day"
  namespace           = "AWS/ES"
  metric_name         = "Nodes"
  statistic           = "Minimum"
  comparison_operator = "LessThanThreshold"
  threshold           = var.number_of_nodes_in_cluster
  period              = 86400 # 1 day
  evaluation_periods  = 1

  dimensions = {
    ClientId   = data.aws_caller_identity.current.account_id
    DomainName = var.opensearch_cluster_name
  }

  alarm_actions = [aws_sns_topic.os_alert_topic.arn]
  ok_actions    = [aws_sns_topic.os_alert_topic.arn]
}
