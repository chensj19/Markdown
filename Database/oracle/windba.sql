-- ����temp��ռ�
CREATE TEMPORARY TABLESPACE orcl_temp TEMPFILE '/data/oracle/oradata/orcl/orcl_temp.dbf' SIZE  32m AUTOEXTEND ON NEXT  32m MAXSIZE  UNLIMITED  EXTENT MANAGEMENT LOCAL;
-- �������ݱ�ռ�
CREATE TABLESPACE orcl_data LOGGING DATAFILE '/data/oracle/oradata/orcl/orcl_data.dbf' SIZE 32m AUTOEXTEND ON NEXT  32m MAXSIZE  UNLIMITED  EXTENT MANAGEMENT LOCAL;
-- �����û�
CREATE USER WINDBA IDENTIFIED BY WINDBA ACCOUNT UNLOCK DEFAULT TABLESPACE orcl_data TEMPORARY TABLESPACE orcl_temp;
-- ��Ȩ
grant connect,resource,dba to WINDBA;
-- �����û���¼
grant create session to WINDBA;
-- ������Դ
grant connect,resource,dba to WINDBA;
-- �����ֵ��Ȩ��
grant select any  dictionary to WINDBA;
-- ��Ȩ tablespace users
alter user WINDBA quota unlimited on orcl_data;
-- �޸��α����
alter system set open_cursors=10000;
-- �ύ
commit;
