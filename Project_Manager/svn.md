# SVN命令

```bash
count=`svn status|grep ! |wc -l` ; if test $count -gt  0 ; then svn status|grep ! |awk '{print $2}'|xargs svn delete; fi
count=`svn status|grep ? |wc -l` ; if test $count -gt  0 ; then svn status|grep ? |awk '{print $2}'|xargs svn add; fi
```

