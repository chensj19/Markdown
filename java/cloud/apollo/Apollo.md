# Apollo

## 一、测试环境

### 主机规划：

| IP             | 主机名               | 用处                      |
| -------------- | -------------------- | ------------------------- |
| 192.168.78.128 | centos7.node.ansible | Apollo Portal             |
| 192.168.78.129 | centos7.node.web1    | Apollo Dev Config & Admin |
| 192.168.78.132 | centos7.node.web2    | Apollo Uat Config & Admin |
| 192.168.78.130 | centos7.node.db      | 数据库                    |

### 数据库规划

| 环境    | 数据库名称        | 数据库字符串                                                 |
| ------- | ----------------- | ------------------------------------------------------------ |
| DEV     | ApolloConfigDevDB | jdbc:mysql://192.168.78.130:3306/ApolloConfigDevDB?useSSL=false&characterEncoding=utf8 |
| UAT     | ApolloConfigUatDB | jdbc:mysql://192.168.78.130:3306/ApolloConfigUatDB?useSSL=false&characterEncoding=utf8 |
| DEV/UAT | ApolloPortalDB    | jdbc:mysql://192.168.78.130:3306/ApolloPortalDB?useSSL=false&characterEncoding=utf8 |

