<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" import="java.util.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ include file="../tags/tags.jsp"%>
<%@ include file="../tags/staticFiles.jsp"%>
<%
String EXCULDEDPRODUCTCODE = (String) request.getAttribute("EXCULDEDPRODUCTCODE");
String FromDate = (String) request.getAttribute("FromDate");
String ToDate = (String) request.getAttribute("ToDate");
String AccountNumber = (String) request.getAttribute("AccountNumber");
String CustomerId = (String) request.getAttribute("CustomerId");
String CustomerName = (String) request.getAttribute("CustomerName");
String StaticLink = (String) request.getAttribute("StaticLink");
String TransactionLink = (String) request.getAttribute("TransactionLink");
String MinLinks = (String) request.getAttribute("MinLinks");
String CounterAccountNo = (String) request.getAttribute("CounterAccountNo");
String CounterAccountGroup = (String) request.getAttribute("CounterAccountGroup");
String LevelCount = (String) request.getAttribute("LevelCount");
Map<String, Object> EntityTracerMatrixData = (Map<String, Object>) request.getAttribute("EntityTracerMatrixData");
ArrayList matrixNodes = (ArrayList)EntityTracerMatrixData.get("AllNodes");
ArrayList matrixEdges = (ArrayList)EntityTracerMatrixData.get("AllEdges");
String matrixNode = "";
String matrixEdge = "";
String fromNode = "";
String toNode = "";

HashMap parentMap = new HashMap();
HashMap parentMapXPosition = new HashMap();
HashMap nodedListMap = new HashMap();

int xPosition = 15;
int yPosition = 56;

String parentNode = "";
String parentXPosition = "";

%>
<html>
	<div id="chart-container"></div>
</html>
<script type="text/javascript">
var margin = {top: 20, right: 120, bottom: 20, left: 150},
width = 960 - margin.right - margin.left,
height = 500 - margin.top - margin.bottom;

FusionCharts.ready(function () {
    var constructionPlan = new FusionCharts({
        type: 'dragnode',
        renderAt: 'chart-container',
        width: '1650',
        height: '950',
        dataFormat: 'json',
        dataSource: {
            "chart": {
                "caption": "Entity Matrix",                                
                "arrowatstart": "0",
                "arrowatend": "1",
                "viewMode": "1",
                "showCanvasBorder": "0",
                "showXAxisLine" : "0",
                "bgColor":"#ffffff",
                "showBorder": "0",
                "paletteColors": "#0075c2",
                "baseFontColor": "#ffffff",                
                "baseFont": "Helvetica Neue,Arial",
                "captionFontSize": "14",
                "captionFontColor": "#333333",
                "btnTextColor": "#333333",
                "showPlotBorder": "0",
                "toolTipColor": "#ffffff",
                "toolTipBorderThickness": "0",
                "toolTipBgColor": "#000000",
                "toolTipBgAlpha": "80",
                "toolTipBorderRadius": "2",
                "toolTipPadding": "5",
                "connectorToolText": "$label Level"
            },            
            "dataset": [
                {
                    "id": "1",
                    "seriesname": "DS1",
                    "data": [
					<%
					for(int i = 0; i < matrixEdges.size(); i++) {
 						matrixEdge = matrixEdges.get(i).toString();	
 						fromNode = matrixEdge.substring(0,matrixEdge.indexOf(":"));
 						toNode = matrixEdge.substring(matrixEdge.indexOf(":")+1);
 						if(parentMap.get(toNode) == null )
 							parentMap.put(toNode, fromNode);
 						
 						for(int j = 0; j < 2; j++) {
 						if( j == 0)	
							matrixNode = fromNode;	
 						else	
							matrixNode = toNode;	
 						
 						if(nodedListMap.get(matrixNode) == null) {
						nodedListMap.put(matrixNode,"Y");
						//System.out.println("matrixNode:  "+matrixNode);
						parentNode = "";
						parentXPosition = "";

						if(parentMap.get(matrixNode) != null ){
							parentNode = parentMap.get(matrixNode).toString();
							parentXPosition = "";
							if(parentMapXPosition.get(parentNode) != null ){
								parentXPosition = parentMapXPosition.get(parentNode).toString();
							}
						System.out.println("parentNode:  "+parentNode+", And parentXPosition:  "+parentXPosition);
						}
						if(!parentXPosition.equals("")){
							xPosition = Integer.parseInt(parentXPosition) + 3;
						}
						else {
							xPosition = 4 + (i * 3);
						}
							
						//xPosition = 4 + (i * 3);
						yPosition = 56 + (i * 2);
						parentMapXPosition.put(matrixNode, xPosition);
						System.out.println("matrixNode:  "+matrixNode+", And xPosition:  "+xPosition);
						String nodeShape = "CIRCLE";
						String color = "blue";
						if(matrixNode.equalsIgnoreCase(AccountNumber) || matrixNode.equalsIgnoreCase(CounterAccountNo) )
							nodeShape = "RECTANGLE";
						if(fromNode.equalsIgnoreCase(AccountNumber))
 							color = "#f2c500";
 						if(toNode.equalsIgnoreCase(CounterAccountNo))
 							color = "#f2c500";
 						
					if(i == matrixEdges.size()-1){
					%>
                      {
                        "id": "<%= matrixNode %>",
                        "x": "<%= xPosition %>",
                        "y": "<%= yPosition %>",
                        "name": "<%= matrixNode %>",
                        <%
                        if(matrixNode.equalsIgnoreCase(AccountNumber) || matrixNode.equalsIgnoreCase(CounterAccountNo)) {
                        %>
                        "height": "25",
                        "width": "200",
                        "shape": "RECTANGLE",
                        <% } else { %>
                        "radius": "25",
                        "shape": "<%= nodeShape%>",
                        <% } %>
                        "tooltext": "<%= matrixNode %>"
                      }
                    <%
					} else {
					%>
                    	{
                        "id": "<%= matrixNode %>",
                        "x": "<%= xPosition %>",
                        "y": "<%= yPosition %>",
                        "name": "<%= matrixNode %>",
                        <%
                        if(matrixNode.equalsIgnoreCase(AccountNumber) || matrixNode.equalsIgnoreCase(CounterAccountNo)) {
                        %>
                        "height": "25",
                        "width": "100",
                        "shape": "RECTANGLE",
                        <% } else { %>
                        "radius": "25",
                        "shape": "<%= nodeShape%>",
                        <% } %>
                        "tooltext": "<%= matrixNode %>"
                    	},
					<% 
					}
					}
					}
					}
					%>
                    ]
                }
            ],
            "connectors": [
                {
                    "stdthickness": "2",
                    "connector": [
   					<%
 					for(int i = 0; i < matrixEdges.size(); i++) {
 						matrixEdge = matrixEdges.get(i).toString();	
 						fromNode = matrixEdge.substring(0,matrixEdge.indexOf(":"));
 						toNode = matrixEdge.substring(matrixEdge.indexOf(":")+1);
 						//System.out.println("fromNode:  "+fromNode+" , And toNode :   "+toNode);
 						String color = "#1aaf5d";
 						if(fromNode.equalsIgnoreCase(AccountNumber))
 							color = "#f2c500";
 						if(toNode.equalsIgnoreCase(CounterAccountNo))
 							color = "#f2c500";
 						
 					if(i == matrixEdges.size()-1){
 					%>
                    	{
                        "from": "<%=fromNode%>",
                        "to": "<%=toNode%>",
                        "color": "<%= color %>",
                        "strength": "1",
                        "arrowatstart": "0",
                        "alpha": "100",
                        "label": "<%= i %>"
                    	}
                     <%
 					} else {
 					%>
 					{
                        "from": "<%=fromNode%>",
                        "to": "<%=toNode%>",
                        "color": "<%= color %>",
                        "strength": "1",
                        "arrowatstart": "0",
                        "alpha": "100",
                        "label": "<%= i %>"
                    	},
 					<% 
 					}
 					}
 					%>
                    ]
                }
            ]
			/*
            ,
            "annotations": {
                "origw": "400",
                "origh": "300",
                "autoscale": "1",
                "groups": [                    
                    {
                        "color": "#0075c2",
                        "fontSize": "12",
                        "y": "$chartEndY - $chartBottomMargin - 54",
                        "items": [
                            {                                
                                "id": "anno-A",
                                "type": "text",
                                "label": "A. Excavate",
                                "align": "Left",
                                "verticalAlign": "top",
                                "bold": "1",
                                "x": "$chartStartX + $chartLeftMargin + 24"                                                            
                            },
                            {                                
                                "id": "anno-B",
                                "type": "text",
                                "label": "B. Foundation",
                                "align": "Left",
                                "verticalAlign": "top",
                                "bold": "1",
                                "x": "$chartStartX + $chartLeftMargin + 124"                           
                            },
                            {                                
                                "id": "anno-C",
                                "type": "text",
                                "label": "C. Rough Wall",
                                "align": "Left",
                                "verticalAlign": "top",
                                "bold": "1",
                                "x": "$chartStartX + $chartLeftMargin + 224"                           
                            },
                            {                                
                                "id": "anno-D",
                                "type": "text",
                                "label": "D. Roof",
                                "align": "Left",
                                "verticalAlign": "top",
                                "bold": "1",
                                "x": "$chartStartX + $chartLeftMargin + 315"                           
                            }                            
                        ]
                    },
                    {
                        "color": "#0075c2",
                        "fontSize": "12",
                        "y": "$chartEndY - $chartBottomMargin - 42",
                        "items": [
                            {                                
                                "id": "anno-E",
                                "type": "text",
                                "label": "E. Exterior Plumbing",
                                "align": "Left",
                                "verticalAlign": "top",
                                "bold": "1",
                                "x": "$chartStartX + $chartLeftMargin + 24"                           
                            },
                            {                                
                                "id": "anno-F",
                                "type": "text",
                                "label": "F. Interior Plumbing",
                                "align": "Left",
                                "verticalAlign": "top",
                                "bold": "1",
                                "x": "$chartStartX + $chartLeftMargin + 124"                                                            
                            },
                            {                                
                                "id": "anno-G",
                                "type": "text",
                                "label": "G. Exterior Siding",
                                "align": "Left",
                                "verticalAlign": "top",
                                "bold": "1",
                                "x": "$chartStartX + $chartLeftMargin + 224"                           
                            },
                            {                                
                                "id": "anno-H",
                                "type": "text",
                                "label": "H. Exterior Painting",
                                "align": "Left",
                                "verticalAlign": "top",
                                "bold": "1",
                                "x": "$chartStartX + $chartLeftMargin + 315"                           
                            }                            
                        ]
                    },
                    {
                        "color": "#0075c2",
                        "fontSize": "12",
                        "y": "$chartEndY - $chartBottomMargin - 30",
                        "items": [
                            {                                
                                "id": "anno-I",
                                "type": "text",
                                "label": "I. Electrical Work",
                                "align": "Left",
                                "verticalAlign": "top",
                                "bold": "1",
                                "x": "$chartStartX + $chartLeftMargin + 24"                           
                            },
                            {                                
                                "id": "anno-J",
                                "type": "text",
                                "label": "J. Wallboard",
                                "align": "Left",
                                "verticalAlign": "top",
                                "bold": "1",
                                "x": "$chartStartX + $chartLeftMargin + 124"                           
                            },
                            {                                
                                "id": "anno-K",
                                "type": "text",
                                "label": "K. Flooring",
                                "align": "Left",
                                "verticalAlign": "top",
                                "bold": "1",
                                "x": "$chartStartX + $chartLeftMargin + 224"                                                            
                            },
                            {                                
                                "id": "anno-L",
                                "type": "text",
                                "label": "L. Interior Painting",
                                "align": "Left",
                                "verticalAlign": "top",
                                "bold": "1",
                                "x": "$chartStartX + $chartLeftMargin + 315"                           
                            }                           
                        ]
                    },
                    {
                        "color": "#0075c2",
                        "fontSize": "12",
                        "y": "$chartEndY - $chartBottomMargin - 18",
                        "items": [                            
                            {                                
                                "id": "anno-M",
                                "type": "text",
                                "label": "M. Exterior Fixtures",
                                "align": "Left",
                                "verticalAlign": "top",
                                "bold": "1",
                                "x": "$chartStartX + $chartLeftMargin + 24"                           
                            },
                            {                                
                                "id": "anno-N",
                                "type": "text",
                                "label": "N. Interior Fixtures",
                                "align": "Left",
                                "verticalAlign": "top",
                                "bold": "1",
                                "x": "$chartStartX + $chartLeftMargin + 124"                           
                            }
                        ]
                    }
                ]
            }
            */
        }                
    }).render();
});
</script>
