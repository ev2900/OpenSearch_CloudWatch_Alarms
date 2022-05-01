# OpenSearch CloudWatch Alarms
[AWS documention](https://docs.aws.amazon.com/opensearch-service/latest/developerguide/cloudwatch-alarms.html) recomends the following CloudWatch alarms to monitor an OpenSearch domain

| Metric name                | Statistic | Period (second) | ComparisonOperator            | Threshold | EvaluationPeriods |
|----------------------------|-----------|-----------------| ------------------------------|-----------|-------------------|
| ClusterStatus.red          | Maximum   | 60              | GreaterThanOrEqualToThreshold | 1         | 1                 | 
| ClusterStatus.yellow       | Maximum   | 60              | GreaterThanOrEqualToThreshold | 1         | 1                 |
| FreeStorageSpace           | Minimum   | 60              | LessThanOrEqualToThreshold    | 20480     | 1                 |
| ClusterIndexWritesBlocked  | Maximum   | 300             | GreaterThanOrEqualToThreshold | 1         | 1                 |
| AutomatedSnapshotFailure   | Maximum   | 60              | GreaterThanOrEqualToThreshold | 1         | 15                |
| CPUUtilization             | Maximum   | 900             | GreaterThanOrEqualToThreshold | 80        | 15                |
| JVMMemoryPressure          | Maximum   | 300             | GreaterThanOrEqualToThreshold | 80        | 3                 |
| MasterCPUUtilization       | Maximum   | 900             | GreaterThanOrEqualToThreshold | 50        | 3                 |
| MasterJVMMemoryPressure    | Maximum   | 900             | GreaterThanOrEqualToThreshold | 80        | 1                 |
| KMSKeyError                |           | 60              | GreaterThanOrEqualToThreshold | 1         | 1                 |
| KMSKeyInaccessible         |           | 60              | GreaterThanOrEqualToThreshold | 1         | 1                 |
| shards.active              | Maximum   | 60              | GreaterThanOrEqualToThreshold | 30000     | 1                 |  
| 5xx alarms                 |           |                 |                               |           | 1                 |
| MasterReachableFromNode    |           | 86400           | < 1                           | 1         | 1                 |
| ThreadpoolWriteQueue       | Average   | 60              | GreaterThanOrEqualToThreshold | 100       | 1                 |
| ThreadpoolSearchQueue      | Average   | 60              | GreaterThanOrEqualToThreshold | 500       | 1                 |
| ThreadpoolSearchQueue      | Maximum   | 60              | GreaterThanOrEqualToThreshold | 5000      | 1                 |

Deploying the CloudFormation Stack in repository will create CloudWatch Alarms for these metrics. To deploy these CloudWatch alarms click the button below

