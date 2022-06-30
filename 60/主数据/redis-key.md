# 主数据缓存key统计

## 编码规则

统一前缀：`1010:mdm:cr`

| KEY                                                  | 说明               |
| ---------------------------------------------------- | ------------------ |
| 1010:base_mdm:rules                                  | 编码规则 参考sql1  |
| 1010:cr:biz_code:${业务编码}                         | 业务编码规则       |
| 1010:cr:code:value:${时间}:${机构SOID}:${编码片段ID} | 当前指定编码片段值 |
| 1010:cr:code:value:${机构SOID}:${编码片段ID}         | 当前指定编码片段值 |

业务编码：来源于表`BIZ_CODING_RULE`中`CODING_RULE_BIZ_CODE`字段

编码片段：来源于表`BIZ_CODE_SEGMENT`中`CODE_SEGMENT_ID`字段

sql1:

```sql
-- 根据codingRuleId分组，会将不同片段添加到一个分组中去
select 
 ru.CODING_RULE_ID  as codingRuleId,
 ru.CODING_RULE_NAME  as codingRuleName,
 ru.CODING_RULE_DESC  as codingRuleDesc,
 ru.CODING_RULE_BIZ_CODE  as codingRuleBizCode,
 ru.APP_SYSTEM_CODE  as appSystemCode,
 ru.CODE_RULE_STATUS  as codeRuleStatus,
 ru.MAX_CHARACTER_SIZE  as maxCharacterSize,
 ru.CREATED_BY  as createdB,
 ru.MODIFIED_AT  as modifiedAt,
 ru.MODIFIED_BY  as modifiedBy,
 ru.HOSPITAL_SOID  as hospitalSOID ,
 segment.CODE_SEGMENT_ID  as codeSegmentId,
 segment.CODE_SEGMENT_TYPE_CODE  as codeSegmentTypeCode,
 segment.CHARACTER_SIZE  as characterSize,
 segment.FIXED_CHARACTER  as fixedCharacter,
 segment.COMPLEMENT  as complement,
 segment.COMPLETE_DIRECTION_CODE  as completeDirectionCode,
 segment.SEQ_NO  as seqNo,
 segment.DATE_FORMAT_CODE  as dateFormatCode,
 vs.VALUE_DESC  as dateFormat,
 segment.DATE_TYPE_CODE  as dateTypeCode,
 segment.START_NUMBER  as startNumber,
 segment.STEP_LENGTH  as stepLength,
 segment.RESET_MODE_CODE  as resetModeCode,
 segment.MAX_VALUE  as maxValue,
 segment.CODE_PARAMETER_TYPE_CODE  as codeParameterTypeCode,
 segment.CODE_OVERFLOW_HANDLING_CODE  as codeOverflowHandlingCode,
 org.CODING_RULE_X_ORG_ID  as codingRuleXOrgId,
 org.CODING_RULE_X_ORG_TYPE_CODE  as codingRuleOrgTypeCode,
 org.ORG_ID  as orgId
 from BIZ_CODING_RULE ru 
 left join BIZ_CODE_SEGMENT segment on segment.CODING_RULE_ID = ru.CODING_RULE_ID and segment.IS_DEL  = 0 
 left join CODING_RULE_X_ORGANIZATION org on org.CODING_RULE_ID = ru.CODING_RULE_ID  and org.IS_DEL = 0 
 left join VALUE_SET vs on vs.VALUE_ID  = segment.DATE_FORMAT_CODE  
 where ru.IS_DEL = 0 and ru.CODE_RULE_STATUS  = 98360
```

key: `1010:cr:biz_code:业务编码`

示例：

   普通处方编号：`1010:cr:biz_code:376369`

   普通编号当前值：`1010:cr:code:value:256181:${codeSegmentId}`

## 机构

| KEY                                           | 说明 |
| --------------------------------------------- | ---- |
| 1010:mdm:employee:findemployeeidbyemployeeno: |      |
|                                               |      |
|                                               |      |



## OID

| KEY                                   | 说明         |
| ------------------------------------- | ------------ |
| 1010:mdm:oneoid:soid:${shortObjectId} | 短码映射关系 |
| 1010:mdm:oneoid:oid:${longObjectId}   | 长码映射关系 |

## 参数配置

| KEY                                          | 说明                   | 其他                       | 数据示例             | 参数类                      |
| -------------------------------------------- | ---------------------- | -------------------------- | -------------------- | --------------------------- |
| 1010:mdm:find_param_id_by_param_no:{paramNo} | 存放参数ID与参数NO关系 | redis key 最后一位为参数NO |                      | FindParamIdByParamNoCacheDO |
| 1010:mdm:default_param_config:{paramId}      | 全局默认参数配置       | map                        | key:soid value:{}    | CommonParamConfigCacheDO    |
| 1010:mdm:param_config:{preferenceTypeCode}   | 个人参数配置           | map                        | key:paramId value:{} | CustomParamConfigCacheDO    |

## 偏好设置

| KEY                                                          | 说明                           | 其他 | 数据示例                        | 参数类                         |
| ------------------------------------------------------------ | ------------------------------ | ---- | ------------------------------- | ------------------------------ |
| 1010:preference_setting:common:{hospitalSOID}                | 全局配置                       | map  | key:preferenceTypeCode value:{} | CommonPreferenceSettingCacheDO |
| 1010:preference_setting:{preferenceTypeCode}:{appScopeEntityId} | 缓存用户偏好设置  个人、科室等 | map  | key:preferenceTypeCode value:{} | CommonPreferenceSettingCacheDO |



## ~~资源~~

key: `1010:mdm:res`

| KEY                                               | 说明       |
| ------------------------------------------------- | ---------- |
| 1010:mdm:res:emp:${employeeId}                    | 员工       |
| 1010:mdm:res:emp:emp_address:${employeeId}        | 员工地址   |
| 1010:mdm:res:emp:emp_medins:${employeeId}         |            |
| 1010:mdm:res:emp:emp_id_card:${employeeId}        | 员工证件号 |
| 1010:mdm:res:emp:emp_identification:${employeeId} | 员工证件号 |
| 1010:mdm:res:emp:emp_name_set:${employeeId}       | 员工证件号 |
| 1010:mdm:res:emp:emp_telecom:${employeeId}        | 员工证件号 |
| 1010:mdm:res:org:org_emp:${employeeId}            | 员工证件号 |
| 1010:mdm:res:emp:org_emp:${employeeId}            |            |
| 1010:mdm:res:emp:user:${employeeId}               |            |