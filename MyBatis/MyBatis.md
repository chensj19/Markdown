# MyBatis 使用笔记

## 1. association和collection用法

### 1.1 关联-association

association通常用来映射一对一的关系，例如，有个类user,对应的实体类如下：(getter,setter方法省略)

```java
    private String id;//主键
    private String userName;//用户姓名
```

 

有个类Article,对应的实体类如下：

```java
    private String id;//主键
    private String articleTitle;//文章标题
    private String articleContent;//文章内容
  
```

如果我想查询一个用户的时候，也查到他写的一篇文章，可以怎样写呢？在类user加入一个属性article

```java
   private String id;//主键
   private String userName;//用户姓名
   private Article article;//新增的文章属性
 
```

2、mapper.xml 我在user类的mapper.xml这样配置

```xml
<resultMap id="userResultMap" type="test.mybatis.entity.User">
  <id column="id" property="id" jdbcType="VARCHAR" javaType="java.lang.String"/>
  <result column="userName" property="userName" jdbcType="VARCHAR" javaType="java.lang.String"/>
  //这里把user的id传过去
   <association property="article" column="id"                       
            select="test.mybatis.dao.articleMapper.selectArticleByUserId" />
    //test.mybatis.dao.articleMapper为命名空间
 </resultMap>
```

同时，我的article对应的xml这样写：

```xml
<resultMap id="articleResultMap" type="test.mybatis.entity.Article">
   <id column="id" property="id" jdbcType="VARCHAR" javaType="java.lang.String"/>
   <result column="articleTitle" property="articleTitle" jdbcType="VARCHAR" javaType="java.lang.String"/>
  <result column="articleContent" property="articleContent" jdbcType="VARCHAR" javaType="java.lang.String"/>
 </resultMap>
```

同时，在article对应的xml有这样的select语句：

```xml
<select id="selectArticleByUserId"
parameterType="java.lang.String"
resultMap="ArticleResultMap" >
    select * from
    tb_article where userId=#{userId} 
</select>
```



### 1.2 集合-collection

一对多，collection，理解了一对一，一对多容易理解。

实体类增加对应属性

```java
  private String id;//主键
   private String userName;//用户姓名
   private List<Article> articleList;
```

userMapper.xml这样配置

```xml
<resultMap id="userResultMap" type="test.mybatis.entity.User">
  <id column="id" property="id" jdbcType="VARCHAR" javaType="java.lang.String"/>
  <result column="userName" property="userName" jdbcType="VARCHAR" javaType="java.lang.String"/>
//这里把user的id传过去
   <collection property="articleList" column="id"                       
            select="test.mybatis.dao.articleMapper.selectArticleListByUserId" />
 </resultMap>
以下省略，类同，Mybatis会把结果封装成List类型。
```

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

三、如果我还想通过Article表另一张表，比如文章中有个fk_id，也可以像上面这样重复配置，把fk_id当做与另一张表关联的参数，那时就可以通过用户查到文章，查到文章关联的另一张表了。

### 1.3 association与collection一起使用

*在两者一起使用的情况下，则需要注意如果association与collection是分配一对多关系，则不能使用association，而是使用下面的模式*

```xml
<resultMap id="mbkGjzdzkVOResultForList" type="com.winning.mbk.model.vo.MbkGjzdzkVO">
        <result column="ID" property="id" jdbcType="VARCHAR" />
        <result column="YYDM" property="yydm" jdbcType="VARCHAR" />
        <result column="YYMC" property="yymc" jdbcType="VARCHAR" />
        <result column="FJMC" property="fjmc" jdbcType="VARCHAR" />
        <result column="YYMCSX" property="yymcsx" jdbcType="VARCHAR" />
        <result column="PY" property="py" jdbcType="VARCHAR" />
        <result column="WB" property="wb" jdbcType="VARCHAR" />
        <result column="YYDQ" property="yydq" jdbcType="VARCHAR" />
        <result column="PDM" property="pdm" jdbcType="VARCHAR" />
        <result column="CDM" property="cdm" jdbcType="VARCHAR" />
        <result column="DDM" property="ddm" jdbcType="VARCHAR" />
        <result column="YYXZ" property="yyxz" jdbcType="VARCHAR" />
        <result column="YYDJ" property="yydj" jdbcType="VARCHAR" />
        <result column="YYDJMX" property="yydjmx" jdbcType="VARCHAR" />
        <result column="SGF" property="sgf" jdbcType="VARCHAR" />
        <result column="GFLB" property="gflb" jdbcType="INTEGER" />
        <result column="BZ" property="bz" jdbcType="OTHER" />
        <result column="DZBLXM" property="dzblxm" jdbcType="VARCHAR" />
        <result column="HLBLXM" property="hlblxm" jdbcType="VARCHAR" />
        <result column="TJYH" property="tjyh" jdbcType="INTEGER" />
        <result column="BGKH" property="bgkh" jdbcType="INTEGER" />
        <result column="HYBZ" property="hybz" jdbcType="INTEGER" />
        <result column="SGFDZWDLJ" property="sgfdzwdlj" jdbcType="VARCHAR" />
        <result column="CREATE_TIME" property="createTime" jdbcType="TIMESTAMP" />
        <result column="YXJL" property="yxjl" jdbcType="INTEGER" />
        <result column="IS_HOSPITAL" property="isHospital" jdbcType="INTEGER" />
        <result column="YYXZDM" property="yyxzdm" jdbcType="VARCHAR" />
        <result column="YYDJDM" property="yydjdm" jdbcType="VARCHAR" />
        <collection property="voList"  ofType="com.winning.mbk.model.MbkBzksk">
            <result column="KSID" property="id" jdbcType="VARCHAR" />
            <result column="KSDM" property="ksdm" jdbcType="VARCHAR" />
            <result column="KSMC" property="ksmc" jdbcType="VARCHAR" />
            <result column="SJDM" property="sjdm" jdbcType="VARCHAR" />
            <result column="SJMC" property="sjmc" jdbcType="VARCHAR" />
            <result column="KSYXJL" property="yxjl" jdbcType="INTEGER" />
            <result column="MEMO" property="memo" jdbcType="VARCHAR" />
            <result column="CREATETIME" property="createTime" jdbcType="TIMESTAMP" />
        </collection>
    </resultMap>
```

但是对于association和collection分别对应的一对一和一对多的情况，则可以直接使用两者组合

```xml
<resultMap id="mbkGjzdzkVOResultForList" type="com.winning.mbk.model.vo.MbkGjzdzkVO">
      	<result column="NAME" property="name" jdbcType="VARCHAR" />
        <result column="CODE" property="code" jdbcType="VARCHAR" />
        <association property="hosptial" javaType="com.winning.mbk.model.MbkHospital">
            <result column="ID" property="id" jdbcType="VARCHAR" />
            <result column="YYDM" property="yydm" jdbcType="VARCHAR" />
            <result column="YYMC" property="yymc" jdbcType="VARCHAR" />
            <result column="FJMC" property="fjmc" jdbcType="VARCHAR" />
            <result column="YYMCSX" property="yymcsx" jdbcType="VARCHAR" />
            <result column="PY" property="py" jdbcType="VARCHAR" />
            <result column="WB" property="wb" jdbcType="VARCHAR" />
            <result column="YYDQ" property="yydq" jdbcType="VARCHAR" />
            <result column="PDM" property="pdm" jdbcType="VARCHAR" />
            <result column="CDM" property="cdm" jdbcType="VARCHAR" />
            <result column="DDM" property="ddm" jdbcType="VARCHAR" />
            <result column="YYXZ" property="yyxz" jdbcType="VARCHAR" />
            <result column="YYDJ" property="yydj" jdbcType="VARCHAR" />
            <result column="YYDJMX" property="yydjmx" jdbcType="VARCHAR" />
            <result column="SGF" property="sgf" jdbcType="VARCHAR" />
            <result column="GFLB" property="gflb" jdbcType="INTEGER" />
            <result column="BZ" property="bz" jdbcType="OTHER" />
            <result column="DZBLXM" property="dzblxm" jdbcType="VARCHAR" />
            <result column="HLBLXM" property="hlblxm" jdbcType="VARCHAR" />
            <result column="TJYH" property="tjyh" jdbcType="INTEGER" />
            <result column="BGKH" property="bgkh" jdbcType="INTEGER" />
            <result column="HYBZ" property="hybz" jdbcType="INTEGER" />
            <result column="SGFDZWDLJ" property="sgfdzwdlj" jdbcType="VARCHAR" />
            <result column="CREATE_TIME" property="createTime" jdbcType="TIMESTAMP" />
            <result column="YXJL" property="yxjl" jdbcType="INTEGER" />
            <result column="IS_HOSPITAL" property="isHospital" jdbcType="INTEGER" />
            <result column="YYXZDM" property="yyxzdm" jdbcType="VARCHAR" />
            <result column="YYDJDM" property="yydjdm" jdbcType="VARCHAR" />
    	</association>    
        <collection property="voList"  ofType="com.winning.mbk.model.MbkBzksk">
            <result column="KSID" property="id" jdbcType="VARCHAR" />
            <result column="KSDM" property="ksdm" jdbcType="VARCHAR" />
            <result column="KSMC" property="ksmc" jdbcType="VARCHAR" />
            <result column="SJDM" property="sjdm" jdbcType="VARCHAR" />
            <result column="SJMC" property="sjmc" jdbcType="VARCHAR" />
            <result column="KSYXJL" property="yxjl" jdbcType="INTEGER" />
            <result column="MEMO" property="memo" jdbcType="VARCHAR" />
            <result column="CREATETIME" property="createTime" jdbcType="TIMESTAMP" />
        </collection>
    </resultMap>
```

### 1.4 总结

*对象下面嵌套的对象采用`<association>`写法，嵌套的集合采用`<collection>`写法*

使用方案：

1. 其中`projectInfo`与`projectCharge`对象为`Project`的嵌套对象，采用`<association>`写法，而`requires`是`list`集合，采用`<collection>`写法

   ```xml
   <resultMap type="com.utry.ucsc.task.vo.Project" id="ProjectDetailResultMap">
       <association property="projectInfo" javaType="com.utry.ucsc.task.vo.ProjectInfo">
          <result column="id" jdbcType="VARCHAR" property="projectId" />
          <result column="version" jdbcType="INTEGER" property="version" />
          <result column="project_name" jdbcType="VARCHAR" property="projectName" />
          <result column="project_type" jdbcType="VARCHAR" property="projectType" />
          <result column="description" jdbcType="VARCHAR" property="description" />
          <result column="project_status" jdbcType="VARCHAR" property="projectStatus" />
          <result column="payment_status" jdbcType="VARCHAR" property="paymentStatus" />
          <result column="start_date" jdbcType="TIMESTAMP" property="startDate" />
          <result column="end_date" jdbcType="TIMESTAMP" property="endDate" />
          <result column="workbench_name" jdbcType="VARCHAR" property="workbenchName" />
          <result column="project_logo" jdbcType="VARCHAR" property="projectLogo" />
          <result column="project_display_level" jdbcType="VARCHAR" property="projectDisplayLevel" />
          <result column="task_total" jdbcType="INTEGER" property="taskTotal" />
          <result column="max_task_once" jdbcType="INTEGER" property="maxTaskOnce" />
          <result column="accepted_task_count" jdbcType="INTEGER" property="acceptedTaskCount" />
          <result column="completed_task_count" jdbcType="INTEGER" property="completedTaskCount" />
          <result column="company_id" jdbcType="VARCHAR" property="companyId" />
          <result column="creator" jdbcType="VARCHAR" property="creator" />
          <result column="create_date" jdbcType="TIMESTAMP" property="createDate" />
          <result column="modified_date" jdbcType="TIMESTAMP" property="modifiedDate" />
       </association>
       <association property="projectCharge" javaType="com.utry.ucsc.task.vo.ProjectCharge">
         <result column="charge_type" jdbcType="VARCHAR" property="chargeType" />
         <result column="unit_price" jdbcType="DECIMAL" property="unitPrice" />
         <result column="extract_price" jdbcType="DECIMAL" property="extractPrice" />
       </association>
       <collection property="requires" resultMap="ProjectRequireResultMap"/>
     </resultMap>
     <resultMap type="com.utry.ucsc.task.vo.ProjectRequirement" id="ProjectRequireResultMap">
       <result column="require_type" jdbcType="VARCHAR" property="requireType" />
       <result column="require_value" jdbcType="VARCHAR" property="requireValue" />
     </resultMap>
   ```

   

2. `<association>`写法不变，`<collection>`中采用`ofType`属性指向集合中的元素类型

   ```xml
   <resultMap type="com.utry.ucsc.task.vo.Project" id="ProjectDetailResultMap">
       <association property="projectInfo" javaType="com.utry.ucsc.task.vo.ProjectInfo">
          <result column="projectId" jdbcType="VARCHAR" property="projectId" />
          <result column="version" jdbcType="INTEGER" property="version" />
          <result column="project_name" jdbcType="VARCHAR" property="projectName" />
          <result column="project_type" jdbcType="VARCHAR" property="projectType" />
          <result column="description" jdbcType="VARCHAR" property="description" />
          <result column="project_status" jdbcType="VARCHAR" property="projectStatus" />
          <result column="payment_status" jdbcType="VARCHAR" property="paymentStatus" />
          <result column="start_date" jdbcType="TIMESTAMP" property="startDate" />
          <result column="end_date" jdbcType="TIMESTAMP" property="endDate" />
          <result column="workbench_name" jdbcType="VARCHAR" property="workbenchName" />
          <result column="project_logo" jdbcType="VARCHAR" property="projectLogo" />
          <result column="project_display_level" jdbcType="VARCHAR" property="projectDisplayLevel" />
          <result column="task_total" jdbcType="INTEGER" property="taskTotal" />
          <result column="max_task_once" jdbcType="INTEGER" property="maxTaskOnce" />
          <result column="accepted_task_count" jdbcType="INTEGER" property="acceptedTaskCount" />
          <result column="completed_task_count" jdbcType="INTEGER" property="completedTaskCount" />
          <result column="company_id" jdbcType="VARCHAR" property="companyId" />
          <result column="creator" jdbcType="VARCHAR" property="creator" />
          <result column="create_date" jdbcType="TIMESTAMP" property="createDate" />
          <result column="modified_date" jdbcType="TIMESTAMP" property="modifiedDate" />
       </association>
       <association property="projectCharge" javaType="com.utry.ucsc.task.vo.ProjectCharge">
         <result column="charge_type" jdbcType="VARCHAR" property="chargeType" />
         <result column="unit_price" jdbcType="DECIMAL" property="unitPrice" />
         <result column="extract_price" jdbcType="DECIMAL" property="extractPrice" />
       </association>
       <collection property="requires" ofType="com.utry.ucsc.task.vo.ProjectRequirement">
         <result column="require_type" jdbcType="VARCHAR" property="requireType" />
         <result column="require_value" jdbcType="VARCHAR" property="requireValue" />
       </collection>
     </resultMap>
   ```

   

3. `projectInfo`与`projectCharge`对象仍然采用`<association>`写法，`requires`采用内部嵌套查询方式

   ```xml
   <resultMap type="com.utry.ucsc.task.vo.Project" id="ProjectDetailResultMap">
       <association property="projectInfo" javaType="com.utry.ucsc.task.vo.ProjectInfo">
          <result column="projectId" jdbcType="VARCHAR" property="projectId" />
          <result column="version" jdbcType="INTEGER" property="version" />
          <result column="project_name" jdbcType="VARCHAR" property="projectName" />
          <result column="project_type" jdbcType="VARCHAR" property="projectType" />
          <result column="description" jdbcType="VARCHAR" property="description" />
          <result column="project_status" jdbcType="VARCHAR" property="projectStatus" />
          <result column="payment_status" jdbcType="VARCHAR" property="paymentStatus" />
          <result column="start_date" jdbcType="TIMESTAMP" property="startDate" />
          <result column="end_date" jdbcType="TIMESTAMP" property="endDate" />
          <result column="workbench_name" jdbcType="VARCHAR" property="workbenchName" />
          <result column="project_logo" jdbcType="VARCHAR" property="projectLogo" />
          <result column="project_display_level" jdbcType="VARCHAR" property="projectDisplayLevel" />
          <result column="task_total" jdbcType="INTEGER" property="taskTotal" />
          <result column="max_task_once" jdbcType="INTEGER" property="maxTaskOnce" />
          <result column="accepted_task_count" jdbcType="INTEGER" property="acceptedTaskCount" />
          <result column="completed_task_count" jdbcType="INTEGER" property="completedTaskCount" />
          <result column="company_id" jdbcType="VARCHAR" property="companyId" />
          <result column="creator" jdbcType="VARCHAR" property="creator" />
          <result column="create_date" jdbcType="TIMESTAMP" property="createDate" />
          <result column="modified_date" jdbcType="TIMESTAMP" property="modifiedDate" />
       </association>
       <association property="projectCharge" javaType="com.utry.ucsc.task.vo.ProjectCharge">
         <result column="charge_type" jdbcType="VARCHAR" property="chargeType" />
         <result column="unit_price" jdbcType="DECIMAL" property="unitPrice" />
         <result column="extract_price" jdbcType="DECIMAL" property="extractPrice" />
       </association>
       <collection property="requires" ofType="com.utry.ucsc.task.vo.ProjectRequirement"
         select="com.utry.ucsc.task.dao.ProjectInfoBeanMapper.getProjectRequire" column="{projectId=projectId,version=version}">
       </collection>
     </resultMap>
     <resultMap type="com.utry.ucsc.task.vo.ProjectRequirement" id="RequiresResultMap">
       <result column="require_type" jdbcType="VARCHAR" property="requireType" />
       <result column="require_value" jdbcType="VARCHAR" property="requireValue" />
     </resultMap>
   ```

   这里嵌套的查询getProjectRequire查询中parameterType采用Map，<collection>标签中的column多个参数写法也需按照上述规范，=左边的是getProjectRequire这个方法中的入参名称，==右边是getProjectDetail这个查询方法中的查询出来对应的字段名称。另外，结果集<resultMap>中各个标签顺序也是有规定的:(constructor?, id*, result*, association*, collection*, discriminator?)，不按照这个规定，编译会报错

4. 对比

   通过日志打印sql发现，其中第一种和第二种写法都只查询了一次sql，第三种查询了两次sql，但是用的是一个sql连接，并不是新建一个sql连接，所以性能上差别不大，但是第三种写法明显复杂不少，推荐第一种和第二种写法。

   