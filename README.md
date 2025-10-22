# OpenSearch CloudWatch Alarms

<img width="275" alt="map-user" src="https://img.shields.io/badge/cloudformation template deployments-793-blue"> <img width="85" alt="map-user" src="https://img.shields.io/badge/views-10567-green"> <img width="125" alt="map-user" src="https://img.shields.io/badge/unique visits-3931-green">

> [!NOTE]
> A Terraform deployment option is also available. You can find the required .tf file [HERE](https://github.com/ev2900/OpenSearch_CloudWatch_Alarms/blob/main/OpenSearch_cloudwatch_alarms.tf)

Deploying the CloudFormation / Terraform in this repository will create CloudWatch Alarms - that will trigger email alerts via. SNS notification - for the metrics documented in the table below.

To deploy the CloudWatch alarms via. CloudFormation click the button

[![Launch CloudFormation Stack](https://sharkech-public.s3.amazonaws.com/misc-public/cloudformation-launch-stack.png)](https://console.aws.amazon.com/cloudformation/home#/stacks/new?stackName=open-search-cloudwatch-alarms&templateURL=https://sharkech-public.s3.amazonaws.com/misc-public/OpenSearch_cloudwatch_alarms.yaml)

When prompted by CloudFormation enter the name of the OpenSearch domain to monitor and the email address you want notifications to be send to

[AWS documention](https://docs.aws.amazon.com/opensearch-service/latest/developerguide/cloudwatch-alarms.html) recomends these CloudWatch alarms as a means of monitoring an OpenSearch domain

| Metric name                    | Statistic | Period (second) | ComparisonOperator            | Threshold | EvaluationPeriods |
|--------------------------------|-----------|-----------------| ------------------------------|-----------|-------------------|
| ClusterStatus.red              | Maximum   | 60              | GreaterThanOrEqualToThreshold | 1         | 1                 |
| ClusterStatus.yellow           | Maximum   | 60              | GreaterThanOrEqualToThreshold | 1         | 5                 |
| FreeStorageSpace               | Minimum   | 60              | LessThanOrEqualToThreshold    | 20480     | 1                 |
| ClusterIndexWritesBlocked      | Maximum   | 300             | GreaterThanOrEqualToThreshold | 1         | 1                 |
| AutomatedSnapshotFailure       | Maximum   | 60              | GreaterThanOrEqualToThreshold | 1         | 1                 |
| CPUUtilization                 | Maximum   | 900             | GreaterThanOrEqualToThreshold | 80        | 3                 |
| JVMMemoryPressure              | Maximum   | 60              | GreaterThanOrEqualToThreshold | 95        | 3                 |
| OldGenJVMMemoryPressure        | Maximum   | 60              | GreaterThanOrEqualToThreshold | 80        | 3                 |
| MasterCPUUtilization           | Maximum   | 900             | GreaterThanOrEqualToThreshold | 50        | 3                 |
| MasterJVMMemoryPressure        | Maximum   | 60              | GreaterThanOrEqualToThreshold | 95        | 3                 |
| MasterOldGenJVMMemoryPressure  | Maximum   | 60              | GreaterThanOrEqualToThreshold | 80        | 3                 |
| KMSKeyError                    | Maximum   | 60              | GreaterThanOrEqualToThreshold | 1         | 1                 |
| KMSKeyInaccessible             | Maximum   | 60              | GreaterThanOrEqualToThreshold | 1         | 1                 |
| Shards.active                  | Maximum   | 60              | GreaterThanOrEqualToThreshold | 30000     | 1                 |
| MasterReachableFromNode        | Maximum   | 86400           | LessThanThreshold             | 1         | 1                 |
| ThreadpoolWriteQueue           | Average   | 60              | GreaterThanOrEqualToThreshold | 100       | 1                 |
| ThreadpoolSearchQueue          | Average   | 60              | GreaterThanOrEqualToThreshold | 500       | 1                 |
| ThreadpoolSearchQueue          | Maximum   | 60              | GreaterThanOrEqualToThreshold | 5000      | 1                 |
| ThreadpoolWriteRejected        | Maximum   | 60              | GreaterThanOrEqualToThreshold | 1         | 1                 |
| ThreadpoolSearchRejected       | Maximum   | 60              | GreaterThanOrEqualToThreshold | 1         | 1                 |
| Nodes                          | Minimum   | 86400           | LessThanThreshold             | 1         | 1                 |

## Planned Improvements  for this Repository
1. Add alarm for [IOPS Throttle](https://docs.aws.amazon.com/opensearch-service/latest/developerguide/managedomains-cloudwatchmetrics.html#managedomains-cloudwatchmetrics-cluster-metrics) | Maximum | 300 seconds | GreaterThanOrEqualToThreshold | 1 | 2
2. Add alarm for [Throughput Throttle](https://docs.aws.amazon.com/opensearch-service/latest/developerguide/managedomains-cloudwatchmetrics.html#managedomains-cloudwatchmetrics-cluster-metrics) | Maximum | 300 seconds | GreaterThanOrEqualToThreshold | 1 | 2
3. Add alarm for [ReadThroughputMicroBursting](https://docs.aws.amazon.com/opensearch-service/latest/developerguide/managedomains-cloudwatchmetrics.html#managedomains-cloudwatchmetrics-master-ebs-metrics) + [WriteThroughputMicroBursting](https://docs.aws.amazon.com/opensearch-service/latest/developerguide/managedomains-cloudwatchmetrics.html#managedomains-cloudwatchmetrics-master-ebs-metrics) | SUM ReadThroughputMicroBursting + WriteThroughputMicroBursting | 300 | GreaterThan | Provisioned Throughput of EBS volume(s) | 2
4. Simply user inputs to their email and cluster ARN. Automaticlly get the other required cluster information using the ARN
5. Add alarms for metrics of the dedicated cordinator nodes
