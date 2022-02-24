package com.quantumdataengines.app.listScanning.listIndexing;

import com.quantumdataengines.app.listScanning.castExceptions.IOAccessError;
import com.quantumdataengines.app.listScanning.castExceptions.SourceNotFoundError;
import com.quantumdataengines.app.listScanning.dataInfoReaders.main.ListReader;
import java.io.IOException;
import java.util.*;

import org.apache.lucene.document.Document;
import org.apache.lucene.document.Field;
import org.apache.lucene.index.IndexWriter;
import org.apache.lucene.index.Term;

public class DocGenerator
{
    public DocGenerator()
    {
        l_objListReader = null;
        l_objDocument = null;
        l_intIndexedCount = 0;
    }
    public void docToGenerate(ListReader objListReader, IndexWriter objIndexWriter, String strListName)
        throws IOAccessError, SourceNotFoundError, IOException
    {
        l_objListReader = objListReader;
        Set setFieldTypesList = l_objListReader.getListFieldTypes();
        l_objListReader.open();
        while(l_objListReader.next()) 
        {
            l_objDocument = new Document();
            //l_objDocument.add(new Field("record", l_objListReader.getListRecord(), org.apache.lucene.document.Field.Store.YES, org.apache.lucene.document.Field.Index.NO));
            l_objDocument.add(new Field("record", "", org.apache.lucene.document.Field.Store.YES, org.apache.lucene.document.Field.Index.NO));
            l_objDocument.add(new Field("id", l_objListReader.getListUniqueId(), org.apache.lucene.document.Field.Store.YES, org.apache.lucene.document.Field.Index.NOT_ANALYZED_NO_NORMS));
            l_objDocument.add(new Field("listname", strListName, org.apache.lucene.document.Field.Store.YES, org.apache.lucene.document.Field.Index.NO));
            for(Iterator iterator = setFieldTypesList.iterator(); iterator.hasNext();)
            {
            String strListFieldType = (String)iterator.next();
            String strArrayFieldNames[] = l_objListReader.getListFields(strListFieldType);
            for(int i = 0; i < strArrayFieldNames.length; i++)
            {
            String strListFieldValue = null ;
            strListFieldValue = l_objListReader.getListFieldValue(strArrayFieldNames[i]);
            //String strListFieldDelimiter = l_objListReader.getFieldDelimiter(strArrayFieldNames[i]);
            //System.out.println("strListFieldDelimiter:  "+strListFieldDelimiter);
            l_objDocument.add(new Field(strArrayFieldNames[i], strListFieldValue, org.apache.lucene.document.Field.Store.YES, org.apache.lucene.document.Field.Index.ANALYZED));
            }
            }
            objIndexWriter.updateDocument(new Term("id", l_objListReader.getListUniqueId()), l_objDocument);
            l_intIndexedCount++;
        }
        l_flagIndexedStatus = true;
    }

    public int countOfIndexedRecords()
    {
        return l_intIndexedCount;
    }

    public boolean hasIndexingDone()
    {
        return l_flagIndexedStatus;
    }

    private ListReader l_objListReader;
    private Document l_objDocument;
    private int l_intIndexedCount;
    private boolean l_flagIndexedStatus;
}