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
String builtCondition=request.getParameter("builtCondition");
String l_strReportName=request.getParameter("l_strReportName");

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

ArrayList l_ALTableList  = new ArrayList();
ArrayList transactionColumns = new ArrayList();
ArrayList customerColumns = new ArrayList();
ArrayList accountsColumns = new ArrayList();
		
Connection conn = null;
PreparedStatement uStmt = null;
ResultSet rs = null;
String queryString = "";
int countVal = 0;
int l_intColumnCount = 0;
try {
DriverManager.registerDriver(new OracleDriver());
conn = DatabaseConnectionFactory.getConnection("COMPAML");
//if(builtCondition.indexOf("TB_TRANSACTIONS") > -1)
//{
l_ALTableList.add("TB_TRANSACTIONS");
uStmt = conn.prepareStatement("SELECT COLUMN_NAME FROM USER_TAB_COLUMNS WHERE TABLE_NAME = 'TB_TRANSACTIONS' ORDER BY COLUMN_ID ");
rs = uStmt.executeQuery();
while (rs.next()) {
	transactionColumns.add(rs.getString("COLUMN_NAME"));
}
//}
//if(builtCondition.indexOf("TB_CUSTOMERMASTER") > -1)
//{
l_ALTableList.add("TB_CUSTOMERMASTER");
rs=null;
uStmt = conn.prepareStatement("SELECT COLUMN_NAME FROM USER_TAB_COLUMNS WHERE TABLE_NAME = 'TB_CUSTOMERMASTER' ORDER BY COLUMN_ID ");
rs = uStmt.executeQuery();
while (rs.next()) {
	customerColumns.add(rs.getString("COLUMN_NAME"));
}
//}
//if(builtCondition.indexOf("TB_ACCOUNTSMASTER") > -1)
//{
l_ALTableList.add("TB_ACCOUNTSMASTER");
rs=null;
uStmt = conn.prepareStatement("SELECT COLUMN_NAME FROM USER_TAB_COLUMNS WHERE TABLE_NAME = 'TB_ACCOUNTSMASTER' ORDER BY COLUMN_ID ");
rs = uStmt.executeQuery();
while (rs.next()) {
	accountsColumns.add(rs.getString("COLUMN_NAME"));
}
//}

if(l_strAction.equals("saveParameters")) {
String l_strColumnIndex = (String) request.getParameter("l_strColumnIndex");
String l_strColumnName = (String) request.getParameter("l_strColumnName");
String l_strColumnAliasName = (String) request.getParameter("l_strColumnAliasName");
String l_strDefaultValue = (String) request.getParameter("l_strDefaultValue");
String l_strTableName = (String) request.getParameter("l_strTableName");
String l_strTableColumnName = (String) request.getParameter("l_strTableColumnName");
String l_strDefaultValueType = "Static";
rs=null;
queryString = " SELECT COUNT(*) COUNTVAL "+
	          "   FROM TB_REPORTBUILDERCOLUMNS "+
			  "  WHERE REPORTID = '"+l_strReportID+"' "+
			  "    AND COLUMNINDEX = '"+l_strColumnIndex+"' ";
uStmt = conn.prepareStatement(queryString);
rs = uStmt.executeQuery();
while (rs.next()) 
  countVal = rs.getInt("COUNTVAL");

if(countVal == 0)
	queryString = " INSERT INTO TB_REPORTBUILDERCOLUMNS ( REPORTID, COLUMNINDEX, COLUMNNAME, "+
			      "       COLUMNALIASNAME, DEFAULTVALUETYPE, DEFAULTVALUE, TABLE_NAME, TABLE_COLUMN_NAME, "+
			      "       UPDATEDDATE, UPDATEDBY) "+ 
			      "  VALUES( '"+l_strReportID+"', '"+l_strColumnIndex+"', '"+l_strColumnName+"', "+
	              "  '"+l_strColumnAliasName+"', '"+l_strDefaultValueType+"', '"+l_strDefaultValue+"', '"+l_strTableName+"', '"+l_strTableColumnName+"', "+
	              "  SYSTIMESTAMP, '"+LOGGEDUSER+"' ) ";
else
	queryString = " UPDATE TB_REPORTBUILDERCOLUMNS SET COLUMNNAME = '"+l_strColumnName+"', "+
	              "       COLUMNALIASNAME = '"+l_strColumnAliasName+"', DEFAULTVALUE = '"+l_strDefaultValue+"', "+
	              "       TABLE_NAME = '"+l_strTableName+"' , TABLE_COLUMN_NAME = '"+l_strTableColumnName+"' , "+
	              "       UPDATEDDATE = SYSTIMESTAMP, UPDATEDBY = '"+LOGGEDUSER+"' "+
                  " WHERE REPORTID =  '"+l_strReportID+"' AND COLUMNINDEX = '"+l_strColumnIndex+"' ";
uStmt = conn.prepareStatement(queryString);
uStmt.executeUpdate();
}
else if(l_strAction.equals("deleteParameters")) {
String l_strColumnIndex = (String) request.getParameter("l_strColumnIndex");
if(l_strColumnIndex != null && l_strColumnIndex.indexOf(",") >= 0)
  l_strColumnIndex = l_strColumnIndex.substring(0, l_strColumnIndex.length()-1);

queryString = " DELETE FROM TB_REPORTBUILDERCOLUMNS "+
			  " WHERE REPORTID =  '"+l_strReportID+"' AND COLUMNINDEX IN ("+l_strColumnIndex+") ";

//System.out.println("queryString : "+queryString);
uStmt = conn.prepareStatement(queryString);
uStmt.executeUpdate();

queryString = " UPDATE TB_REPORTBUILDERCOLUMNS SET COLUMNINDEX = ROWNUM WHERE REPORTID =  '"+l_strReportID+"' ";

//System.out.println("queryString : "+queryString);
uStmt = conn.prepareStatement(queryString);
uStmt.executeUpdate();

}
else if(l_strAction.equals("showParameterDetails")) {
String l_strColumnIndex = (String) request.getParameter("l_strColumnIndex");
rs=null;
queryString = "SELECT COLUMNINDEX, COLUMNNAME, COLUMNALIASNAME, DEFAULTVALUE, TABLE_NAME, TABLE_COLUMN_NAME "+ 
			  "  FROM TB_REPORTBUILDERCOLUMNS A "+
			  " WHERE REPORTID = '"+l_strReportID+"' AND COLUMNINDEX = '"+l_strColumnIndex+"' ";
uStmt = conn.prepareStatement(queryString);
rs = uStmt.executeQuery();
while (rs.next()) {
l_HMParamSearchResult = new HashMap();
l_HMParamSearchResult.put("COLUMNINDEX",rs.getString("COLUMNINDEX"));
l_HMParamSearchResult.put("COLUMNNAME",rs.getString("COLUMNNAME"));
l_HMParamSearchResult.put("COLUMNALIASNAME",rs.getString("COLUMNALIASNAME"));
l_HMParamSearchResult.put("DEFAULTVALUE",rs.getString("DEFAULTVALUE"));
l_HMParamSearchResult.put("TABLE_NAME",rs.getString("TABLE_NAME"));
l_HMParamSearchResult.put("TABLE_COLUMN_NAME",rs.getString("TABLE_COLUMN_NAME"));
}
}

rs=null;
queryString = "SELECT ROWNUM AS ROWPOSITION, A.* FROM (SELECT REPORTID, COLUMNINDEX, COLUMNNAME, TABLE_NAME, "+
	          "       TABLE_COLUMN_NAME, COLUMNALIASNAME, COLUMNTYPE, DEFAULTVALUETYPE, DEFAULTVALUE, ISMANDATORY, "+
			  "       TO_CHAR(UPDATEDDATE,'DD-MON-YYYY') UPDATEDON, UPDATEDBY UPDATEDBY "+ 
			  "  FROM TB_REPORTBUILDERCOLUMNS A "+
			  " WHERE REPORTID = '"+l_strReportID+"' ORDER BY COLUMNINDEX) A ";

//System.out.println("queryString		"+queryString);
uStmt = conn.prepareStatement(queryString);
rs = uStmt.executeQuery();
while (rs.next()) 
{
l_HMSearchResult = new HashMap();
l_HMSearchResult.put("ROWPOSITION",rs.getString("ROWPOSITION"));
l_HMSearchResult.put("REPORTID",rs.getString("REPORTID"));
l_HMSearchResult.put("COLUMNINDEX",rs.getString("COLUMNINDEX"));
l_HMSearchResult.put("COLUMNNAME",rs.getString("COLUMNNAME"));
l_HMSearchResult.put("TABLE_NAME",rs.getString("TABLE_NAME"));
l_HMSearchResult.put("TABLE_COLUMN_NAME",rs.getString("TABLE_COLUMN_NAME"));
l_HMSearchResult.put("COLUMNALIASNAME",rs.getString("COLUMNALIASNAME"));
l_HMSearchResult.put("COLUMNTYPE",rs.getString("COLUMNTYPE"));
l_HMSearchResult.put("DEFAULTVALUETYPE",rs.getString("DEFAULTVALUETYPE"));
l_HMSearchResult.put("DEFAULTVALUE",rs.getString("DEFAULTVALUE"));
l_HMSearchResult.put("ISMANDATORY",rs.getString("ISMANDATORY"));
l_HMSearchResult.put("UPDATEDON",rs.getString("UPDATEDON"));
l_HMSearchResult.put("UPDATEDBY",rs.getString("UPDATEDBY"));
l_ALSearchResult.add(l_HMSearchResult);
}

rs=null;
uStmt = conn.prepareStatement("SELECT COUNT(*) AS COLUMN_COUNT FROM TB_REPORTBUILDERCOLUMNS WHERE REPORTID = '"+l_strReportID+"' ");
rs = uStmt.executeQuery();
while (rs.next()) 
	l_intColumnCount = rs.getInt("COLUMN_COUNT")+1;


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
<TITLE>Set Report Columns</TITLE>
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
	left: 10px;
}

.modal-header {
	flex-direction: row-reverse;
}

.xtrSmlButton {
	padding: 1px 5px;
	font-size: 12px;
}

.table td {
	padding: 8px;
}

.x-grid3 .x-window-ml {
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
	padding: 0;
	overflow: text;
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
	padding: 0;
}

.x-grid3 .x-card-btns td.x-toolbar-cell {
	padding: 3px 3px 0;
}

.x-box-inner {
	zoom: 1;
}

.icon-user-add {
	background-image:
		url(<%=contextPath%>/ext-3.2.1/examples/shared/icons/fam/user_add.gif)
		!important;
}

.icon-user-delete {
	background-image:
		url(<%=contextPath%>/ext-3.2.1/examples/shared/icons/fam/user_delete.gif)
		!important;
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
	background-image: url(/images/icons_ext/copy_from_existing.gif)
		!important;
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
	background-image: url(/images/icons_ext/copy_from_existing.gif)
		!important;
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
var builtCondition = '';
var l_strColumnIndex = document.getElementById("txtColumnIndex").value;
var l_strDefaultValue = document.getElementById("txtDefaultValue").value;
var l_strColumnName = document.getElementById("txtColumnName").value;
var l_strColumnAliasName = document.getElementById("txtColumnAliasName").value;
var l_strTableName = document.getElementById("txtTableName").value;
var l_strTableColumnName = document.getElementById("txtEmptTableColumnName").value;
if(l_strTableName == 'TB_TRANSACTIONS')
	l_strTableColumnName = document.getElementById("txtTranTableColumnName").value;
else if(l_strTableName == 'TB_CUSTOMERMASTER')
	l_strTableColumnName = document.getElementById("txtCustTableColumnName").value;
else if(l_strTableName == 'TB_ACCOUNTSMASTER')
	l_strTableColumnName = document.getElementById("txtAcctTableColumnName").value;
var l_strAction = "saveParameters";
document.location.replace("<%=contextPath%>/ReportBuilder/jsp/SetReportColumns.jsp?l_strReportID="+l_strReportID+"&l_strNoOfParameters="+l_strNoOfParameters+"&builtCondition="+builtCondition+"&l_strColumnIndex="+l_strColumnIndex+"&l_strDefaultValue="+l_strDefaultValue+"&l_strColumnName="+l_strColumnName+"&l_strColumnAliasName="+l_strColumnAliasName+"&l_strTableName="+l_strTableName+"&l_strTableColumnName="+l_strTableColumnName+"&l_strAction="+l_strAction);
}

function openClose()
{
	window.close();
}

function openClear()
{
document.getElementById('txtColumnIndex').value='';
document.getElementById('txtDefaultValue').value='';
document.getElementById('txtColumnName').value='';
document.getElementById('txtColumnAliasName').value='';
document.getElementById('txtTableName').value='';
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
var builtCondition = "<%= builtCondition %>";
var l_strColumnIndex=l_strSelectedItems ;
var l_strAction = "deleteParameters";
document.location.replace("<%=contextPath%>/ReportBuilder/jsp/SetReportColumns.jsp?l_strReportID="+l_strReportID+"&l_strNoOfParameters="+l_strNoOfParameters+"&builtCondition="+builtCondition+"&l_strColumnIndex="+l_strColumnIndex+"&l_strAction="+l_strAction);
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
var builtCondition = "<%= builtCondition %>";
var l_strColumnIndex = document.getElementById("txtColumnIndex").value;
var l_strAction = "deleteParameters";
document.location.replace("<%=contextPath%>/ReportBuilder/jsp/SetReportColumns.jsp?l_strReportID="+l_strReportID+"&l_strNoOfParameters="+l_strNoOfParameters+"&builtCondition="+builtCondition+"&l_strColumnIndex="+l_strColumnIndex+"&l_strAction="+l_strAction);
}
}

function listDetails(columnIndex)
{
var l_strReportID = '<%= l_strReportID %>';
var l_strNoOfParameters = '<%= l_strNoOfParameters %>';
var builtCondition = "<%= builtCondition %>";
var l_strColumnIndex = columnIndex ;
var l_strAction = "showParameterDetails";
document.location.replace("<%=contextPath%>/ReportBuilder/jsp/SetReportColumns.jsp?l_strReportID="+l_strReportID+"&l_strNoOfParameters="+l_strNoOfParameters+"&builtCondition="+builtCondition+"&l_strColumnIndex="+l_strColumnIndex+"&l_strAction="+l_strAction);
}

</script>
<body style="margin: 10px 10px;" >
<script type="text/javascript">
Ext.override(Ext.form.Field, { 
    showContainer: function() { 
	
        this.enable(); 
        this.show(); 
        this.getEl().up('.x-form-item').setDisplayed(true); // show entire container and children (including label if applicable) 
    }, 
     
    hideContainer: function() { 
        this.disable(); // for validation 
        this.hide(); 
        this.getEl().up('.x-form-item').setDisplayed(false); // hide container and children (including label if applicable) 
    }, 
     
    setContainerVisible: function(visible) { 
			//alert("inside");
        if (visible) { 
            this.showContainer(); 
        } else { 
            this.hideContainer(); 
        } 
        return this; 
    } 
});  


Ext.onReady(function(){
    Ext.QuickTips.init();

	var tranColumnsName =  new Ext.form.ComboBox({
					//width:          150,
					//xtype:          'combo',
					fieldLabel: '<font color="<%= THEMECOLORNAME %>">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;TableColumn Name</font>',
					mode:           'local',
					labelSeparator : '' ,
					triggerAction:  'all',
					forceSelection: true,
					editable:       true,
					//fieldLabel:     'Branch Code',
					name:           'txtTranTableColumnName',
					hiddenName :    'txtTranTableColumnName',
					displayField:   'name',
					valueField:     'value',
                    anchor:'50%',
					//emptyText:'ALL',
					labelStyle:'width:180px;',
					value : '<%= l_HMParamSearchResult == null? "":l_HMParamSearchResult.get("TABLE_COLUMN_NAME") %>',
					store:new Ext.data.JsonStore({
						fields : ['name', 'value'],
						data   : [
							<%for(int i =0; i<transactionColumns.size();i++){%>
								{name : '<%=transactionColumns.get(i)%>', value: '<%=transactionColumns.get(i)%>'},
							<%}%>
							{name : '', value: ''}
						]
					})				
				});

	var custColumnsName =  new Ext.form.ComboBox({
					//width:          150,
					//xtype:          'combo',
					fieldLabel: '<font color="<%= THEMECOLORNAME %>">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;TableColumn Name</font>',
					mode:           'local',
					labelSeparator : '' ,
					triggerAction:  'all',
					forceSelection: true,
					editable:       true,
					//fieldLabel:     'Branch Code',
					name:           'txtCustTableColumnName',
					hiddenName :    'txtCustTableColumnName',
					displayField:   'name',
					valueField:     'value',
                    anchor:'50%',
					//emptyText:'ALL',
					labelStyle:'width:180px;',
					value : '<%= l_HMParamSearchResult == null? "":l_HMParamSearchResult.get("TABLE_COLUMN_NAME") %>',
					store:new Ext.data.JsonStore({
						fields : ['name', 'value'],
						data   : [
							<%for(int i =0; i<customerColumns.size();i++){%>
								{name : '<%=customerColumns.get(i)%>', value: '<%=customerColumns.get(i)%>'},
							<%}%>
							{name : '', value: ''}
						]
					})				
				});

	var acctColumnsName =  new Ext.form.ComboBox({
					//width:          150,
					//xtype:          'combo',
					fieldLabel: '<font color="<%= THEMECOLORNAME %>">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;TableColumn Name</font>',
					mode:           'local',
					triggerAction:  'all',
					labelSeparator : '' ,
					forceSelection: true,
					editable:       true,
					//fieldLabel:     'Branch Code',
					name:           'txtAcctTableColumnName',
					hiddenName :    'txtAcctTableColumnName',
					displayField:   'name',
					valueField:     'value',
                    anchor:'50%',
					//emptyText:'ALL',
					labelStyle:'width:180px;',
					value : '<%= l_HMParamSearchResult == null? "":l_HMParamSearchResult.get("TABLE_COLUMN_NAME") %>',
					store:new Ext.data.JsonStore({
						fields : ['name', 'value'],
						data   : [
							<%for(int i =0; i<accountsColumns.size();i++){%>
								{name : '<%=accountsColumns.get(i)%>', value: '<%=accountsColumns.get(i)%>'},
							<%}%>
							{name : '', value: ''}
						]
					})				
				});

	var emptColumnsName =  new Ext.form.ComboBox({
					//width:          150,
					//xtype:          'combo',
					fieldLabel: '<font color="<%= THEMECOLORNAME %>">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;TableColumn Name</font>',
					mode:           'local',
					labelSeparator : '' ,
					triggerAction:  'all',
					forceSelection: true,
					editable:       true,
					//fieldLabel:     'Branch Code',
					name:           'txtEmptTableColumnName',
					hiddenName :    'txtEmptTableColumnName',
					displayField:   'name',
					valueField:     'value',
                    anchor:'50%',
					//emptyText:'ALL',
					labelStyle:'width:180px;',
					value : '<%= l_HMParamSearchResult == null? "":l_HMParamSearchResult.get("TABLE_COLUMN_NAME") %>',
					store:new Ext.data.JsonStore({
						fields : ['name', 'value'],
						data   : [
							{name : '', value: ''}
						]
					})				
				});

	var brnSrch = {
				xtype: 'fieldset',
			    title: '<font color="<%= THEMECOLORNAME %>">Columns Information</font>',
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
					fieldLabel: '<font color="<%= THEMECOLORNAME %>">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Column Index</font>',
					name:           'txtColumnIndex',
					labelSeparator : '' ,
					hiddenName:     'txtColumnIndex',
					displayField:   'name',
					valueField:     'value',
					anchor:'40%',
					value : '<%= l_HMParamSearchResult == null? "":l_HMParamSearchResult.get("COLUMNINDEX") %>',
					labelStyle:'width:180px;',
                    store:new Ext.data.JsonStore({
						fields : ['name', 'value'],
						data   : [
							<%for(int i=l_intColumnCount; i<=l_intColumnCount;i++){%>
							{name : '<%=i%>', value: '<%=i%>'},
                            <%}%>
							{name : '', value: ''} 
						]
					})
                },{
					xtype: 'textfield',
					fieldLabel: '<font color="<%= THEMECOLORNAME %>">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Column Name</font>',
					labelSeparator : '' ,
					name : 'txtColumnName',
					labelStyle:'width:180px;',
                    allowBlank: false,
					value : '<%= l_HMParamSearchResult == null? "":l_HMParamSearchResult.get("COLUMNNAME") %>',
					anchor:'50%'
				},{
					xtype:          'combo',
					fieldLabel: '<font color="<%= THEMECOLORNAME %>">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Table Name</font>',
					mode:           'local',
					triggerAction:  'all',
					forceSelection: true,
					editable:       true,
					name:           'txtTableName',
					labelSeparator : '' ,
					hiddenName:     'txtTableName',
					displayField:   'name',
					valueField:     'value',
					//anchor:'40%',
					width:140,
					value : '<%= l_HMParamSearchResult == null? "":l_HMParamSearchResult.get("TABLE_NAME") %>',
					labelStyle:'width:180px;',
					store:new Ext.data.JsonStore({
						fields : ['name', 'value'],
						data   : [
							<%for(int i=0; i<l_ALTableList.size();i++){%>
							{name : '<%=l_ALTableList.get(i)%>', value: '<%=l_ALTableList.get(i)%>'},
							<%}%>
							{name : '', value: ''}
						]
					}),
					 selectOnFocus: true,
					 listeners:{
						scope: 'globle',
						select:function(){		
							var code = document.getElementById("txtTableName").value;
							if(code == "TB_TRANSACTIONS"){
								emptColumnsName.setContainerVisible(false);
								custColumnsName.setContainerVisible(false);
								acctColumnsName.setContainerVisible(false);
								tranColumnsName.setContainerVisible(true);
								}
							else if(code == "TB_CUSTOMERMASTER"){
								emptColumnsName.setContainerVisible(false);
								tranColumnsName.setContainerVisible(false);
								acctColumnsName.setContainerVisible(false);
								custColumnsName.setContainerVisible(true);
								}
							else if(code == "TB_ACCOUNTSMASTER"){
								emptColumnsName.setContainerVisible(false);
								tranColumnsName.setContainerVisible(false);
								custColumnsName.setContainerVisible(false);
								acctColumnsName.setContainerVisible(true);
								}
							}
							}
					}]
            },{
                columnWidth:.5,
                layout: 'form',
                items: [{ 
					xtype: 'textfield',
					fieldLabel: '<font color="<%= THEMECOLORNAME %>">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Default Value</font>',
					labelSeparator : '' ,
					name : 'txtDefaultValue',
					labelStyle:'width:180px;',
					allowBlank: false,
					value : '<%= l_HMParamSearchResult == null? "":l_HMParamSearchResult.get("DEFAULTVALUE") %>',
					anchor:'50%'
				},{
					xtype: 'textfield',
					fieldLabel: '<font color="<%= THEMECOLORNAME %>">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Column AliasName</font>',
					labelSeparator : '' ,
					name : 'txtColumnAliasName',
					labelStyle:'width:180px;',
                    allowBlank: false,
					value : '<%= l_HMParamSearchResult == null? "":l_HMParamSearchResult.get("COLUMNALIASNAME") %>',
					anchor:'50%'
				},emptColumnsName,tranColumnsName,custColumnsName,acctColumnsName]
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
	/*emptColumnsName.setContainerVisible(false);
	custColumnsName.setContainerVisible(false);
	acctColumnsName.setContainerVisible(false);
	tranColumnsName.setContainerVisible(true);
	*/
	//var tabName = '<%= l_HMParamSearchResult == null ? "":l_HMParamSearchResult.get("TABLE_NAME") %>';
	var tabName = document.getElementById("txtTableName").value;
	if(tabName == "TB_TRANSACTIONS"){
		emptColumnsName.setContainerVisible(false);
		custColumnsName.setContainerVisible(false);
		acctColumnsName.setContainerVisible(false);
		tranColumnsName.setContainerVisible(true);
	}
	else if(tabName == "TB_CUSTOMERMASTER"){
		emptColumnsName.setContainerVisible(false);
		tranColumnsName.setContainerVisible(false);
		acctColumnsName.setContainerVisible(false);
		custColumnsName.setContainerVisible(true);
	}
	else if(tabName == "TB_ACCOUNTSMASTER"){
		emptColumnsName.setContainerVisible(false);
		tranColumnsName.setContainerVisible(false);
		custColumnsName.setContainerVisible(false);
		acctColumnsName.setContainerVisible(true);
	}
	else {
		tranColumnsName.setContainerVisible(false);
		custColumnsName.setContainerVisible(false);
		acctColumnsName.setContainerVisible(false);
		emptColumnsName.setContainerVisible(true);
	};
	
   var checkBoxSelMod = new Ext.grid.CheckboxSelectionModel();

    var Employee = Ext.data.Record.create([
	{
        name: 'ROWPOSITION',
        type: 'number'
    },{
        name: 'CHECKBOX',
        type: 'string'
    },{
        name: 'COLUMNINDEX',
        type: 'string'
    },{
        name: 'COLUMNNAME',
        type: 'string'
    },{
        name: 'COLUMNALIASNAME',
        type: 'string'
    },{
        name: 'DEFAULTVALUE',
        type: 'string'
    },{
        name: 'TABLENAME',
        type: 'string'
    },{
        name: 'TABLECOLUMNNAME',
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
	    l_strTempNBR = l_HMSearchResult.get("COLUMNINDEX").toString();
	    String l_strParameIndex = l_HMSearchResult.get("COLUMNINDEX").toString();
%>   
       data1[<%= l_intSize%>] = ['<%=l_HMSearchResult.get("ROWPOSITION")%>',"<input type=checkbox name=checkbox id='<%=l_strParameIndex%>' onclick=selectList(\""+'<%=l_strParameIndex%>'+"\")>","<a href=# title='click to view details' onclick=listDetails(\""+'<%=l_strParameIndex%>'+"\")><%=l_strTempNBR%></a>",'<%=l_HMSearchResult.get("COLUMNNAME")%>','<%=l_HMSearchResult.get("COLUMNALIASNAME")%>','<%=l_HMSearchResult.get("DEFAULTVALUE")%>','<%=l_HMSearchResult.get("TABLE_NAME")%>','<%=l_HMSearchResult.get("TABLE_COLUMN_NAME")%>','<%=l_HMSearchResult.get("UPDATEDON")%>','<%=l_HMSearchResult.get("UPDATEDBY")%>'];
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
            id: 'COLUMNINDEX',
            header: '<B>Column Index</B>',
            dataIndex: 'COLUMNINDEX',
            width: 100,
            sortable: true,
            editor: {
                xtype: 'textfield',
                allowBlank: false
            }
        },{
            header: '<B>Column Name</B>',
            dataIndex: 'COLUMNNAME',
            width: 130,
            sortable: true,
            editor: {
                xtype: 'textfield',
                allowBlank: false
            }
        },{
            header: '<B>Alias Name</B>',
            dataIndex: 'COLUMNALIASNAME',
            width: 120,
            sortable: true,
            editor: {
                xtype: 'textfield',
                allowBlank: false
            }
        },{
            header: '<B>Default Value</B>',
            dataIndex: 'DEFAULTVALUE',
            width: 200,
            sortable: true,
            editor: {
                xtype: 'textfield',
                allowBlank: false
            }
        },{
            header: '<B>Table Name</B>',
            dataIndex: 'TABLENAME',
            width: 140,
            sortable: true,
            editor: {
                xtype: 'textfield',
                allowBlank: false
            }
        },{
            header: '<B>Table_Column_Name</B>',
            dataIndex: 'TABLECOLUMNNAME',
            width: 150,
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
l_strSelectedItemToDelete = record.data['COLUMNINDEX'];
});
});

	
</script>

<div id="editorgrid0"  class="absolute0"></div> 

</body>
</html>
