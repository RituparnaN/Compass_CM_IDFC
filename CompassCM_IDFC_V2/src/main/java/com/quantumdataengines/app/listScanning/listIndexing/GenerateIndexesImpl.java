package com.quantumdataengines.app.listScanning.listIndexing;

import java.io.File;
import java.io.IOException;

import org.apache.lucene.analysis.Analyzer;
import org.apache.lucene.analysis.standard.StandardAnalyzer;
import org.apache.lucene.index.IndexWriter;
import org.apache.lucene.index.IndexWriterConfig;
import org.apache.lucene.store.FSDirectory;
import org.apache.lucene.util.Version;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.quantumdataengines.app.compass.util.CommonUtil;
import com.quantumdataengines.app.listScanning.castExceptions.CreateIndexError;
import com.quantumdataengines.app.listScanning.castExceptions.IOAccessError;
import com.quantumdataengines.app.listScanning.castExceptions.SourceNotFoundError;
import com.quantumdataengines.app.listScanning.dataInfoReaders.main.ListReader;
// import com.quantumdataengines.utilities.ApplicationProperties;

 public class GenerateIndexesImpl implements GenerateIndexes
 {

	 private static final Logger log = LoggerFactory.getLogger(GenerateIndexesImpl.class);
    public GenerateIndexesImpl()
    {
    l_objDocGenerator = null;
    l_objDocGenerator = new DocGenerator();
    l_objIndexWriter = null;
    }

    public void createListIndexing(ListReader objListReader, String strListName) throws CreateIndexError, IOAccessError, SourceNotFoundError, IllegalArgumentException
    {
    try
    {
    Analyzer analyzer = new StandardAnalyzer(Version.LUCENE_47);
    IndexWriterConfig indexWriterConfig = new IndexWriterConfig(Version.LUCENE_47, analyzer);
    indexWriterConfig.setOpenMode(org.apache.lucene.index.IndexWriterConfig.OpenMode.CREATE_OR_APPEND);
    //indexWriterConfig.setOpenMode(org.apache.lucene.index.IndexWriterConfig.OpenMode.CREATE);
    //File indexFile = new File((new StringBuilder("index/")).append(strListName).toString());
    /* 21st Oct 2016 */
    // String strListIndexDirectoryPath = ApplicationProperties.getInstance().getProperty("ListDirectoryPath").trim();
    // File indexFile = new File((new StringBuilder("D:\\IndexFolder\\")).append(strListName).toString());
    String indexFolder = CommonUtil.loadProperties().getProperty("compass.aml.paths.indexFolder");
    File indexFile = new File((new StringBuilder(indexFolder)).append(strListName).toString());
    // File indexFile = new File((new StringBuilder(strListIndexDirectoryPath)).append(strListName).toString());
    /* 21st Oct 2016 */
    if(objListReader == null || strListName == null)
        throw new IllegalArgumentException(" Argument can not be null ");
    try {
    org.apache.lucene.store.Directory l_Directory = FSDirectory.open(indexFile);
    l_objIndexWriter = new IndexWriter(l_Directory, indexWriterConfig);
    }
    catch(IOException ioe) {
	indexFile.mkdir();
    org.apache.lucene.store.Directory l_Directory = FSDirectory.open(indexFile);
    l_objIndexWriter = new IndexWriter(l_Directory, indexWriterConfig);
    }
    l_objDocGenerator.docToGenerate(objListReader, l_objIndexWriter, strListName);
    l_objIndexWriter.close();
    }
    catch(IOException e) {
    	log.error("Error in GenerateIndexesImpl -> createListIndexing : "+e.toString());
	System.out.println("Error in GenerateIndexesImpl -> createListIndexing : "+e.toString());
	e.printStackTrace();
    throw new CreateIndexError("Creating index files ", e);
    }
    }

    public void createIndexingWithFolder(ListReader objListReader, String strListName, String strListPath, String strListIndexPath) throws CreateIndexError, IOAccessError, SourceNotFoundError, IllegalArgumentException
    {
    try
    {
    String l_strListPath1 = "";
    String l_ListIndexPath = strListIndexPath;
    if(l_ListIndexPath != null)
    	l_strListPath1 = (new StringBuilder(String.valueOf(l_ListIndexPath))).append(strListPath).toString();
    else
    	l_strListPath1 = strListPath;
    Analyzer analyzer = new StandardAnalyzer(Version.LUCENE_47);
    IndexWriterConfig indexWriterConfig = new IndexWriterConfig(Version.LUCENE_47, analyzer);
    File indexFile = new File(l_strListPath1);
    if(objListReader == null || strListName == null || l_strListPath1 == null)
        throw new IllegalArgumentException(" Argument can not be null ");
    try
    {
    org.apache.lucene.store.Directory l_Directory = FSDirectory.open(indexFile);
    l_objIndexWriter = new IndexWriter(l_Directory, indexWriterConfig);
    }
    catch(IOException ioexception)
    {
	indexFile.mkdir();
    org.apache.lucene.store.Directory l_Directory = FSDirectory.open(indexFile);
    l_objIndexWriter = new IndexWriter(l_Directory, indexWriterConfig);
    log.error("Error in GenerateIndexesImpl -> createIndexingWithFolder : "+ioexception.toString());
	System.out.println("Error in GenerateIndexesImpl -> createIndexingWithFolder : "+ioexception.toString());
	ioexception.printStackTrace();
    }
    l_objDocGenerator.docToGenerate(objListReader, l_objIndexWriter, strListName);
    l_objIndexWriter.close();
    }
    catch(IOException ioexception1)
    {
    	log.error("Error in GenerateIndexesImpl -> createIndexingWithFolder : "+ioexception1.toString());
	System.out.println("Error in GenerateIndexesImpl -> createIndexingWithFolder : "+ioexception1.toString());
	ioexception1.printStackTrace();
    throw new CreateIndexError("Creating index files ", ioexception1);
    }
    }
    public boolean hasIndexingDone()
    {
        return l_objDocGenerator.hasIndexingDone();
    }
    public int countOfIndexedRecords()
    {
        return l_objDocGenerator.countOfIndexedRecords();
    }
    private IndexWriter l_objIndexWriter;
    private DocGenerator l_objDocGenerator;
}