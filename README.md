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
| MasterCPUUtilization
