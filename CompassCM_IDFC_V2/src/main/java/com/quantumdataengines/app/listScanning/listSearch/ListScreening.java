package com.quantumdataengines.app.listScanning.listSearch;

import com.quantumdataengines.app.listScanning.castExceptions.FileNotFoundError;
import java.io.IOException;
import java.util.HashMap;
// import org.apache.lucene.queryParser.ParseException;
import org.apache.lucene.queryparser.classic.QueryParser;
import org.apache.lucene.queryparser.classic.ParseException;

public interface ListScreening
{
    public abstract void setListFieldsIndexedInfo(HashMap hashMap);
    public abstract void setDistinctMatchLevelDistance(String strStringDistance);
    public abstract void setListSearchLevel(int intSearchLevel);
    public abstract void initListSearcher(String strString, int intInteger, boolean boolFlag) throws FileNotFoundError, IllegalArgumentException;
    public abstract String removeAliasWords(String strAliasWord, HashMap hashMap);
    public abstract Object[] listSearch(String strSearch, String strSearch1, int intScoreLimit) throws ParseException, IOException;
    public abstract Object[] listSearch(String strSearch, String strSearch1, int intScoreLimit, HashMap hashMap) throws ParseException, IOException;
    public abstract Object[] listSearch(String strSearch, String strSearch1, int intScoreLimit, String strSearch2) throws ParseException, IOException;
    public abstract Object[] listSearch(String strSearch, String strSearch1, int intScoreLimit, String strSearch2, HashMap hashMap) throws ParseException, IOException;
}