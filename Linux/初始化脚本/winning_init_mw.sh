yum install -y elasticsearch
systemctl enable elasticsearch
systemctl restart elasticsearch
yum install -y neo4j
systemctl enable neo4j
systemctl restart neo4j
yum install -y minio
systemctl enable minio
systemctl restart minio 
yum install -y consul
systemctl enable consul
systemctl restart consul
yum install -y redis
systemctl enable redis
systemctl restart redis
yum install -y xxl-job
systemctl enable xxl-job
systemctl restart xxl-job
yum install -y rabbitmq
systemctl enable rabbitmq
systemctl restart rabbitmq
yum install -y kibana
systemctl enable kibana
systemctl restart kibana
yum install -y postgresql
systemctl enable postgresql
systemctl restart postgresql