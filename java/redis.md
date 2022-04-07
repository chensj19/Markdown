## redis long

```java
// 做个强制类型转换，解决redis中加载Long类型问题
List<Long> ps = Lists.newArrayList();
for (Object permission : permissions) {
	Long p = null;
  if (permission instanceof Integer) {
      p = ((Integer) permission).longValue();
      ps.add(p);
  } else if (permission instanceof Long) {
      p = (Long) permission;
      ps.add(p);
  }
}	
```

