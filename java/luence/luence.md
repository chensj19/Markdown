# Luence

## 1、工作流程

![Luence工作流程](https://img-blog.csdn.net/20170103091620316?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvcm9uYWxvZA==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

全文索引都包含三个部分

  * 索引部分

  * 分词部分

    * 将词语进行分词

  * 搜索部分

### 1.1 项目搭建

    ```xml
    <dependency>
         <groupId>org.apache.lucene</groupId>
         <artifactId>lucene-core</artifactId>
         <version>3.5.0</version>
    </dependency>
    ```
### 1.2  创建索引
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
### 1.3  创建查询
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

### 1.4 索引原理

​	全文检索技术[由来已久](https://www.baidu.com/s?wd=%E7%94%B1%E6%9D%A5%E5%B7%B2%E4%B9%85&tn=24004469_oem_dg&rsv_dl=gh_pl_sl_csd)，绝大多数都基于倒排索引来做，曾经也有过一些其他方案如文件指纹。倒排索引，[顾名思义](https://www.baidu.com/s?wd=%E9%A1%BE%E5%90%8D%E6%80%9D%E4%B9%89&tn=24004469_oem_dg&rsv_dl=gh_pl_sl_csd)，它相反于一篇文章包含了哪些词，它从词出发，记载了这个词在哪些文档中出现过，由两部分组成——词典和倒排表。

![](https://img-blog.csdn.net/20170103094805234?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvcm9uYWxvZA==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

​	其中词典结构尤为重要，有很多种词典结构，各有各的优缺点，最简单如排序数组，通过二分查找来检索数据，更快的有哈希表，磁盘查找有B树、B+树，但一个能支持TB级数据的倒排索引结构需要在时间和空间上有个平衡，下图列了一些常见词典的优缺点：

![词典优缺点对比](https://img-blog.csdn.net/20170103100752086?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvcm9uYWxvZA==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

其中可用的有：B+树、跳跃表、FST 
　　B+树： 

![](https://img-blog.csdn.net/20170103101508006?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvcm9uYWxvZA==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

> 理论基础：平衡多路查找树
> 优点：外存索引、可更新
> 缺点：空间大、速度不够快

跳跃表： 

![](https://img-blog.csdn.net/20170103103111392?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvcm9uYWxvZA==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)


    优点：结构简单、跳跃间隔、级数可控，Lucene3.0之前使用的也是跳跃表结构，后换成了FST，但跳跃表在Lucene其他地方还有应用如倒排表合并和文档号索引。
    缺点：模糊查询支持不好
　FST 
　　Lucene现在使用的索引结构 

![](https://img-blog.csdn.net/20170103104515602?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvcm9uYWxvZA==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

> 理论基础:   《Direct construction of minimal acyclic subsequential transducers》，通过输入有序字符串构建最小有向无环图。
> 优点：内存占用率低，压缩率一般在3倍~20倍之间、模糊查询支持好、查询快
> 缺点：结构复杂、输入要求有序、更新不易
>
> Lucene里有个FST的实现，从对外接口上看，它跟Map结构很相似，有查找，有迭代：