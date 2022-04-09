# maven



## 查看依赖包

```bash
mvn dependency:tree -Dverbose -Dincludes=com.winning.record.ipt:winning-bmts-record-diagnosis-inpatient-api:0.1.4-SNAPSHOT

# appendOutput:追加输出，而不是覆盖
# excludes，includes：通过逗号分离，格式[groupId]:[artifactId]:[type]:[version]，支持通配符*
# outputFile：指定输出文件路径
# outputType：指定输出文件格式，默认text，还支持dot,graphml,tgf
```

