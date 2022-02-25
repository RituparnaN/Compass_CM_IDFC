<!doctype html public "-//w3c//dtd html 4.0 transitional//en">

<%@ page language="java" %>
<%@ page import ="java.io.IOException" %>
<%@ page import ="java.util.*" %>
<%@ page import ="java.sql.Connection" %>
<%@ page import ="java.sql.DriverManager" %>
<%@ page import ="java.sql.PreparedStatement" %>
<%@ page import ="java.sql.ResultSet" %>
<%@ page import ="java.sql.SQLException" %>
<%@ page import ="oracle.jdbc.driver.OracleDriver" %>
<%@ page import ="com.quantumdataengines.main.utils.DatabaseConnectionFactory" %>
<%
String THEMEFILENAME = session.getAttribute("THEMEFILENAME") == null ? System.getProperty("THEMEFILENAME"):session.getAttribute("THEMEFILENAME").toString();
String THEMECOLORNAME = session.getAttribute("THEMECOLORNAME") == null ? System.getProperty("THEMECOLORNAME"):session.getAttribute("THEMECOLORNAME").toString();    
String contextPath = request.getContextPath()==null?"":request.getContextPath();
%>
<%
String l_strNoOfParameters = (String) request.getParameter("l_strNoOfParameters");
int l_intNoOfParameters = Integer.parseInt(l_strNoOfParameters);
String l_strReportID = (String) request.getParameter("l_strReportID");
String l_strAction = request.getParameter("l_strAction") != null ? (String) request.getParameter("l_strAction"):"";
String LOGGEDUSER = session.getAttribute("LOGGEDUSER").toString();
String TERMINALID = request.getRemoteAddr();
Connection con = null;
ResultSet rsPrep = null;
ArrayList l_ALSearchResult  = new ArrayList();
HashMap l_HMSearchResult = new HashMap();
HashMap l_HMParamSearchResult = null ;
HashMap l_HMDetails = new HashMap();
ArrayList l_ALAlertCode  = new ArrayList();
Connection conn = null;
PreparedStatement uStmt = null;
ResultSet rs = null;
String queryString = "";
int countVal = 0;
try {
DriverManager.registerDriver(new OracleDriver());
//conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:XE", "COMPAML","ORACLE");
conn = DatabaseConnectionFactory.getConnection("COMPAML");

if(l_strAction.equals("saveParameters")) {
String l_strParameterIndex = (String) request.getParameter("l_strParameterIndex");
String l_strColumnIndex = l_strParameterIndex.replaceAll("@param", "");
String l_strParameterLabel = (String) request.getParameter("l_strParameterLabel");
String l_strParameterType = (String) request.getParameter("l_strParameterType");
String l_strDefaultValueType = (String) request.getParameter("l_strDefaultValueType");
String l_strDefaultValue = (String) request.getParameter("l_strDefaultValue");
String l_strMandatory = (String) request.getParameter("l_strMandatory");

rs=null;
queryString = " SELECT COUNT(*) COUNTVAL "+
	          "   FROM TB_REPORTBUILDERPARAMS "+
			  "  WHERE REPORTID = '"+l_strReportID+"' "+
			  "    AND PARAMINDEX = '"+l_strColumnIndex+"' ";
uStmt = conn.prepareStatement(queryString);
rs = uStmt.executeQuery();
while (rs.next()) 
  countVal = rs.getInt("COUNTVAL");

if(countVal == 0)
	queryString = " INSERT INTO TB_REPORTBUILDERPARAMS ( REPORTID, PARAMINDEX, PARAMNAME, "+
			      "       PARAMALIASNAME, PARAMTYPE, DEFAULTVALUETYPE, DEFAULTVALUE, "+
			      "       ISMANDATORY, UPDATEDDATE, UPDATEDBY) "+ 
			      "  VALUES( '"+l_strReportID+"', '"+l_strColumnIndex+"', '"+l_strParameterIndex+"', "+
	              "  '"+l_strParameterLabel+"', '"+l_strParameterType+"', '"+l_strDefaultValueType+"', '"+l_strDefaultValue+"', "+
	              "  '"+l_strMandatory+"', SYSTIMESTAMP, '"+LOGGEDUSER+"' ) ";
else
	queryString = " UPDATE TB_REPORTBUILDERPARAMS SET PARAMALIASNAME = '"+l_strParameterLabel+"', PARAMTYPE = '"+l_strParameterType+"', "+
	              "       DEFAULTVALUETYPE = '"+l_strDefaultValueType+"', DEFAULTVALUE = '"+l_strDefaultValue+"', "+
	              "       ISMANDATORY = '"+l_strMandatory+"' , UPDATEDDATE = SYSTIMESTAMP, UPDATEDBY = '"+LOGGEDUSER+"' "+
                  " WHERE REPORTID =  '"+l_strReportID+"' AND PARAMINDEX = '"+l_strColumnIndex+"' ";
uStmt = conn.prepareStatement(queryString);
uStmt.executeUpdate();
}
else if(l_strAction.equals("deleteParameters")) {
String l_strParameterIndex = (String) request.getParameter("l_strParameterIndex");
String l_strColumnIndex = l_strParameterIndex.replaceAll("@param", "");
if(l_strColumnIndex != null && l_strColumnIndex.indexOf(",") >= 0)
  l_strColumnIndex = l_strColumnIndex.substring(0, l_strColumnIndex.length()-1);

queryString = " DELETE FROM TB_REPORTBUILDERPARAMS "+
			  " WHERE REPORTID =  '"+l_strReportID+"' AND PARAMINDEX IN ("+l_strColumnIndex+") ";
//System.out.println("queryString : "+queryString);
uStmt = conn.prepareStatement(queryString);
uStmt.executeUpdate();
}
else if(l_strAction.equals("showParameterDetails")) {
String l_strColumnIndex = (String) request.getParameter("l_strColumnIndex");
rs=null;
queryString = "SELECT PARAMINDEX, PARAMNAME, PARAMALIASNAME, PARAMTYPE, DEFAULTVALUETYPE, DEFAULTVALUE, ISMANDATORY "+ 
			  "  FROM TB_REPORTBUILDERPARAMS A "+
			  " WHERE REPORTID = '"+l_strReportID+"' AND PARAMINDEX = '"+l_strColumnIndex+"' ";
uStmt = conn.prepareStatement(queryString);
rs = uStmt.executeQuery();
while (rs.next()) {
l_HMParamSearchResult = new HashMap();
l_HMParamSearchResult.put("PARAMINDEX",rs.getString("PARAMINDEX"));
l_HMParamSearchResult.put("PARAMNAME",rs.getString("PARAMNAME"));
l_HMParamSearchResult.put("PARAMALIASNAME",rs.getString("PARAMALIASNAME"));
l_HMParamSearchResult.put("PARAMTYPE",rs.getString("PARAMTYPE"));
l_HMParamSearchResult.put("DEFAULTVALUETYPE",rs.getString("DEFAULTVALUETYPE"));
l_HMParamSearchResult.put("DEFAULTVALUE",rs.getString("DEFAULTVALUE"));
l_HMParamSearchResult.put("ISMANDATORY",rs.getString("ISMANDATORY"));
}
}

rs=null;
queryString = "SELECT ROWNUM AS ROWPOSITION, A.* FROM (SELECT REPORTID, PARAMINDEX, PARAMNAME, "+
			  "       PARAMALIASNAME, PARAMTYPE, DEFAULTVALUETYPE, DEFAULTVALUE, ISMANDATORY, "+
			  "       TO_CHAR(UPDATEDDATE,'DD-MON-YYYY') UPDATEDON, UPDATEDBY UPDATEDBY "+ 
			  "  FROM TB_REPORTBUILDERPARAMS A "+
			  " WHERE REPORTID = '"+l_strReportID+"' ORDER BY PARAMINDEX) A ";

//System.out.println("queryString		"+queryString);
uStmt = conn.prepareStatement(queryString);
rs = uStmt.executeQuery();
while (rs.next()) 
{
l_HMSearchResult = new HashMap();
l_HMSearchResult.put("ROWPOSITION",rs.getString("ROWPOSITION"));
l_HMSearchResult.put("REPORTID",rs.getString("REPORTID"));
l_HMSearchResult.put("PARAMINDEX",rs.getString("PARAMINDEX"));
l_HMSearchResult.put("PARAMNAME",rs.getString("PARAMNAME"));
l_HMSearchResult.put("PARAMALIASNAME",rs.getString("PARAMALIASNAME"));
l_HMSearchResult.put("PARAMTYPE",rs.getString("PARAMTYPE"));
l_HMSearchResult.put("DEFAULTVALUETYPE",rs.getString("DEFAULTVALUETYPE"));
l_HMSearchResult.put("DEFAULTVALUE",rs.getString("DEFAULTVALUE"));
l_HMSearchResult.put("ISMANDATORY",rs.getString("ISMANDATORY"));
l_HMSearchResult.put("UPDATEDON",rs.getString("UPDATEDON"));
l_HMSearchResult.put("UPDATEDBY",rs.getString("UPDATEDBY"));
l_ALSearchResult.add(l_HMSearchResult);
}

rs.close();
uStmt.close();
conn.close(); 
}catch (Exception t) {
System.out.println("t.getMessage() " + t.getMessage());
t.printStackTrace();
}finally {
try {
	if (rsPrep != null)
		rsPrep.close();
} catch (SQLException e) {
	System.out.println("Exception :" + e);
}
try {
	if (con != null)
		con.close();
} catch (Exception e) {
	System.out.println("Exception :" + e);
}
}
	%>
<HTML><meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" />
<TITLE>Set Report Parameters</TITLE>
<script type="text/javascript" src="<%=contextPath%>/ext-3.2.1/adapter/ext/ext-base.js"></script>
   <script type="text/javascript" src="<%=contextPath%>/ext-3.2.1/ext-all.js"></script>    
   <script type="text/javascript" src="<%=contextPath%>/ext-3.2.1/examples/form/states.js"></script>
   <script type="text/javascript" src="<%=contextPath%>/ext-3.2.1/examples/shared/examples.js"></script>
   <script type="text/javascript" src="<%=contextPath%>/ext-3.2.1/examples/data.js"></script>

   <script type="text/javascript" src="<%=contextPath%>/ext-3.2.1/examples/grid/gen-names.js"></script>
   <script type="text/javascript" src="<%=contextPath%>/ext-3.2.1/examples/ux/RowEditor.js"></script>
   <script type="text/javascript" src="<%=contextPath%>/ext-3.2.1/examples/form/absform.js"></script>
   <script type="text/javascript" src="<%=contextPath%>/ext-3.2.1/Exporter-all.js" ></script>


   <link rel="stylesheet" type="text/css" href="<%=contextPath%>/ext-3.2.1/resources/css/ext-all.css" />  
   <link rel="stylesheet" type="text/css" href="<%=contextPath%>/ext-3.2.1/resources/css/<%= THEMEFILENAME %>" />
   <link rel="stylesheet" type="text/css" href="<%=contextPath%>/ext-3.2.1/examples/shared/examples.css" />
   <link rel="stylesheet" type="text/css" href="<%=contextPath%>/ext-3.2.1/examples/ux/css/RowEditor.css" />
   <link rel="stylesheet" type="text/css" href="<%=contextPath%>/ext-3.2.1/examples/grid/grid-examples.css" />
   <link rel="stylesheet" type="text/css" href="<%=contextPath%>/ext-3.2.1/examples/tabs/tabs-example.css" />
   <link  rel='stylesheet' type='text/css' href="<%=contextPath%>/ext-3.2.1/example/style.css" />

   <script type="text/javascript" src="<%=contextPath%>/ext-3.2.1/examples/ux/ProgressBarPager.js"></script>
   <script type="text/javascript" src="<%=contextPath%>/ext-3.2.1/examples/ux/PanelResizer.js"></script>
   <script type="text/javascript" src="<%=contextPath%>/ext-3.2.1/examples/ux/PagingMemoryProxy.js"></script>
   <link rel="stylesheet" type="text/css" href="<%=contextPath%>/ext-3.2.1/examples/ux/css/PanelResizer.css" />

<!-- <style type="text/css"></style> -->
<style type="text/css">

.absolute0 {
position: absolute;
top: 0px;
left:10px;
}
.modal-header {
    	flex-direction: row-reverse;
	}
	.xtrSmlButton
	{
		padding: 1px 5px;
		font-size: 12px;
	}
	.table td
	{
		padding: 8px;
	}
	
		.x-grid3 .x-window-ml{
			padding-left: 0;	
		} 
		.x-grid3 .x-window-mr {
			padding-right: 0;
		} 
		.x-grid3 .x-window-tl {
			padding-left: 0;
		} 
		.x-grid3 .x-window-tr {
			padding-right: 0;
		} 
		.x-grid3 .x-window-tc .x-window-header {
			height: 3px;
			padding:0;
			overflow:text;
		} 
		.x-grid3 .x-window-mc {
			border-width: 0;
			background: #cdd9e8;
		} 
		.x-grid3 .x-window-bl {
			padding-left: 0;
		} 
		.x-grid3 .x-window-br {
			padding-right: 0;
		}
		.x-grid3 .x-card-btns {
			padding:0;
		}
		.x-grid3 .x-card-btns td.x-toolbar-cell {
			padding:3px 3px 0;
		}
		.x-box-inner {
			zoom:1;
		}
        .icon-user-add {
            background-image: url(<%=contextPath%>/ext-3.2.1/examples/shared/icons/fam/user_add.gif) !important;
        }
        .icon-user-delete {
            background-image: url(<%=contextPath%>/ext-3.2.1/examples/shared/icons/fam/user_delete.gif) !important;
        } 
		
		.icon-search {
            background-image: url(/images/icons_ext/search.gif) !important;
        }
		.icon-clear {
            background-image: url(/images/icons_ext/clear.gif) !important;
        }
        .icon-delete {
            background-image: url(/images/icons_ext/delete.gif) !important;
        } 
		            	.icon-copy-from-existing {
            background-image: url(/images/icons_ext/copy_from_existing.gif) !important;
        }
		.icon-save {
            background-image: url(/images/icons_ext/save.gif) !important;
        }
        .icon-save-draft {
            background-image: url(/images/icons_ext/save_draft.png) !important;
        }
		.icon-clear {
            background-image: url(/images/icons_ext/clear.gif) !important;
        }
		.icon-close {
            background-image: url(/images/icons_ext/close.gif) !important;
        }
		.icon-authorize {
            background-image: url(/images/icons_ext/Approve.gif) !important;
        }
		.icon-reject {
            background-image: url(/images/icons_ext/Reject.gif) !important;
        }
		.icon-copy-from-existing {
            background-image: url(/images/icons_ext/copy_from_existing.gif) !important;
        }
		.icon-save {
            background-image: url(/images/icons_ext/save.gif) !important;
        }
        .icon-save-draft {
            background-image: url(/images/icons_ext/save_draft.png) !important;
        }
		.icon-clear {
            background-image: url(/images/icons_ext/clear.gif) !important;
        }
		.icon-close {
            background-image: url(/images/icons_ext/close.gif) !important;
        }
		.icon-authorize {
            background-image: url(/images/icons_ext/Approve.gif) !important;
        }
		.icon-reject {
            background-image: url(/images/icons_ext/Reject.gif) !important;
        }
        .icon-search {
            background-image: url(/images/icons_ext/search.gif) !important;
        }
        .icon-delete {
            background-image: url(/images/icons_ext/delete.gif) !important;
        }
    </style>

<script>
var l_strAuthrozeOrSave1 = "";

var data = [];
var grid;
var grid1;
var grid2;
var Temparr = new Array();
var Perarr = new Array();
var l_strSelectedItemToDelete = "";
var data1=new Array();
var data2=new Array();

function openSave()
{ 
var l_strReportID = '<%= l_strReportID %>';
var l_strNoOfParameters = '<%= l_strNoOfParameters %>';
var l_strParameterIndex = document.getElementById("txtParameterIndex").value;
var l_strParameterLabel = document.getElementById("txtParameterLabel").value;
var l_strParameterType = document.getElementById("txtParameterType").value;
var l_strDefaultValueType = document.getElementById("txtDefaultValueType").value;
var l_strDefaultValue = document.getElementById("txtDefaultValue").value;
var l_strMandatory = document.getElementById("txtMandatory").value;
var l_strAction = "saveParameters";

document.location.replace("<%=contextPath%>/ReportBuilder/jsp/SetReportParameters.jsp?l_strReportID="+l_strReportID+"&l_strNoOfParameters="+l_strNoOfParameters+"&l_strParameterIndex="+l_strParameterIndex+"&l_strParameterLabel="+l_strParameterLabel+"&l_strParameterType="+l_strParameterType+"&l_strDefaultValueType="+l_strDefaultValueType+"&l_strDefaultValue="+l_strDefaultValue+"&l_strMandatory="+l_strMandatory+"&l_strAction="+l_strAction);
}


function openClose()
{
	window.close();
}

function openClear()
{
document.getElementById('txtParameterLabel').value='';
document.getElementById('txtParameterType').value='';
document.getElementById('txtDefaultValueType').value='';
document.getElementById('txtDefaultValue').value='';
document.getElementById('txtMandatory').value='';
}

var l_strSelectedItems = "";
function selectList(strSelectedItem)
{
if(document.getElementById(eval('strSelectedItem')).checked)
   l_strSelectedItems = l_strSelectedItems+strSelectedItem+',';
else
   l_strSelectedItems = l_strSelectedItems.replace(strSelectedItem+',','');
}

function deleteParameters()
{
Ext.MessageBox.confirm('Confirm', "Are&nbsp;you&nbsp;sure&nbsp;to&nbsp;delete?", showResult1);
}

function showResult1(btn)
{
if(btn == "yes")
{
var l_strReportID = '<%= l_strReportID %>';
var l_strNoOfParameters = '<%= l_strNoOfParameters %>';
var l_strParameterIndex=l_strSelectedItems ;
var l_strAction = "deleteParameters";
document.location.replace("<%=contextPath%>/ReportBuilder/jsp/SetReportParameters.jsp?l_strReportID="+l_strReportID+"&l_strNoOfParameters="+l_strNoOfParameters+"&l_strParameterIndex="+l_strParameterIndex+"&l_strAction="+l_strAction);
}
}

function openDelete()
{
Ext.MessageBox.confirm('Confirm', "Are&nbsp;you&nbsp;sure&nbsp;to&nbsp;delete?", showResult2);
}
function showResult2(btn)
{
if(btn == "yes")
{
var l_strReportID = '<%= l_strReportID %>';
var l_strNoOfParameters = '<%= l_strNoOfParameters %>';
var l_strParameterIndex = document.getElementById("txtParameterIndex").value;
var l_strAction = "deleteParameters";
document.location.replace("<%=contextPath%>/ReportBuilder/jsp/SetReportParameters.jsp?l_strReportID="+l_strReportID+"&l_strNoOfParameters="+l_strNoOfParameters+"&l_strParameterIndex="+l_strParameterIndex+"&l_strAction="+l_strAction);
}
}

function listDetails(columnIndex)
{
var l_strReportID = '<%= l_strReportID %>';
var l_strNoOfParameters = '<%= l_strNoOfParameters %>';
var l_strColumnIndex = columnIndex ;
var l_strAction = "showParameterDetails";
document.location.replace("<%=contextPath%>/ReportBuilder/jsp/SetReportParameters.jsp?l_strReportID="+l_strReportID+"&l_strNoOfParameters="+l_strNoOfParameters+"&l_strColumnIndex="+l_strColumnIndex+"&l_strAction="+l_strAction);
}

</script>
<body style="margin: 10px 10px;" >
<script type="text/javascript">
Ext.onReady(function(){
    Ext.QuickTips.init();

	var brnSrch = {
				xtype: 'fieldset',
			    title: '<font color="<%= THEMECOLORNAME %>">Parameter Information</font>',
			    autoHeight: true,
			    animCollapse:'false' ,
				width: '1098',
            	hideMode:'offsets',    
			    collapsible: false,	
			    items:[{
            layout:'column',
            items:[{
                columnWidth:.5,
                layout: 'form',
                items: [{
					width:          50,
					xtype:          'combo',
					mode:           'local',
					triggerAction:  'all',
					forceSelection: true,
					editable:       true,
					fieldLabel: '<font color="<%= THEMECOLORNAME %>">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Parameter Index</font>',
					name:           'txtParameterIndex',
					labelSeparator : '' ,
					hiddenName:     'txtParameterIndex',
					displayField:   'name',
					valueField:     'value',
					anchor:'40%',
					value : '<%= l_HMParamSearchResult == null? "":l_HMParamSearchResult.get("PARAMNAME") %>',
					labelStyle:'width:180px;',
                    store:new Ext.data.JsonStore({
						fields : ['name', 'value'],
						data   : [
							<%for(int i=1; i<=l_intNoOfParameters;i++){%>
							{name : '@param'+'<%=i%>', value: '@param'+'<%=i%>'},
                            <%}%>
							{name : '', value: ''} 
						]
					})
                },{
					width:          50,
					xtype:          'combo',
					mode:           'local',
					triggerAction:  'all',
					forceSelection: true,
					editable:       true,
					fieldLabel: '<font color="<%= THEMECOLORNAME %>">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Parameter Type</font>',
					name:           'txtParameterType',
					labelSeparator : '' ,
					hiddenName:     'txtParameterType',
					displayField:   'name',
					valueField:     'value',
					anchor:'40%',
					value : '<%= l_HMParamSearchResult == null? "":l_HMParamSearchResult.get("PARAMTYPE") %>',
					labelStyle:'width:180px;',
                    store:new Ext.data.JsonStore({
						fields : ['name', 'value'],
						data   : [
							{name : 'Text', value: 'Text'},
							{name : 'Number', value: 'Number'},
							{name : 'Date', value: 'Date'},
							{name : 'Select', value: 'Select'} 
						]
					})
                },{
					width:          50,
					xtype:          'combo',
					mode:           'local',
					triggerAction:  'all',
					forceSelection: true,
					editable:       true,
					fieldLabel: '<font color="<%= THEMECOLORNAME %>">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Mandatory</font>',
					name:           'txtMandatory',
					labelSeparator : '' ,
					hiddenName:     'txtMandatory',
					displayField:   'name',
					valueField:     'value',
					anchor:'40%',
					value : '<%= l_HMParamSearchResult == null? "Y":l_HMParamSearchResult.get("ISMANDATORY") %>',
					labelStyle:'width:180px;',
                    store:new Ext.data.JsonStore({
						fields : ['name', 'value'],
						data   : [
							{name : 'Yes', value: 'Y'},
							{name : 'NO', value: 'N'}
						]
					})
                }]
            },{
                columnWidth:.5,
                layout: 'form',
                items: [{
					xtype: 'textfield',
					fieldLabel: '<font color="<%= THEMECOLORNAME %>">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Parameter Label</font>',
					labelSeparator : '' ,
					name : 'txtParameterLabel',
					labelStyle:'width:220px;',
                    allowBlank: false,
					value : '<%= l_HMParamSearchResult == null? "":l_HMParamSearchResult.get("PARAMALIASNAME") %>',
					anchor:'50%'
				},{
					xtype:'compositefield',
					fieldLabel: '<font color="<%= THEMECOLORNAME %>">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Default value</font>',
					labelSeparator : '' ,
                    name: 'txtDefaultValueMapping',
					labelStyle:'width:220px;',
                    anchor:'70%',
						 items : [
							{
								xtype:          'combo',
								mode:           'local',
								triggerAction:  'all',
								forceSelection: true,
								editable:       true,
								name:           'txtDefaultValueType',
								labelSeparator : '' ,
								hiddenName:     'txtDefaultValueType',
								displayField:   'name',
								valueField:     'value',
								//anchor:'10%',
								width:80,
                                value : '<%= l_HMParamSearchResult == null? "Static":l_HMParamSearchResult.get("DEFAULTVALUETYPE") %>',
								//labelStyle:'width:180px;',
								store:new Ext.data.JsonStore({
									fields : ['name', 'value'],
									data   : [
										{name : 'Static', value: 'Static'},
										{name : 'Query', value: 'Query'}
									]
								})
							},
                            { 
								xtype: 'textarea',
								labelSeparator : '' ,
								name : 'txtDefaultValue',
								//labelStyle:'width:220px;',
								width:200,
                                allowBlank: false,
								value : '<%= l_HMParamSearchResult == null? "":l_HMParamSearchResult.get("DEFAULTVALUE") %>',
								anchor:'30%'
							}                            
                        ]
				}]
            }]
            //}]
        }]
};

var partyDetails = new Ext.FormPanel({
        labelAlign: 'left',
        frame:true,
        //title: 'AddTo List',
        bodyStyle:'padding:5px 5px 0',
		width: '100%',
		items: [brnSrch],
			buttons: [{
            text: 'Save',
			iconCls:'icon-search',
			handler: function(){
			openSave();
		 }
        },{
            text: 'Clear',
			iconCls:'icon-search',
			handler: function(){
			openClear();
		 }
        },{
            text: 'Delete',
			iconCls:'icon-search',
			handler: function(){
			openDelete();
		 }
        },{
            text: 'Close',
			iconCls:'icon-delete',
            handler: function(){
			openClose();
		}
        }]
    });
	partyDetails.render("editorgrid0");

   var checkBoxSelMod = new Ext.grid.CheckboxSelectionModel();

    var Employee = Ext.data.Record.create([
	{
        name: 'ROWPOSITION',
        type: 'number'
    },{
        name: 'CHECKBOX',
        type: 'string'
    },{
        name: 'PARAMETERINDEX',
        type: 'string'
    },{
        name: 'PARAMETERLABEL',
        type: 'string'
    },{
        name: 'PARAMETERTYPE',
        type: 'string'
    },{
        name: 'DEFAULTVALUE',
        type: 'string'
    },{
        name: 'ISMANDATORY',
        type: 'string'
    },{
        name: 'UPDATEDON',
        type: 'string'
    },{
        name: 'UPDATEDBY',
        type: 'string'
    }]);


    // hideous function to generate employee data
    var genData = function(){
        data = [];
        var s = new Date(2007, 0, 1);
        var now = new Date(), i = -1;
		//var l_strNBRRef = "XYZ";
       return data;
    }

	 <%  
	    int l_countvalue = 0;
		String l_strTempNBR = "";
		String l_strAlrtCodeNo =  "";
	    for(int l_intSize = 0; l_intSize < l_ALSearchResult.size();l_intSize++)
	    {
	    l_HMSearchResult = (HashMap) l_ALSearchResult.get(l_intSize);
	    l_strTempNBR = l_HMSearchResult.get("PARAMNAME").toString();
	    String l_strParameIndex = l_HMSearchResult.get("PARAMINDEX").toString();
%>   
       data1[<%= l_intSize%>] = ['<%=l_HMSearchResult.get("ROWPOSITION")%>',"<input type=checkbox name=checkbox id='<%=l_strParameIndex%>' onclick=selectList(\""+'<%=l_strParameIndex%>'+"\")>","<a href=# title='click to view details' onclick=listDetails(\""+'<%=l_strParameIndex%>'+"\")><%=l_strTempNBR%></a>",'<%=l_HMSearchResult.get("PARAMALIASNAME")%>','<%=l_HMSearchResult.get("PARAMTYPE")%>','<%=l_HMSearchResult.get("DEFAULTVALUE")%>','<%=l_HMSearchResult.get("ISMANDATORY")%>','<%=l_HMSearchResult.get("UPDATEDON")%>','<%=l_HMSearchResult.get("UPDATEDBY")%>'];
<%}%>

     // example of custom renderer function
    function change(val){
        if(val > 0){
            return '<span style="color:green;">' + val + '</span>';
        }else if(val < 0){
            return '<span style="color:red;">' + val + '</span>';
        }
        return val;
    }

    // example of custom renderer function
    function pctChange(val){
        if(val > 0){
            return '<span style="color:green;">' + val + '%</span>';
        }else if(val < 0){
            return '<span style="color:red;">' + val + '%</span>';
        }
        return val;
    }

    // create the data store
    var store = new Ext.data.GroupingStore({
        proxy: new Ext.ux.data.PagingMemoryProxy(data1),
        remoteSort:true,
        sortInfo: {field:'ROWPOSITION', direction:'ASC'},
        reader: new Ext.data.ArrayReader({
        fields:Employee 
        })
    });

// create the Grid
    var grid = new Ext.grid.GridPanel({
        store: store,
        columns: [
        //new Ext.grid.RowNumberer(),
        {
            id:'ROWPOSITION',
			header: ' ',
            dataIndex: 'ROWPOSITION',
            width: 25
        },{
				header: ' ',//<B><input type="checkbox" name="checkbox" id="checkbox" ></B>',
				dataIndex: 'CHECKBOX',
				width: 40,
				sortable: true,
				editor: {
				xtype: 'textfield',
				allowBlank: true
            }
        },{
            id: 'PARAMETERINDEX',
            header: '<B>Parameter Index</B>',
            dataIndex: 'PARAMETERINDEX',
            width: 120,
            sortable: true,
            editor: {
                xtype: 'textfield',
                allowBlank: false
            }
        },{
            header: '<B>Parameter Label</B>',
            dataIndex: 'PARAMETERLABEL',
            width: 150,
            sortable: true,
            editor: {
                xtype: 'textfield',
                allowBlank: false
            }
        },{
            header: '<B>Parameter Type</B>',
            dataIndex: 'PARAMETERTYPE',
            width: 120,
            sortable: true,
            editor: {
                xtype: 'textfield',
                allowBlank: false
            }
        },{
            header: '<B>Default Value</B>',
            dataIndex: 'DEFAULTVALUE',
            width: 300,
            sortable: true,
            editor: {
                xtype: 'textfield',
                allowBlank: false
            }
        },{
            header: '<B>Mandatory</B>',
            dataIndex: 'ISMANDATORY',
            width: 100,
            sortable: true,
            editor: {
                xtype: 'textfield',
                allowBlank: false
            }
        },{
            header: '<B>UpdatedOn</B>',
            dataIndex: 'UPDATEDON',
            width: 120,
            sortable: true,
            editor: {
                xtype: 'textfield',
                allowBlank: false
            }
        },{
            header: '<B>UpdatedBy</B>',
            dataIndex: 'UPDATEDBY',
            width: 120,
            sortable: true,
            editor: {
                xtype: 'textfield',
                allowBlank: false
            }
        }],
        stripeRows: true,
        //autoExpandColumn: 'ALERTCODE',
        height:330,
        width:'100%',
        frame:true,
        //title: 'FalsePositive Lists',
        plugins: new Ext.ux.PanelResizer({
            minHeight: 100
        }),rowNumberer : function(value, p, record) {
		var ds = record.store
		var i = ds.lastOptions.params.start
		if (isNaN(i)) {
			i = 0;
		}
		return ds.indexOf(record)+i+1
	},
        view: new Ext.grid.GroupingView({
            markDirty: false
        }), 
        bbar: new Ext.PagingToolbar({
            pageSize: 30,
            store: store,
            displayInfo: true,

            plugins: new Ext.ux.ProgressBarPager()
        }),
		buttons: [{
            text: 'Delete',
			iconCls:'icon-delete',
            handler: function(){
			deleteParameters();
		}
        },{
            text: 'Close',
			iconCls:'icon-delete',
            handler: function(){
			openClose();
		}
        }]
    });

    grid.render('editorgrid0');

    store.load({params:{start:0, limit:15}});

	 grid.getSelectionModel().on('selectionchange', function(sm)
	{
		 var record = grid.getStore().getAt(1);
        
        //grid.removeBtn.setDisabled(sm.getCount() < 1);
    });
grid.on('rowclick', function(grid, rowIndex, e) {
var record = grid.getStore().getAt(rowIndex);
l_strSelectedItemToDelete = record.data['PARAMETERINDEX'];
});
});

	
</script>

<div id="editorgrid0"  class="absolute0"></div> 

</body>
</html>
