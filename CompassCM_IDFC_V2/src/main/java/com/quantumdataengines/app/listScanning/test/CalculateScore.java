package com.quantumdataengines.app.listScanning.test;

import com.wcohen.secondstring.JaroWinklerTFIDF;
import com.wcohen.secondstring.Level2Jaro;
import com.wcohen.secondstring.Level2MongeElkan;
import com.wcohen.secondstring.MongeElkan;
import com.wcohen.secondstring.StringDistance;
import com.wcohen.secondstring.StringWrapper;

public class CalculateScore {

	private static StringDistance m_StringDistance = new MongeElkan();

	public static void main(String[] args) {
	double doubleMatchScore = 0d;
	double doubleMaxScore = 0d;
    double doubleMinScore = 0d;
	StringWrapper searchstringWrapper = m_StringDistance.prepare("Osama Bin Laden");
	StringWrapper fieldValueWrapper = m_StringDistance.prepare("Osama Mohammed Awad Bin Laden");
	double doubleFirstWithSecondScore = m_StringDistance.score(searchstringWrapper, fieldValueWrapper);
	double doubleSeconWithFirstScore = m_StringDistance.score(fieldValueWrapper, searchstringWrapper);
	double doubleFirstToSecondScore = doubleFirstWithSecondScore <= 1.0D ? doubleFirstWithSecondScore : 1.0D;
    double doubleSecondToFirstScore = doubleSeconWithFirstScore <= 1.0D ? doubleSeconWithFirstScore : 1.0D; 
    if(doubleFirstToSecondScore > doubleSecondToFirstScore)
    {
    	doubleMaxScore = doubleFirstToSecondScore;
    	doubleMinScore = doubleSecondToFirstScore;
    }
    else
    {
    	doubleMaxScore = doubleSecondToFirstScore;
    	doubleMinScore = doubleFirstToSecondScore;
    }
    if(doubleMaxScore > .93 && doubleMinScore > .93)
    	doubleMatchScore = (doubleMinScore * doubleMinScore * 50 +  doubleMaxScore * (100 - (doubleMinScore * 50)));
    else
    	doubleMatchScore = (doubleMinScore * doubleMinScore * 50 +  doubleMaxScore * ((100 * doubleMaxScore) - (doubleMinScore * 50)));
        
    System.out.println(" doubleFirstToSecondScore "+doubleMaxScore+" Score2 "+doubleMinScore+" Final Score "+doubleMatchScore);
    System.out.println();
	}
}
