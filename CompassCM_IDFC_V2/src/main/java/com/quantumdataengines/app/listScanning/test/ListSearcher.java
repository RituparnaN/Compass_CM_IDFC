
package com.quantumdataengines.app.listScanning.test;

import java.io.IOException;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.Iterator;
import java.util.StringTokenizer;
import java.util.Vector;


// import org.apache.lucene.queryParser.ParseException;
import org.apache.lucene.queryparser.classic.QueryParser;
import org.apache.lucene.queryparser.classic.ParseException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.quantumdataengines.app.compass.util.CommonUtil;
import com.quantumdataengines.app.listScanning.castExceptions.FileNotFoundError;
import com.quantumdataengines.app.listScanning.listSearch.ListScreening;
import com.quantumdataengines.app.listScanning.listSearch.ScreeningResultVO;
import com.quantumdataengines.app.listScanning.model.FieldMappingVO;
import com.quantumdataengines.app.listScanning.model.ListVO;
// import com.quantumdataengines.utilities.ApplicationProperties;

public class ListSearcher
{
	private static final Logger log = LoggerFactory.getLogger(ListSearcher.class);
	public ListSearcher(ListVO objListVO, Collection objMatchFieldInfo, HashMap hashMapIndexInfo) throws FileNotFoundError
    {
    l_strColumnNames = null;
    l_strMessageType = null;
    l_strListCode = null;
    l_stringListCode = null;
    l_arrayListIgnoreWord = null;
    l_arraySpecialCharacters = null;
    l_objFuzzySearcher = null;
    l_objNormalSearcher = null;
    l_strSearchLevel = null;
    l_objNormalSearchArray = null;
    l_objFuzzySearchArray = null;
    l_boolFUZZY_PRESENT = false;
    l_boolNORMAL_PRESENT = false;
    l_hashMapIndexFieldVO = null;
    l_strSearchLevel = objListVO.getSearchLevel();
    l_hashMapIndexFieldVO = hashMapIndexInfo;
    String l_SeperateIndexPath = "";
    //String l_ListIndexPath = "D:\\IndexFolder";
	/* 21st Oct 2016 */
    // String strListIndexDirectoryPath = ApplicationProperties.getInstance().getProperty("ListIndexDirectoryPath").trim();
    // String strListIndexDirectoryPath = "D:\\IndexFolder";
    String strListIndexDirectoryPath = CommonUtil.loadProperties().getProperty("compass.aml.paths.indexFolder");
	/* 21st Oct 2016 */
    try
    {
    l_objFuzzySearcher = (ListScreening)Class.forName("com.quantumdataengines.app.listScanning.listSearch.ListScreeningImpl").newInstance();
    Method objMethodArray[] = l_objFuzzySearcher.getClass().getDeclaredMethods();
    for(int i = 0; i < objMethodArray.length; i++)
    {
    if(!objMethodArray[i].getName().equalsIgnoreCase("initListSearcher"))
        continue;
    objMethodArray[i].invoke(l_objFuzzySearcher, new Object[] {
        (new StringBuilder(String.valueOf(strListIndexDirectoryPath))).append(objListVO.getListCode()).toString(), Integer.valueOf(1), Boolean.valueOf(true)	
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
   		(new StringBuilder(String.valueOf(strListIndexDirectoryPath))).append(objListVO.getListCode()).toString(), Integer.valueOf(2), Boolean.valueOf(true)	
    });
    break;
    }
    }
    catch(Exception e)
    {
    	log.error("Error occured :"+e.getMessage());
        e.printStackTrace();
    }
    //System.out.println("l_hashMapIndexFieldVO   "+l_hashMapIndexFieldVO);
    if(l_hashMapIndexFieldVO != null)
    {
        l_objFuzzySearcher.setListFieldsIndexedInfo(l_hashMapIndexFieldVO);
        l_objNormalSearcher.setListFieldsIndexedInfo(l_hashMapIndexFieldVO);
    }
    if(l_strSearchLevel.equalsIgnoreCase("Typical"))
        l_objFuzzySearcher.setListSearchLevel(1);
    else
        if(l_strSearchLevel.equalsIgnoreCase("Exhaustive"))
            l_objFuzzySearcher.setListSearchLevel(2);
    else
    if(l_strSearchLevel.equalsIgnoreCase("Loose"))
        l_objFuzzySearcher.setListSearchLevel(3);
    categorizeListFields(objMatchFieldInfo);
    l_strListCode = objListVO.getListCode();
    Thread.currentThread().setName("NewQdeThread");
    }

    protected void categorizeListFields(Collection objMatchFieldInfo)
    {
    Iterator iterator = objMatchFieldInfo.iterator();
    ArrayList alNormalSearchFields = new ArrayList();
    ArrayList alFuzzySearchFields = new ArrayList();
    while(iterator.hasNext()) 
    {
    FieldMappingVO objFieldMappingVO = (FieldMappingVO)iterator.next();
    if(objFieldMappingVO.getFieldCategory().equals("identity"))
    {
	alNormalSearchFields.add(objFieldMappingVO);
    l_boolNORMAL_PRESENT = true;
    } else
    {
	alFuzzySearchFields.add(objFieldMappingVO);
    l_boolFUZZY_PRESENT = true;
    }
    }
    l_objNormalSearchArray = getListFieldMappingVOArray(alNormalSearchFields);
    l_objFuzzySearchArray = getListFieldMappingVOArray(alFuzzySearchFields);
    }

    private FieldMappingVO[] getListFieldMappingVOArray(Collection objCollection)
    {
    FieldMappingVO objFieldMappingVOArray[] = new FieldMappingVO[objCollection.size()];
    Iterator iterator = objCollection.iterator();
    int intIndexValue = 0;
    while(iterator.hasNext()) 
    	objFieldMappingVOArray[intIndexValue++] = (FieldMappingVO)iterator.next();
    return objFieldMappingVOArray;
    }
    
    private void doListFuzzySearch(HashMap hashMapFieldValue, Vector vectorResult) throws ParseException, IOException
    {
    //Set set = hashMapFieldValue.keySet();
    //Iterator iterator = set.iterator();
    String strTempString = null;
    for(int i = 0; i < l_objFuzzySearchArray.length; i++)
    {
    FieldMappingVO objFieldMappingVO = l_objFuzzySearchArray[i];
    String strDataFieldsArray[] = objFieldMappingVO.getDataFields();
    String strTempSearch = "";
    for(int j = 0; j < strDataFieldsArray.length; j++)
    {
    strTempString = (String)hashMapFieldValue.get(strDataFieldsArray[j]);
    if(strTempString != null)
    	strTempSearch = (new StringBuilder(String.valueOf(strTempSearch))).append(" ").append(strTempString).toString();
    }

    if(strTempSearch != null && !strTempSearch.trim().equals("") && !strTempSearch.trim().equalsIgnoreCase("null"))
    if(objFieldMappingVO.isRepeated())
    {
    String strFieldDelimiter = objFieldMappingVO.getDelimiter();
    for(StringTokenizer l_strTokenizer = new StringTokenizer(strTempSearch, strFieldDelimiter); l_strTokenizer.hasMoreTokens();)
    {
    String strTokenString = l_strTokenizer.nextToken();
    Object objResultArray[] = (Object[])null;
    //if(strIgnoreWordsFlag != null && strIgnoreWordsFlag.equalsIgnoreCase("Y") || strAliasWordsFlag != null && strAliasWordsFlag.equalsIgnoreCase("Y"))
    //    objResultArray = l_objFuzzySearcher.search(objFieldMappingVO.getMatchField(), l_StrToken, objFieldMappingVO.getScoreLimit(), (HashMap)ApplicationProperties.m_ListKeywords.get(l_strListCode));
    //else
    objResultArray = l_objFuzzySearcher.listSearch(objFieldMappingVO.getMatchField(), strTokenString, objFieldMappingVO.getScoreLimit());
    if(objResultArray != null && objResultArray.length > 0)
    {
    for(int j = 0; j < objResultArray.length; j++)
    {
    	ScreeningResultVO objScreeningResultVO = (ScreeningResultVO)objResultArray[j];
    	objScreeningResultVO.setSourceField(objFieldMappingVO.getSourceField());
        vectorResult.add(objScreeningResultVO);
    }
    }
    }
    } 
    else
    {
    Object objResultArray[] = (Object[])null;
    objResultArray = l_objFuzzySearcher.listSearch(objFieldMappingVO.getMatchField(), strTempSearch, objFieldMappingVO.getScoreLimit());
    if(objResultArray != null && objResultArray.length > 0)
    {
    for(int j = 0; j < objResultArray.length; j++)
    {
	ScreeningResultVO objScreeningResultVO = (ScreeningResultVO)objResultArray[j];
	objScreeningResultVO.setSourceField(objFieldMappingVO.getSourceField());
    vectorResult.add(objScreeningResultVO);
    }
    }
    }
    }
    }

    private void doListIdentitySearch(HashMap hashMapFieldValue, Vector vectorResult) throws ParseException, IOException
    {
    String strTempString = null;
    for(int i = 0; i < l_objNormalSearchArray.length; i++)
    {
    FieldMappingVO objFieldMappingVO = l_objNormalSearchArray[i];
    String strDataFieldsArray[] = objFieldMappingVO.getDataFields();
    String strTempSearch = "";
    for(int j = 0; j < strDataFieldsArray.length; j++)
    {
	strTempString = (String)hashMapFieldValue.get(strDataFieldsArray[j]);
    if(strTempString != null)
    	strTempSearch = (new StringBuilder(String.valueOf(strTempSearch))).append(" ").append(strTempString).toString();
    }

    if(strTempSearch != null && !strTempSearch.trim().equals("") && !strTempSearch.trim().equalsIgnoreCase("null"))
    {
    Object objResultArray[] = (Object[])null;
    objResultArray = l_objNormalSearcher.listSearch(objFieldMappingVO.getMatchField(), strTempSearch, objFieldMappingVO.getScoreLimit());
    if(objResultArray != null && objResultArray.length > 0)
    {
    for(int j = 0; j < objResultArray.length; j++)
    {
	ScreeningResultVO objScreeningResultVO = (ScreeningResultVO)objResultArray[j];
	objScreeningResultVO.setSourceField(objFieldMappingVO.getSourceField());
    vectorResult.add(objScreeningResultVO);
    }
    }
    }
    }
    }

    public Vector listSearch(HashMap hashMapFieldValue) throws ParseException, IOException, Exception
    {
    Vector l_ResVector = new Vector();
    if(l_boolNORMAL_PRESENT)
        doListIdentitySearch(hashMapFieldValue, l_ResVector);
    if(l_boolFUZZY_PRESENT)
        doListFuzzySearch(hashMapFieldValue, l_ResVector);
    return l_ResVector;
    }

    private String l_strColumnNames;
    private ListScreening l_objFuzzySearcher;
    private ListScreening l_objNormalSearcher;
    private String l_strSearchLevel;
    private FieldMappingVO l_objNormalSearchArray[];
    private FieldMappingVO l_objFuzzySearchArray[];
    private boolean l_boolFUZZY_PRESENT;
    private boolean l_boolNORMAL_PRESENT;
    private HashMap l_hashMapIndexFieldVO;
    public String l_strMessageType;
    private String l_strListCode;
    private String l_stringListCode;
    private ArrayList l_arrayListIgnoreWord;
    private char l_arraySpecialCharacters[];
    private static String strIgnoreWordsFlag = null;
    private static String strAliasWordsFlag = null;

}