### CloudNative
#### 基本功能满足度
1. 集群的创建， 支持1主多从
2. 支持从已有的pg库构建新的pg集群
3. 支持快照备份
4. 集成pgbouncer
5. 高可用能力
   1. 自动故障检测和自动failover
   2. switchover能力
   3. https://cloudnative-pg.io/documentation/1.21/failure_modes/
6. 监控： 使用prometheus， grafana， operator可以通过在集群资源本身中设置`.spec.monitoring.enablePodMonitor`来自动创建正确指向集群的 PodMonitor （默认值： false）。true
7. 备份
  支持备份至对象存储， 以及使用快照备份，支持计划备份`ScheduledBackup`, 按需备份`Backup`等

|                                   | 对象存储 |   卷快照   |
|-----------------------------------|:------------:|:--------------------:|
| **WAL 归档**                 |   Required   |    Recommended (1)   |
| **冷备份**                   |      ✗       |           ✓          |
| **热备份**                    |      ✓       |           ✓          |
| **增量备份**              |      ✗       |         ✓  (2)       |
| **差异备份**             |      ✗       |         ✓  (2)       |
| **从备机备份**         |      ✓       |           ✓          |
| **快照恢复**             |    ✗ (3)     |           ✓          |
| **基于时间点的恢复(PITR)** |      ✓       | Requires WAL archive |
| **Underlying technology**         | Barman Cloud |   Kubernetes API     |

  
##### Kubernetes及PostgreSQL支持列表
CloudNativePG版本的支持状态
|版本	|目前支持	|发布日期	|生命尽头	|支持的Kubernetes版本	|已测试，但不支持|	支持的 Postgres 版本|
|-|-|-|-|-|-|-|
|1.21.x	|是的	|2023 年 10 月 12 日|	~ 2024 年 4 月 12 日|	1.25, 1.26, 1.27, 1.28|	1.23, 1.24|	12 - 16|
|1.20.x	|是的	|2023 年 4 月 27 日|	~ 2023 年 12 月 28 日|	1.24, 1.25, 1.26, 1.27|	1.23|	11 - 16|
|主要的	|不，仅开发|-|-|-|-|11 - 16|

#### 场景覆盖度
#### 亮点功能
1. 自定义的控制器， 实现了一个区别于`statefulset`的控制器， 通过该控制器直接管理`pod`, 虽然增加了实现的复杂性，但这种设计选择为`operator`提供了更灵活的管理集群的方式， 同时对`PostgreSQL`的拓扑关系保持透明
2. 支持调整PVC 的大小 -- 需要csi支持
3. 当一个集群中存在多个pvc时， 某个节点`node`失联的情况下， 支持在另外一个节点创建pod和pvc并从已有的pvc中拷贝数据到新的pvc中
4. 支持[集群休眠](https://github.com/cloudnative-pg/cloudnative-pg/blob/main/docs/src/declarative_hibernation.md)
5. 数据库角色管理资源化
### 架构
Kubernetes架构:
支持多可用区集群
支持单集群
PostgreSQL 高可用架构
CloudNativePG 支持基于异步和同步的流式复制的集群来管理同一个kubenretes集群内的多个热备副本：
* 一主多备
* 应用可用服务
  *  `-rw`: 应用程序仅连接到集群的主实例
  *  `-ro`： 应用程序仅连接只读实例
  *  `-r`: 应用程序连接到任何只读实例


![Bird-eye view of the recommended shared nothing architecture for PostgreSQL in Kubernetes](./docs/src/images/k8s-pg-architecture.png)
如果集群的拓扑发生变化， CloudNativePG会自动更新上述服务。

##### 滚动更新
操作员开始升级所有副本，一次升级一个 Pod，并从序列号最高的副本开始。  
主节点是最后一个要升级的节点。  
  滚动更新是可配置的，可以完全自动化(unsupervised) 或需要人工干预(supervised)。
升级保留 CloudNativePG 身份，无需重新克隆数据。如果需要，Pod 将被删除并使用相同的 PVC 和新映像再次创建。在滚动更新过程中，每个服务端点都会移动以反映集群的状态，以便应用程序可以忽略正在更新的节点。跨Kubernetes集群部署
CloudNative 引入PostgreSQL副本集群概念， 副本集群可在私有， 公有云，混合和多云环境实现多集群部署的CloudNative方式
副本集是一个单独的`Cluster`资源:
1. 具有来自定义的外部**源**集群的**任一** `pg_basebackup` 或完整'recovery' 的引导
2. 将`replica.enabled`选项设置为`true`
3. 从 由指定的外部集群进行复制`replica.source`, 通常来自于外部kubernetes集群
4. 重放从恢复对象存储``接收的WAL 信息， 或通过流复制， 或两者的任何一个
5. 只接受只读连接
![An example of multi-cluster deployment with a primary and a replica cluster](./docs/src/images/multi-cluster.png)

!!!重要
CloudNativePG 目前不支持任何跨集群切换或故障转移， 此类操作必须手动执行或委托给多集群感知机构， 每个PostgreSQL 集群都是独立的

##### 审计
CloudNativePG 允许数据库和安全管理员、审计员和操作员使用 PGAudit（适用于 PostgreSQL）跟踪和分析数据库活动。此类活动直接在 JSON 日志中流动，并且可以使用 Fluentd 等常见日志代理正确路由到正确的下游目标。

##### 实时查询监控
CloudNativePG 透明且原生支持：
基本pg_stat_statements扩展，它可以跟踪 PostgreSQL 服务器执行的所有 SQL 语句的计划和执行统计信息；
扩展auto_explain，它提供了一种自动记录慢速语句的执行计划的方法，而无需手动运行EXPLAIN（有助于跟踪未优化的查询）；
扩展，使逻辑复制槽可以跨物理故障转移使用，确保基于 PostgreSQL 原生逻辑复制的变更数据捕获 (CDC) 上下文的弹性pg_failover_slots；

#### 架构的具体实现
#### 架构的物理依赖
多可用区， 单可用区均可
#### 架构的丰富度
支持跨可用区部署， 支持1注多从等
1. 支持kubernetes 原生[snapshot](https://github.com/cloudnative-pg/cloudnative-pg/pull/3102) 备份 

##### 自动failover
支持配置服务不可用时间， 当服务超过设置的超时时间后， operator会对其进行故障转移
故障转移流程：
1. 首先，它将标记TargetPrimary为pending。此状态更改将强制主 Pod 关闭，以确保副本上的 WAL 接收器停止。集群将被标记为处于故障转移阶段（“故障转移”）
2. 一旦所有 WAL 接收器停止，就会进行领导者选举，并命名新的主节点。所选实例将启动升级为主实例，完成后，集群将恢复正常运行。同时，原来的主 Pod 会重新启动，检测到它不再是主节点，并成为副本节点。


#### 自带benchmark组件
CNPG kubectl 插件提供了一种使用 CloudNativePG 对 Kubernetes 中的 PostgreSQL 部署进行基准测试的简单方法。
基准测试主要集中在两个方面：
  * 数据库，通过依赖pgbench
  * 存储，依靠fio


