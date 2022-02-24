package com.quantumdataengines.app.listScanning.listSearch;

import java.util.*;

import com.quantumdataengines.app.compass.util.CompassStringOperationUtil;

public class CalculateMatchScore
{
    public CalculateMatchScore()
    {
    }
    public static void main(String args[]) throws Exception
    {
        Calendar calendar = Calendar.getInstance();
        long l_start = calendar.getTimeInMillis();
        System.out.println((new StringBuilder("New Score:")).append(calculateNewScore("Osama Bin Laden", "Laden Bin Osama")).toString());
        System.out.println((new StringBuilder("Total Time Taken for scoring in millisecs:")).append(Calendar.getInstance().getTimeInMillis() - l_start).toString());
        System.out.println((new StringBuilder("New Score1:")).append(calculateNewScore("VIJENDER SINGH", "Virender SINGH")).toString());
        System.out.println((new StringBuilder("New Score2:")).append(calculateNewScore("virender singh", "virender singh")).toString());
        System.out.println((new StringBuilder("New Score2 Bank Of Jerusalem Limited:")).append(calculateNewScore("BANK OF JERUSALEM LIMITED", "BANK OF JERUSALEM")).toString());
        System.out.println((new StringBuilder("New Score2 Bank Of Jerusalem Limited:")).append(calculateNewScore("BANK OF JERUSALEM LIMITED", "BANK OF JERUSALEM LIMITED LTD;")).toString());
        
        System.out.println((new StringBuilder("Total Time Taken for scoring in millisecs:")).append(Calendar.getInstance().getTimeInMillis() - l_start).toString());
    }
    private static int calculateScore(String strCompareString1, String strCompareString2)
        throws Exception
    {
        String strSortedString1 = sortString(strCompareString1.toUpperCase());
        String strSortedString2 = sortString(strCompareString2.toUpperCase());
        String strStringArray1[] = createStringArray(strSortedString1);
        String strStringArray2[] = createStringArray(strSortedString2);
        int intFirstToSecondScore = calcBrokenStringScore(strStringArray1, strStringArray2);
        int intSecondToFirstScore = calcBrokenStringScore(strStringArray2, strStringArray1);
        double doublelevenshteinDistance = getLevenshteinDistance(strSortedString1, strSortedString2);
        double doublePercentValue = (doublelevenshteinDistance * 100D) / (double)(strSortedString1.length() + strSortedString2.length());
        int intMatchScore = (new Double(Math.ceil(100D - doublePercentValue))).intValue();
        int intWordMatchScore = (intFirstToSecondScore + intSecondToFirstScore) / 2;
        if(intMatchScore > intWordMatchScore)
            return intMatchScore;
        else
            return intWordMatchScore;
    }

    public static int calculateNewScore(String strCompareString1, String strCompareString2)
        throws Exception
    {
    	// System.out.println("Pre: strCompareString21, strCompareString2: "+strCompareString1+" : "+strCompareString2);
    	strCompareString1 = CompassStringOperationUtil.replaceNoiseWordForScanning(strCompareString1.toUpperCase());
    	strCompareString2 = CompassStringOperationUtil.replaceNoiseWordForScanning(strCompareString2.toUpperCase());
    	// System.out.println("Post: strCompareString21, strCompareString2: "+strCompareString1+" : "+strCompareString2);
    	
    	String strSortedString1 = sortString(strCompareString1.toUpperCase());
        String strSortedString2 = sortString(strCompareString2.toUpperCase());
        String strStringArray1[] = createStringArray(strSortedString1);
        String strStringArray2[] = createStringArray(strSortedString2);
        int intFirstToSecondScore = calcBrokenStringScorePercentage(strStringArray1, strStringArray2);
        int intSecondToFirstScore = calcBrokenStringScorePercentage(strStringArray2, strStringArray1);
        int intTempScore = 0;
        if(intFirstToSecondScore == 1 && intSecondToFirstScore == 1)
        	intTempScore = 5;
        int intMaxCalculatedScore = calculateScore(strCompareString1, strCompareString2);
        float floatNumerator = (float)((strStringArray1.length + strStringArray2.length) - Math.abs(strStringArray1.length - strStringArray2.length)) + 0.0F;
        float floatDenominator = strStringArray1.length + strStringArray2.length;
        double doublePercentValue = floatNumerator / floatDenominator;
        double intWordMatchScore = 5D * doublePercentValue;
        float floatMaxPercentValue = 0.9F;
        int intFinalMatchscore = (new Double(Math.floor((double)(floatMaxPercentValue * (float)intMaxCalculatedScore + (float)intTempScore) + intWordMatchScore))).intValue();
        int doublelevenshteinDistance = getLevenshteinDistance(strSortedString1, strSortedString2);
        if(doublelevenshteinDistance <= 2)
        	intFinalMatchscore = intMaxCalculatedScore;
        return intFinalMatchscore;
    }
    private static String[] createStringArray(String strConvertToArray) throws Exception
    {
        StringTokenizer stringTokenizer = new StringTokenizer(strConvertToArray, " ");
        String strArray[] = new String[stringTokenizer.countTokens()];
        for(int i = 0; stringTokenizer.hasMoreTokens(); i++)
        	strArray[i] = stringTokenizer.nextToken();
        return strArray;
    }
    private static int calcBrokenStringScore(String strCompareArray1[], String strCompareArray2[]) throws Exception
    {
        int intPresentScore = 0;
        int intPastScore = 0;
        int i = 0;
        int j = 0;
        int intFinalMatchScore = 0;
        for(i = 0; i < strCompareArray1.length; i++)
        {
        	intPresentScore = -1;
        	intPastScore = -1;
            for(j = 0; j < strCompareArray2.length; j++)
            {
            	intPresentScore = calculatePercentageScore(getLevenshteinDistance(strCompareArray1[i], strCompareArray2[j]), strCompareArray1[i].length(), strCompareArray2[j].length());
                if(intPastScore < intPresentScore)
                	intPastScore = intPresentScore;
            }
            intFinalMatchScore += intPastScore;
        }
        if(strCompareArray1.length == 0)
        	return intFinalMatchScore;
        else
        	return intFinalMatchScore / strCompareArray1.length;
    }

    private static int calcBrokenStringScorePercentage(String strCompareArray1[], String strCompareArray2[]) throws Exception
    {
        int intPresentScore = 0;
        int intPastScore = 0;
        int i = 0;
        int j = 0;
        for(i = 0; i < strCompareArray1.length; i++)
        {
        	intPresentScore = -1;
        	intPastScore = -1;
            for(j = 0; j < strCompareArray2.length; j++)
            {
            	intPresentScore = calculatePercentageScore(getLevenshteinDistance(strCompareArray1[i], strCompareArray2[j]), strCompareArray1[i].length(), strCompareArray2[j].length());
                if(intPastScore < intPresentScore)
                	intPastScore = intPresentScore;
            }
            if(intPastScore < 80)
                return 0;
        }
        return 1;
    }

    private static int calculatePercentageScore(int intDistance, int intLength1, int intLength2)
    {
        return 100 - (intDistance * 100) / (intLength1 + intLength2);
    }

    public static String sortString(String strSortString) throws Exception
    {
        StringTokenizer stringTokenizer = new StringTokenizer(strSortString, " ");
        String stringArray[] = new String[stringTokenizer.countTokens()];
        for(int i = 0; stringTokenizer.hasMoreTokens(); i++)
        	stringArray[i] = stringTokenizer.nextToken();
        Arrays.sort(stringArray);
        StringBuffer stringBuffer = new StringBuffer();
        for(int i = 0; i < stringArray.length; i++)
        	stringBuffer.append(stringArray[i]).append(" ");
        return stringBuffer.toString().trim();
    }

    public static int getLevenshteinDistance(String strString1, String strString2) throws Exception
    {
        if(strString1 == null || strString2 == null)
            throw new IllegalArgumentException("Strings must not be null");
        int intLengthOfString1 = strString1.length();
        int intLengthOfString2 = strString2.length();
        if(intLengthOfString1 == 0)
            return intLengthOfString2;
        if(intLengthOfString2 == 0)
            return intLengthOfString1;
        int intArray1[] = new int[intLengthOfString1 + 1];
        int intArray2[] = new int[intLengthOfString1 + 1];
        for(int i = 0; i <= intLengthOfString1; i++)
        	intArray1[i] = i;
        for(int j = 1; j <= intLengthOfString2; j++)
        {
            char t_j = strString2.charAt(j - 1);
            intArray2[0] = j;
            for(int i = 1; i <= intLengthOfString1; i++)
            {
                int cost = strString1.charAt(i - 1) != t_j ? 1 : 0;
                intArray2[i] = Math.min(Math.min(intArray2[i - 1] + 1, intArray1[i] + 1), intArray1[i - 1] + cost);
            }
            int intTempArray[] = intArray1;
            intArray1 = intArray2;
            intArray2 = intTempArray;
        }
        return intArray1[intLengthOfString1];
    }
}