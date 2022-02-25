package com.quantumdataengines.app.compass.service.scanning;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.StringTokenizer;

/*
 * Created on Nov 2, 2006
 *
 * To change the template for this generated file go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */

/**
 * @author Administrator
 *
 * To change the template for this generated type comment go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
public class NameMatcher {

	String srcFirstNm = "";
	String srcMiddleNm = "";
	String srcLastNm = "";

	String tarFirstNm = "";
	String tarMiddleNm = "";
	String tarLastNm = "";

	String[] srcArray;
	String[] tarArray;

	public static void main(String[] args)
	{

		String srcName;
		String targetName;


		try {
		BufferedReader br = new BufferedReader(new FileReader(new File("d:\\PDFFiles\\input2.txt")));
		PrintWriter pw = new PrintWriter(new FileOutputStream(new File("d:\\PDFFiles\\output2.xls")));
		pw.println("Applicant Name"+"\t"+"Name on CBN"+"\t"+"finalPer");
		String input = "";
		while((input = br.readLine()) != null)
		{
			input = input.toUpperCase().trim();
			if(!(input.trim().equals("")))
			{
				int index = input.indexOf("---");
				srcName = input.substring(0,index).trim();
				targetName = input.substring(index+3).trim();

				NameMatcher nmMtch = new NameMatcher();

				double finalPerMatch = nmMtch.matchNames(srcName,targetName);
                System.out.println(srcName+" : "+targetName+" - "+finalPerMatch);
				pw.println(srcName+"\t"+targetName+"\t"+finalPerMatch);

			}

		}

		br.close();
		pw.close();

	} catch (FileNotFoundException e) {
		e.printStackTrace();
	} catch (IOException e) {
		e.printStackTrace();
	}


/*
		srcName = "";
		targetName = "";

		srcName = srcName.toUpperCase().trim();
		targetName = targetName.toUpperCase().trim();
		double perMatch = 0;

		NameMatcher thisObj = new NameMatcher();
		perMatch = thisObj.matchNames(srcName,targetName);
		System.out.println("Percentage of match New Name Matcher : "+perMatch);
*/


		//System.out.println("Only CIPS OUTPUT");
		//perMatch = thisObj.CIPS(srcName,targetName);
		//System.out.println("Percentage of match : "+perMatch);

	}


	public double matchNames(String srcName,String targetName)
	{
		srcName = srcName.replace(",", " ");
		targetName = targetName.replace(",", " ");
		
		double finalPerMatch = 0;

		if(srcName.equals(targetName))
		{
			finalPerMatch = 100;
			return finalPerMatch;
		}

		String newSrcName = removeSpace(srcName);
		String newTargetName = removeSpace(targetName);
		if(newSrcName.equals(newTargetName))
		{
			finalPerMatch = 99.5;
			return finalPerMatch;
		}

		else
		{
			srcArray = breakName(srcName);
			tarArray = breakName(targetName);

			srcFirstNm = srcArray[0];
			if(srcArray.length > 1)
				srcLastNm = srcArray[srcArray.length-1];

			for(int i = 1;i<srcArray.length-1;i++)
				srcMiddleNm = srcMiddleNm +" "+ srcArray[i];

			tarFirstNm = tarArray[0];
			if(tarArray.length > 1)
				tarLastNm = tarArray[tarArray.length-1];

			for(int i = 1;i<tarArray.length-1;i++)
				tarMiddleNm = tarMiddleNm +" " +tarArray[i];

			srcLastNm = srcLastNm.trim();
			srcFirstNm = srcFirstNm.trim();
			srcMiddleNm = srcMiddleNm.trim();

			tarLastNm = tarLastNm.trim();
			tarFirstNm = tarFirstNm.trim();
			tarMiddleNm = tarMiddleNm.trim();

			finalPerMatch = match();

			if(finalPerMatch != 0)
			{
				finalPerMatch = Math.floor(100 - (((100 - finalPerMatch) / 44) * 10));
				return finalPerMatch;
			}
			else
			{
				finalPerMatch = MatchAfterReordering();
				if(finalPerMatch != 0)
					finalPerMatch = Math.floor(100 - (((100 - finalPerMatch) / 44) * 10));
					return finalPerMatch;
			}

		}
	}

	private String removeSpace(String name)
	{
		String result = "";
		StringTokenizer st = new StringTokenizer(name);

		while(st.hasMoreTokens())
		{
			result = result + st.nextToken().trim();
		}

		return result;
	}

	private String[] breakName(String name)
	{
		String result = name;
		StringTokenizer st = new StringTokenizer(name);

		String[] nameArray = new String[st.countTokens()];
		int i = 0;
		while(st.hasMoreTokens())
		{
			nameArray[i] = st.nextToken();
			i++;
		}
		return nameArray;
	}

	private double match()
	{
		double finalPer = 0;
		double firstPer = 0;
		double lastPer = 0;
		double middlePer = 0;

		if(srcFirstNm.equals(tarFirstNm))
			firstPer  =100;
//		else if((srcFirstNm.length() == 1) || (tarFirstNm.length() == 1))
//		{
//			if(srcFirstNm.charAt(0) != tarFirstNm.charAt(0))
//				return 0;
//			else
//				firstPer = 90;
//		}
		else
		{
			firstPer = CIPS(srcFirstNm,tarFirstNm);
			/* Commented on 12/07/2012
			if(firstPer < 90)
				return 0;
			*/	
		}

		//depending on last names

		if(srcLastNm.equals("") && tarLastNm.equals(""))
			return firstPer;//lastPer = firstPer;
//		else if(srcLastNm.equals("") || tarLastNm.equals(""))
//			lastPer = (0.8*firstPer);
		else
		{
			if(srcLastNm.equals(tarLastNm))
				lastPer = 100;
//			else if( (srcLastNm.length()==1) || (tarLastNm.length()==1) )
//			{
//				if(srcLastNm.charAt(0) != tarLastNm.charAt(0))
//					return 0;
//				else
//					lastPer = 90;
//			}

			else
			{
				lastPer = CIPS(srcLastNm,tarLastNm);
				/* Commented on 12/07/2012
					if(lastPer < 90)
				{
//					if(srcArray.length != tarArray.length)
//					{
//						lastPer = CIPS(srcLastNm,tarMiddleNm);
//						if(lastPer < 90)
//						{
//							lastPer = CIPS(tarLastNm,srcMiddleNm);
//							if(lastPer < 90)
//								return 0;
//							else
//								return (0.9 * ((firstPer * lastPer) / 100));
//						}
//						else
//							return (0.9 * ((firstPer * lastPer) / 100));
//					}
//					else
						return 0;
				 
				}*/
			}
		}


		//depending on middle names


		if(srcMiddleNm.equals(tarMiddleNm))
			return (firstPer * lastPer) / 100;
//		else if(srcMiddleNm.equals("") || tarMiddleNm.equals(""))
//			return 0.8 * ((firstPer * lastPer) / 100);

//		else if((srcMiddleNm.length()==1) || (tarMiddleNm.length()==1) )
//		{
//			if(srcMiddleNm.charAt(0) != tarMiddleNm.charAt(0))
//				return 0;
//			else
//				middlePer = 90;
//		}
		else if(!srcMiddleNm.equals("")&& !tarMiddleNm.equals(""))
		{
			middlePer = CIPS(srcMiddleNm,tarMiddleNm);
			/* Commented on 12/07/2012
			if(middlePer < 90)
				return 0;
			*/	
		}

		finalPer = (firstPer * lastPer * middlePer) / 10000;

		return finalPer;

	}

	private double MatchAfterReordering()
	{
		double finalPer = 0;
		double firstPer = 0;
		double lastPer = 0;
		double middlePer = 0;

		if((srcFirstNm.length()>1) && (tarLastNm.length()>1))
		{
			//compare first name of source and last name of target.
			if(srcFirstNm.equals(tarLastNm))
				firstPer =100;
			else
			{
				firstPer = CIPS(srcFirstNm,tarLastNm);
				/* Commented on 12/07/2012
				if(firstPer < 90)
					return 0;
				*/	
			}

			//compare last name of source and first name of target.

			if(srcLastNm.equals(tarFirstNm))
				lastPer = 100;
			else
			{
				lastPer = CIPS(srcLastNm,tarFirstNm);
				/* Commented on 12/07/2012
				if(lastPer < 90)
					return 0;
				*/	
			}

			//now compare middle names

		    if(srcMiddleNm.equals(tarMiddleNm))
		    {
				finalPer = 	0.9 * ( (firstPer*lastPer)/100 );
				return finalPer;
		    }
//			else if((srcMiddleNm.equals("")) || (tarMiddleNm.equals("")))
//			{
//				finalPer = 	0.8 * ( (firstPer*lastPer)/100 );
//				return finalPer;
//			}
//
//			else if( (srcMiddleNm.length() == 1) || (tarMiddleNm.length() == 1) )
//			{
//				if(srcMiddleNm.charAt(0) != tarMiddleNm.charAt(0))
//					return 0;
//				else middlePer = 90;
//			}
			else
			{
				middlePer = CIPS(srcMiddleNm,tarMiddleNm);
				/* Commented on 12/07/2012
				if(middlePer < 90)
					return 0;
				*/	
			}

			finalPer = 0.9 * (firstPer * lastPer * middlePer) / 10000;

		}

		return finalPer;
	}


	public double CIPS(String source,String target)
	{
		source = source.replace(",", " ");
		target = target.replace(",", " ");
		double[][] costArray = new double[source.length()+1][target.length()+1];

		int maxLen = source.length();
		if(target.length() > maxLen)
			maxLen = target.length();

		int srcLen = source.length();
		int tarLen = target.length();

		source = "#" + source + "!";
		target = "#" + target + "!";

		for(int i=0; i<=srcLen; i++)
			costArray[i][0] = i;

		for(int j=0; j<=tarLen; j++)
			costArray[0][j] = j;

		double value1 = 0;
		double value2 = 0;
		double value3 = 0;
		double minVal = 0;

		//System.out.println("Source is : "+source);

		//System.out.println("Target is : "+target);


		for(int i=1; i<=srcLen; i++)
			for(int j=1; j<=tarLen; j++)
			{


				value1 = costArray[i-1][j] + costInsDel(source.charAt(i),source.charAt(i-1),source.charAt(i+1));
				value2 = costArray[i][j-1] + costInsDel(target.charAt(j),target.charAt(j-1),target.charAt(j+1));

				minVal = Math.min(value1,value2);

				value3 = costArray[i-1][j-1] + costSub(source.charAt(i),target.charAt(j));

				minVal = Math.min(value3,minVal);

				costArray[i][j] = minVal;



				if(i>2 && j>2)
				{
					if((source.charAt(i)==target.charAt(j-1)) && (source.charAt(i-1)==target.charAt(j)))
					{
						value1 = costArray[i][j];
						value2 = costArray[i-2][j-2] + costSwap(source.charAt(i),target.charAt(j));
						costArray[i][j]= Math.min(value1,value2);
					}
				}

				//System.out.println("Value of i : "+i+" and Value of j :"+j);
				printArray(costArray,srcLen,tarLen,source,target);



			}


		double finalPer = costArray[srcLen][tarLen];
		finalPer = (1.0 - (finalPer/maxLen))*100;

		printArray(costArray,srcLen,tarLen,source,target);

		return Math.round(finalPer);
	}


	private double costInsDel(char currChar,char prevChar, char nextChar)
	{
		if(currChar<65 || currChar>90)
		 return 0.05;
		else if((currChar == prevChar) && (currChar != 'E') && (currChar!='O'))
			return 0.15;
		if(isVowel(currChar))
			return 0.25;
		else if((currChar == 'W') || (currChar == 'Y'))
			return 0.5;
		else if(currChar == 'H')
		{
			if((prevChar == 'B') || (prevChar == 'C') || (prevChar == 'D') || (prevChar == 'G') || (prevChar == 'K') || (prevChar == 'P') || (prevChar == 'J') || (prevChar == 'S'))
				return 0.15;
			else
				return 0.25;
		}
		else if((currChar == 'C') && ( (prevChar == 'S' || prevChar == 'X') ))
			return 0.25;
		else if((currChar == 'N') && isConsonant(nextChar))
			return 0.35;
		else
			return 1.0;

	}

	private double costSub(char src,char tar)
	{
		if(src == tar)
			return 0.0;
		else if( (isVowel(src)) && (isVowel(tar)) && isValidVowelCombn(src,tar) )
			return 0.25;
		else if( (src<65 || src>90) || (tar<65 || tar>90) )
			return 0.05;

		String str = ""+src+tar;
		str.trim();

		if( str.equals("YI") || str.equals("IY") || str.equals("RD") || str.equals("DR") || str.equals("CK") || str.equals("KC") || str.equals("CS") || str.equals("SC") || str.equals("GJ") || str.equals("JG") || str.equals("ZJ") || str.equals("JZ") || str.equals("XZ") || str.equals("ZX") || str.equals("XS") || str.equals("SX") || str.equals("XJ") || str.equals("JS") || str.equals("SZ") || str.equals("ZS") )
			return 0.25;
		else if ( str.equals("KQ") || str.equals("QK") || str.equals("WV") || str.equals("VW") || str.equals("BV") ||  str.equals("VB") || str.equals("PF") || str.equals("FP") )
			return 0.15;
		else
			return 1.0;
	}

	private double costSwap(char src,char tar)
	{
		if(isVowel(src) && isVowel(tar) && isValidVowelCombn(src,tar))
			return 0.15;
		else if( (isVowel(src) && ( (tar == 'B') || (tar == 'C') || (tar == 'D') || (tar == 'F') || (tar == 'G') || (tar == 'H') || (tar == 'J') || (tar == 'K') || (tar == 'L') || (tar == 'M') || (tar == 'N') || (tar == 'P') || (tar == 'Q') || (tar == 'S') || (tar == 'T') || (tar == 'V') || (tar == 'W') || (tar == 'X') || (tar == 'Y') || (tar == 'Z') )) || (isVowel(tar) && ( (src == 'B') || (src == 'C') || (src == 'D') || (src == 'F') || (src == 'G') || (src == 'H') || (src == 'J') || (src == 'K') || (src == 'L') || (src == 'M') || (src == 'N') || (src == 'P') || (src == 'Q') || (src == 'S') || (src == 'T') || (src == 'V') || (src == 'W') || (src == 'X') || (src == 'Y') || (src == 'Z') )) )
			return 0.25;
		else if( (isVowel(src) && tar == 'R') || (isVowel(tar) && src == 'R') )
			return 0.15;
		else
			return 0.35;

	}

	private boolean isVowel(char ch)
	{
		if((ch == 'A') || (ch == 'E') || (ch == 'I') || (ch == 'O') || (ch == 'U'))
			return true;
		else
			return false;
	}

	private boolean isConsonant(char ch)
	{
		if((ch == 'A') || (ch == 'E') || (ch == 'I') || (ch == 'O') || (ch == 'U'))
			return false;
		else
			return true;

	}

	private boolean isValidVowelCombn(char src,char tar)
	{
		String str = ""+src+tar;
		str.trim();
		if(str.equals("AU") || str.equals("UA") || str.equals("EU") || str.equals("UE") || str.equals("IU") || str.equals("UI") || str.equals("IO") || str.equals("OI"))
			return false;
		else
			return true;
	}


	private void printArray(double[][] strArray,int srclen,int tarlen,String source,String target)
	{
//		try {
//			FileOutputStream fos = new FileOutputStream(new File("c:/cips_matrix.txt"));
//
//			//System.out.print(""+"\t");
//			for(int j=0; j<=tarlen; j++)
//				//System.out.print("\t"+target.charAt(j));
//
//			//System.out.println("");
//
//			for(int i=0; i<=srclen; i++)
//			{
//				//System.out.print("\t"+source.charAt(i));
//				for(int j=0; j<=tarlen; j++)
//					//System.out.print("\t"+strArray[i][j]);
//				//System.out.println("");
//			}
//			//System.out.println("\r\n");
//		} catch (FileNotFoundException e) {
//			// TODO Auto-generated catch block
//			e.printStackTrace();
//		}

	}
}
