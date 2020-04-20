# java常用代码

## 下载
### 单个文件下载
```java
        try {
            byte[] bytes = null;
            if (!StringUtils.isEmpty(name)) {
                bytes = FtpUtils.downloadFileAsByte(name, FTP_PRACTICE_PDF_PATH);
                //获取响应输出流
                OutputStream outputStream = new BufferedOutputStream(response.getOutputStream());
                // 设置response的Header
                response.setContentType("multipart/form-data;charset=UTF-8");
                response.addHeader("Content-Disposition", "attachment;filename=".concat(String.valueOf(URLEncoder.encode(name, "UTF-8"))));
                outputStream.write(bytes);
                outputStream.flush();
                outputStream.close();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
```

### 批量文件下载
```java
        // 获取数据校验信息
        List<EtEasyDataCheck> etEasyDataChecks = getFacade().getEtEasyDataCheckService().getEtEasyDataCheckList(easyDataCheck);
        for (int i = 0; i < etEasyDataChecks.size(); i++) {
            EtEasyDataCheck etEasyDataCheck = etEasyDataChecks.get(i);
            //获取
            SysDataCheckScript temp = new SysDataCheckScript();
            Long sourceId = etEasyDataCheck.getSourceId();
            if (sourceId == null) {
                return;
            }
            temp.setId(sourceId);
            SysDataCheckScript sysDataCheckScript = getFacade().getSysDataCheckScriptService().getSysDataCheckScript(temp);
            if (sysDataCheckScript == null) {
                return;
            }
            //获取脚本地址
            String scriptPath = sysDataCheckScript.getRemotePath();
            if (StringUtil.isEmptyOrNull(scriptPath)) {
                return;
            }
            //获取文件名
            String filename = scriptPath.substring(scriptPath.lastIndexOf("/") + 1);
//            String saveFile = "/sql/" + filename.substring(0, filename.indexOf(".")) + "_" + i + "." + filename.substring(filename.indexOf(".") + 1);
            String ftpPath = scriptPath.replace(filename, "");
//            File file = null;
            List byteList = new ArrayList();
            byteList.add(0, filename);
            try {
                byte[] fileByte = CommonFtpUtils.downloadFileAsByte(filename, ftpPath);
                byteList.add(1, fileByte);
                fileByteList.add(byteList);
            } catch (Exception e) {
                e.printStackTrace();
            }

        }
        //压缩输出流
        response.setContentType("application/zip");
        response.setCharacterEncoding("utf-8");
        //这里需要针对打出的压缩包名称的编码格式进行乱码处理：new String(("压缩包名称").getBytes("GBK"), "iso8859-1")
        response.setHeader("Content-Disposition", "attachment; filename=\""
                + new String((new SimpleDateFormat("yyyyMMddHHmmss").format(new Date()) + ".zip").getBytes("GBK"), "iso8859-1") + "\"");
        BufferedOutputStream buff = null;
        OutputStream outStr = null;
        outStr = response.getOutputStream();
        ZipOutputStream zipOutputStream = new ZipOutputStream(new BufferedOutputStream(outStr));
        int len = 0;
        FileInputStream fileInputStream = null;
        String fileName = null;
        //循环打包到输出流
        for (List currentList : fileByteList) {
            fileName = (String) currentList.get(0);
            byte[] buf = (byte[]) currentList.get(1);
            //放入压缩zip包中;
            zipOutputStream.putNextEntry(new ZipEntry(fileName));

            //读取文件;
            zipOutputStream.write(buf);

            //关闭;
            zipOutputStream.closeEntry();
            if (fileInputStream != null) {
                fileInputStream.close();

            }
        }
        zipOutputStream.flush();
        zipOutputStream.close();
```