<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%> 
<%
String contextPath = request.getContextPath()==null?"":request.getContextPath();
String caseNo = (String) request.getAttribute("caseNo");
String message = request.getAttribute("message") != null ? (String) request.getAttribute("message") : " ";
Map<String, String> formData = request.getAttribute("FORMDATA") != null ? (Map<String, String>) request.getAttribute("FORMDATA") : new HashMap<String, String>();
%>
<style type="text/css">

.vertical-text{
	writing-mode:tb-rl;
    -webkit-transform:rotate(180deg);
    -moz-transform:rotate(180deg);
    -o-transform: rotate(180deg);
    -ms-transform:rotate(180deg);
    transform: rotate(180deg);
    white-space:nowrap;
    display:block;
    bottom:0;
    width:20px;
    height:20px;
  }

.customHeaderTable{
	border: 0px;
}
.table{
	margin-bottom: 0px;
}
.borderless > tbody > tr > td, .borderless > tfoot > tr > td{
    border: none;
}
.sectionHeader{
	padding: 1px;
	border-bottom: 1px solid black;
}
.headerLeft{
	padding: 10px 5px;
	float: left;
	position: relative !important;
	width: 80px;
	color: white;
	background: black;
	font-weight: bold;
	border-top-left-radius: 4px;
}
.headerRight{
	padding: 5px 10px;
	position: relative !important;
	font-size: 15px;
}

.FATCAdatepicker{
	background-image:url("${pageContext.request.contextPath}/includes/images/calendar.png");
	background-repeat:no-repeat;
	background-position: 98%;
}

#fatca1042SForm input[type="text"]{
	background-color: #DCDCFF;
}
#fatca1042SForm input[type="text"]:FOCUS{
	background-color: #FFF;
}
#fatca1042SForm input[type=text].input-ovr, input[type=text].input-ovr1 {
		text-align: justify;
		padding:2px 5px;
		height: 28px;
		width: 22px;
		text-align: center;
		font-size:14px;
		font-weight: normal;
		line-height:1.42857143;
		color:#555;
		border:1px solid #ccc;
		border-radius:4px;
		-webkit-box-shadow:inset 0 1px 1px rgba(0,0,0,.075);
		box-shadow:inset 0 1px 1px rgba(0,0,0,.075);
		-webkit-transition:border-color ease-in-out .15s,-webkit-box-shadow ease-in-out .15s;
		-o-transition:border-color ease-in-out .15s,box-shadow ease-in-out .15s;
		transition:border-color ease-in-out .15s,box-shadow ease-in-out .15s
}
</style>
<script type="text/javascript">
	$(document).ready(function(){
		$("button[data-number=2]").click(function(e){
			e.preventDefault();
		   // $('#addNewIndividualModal').modal('hide');
		    $('#compassCaseWorkFlowGenericModal').modal('show');
		});
		
		$(".FATCAdatepicker").datepicker({
			 dateFormat : "yy-mm-dd",
			 changeMonth: true,
		     changeYear: true
		 });
		
		$(".input-ovr").keypress(function(evt){
			$(this).val("");
			return true;
		});
		
		$(".input-ovr").keyup(function(evt){
			if(evt.which != 46){
				if(evt.which == 8 || evt.which == 37){
					if(evt.which == 8)
						$(this).val("");
					$(this).prev().focus();
				}else{
					$(this).next().focus();
				}
			}
		});
		
		var icons = {
			header: "ui-icon-circle-arrow-e",
			activeHeader: "ui-icon-circle-arrow-s"
		};
		
		$( "#accordion" ).accordion({
			icons: icons,
			collapsible: true,
			active: false
		});

		$("#generateFATCAPackage").click(function(){
			var mywin = window.open("<%=contextPath%>/common/generateFATCAPackage?caseNo=<%=caseNo%>", 'GENERATE_FATCA_PACKAGE', 'height=800,width=1250,resizable=Yes,scrollbars=Yes');
			mywin.moveTo(5,02);
		});
		
		$("#saveFATCA1042Form").click(function(){
			var formObj = $("#fatca1042Form");
			var formData = $(formObj).serialize();
			var caseNo = $(formObj).find("input#caseNo").val();
			//document.write(formData);
			$.ajax({
				url : "${pageContext.request.contextPath}/common/saveFATCA1042Form",
				type : 'POST',
				cache : false,
				data : formData,
				success : function(res){
					alert(res);
				},
				error : function(a,b,c){
					alert(a+b+c);
				}
			});
		});
		
		$("#exportFATCAForm").click(function(){
			var formObj = $("#fatcaForm");
			var formData = $(formObj).serialize();
			var caseNo = $(formObj).find("input#caseNo").val();
						
			$.fileDownload('<%=contextPath%>/common/exportFATCAForm?'+formData, {
			    httpMethod : "GET",
				successCallback: function (url) {
			    },
			    failCallback: function (html, url) {
			        alert('Failed to download file'+url+"\n"+html);
			    }
			});
			
		});
	});
	
	function closeWindow(){
		if(confirm('Are you sure?')){
			window.close();
		}
	}

	function changeName(sourceattr, targetattr){
		var name = "";
		var title = $("#"+sourceattr+"_TITLE").val();
		var firstname = $("#"+sourceattr+"_FIRSTNAME").val();
		var middlename = $("#"+sourceattr+"_MIDDLENAME").val();
		var lastname = $("#"+sourceattr+"_LASTNAME").val();

		if(title != "")
			name = name + title+" ";
		if(firstname != "")
			name = name + firstname+" ";
		if(middlename != "")
			name = name + middlename+" ";
		if(lastname != "")
			name = name + lastname;
		$("#"+targetattr).val(name);
	}
	
	 //function openPdf(e, path, redirect) {
	        // stop the browser from going to the href
	       // e = e || window.event; // for IE
	        //e.preventDefault(); 

	        // launch a new window with your PDF
	        //window.open(path, '', /* options */);

	        // redirect current page to new location
	       // window.location = redirect;
	    //}
</script>
</head>
<body>
<div class="modal fade bs-example-modal-lg addNewIndividualModal" id="addNewIndividualModal" tabindex="1" role="dialog" aria-labelledby="myLargeModalLabel">
  <div class="modal-dialog modal-lg">
    <div class="modal-content card-primary">
      <div class="modal-header card-header">
        <button type="button" class="close" data-number="2" data-dismiss="addNewIndividualModal" aria-label="Close">
        <span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="modal-title">...</h4>
      </div>
	  <div class="modal-body" id="addNewIndividualDetails">
      	Loading...
      </div>
    </div>
  </div>
</div>
	<div style="width: 100%">
	<form action="<%=contextPath%>/saveOrExportFATCA1042SForm" method="POST" id="fatca1042SForm" class="form-inline">	
	<input type="hidden" name="caseNo" id="caseNo" value="<%=caseNo%>">
	<!-- COPY A STARTING -->
	<div class="section" style="padding: 5px 7.5% 0 7.5%;">
		<div class="col-lg-12">
			<div class="card card-primary">
				<div class="card-body">
					<table class="table customHeaderTable" style="text-align: center;">
						<tr>
							<td width="18%" style="border-right: 2px solid black;">
								Form <font style="font-weight: bold; font-size: 20px" face="Helvetica">1042</font>
							</td>
							<td width="65%">
								<font style="font-weight: bold; font-size: 20px" face="ITC Franklin Gothic Std Book">Annual Withholding Tax Return for U.S. Source        Income of Foreign Persons 
								</font>
							</td>
							<td width="17%" style="border-left: 2px solid black;">
								OMB No. 1545-0096
							</td>
						</tr>
						<tr>
							<td style="border-right: 2px solid black; border-bottom: 2px solid black">
								Department of the Treasury Internal Revenue Service
							</td>
							<td style="border-bottom: 2px solid black">
								Information about Form 1042 and its separate instructions is at <a href="javascript:void(0)" onclick="window.open('http://www.irs.gov/form1024')">www.irs.gov/form1024</a>.
							</td>
							<td style="border-left: 2px solid black; border-bottom: 2px solid black">
								<font style="font-weight: bold; font-size: 20px" face="Helvetica">2016</font>
							</td>
						</tr>
						<tr style="text-align: left;">
							<td colspan="2">
								<label for="REPORT_TYPE_FATCA4">
									If this is an amended return, check here ................................................................................................
								</label>
							</td>
							<td colspan="1">
								<input type="checkbox" id="F1042_AMENDEDRETURN" name="F1042_AMENDEDRETURN" value="1042_AMENDED"
								<% if("1042_AMENDED".equals(formData.get("F1042_AMENDEDRETURN"))){ %> checked="checked" <%} %>/>
							</td>
						</tr>
					</table>
				</div>
			</div>
		</div>
	</div>
	<div class="section" style="padding: 5px 7.5% 0 7.5%;">
		<div class="col-lg-12">
			<div class="card card-primary">
				<table class="table customHeaderTable" style="text-align: center;">
					<tr>
						<td colspan="5">
							<font style="font-weight: bold; font-size: 20px; text-align: center;" face="ITC Franklin Gothic Std Book" >For IRS Use Only</font>
						</td>
					</tr>
					<tr>
						<td width="15%">
							<font style="font-weight: bold;" face="ITC Franklin Gothic Std Book" >CC</font>
						</td>
						<td width="30%">
							<input type="text" class="input-sm form-control" id="F1042_IRSCC" name="F1042_IRSCC"
							value="<%=formData.get("F1042_IRSCC") != null ? formData.get("F1042_IRSCC") : ""%>"/>
						</td>
						<td width="2%">&nbsp;</td>
						<td width="18%">
							<font style="font-weight: bold;" face="ITC Franklin Gothic Std Book" >FD</font>
						</td>
						<td width="30%">
							<input type="text" class="input-sm form-control" id="F1042_IRSFD" name="F1042_IRSFD"
							value="<%=formData.get("F1042_IRSFD") != null ? formData.get("F1042_IRSFD") : ""%>"/>
						</td>
					</tr>
					<tr>
						<td width="15%">
							<font style="font-weight: bold;" face="ITC Franklin Gothic Std Book" >RD</font>
						</td>
						<td width="30%">
							<input type="text" class="input-sm form-control" id="F1042_IRSRD" name="F1042_IRSRD"
							value="<%=formData.get("F1042_IRSRD") != null ? formData.get("F1042_IRSRD") : ""%>"/>
						</td>
						<td width="2%">&nbsp;</td>
						<td width="18%">
							<font style="font-weight: bold;" face="ITC Franklin Gothic Std Book" >FF</font>
						</td>
						<td width="30%">
							<input type="text" class="input-sm form-control" id="F1042_IRSFF" name="F1042_IRSFF"
							value="<%=formData.get("F1042_IRSFF") != null ? formData.get("F1042_IRSFF") : ""%>"/>
						</td>
					</tr>
					<tr>
						<td width="15%">
							<font style="font-weight: bold;" face="ITC Franklin Gothic Std Book" >CAF</font>
						</td>
						<td width="30%">
							<input type="text" class="input-sm form-control" id="F1042_IRSCAF" name="F1042_IRSCAF"
							value="<%=formData.get("F1042_IRSCAF") != null ? formData.get("F1042_IRSCAF") : ""%>"/>
						</td>
						<td width="2%">&nbsp;</td>
						<td width="18%">
							<font style="font-weight: bold;" face="ITC Franklin Gothic Std Book" >FP</font>
						</td>
						<td width="30%">
							<input type="text" class="input-sm form-control" id="F1042_IRSFP" name="F1042_IRSFP"
							value="<%=formData.get("F1042_IRSFP") != null ? formData.get("F1042_IRSFP") : ""%>"/>
						</td>
					</tr>
					<tr>
						<td width="15%">
							<font style="font-weight: bold;" face="ITC Franklin Gothic Std Book" >CR </font>
						</td>
						<td width="30%">
							<input type="text" class="input-sm form-control" id="F1042_IRSCR" name="F1042_IRSCR"
							value="<%=formData.get("F1042_IRSCR") != null ? formData.get("F1042_IRSCR") : ""%>"/>
						</td>
						<td width="2%">&nbsp;</td>
						<td width="18%">
							<font style="font-weight: bold;" face="ITC Franklin Gothic Std Book" >I</font>
						</td>
						<td width="30%">
							<input type="text" class="input-sm form-control" id="F1042_IRSI" name="F1042_IRSI"
							value="<%=formData.get("F1042_IRSI") != null ? formData.get("F1042_IRSI") : ""%>"/>
						</td>
					</tr>
					<tr>
						<td width="15%">
							<font style="font-weight: bold;" face="ITC Franklin Gothic Std Book" >EDC</font>
						</td>
						<td width="30%">
							<input type="text" class="input-sm form-control" id="F1042_IRSEDC" name="F1042_IRSEDC"
							value="<%=formData.get("F1042_IRSEDC") != null ? formData.get("F1042_IRSEDC") : ""%>"/>
						</td>
						<td width="2%">&nbsp;</td>
						<td width="18%">
							<font style="font-weight: bold;" face="ITC Franklin Gothic Std Book" >SIC</font>
						</td>
						<td width="30%">
							<input type="text" class="input-sm form-control" id="F1042_IRSSIC" name="F1042_IRSSIC"
							value="<%=formData.get("F1042_IRSSIC") != null ? formData.get("F1042_IRSSIC") : ""%>"/>
						</td>
					</tr>
				</table>
			</div>
		</div>
	</div>
	<div class="section" style="padding: 0 7.5% 0 7.5%;">
		<div class="col-lg-12">
			<div class="card card-danger" style="margin-top: 20px; margin-bottom: 0;">
				<table class="table">
					<tr>
						<td width="24%">
							Name of withholding agent
						</td>
						<td width="25%">
							<input type="text" class="input-sm form-control" id="F1042_WHAGENTNAME" name="F1042_WHAGENTNAME"
							value="<%=formData.get("F1042_WHAGENTNAME") != null ? formData.get("F1042_WHAGENTNAME") : ""%>"/>
						</td>
						<td width="2%">&nbsp;</td>
						<td width="24%">
							Employer identification number
						</td>
						<td width="25%">
							<input type="text" class="input-sm form-control" id="F1042_EIN" name="F1042_EIN"
							value="<%=formData.get("F1042_EIN") != null ? formData.get("F1042_EIN") : ""%>"/>
						</td>
					</tr>
					<tr>
						<td width="24%">
							Chapter 3 Status Code 
						</td>
						<td width="25%">
							<input type="text" class="input-sm form-control" id="F1042_CH3_STATUSCODE" name="F1042_CH3_STATUSCODE"
							value="<%=formData.get("F1042_CH3_STATUSCODE") != null ? formData.get("F1042_CH3_STATUSCODE") : ""%>"/>
						</td>
						<td width="2%">&nbsp;</td>
						<td width="24%">
							Chapter 4 Status Code
						</td>
						<td width="25%">
							<input type="text" class="input-sm form-control" id="F1042_CH4_STATUSCODE" name="F1042_CH4_STATUSCODE"
							value="<%=formData.get("F1042_CH4_STATUSCODE") != null ? formData.get("F1042_CH4_STATUSCODE") : ""%>"/>
						</td>
					</tr>
					<tr>
						<td width="24%">
							Number, street, and room or suite no. (if a P.O. box, see instructions)
						</td>
						<td width="25%">
							<input type="text" class="input-sm form-control" id="F1042_ADDR1" name="F1042_ADDR1"
							value="<%=formData.get("F1042_ADDR1") != null ? formData.get("F1042_ADDR1") : ""%>"/>
						</td>
						<td width="2%">&nbsp;</td>
						<td width="24%">
							City or town, state or province, country, and ZIP or foreign postal code
						</td>
						<td width="25%">
							<input type="text" class="input-sm form-control" id="F1042_ADDR2" name="F1042_ADDR2"
							value="<%=formData.get("F1042_ADDR2") != null ? formData.get("F1042_ADDR2") : ""%>"/>
						</td>
					</tr>
					<tr>
						<td colspan="2">
							If you do not expect to file this return in the future, </br>check here &nbsp;&nbsp;&nbsp;
							<input type="checkbox" class="input-sm form-control" id="F1042_NOFILE_RETURN" name="F1042_NOFILE_RETURN" value="NOTAX_DEPOSITED" 
							 <% if("NOFILE_RETURN".equals(formData.get("F1042_NOFILE_RETURN"))){ %> checked="checked" <%} %>/>
						</td>
						<td width="2%">&nbsp;</td>
						<td width="24%">
							Enter date final income paid 
						</td>
						<td width="25%">
							<input type="text" class="input-sm form-control FATCAdatepicker" id="F1042_FEDERALTAX_WITHHELD" name="F1042_FEDERALTAX_WITHHELD"
							value="<%=formData.get("F1042_FEDERALTAX_WITHHELD") != null ? formData.get("F1042_FEDERALTAX_WITHHELD") : ""%>"/>
						</td>
					</tr>
				</table>
			</div>
		</div>
	</div>
	<div class="section" style="padding: 0 7.5% 0 7.5%;">
		<div class="col-lg-12">
			<div class="card card-danger" style="margin-top: 20px; margin-bottom: 0;">
				<div class="sectionHeader">
					<div class="headerLeft">
						Section I
					</div>
					<div class="headerRight">
						&nbsp;&nbsp;&nbsp;
						<font style="font-weight: bold; font-size: 20px; text-align: center;" face="ITC Franklin Gothic Std Book" >Record of Federal Tax Liability</font> 
						(Do not show federal tax deposits here)
					</div>
				</div>
				<table class="table" >
					<tr>
						<td colspan="5" style="padding: 5px 2px 10px 3px !important; ">
							<table class="table-bordered">
								<tr>
									<th width="3%" style="text-align: center;">
										Line No. 
									</th>
									<th width="10%" style="text-align: center;">
										Period ending
									</th>
									<th width="20%" style="text-align: center;">Tax liability for period  (including any taxes assumed on Form(s) 1000)</th>
									<th width="3%" style="text-align: center;">
										Line No. 
									</th>
									<th width="10%" style="text-align: center;">
										Period ending
									</th>
									<th width="20%" style="text-align: center;">Tax liability for period  (including any taxes assumed on Form(s) 1000)</th>
									<th width="3%" style="text-align: center;">
										Line No. 
									</th>
									<th width="10%" style="text-align: center;">
										Period ending
									</th>
									<th width="21%" style="text-align: center;">Tax liability for period  (including any taxes assumed on Form(s) 1000)</th>
								</tr>
								<tr>
									<td width="3%" style="text-align: center; font-weight: bold;">
										1 
									</td>
									<td width="10%"  style="text-align: center;">
										<table>
											<tr>
												<td width="80%" style="text-align: center;">&nbsp;Jan.&nbsp;&nbsp;&nbsp;&nbsp;</td>
												<td width="10%" style="text-align: center;">7</td>
											</tr>
										</table>
									</td>
									<td width="20%" style="text-align: center;">
										<input type="text" class="input-sm form-control" id="F1042_TAXLIABLE_JAN7" name="F1042_TAXLIABLE_JAN7"
										value="<%=formData.get("F1042_TAXLIABLE_JAN7") != null ? formData.get("F1042_TAXLIABLE_JAN7") : ""%>"/>
									</td>
									<td width="3%" style="text-align: center; font-weight: bold;">
										21 
									</td>
									<td width="10%" style="text-align: center;">
										<table>
											<tr>
												<td width="80%" style="text-align: center;">&nbsp;May&nbsp;&nbsp;&nbsp;&nbsp;</td>
												<td width="10%" style="text-align: center;">7</td>
											</tr>
										</table>
									</td>
									<td width="20%" style="text-align: center;">
										<input type="text" class="input-sm form-control" id="F1042_TAXLIABLE_MAY7" name="F1042_TAXLIABLE_MAY7"
										value="<%=formData.get("F1042_TAXLIABLE_MAY7") != null ? formData.get("F1042_TAXLIABLE_MAY7") : ""%>"/>
									</td>
									<td width="3%" style="text-align: center; font-weight: bold;">
										41 
									</td>
									<td width="10%" style="text-align: center;">
										<table>
											<tr>
												<td width="80%" style="text-align: center;">&nbsp;Sept.&nbsp;&nbsp;&nbsp;&nbsp;</td>
												<td width="10%" style="text-align: center;">7</td>
											</tr>
										</table>
									</td>
									<td width="20%" style="text-align: center;">
										<input type="text" class="input-sm form-control" id="F1042_TAXLIABLE_SEPT7" name="F1042_TAXLIABLE_SEPT7"
										value="<%=formData.get("F1042_TAXLIABLE_SEPT7") != null ? formData.get("F1042_TAXLIABLE_SEPT7") : ""%>"/>
									</td>
								</tr>
								<tr>
									<td width="3%" style="text-align: center; font-weight: bold;">
										2 
									</td>
									<td width="10%" style="text-align: center;">
										<table>
											<tr>
												<td width="80%" style="text-align: center;">&nbsp;Jan.&nbsp;&nbsp;&nbsp;&nbsp;</td>
												<td width="10%" style="text-align: center;">15</td>
											</tr>
										</table>
									</td>
									<td width="20%" style="text-align: center;">
										<input type="text" class="input-sm form-control" id="F1042_TAXLIABLE_JAN15" name="F1042_TAXLIABLE_JAN15"
										value="<%=formData.get("F1042_TAXLIABLE_JAN15") != null ? formData.get("F1042_TAXLIABLE_JAN15") : ""%>"/>
									</td>
									<td width="3%" style="text-align: center; font-weight: bold;">
										22
									</td>
									<td width="10%" style="text-align: center;">
										<table>
											<tr>
												<td width="80%" style="text-align: center;">&nbsp;May&nbsp;&nbsp;&nbsp;&nbsp;</td>
												<td width="10%" style="text-align: center;">15</td>
											</tr>
										</table>
									</td>
									<td width="20%" style="text-align: center;">
										<input type="text" class="input-sm form-control" id="F1042_TAXLIABLE_MAY15" name="F1042_TAXLIABLE_MAY15"
										value="<%=formData.get("F1042_TAXLIABLE_MAY15") != null ? formData.get("F1042_TAXLIABLE_MAY15") : ""%>"/>
									</td>
									<td width="3%" style="text-align: center; font-weight: bold;">
										42
									</td>
									<td width="10%" style="text-align: center;">
										<table>
											<tr>
												<td width="80%" style="text-align: center;">&nbsp;Sept.&nbsp;&nbsp;&nbsp;&nbsp;</td>
												<td width="10%" style="text-align: center;">15</td>
											</tr>
										</table>
									</td>
									<td width="20%" style="text-align: center;">
										<input type="text" class="input-sm form-control" id="F1042_TAXLIABLE_SEPT15" name="F1042_TAXLIABLE_SEPT15"
										value="<%=formData.get("F1042_TAXLIABLE_SEPT15") != null ? formData.get("F1042_TAXLIABLE_SEPT15") : ""%>"/>
									</td>
								</tr>
								<tr>
									<td width="3%" style="text-align: center; font-weight: bold;">
										3
									</td>
									<td width="10%" style="text-align: center;">
										<table>
											<tr>
												<td width="80%" rowspan="4" style="text-align: center;">&nbsp;Jan.&nbsp;&nbsp;&nbsp;&nbsp;</td>
												<td width="10%" style="text-align: center;">22</td>
											</tr>
										</table>
									</td>
									<td width="20%" style="text-align: center;">
										<input type="text" class="input-sm form-control" id="F1042_TAXLIABLE_JAN22" name="F1042_TAXLIABLE_JAN22"
										value="<%=formData.get("F1042_TAXLIABLE_JAN22") != null ? formData.get("F1042_TAXLIABLE_JAN22") : ""%>"/>
									</td>
									<td width="3%" style="text-align: center; font-weight: bold;">
										23 
									</td>
									<td width="10%" style="text-align: center;">
										<table>
											<tr>
												<td width="80%" style="text-align: center;">&nbsp;May&nbsp;&nbsp;&nbsp;&nbsp;</td>
												<td width="10%" style="text-align: center;">22</td>
											</tr>
										</table>
									</td>
									<td width="20%" style="text-align: center;">
										<input type="text" class="input-sm form-control" id="F1042_TAXLIABLE_MAY22" name="F1042_TAXLIABLE_MAY22"
										value="<%=formData.get("F1042_TAXLIABLE_MAY22") != null ? formData.get("F1042_TAXLIABLE_MAY22") : ""%>"/>
									</td>
									<td width="3%" style="text-align: center; font-weight: bold;">
										43
									</td>
									<td width="10%" style="text-align: center;">
										<table>
											<tr>
												<td width="80%" style="text-align: center;">&nbsp;Sept.&nbsp;&nbsp;&nbsp;&nbsp;</td>
												<td width="10%" style="text-align: center;">22</td>
											</tr>
										</table>
									</td>
									<td width="20%" style="text-align: center;">
										<input type="text" class="input-sm form-control" id="F1042_TAXLIABLE_SEPT22" name="F1042_TAXLIABLE_SEPT22"
										value="<%=formData.get("F1042_TAXLIABLE_SEPT22") != null ? formData.get("F1042_TAXLIABLE_SEPT22") : ""%>"/>
									</td>
								</tr>
								<tr>
									<td width="3%" style="text-align: center; font-weight: bold;">
										4
									</td>
									<td width="10%" style="text-align: center;">
										<table>
											<tr>
												<td width="80%" rowspan="4" style="text-align: center;">&nbsp;Jan.&nbsp;&nbsp;&nbsp;&nbsp;</td>
												<td width="10%" style="text-align: center;">31</td>
											</tr>
										</table>
									</td>
									<td width="20%" style="text-align: center;">
										<input type="text" class="input-sm form-control" id="F1042_TAXLIABLE_JAN31" name="F1042_TAXLIABLE_JAN31"
										value="<%=formData.get("F1042_TAXLIABLE_JAN31") != null ? formData.get("F1042_TAXLIABLE_JAN31") : ""%>"/>
									</td>
									<td width="3%" style="text-align: center; font-weight: bold;">
										24
									</td>
									<td width="10%" style="text-align: center;">
										<table>
											<tr>
												<td width="80%" style="text-align: center;">&nbsp;May&nbsp;&nbsp;&nbsp;&nbsp;</td>
												<td width="10%" style="text-align: center;">31</td>
											</tr>
										</table>
									</td>
									<td width="20%" style="text-align: center;">
										<input type="text" class="input-sm form-control" id="F1042_TAXLIABLE_MAY31" name="F1042_TAXLIABLE_MAY31"
										value="<%=formData.get("F1042_TAXLIABLE_MAY31") != null ? formData.get("F1042_TAXLIABLE_MAY31") : ""%>"/>
									</td>
									<td width="3%" style="text-align: center; font-weight: bold;">
										44
									</td>
									<td width="10%" style="text-align: center;">
										<table>
											<tr>
												<td width="80%" style="text-align: center;">&nbsp;Sept.&nbsp;&nbsp;&nbsp;&nbsp;</td>
												<td width="10%" style="text-align: center;">30</td>
											</tr>
										</table>
									</td>
									<td width="20%" style="text-align: center;">
										<input type="text" class="input-sm form-control" id="F1042_TAXLIABLE_SEPT30" name="F1042_TAXLIABLE_SEPT30"
										value="<%=formData.get("F1042_TAXLIABLE_SEPT30") != null ? formData.get("F1042_TAXLIABLE_SEPT30") : ""%>"/>
									</td>
								</tr>
								<tr>
									<td width="3%" style="text-align: center; font-weight: bold;">
										5
									</td>
									<td width="10%" style="text-align: center;">
										<table>
											<tr>
												<td width="80%" style="text-align: center; font-weight: bold;">&nbsp;Jan.&nbsp;&nbsp;&nbsp;</td>
												<td width="10%" style="text-align: center; font-weight: bold;">total</td>
											</tr>
										</table>
									</td>
									<td width="20%" style="text-align: center;">
										<input type="text" class="input-sm form-control" id="F1042_TAXLIABLE_JANTOTAL" name="F1042_TAXLIABLE_JANTOTAL"
										value="<%=formData.get("F1042_TAXLIABLE_JANTOTAL") != null ? formData.get("F1042_TAXLIABLE_JANTOTAL") : ""%>"/>
									</td>
									<td width="3%" style="text-align: center; font-weight: bold;">
										25
									</td>
									<td width="10%" style="text-align: center;">
										<table>
											<tr>
												<td width="80%" style="text-align: center;font-weight: bold;">&nbsp;May&nbsp;&nbsp;&nbsp;&nbsp;</td>
												<td width="10%" style="text-align: center; font-weight: bold;">total</td>
											</tr>
										</table>
									</td>
									<td width="20%" style="text-align: center;">
										<input type="text" class="input-sm form-control" id="F1042_TAXLIABLE_MAYTOTAL" name="F1042_TAXLIABLE_MAYTOTAL"
										value="<%=formData.get("F1042_TAXLIABLE_MAYTOTAL") != null ? formData.get("F1042_TAXLIABLE_MAYTOTAL") : ""%>"/>
									</td>
									<td width="3%" style="text-align: center; font-weight: bold;">
										45
									</td>
									<td width="10%" style="text-align: center;">
										<table>
											<tr>
												<td width="80%" style="text-align: center;font-weight: bold;">&nbsp;Sept.&nbsp;&nbsp;&nbsp;</td>
												<td width="10%" style="text-align: center;font-weight: bold;">total</td>
											</tr>
										</table>
									</td>
									<td width="20%" style="text-align: center;">
										<input type="text" class="input-sm form-control" id="F1042_TAXLIABLE_SEPTTOTAL" name="F1042_TAXLIABLE_SEPTTOTAL"
										value="<%=formData.get("F1042_TAXLIABLE_SEPTTOTAL") != null ? formData.get("F1042_TAXLIABLE_SEPTTOTAL") : ""%>"/>
									</td>
								</tr>
								
								<tr>
									<td width="3%" style="text-align: center; font-weight: bold;">
										6 
									</td>
									<td width="10%"  style="text-align: center;">
										<table>
											<tr>
												<td width="80%" style="text-align: center;">&nbsp;Feb.&nbsp;&nbsp;&nbsp;&nbsp;</td>
												<td width="10%" style="text-align: center;">7</td>
											</tr>
										</table>
									</td>
									<td width="20%" style="text-align: center;">
										<input type="text" class="input-sm form-control" id="F1042_TAXLIABLE_FEB7" name="F1042_TAXLIABLE_FEB7"
										value="<%=formData.get("F1042_TAXLIABLE_FEB7") != null ? formData.get("F1042_TAXLIABLE_FEB7") : ""%>"/>
									</td>
									<td width="3%" style="text-align: center; font-weight: bold;">
										26
									</td>
									<td width="10%" style="text-align: center;">
										<table>
											<tr>
												<td width="80%" style="text-align: center;">&nbsp;June&nbsp;&nbsp;&nbsp;&nbsp;</td>
												<td width="10%" style="text-align: center;">7</td>
											</tr>
										</table>
									</td>
									<td width="20%" style="text-align: center;">
										<input type="text" class="input-sm form-control" id="F1042_TAXLIABLE_JUNE7" name="F1042_TAXLIABLE_JUNE7"
										value="<%=formData.get("F1042_TAXLIABLE_JUNE7") != null ? formData.get("F1042_TAXLIABLE_JUNE7") : ""%>"/>
									</td>
									<td width="3%" style="text-align: center; font-weight: bold;">
										46
									</td>
									<td width="10%" style="text-align: center;">
										<table>
											<tr>
												<td width="80%" style="text-align: center;">&nbsp;Oct.&nbsp;&nbsp;&nbsp;&nbsp;</td>
												<td width="10%" style="text-align: center;">7</td>
											</tr>
										</table>
									</td>
									<td width="20%" style="text-align: center;">
										<input type="text" class="input-sm form-control" id="F1042_TAXLIABLE_OCT7" name="F1042_TAXLIABLE_OCT7"
										value="<%=formData.get("F1042_TAXLIABLE_OCT7") != null ? formData.get("F1042_TAXLIABLE_OCT7") : ""%>"/>
									</td>
								</tr>
								<tr>
									<td width="3%" style="text-align: center; font-weight: bold;">
										7
									</td>
									<td width="10%" style="text-align: center;">
										<table>
											<tr>
												<td width="80%" style="text-align: center;">&nbsp;Feb.&nbsp;&nbsp;&nbsp;&nbsp;</td>
												<td width="10%" style="text-align: center;">15</td>
											</tr>
										</table>
									</td>
									<td width="20%" style="text-align: center;">
										<input type="text" class="input-sm form-control" id="F1042_TAXLIABLE_FEB15" name="F1042_TAXLIABLE_FEB15"
										value="<%=formData.get("F1042_TAXLIABLE_FEB15") != null ? formData.get("F1042_TAXLIABLE_FEB15") : ""%>"/>
									</td>
									<td width="3%" style="text-align: center; font-weight: bold;">
										27
									</td>
									<td width="10%" style="text-align: center;">
										<table>
											<tr>
												<td width="80%" style="text-align: center;">&nbsp;June&nbsp;&nbsp;&nbsp;&nbsp;</td>
												<td width="10%" style="text-align: center;">15</td>
											</tr>
										</table>
									</td>
									<td width="20%" style="text-align: center;">
										<input type="text" class="input-sm form-control" id="F1042_TAXLIABLE_JUNE15" name="F1042_TAXLIABLE_JUNE15"
										value="<%=formData.get("F1042_TAXLIABLE_JUNE15") != null ? formData.get("F1042_TAXLIABLE_JUNE15") : ""%>"/>
									</td>
									<td width="3%" style="text-align: center; font-weight: bold;">
										47
									</td>
									<td width="10%" style="text-align: center;">
										<table>
											<tr>
												<td width="80%" style="text-align: center;">&nbsp;Oct.&nbsp;&nbsp;&nbsp;&nbsp;</td>
												<td width="10%" style="text-align: center;">15</td>
											</tr>
										</table>
									</td>
									<td width="20%" style="text-align: center;">
										<input type="text" class="input-sm form-control" id="F1042_TAXLIABLE_OCT15" name="F1042_TAXLIABLE_OCT15"
										value="<%=formData.get("F1042_TAXLIABLE_OCT15") != null ? formData.get("F1042_TAXLIABLE_OCT15") : ""%>"/>
									</td>
								</tr>
								<tr>
									<td width="3%" style="text-align: center; font-weight: bold;">
										8
									</td>
									<td width="10%" style="text-align: center;">
										<table>
											<tr>
												<td width="80%" rowspan="4" style="text-align: center;">&nbsp;Feb.&nbsp;&nbsp;&nbsp;&nbsp;</td>
												<td width="10%" style="text-align: center;">22</td>
											</tr>
										</table>
									</td>
									<td width="20%" style="text-align: center;">
										<input type="text" class="input-sm form-control" id="F1042_TAXLIABLE_FEB22" name="F1042_TAXLIABLE_FEB22"
										value="<%=formData.get("F1042_TAXLIABLE_FEB22") != null ? formData.get("F1042_TAXLIABLE_FEB22") : ""%>"/>
									</td>
									<td width="3%" style="text-align: center; font-weight: bold;">
										28
									</td>
									<td width="10%" style="text-align: center;">
										<table>
											<tr>
												<td width="80%" style="text-align: center;">&nbsp;June&nbsp;&nbsp;&nbsp;&nbsp;</td>
												<td width="10%" style="text-align: center;">22</td>
											</tr>
										</table>
									</td>
									<td width="20%" style="text-align: center;">
										<input type="text" class="input-sm form-control" id="F1042_TAXLIABLE_JUNE22" name="F1042_TAXLIABLE_JUNE22"
										value="<%=formData.get("F1042_TAXLIABLE_JUNE22") != null ? formData.get("F1042_TAXLIABLE_JUNE22") : ""%>"/>
									</td>
									<td width="3%" style="text-align: center; font-weight: bold;">
										48
									</td>
									<td width="10%" style="text-align: center;">
										<table>
											<tr>
												<td width="80%" style="text-align: center;">&nbsp;Oct.&nbsp;&nbsp;&nbsp;&nbsp;</td>
												<td width="10%" style="text-align: center;">22</td>
											</tr>
										</table>
									</td>
									<td width="20%" style="text-align: center;">
										<input type="text" class="input-sm form-control" id="F1042_TAXLIABLE_OCT22" name="F1042_TAXLIABLE_OCT22"
										value="<%=formData.get("F1042_TAXLIABLE_OCT22") != null ? formData.get("F1042_TAXLIABLE_OCT22") : ""%>"/>
									</td>
								</tr>
								<tr>
									<td width="3%" style="text-align: center; font-weight: bold;">
										9
									</td>
									<td width="10%" style="text-align: center;">
										<table>
											<tr>
												<td width="80%" rowspan="4" style="text-align: center;">&nbsp;Feb.&nbsp;&nbsp;&nbsp;&nbsp;</td>
												<td width="10%" style="text-align: center;">29</td>
											</tr>
										</table>
									</td>
									<td width="20%" style="text-align: center;">
										<input type="text" class="input-sm form-control" id="F1042_TAXLIABLE_FEB29" name="F1042_TAXLIABLE_FEB29"
										value="<%=formData.get("F1042_TAXLIABLE_FEB29") != null ? formData.get("F1042_TAXLIABLE_FEB29") : ""%>"/>
									</td>
									<td width="3%" style="text-align: center; font-weight: bold;">
										29
									</td>
									<td width="10%" style="text-align: center;">
										<table>
											<tr>
												<td width="80%" style="text-align: center;">&nbsp;June&nbsp;&nbsp;&nbsp;&nbsp;</td>
												<td width="10%" style="text-align: center;">30</td>
											</tr>
										</table>
									</td>
									<td width="20%" style="text-align: center;">
										<input type="text" class="input-sm form-control" id="F1042_TAXLIABLE_JUNE30" name="F1042_TAXLIABLE_JUNE30"
										value="<%=formData.get("F1042_TAXLIABLE_JUNE30") != null ? formData.get("F1042_TAXLIABLE_JUNE30") : ""%>"/>
									</td>
									<td width="3%" style="text-align: center; font-weight: bold;">
										49
									</td>
									<td width="10%" style="text-align: center;">
										<table>
											<tr>
												<td width="80%" style="text-align: center;">&nbsp;Oct.&nbsp;&nbsp;&nbsp;&nbsp;</td>
												<td width="10%" style="text-align: center;">31</td>
											</tr>
										</table>
									</td>
									<td width="20%" style="text-align: center;">
										<input type="text" class="input-sm form-control" id="F1042_TAXLIABLE_OCT31" name="F1042_TAXLIABLE_OCT31"
										value="<%=formData.get("F1042_TAXLIABLE_OCT31") != null ? formData.get("F1042_TAXLIABLE_OCT31") : ""%>"/>
									</td>
								</tr>
								<tr>
									<td width="3%" style="text-align: center; font-weight: bold;">
										10
									</td>
									<td width="10%" style="text-align: center;">
										<table>
											<tr>
												<td width="80%" style="text-align: center; font-weight: bold;">&nbsp;Feb.&nbsp;&nbsp;&nbsp;</td>
												<td width="10%" style="text-align: center; font-weight: bold;">total</td>
											</tr>
										</table>
									</td>
									<td width="20%" style="text-align: center;">
										<input type="text" class="input-sm form-control" id="F1042_TAXLIABLE_FEBTOTAL" name="F1042_TAXLIABLE_FEBTOTAL"
										value="<%=formData.get("F1042_TAXLIABLE_FEBTOTAL") != null ? formData.get("F1042_TAXLIABLE_FEBTOTAL") : ""%>"/>
									</td>
									<td width="3%" style="text-align: center; font-weight: bold;">
										30
									</td>
									<td width="10%" style="text-align: center;">
										<table>
											<tr>
												<td width="80%" style="text-align: center;font-weight: bold;">&nbsp;June&nbsp;&nbsp;&nbsp;&nbsp;</td>
												<td width="10%" style="text-align: center; font-weight: bold;">total</td>
											</tr>
										</table>
									</td>
									<td width="20%" style="text-align: center;">
										<input type="text" class="input-sm form-control" id="F1042_TAXLIABLE_JUNETOTAL" name="F1042_TAXLIABLE_JUNETOTAL"
										value="<%=formData.get("F1042_TAXLIABLE_JUNETOTAL") != null ? formData.get("F1042_TAXLIABLE_JUNETOTAL") : ""%>"/>
									</td>
									<td width="3%" style="text-align: center; font-weight: bold;">
										50
									</td>
									<td width="10%" style="text-align: center;">
										<table>
											<tr>
												<td width="80%" style="text-align: center;font-weight: bold;">&nbsp;Oct.&nbsp;&nbsp;&nbsp;</td>
												<td width="10%" style="text-align: center;font-weight: bold;">total</td>
											</tr>
										</table>
									</td>
									<td width="20%" style="text-align: center;">
										<input type="text" class="input-sm form-control" id="F1042_TAXLIABLE_OCTTOTAL" name="F1042_TAXLIABLE_OCTTOTAL"
										value="<%=formData.get("F1042_TAXLIABLE_OCTTOTAL") != null ? formData.get("F1042_TAXLIABLE_OCTTOTAL") : ""%>"/>
									</td>
								</tr>
								
								<tr>
									<td width="3%" style="text-align: center; font-weight: bold;">
										11
									</td>
									<td width="10%"  style="text-align: center;">
										<table>
											<tr>
												<td width="80%" style="text-align: center;">&nbsp;Mar.&nbsp;&nbsp;&nbsp;&nbsp;</td>
												<td width="10%" style="text-align: center;">7</td>
											</tr>
										</table>
									</td>
									<td width="20%" style="text-align: center;">
										<input type="text" class="input-sm form-control" id="F1042_TAXLIABLE_MAR7" name="F1042_TAXLIABLE_MAR7"
										value="<%=formData.get("F1042_TAXLIABLE_MAR7") != null ? formData.get("F1042_TAXLIABLE_MAR7") : ""%>"/>
									</td>
									<td width="3%" style="text-align: center; font-weight: bold;">
										31 
									</td>
									<td width="10%" style="text-align: center;">
										<table>
											<tr>
												<td width="80%" style="text-align: center;">&nbsp;July&nbsp;&nbsp;&nbsp;&nbsp;</td>
												<td width="10%" style="text-align: center;">7</td>
											</tr>
										</table>
									</td>
									<td width="20%" style="text-align: center;">
										<input type="text" class="input-sm form-control" id="F1042_TAXLIABLE_JULY7" name="F1042_TAXLIABLE_JULY7"
										value="<%=formData.get("F1042_TAXLIABLE_JULY7") != null ? formData.get("F1042_TAXLIABLE_JULY7") : ""%>"/>
									</td>
									<td width="3%" style="text-align: center; font-weight: bold;">
										51 
									</td>
									<td width="10%" style="text-align: center;">
										<table>
											<tr>
												<td width="80%" style="text-align: center;">&nbsp;Nov.&nbsp;&nbsp;&nbsp;&nbsp;</td>
												<td width="10%" style="text-align: center;">7</td>
											</tr>
										</table>
									</td>
									<td width="20%" style="text-align: center;">
										<input type="text" class="input-sm form-control" id="F1042_TAXLIABLE_NOV7" name="F1042_TAXLIABLE_NOV7"
										value="<%=formData.get("F1042_TAXLIABLE_NOV7") != null ? formData.get("F1042_TAXLIABLE_NOV7") : ""%>"/>
									</td>
								</tr>
								<tr>
									<td width="3%" style="text-align: center; font-weight: bold;">
										12 
									</td>
									<td width="10%" style="text-align: center;">
										<table>
											<tr>
												<td width="80%" style="text-align: center;">&nbsp;Mar.&nbsp;&nbsp;&nbsp;&nbsp;</td>
												<td width="10%" style="text-align: center;">15</td>
											</tr>
										</table>
									</td>
									<td width="20%" style="text-align: center;">
										<input type="text" class="input-sm form-control" id="F1042_TAXLIABLE_MAR15" name="F1042_TAXLIABLE_MAR15"
										value="<%=formData.get("F1042_TAXLIABLE_MAR15") != null ? formData.get("F1042_TAXLIABLE_MAR15") : ""%>"/>
									</td>
									<td width="3%" style="text-align: center; font-weight: bold;">
										32
									</td>
									<td width="10%" style="text-align: center;">
										<table>
											<tr>
												<td width="80%" style="text-align: center;">&nbsp;July&nbsp;&nbsp;&nbsp;&nbsp;</td>
												<td width="10%" style="text-align: center;">15</td>
											</tr>
										</table>
									</td>
									<td width="20%" style="text-align: center;">
										<input type="text" class="input-sm form-control" id="F1042_TAXLIABLE_JULY15" name="F1042_TAXLIABLE_JULY15"
										value="<%=formData.get("F1042_TAXLIABLE_JULY15") != null ? formData.get("F1042_TAXLIABLE_JULY15") : ""%>"/>
									</td>
									<td width="3%" style="text-align: center; font-weight: bold;">
										52
									</td>
									<td width="10%" style="text-align: center;">
										<table>
											<tr>
												<td width="80%" style="text-align: center;">&nbsp;Nov.&nbsp;&nbsp;&nbsp;&nbsp;</td>
												<td width="10%" style="text-align: center;">15</td>
											</tr>
										</table>
									</td>
									<td width="20%" style="text-align: center;">
										<input type="text" class="input-sm form-control" id="F1042_TAXLIABLE_NOV15" name="F1042_TAXLIABLE_NOV15"
										value="<%=formData.get("F1042_TAXLIABLE_NOV15") != null ? formData.get("F1042_TAXLIABLE_NOV15") : ""%>"/>
									</td>
								</tr>
								<tr>
									<td width="3%" style="text-align: center; font-weight: bold;">
										13
									</td>
									<td width="10%" style="text-align: center;">
										<table>
											<tr>
												<td width="80%" rowspan="4" style="text-align: center;">&nbsp;Mar.&nbsp;&nbsp;&nbsp;&nbsp;</td>
												<td width="10%" style="text-align: center;">22</td>
											</tr>
										</table>
									</td>
									<td width="20%" style="text-align: center;">
										<input type="text" class="input-sm form-control" id="F1042_TAXLIABLE_MAR22" name="F1042_TAXLIABLE_MAR22"
										value="<%=formData.get("F1042_TAXLIABLE_MAR22") != null ? formData.get("F1042_TAXLIABLE_MAR22") : ""%>"/>
									</td>
									<td width="3%" style="text-align: center; font-weight: bold;">
										33 
									</td>
									<td width="10%" style="text-align: center;">
										<table>
											<tr>
												<td width="80%" style="text-align: center;">&nbsp;July&nbsp;&nbsp;&nbsp;&nbsp;</td>
												<td width="10%" style="text-align: center;">22</td>
											</tr>
										</table>
									</td>
									<td width="20%" style="text-align: center;">
										<input type="text" class="input-sm form-control" id="F1042_TAXLIABLE_JULY22" name="F1042_TAXLIABLE_JULY22"
										value="<%=formData.get("F1042_TAXLIABLE_JULY22") != null ? formData.get("F1042_TAXLIABLE_JULY22") : ""%>"/>
									</td>
									<td width="3%" style="text-align: center; font-weight: bold;">
										53
									</td>
									<td width="10%" style="text-align: center;">
										<table>
											<tr>
												<td width="80%" style="text-align: center;">&nbsp;Nov.&nbsp;&nbsp;&nbsp;&nbsp;</td>
												<td width="10%" style="text-align: center;">22</td>
											</tr>
										</table>
									</td>
									<td width="20%" style="text-align: center;">
										<input type="text" class="input-sm form-control" id="F1042_TAXLIABLE_NOV22" name="F1042_TAXLIABLE_NOV22"
										value="<%=formData.get("F1042_TAXLIABLE_NOV22") != null ? formData.get("F1042_TAXLIABLE_NOV22") : ""%>"/>
									</td>
								</tr>
								<tr>
									<td width="3%" style="text-align: center; font-weight: bold;">
										14
									</td>
									<td width="10%" style="text-align: center;">
										<table>
											<tr>
												<td width="80%" rowspan="4" style="text-align: center;">&nbsp;Mar.&nbsp;&nbsp;&nbsp;&nbsp;</td>
												<td width="10%" style="text-align: center;">31</td>
											</tr>
										</table>
									</td>
									<td width="20%" style="text-align: center;">
										<input type="text" class="input-sm form-control" id="F1042_TAXLIABLE_MAR31" name="F1042_TAXLIABLE_MAR31"
										value="<%=formData.get("F1042_TAXLIABLE_MAR31") != null ? formData.get("F1042_TAXLIABLE_MAR31") : ""%>"/>
									</td>
									<td width="3%" style="text-align: center; font-weight: bold;">
										34
									</td>
									<td width="10%" style="text-align: center;">
										<table>
											<tr>
												<td width="80%" style="text-align: center;">&nbsp;July&nbsp;&nbsp;&nbsp;&nbsp;</td>
												<td width="10%" style="text-align: center;">31</td>
											</tr>
										</table>
									</td>
									<td width="20%" style="text-align: center;">
										<input type="text" class="input-sm form-control" id="F1042_TAXLIABLE_JULY31" name="F1042_TAXLIABLE_JULY31"
										value="<%=formData.get("F1042_TAXLIABLE_JULY31") != null ? formData.get("F1042_TAXLIABLE_JULY31") : ""%>"/>
									</td>
									<td width="3%" style="text-align: center; font-weight: bold;">
										54
									</td>
									<td width="10%" style="text-align: center;">
										<table>
											<tr>
												<td width="80%" style="text-align: center;">&nbsp;Nov.&nbsp;&nbsp;&nbsp;&nbsp;</td>
												<td width="10%" style="text-align: center;">30</td>
											</tr>
										</table>
									</td>
									<td width="20%" style="text-align: center;">
										<input type="text" class="input-sm form-control" id="F1042_TAXLIABLE_NOV30" name="F1042_TAXLIABLE_NOV30"
										value="<%=formData.get("F1042_TAXLIABLE_NOV30") != null ? formData.get("F1042_TAXLIABLE_NOV30") : ""%>"/>
									</td>
								</tr>
								<tr>
									<td width="3%" style="text-align: center; font-weight: bold;">
										15
									</td>
									<td width="10%" style="text-align: center;">
										<table>
											<tr>
												<td width="80%" style="text-align: center; font-weight: bold;">&nbsp;Mar.&nbsp;&nbsp;&nbsp;</td>
												<td width="10%" style="text-align: center; font-weight: bold;">total</td>
											</tr>
										</table>
									</td>
									<td width="20%" style="text-align: center;">
										<input type="text" class="input-sm form-control" id="F1042_TAXLIABLE_MARTOTAL" name="F1042_TAXLIABLE_MARTOTAL"
										value="<%=formData.get("F1042_TAXLIABLE_MARTOTAL") != null ? formData.get("F1042_TAXLIABLE_MARTOTAL") : ""%>"/>
									</td>
									<td width="3%" style="text-align: center; font-weight: bold;">
										35
									</td>
									<td width="10%" style="text-align: center;">
										<table>
											<tr>
												<td width="80%" style="text-align: center;font-weight: bold;">&nbsp;July&nbsp;&nbsp;&nbsp;&nbsp;</td>
												<td width="10%" style="text-align: center; font-weight: bold;">total</td>
											</tr>
										</table>
									</td>
									<td width="20%" style="text-align: center;">
										<input type="text" class="input-sm form-control" id="F1042_TAXLIABLE_JULYTOTAL" name="F1042_TAXLIABLE_JULYTOTAL"
										value="<%=formData.get("F1042_TAXLIABLE_JULYTOTAL") != null ? formData.get("F1042_TAXLIABLE_JULYTOTAL") : ""%>"/>
									</td>
									<td width="3%" style="text-align: center; font-weight: bold;">
										55
									</td>
									<td width="10%" style="text-align: center;">
										<table>
											<tr>
												<td width="80%" style="text-align: center;font-weight: bold;">&nbsp;Nov.&nbsp;&nbsp;&nbsp;</td>
												<td width="10%" style="text-align: center;font-weight: bold;">total</td>
											</tr>
										</table>
									</td>
									<td width="20%" style="text-align: center;">
										<input type="text" class="input-sm form-control" id="F1042_TAXLIABLE_NOVTOTAL" name="F1042_TAXLIABLE_NOVTOTAL"
										value="<%=formData.get("F1042_TAXLIABLE_NOVTOTAL") != null ? formData.get("F1042_TAXLIABLE_NOVTOTAL") : ""%>"/>
									</td>
								</tr>
								
								<tr>
									<td width="3%" style="text-align: center; font-weight: bold;">
										16
									</td>
									<td width="10%"  style="text-align: center;">
										<table>
											<tr>
												<td width="80%" style="text-align: center;">&nbsp;Apr.&nbsp;&nbsp;&nbsp;&nbsp;</td>
												<td width="10%" style="text-align: center;">7</td>
											</tr>
										</table>
									</td>
									<td width="20%" style="text-align: center;">
										<input type="text" class="input-sm form-control" id="F1042_TAXLIABLE_APR7" name="F1042_TAXLIABLE_APR7"
										value="<%=formData.get("F1042_TAXLIABLE_APR7") != null ? formData.get("F1042_TAXLIABLE_APR7") : ""%>"/>
									</td>
									<td width="3%" style="text-align: center; font-weight: bold;">
										36
									</td>
									<td width="10%" style="text-align: center;">
										<table>
											<tr>
												<td width="80%" style="text-align: center;">&nbsp;Aug.&nbsp;&nbsp;&nbsp;&nbsp;</td>
												<td width="10%" style="text-align: center;">7</td>
											</tr>
										</table>
									</td>
									<td width="20%" style="text-align: center;">
										<input type="text" class="input-sm form-control" id="F1042_TAXLIABLE_AUG7" name="F1042_TAXLIABLE_AUG7"
										value="<%=formData.get("F1042_TAXLIABLE_AUG7") != null ? formData.get("F1042_TAXLIABLE_AUG7") : ""%>"/>
									</td>
									<td width="3%" style="text-align: center; font-weight: bold;">
										56
									</td>
									<td width="10%" style="text-align: center;">
										<table>
											<tr>
												<td width="80%" style="text-align: center;">&nbsp;Dec.&nbsp;&nbsp;&nbsp;&nbsp;</td>
												<td width="10%" style="text-align: center;">7</td>
											</tr>
										</table>
									</td>
									<td width="20%" style="text-align: center;">
										<input type="text" class="input-sm form-control" id="F1042_TAXLIABLE_DEC7" name="F1042_TAXLIABLE_DEC7"
										value="<%=formData.get("F1042_TAXLIABLE_DEC7") != null ? formData.get("F1042_TAXLIABLE_DEC7") : ""%>"/>
									</td>
								</tr>
								<tr>
									<td width="3%" style="text-align: center; font-weight: bold;">
										17
									</td>
									<td width="10%" style="text-align: center;">
										<table>
											<tr>
												<td width="80%" style="text-align: center;">&nbsp;Apr.&nbsp;&nbsp;&nbsp;&nbsp;</td>
												<td width="10%" style="text-align: center;">15</td>
											</tr>
										</table>
									</td>
									<td width="20%" style="text-align: center;">
										<input type="text" class="input-sm form-control" id="F1042_TAXLIABLE_APR15" name="F1042_TAXLIABLE_APR15"
										value="<%=formData.get("F1042_TAXLIABLE_APR15") != null ? formData.get("F1042_TAXLIABLE_APR15") : ""%>"/>
									</td>
									<td width="3%" style="text-align: center; font-weight: bold;">
										37
									</td>
									<td width="10%" style="text-align: center;">
										<table>
											<tr>
												<td width="80%" style="text-align: center;">&nbsp;Aug.&nbsp;&nbsp;&nbsp;&nbsp;</td>
												<td width="10%" style="text-align: center;">15</td>
											</tr>
										</table>
									</td>
									<td width="20%" style="text-align: center;">
										<input type="text" class="input-sm form-control" id="F1042_TAXLIABLE_AUG15" name="F1042_TAXLIABLE_AUG15"
										value="<%=formData.get("F1042_TAXLIABLE_AUG15") != null ? formData.get("F1042_TAXLIABLE_AUG15") : ""%>"/>
									</td>
									<td width="3%" style="text-align: center; font-weight: bold;">
										57
									</td>
									<td width="10%" style="text-align: center;">
										<table>
											<tr>
												<td width="80%" style="text-align: center;">&nbsp;Dec.&nbsp;&nbsp;&nbsp;&nbsp;</td>
												<td width="10%" style="text-align: center;">15</td>
											</tr>
										</table>
									</td>
									<td width="20%" style="text-align: center;">
										<input type="text" class="input-sm form-control" id="F1042_TAXLIABLE_DEC15" name="F1042_TAXLIABLE_DEC15"
										value="<%=formData.get("F1042_TAXLIABLE_DEC15") != null ? formData.get("F1042_TAXLIABLE_DEC15") : ""%>"/>
									</td>
								</tr>
								<tr>
									<td width="3%" style="text-align: center; font-weight: bold;">
										18
									</td>
									<td width="10%" style="text-align: center;">
										<table>
											<tr>
												<td width="80%" rowspan="4" style="text-align: center;">&nbsp;Apr.&nbsp;&nbsp;&nbsp;&nbsp;</td>
												<td width="10%" style="text-align: center;">22</td>
											</tr>
										</table>
									</td>
									<td width="20%" style="text-align: center;">
										<input type="text" class="input-sm form-control" id="F1042_TAXLIABLE_APR22" name="F1042_TAXLIABLE_APR22"
										value="<%=formData.get("F1042_TAXLIABLE_APR22") != null ? formData.get("F1042_TAXLIABLE_APR22") : ""%>"/>
									</td>
									<td width="3%" style="text-align: center; font-weight: bold;">
										38 
									</td>
									<td width="10%" style="text-align: center;">
										<table>
											<tr>
												<td width="80%" style="text-align: center;">&nbsp;Aug.&nbsp;&nbsp;&nbsp;&nbsp;</td>
												<td width="10%" style="text-align: center;">22</td>
											</tr>
										</table>
									</td>
									<td width="20%" style="text-align: center;">
										<input type="text" class="input-sm form-control" id="F1042_TAXLIABLE_AUG22" name="F1042_TAXLIABLE_AUG22"
										value="<%=formData.get("F1042_TAXLIABLE_AUG22") != null ? formData.get("F1042_TAXLIABLE_AUG22") : ""%>"/>
									</td>
									<td width="3%" style="text-align: center; font-weight: bold;">
										58
									</td>
									<td width="10%" style="text-align: center;">
										<table>
											<tr>
												<td width="80%" style="text-align: center;">&nbsp;Dec.&nbsp;&nbsp;&nbsp;&nbsp;</td>
												<td width="10%" style="text-align: center;">22</td>
											</tr>
										</table>
									</td>
									<td width="20%" style="text-align: center;">
										<input type="text" class="input-sm form-control" id="F1042_TAXLIABLE_DEC22" name="F1042_TAXLIABLE_DEC22"
										value="<%=formData.get("F1042_TAXLIABLE_DEC22") != null ? formData.get("F1042_TAXLIABLE_DEC22") : ""%>"/>
									</td>
								</tr>
								<tr>
									<td width="3%" style="text-align: center; font-weight: bold;">
										19
									</td>
									<td width="10%" style="text-align: center;">
										<table>
											<tr>
												<td width="80%" rowspan="4" style="text-align: center;">&nbsp;Apr.&nbsp;&nbsp;&nbsp;&nbsp;</td>
												<td width="10%" style="text-align: center;">30</td>
											</tr>
										</table>
									</td>
									<td width="20%" style="text-align: center;">
										<input type="text" class="input-sm form-control" id="F1042_TAXLIABLE_APR30" name="F1042_TAXLIABLE_APR30"
										value="<%=formData.get("F1042_TAXLIABLE_APR30") != null ? formData.get("F1042_TAXLIABLE_APR30") : ""%>"/>
									</td>
									<td width="3%" style="text-align: center; font-weight: bold;">
										39
									</td>
									<td width="10%" style="text-align: center;">
										<table>
											<tr>
												<td width="80%" style="text-align: center;">&nbsp;Aug.&nbsp;&nbsp;&nbsp;&nbsp;</td>
												<td width="10%" style="text-align: center;">31</td>
											</tr>
										</table>
									</td>
									<td width="20%" style="text-align: center;">
										<input type="text" class="input-sm form-control" id="F1042_TAXLIABLE_AUG31" name="F1042_TAXLIABLE_AUG31"
										value="<%=formData.get("F1042_TAXLIABLE_AUG31") != null ? formData.get("F1042_TAXLIABLE_AUG31") : ""%>"/>
									</td>
									<td width="3%" style="text-align: center; font-weight: bold;">
										59
									</td>
									<td width="10%" style="text-align: center;">
										<table>
											<tr>
												<td width="80%" style="text-align: center;">&nbsp;Dec.&nbsp;&nbsp;&nbsp;&nbsp;</td>
												<td width="10%" style="text-align: center;">31</td>
											</tr>
										</table>
									</td>
									<td width="20%" style="text-align: center;">
										<input type="text" class="input-sm form-control" id="F1042_TAXLIABLE_DEC31" name="F1042_TAXLIABLE_DEC31"
										value="<%=formData.get("F1042_TAXLIABLE_DEC31") != null ? formData.get("F1042_TAXLIABLE_DEC31") : ""%>"/>
									</td>
								</tr>
								<tr>
									<td width="3%" style="text-align: center; font-weight: bold;">
										20
									</td>
									<td width="10%" style="text-align: center;">
										<table>
											<tr>
												<td width="80%" style="text-align: center; font-weight: bold;">&nbsp;Apr.&nbsp;&nbsp;&nbsp;</td>
												<td width="10%" style="text-align: center; font-weight: bold;">total</td>
											</tr>
										</table>
									</td>
									<td width="20%" style="text-align: center;">
										<input type="text" class="input-sm form-control" id="F1042_TAXLIABLE_APRTOTAL" name="F1042_TAXLIABLE_APRTOTAL"
										value="<%=formData.get("F1042_TAXLIABLE_APRTOTAL") != null ? formData.get("F1042_TAXLIABLE_APRTOTAL") : ""%>"/>
									</td>
									<td width="3%" style="text-align: center; font-weight: bold;">
										40
									</td>
									<td width="10%" style="text-align: center;">
										<table>
											<tr>
												<td width="80%" style="text-align: center;font-weight: bold;">&nbsp;Aug.&nbsp;&nbsp;&nbsp;&nbsp;</td>
												<td width="10%" style="text-align: center; font-weight: bold;">total</td>
											</tr>
										</table>
									</td>
									<td width="20%" style="text-align: center;">
										<input type="text" class="input-sm form-control" id="F1042_TAXLIABLE_AUGTOTAL" name="F1042_TAXLIABLE_AUGTOTAL"
										value="<%=formData.get("F1042_TAXLIABLE_AUGTOTAL") != null ? formData.get("F1042_TAXLIABLE_AUGTOTAL") : ""%>"/>
									</td>
									<td width="3%" style="text-align: center; font-weight: bold;">
										60
									</td>
									<td width="10%" style="text-align: center;">
										<table>
											<tr>
												<td width="80%" style="text-align: center;font-weight: bold;">&nbsp;Dec.&nbsp;&nbsp;&nbsp;</td>
												<td width="10%" style="text-align: center;font-weight: bold;">total</td>
											</tr>
										</table>
									</td>
									<td width="20%" style="text-align: center;">
										<input type="text" class="input-sm form-control" id="F1042_TAXLIABLE_DECTOTAL" name="F1042_TAXLIABLE_DECTOTAL"
										value="<%=formData.get("F1042_TAXLIABLE_DECTOTAL") != null ? formData.get("F1042_TAXLIABLE_DECTOTAL") : ""%>"/>
									</td>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td colspan="5">
							<table>
								<tr>
									<td colspan="5"><font style="font-weight: bold;">61. No. of Forms 1042-S filed: </font></td>
								</tr>
								<tr>
									<td width="24%">
										&nbsp; &nbsp;&nbsp;<font style="font-weight: bold;">a.</font> On paper
									</td>
									<td width="25%">
										<input type="text" class="input-sm form-control" id="F1042_1042SFORM_PAPER" name="F1042_1042SFORM_PAPER"
										value="<%=formData.get("F1042_1042SFORM_PAPER") != null ? formData.get("F1042_1042SFORM_PAPER") : ""%>"/>
									</td>
									<td width="2%">&nbsp;</td>
									<td width="24%">
										<font style="font-weight: bold;">b.</font> Electronically
									</td>
									<td width="25%">
										<input type="text" class="input-sm form-control" id="F1042_1042SFORM_ELECTRONIC" name="F1042_1042SFORM_ELECTRONIC"
										value="<%=formData.get("F1042_1042SFORM_ELECTRONIC") != null ? formData.get("F1042_1042SFORM_ELECTRONIC") : ""%>"/>
									</td>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td colspan="5">
							<table>
								<tr>
									<td colspan="5"><font style="font-weight: bold;">62.</font> Total gross amounts reported on all Forms 1042-S and 1000: </td>
								</tr>
								<tr>
									<td colspan="4">
										&nbsp; &nbsp;&nbsp;<font style="font-weight: bold;">a.</font>Total U.S. source FDAP income (other than U.S. source substitute payments) reported
									</td>
									<td colspan="1">
										<input type="text" class="input-sm form-control" id="F1042_US_FDAP_TOTALINCOME" name="F1042_US_FDAP_TOTALINCOME"
										value="<%=formData.get("F1042_US_FDAP_TOTALINCOME") != null ? formData.get("F1042_US_FDAP_TOTALINCOME") : ""%>"/>
									</td>
								</tr>
								<tr>
									<td colspan="5">
										&nbsp; &nbsp;&nbsp;<font style="font-weight: bold;">b.</font>Total U.S. source substitute payments reported: 
									</td>
								</tr>
								<tr style="font-size: 12px;">
									<td width="24%">
										&nbsp;&nbsp;&nbsp;&nbsp;(1) Total U.S. source substitute &nbsp;&nbsp;&nbsp;&nbsp;dividend payments reported 
									</td>
									<td width="25%">
										<input type="text" class="input-sm form-control" id="F1042_TOTALUSSRC_DIVPAYMENT" name="F1042_TOTALUSSRC_DIVPAYMENT"
										value="<%=formData.get("F1042_TOTALUSSRC_DIVPAYMENT") != null ? formData.get("F1042_TOTALUSSRC_DIVPAYMENT") : ""%>"/>
									</td>
									<td width="2%">&nbsp;</td>
									<td width="24%">
										(2) Total U.S. source substitute payments reported other than substitute dividend payments 
									</td>
									<td width="25%">
										<input type="text" class="input-sm form-control" id="F1042_TOTALUSSRC_DIVPAYMENTOTR" name="F1042_TOTALUSSRC_DIVPAYMENTOTR"
										value="<%=formData.get("F1042_TOTALUSSRC_DIVPAYMENTOTR") != null ? formData.get("F1042_TOTALUSSRC_DIVPAYMENTOTR") : ""%>"/>
									</td>
								</tr>
								<tr>
									<td colspan="4">
										&nbsp; &nbsp;&nbsp;<font style="font-weight: bold;">c. Total gross amounts reported</font> (Add lines 62a-b) 
									</td>
									<td colspan="1">
										<input type="text" class="input-sm form-control" id="F1042_TOTALGROSSAMT" name="F1042_TOTALGROSSAMT"
										value="<%=formData.get("F1042_TOTALGROSSAMT") != null ? formData.get("F1042_TOTALGROSSAMT") : ""%>"/>
									</td>
								</tr>
								<tr>
									<td colspan="4">
										&nbsp; &nbsp;&nbsp;<font style="font-weight: bold;">d.</font>Enter gross amounts actually paid if different from gross amounts reported 
									</td>
									<td colspan="1">
										<input type="text" class="input-sm form-control" id="F1042_GROSSAMTPAID" name="F1042_GROSSAMTPAID"
										value="<%=formData.get("F1042_GROSSAMTPAID") != null ? formData.get("F1042_GROSSAMTPAID") : ""%>"/>
									</td>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td colspan="1">
							<font style="font-weight: bold;">Third Party Designee</font>
						</td>
						<td colspan="4">
							<table>
								<tr>
									<td width="75%">Do you want to allow another person to discuss this return with the IRS (see instructions)?</td>
									<td width="10%">
										&nbsp;&nbsp;&nbsp;&nbsp;Yes&nbsp;&nbsp;<input type="radio" class="input-sm form-control" id="F1042_IRSRETURN_ALWOTRPERSON_YES" name="F1042_IRSRETURN_ALWOTRPERSON" value="YES" 
										 <% if("YES".equals(formData.get("F1042_IRSRETURN_ALWOTRPERSON"))){ %> checked="checked" <%} %>/>
									</td>
									<td width="5%">&nbsp;</td>
									<td width="10%">
										&nbsp;&nbsp;&nbsp;&nbsp;No&nbsp;&nbsp;<input type="radio" class="input-sm form-control" id="F1042_IRSRETURN_ALWOTRPERSON_NO" name="F1042_IRSRETURN_ALWOTRPERSON" value="NO" 
										 <% if("NO".equals(formData.get("F1042_IRSRETURN_ALWOTRPERSON"))){ %> checked="checked" <%} %>/>
									</td>
								</tr>
								<tr>
									<td colspan="5">
										<table>
											<tr style="font-size: 12px;">
												<td width="15%">Designee’s name</td>
												<td width="10%">
													<input type="text" class="input-sm form-control" id="F1042_DESIGNEE_NAME" name="F1042_DESIGNEE_NAME"
													value="<%=formData.get("F1042_DESIGNEE_NAME") != null ? formData.get("F1042_DESIGNEE_NAME") : ""%>"/>
												</td>
												<td width="5%">&nbsp;</td>
												<td width="15%">Phone no.</td>
												<td width="10%">
													<input type="text" class="input-sm form-control" id="F1042_PHONE_NO" name="F1042_PHONE_NO"
													value="<%=formData.get("F1042_PHONE_NO") != null ? formData.get("F1042_PHONE_NO") : ""%>"/>
												</td>
												<td width="5%">&nbsp;</td>
												<td width="30%">Personal Identification Number (PIN)</td>
												<td width="10%">
													<input type="text" class="input-sm form-control" id="F1042_ID_NUM" name="F1042_ID_NUM"
													value="<%=formData.get("F1042_ID_NUM") != null ? formData.get("F1042_ID_NUM") : ""%>"/>
												</td>
											</tr>
										</table>
									</td>
									
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td colspan="1">
							<font style="font-weight: bold;">Sign Here</font>
						</td>
						<td colspan="4">
							<table>
								<tr>
									<td width="100%">
										Under penalties of perjury, I declare that I have examined this return, 
										including accompanying schedules and statements, and to the best of my knowledge and belief, 
										it is true, correct, and complete. Declaration of preparer (other than withholding agent) 
										is based on all information of which preparer has any knowledge.
									</td>
								</tr>
								<tr>
									<td colspan="5">
										<table>
											<tr style="font-size: 12px;">
												<td width="35%">Your signature&nbsp;</td>
												<td width="10%">
													<input type="text" class="input-sm form-control" id="F1042_SIGNATURE" name="F1042_SIGNATURE"
													value="<%=formData.get("F1042_SIGNATURE") != null ? formData.get("F1042_SIGNATURE") : ""%>"/>
												</td>
												<td width="10%">&nbsp;</td>
												<td width="35%">Date</td>
												<td width="10%">
													<input type="text" class="input-sm form-control FATCAdatepicker" id="F1042_SIGNDATE" name="F1042_SIGNDATE"
													value="<%=formData.get("F1042_SIGNDATE") != null ? formData.get("F1042_SIGNDATE") : ""%>"/>
												</td>
											</tr>
											<tr style="font-size: 12px;">
												<td width="35%">Capacity in which acting </td>
												<td width="10%">
													<input type="text" class="input-sm form-control" id="F1042_ACTING_CAPACITY" name="F1042_ACTING_CAPACITY"
													value="<%=formData.get("F1042_ACTING_CAPACITY") != null ? formData.get("F1042_ACTING_CAPACITY") : ""%>"/>
												</td>
												<td width="10%">&nbsp;</td>
												<td width="35%">Daytime phone number </td>
												<td width="10%">
													<input type="text" class="input-sm form-control" id="F1042_DAYTIME_PHNO" name="F1042_DAYTIME_PHNO"
													value="<%=formData.get("F1042_DAYTIME_PHNO") != null ? formData.get("F1042_DAYTIME_PHNO") : ""%>"/>
												</td>
											</tr>
										</table>
									</td>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td colspan="1">
							<font style="font-weight: bold;">Paid Preparer Use Only</font>
						</td>
						<td colspan="4">
							<table>
								<tr>
									<td width="35%">Print/Type preparer’s name</td>
									<td width="10%">
										<input type="text" class="input-sm form-control" id="F1042_PREPARERSNAME" name="F1042_PREPARERSNAME"
										value="<%=formData.get("F1042_PREPARERSNAME") != null ? formData.get("F1042_PREPARERSNAME") : ""%>"/>
									</td>
									<td width="10%">&nbsp;</td>
									<td width="35%">Preparer’s signature</td>
									<td width="10%">
										<input type="text" class="input-sm form-control" id="F1042_PREPARERSSIGN" name="F1042_PREPARERSSIGN"
										value="<%=formData.get("F1042_PREPARERSSIGN") != null ? formData.get("F1042_PREPARERSSIGN") : ""%>"/>
									</td>
								</tr>
								<tr>
									<td width="35%">Date</td>
									<td width="10%">
										<input type="text" class="input-sm form-control" id="F1042_PAIDDATE" name="F1042_PAIDDATE"
										value="<%=formData.get("F1042_PAIDDATE") != null ? formData.get("F1042_PAIDDATE") : ""%>"/>
									</td>
									<td width="10%">&nbsp;</td>									
									<td width="35%">Check if self-employed </td>
									<td width="10%">
										&nbsp;&nbsp;&nbsp;<input type="checkbox" class="input-sm form-control" id="F1042_SELFEMP_CHECK" name="F1042_SELFEMP_CHECK" value="F1042_SELFEMP"
										<% if("F1042_SELFEMP".equals(formData.get("F1042_SELFEMP_CHECK"))){ %> checked="checked" <%} %>/>
									</td>
								</tr>
								<tr>
									<td colspan="5">PTIN 
										<input type="text" class="input-sm form-control" id="F1042_PTIN" name="F1042_PTIN"
										value="<%=formData.get("F1042_PTIN") != null ? formData.get("F1042_PTIN") : ""%>"/>
									</td>
								</tr>
								<tr>
									<td width="35%">Firm’s name</td>
									<td width="10%">
										<input type="text" class="input-sm form-control" id="F1042_FIRMNAME" name="F1042_FIRMNAME"
										value="<%=formData.get("F1042_FIRMNAME") != null ? formData.get("F1042_FIRMNAME") : ""%>"/>
									</td>
									<td width="10%">&nbsp;</td>									
									<td width="35%">Firm's EIN </td>
									<td width="10%">
										<input type="text" class="input-sm form-control" id="F1042_FIRMEIN" name="F1042_FIRMEIN"
										value="<%=formData.get("F1042_FIRMEIN") != null ? formData.get("F1042_FIRMEIN") : ""%>"/>
									</td>
								</tr>
								<tr>
									<td width="35%">Firm’s address </td>
									<td width="10%">
										<input type="text" class="input-sm form-control" id="F1042_FIRMADDRESS" name="F1042_FIRMADDRESS"
										value="<%=formData.get("F1042_FIRMADDRESS") != null ? formData.get("F1042_FIRMADDRESS") : ""%>"/>
									</td>
									<td width="10%">&nbsp;</td>									
									<td width="35%">Phone no.</td>
									<td width="10%">
										<input type="text" class="input-sm form-control" id="F1042_FIRMPHNO" name="F1042_FIRMPHNO"
										value="<%=formData.get("F1042_FIRMPHNO") != null ? formData.get("F1042_FIRMPHNO") : ""%>"/>
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</div>
<div>
	<table>	
		<tr>		
			<td width="65%"><font style="font-weight: bold;">For Privacy Act and Paperwork Reduction Act Notice, see instructions.</font></td>
			<td width="15%">&nbsp;&nbsp;&nbsp;Cat.No. 11384V&nbsp;&nbsp;&nbsp;&nbsp;</td>
			<td width="20%">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Form <font style="font-weight: bold;">1042</font>(2016)</td>
		</tr>
	</table>
</div>
</div>
</div>
	<div class="section" style="padding: 0 7.5% 0 7.5%;">
		<div class="col-lg-12">
			<div class="card card-danger" style="margin-top: 20px; margin-bottom: 0;">
				<table>	
					<tr>
						<td colspan="5">
							<table>
								<tr>
									<td colspan="5"><font style="font-weight: bold;">63.</font> Total tax reported as withheld or paid by withholding agent on all Forms 1042-S and 1000: </td>
								</tr>
								<tr>
									<td colspan="4">
										&nbsp; &nbsp;&nbsp;<font style="font-weight: bold;">a.</font>Tax withheld by withholding agent 
									</td>
									<td colspan="1">
										<input type="text" class="input-sm form-control" id="F1042_TAXWH_BYWHAGENT" name="F1042_TAXWH_BYWHAGENT"
										value="<%=formData.get("F1042_TAXWH_BYWHAGENT") != null ? formData.get("F1042_TAXWH_BYWHAGENT") : ""%>"/>
									</td>
								</tr>
								<tr>
									<td colspan="5">
										&nbsp; &nbsp;&nbsp;<font style="font-weight: bold;">b.</font>Tax withheld by other withholding agents:
									</td>
								</tr>
								<tr style="font-size: 12px;">
									<td width="24%">
										&nbsp;&nbsp;&nbsp;&nbsp;(1) For payments other than substitute dividends 
									</td>
									<td width="25%">
										<input type="text" class="input-sm form-control" id="F1042_OTRSDTAXPAY_WHAGENT" name="F1042_OTRSDTAXPAY_WHAGENT"
										value="<%=formData.get("F1042_OTRSDTAXPAY_WHAGENT") != null ? formData.get("F1042_OTRSDTAXPAY_WHAGENT") : ""%>"/>
									</td>
									<td width="2%">&nbsp;</td>
									<td width="24%">
										(2) For substitute dividends  
									</td>
									<td width="25%">
										<input type="text" class="input-sm form-control" id="F1042_SDTAXPAY_WHAGENT" name="F1042_SDTAXPAY_WHAGENT"
										value="<%=formData.get("F1042_SDTAXPAY_WHAGENT") != null ? formData.get("F1042_SDTAXPAY_WHAGENT") : ""%>"/>
									</td>
								</tr>
								<tr>
									<td colspan="5">
										&nbsp; &nbsp;&nbsp;<font style="font-weight: bold;">c.</font>Adjustments to withholding:
									</td>
								</tr>
								<tr style="font-size: 12px;">
									<td width="24%">
										&nbsp;&nbsp;&nbsp;&nbsp;(1) Adjustments to overwithholding  
									</td>
									<td width="25%">
										<input type="text" class="input-sm form-control" id="F1042_OVERWH_ADJUSTMENT" name="F1042_OVERWH_ADJUSTMENT"
										value="<%=formData.get("F1042_OVERWH_ADJUSTMENT") != null ? formData.get("F1042_OVERWH_ADJUSTMENT") : ""%>"/>
									</td>
									<td width="2%">&nbsp;</td>
									<td width="24%">
										(2) Adjustments to underwithholding   
									</td>
									<td width="25%">
										<input type="text" class="input-sm form-control" id="F1042_UNDERWH_ADJUSTMENT" name="F1042_UNDERWH_ADJUSTMENT"
										value="<%=formData.get("F1042_UNDERWH_ADJUSTMENT") != null ? formData.get("F1042_UNDERWH_ADJUSTMENT") : ""%>"/>
									</td>
								</tr>
								<tr>
									<td colspan="4">
										&nbsp; &nbsp;&nbsp;<font style="font-weight: bold;">d.</font>Tax paid by withholding agent 
									</td>
									<td colspan="1">
										<input type="text" class="input-sm form-control" id="F1042_TAXPAIDBY_WHAGENT" name="F1042_TAXPAIDBY_WHAGENT"
										value="<%=formData.get("F1042_TAXPAIDBY_WHAGENT") != null ? formData.get("F1042_TAXPAIDBY_WHAGENT") : ""%>"/>
									</td>
								</tr>
								<tr>
									<td colspan="4">
										&nbsp; &nbsp;&nbsp;<font style="font-weight: bold;">e. Total tax reported as withheld or paid </font> 
									</td>
									<td colspan="1">
										<input type="text" class="input-sm form-control" id="F1042_TOTALTAX_PAIDORWH" name="F1042_TOTALTAX_PAIDORWH"
										value="<%=formData.get("F1042_TOTALTAX_PAIDORWH") != null ? formData.get("F1042_TOTALTAX_PAIDORWH") : ""%>"/>
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</div>
			<div>
				<table>	
					<tr>		
						<td width="65%"><font style="font-weight: bold;">For Privacy Act and Paperwork Reduction Act Notice, see instructions.</font></td>
						<td width="15%">&nbsp;&nbsp;&nbsp;Cat.No. 11386R </td>
						<td width="20%">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Form <font style="font-weight: bold;">1042-S</font>(2017)</td>
					</tr>
				</table>
			</div>
		</div>
	</div>
	<!-- COPY A ENDING -->
	
	<!-- 64 STARTING -->
	<div class="section" style="padding: 0 7.5% 0 7.5%;">
		<div class="col-lg-12">
			<div class="card card-danger" style="margin-top: 20px; margin-bottom: 0;">
				<table>	
					<tr>
						<td colspan="5">
							<table>
								<tr>
									<td colspan="5"><font style="font-weight: bold;">64.</font> Total net tax liability: </td>
								</tr>
								<tr>
									<td colspan="4">
										&nbsp; &nbsp;&nbsp;<font style="font-weight: bold;">a.</font>Adjustments to total net tax liability 
									</td>
									<td colspan="1">
										<input type="text" class="input-sm form-control" id="F1042_TAXLIABLITY_ADJ" name="F1042_TAXLIABLITY_ADJ"
										value="<%=formData.get("F1042_TAXLIABLITY_ADJ") != null ? formData.get("F1042_TAXLIABLITY_ADJ") : ""%>"/>
									</td>
								</tr>
								<tr>
									<td colspan="4">
										&nbsp; &nbsp;&nbsp;<font style="font-weight: bold;">b.</font>Total net tax liability under chapter 3 
									</td>
									<td colspan="1">
										<input type="text" class="input-sm form-control" id="F1042_TAXLIABLITY_CHAP3" name="F1042_TAXLIABLITY_CHAP3"
										value="<%=formData.get("F1042_TAXLIABLITY_CHAP3") != null ? formData.get("F1042_TAXLIABLITY_CHAP3") : ""%>"/>
									</td>
								</tr>
								<tr>
									<td colspan="4">
										&nbsp; &nbsp;&nbsp;<font style="font-weight: bold;">c.</font>Total net tax liability under chapter 4 
									</td>
									<td colspan="1">
										<input type="text" class="input-sm form-control" id="F1042_TAXLIABLITY_CHAP4" name="F1042_TAXLIABLITY_CHAP4"
										value="<%=formData.get("F1042_TAXLIABLITY_CHAP4") != null ? formData.get("F1042_TAXLIABLITY_CHAP4") : ""%>"/>
									</td>
								</tr>
								<tr>
									<td colspan="4">
										&nbsp; &nbsp;&nbsp;<font style="font-weight: bold;">d.</font>Excise tax on specified federal procurement payments (Total payments made x 2%) 
									</td>
									<td colspan="1">
										<input type="text" class="input-sm form-control" id="F1042_TAXLIABLITY_EXCISE" name="F1042_TAXLIABLITY_EXCISE"
										value="<%=formData.get("F1042_TAXLIABLITY_EXCISE") != null ? formData.get("F1042_TAXLIABLITY_EXCISE") : ""%>"/>
									</td>
								</tr>
								<tr>
									<td colspan="4">
										&nbsp; &nbsp;&nbsp;<font style="font-weight: bold;">e. Total net tax liability </font> 
									</td>
									<td colspan="1">
										<input type="text" class="input-sm form-control" id="F1042_TAXLIABLITY_TOTAL" name="F1042_TAXLIABLITY_TOTAL"
										value="<%=formData.get("F1042_TAXLIABLITY_TOTAL") != null ? formData.get("F1042_TAXLIABLITY_TOTAL") : ""%>"/>
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</div>
			<div>
				<table>	
					<tr>		
						<td width="65%"><font style="font-weight: bold;">For Privacy Act and Paperwork Reduction Act Notice, see instructions.</font></td>
						<td width="15%">&nbsp;&nbsp;&nbsp;Cat.No. 11386R </td>
						<td width="20%">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Form <font style="font-weight: bold;">1042-S</font>(2017)</td>
					</tr>
				</table>
			</div>
		</div>
	</div>
	<!-- 64 ENDING -->
	
	<div class="section" style="padding: 0 7.5% 0 7.5%;">
		<div class="col-lg-12">
			<div class="card card-danger" style="margin-top: 20px; margin-bottom: 0;">
				<table>	
					<tr>
						<td colspan="5">
							<table>
								<tr>
									<td colspan="5"><font style="font-weight: bold;">65.</font> Total paid by electronic funds transfer (or with a request for extension of time to file): </td>
								</tr>
								<tr>
									<td colspan="4">
										&nbsp; &nbsp;&nbsp;<font style="font-weight: bold;">a.</font>Total paid during calendar year 
									</td>
									<td colspan="1">
										<input type="text" class="input-sm form-control" id="F1042_TOTALPAID_CALYEAR" name="F1042_TOTALPAID_CALYEAR"
										value="<%=formData.get("F1042_TOTALPAID_CALYEAR") != null ? formData.get("F1042_TOTALPAID_CALYEAR") : ""%>"/>
									</td>
								</tr>
								<tr>
									<td colspan="4">
										&nbsp; &nbsp;&nbsp;<font style="font-weight: bold;">b.</font>Total paid during subsequent year 
									</td>
									<td colspan="1">
										<input type="text" class="input-sm form-control" id="F1042_TOTALPAID_SUBSYEAR" name="F1042_TOTALPAID_SUBSYEAR"
										value="<%=formData.get("F1042_TOTALPAID_SUBSYEAR") != null ? formData.get("F1042_TOTALPAID_SUBSYEAR") : ""%>"/>
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
				<table>
					<tr>
						<td colspan="4">
							<font style="font-weight: bold;">66. &nbsp;</font>Enter overpayment applied as credit from 2015 Form 1042 
						</td>
						<td colspan="1">
							<input type="text" style="margin-left: 60px;" class="input-sm form-control" id="F1042_OVERPAYMENT" name="F1042_OVERPAYMENT"
							value="<%=formData.get("F1042_OVERPAYMENT") != null ? formData.get("F1042_OVERPAYMENT") : ""%>"/>
						</td>
					</tr>
					<tr>
						<td colspan="5">
							<table>
								<tr>
									<td colspan="5"><font style="font-weight: bold;">67.</font> Credit for amounts withheld by other withholding agents: </td>
								</tr>
								<tr>
									<td colspan="4">
										&nbsp; &nbsp;&nbsp;<font style="font-weight: bold;">a.</font>For payments other than substitute dividend payments 
									</td>
									<td colspan="1">
										<input type="text" class="input-sm form-control" id="F1042_BYWH_EXCEPT_SUBSDIVPAY" name="F1042_BYWH_EXCEPT_SUBSDIVPAY"
										value="<%=formData.get("F1042_BYWH_EXCEPT_SUBSDIVPAY") != null ? formData.get("F1042_BYWH_EXCEPT_SUBSDIVPAY") : ""%>"/>
									</td>
								</tr>
								<tr>
									<td colspan="4">
										&nbsp; &nbsp;&nbsp;<font style="font-weight: bold;">b.</font>For substitute dividend payments 
									</td>
									<td colspan="1">
										<input type="text" class="input-sm form-control" id="F1042_BYWH_FOR_SUBSDIVPAY" name="F1042_BYWH_FOR_SUBSDIVPAY"
										value="<%=formData.get("F1042_BYWH_FOR_SUBSDIVPAY") != null ? formData.get("F1042_BYWH_FOR_SUBSDIVPAY") : ""%>"/>
									</td>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td colspan="4">
							<font style="font-weight: bold;">68. &nbsp;</font><font style="font-weight: bold;">Total payments.</font>
						</td>
						<td colspan="1">
							<input type="text" class="input-sm form-control" id="F1042_TOTALPAYMENT" name="F1042_TOTALPAYMENT"
							value="<%=formData.get("F1042_TOTALPAYMENT") != null ? formData.get("F1042_TOTALPAYMENT") : ""%>"/>
						</td>
					</tr>
					<tr>
						<td colspan="4">
							<font style="font-weight: bold;">69. &nbsp;</font>If line 64e is larger than line 68, enter balance due here
						</td>
						<td colspan="1">
							<input type="text" class="input-sm form-control" id="F1042_DUE_BALANCE" name="F1042_DUE_BALANCE"
							value="<%=formData.get("F1042_DUE_BALANCE") != null ? formData.get("F1042_DUE_BALANCE") : ""%>"/>
						</td>
					</tr>
					<tr>
						<td colspan="5"><font style="font-weight: bold;">70.</font></td>
					</tr>
					<tr>
						<td colspan="4">
							&nbsp; &nbsp;&nbsp;<font style="font-weight: bold;">a.</font>Enter overpayment attributable to overwithholding on U.S. source income of foreign persons 
						</td>
						<td colspan="1">
							<input type="text" class="input-sm form-control" id="F1042_OVERPAY_OVERWH" name="F1042_OVERPAY_OVERWH"
							value="<%=formData.get("F1042_OVERPAY_OVERWH") != null ? formData.get("F1042_OVERPAY_OVERWH") : ""%>"/>
						</td>
					</tr>
					<tr>
						<td colspan="4">
							&nbsp; &nbsp;&nbsp;<font style="font-weight: bold;">b.</font>Enter overpayment attributable to excise tax on specified federal procurement payments 
						</td>
						<td colspan="1">
							<input type="text" class="input-sm form-control" id="F1042_OVERPAY_EXCISETAX" name="F1042_OVERPAY_EXCISETAX"
							value="<%=formData.get("F1042_OVERPAY_EXCISETAX") != null ? formData.get("F1042_OVERPAY_EXCISETAX") : ""%>"/>
						</td>
					</tr>
					<tr>
						<td colspan="5"><font style="font-weight: bold;">71.</font> Apply overpayment (sum of lines 70a and 70b) to (check one): </td>
					</tr>
					<tr>
						<td colspan="4">
							&nbsp; &nbsp;&nbsp;<font style="font-weight: bold; margin-left: 100px;"></font>Credit on 2017 Form 1042 
						</td>
						<td colspan="1">
							<input type="radio" id="F1042_APPLY_OVERPAY_CREDIT" name="F1042_APPLY_OVERPAY" value="CREDIT"
							<% if("CREDIT".equals(formData.get("F1042_APPLY_OVERPAY"))){ %> checked="checked" <%} %>/>
						</td>
					</tr>
					<tr>
						<td>&nbsp; &nbsp;&nbsp;<font style="font-weight: bold; margin-left: 140px;"></font>OR</td>
					</tr>
					<tr>
						<td colspan="4">
							&nbsp; &nbsp;&nbsp;<font style="font-weight: bold; margin-left: 130px;"></font>Refund 
						</td>
						<td colspan="1">
							<input type="radio" id="F1042_APPLY_OVERPAY_REFUND" name="F1042_APPLY_OVERPAY" value="REFUND"
							<% if("REFUND".equals(formData.get("F1042_APPLY_OVERPAY"))){ %> checked="checked" <%} %>/>
						</td>
					</tr>
				</table>
			</div>
		</div>
	</div>
	
	<!-- SECTION 2 -->
	<div class="section" style="padding: 0 7.5% 0 7.5%;">
		<div class="col-lg-12">
			<div class="card card-danger" style="margin-top: 20px; margin-bottom: 0;">
				<div class="sectionHeader">
					<div class="headerLeft">
						Section II
					</div>
					<div class="headerRight">
						&nbsp;&nbsp;&nbsp;
						<font style="font-weight: bold; font-size: 20px; text-align: center;" face="ITC Franklin Gothic Std Book" >Reconciliation of Payments of U.S. Source FDAP Income</font>
					</div>
				</div>
				<div class="section" style="padding: 0 7.5% 0 7.5%;">
					<table>
						<tr>
						<td colspan="4">
							<font style="font-weight: bold;">1.</font>Total U.S. source FDAP income required to be withheld upon under chapter 4
						</td>
						<td colspan="1">
							<input type="text" style="margin-left:40px;" class="input-sm form-control" id="F1042_TOTALFDAP_INCOME_WH" name="F1042_TOTALFDAP_INCOME_WH"
							value="<%=formData.get("F1042_TOTALFDAP_INCOME_WH") != null ? formData.get("F1042_TOTALFDAP_INCOME_WH") : ""%>"/>
						</td>
						</tr>
						<tr>
						<td colspan="5">
							<table>
								<tr>
									<td colspan="5"><font style="font-weight: bold;">2.</font>Total U.S. source FDAP income required to be reported under chapter 4 but not required to bewithheld upon under chapter 4 because: </td>
								</tr>
								<tr>
									<td colspan="4">
										&nbsp; &nbsp;&nbsp;<font style="font-weight: bold;">a.</font>Amount of income paid to recipients whose chapter 4 status established no withholding is required 
									</td>
									<td colspan="1">
										<input type="text" class="input-sm form-control" id="F1042_INCOME_4_NOWH" name="F1042_INCOME_4_NOWH"
										value="<%=formData.get("F1042_INCOME_4_NOWH") != null ? formData.get("F1042_INCOME_4_NOWH") : ""%>"/>
									</td>
								</tr>
								<tr>
									<td colspan="4">
										&nbsp; &nbsp;&nbsp;<font style="font-weight: bold;">b.</font>Amount of excluded nonfinancial payments 
									</td>
									<td colspan="1">
										<input type="text" class="input-sm form-control" id="F1042_EXCLUDED_NONFINPAY" name="F1042_EXCLUDED_NONFINPAY"
										value="<%=formData.get("F1042_EXCLUDED_NONFINPAY") != null ? formData.get("F1042_EXCLUDED_NONFINPAY") : ""%>"/>
									</td>
								</tr>
								<tr>
									<td colspan="4">
										&nbsp; &nbsp;&nbsp;<font style="font-weight: bold;">c.</font>Amount of income paid with respect to grandfathered obligations 
									</td>
									<td colspan="1">
										<input type="text" class="input-sm form-control" id="F1042_INCOMEPAID_GF_OBLIG" name="F1042_INCOMEPAID_GF_OBLIG"
										value="<%=formData.get("F1042_INCOMEPAID_GF_OBLIG") != null ? formData.get("F1042_INCOMEPAID_GF_OBLIG") : ""%>"/>
									</td>
								</tr>
								<tr>
									<td colspan="4">
										&nbsp; &nbsp;&nbsp;<font style="font-weight: bold;">d.</font>Amount of income effectively connected with the conduct of a trade or business in the U.S. 
									</td>
									<td colspan="1">
										<input type="text" class="input-sm form-control" id="F1042_INCOME_CONNECTED_TRADE" name="F1042_INCOME_CONNECTED_TRADE"
										value="<%=formData.get("F1042_INCOME_CONNECTED_TRADE") != null ? formData.get("F1042_INCOME_CONNECTED_TRADE") : ""%>"/>
									</td>
								</tr>
								<tr>
									<td colspan="4">
										&nbsp; &nbsp;&nbsp;<font style="font-weight: bold;">e.</font>Amount of excluded payments on offshore obligations 
									</td>
									<td colspan="1">
										<input type="text" class="input-sm form-control" id="F1042_EXCLUDED_OFF_OBLIG" name="F1042_EXCLUDED_OFF_OBLIG"
										value="<%=formData.get("F1042_EXCLUDED_OFF_OBLIG") != null ? formData.get("F1042_EXCLUDED_OFF_OBLIG") : ""%>"/>
									</td>
								</tr>
								<tr>
									<td colspan="4">
										&nbsp; &nbsp;&nbsp;<font style="font-weight: bold;">f.</font>Amount of excluded payments on collateral 
									</td>
									<td colspan="1">
										<input type="text" class="input-sm form-control" id="F1042_EXCLUDED_COLLATERAL" name="F1042_EXCLUDED_COLLATERAL"
										value="<%=formData.get("F1042_EXCLUDED_COLLATERAL") != null ? formData.get("F1042_EXCLUDED_COLLATERAL") : ""%>"/>
									</td>
								</tr>
								<tr>
									<td colspan="4">
										&nbsp; &nbsp;&nbsp;<font style="font-weight: bold;">g.</font>Total U.S. source FDAP income required to be reported under chapter 4 but not required to be withheld upon under chapter 4 
									</td>
									<td colspan="1">
										<input type="text" class="input-sm form-control" id="F1042_US_INCOME_NOWH" name="F1042_US_INCOME_NOWH"
										value="<%=formData.get("F1042_US_INCOME_NOWH") != null ? formData.get("F1042_US_INCOME_NOWH") : ""%>"/>
									</td>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td colspan="4">
							<font style="font-weight: bold;">3.</font>Total U.S. source FDAP income reportable under chapter 4
						</td>
						<td colspan="1">
							<input type="text" style="margin-left:40px;" class="input-sm form-control" id="F1042_US_INCOME_REP_CHAP4" name="F1042_US_INCOME_REP_CHAP4"
							value="<%=formData.get("F1042_US_INCOME_REP_CHAP4") != null ? formData.get("F1042_US_INCOME_REP_CHAP4") : ""%>"/>
						</td>
					</tr>
					<tr>
						<td colspan="4">
							<font style="font-weight: bold;">4.</font>Total U.S. source FDAP income reported on all Forms 1042-S
						</td>
						<td colspan="1">
							<input type="text" style="margin-left:40px;" class="input-sm form-control" id="F1042_US_INCOME_REP_ALL" name="F1042_US_INCOME_REP_ALL"
							value="<%=formData.get("F1042_US_INCOME_REP_ALL") != null ? formData.get("F1042_US_INCOME_REP_ALL") : ""%>"/>
						</td>
					</tr>
					<tr>
						<td colspan="4">
							<font style="font-weight: bold;">5.</font>Total variance, subtract line 3 from line 4, if amount other than zero, provide explanation on line 6
						</td>
						<td colspan="1">
							<input type="text" style="margin-left:40px;" class="input-sm form-control" id="F1042_TOTALVARIANCE" name="F1042_TOTALVARIANCE"
							value="<%=formData.get("F1042_TOTALVARIANCE") != null ? formData.get("F1042_TOTALVARIANCE") : ""%>"/>
						</td>
					</tr>
					</table>
					<table>
						<tr>
						<td colspan="4">
							<font style="font-weight: bold;">6. &nbsp;</font>
						</td>
						<td colspan="1">
							<textarea rows="5" cols="85" class="input-sm form-control" id="F1042_FDAP_EXPLAIN" name="F1042_FDAP_EXPLAIN" >
							<%= formData.get("F1042_FDAP_EXPLAIN") != null ? formData.get("F1042_FDAP_EXPLAIN") : ""%>
							</textarea>
						</td>
						</tr>
					</table>
				</div>
			</div>		
		</div>
	</div>
	
	
	<!-- SECTION 3 -->
	<div class="section" style="padding: 0 7.5% 0 7.5%;">
		<div class="col-lg-12">
			<div class="card card-danger" style="margin-top: 20px; margin-bottom: 0;">
				<div class="sectionHeader">
					<div class="headerLeft">
						Section III
					</div>
					<div class="headerRight">
						&nbsp;&nbsp;&nbsp;
						<font style="font-weight: bold; font-size: 20px; text-align: center;" face="ITC Franklin Gothic Std Book" >Notional principal contract payments and other payments on derivative contracts that reference (in whole or in part) a U.S. security</font>
					</div>
				</div>
				<div class="section" style="padding: 0 7.5% 0 7.5%;">
					<table>
						<tr style="text-align: left;">
							<td colspan="2">	
								Check here if any payments (including gross proceeds) were made by the withholding agent under notional principal contracts or other derivatives contracts that reference (in whole or in part) a U.S. security
							</td>
							<td colspan="1">
								<input type="checkbox" id="F1042_NOTION_CONTRACTPAY" name="F1042_NOTION_CONTRACTPAY" value="1042_NOTION_C_PAY"
								<% if("1042_NOTION_C_PAY".equals(formData.get("F1042_NOTION_CONTRACTPAY"))){ %> checked="checked" <%} %>/>
							</td>
						</tr>
					</table>
				</div>
			</div>		
		</div>
	</div>
	
	<div class="section" style="padding: 15px 7.5% 0 7.5%; text-align: center;">
		<div class="col-lg-12">
			<div class="card card-danger" style="padding: 5px 0; margin-top: 20px;">
				<button class="btn btn-primary btn-sm" type="button" id="saveFATCA1042Form">Save</button>
				<!-- <button class="btn btn-success btn-sm" type="button" id="exportFATCAForm" >Export XML</button> -->
				<a type="button" class="btn btn-success btn-sm" href="FATCAReport/1042Forms/f1042s/f1042s.pdf" onclick="openPdf(event, 'FATCAReport/1042Forms/f1042s/f1042s.pdf', '');">Export XML</a>
				<button class="btn btn-info btn-sm" type="button" id="generateFATCAPackage" onclick="generateFATCAPackage()">Generate FATCA Package</button>
			</div>
		</div>
	</div>
	</form>
	</div>
</body>
</html>	