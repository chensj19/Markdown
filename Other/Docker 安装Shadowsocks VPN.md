@[TOC](Docker ��װShadowsocks VPN)

# ׼������

1.���Է��ʹ�����վ�ķ���������VPS������ʹ�õ��ǰ��߹�VPS��
2.Linuxϵͳ����������߰�װ����Centos7��

# Docker��װ
 1.**��װ Docker**

    yum install docker -y

2.**���� Docker ����**

    service docker start
    chkconfig docker on

3.**��� Docker �汾**

    docker -version

# Docker����װ

���ߺʹ󲿷���������һ����ѡ����Github�ϵ�ShadowSocks VPN Docker������а�װ����װ�������

    docker pull oddrationale/docker-shadowsocks

# ����Docker����

    docker run -d -p 19929:19929 oddrationale/docker-shadowsocks -s 0.0.0.0 -p 19929 -k laosiji-m aes-256-cfb
>-d�������� Docker ��פ��̨����
-p��ָ��Ҫӳ��Ķ˿ڣ�����˿ں�ͳһ����һ�¼��ɡ����磺19929
-s������ IP ��ַ�����øĶ�
-k����������� VPN �����룬���磺laosiji
-mָ�����ܷ�ʽ��aes-256-cfb��
    
ִ����ɺ�鿴�����Ƿ񴴽��ɹ�������

    docker ps -a

# ����ǽ�˿�����
>1.�ļ�λ��
>`/etc/sysconfig/iptables`
>2.������
>`-A INPUT -p tcp -m tcp --dport 19929 -j ACCEPT`
>3.��������
>`service iptables restart`

�����vi�����鷳��1��2���������Ժϲ�Ϊ��

    iptables -I INPUT -p tcp --dport 19929 -j ACCEPT

# ShadowSocks �ͻ���
�ص����ˣ����ϵ���Դ�ܶ඼����г�ˣ�����ͦ���ҵġ��������Ҽ�(dao)��(chu)��(qiu)и(ren)�£����Ǹ㵽�ˡ��������õĺ����ҾͲ���׸�������������˽��¡������������£�
![���������ͼƬ����](https://img-blog.csdnimg.cn/2018112315004876.jpg?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2NmNzk4NjE1OTQ2,size_16,color_FFFFFF,t_70)
�����ǰٶ������������ӣ�
���ӣ�https://pan.baidu.com/s/1YyQmy0Xw539_pVaU8pwFVQ 
���룺c43e