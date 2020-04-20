# Elastic 集群环境部署

## Elasticsearch集群部署



## Kibana部署



## filebeat 安装

### 安装软件：/lib/ld-linux.so.2: bad ELF interpreter解决

```bash
yum install glibc.i686 -y
```

### 获取源文件

```bash
wget https://mirrors.huaweicloud.com/filebeat/7.2.0/filebeat-7.2.0-linux-x86_64.tar.gz
tar -zxvf filebeat-7.2.0-linux-x86_64.tar.gz
```

### 配置文件修改

```bash
vim filebeat-7.2.0-linux-x86_64/filebeat.yml
```

* **master**

```yml
#============================== Kibana =====================================
setup.kibana:
  host: "192.168.31.38:5601"
#-------------------------- Elasticsearch output ------------------------------
output.elasticsearch:
  # Array of hosts to connect to.
  hosts: ["192.168.31.38:9200"]
```

* **slave1**

```yaml
#============================== Kibana =====================================
setup.kibana:
  host: "192.168.31.38:5601"
#-------------------------- Elasticsearch output ------------------------------
output.elasticsearch:
  # Array of hosts to connect to.
  hosts: ["192.168.31.39:9200"]
```

* **slave2**

```yaml
#============================== Kibana =====================================
setup.kibana:
  host: "192.168.31.38:5601"
#-------------------------- Elasticsearch output ------------------------------
output.elasticsearch:
  # Array of hosts to connect to.
  hosts: ["192.168.31.40:9200"]
```

* **slave3**

```yaml
#============================== Kibana =====================================
setup.kibana:
  host: "192.168.31.38:5601"
#-------------------------- Elasticsearch output ------------------------------
output.elasticsearch:
  # Array of hosts to connect to.
  hosts: ["192.168.31.41:9200"]
```

### 初始化

```bash
cd filebeat-7.2.0-linux-x86_64
# 启用和配置elasticsearch
./filebeat modules enable elasticsearch
# Modify the settings in the modules.d/elasticsearch.yml file.
Enabled elasticsearch
./filebeat setup
./filebeat -e
```

