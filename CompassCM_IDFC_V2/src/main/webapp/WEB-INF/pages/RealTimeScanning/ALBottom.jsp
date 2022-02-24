<%@ page import="java.io.*,java.sql.*,java.util.*,java.sql.ResultSet,java.text.*,java.text.SimpleDateFormat" %>
<%@ page import ="com.quantumdataengines.main.utils.DatabaseConnectionFactory" %>
<%
String THEMEFILENAME = session.getAttribute("THEMEFILENAME") == null ? System.getProperty("THEMEFILENAME"):session.getAttribute("THEMEFILENAME").toString();
String THEMECOLORNAME = session.getAttribute("THEMECOLORNAME") == null ? System.getProperty("THEMECOLORNAME"):session.getAttribute("THEMECOLORNAME").toString();      
String contextPath = request.getContextPath()==null?"":request.getContextPath();
%>
<%
int i,j;

HashMap l_HMReportData = request.getAttribute("Records") == null ? new HashMap():(HashMap)request.getAttribute("Records");
int intCountOfRecords = request.getAttribute("Records") == null ? 0:Integer.parseInt(((HashMap)request.getAttribute("Records")).get("TotalRecords").toString());
int counter = request.getAttribute("counter") == null ? 0 : Integer.parseInt((String)request.getAttribute("counter"));
String FileName = request.getAttribute("filename") == null ? null : (String)request.getAttribute("filename");
String FileImport = request.getAttribute("FileImport") == null ? null : (String)request.getAttribute("FileImport");
String UserCode = request.getAttribute("UserCode") == null ? "ALL" : (String)request.getAttribute("UserCode");

ArrayList list = (ArrayList)l_HMReportData.get("ReportData");
String[] l_Headers = (String[])l_HMReportData.get("Header");
//System.out.println("l_Headers  "+l_Headers.length);
String builtCondition = (String)request.getAttribute("builtCondition");
StringBuffer sb=new StringBuffer("[");
int listSize=list.size();
String strFirstString = "";
//String LOGGEDUSER = session.getAttribute("LOGGEDUSER").toString();
String LOGGEDUSER = request.getParameter("LOGGEDUSER") == null ? "AMLUser":(String)request.getParameter("LOGGEDUSER");
String TERMINALID = request.getRemoteAddr();
%>


<html>
<TITLE>Bottom Frame</TITLE>
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

<style type="text/css">
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
		.icon-delete {
            background-image: url(/images/icons_ext/delete.gif) !important;
        }      
  </style>
<style type="text/css">
.absolute {
 position: absolute;
 top: 360px;
}
.absolute0 {
 position: absolute;
 top:2px;
 left:0px;
}

    </style>
<body style="margin: 10px 10px;" >
<script>

var data = [];
var grid;
var Temparr = new Array();
var Perarr = new Array();
var l_strSelectedItemToDelete = "";
var data1=new Array();
function openCustDetails(strval)
{ 
	var RequestType = '';
	var mywin = window.open("<%=contextPath%>/CustomerMaster/Search/CustomerDetails.jsp?l_strCustomerId="+strval+"&RequestType="+RequestType,'','height=600,width=1250,resizable=No');
	mywin.moveTo(10,02);
}
function openAcctDetails(strval)
{ 
	var RequestType = '';
	var mywin = window.open("<%=contextPath%>/AccountsMaster/Search/AccountDetails.jsp?l_strAccountNo="+strval+"&RequestType="+RequestType,'','height=600,width=1250,resizable=No');
	mywin.moveTo(10,02);
}
function openTranItem(strval)
{ 
	l_strSelectedItemToDelete = strval;
	//alert('openInvoiceSerachPage  '+l_strSelectedItemToDelete);
	var record = grid.getStore().getAt(0);
	//alert(record.data['SELECTITEM'].checked);
	
}

</script>
<script type="text/javascript">
Ext.onReady(function(){
    Ext.QuickTips.init();

   var checkBoxSelMod = new Ext.grid.CheckboxSelectionModel();

    var Employee = Ext.data.Record.create([
    <%
	  for(i=0; i<l_Headers.length; i++)
	  {
      if(i == 0){ strFirstString = l_Headers[i];
	%>
	  {
        name: '<%=l_Headers[i]%>',
        type: 'string'
	  }
    <% } else { %>
      ,{
        name: '<%=l_Headers[i]%>',
        type: 'string'
	  }
	<% } } %>
	]);


    // hideous function to generate employee data
    var genData = function(){
        data = [];
        var s = new Date(2007, 0, 1);
        var now = new Date(), i = -1;
		return data;
    }

	 <%  
	    String l_strTempNBR = "";
		int l_countvalue = 0;
        for(i=0;i<listSize;i++)
	    {
        HashMap rowdata=(HashMap)list.get(i);
	%>   
       data1[<%= i%>] = [
	<%
		for(j=0; j<l_Headers.length;j++)
		{
		  String rowVal=(String)rowdata.get(l_Headers[j]);
		  if(j == 0) {
	%>
		'<%=rowVal%>'
	<% } else { %>
		,'<%=rowVal%>'
    <% } } %>
	];
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
        sortInfo: {field:'PROCESSEDDATE', direction:'DESC'},
        reader: new Ext.data.ArrayReader({
        fields:Employee 
        })
    });

// create the Grid
    var grid = new Ext.grid.GridPanel({
        store: store,
        columns: [
        new Ext.grid.RowNumberer(),
	<%
      int columnLength = 1280/l_Headers.length;
      //System.out.println("columnLength  "+columnLength);
	  for(i=0; i<l_Headers.length; i++)
	  {
      if(i == 0){ //strFirstString = l_Headers[i];
	%>
	  {
            id: '<%=l_Headers[i]%>',
            header: '<B><%=l_Headers[i]%></B>',
            dataIndex: '<%=l_Headers[i]%>',
            width: <%= columnLength %>,
            sortable: true,
            editor: {
                xtype: 'textfield',
                allowBlank: false
            }
        }  
	<% } else { %>
      ,{
            id: '<%=l_Headers[i]%>',
            header: '<B><%=l_Headers[i]%></B>',
            dataIndex: '<%=l_Headers[i]%>',
            width: <%= columnLength %>,
            sortable: true,
            editor: {
                xtype: 'textfield',
                allowBlank: false
            }
        }
	<% } } %>
		],
        stripeRows: true,
        autoExpandColumn: '<%= strFirstString %>',
        height:500,
        width:1320,
        frame:true,
        title: 'Audit Log Data',
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
            pageSize: 20,
            store: store,
            displayInfo: true,

            plugins: new Ext.ux.ProgressBarPager()
        })
    });

    grid.render('editorgrid0');

    store.load({params:{start:0, limit:20}});

	 grid.getSelectionModel().on('selectionchange', function(sm)
	{
		 var record = grid.getStore().getAt(1);
        
        //grid.removeBtn.setDisabled(sm.getCount() < 1);
    });
grid.on('rowclick', function(grid, rowIndex, e) {
var record = grid.getStore().getAt(rowIndex);
l_strSelectedItemToDelete = record.data['<%= strFirstString %>'];
});
});

	
</script>

<div id="editorgrid0"  class="absolute0"></div>

</body>
</html>
