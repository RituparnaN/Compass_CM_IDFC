package com.quantumdataengines.app.listScanning.listSearch;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.StringTokenizer;
import java.util.regex.Pattern;

import org.apache.lucene.analysis.Analyzer;
import org.apache.lucene.analysis.standard.StandardAnalyzer;
import org.apache.lucene.document.Document;
import org.apache.lucene.index.IndexReader;
// import org.apache.lucene.queryParser.ParseException;
// import org.apache.lucene.queryParser.QueryParser;
import org.apache.lucene.queryparser.classic.QueryParser;
import org.apache.lucene.queryparser.classic.ParseException;

import org.apache.lucene.search.BooleanQuery;
// import org.apache.lucene.search.DefaultSimilarity;
import org.apache.lucene.search.similarities.DefaultSimilarity;
import org.apache.lucene.search.IndexSearcher;
import org.apache.lucene.search.Query;
import org.apache.lucene.search.ScoreDoc;
import org.apache.lucene.search.TopDocs;
import org.apache.lucene.store.FSDirectory;
import org.apache.lucene.util.Version;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.quantumdataengines.app.listScanning.castExceptions.FileNotFoundError;

public class ListScreeningImpl implements ListScreening
{
	private static final Logger log = LoggerFactory.getLogger(ListScreeningImpl.class);
    public ListScreeningImpl()
    {
    }

    public ListScreeningImpl(String strIndexPath, int intSearchType) throws FileNotFoundError, IllegalArgumentException
    {
    l_intSearchType = 2;
    PREFIX_LENGTH = 0;
    l_objSearcher = null;
    l_objAnalyzer = null;
    l_objQuery = null;
    try
    {
    l_objIndexReader = null;
    if(strIndexPath.indexOf("index") >= 0)
        l_strIndexDefaultDir = strIndexPath;
    else
        l_strIndexDefaultDir = (new StringBuilder("index")).append(fileSeperator).append(strIndexPath).toString();
    readListIndexes(strIndexPath, intSearchType);
    }
    catch(IOException e)
    {
    	log.error("Exception in ListScreeningImpl constructor : "+e.toString());
	System.out.println("Exception in ListScreeningImpl constructor : "+e.toString());
    e.printStackTrace();
	throw new FileNotFoundError((new StringBuilder("Error in Accessing Index file :")).append(e).toString());
    }
    catch(Exception e)
    {
    	log.error("Exception in ListScreeningImpl constructor : "+e.toString());
	System.out.println("Exception in ListScreeningImpl constructor : "+e.toString());
    e.printStackTrace();
    throw new FileNotFoundError((new StringBuilder("Error in Accessing Index file :")).append(e).toString());
    }
    }

    public ListScreeningImpl(String strIndexPath, int intSearchType, boolean boolMultipleIndex) throws FileNotFoundError, IllegalArgumentException
    {
    l_intSearchType = 2;
    PREFIX_LENGTH = 0;
    l_objSearcher = null;
    l_objAnalyzer = null;
    l_objQuery = null;
    try
    {
    l_objIndexReader = null;
    if(boolMultipleIndex)
        l_strIndexDefaultDir = strIndexPath;
    else if(strIndexPath.indexOf("index") >= 0)
        l_strIndexDefaultDir = strIndexPath;
    else
        l_strIndexDefaultDir = (new StringBuilder("index")).append(fileSeperator).append(strIndexPath).toString();
    readListIndexes(strIndexPath, intSearchType);
    }
    catch(IOException e)
    {
    	log.error("Exception in ListScreeningImpl constructor : "+e.toString());
	System.out.println("Exception in ListScreeningImpl constructor : "+e.toString());
    e.printStackTrace();
    throw new FileNotFoundError((new StringBuilder("Error in Accessing Index file :")).append(e).toString());
    }
    catch(Exception e)
    {
    	log.error("Exception in ListScreeningImpl constructor : "+e.toString());
	System.out.println("Exception in ListScreeningImpl constructor : "+e.toString());
    e.printStackTrace();
    throw new FileNotFoundError((new StringBuilder("Error in Accessing Index file :")).append(e).toString());
    }
    }

    /*public ListScreeningImpl(String strIndexSource, int intSearchType) throws FileNotFoundError, IllegalArgumentException
    {
        this(strIndexSource, intSearchType, null);
    }
    */

    public void initListSearcher(String strIndexPath, int intSearchType, boolean boolMultipleIndex) throws FileNotFoundError, IllegalArgumentException
    {
    l_intSearchType = 2;
    PREFIX_LENGTH = 0;
    l_objSearcher = null;
    l_objAnalyzer = null;
    l_objQuery = null;
    try
    {
    l_objIndexReader = null;
    if(boolMultipleIndex)
        l_strIndexDefaultDir = strIndexPath;
    else if(strIndexPath.indexOf("index") >= 0)
        l_strIndexDefaultDir = strIndexPath;
    else
        l_strIndexDefaultDir = (new StringBuilder("index")).append(fileSeperator).append(strIndexPath).toString();
    readListIndexes(strIndexPath, intSearchType);
    }
    catch(IOException e)
    {
    	log.error("Exception in ListScreeningImpl->initListSearcher : "+e.toString());
	System.out.println("Exception in ListScreeningImpl->initListSearcher : "+e.toString());
    e.printStackTrace();
    throw new FileNotFoundError((new StringBuilder("Error in Accessing Index file :")).append(e).toString());
    }
    catch(Exception e)
    {
    	log.error("Exception in ListScreeningImpl->initListSearcher : "+e.toString());
	System.out.println("Exception in ListScreeningImpl->initListSearcher : "+e.toString());
    e.printStackTrace();
    throw new FileNotFoundError((new StringBuilder("Error in Accessing Index file :")).append(e).toString());
    }
    }

    private void readListIndexes(String strReadIndexSource, int intSearchType) throws IOException, IllegalArgumentException
    {
    if(strReadIndexSource == null) {
    	log.error("ListSearcher constructor Argument null");
    throw new IllegalArgumentException("ListSearcher constructor Argument null");
    } else {
    l_intSearchType = intSearchType;
    org.apache.lucene.store.Directory directory = FSDirectory.open(new File(l_strIndexDefaultDir));
    l_objIndexReader = IndexReader.open(directory);
    l_objSearcher = new IndexSearcher(l_objIndexReader);
    l_objSearcher.setSimilarity(new DefaultSimilarity());
    l_objAnalyzer = new StandardAnalyzer(Version.LUCENE_47);
    l_strIndexDefaultDir = "index";
    return;
    }
    }

    public void close() throws IOException
    {
    // l_objSearcher.close();
    l_objIndexReader.close();
    }

    public static String formFuzzyString(String strToConvertFuzzy) throws Exception
    {
    StringBuffer l_returnString = new StringBuffer();
    String l_strToConvertFuzzy = LUCENE_PATTERN.matcher(QueryParser.escape(strToConvertFuzzy)).replaceAll("\\\\$0");
    StringTokenizer l_stk = new StringTokenizer(l_strToConvertFuzzy, " ");
    int l_tokenCount = l_stk.countTokens();
    for(int i = 0; i < l_tokenCount; i++)
        l_returnString.append(l_stk.nextToken()).append("~").append(MATCH_DISTANCE).append(" ");
    return l_returnString.toString();
    }

    public void setListFieldsIndexedInfo(HashMap hashMapObject) {
    }

    public Object[] listSearch(String strSearchField, String strSearchString, int intScoreLimit, String strSourceField) throws ParseException, IOException
    {
    String l_fuzzyString = null;
    Query l_CQuery = null;
    if(strSearchString == null || strSearchString.trim().length() <= 0)
        return (new ArrayList()).toArray();
    QueryParser parser = new QueryParser(Version.LUCENE_47, strSearchField, l_objAnalyzer);
    try {
        l_fuzzyString = formFuzzyString((new StringBuilder(String.valueOf(strSearchString.toUpperCase()))).append(" ").toString());
    }
    catch(Exception e) {
    	log.error("Exception in ListScreeningImpl->search : "+e.toString());
    	System.out.println("Exception in ListScreeningImpl->search : "+e.toString());
        e.printStackTrace();
    }
    l_CQuery = parser.parse(l_fuzzyString);
    BooleanQuery l_boolQry = new BooleanQuery();
    l_boolQry.add(l_CQuery, org.apache.lucene.search.BooleanClause.Occur.MUST);
    TopDocs results = l_objSearcher.search(l_boolQry, 30000);
    ScoreDoc hits[] = results.scoreDocs;
    return createScanResults(hits, strSearchString.trim(), strSearchField, intScoreLimit, strSourceField);
    }

    public Object[] listSearch(String strSearchField, String strSearchString, int intScoreLimit) throws ParseException, IOException
    {
    String strFuzzyString = null;
    Query objQuery = null;
    if(strSearchString == null || strSearchString.trim().length() <= 0)
        return (new ArrayList()).toArray();
    QueryParser objQueryParser = new QueryParser(Version.LUCENE_47, strSearchField, l_objAnalyzer);
    try {
    	strFuzzyString = formFuzzyString(strSearchString);
    	// objQuery = objQueryParser.parse(strFuzzyString);
    	objQuery = objQueryParser.parse(QueryParser.escape(strFuzzyString));
    }
    catch(Exception e) {
    	log.error("Exception in ListScreeningImpl->search : "+e.toString());
    	System.out.println("Exception in ListScreeningImpl->search : "+e.toString());
        e.printStackTrace();
    }
    BooleanQuery objBooleanQuery = new BooleanQuery();
    objBooleanQuery.add(objQuery, org.apache.lucene.search.BooleanClause.Occur.MUST);
    TopDocs objTopDocs = l_objSearcher.search(objBooleanQuery, 30000);
    ScoreDoc arrayScoreDoc[] = objTopDocs.scoreDocs;
    return createScanResults(arrayScoreDoc, strSearchString.trim(), strSearchField, intScoreLimit, null);
    }

    public Object[] listSearch(String strSearchField, String strSearchString, int intScoreLimit, HashMap hmAliasWordMap) throws ParseException, IOException
    {
    Query objQuery = null;
    strSearchString = removeAliasWords(strSearchString == null ? "" : strSearchString, hmAliasWordMap);
    if(strSearchString == null || strSearchString.trim().length() <= 0)
        return (new ArrayList()).toArray();
    String strFuzzyString = null;
    QueryParser objQueryParser = new QueryParser(Version.LUCENE_47, strSearchField, l_objAnalyzer);
    try {
    	strFuzzyString = formFuzzyString(strSearchString);
    }
    catch(Exception e) {
    	log.error("Exception in ListScreeningImpl->search : "+e.toString());
    	System.out.println("Exception in ListScreeningImpl->search : "+e.toString());
        e.printStackTrace();
    }
    objQuery = objQueryParser.parse(strFuzzyString);
    BooleanQuery objBooleanQuery = new BooleanQuery();
    objBooleanQuery.add(objQuery, org.apache.lucene.search.BooleanClause.Occur.MUST);
    TopDocs objTopDocs = l_objSearcher.search(objBooleanQuery, 30000);
    ScoreDoc objScoreDoc[] = objTopDocs.scoreDocs;
    return createScanResults(objScoreDoc, strSearchString.trim(), strSearchField, intScoreLimit, null, hmAliasWordMap);
    }

    public Object[] listSearch(String strSearchField, String strSearchString, int intScoreLimit, String strSourceField, HashMap hmAliasWordMap) throws ParseException, IOException
    {
    String strFuzzyString = null;
    Query objQuery = null;
    strSearchString = removeAliasWords(strSearchString == null ? "" : strSearchString, hmAliasWordMap);
    if(strSearchString == null || strSearchString.trim().length() <= 0)
        return (new ArrayList()).toArray();
    QueryParser objQueryParser = new QueryParser(Version.LUCENE_47, strSearchField, l_objAnalyzer);
    try {
    	strFuzzyString = formFuzzyString(strSearchString);
    }
    catch(Exception e) {
    	log.error("Exception in ListSearcherImpl - > search : "+e.toString());
    	System.out.println("Exception in ListSearcherImpl - > search : "+e.toString());
        e.printStackTrace();
    }
    objQuery = objQueryParser.parse(strFuzzyString);
    BooleanQuery objBooleanQuery = new BooleanQuery();
    objBooleanQuery.add(objQuery, org.apache.lucene.search.BooleanClause.Occur.MUST);
    TopDocs objTopDocs = l_objSearcher.search(objBooleanQuery, 30000);
    ScoreDoc objScoreDoc[] = objTopDocs.scoreDocs;
    return createScanResults(objScoreDoc, strSearchString.trim(), strSearchField, intScoreLimit, strSourceField, hmAliasWordMap);
    }

    private Object[] createScanResults(ScoreDoc objScoreDoc[], String strSearchString, String strSearchField, int intScoreLimit, String strSourceField) throws IOException
    {
    ArrayList arrayListScanResult = new ArrayList();
    for(int i = 0; i < objScoreDoc.length; i++){
    Document objDocument = l_objIndexReader.document(objScoreDoc[i].doc);
    String strDocArrayData[] = objDocument.getValues(strSearchField);
    int intMatchScore = 0;
    if(strDocArrayData != null) {
    for(int j = 0; j < strDocArrayData.length; j++) {
    try {
    	intMatchScore = CalculateMatchScore.calculateNewScore(strDocArrayData[j], strSearchString);
    }
    catch(Exception e) {
    	log.error("Exception in ListScreeingImpl-> generateResults : "+e.toString());
    	System.out.println("Exception in ListScreeingImpl-> generateResults : "+e.toString());
        e.printStackTrace();
    }
    if(intMatchScore >= intScoreLimit) {
	ScreeningResultVO objScreeningResultVO = new ScreeningResultVO();
    objScreeningResultVO.setId(objDocument.get("id").trim());
    objScreeningResultVO.setRecord(objDocument.get("record"));
    objScreeningResultVO.setListName(objDocument.get("listname"));
    objScreeningResultVO.setMatchField(strSearchField);
    objScreeningResultVO.setMatchData(strDocArrayData[j]);
    objScreeningResultVO.setSourceField(strSourceField);
    objScreeningResultVO.setSourceData(strSearchString);
    objScreeningResultVO.setScore(intMatchScore);
    objScreeningResultVO.setDOB(objDocument.get("DATEOFBIRTH") == null ? " " : objDocument.get("DATEOFBIRTH"));
    objScreeningResultVO.setPlaceOfBirth(objDocument.get("PLACEOFBIRTH") != null ? objDocument.get("PLACEOFBIRTH") : " ");
    objScreeningResultVO.setPassportID(objDocument.get("PASSPORTID") != null ? objDocument.get("PASSPORTID") : " ");
    objScreeningResultVO.setNationality(objDocument.get("NATIONALITY") == null ? " " : objDocument.get("NATIONALITY"));
    objScreeningResultVO.setLocalID(objDocument.get("LOCALID") != null ? objDocument.get("LOCALID") : " ");
    objScreeningResultVO.setAddress(objDocument.get("ADDRESS") != null ? objDocument.get("ADDRESS") : " ");
    arrayListScanResult.add(objScreeningResultVO);
    }
    }
    }
    }
    return arrayListScanResult.toArray();
    }

    private Object[] createScanResults(ScoreDoc objScoreDoc[], String strSearchString, String strField, int intScoreLimit, String strSourceField, HashMap hmAliasWordMap) throws IOException
    {
    ArrayList arrayListScanResult = new ArrayList();
    for(int i = 0; i < objScoreDoc.length; i++) {
    Document objDocument = l_objIndexReader.document(objScoreDoc[i].doc);
    String strDocArrayData[] = objDocument.getValues(strField);
    int intMatchScore = 0;
    if(strDocArrayData != null) {
    for(int j = 0; j < strDocArrayData.length; j++) {
    try {
    	intMatchScore = CalculateMatchScore.calculateNewScore(removeAliasWords(strDocArrayData[j] == null ? "" : strDocArrayData[j], hmAliasWordMap), strSearchString);
    }
    catch(Exception e) {
    	log.error("Exception in ListScreeningImpl -> generateResults : "+e.toString());
    	System.out.println("Exception in ListScreeningImpl -> generateResults : "+e.toString());
        e.printStackTrace();
    }
    if(intMatchScore >= intScoreLimit) {
	ScreeningResultVO objScreeningResultVO = new ScreeningResultVO();
    objScreeningResultVO.setId(objDocument.get("id").trim());
    objScreeningResultVO.setRecord(objDocument.get("record"));
    objScreeningResultVO.setListName(objDocument.get("listname"));
    objScreeningResultVO.setMatchField(strField);
    objScreeningResultVO.setMatchData(strDocArrayData[j]);
    objScreeningResultVO.setSourceField(strSourceField);
    objScreeningResultVO.setSourceData(strSearchString);
    objScreeningResultVO.setScore(intMatchScore);
    objScreeningResultVO.setDOB(objDocument.get("DATEOFBIRTH") == null ? " " : objDocument.get("DATEOFBIRTH"));
    objScreeningResultVO.setPlaceOfBirth(objDocument.get("PLACEOFBIRTH") != null ? objDocument.get("PLACEOFBIRTH") : " ");
    objScreeningResultVO.setNationality(objDocument.get("NATIONALITY") == null ? " " : objDocument.get("NATIONALITY"));
    objScreeningResultVO.setPassportID(objDocument.get("PASSPORTID") != null ? objDocument.get("PASSPORTID") : " ");
    objScreeningResultVO.setLocalID(objDocument.get("LOCALID") != null ? objDocument.get("LOCALID") : " ");
    objScreeningResultVO.setAddress(objDocument.get("ADDRESS") != null ? objDocument.get("ADDRESS") : " ");
    arrayListScanResult.add(objScreeningResultVO);
    }
    }
    }
    }
    return arrayListScanResult.toArray();
    }

    public void setListSearchLevel(int intSearchLevel)
    {
    switch(intSearchLevel)
    {
    case 1: 
        setDistinctMatchLevelDistance("0.9");
        l_intSearchType = 2;
        break;

    case 2: 
        setDistinctMatchLevelDistance("0.5");
        l_intSearchType = 1;
        break;

    case 3: 
        setDistinctMatchLevelDistance("0.2");
        l_intSearchType = 1;
        break;
    }
    }

    public void setDistinctMatchLevelDistance(String intDistance)
    {
        MATCH_DISTANCE = intDistance;
    }

    public String removeAliasWords(String strMatchString, HashMap hashMap)
    {
    StringBuffer stringBuffer = new StringBuffer();
    strMatchString = strMatchString.replaceAll("\t", " ");
    strMatchString = strMatchString.replaceAll("  ", " ");
    if(hashMap != null)
    if(strMatchString.lastIndexOf(" ") > 0) {
    String matchString[] = strMatchString.split(" ");
    String replacedWord = "";
    String stringArray[];
    int j = (stringArray = matchString).length;
    for(int i = 0; i < j; i++) {
    String strActualString = stringArray[i];
    replacedWord = (String)hashMap.get(strActualString.toUpperCase());
    if(hashMap.containsKey(strActualString.toUpperCase()) && replacedWord == null)
    	stringBuffer.append("");
    else
    	stringBuffer.append(replacedWord != null ? replacedWord != "" ? (new StringBuilder(String.valueOf(replacedWord))).append(" ").toString() : "" : (new StringBuilder(String.valueOf(strActualString))).append(" ").toString());
    }
    } 
    else {
    String replacedWord = (String)hashMap.get(strMatchString.toUpperCase());
    if(hashMap.containsKey(strMatchString.toUpperCase()) && replacedWord == null)
    	stringBuffer.append("");
    else
    	stringBuffer.append(replacedWord != null ? replacedWord != "" ? (new StringBuilder(String.valueOf(replacedWord))).append(" ").toString() : "" : (new StringBuilder(String.valueOf(strMatchString))).append(" ").toString());
    }
    return stringBuffer.toString().trim();
    }

    public static final String l_strSpace = " ";
    public static final String l_strTilde = "~";
    public static final String l_strEmpty = "";
    private static final String l_strREPLACEMENT_STRING = "\\\\$0";
    private static String l_strIndexDefaultDir = "index";
    private static final String l_strIndex = "index";
    public static final int FUZZY_SEARCH = 1;
    public static final int NORMAL_SEARCH = 2;
    public static final int TYPICAL = 1;
    public static final int EXHAUSTIVE = 2;
    public static final int LOOSE = 3;
    private int l_intSearchType;
    private int PREFIX_LENGTH;
    private static final String fileSeperator;
    private IndexReader l_objIndexReader;
    private IndexSearcher l_objSearcher;
    private Analyzer l_objAnalyzer;
    private static String MATCH_DISTANCE;
    private Query l_objQuery;
    public static final int l_topDocsSize = 30000;
    private static final String LUCENE_ESCAPE_CHARS = "(\\bAND\\b)|(\\bOR\\b)|(\\bNOT\\b)";
    private static final Pattern LUCENE_PATTERN = Pattern.compile("(\\bAND\\b)|(\\bOR\\b)|(\\bNOT\\b)");
    static 
    {
        fileSeperator = File.separator;
    }
}