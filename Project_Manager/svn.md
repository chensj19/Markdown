# SVN命令

```bash
count=`svn status|grep ! |wc -l` ; if test $count -gt  0 ; then svn status|grep ! |awk '{print $2}'|xargs svn delete; fi
count=`svn status|grep ? |wc -l` ; if test $count -gt  0 ; then svn status|grep ? |awk '{print $2}'|xargs svn add; fi

svn co svn://172.16.0.198/AAIO --username  --password  ./
```

svn://admin@172.16.6.175/outpatient/winning-coordinator-plugin-**allinone**





