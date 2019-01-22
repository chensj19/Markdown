全文索引都包含三个部分
​    
  * 索引部分
  * 分词部分
    * 将词语进行分词
  * 搜索部分
* 项目搭建

  ```xml
  <dependency>
       <groupId>org.apache.lucene</groupId>
       <artifactId>lucene-core</artifactId>
       <version>3.5.0</version>
  </dependency>
  ```


* 创建索引
```java
    public void index() {
        Directory directory = null;
        IndexWriter writer = null;
        try {
            // 1 创建Directory 内存索引
            // Directory directory = new RAMDirectory();
            directory = FSDirectory.open(new File("/home/chensj/index01"));
            // 2 创建IndexWriter
            // 分词器
            StandardAnalyzer analyzer = new StandardAnalyzer(Version.LUCENE_35);
            // IndexWriter config
            IndexWriterConfig config = new IndexWriterConfig(Version.LUCENE_35,analyzer);
            writer = new IndexWriter(directory,config);
            // 3 创建Document对象
            Document doc = null;
            File file = new File("/home/chensj/sql");
            // 4 为Document添加Field
            for (File f : file.listFiles()) {
                doc = new Document();
                doc.add(new Field("content",new FileReader(f)));
                doc.add(new Field("filename",f.getName(),Field.Store.YES,Field.Index.NOT_ANALYZED));
                doc.add(new Field("path",f.getAbsolutePath(),Field.Store.YES,Field.Index.NOT_ANALYZED));
                // 5 通过IndexWriter 添加文档到索引中
                writer.addDocument(doc);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }finally {
            if(writer != null){
                try {
                    writer.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }

    }
```
* 创建查询
```java

public void search(){

        Directory directory = null;
        try {
            // 1 创建Directory
           directory =  FSDirectory.open(new File("/home/chensj/index01"));
            // 2 创建IndexReader
            IndexReader reader = IndexReader.open(directory);
            // 3 根据IndexReader创建IndexSearch
            IndexSearcher searcher = new IndexSearcher(reader);
            // 4 创建搜索Query
            // 创建parser来确定搜索文件的内容， 第二个表示搜索的域
            QueryParser parser = new QueryParser(Version.LUCENE_35,"content",new StandardAnalyzer(Version.LUCENE_35));
            // 搜索域在content中包含sql的文档
            Query query = parser.parse("java");
            // 5 根据searcher搜索并返回TopDocs
            // 10 为搜索的条数
            TopDocs tds = searcher.search(query,10);
            // 6 根据TopDocs获取ScoreDoc对象
            ScoreDoc[] sds = tds.scoreDocs;
            for (ScoreDoc sd : sds) {
                // 7 根据earcher和ScoreDoc对象获取Document
                Document document  = searcher.doc(sd.doc);
                // 8 根据Document对象获取需要的值
                System.out.println(document.get("filename")+"[" + document.get("path")+"]");
            }
         // 9 关闭reader
         reader.close();
        } catch (IOException e) {
            e.printStackTrace();
        } catch (ParseException e) {
            e.printStackTrace();
        }
    }
​```
```

> 上述这种创建索引的方式是增量创建索引的模式