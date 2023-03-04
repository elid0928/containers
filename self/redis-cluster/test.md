### redis-cluster 容器化测试
1. 新建集群
官方: check pass
pa: check pass
2. 扩容集群
命令：
helm upgrade --timeout 600s  rc3031 --set "password=password,cluster.nodes=8,cluster.update.addNodes=true,cluster.update.currentNumberOfNodes=6" .
3. 缩容集群
4. 删除集群