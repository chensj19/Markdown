--1���鿴��ռ�����Ƽ���С
SELECT t.tablespace_name, round(SUM(bytes / (1024 * 1024)), 0) ts_size
FROM dba_tablespaces t, dba_data_files d
WHERE t.tablespace_name = d.tablespace_name
GROUP BY t.tablespace_name;
--2���鿴��ռ������ļ������Ƽ���С
SELECT tablespace_name,
file_id,
file_name,
round(bytes / (1024 * 1024), 0) total_space
FROM dba_data_files
ORDER BY tablespace_name;
--3���鿴�ع������Ƽ���С
SELECT segment_name,
tablespace_name,
r.status,
(initial_extent / 1024) initialextent,
(next_extent / 1024) nextextent,
max_extents,
v.curext curextent
FROM dba_rollback_segs r, v$rollstat v
WHERE r.segment_id = v.usn(+)
ORDER BY segment_name;
--4���鿴�����ļ�
SELECT NAME FROM v$controlfile;
--5���鿴��־�ļ�
SELECT MEMBER FROM v$logfile;
--6���鿴��ռ��ʹ�����
SELECT SUM(bytes) / (1024 * 1024) AS free_space, tablespace_name
FROM dba_free_space
GROUP BY tablespace_name;
SELECT a.tablespace_name,
a.bytes total,
b.bytes used,
c.bytes free,
(b.bytes * 100) / a.bytes "% USED ",
(c.bytes * 100) / a.bytes "% FREE "
FROM sys.sm$ts_avail a, sys.sm$ts_used b, sys.sm$ts_free c
WHERE a.tablespace_name = b.tablespace_name
AND a.tablespace_name = c.tablespace_name;
--7���鿴���ݿ�����
SELECT owner, object_type, status, COUNT(*) count#
FROM all_objects
GROUP BY owner, object_type, status;
--8���鿴���ݿ�İ汾��
SELECT version
FROM product_component_version
WHERE substr(product, 1, 6) = 'Oracle';
--9���鿴���ݿ�Ĵ������ں͹鵵��ʽ
SELECT name,created, log_mode, log_mode FROM v$database;
--1G=1024MB
--1M=1024KB
--1K=1024Bytes
--1M=11048576Bytes
--1G=1024*11048576Bytes=11313741824Bytes
-- 10���鿴��ռ�ʹ�����
SELECT a.tablespace_name tablespace_name,
total tablespace_total_size,
free tablespace_free_size,
(total - free) tablespace_used_size,
total / (1024 * 1024 * 1024) tablespace_total_gb,
free / (1024 * 1024 * 1024) tablespace_free_gb,
(total - free) / (1024 * 1024 * 1024) tablespace_used_gb,
round((total - free) / total, 4) * 100 tablespace_percent 
FROM (SELECT tablespace_name, SUM(bytes) free
FROM dba_free_space
GROUP BY tablespace_name) a,
(SELECT tablespace_name, SUM(bytes) total
FROM dba_data_files a
GROUP BY tablespace_name) b
WHERE a.tablespace_name = b.tablespace_name 
