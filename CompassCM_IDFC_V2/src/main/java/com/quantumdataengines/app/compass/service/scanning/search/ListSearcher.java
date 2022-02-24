package com.quantumdataengines.app.compass.service.scanning.search;

import com.quantumdataengines.app.compass.model.scanning.MappedFieldVO;
import com.quantumdataengines.app.compass.model.scanning.SearchListVO;
import com.quantumdataengines.app.compass.util.CommonUtil;
//import com.quantumdataengines.screeningImpl.exceptions.IndexFileNotFoundException;
import com.quantumdataengines.app.listScanning.castExceptions.FileNotFoundError;
//import com.quantumdataengines.screeningImpl.search.*;
import com.quantumdataengines.app.listScanning.listSearch.*;

import java.io.File;
import java.io.IOException;
import java.lang.reflect.Method;
import java.util.*;

//import org.apache.lucene.queryParser.ParseException;
import org.apache.lucene.queryparser.classic.QueryParser;
import org.apache.lucene.queryparser.classic.ParseException;


import org.apache.log4j.Logger;

public class ListSearcher
{
	public ListSearcher(SearchListVO objSearchListVO, Collection colMatchedInfo, HashMap hashMapIndexInfo) throws FileNotFoundError
    {
    l_objFuzzySearcher = null;
    l_objNormalSearcher = null;
    l_strSearchLevelValue = null;
    l_objNormalSearchArray = null;
    l_objFuzzySearchArray = null;
    l_boolFUZZY_PRESENT = false;
    l_boolNORMAL_PRESENT = false;
    l_hashMapIndexFieldVO = null;
    l_strSearchLevelValue = objSearchListVO.getSearchLevel();
    //l_strSearchLevelValue = "Typical";
    l_hashMapIndexFieldVO = hashMapIndexInfo;
    // String strListIndexDirectoryPath = ApplicationProperties.getInstance().getProperty("ListIndexDirectoryPath").trim();
    // String strListIndexDirectoryPath = "C:\\Users\\QuantumDataEngines\\APPFOLDER\\IndexFolder\\";
    //String strListIndexDirectoryPath = "D:\\IndexFolder\\";
    String strListIndexDirectoryPath = CommonUtil.loadProperties().getProperty("compass.aml.paths.indexFolder");
    
    try{
    	
    l_objFuzzySearcher = (ListScreening)Class.forName("com.quantumdataengines.app.listScanning.listSearch.ListScreeningImpl").newInstance();
    Method objMethodArray[] = l_objFuzzySearcher.getClass().getDeclaredMethods();
    for(int i = 0; i < objMethodArray.length; i++)
    {
    if(!objMethodArray[i].getName().equalsIgnoreCase("initListSearcher"))
        continue;
    objMethodArray[i].invoke(l_objFuzzySearcher, new Object[] {
        //(new StringBuilder(String.valueOf(strListIndexDirectoryPath))).append(File.separator).append(a_CSearchListVO.getListCode()).toString(), Integer.valueOf(1), Boolean.valueOf(true)
   		(new StringBuilder(String.valueOf(strListIndexDirectoryPath))).append(objSearchListVO.getListCode()).toString(), Integer.valueOf(1), Boolean.valueOf(true)	
    });
    break;
    }
    l_objNormalSearcher = (ListScreening)Class.forName("com.quantumdataengines.app.listScanning.listSearch.ListScreeningImpl").newInstance();
    objMethodArray = l_objNormalSearcher.getClass().getDeclaredMethods();
    for(int i = 0; i < objMethodArray.length; i++)
    {
    if(!objMethodArray[i].getName().equalsIgnoreCase("initListSearcher"))
        continue;
    objMethodArray[i].invoke(l_objNormalSearcher, new Object[] {
        //(new StringBuilder(String.valueOf(strListIndexDirectoryPath))).append(File.separator).append(a_CSearchListVO.getListCode()).toString(), Integer.valueOf(2), Boolean.valueOf(true)
    	(new StringBuilder(String.valueOf(strListIndexDirectoryPath))).append(objSearchListVO.getListCode()).toString(), Integer.valueOf(2), Boolean.valueOf(true)	
    });
    break;
    }
    }catch(Exception e)
    {
    	e.printStackTrace();
    	System.out.println("Exception Occured "+e.getMessage());
    }
    if(l_hashMapIndexFieldVO != null)
    {
        l_objFuzzySearcher.setListFieldsIndexedInfo(l_hashMapIndexFieldVO);
        l_objNormalSearcher.setListFieldsIndexedInfo(l_hashMapIndexFieldVO);
    }
    if(l_strSearchLevelValue.equalsIgnoreCase("Typical"))
        l_objFuzzySearcher.setListSearchLevel(1);
    else
        if(l_strSearchLevelValue.equalsIgnoreCase("Exhaustive"))
            l_objFuzzySearcher.setListSearchLevel(2);
    else
    if(l_strSearchLevelValue.equalsIgnoreCase("Loose"))
        l_objFuzzySearcher.setListSearchLevel(3);
    categorizeSearchListFields(colMatchedInfo);
    }

    protected void categorizeSearchListFields(Collection collectionMatchFieldInfo)
    {
    Iterator iteratorFieldMap = collectionMatchFieldInfo.iterator();
    ArrayList alNormalSearchListFields = new ArrayList();
    ArrayList alFuzzySearchListFields = new ArrayList();
    while(iteratorFieldMap.hasNext()) 
    {
    MappedFieldVO objMappedFieldVO = (MappedFieldVO)iteratorFieldMap.next();
    if(objMappedFieldVO.getFieldCategory().equals("identity"))
    {
        alNormalSearchListFields.add(objMappedFieldVO);
        l_boolNORMAL_PRESENT = true;
    } else
    {
        alFuzzySearchListFields.add(objMappedFieldVO);
        l_boolFUZZY_PRESENT = true;
    }
    }
    l_objNormalSearchArray = getMappedFieldVOArray(alNormalSearchListFields);
    l_objFuzzySearchArray = getMappedFieldVOArray(alFuzzySearchListFields);
    }
    
    private MappedFieldVO[] getMappedFieldVOArray(Collection collectionMappedFieldVO)
    {
    MappedFieldVO objMappedFieldVOArray[] = new MappedFieldVO[collectionMappedFieldVO.size()];
    Iterator iterator = collectionMappedFieldVO.iterator();
    int l_intIndex = 0;
    while(iterator.hasNext()) 
    	objMappedFieldVOArray[l_intIndex++] = (MappedFieldVO)iterator.next();
    return objMappedFieldVOArray;
    }
    
    private void doFuzzyTypeSearch(HashMap hashMapFieldValue, Vector resultVector) throws ParseException, IOException
    {
    for(int i = 0; i < l_objFuzzySearchArray.length; i++)
    {
    MappedFieldVO objMappedFieldVO = l_objFuzzySearchArray[i];
    String strDataFieldsArray[] = objMappedFieldVO.getDataFields();
    String strSearchString = "";
    for(int j = 0; j < strDataFieldsArray.length; j++)
    	strSearchString = (String)hashMapFieldValue.get(strDataFieldsArray[j]);
    if(strSearchString != null && !strSearchString.equals("") && objMappedFieldVO.isRepeated())
    {
    String strFieldDelimiter = objMappedFieldVO.getDelimiter();
    for(StringTokenizer l_strTokenizer = new StringTokenizer(strSearchString, strFieldDelimiter); l_strTokenizer.hasMoreTokens();)
    {
    String tokenString = l_strTokenizer.nextToken();
    Object objResultArray[] = l_objFuzzySearcher.listSearch(objMappedFieldVO.getMatchField(), tokenString, objMappedFieldVO.getScoreLimit());
    if(objResultArray != null && objResultArray.length > 0)
    {
    for(int j = 0; j < objResultArray.length; j++)
    {
	ScreeningResultVO objScreeningResultVO = (ScreeningResultVO)objResultArray[j];
    objScreeningResultVO.setSourceField(objMappedFieldVO.getSourceField());
    resultVector.add(objScreeningResultVO);
    }
    }
    }
    } else
    if(strSearchString != null && !strSearchString.equals("") && !objMappedFieldVO.getFieldType().equalsIgnoreCase("UniqueKey"))
    {
    Object objResultArray[] = l_objFuzzySearcher.listSearch(objMappedFieldVO.getMatchField(), strSearchString, objMappedFieldVO.getScoreLimit());
    if(objResultArray != null && objResultArray.length > 0)
    {
    for(int j = 0; j < objResultArray.length; j++)
    {
	ScreeningResultVO objScreeningResultVO = (ScreeningResultVO)objResultArray[j];
    objScreeningResultVO.setSourceField(objMappedFieldVO.getSourceField());
    objScreeningResultVO.setSourceData(strSearchString);
    resultVector.add(objScreeningResultVO);
    }
    }
    }
    }
    }
    
    private void doIdentityTypeSearch(HashMap hashMapFieldValue, Vector a_ResVector) throws ParseException, IOException
    {
    for(int i = 0; i < l_objNormalSearchArray.length; i++)
    {
    MappedFieldVO objMappedFieldVO = l_objNormalSearchArray[i];
    String strSearchString = (String)hashMapFieldValue.get(objMappedFieldVO.getSourceField());
    if(strSearchString != null && !strSearchString.equals("") && !objMappedFieldVO.getFieldType().equalsIgnoreCase("UniqueKey"))
    {
    Object objResultArray[] = l_objFuzzySearcher.listSearch(objMappedFieldVO.getMatchField(), strSearchString, objMappedFieldVO.getScoreLimit());
    if(objResultArray != null && objResultArray.length > 0)
    {
    for(int j = 0; j < objResultArray.length; j++)
    {
	ScreeningResultVO objScreeningResultVO = (ScreeningResultVO)objResultArray[j];
    objScreeningResultVO.setSourceField(objMappedFieldVO.getSourceField());
    a_ResVector.add(objScreeningResultVO);
    }
    }
    }
    }
    }

    public Vector listSearch(HashMap hashMapFieldValue) throws ParseException, IOException
    {
	Vector l_ResVector = new Vector();
    if(l_boolNORMAL_PRESENT)
        doIdentityTypeSearch(hashMapFieldValue, l_ResVector);
    if(l_boolFUZZY_PRESENT)
        doFuzzyTypeSearch(hashMapFieldValue, l_ResVector);
    return l_ResVector;
    }

    private ListScreening l_objFuzzySearcher;
    private ListScreening l_objNormalSearcher;
    private String l_strSearchLevelValue;
    private MappedFieldVO l_objNormalSearchArray[];
    private MappedFieldVO l_objFuzzySearchArray[];
    private boolean l_boolFUZZY_PRESENT;
    private boolean l_boolNORMAL_PRESENT;
    private HashMap l_hashMapIndexFieldVO;
}