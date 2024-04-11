# OpenSearch CloudWatch Alarms

<img width="275" alt="map-user" src="https://img.shields.io/badge/cloudformation template deployments-444-blue"> <img width="85" alt="map-user" src="https://img.shields.io/badge/views-6005-green"> <img width="125" alt="map-user" src="https://img.shields.io/badge/unique visits-1963-green">

Deploying the CloudFormation Stack in this repository will create CloudWatch Alarms - that will trigger email alerts via. SNS notification - for the metrics documented in the table below.

To deploy the CloudWatch alarms click the button

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
