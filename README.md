# OpenSearch CloudWatch Alarms
[AWS documention](https://docs.aws.amazon.com/opensearch-service/latest/developerguide/cloudwatch-alarms.html) recomends the following CloudWatch alarms to monitor an OpenSearch domain

| Metric name                | Statistic | Period (minute) | Threshold | Datapoints to alarm |
|----------------------------|-----------|-----------------| ----------| --------------------|
| ClusterStatus.red          | Maximum   | 1               | >= 1      | 1 out of 1          | 
| ClusterStatus.yellow       | Maximum   | 1               | >= 1      | 1 out of 1          |
| FreeStorageSpace           | Minimum   | 1               | <= 20480  | 1 out of 1          |
| ClusterIndexWritesBlocked  |           | 5               | >= 1      | 1 out of 1          |
| AutomatedSnapshotFailure   | Maximum   | 1               | >= 1      | 15 out of 15        |
| CPUUtilization             | Maximum   | 15              | >= 80%    | 15 out of 15        |
| JVMMemoryPressure          | Maximum   | 5               | >= 80%    | 3 out of 3          |
| MasterCPUUtilization       | Maximum   | 15              | >= 50%    | 3 out of 3          |
| MasterJVMMemoryPressure    | Maximum   | 15              | >= 80%    | 1 out of 1          |
| KMSKeyError                |           | 1               | >= 1      | 1 out of 1          |
| KMSKeyInaccessible         |           | 1               | >= 1      | 1 out of 1          |
| shards.active              |           | 1               | >= 30000  | 1 out of 1          | 
| 5xx alarms                 |           |                 |           | 1 out of 1          |
| MasterReachableFromNode    |           | 24              | < 1       | 1 out of 1          |
| ThreadpoolWriteQueue       | Average   | 1               | >= 100    | 1 out of 1          |
| ThreadpoolSearchQueue      | Average   | 1               | >= 500    | 1 out of 1          |
| ThreadpoolSearchQueue      | Maximum   | 1               | >= 5000   | 1 out of 1          |

Deploying the CloudFormation Stack in repository will create CloudWatch Alarms for these metrics.

To deploy these CloudWatch alarms click the button below

