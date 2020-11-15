# XXL-Job 表结构

[CDDN参考](https://blog.csdn.net/Q772363685/article/details/85329006)

[简书参考](https://www.jianshu.com/p/b7ac68b5237d)

XXL-JOB调度模块基于Quartz集群实现，其"调度数据库"是在Quartz的11张集群mysql表基础上扩展而成。

其中Quartz为11张表、XXL-Job扩展5张

## Quartz表结构

### 1. XXL_JOB_QRTZ_JOB_DETAILS

##### 存储每一个已配置的 jobDetail 的详细信息

| 表字段            | 含义                                                         |
| ----------------- | ------------------------------------------------------------ |
| sched_name        | 调度名称                                                     |
| job_name          | 集群中job的名字,该名字用户自己可以随意定制,无强行要求        |
| job_group         | 集群中job的所属组的名字,该名字用户自己随意定制,无强行要求    |
| description       | 相关介绍                                                     |
| job_class_name    | 集群中个notejob实现类的完全包名,quartz就是根据这个路径到classpath找到该job类 |
| is_durable        | 是否持久化,把该属性设置为1，quartz会把job持久化到数据库中    |
| is_nonconcurrent  | 是否并发                                                     |
| is_update_data    | 是否更新数据                                                 |
| requests_recovery | 是否接受恢复执行，默认为false，设置了RequestsRecovery为true，则该job会被重新执行 |
| job_data          | 一个blob字段，存放持久化job对象                              |

### 2.XXL_JOB_QRTZ_TRIGGERS

##### 保存触发器的基本信息

|表字段	|  含义                                                    |
| ------- | ------------------------------------------------------- |
|sched_name|	调度名称|
|trigger_name|	触发器的名字,该名字用户自己可以随意定制,无强行要求|
|trigger_group	|触发器所属组的名字,该名字用户自己随意定制,无强行要求|
|job_name	|qrtz_job_details表job_name的外键|
|job_group	|qrtz_job_details表job_group的外键|
|description	|相关介绍|
|next_fire_time	|下一次触发时间，默认为-1，意味不会自动触发|
|prev_fire_time	|上一次触发时间（毫秒）|
|priority|	优先级|
|trigger_state|	当前触发器状态，设置为ACQUIRED,如果设置为WAITING,则job不会触发 （ WAITING:等待 PAUSED:暂停ACQUIRED:正常执行 BLOCKED：阻塞 ERROR：错误）|
|trigger_type|	触发器的类型，使用cron表达式|
|start_time	|开始时间|
|end_time|	结束时间|
|calendar_name|	日程表名称，表qrtz_calendars的calendar_name字段外键|
|misfire_instr	|措施或者是补偿执行的策略|
|job_data|	一个blob字段，存放持久化job对象|

### 3. XXL_JOB_QRTZ_CRON_TRIGGERS

##### 存储触发器的cron表达式表

|表字段	|  含义                                                    |
| ------- | ------------------------------------------------------- |
|sched_name	|调度名称|
|trigger_name	|qrtz_triggers表trigger_name的外键|
|trigger_group|	qrtz_triggers表trigger_group的外键|
|cron_expression	|cron表达式|
|time_zone_id|	时区|

### 4.XXL_JOB_QRTZ_SCHEDULER_STATE

##### 存储集群中note实例信息，quartz会定时读取该表的信息判断集群中每个实例的当前状态

|表字段	|  含义                                                    |
| ------- | ------------------------------------------------------- |
|sched_name|	调度名称|
|instance_name	|之前配置文件中org.quartz.scheduler.instanceId配置的名字，就会写入该字段|
|last_checkin_time	|上次检查时间|
|checkin_interval	|检查间隔时间|

### 5.XXL_JOB_QRTZ_BLOB_TRIGGERS

##### Trigger 作为 Blob 类型存储(用于 Quartz 用户用 JDBC 创建他们自己定制的 Trigger 类型，JobStore 并不知道如何存储实例的时候)

|表字段	|  含义                                                    |
| ------- | ------------------------------------------------------- |
|sched_name	|调度名称|
|trigger_name	|qrtz_triggers表trigger_name的外键|
|trigger_group	|qrtz_triggers表trigger_group的外键|
|blob_data	|一个blob字段，存放持久化Trigger对象|

### 6.XXL_JOB_QRTZ_CALENDARS

##### 以 Blob 类型存储存放日历信息， quartz可配置一个日历来指定一个时间范围。

|表字段	|  含义                                                    |
| ------- | ------------------------------------------------------- |
|sched_name	|调度名称|
|calendar_name	|日历名称|
|calendar	|一个blob字段，存放持久化calendar对象|

### 7.XXL_JOB_QRTZ_FIRED_TRIGGERS

##### 存储与已触发的 Trigger 相关的状态信息，以及相联 Job 的执行信息。

|表字段	|  含义                                                    |
| ------- | ------------------------------------------------------- |
|sched_name	|调度名称|
|entry_id	|调度器实例id|
|trigger_name	|qrtz_triggers表trigger_name的外键|
|trigger_group	|qrtz_triggers表trigger_group的外键|
|instance_name|	调度器实例名|
|fired_time|	触发的时间|
|sched_time|	定时器制定的时间|
|priority	|优先级|
|state	|状态|
|job_name|	集群中job的名字,该名字用户自己可以随意定制,无强行要求|
|job_group|	集群中job的所属组的名字,该名字用户自己随意定制,无强行要求|
|is_nonconcurrent|	是否并发|
|requests_recovery|	是否接受恢复执行，默认为false，设置了RequestsRecovery为true，则会被重新执行|


 ### 8.XXL_JOB_QRTZ_LOCKS

 ##### 存储程序的悲观锁的信息(假如使用了悲观锁)。

|表字段	|  含义                                                    |
| ------- | ------------------------------------------------------- |
|sched_name	|调度名称|
|lock_name	|悲观锁名称|

### 9.XXL_JOB_QRTZ_PAUSED_TRIGGER_GRPS

##### 存储已暂停的 Trigger 组的信息。

|表字段	|  含义                                                    |
| ------- | ------------------------------------------------------- |
|sched_name	|调度名称|
|trigger_group|	qrtz_triggers表trigger_group的外键|

### 10. XXL_JOB_QRTZ_SIMPLE_TRIGGERS

##### 存储简单的 Trigger，包括重复次数，间隔，以及已触发的次数。

|表字段	|  含义                                                    |
| ------- | ------------------------------------------------------- |
|trigger_name	|qrtz_triggers表trigger_ name的外键|
|trigger_group|	qrtz_triggers表trigger_group的外键|
|repeat_count|	重复的次数统计|
|repeat_interval|	重复的间隔时间|
|times_triggered|	已经触发的次数|

### 11. XXL_JOB_QRTZ_SIMPROP_TRIGGERS

##### 存储CalendarIntervalTrigger和DailyTimeIntervalTrigger

|表字段	|  含义                                                    |
| ------- | ------------------------------------------------------- |
|SCHED_NAME|	调度名称|
|TRIGGER_NAME	|qrtz_triggers表trigger_ name的外键|
|TRIGGER_GROUP	|qrtz_triggers表trigger_group的外键|
|STR_PROP_1|	String类型的trigger的第一个参数|
|STR_PROP_2	|String类型的trigger的第二个参数|
|STR_PROP_3|	String类型的trigger的第三个参数|
|INT_PROP_1|	int类型的trigger的第一个参数|
|INT_PROP_2|	int类型的trigger的第二个参数|
|LONG_PROP_1|	long类型的trigger的第一个参数|
|LONG_PROP_2|	long类型的trigger的第二个参数|
|DEC_PROP_1|	decimal类型的trigger的第一个参数|
|DEC_PROP_2|	decimal类型的trigger的第二个参数|
|BOOL_PROP_1|	Boolean类型的trigger的第一个参数|
|BOOL_PROP_2 |	Boolean类型的trigger的第二个参数|

## XXL-Job扩展表

### 1.`XXL_JOB_QRTZ_TRIGGER_GROUP`

##### 执行器信息表，维护任务执行器信息

|表字段	|  含义                                                    |
| ------- | ------------------------------------------------------- |
|id|主键|
|app_name|执行器AppName|
|title|执行器名称|
|order|排序|
|address_type|执行器地址类型：0=自动注册、1=手动录入|
|address_list|执行器地址列表，多地址逗号分隔|

### 2.`XXL_JOB_QRTZ_TRIGGER_INFO`

##### 调度扩展信息表, 用于保存XXL-JOB调度任务的扩展信息，如任务分组、任务名、机器地址、执行器、执行入参和报警邮件等等
|表字段	|  含义                                                    |
| ------- | ------------------------------------------------------- |
|id			|主键				|
|job_group       |   执行器主键ID     |
|job_cron       |     任务执行CRON    |
|job_desc       |   任务描述      |
|add_time       |  添加时间       |
|update_time    | 修改时间        |
|author        |     作者     |
|alarm_email     |   报警邮件     |
|executor_route_strategy| 执行器路由策略 |
|executor_handler     |   执行器任务handler |
|executor_param     |   执行器任务参数 |
|executor_block_strategy|  阻塞处理策略|
|executor_timeout     |   任务执行超时时间，单位秒 |
|executor_fail_retry_count| 失败重试次数|
|glue_type          |   GLUE类型  |
|glue_source         | GLUE源代码   |
|glue_remark      |  GLUE备注     |
|glue_updatetime  |  GLUE更新时间     |
|child_jobid     |    子任务ID，多个逗号分隔    |

### 3.`XXL_JOB_QRTZ_TRIGGER_LOG`

##### 调度日志表,用于保存XXL-JOB任务调度的历史信息，如调度结果、执行结果、调度入参、调度机器和执行器等等；
|表字段	|  含义                                                    |
| ------- | ------------------------------------------------------- |
|id			|主键				|
|job_group                 | 执行器主键ID |
|job_id                    | 任务，主键ID |
|executor_address          | 执行器地址，本次执行的地址 |
|executor_handler          | 执行器任务handler |
|executor_param            | 执行器任务参数 |
|executor_sharding_param   | 执行器任务分片参数，格式如 1/2 |
|executor_fail_retry_count | 失败重试次数 |
|trigger_time              | 调度-时间 |
|trigger_code              | 调度-结果 |
|trigger_msg               | 调度-日志 |
|handle_time               | 执行-时间 |
|handle_code               | 执行-结果 |
|handle_msg                | 执行-日志 |
|alarm_status              | 报警状态 |

### 4.`XXL_JOB_QRTZ_TRIGGER_LOGGLUE`

##### 任务GLUE日志,用于保存GLUE更新历史，用于支持GLUE的版本回溯功能；

|表字段	|  含义                                                    |
| ------- | ------------------------------------------------------- |
|id		  |  主键                                                    |
|job_id      | 任务，主键ID |
|glue_type   | GLUE类型 |
|glue_source |   GLUE源代码|
|glue_remark |  GLUE备注   |
|add_time    | 添加时间 |
|update_time | 更新时间 |

### 5.`XXL_JOB_QRTZ_TRIGGER_REGISTRY`

##### 执行器注册表，维护在线的执行器和调度中心机器地址信息；


|表字段	|  含义                                                    |
| ------- | ------------------------------------------------------- |
|id		  |  主键                                                    |
|registry_group | 注册类型 |
|registry_key   | 注册组别|
|registry_value | 注册地址|
|update_time    | 更新时间 |