### redis-/cluster扩缩容


* 集群创建 [🐶]
* 新增节点 [🐶]
* 删除节点  // 新增脚本
* 节点的高可用

#### 集群创建方案二
1. 使用 redis-cli --cluster create 创建主节点  
    主节点创建规则： all_nodes/ (replicas + 1)   8
    8 / 2 = 4
    [0，1，2，3]
    master 0  slave 1
    master 2  slave 3
    master 4  slave 5
    master 6 slave 7
2. 使用 redis-cli --cluster add-node 添加从节点
    从节点创建规则： [master_index+1, master_index+replicas]  // 从节点的master_index 为主节点的下标
    redis-cli --cluster add-node 127.0.0.1:700x 127.0.0.1:7001 --cluster-slave --cluster-master-id <master_node_id>

以此来实现主节点与从节点pod下标的关系对应
