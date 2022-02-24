<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%> 
<%@ include file="../../../tags/tags.jsp"%>
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
	padding: 5px 5px;
	float: left;
	position: relative !important;
	width: 60px;
	color: white;
	background: black;
	font-weight: bold;
	border-top-left-radius: 4px;
}
.headerRight{
	padding: 5px 10px;
	position: relative !important;
	font-size: 15px;
	font-weight: bold;
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
		
		$("#saveFATCA1042SForm").click(function(){
			var formObj = $("#fatca1042SForm");
			var formData = $(formObj).serialize();
			var caseNo = $(formObj).find("input#caseNo").val();
			$.ajax({
				url : "${pageContext.request.contextPath}/common/saveFATCA1042SForm",
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
								Form <font style="font-weight: bold; font-size: 20px" face="Helvetica">1042-S</font>
							</td>
							<td width="65%">
								<font style="font-weight: bold; font-size: 20px" face="ITC Franklin Gothic Std Book">Foreign Person's U.S. Source Income Subject to Withholding  </font><font style="font-weight: bold; font-size: 20px" face="Helvetica">2017</font>
							</td>
							<td width="17%" style="border-left: 2px solid black;">
								OMB No. 1545-2246
							</td>
						</tr>
						<tr>
							<td style="border-right: 2px solid black; border-bottom: 2px solid black">
								Department of the Treasury Internal Revenue Service
							</td>
							<td style="border-bottom: 2px solid black">
								Information about Form 1042-S and its separate instructions is at <a href="javascript:void(0)" onclick="window.open('http://www.irs.gov/form1024s')">www.irs.gov/form1024s</a>.
							</td>
							<td style="border-left: 2px solid black; border-bottom: 2px solid black">
								<font style="font-weight: bold; font-size: 20px" face="Helvetica">Copy A </font>for Internal Revenue Service
							</td>
						</tr>
						<tr style="text-align: left;">
							<td colspan="3">
								<table width="100%">
									<tr>
										<td width="44%">
											<label for="REPORT_TYPE_FATCA2">
												Unique Form Identifier <input type="text" class="input-sm form-control" name="F1042S_UNQFORMID" id="F1042S_UNQFORMID" 
												value="<%=formData.get("F1042S_UNQFORMID") != null ? formData.get("F1042S_UNQFORMID") : "" %>"/>
											</label>
										</td>
										<td width="17%">
											<label for="REPORT_TYPE_FATCA4">
												Amended <input type="checkbox" id="F1042S_AMENDEDREPORT_A" name="F1042S_AMENDEDREPORT_A" value="1024S_AMENDED"
												<% if("1024S_AMENDED".equals(formData.get("F1042S_AMENDEDREPORT_A"))){ %> checked="checked" <%} %>/>
											</label>
										</td>
										<td width="49%">
											<label for="REPORT_TYPE_FATCA3">
												Amendment No. <input type="text" class="input-sm form-control" name="F1042S_AMENDMENTNO" id="F1042S_AMENDMENTNO" 
												value="<%=formData.get("F1042S_AMENDMENTNO") != null ? formData.get("F1042S_AMENDMENTNO") : "" %>"/>
											</label>
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
				</div>
			</div>
		</div>
	</div>
	<div class="section" style="padding: 0 7.5% 0 7.5%;">
		<div class="col-lg-12">
			<div class="card card-danger" style="margin-top: 20px; margin-bottom: 0;">
				<table class="table">
					<tr>
						<td width="15%">
							1. Income Code
						</td>
						<td width="30%">
							<input type="text" class="input-sm form-control" id="F1042S_INCOMECODE" name="F1042S_INCOMECODE"
							value="<%=formData.get("F1042S_INCOMECODE") != null ? formData.get("F1042S_INCOMECODE") : ""%>"/>
						</td>
						<td width="2%">&nbsp;</td>
						<td width="18%">
							2. Gross Income
						</td>
						<td width="30%">
							<input type="text" class="input-sm form-control" id="F1042S_GROSSINCOME" name="F1042S_GROSSINCOME"
							value="<%=formData.get("F1042S_GROSSINCOME") != null ? formData.get("F1042S_GROSSINCOME") : ""%>"/>
						</td>
						
					</tr>
					<tr>
						<td colspan="5">
							3. Chapter indicator (Enter"3"
							<input type="radio" class="input-sm form-control" id="F1042S_CHAPTER3INDICATOR_A" name="F1042S_CHAPTERINDICATOR_A" value="3"
							<%if("3".equals(formData.get("F1042S_CHAPTERINDICATOR_A"))){ %> checked="checked" <%} %>/>
							or "4"
							<input type="radio" class="input-sm form-control" id="F1042S_CHAPTER4INDICATOR_A" name="F1042S_CHAPTERINDICATOR_A" value="4"
							<%if("4".equals(formData.get("F1042S_CHAPTERINDICATOR_A"))){ %> checked="checked" <%} %>/>)
							<table style="width: 100%; id="chapterIndicator3">
								<tr>
									<td width="2%">&nbsp;</td>
									<td width="15%">
										3a. Exemption code 
									</td>
									<td width="30%">
										<input type="text" class="input-sm form-control" id="F1042S_CHAP3_EXEMCODE" name="F1042S_CHAP3_EXEMCODE"
										value="<%=formData.get("F1042S_CHAP3_EXEMCODE") != null ? formData.get("F1042S_CHAP3_EXEMCODE") : ""%>"/>
									</td>
									<td width="2%">&nbsp;</td>
									<td width="18%">
										3b. Tax rate
									</td>
									<td width="30%">
										<input type="text" class="input-sm form-control" id="F1042S_CHAP3_TAXRATE" name="F1042S_CHAP3_TAXRATE"
										value="<%=formData.get("F1042S_CHAP3_TAXRATE") != null ? formData.get("F1042S_CHAP3_TAXRATE") : ""%>"/>
									</td>
								</tr>
							</table>
							<table>
								<tr>
									<td colspan="6">&nbsp;</td>
								</tr>
							</table>
							<table style="width: 100%; id="chapterIndicator4">
								<tr>
									<td width="2%">&nbsp;</td>
									<td width="15%">
										4a. Exemption code 
									</td>
									<td width="30%">
										<input type="text" class="input-sm form-control" id="F1042S_CHAP4_EXEMCODE" name="F1042S_CHAP4_EXEMCODE"
										value="<%=formData.get("F1042S_CHAP4_EXEMCODE") != null ? formData.get("F1042S_CHAP4_EXEMCODE") : ""%>"/>
									</td>
									<td width="2%">&nbsp;</td>
									<td width="18%">
										4b. Tax rate
									</td>
									<td width="30%">
										<input type="text" class="input-sm form-control" id="F1042S_CHAP4_TAXRATE" name="F1042S_CHAP4_TAXRATE"
										value="<%=formData.get("F1042S_CHAP4_TAXRATE") != null ? formData.get("F1042S_CHAP4_TAXRATE") : ""%>"/>
									</td>
								</tr>
							</table>
						</td>					
					</tr>
					<tr>
						<td width="15%">
							5. Withholding allowance
						</td>
						<td width="30%">
							<input type="text" class="input-sm form-control" id="F1042S_WITHHOLD_ALLOWANCE" name="F1042S_WITHHOLD_ALLOWANCE"
							value="<%=formData.get("F1042S_WITHHOLD_ALLOWANCE") != null ? formData.get("F1042S_WITHHOLD_ALLOWANCE") : ""%>"/>
						</td>
						<td width="2%">&nbsp;</td>
						<td width="18%">
							6. Net income
						</td>
						<td width="30%">
							<input type="text" class="input-sm form-control" id="F1042S_NETINCOME" name="F1042S_NETINCOME"
							value="<%=formData.get("F1042S_NETINCOME") != null ? formData.get("F1042S_NETINCOME") : ""%>"/>
						</td>
					</tr>
					<tr>
						<td width="15%">
							7a. Federal tax withheld
						</td>
						<td width="30%">
							<input type="text" class="input-sm form-control" id="F1042S_FEDERALTAX_WITHHELD" name="F1042S_FEDERALTAX_WITHHELD"
							value="<%=formData.get("F1042S_FEDERALTAX_WITHHELD") != null ? formData.get("F1042S_FEDERALTAX_WITHHELD") : ""%>"/>
						</td>
						<td width="2%">&nbsp;</td>
						<td colspan="2">
							7b.  Check if tax not deposited with IRS pursuant to escrow procedure&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="checkbox" class="input-sm form-control" id="F1042S_NOTAX_DEPOSIT" name="F1042S_NOTAX_DEPOSIT_A" value="NOTAX_DEPOSITED" 
							 <% if("NOTAX_DEPOSITED".equals(formData.get("F1042S_NOTAX_DEPOSIT"))){ %> checked="checked" <%} %>/>
						</td>
					</tr>
					<tr>
						<td width="15%">
							8. Tax withheld by other agents 
						</td>
						<td width="30%">
							<input type="text" class="input-sm form-control" id="F1042S_WITHHELD_OTHERAGENT" name="F1042S_WITHHELD_OTHERAGENT"
							value="<%=formData.get("F1042S_WITHHELD_OTHERAGENT") != null ? formData.get("F1042S_WITHHELD_OTHERAGENT") : ""%>"/>
						</td>
						<td width="2%">&nbsp;</td>
						<td width="18%">
							9. Tax paid by withholding agent 
						</td>
						<td width="30%">
							<input type="text" class="input-sm form-control" id="F1042S_WITHHOLDAGENT_TAX" name="F1042S_WITHHOLDAGENT_TAX"
							value="<%=formData.get("F1042S_WITHHOLDAGENT_TAX") != null ? formData.get("F1042S_WITHHOLDAGENT_TAX") : ""%>"/>
						</td>
					</tr>
					<tr>
						<td width="15%">
							10. Total withholding credit
						</td>
						<td width="30%">
							<input type="text" class="input-sm form-control" id="F1042S_TOTALWITHHOLD_CREDIT" name="F1042S_TOTALWITHHOLD_CREDIT"
							value="<%=formData.get("F1042S_TOTALWITHHOLD_CREDIT") != null ? formData.get("F1042S_TOTALWITHHOLD_CREDIT") : ""%>"/>
						</td>
						<td width="2%">&nbsp;</td>
						<td width="18%">
							11. Amount repaid to recipient
						</td>
						<td width="30%">
							<input type="text" class="input-sm form-control" id="F1042S_RECIPIENT_REPAIDAMT" name="F1042S_RECIPIENT_REPAIDAMT"
							value="<%=formData.get("F1042S_RECIPIENT_REPAIDAMT") != null ? formData.get("F1042S_RECIPIENT_REPAIDAMT") : ""%>"/>
						</td>
					</tr>
					<tr>
						<td width="15%">
							12a. Withholding agent's EIN
						</td>
						<td width="30%">
							<input type="text" class="input-sm form-control" id="F1042S_WITHHOLDAGENT_EIN" name="F1042S_WITHHOLDAGENT_EIN"
							value="<%=formData.get("F1042S_WITHHOLDAGENT_EIN") != null ? formData.get("F1042S_WITHHOLDAGENT_EIN") : ""%>"/>
						</td>
						<td width="2%">&nbsp;</td>
						<td width="18%">
							12b. Ch.3 status code
						</td>
						<td width="30%">
							<input type="text" class="input-sm form-control" id="F1042S_CH3STATUSCODE_WITHHOLD" name="F1042S_CH3STATUSCODE_WITHHOLD"
							value="<%=formData.get("F1042S_CH3STATUSCODE_WITHHOLD") != null ? formData.get("F1042S_CH3STATUSCODE_WITHHOLD") : ""%>"/>
						</td>
					</tr>
					<tr>
						<td width="15%">
							12c. Ch.4 status code
						</td>
						<td width="30%">
							<input type="text" class="input-sm form-control" id="F1042S_CH4STATUSCODE_WITHHOLD" name="F1042S_CH4STATUSCODE_WITHHOLD"
							value="<%=formData.get("F1042S_CH4STATUSCODE_WITHHOLD") != null ? formData.get("F1042S_CH4STATUSCODE_WITHHOLD") : ""%>"/>
						</td>
						<td width="2%">&nbsp;</td>
						<td width="18%">
							12d. Withholding agent's name 
						</td>
						<td width="30%">
							<input type="text" class="input-sm form-control" id="F1042S_WITHHOLDAGENT_NAME" name="F1042S_WITHHOLDAGENT_NAME"
							value="<%=formData.get("F1042S_WITHHOLDAGENT_NAME") != null ? formData.get("F1042S_WITHHOLDAGENT_NAME") : ""%>"/>
						</td>
					</tr>
					<tr>
						<td colspan="3">
							12e.  Withholding agent's Global Intermediary Identification Number (GIIN)
						</td>
						<td colspan="2" >
							<input type="text" class="input-sm form-control" id="F1042S_WITHHOLDAGENT_GIIN" name="F1042S_WITHHOLDAGENT_GIIN"
							value="<%=formData.get("F1042S_WITHHOLDAGENT_GIIN") != null ? formData.get("F1042S_WITHHOLDAGENT_GIIN") : ""%>"/>
						</td>
					</tr>
					<tr>
						<td width="15%">
							12f. Country code
						</td>
						<td width="30%">
							<input type="text" class="input-sm form-control" id="F1042S_WITHHOLD_COUNTRYCODE" name="F1042S_WITHHOLD_COUNTRYCODE"
							value="<%=formData.get("F1042S_WITHHOLD_COUNTRYCODE") != null ? formData.get("F1042S_WITHHOLD_COUNTRYCODE") : ""%>"/>
						</td>
						<td width="2%">&nbsp;</td>
						<td width="18%">
							12g. Foreign taxpayer identification number, if any
						</td>
						<td width="30%">
							<input type="text" class="input-sm form-control" id="F1042S_FOREIGN_TIN" name="F1042S_FOREIGN_TIN"
							value="<%=formData.get("F1042S_FOREIGN_TIN") != null ? formData.get("F1042S_FOREIGN_TIN") : ""%>"/>
						</td>
					</tr>
					<tr>
						<td width="15%">
							12h. Address (number and street)
						</td>
						<td width="30%">
							<input type="text" class="input-sm form-control" id="F1042S_WITHHOLDAGENT_ADDR1" name="F1042S_WITHHOLDAGENT_ADDR1"
							value="<%=formData.get("F1042S_WITHHOLDAGENT_ADDR1") != null ? formData.get("F1042S_WITHHOLDAGENT_ADDR1") : ""%>"/>
						</td>
						<td width="2%">&nbsp;</td>
						<td width="18%">
							12i. City or town, state or province, country, ZIP or foreign postal code
						</td>
						<td width="30%">
							<input type="text" class="input-sm form-control" id="F1042S_WITHHOLDAGENT_ADDR2" name="F1042S_WITHHOLDAGENT_ADDR2"
							value="<%=formData.get("F1042S_WITHHOLDAGENT_ADDR2") != null ? formData.get("F1042S_WITHHOLDAGENT_ADDR2") : ""%>"/>
						</td>
					</tr>
					<tr>
						<td width="15%">
							13a. Recipient's name
						</td>
						<td width="30%">
							<input type="text" class="input-sm form-control" id="F1042S_RECIPIENT_NAME" name="F1042S_RECIPIENT_NAME"
							value="<%=formData.get("F1042S_RECIPIENT_NAME") != null ? formData.get("F1042S_RECIPIENT_NAME") : ""%>"/>
						</td>
						<td width="2%">&nbsp;</td>
						<td width="18%">
							13b. Recipient's country code
						</td>
						<td width="30%">
							<input type="text" class="input-sm form-control" id="F1042S_RECIPIENT_COUNTRYCODE" name="F1042S_RECIPIENT_COUNTRYCODE"
							value="<%=formData.get("F1042S_RECIPIENT_COUNTRYCODE") != null ? formData.get("F1042S_RECIPIENT_COUNTRYCODE") : ""%>"/>
						</td>
					</tr>
					<tr>
						<td width="15%">
							13c. Address (number and street)
						</td>
						<td width="30%">
							<input type="text" class="input-sm form-control" id="F1042S_RECIPIENT_ADDR1" name="F1042S_RECIPIENT_ADDR1"
							value="<%=formData.get("F1042S_RECIPIENT_ADDR1") != null ? formData.get("F1042S_RECIPIENT_ADDR1") : ""%>"/>
						</td>
						<td width="2%">&nbsp;</td>
						<td width="18%">
							13d. City or town, state or province, country, ZIP or foreign postal code
						</td>
						<td width="30%">
							<input type="text" class="input-sm form-control" id="F1042S_RECIPIENT_ADDR2" name="F1042S_RECIPIENT_ADDR2"
							value="<%=formData.get("F1042S_RECIPIENT_ADDR2") != null ? formData.get("F1042S_RECIPIENT_ADDR2") : ""%>"/>
						</td>
					</tr>
					<tr>
						<td width="15%">
							13e. Recipient's U.S. TIN, if any
						</td>
						<td width="30%">
							<input type="text" class="input-sm form-control" id="F1042S_RECIPIENT_USTIN" name="F1042S_RECIPIENT_USTIN"
							value="<%=formData.get("F1042S_RECIPIENT_USTIN") != null ? formData.get("F1042S_RECIPIENT_USTIN") : ""%>"/>
						</td>
						<td width="2%">&nbsp;</td>
						<td width="18%">
							13f. Ch.3 status code
						</td>
						<td width="30%">
							<input type="text" class="input-sm form-control" id="F1042S_CH3STATUSCODE_RCIPIENT" name="F1042S_CH3STATUSCODE_RCIPIENT"
							value="<%=formData.get("F1042S_CH3STATUSCODE_RCIPIENT") != null ? formData.get("F1042S_CH3STATUSCODE_RCIPIENT") : ""%>"/>
						</td>
					</tr>
					<tr>
						<td width="15%">
							13g. Ch.4 status code 
						</td>
						<td width="30%">
							<input type="text" class="input-sm form-control" id="F1042S_CH4STATUSCODE_RCIPIENT" name="F1042S_CH4STATUSCODE_RCIPIENT"
							value="<%=formData.get("F1042S_CH4STATUSCODE_RCIPIENT") != null ? formData.get("F1042S_CH4STATUSCODE_RCIPIENT") : ""%>"/>
						</td>
						<td width="2%">&nbsp;</td>
						<td width="18%">
							13h. Recipient's GIIN
						</td>
						<td width="30%">
							<input type="text" class="input-sm form-control" id="F1042S_RECIPIENT_GIIN" name="F1042S_RECIPIENT_GIIN"
							value="<%=formData.get("F1042S_RECIPIENT_GIIN") != null ? formData.get("F1042S_RECIPIENT_GIIN") : ""%>"/>
						</td>
					</tr>
					<tr>
						<td width="15%">
							13i. Recipient's foreign tax identification number, if any
						</td>
						<td width="30%">
							<input type="text" class="input-sm form-control" id="F1042S_RECIPIENT_FTIN" name="F1042S_RECIPIENT_FTIN"
							value="<%=formData.get("F1042S_RECIPIENT_FTIN") != null ? formData.get("F1042S_RECIPIENT_FTIN") : ""%>"/>
						</td>
						<td width="2%">&nbsp;</td>
						<td width="18%">
							13j. LOB code 
						</td>
						<td width="30%">
							<input type="text" class="input-sm form-control" id="F1042S_RECIPIENT_LOBCODE" name="F1042S_RECIPIENT_LOBCODE"
							value="<%=formData.get("F1042S_RECIPIENT_LOBCODE") != null ? formData.get("F1042S_RECIPIENT_LOBCODE") : ""%>"/>
						</td>
					</tr>
					<tr>
						<td width="15%">
							13k. Recipient's account number
						</td>
						<td width="30%">
							<input type="text" class="input-sm form-control" id="F1042S_RECIPIENT_ACCNO" name="F1042S_RECIPIENT_ACCNO"
							value="<%=formData.get("F1042S_RECIPIENT_ACCNO") != null ? formData.get("F1042S_RECIPIENT_ACCNO") : ""%>"/>
						</td>
						<td width="2%">&nbsp;</td>
						<td width="18%">
							13l. Recipient's date of birth 
						</td>
						<td width="30%">
							<input type="text" class="input-sm form-control" id="F1042S_RECIPIENT_DOB" name="F1042S_RECIPIENT_DOB"
							value="<%=formData.get("F1042S_RECIPIENT_DOB") != null ? formData.get("F1042S_RECIPIENT_DOB") : ""%>"/>
						</td>
					</tr>
					<tr>
						<td width="15%">
							14a. Primary Withholding Agent's Name (if applicable)
						</td>
						<td width="30%">
							<input type="text" class="input-sm form-control" id="F1042S_PRIWHAGENT_NAME" name="F1042S_PRIWHAGENT_NAME"
							value="<%=formData.get("F1042S_PRIWHAGENT_NAME") != null ? formData.get("F1042S_PRIWHAGENT_NAME") : ""%>"/>
						</td>
						<td width="2%">&nbsp;</td>
						<td width="18%">
							14b. Primary Withholding Agent's EIN
						</td>
						<td width="30%">
							<input type="text" class="input-sm form-control" id="F1042S_PRIWHAGENT_EIN" name="F1042S_PRIWHAGENT_EIN"
							value="<%=formData.get("F1042S_PRIWHAGENT_EIN") != null ? formData.get("F1042S_PRIWHAGENT_EIN") : ""%>"/>
						</td>
					</tr>
					<tr>
						<td colspan="2">
							15. Check if pro-rata basis reporting&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="checkbox" class="input-sm form-control" id="F1042S_PRORATA" name="F1042S_PRORATA_A" value="PRORATA" 
							 <% if("PRORATA".equals(formData.get("F1042S_PRORATA"))){ %> checked="checked" <%} %>/>
						</td>
						<td width="2%">&nbsp;</td>
						<td width="18%">
							15a. Intermediary or flow-through entity's EIN, if any
						</td>
						<td width="30%">
							<input type="text" class="input-sm form-control" id="F1042S_INTERMED_EIN" name="F1042S_INTERMED_EIN"
							value="<%=formData.get("F1042S_INTERMED_EIN") != null ? formData.get("F1042S_INTERMED_EIN") : ""%>"/>
						</td>
					</tr>
					<tr>
						<td width="15%">
							15b. Ch.3 status code
						</td>
						<td width="30%">
							<input type="text" class="input-sm form-control" id="F1042S_CH3STATUSCODE_INTERMED" name="F1042S_CH3STATUSCODE_INTERMED"
							value="<%=formData.get("F1042S_CH3STATUSCODE_INTERMED") != null ? formData.get("F1042S_CH3STATUSCODE_INTERMED") : ""%>"/>
						</td>
						<td width="2%">&nbsp;</td>
						<td width="18%">
							15c. Ch.4 status code 
						</td>
						<td width="30%">
							<input type="text" class="input-sm form-control" id="F1042S_CH4STATUSCODE_INTERMED" name="F1042S_CH4STATUSCODE_INTERMED"
							value="<%=formData.get("F1042S_CH4STATUSCODE_INTERMED") != null ? formData.get("F1042S_CH4STATUSCODE_INTERMED") : ""%>"/>
						</td>
					</tr>
					<tr>
						<td width="15%">
							15d. Intermediary or flow-through entity's name 
						</td>
						<td width="30%">
							<input type="text" class="input-sm form-control" id="F1042S_INTERMED_ENTITYNAME" name="F1042S_INTERMED_ENTITYNAME"
							value="<%=formData.get("F1042S_INTERMED_ENTITYNAME") != null ? formData.get("F1042S_INTERMED_ENTITYNAME") : ""%>"/>
						</td>
						<td width="2%">&nbsp;</td>
						<td width="18%">
							15e. Intermediary or flow-through entity's GIIN 
						</td>
						<td width="30%">
							<input type="text" class="input-sm form-control" id="F1042S_INTERMED_GIIN" name="F1042S_INTERMED_GIIN"
							value="<%=formData.get("F1042S_INTERMED_GIIN") != null ? formData.get("F1042S_INTERMED_GIIN") : ""%>"/>
						</td>
					</tr>
					<tr>
						<td width="15%">
							15f. Country code
						</td>
						<td width="30%">
							<input type="text" class="input-sm form-control" id="F1042S_INTERMED_COUNTRYCODE" name="F1042S_INTERMED_COUNTRYCODE"
							value="<%=formData.get("F1042S_INTERMED_COUNTRYCODE") != null ? formData.get("F1042S_INTERMED_COUNTRYCODE") : ""%>"/>
						</td>
						<td width="2%">&nbsp;</td>
						<td width="18%">
							15g. Foreign tax identification number, if any 
						</td>
						<td width="30%">
							<input type="text" class="input-sm form-control" id="F1042S_INTERMED_FTIN" name="F1042S_INTERMED_FTIN"
							value="<%=formData.get("F1042S_INTERMED_FTIN") != null ? formData.get("F1042S_INTERMED_FTIN") : ""%>"/>
						</td>
					</tr>
					<tr>
						<td width="15%">
							15h. Address (number and street)
						</td>
						<td width="30%">
							<input type="text" class="input-sm form-control" id="F1042S_INTERMED_ADDR1" name="F1042S_INTERMED_ADDR1"
							value="<%=formData.get("F1042S_INTERMED_ADDR1") != null ? formData.get("F1042S_INTERMED_ADDR1") : ""%>"/>
						</td>
						<td width="2%">&nbsp;</td>
						<td width="18%">
							15i. City or town, state or province, country, ZIP or foreign postal code
						</td>
						<td width="30%">
							<input type="text" class="input-sm form-control" id="F1042S_INTERMED_ADDR2" name="F1042S_INTERMED_ADDR2"
							value="<%=formData.get("F1042S_INTERMED_ADDR2") != null ? formData.get("F1042S_INTERMED_ADDR2") : ""%>"/>
						</td>
					</tr>
					<tr>
						<td width="15%">
							16a. Payer's name
						</td>
						<td width="30%">
							<input type="text" class="input-sm form-control" id="F1042S_PAYER_NAME" name="F1042S_PAYER_NAME"
							value="<%=formData.get("F1042S_PAYER_NAME") != null ? formData.get("F1042S_PAYER_NAME") : ""%>"/>
						</td>
						<td width="2%">&nbsp;</td>
						<td width="18%">
							16b. Payer's TIN
						</td>
						<td width="30%">
							<input type="text" class="input-sm form-control" id="F1042S_PAYER_TIN" name="F1042S_PAYER_TIN"
							value="<%=formData.get("F1042S_PAYER_TIN") != null ? formData.get("F1042S_PAYER_TIN") : ""%>"/>
						</td>
					</tr>
					<tr>
						<td width="15%">
							16c. Payer's GIIN
						</td>
						<td width="30%">
							<input type="text" class="input-sm form-control" id="F1042S_PAYER_GIIN" name="F1042S_PAYER_GIIN"
							value="<%=formData.get("F1042S_PAYER_GIIN") != null ? formData.get("F1042S_PAYER_GIIN") : ""%>"/>
						</td>
						<td width="2%">&nbsp;</td>
						<td width="18%">
							16d. Ch.3 status code
						</td>
						<td width="30%">
							<input type="text" class="input-sm form-control" id="F1042S_CH3STATUSCODE_PAYER" name="F1042S_CH3STATUSCODE_PAYER"
							value="<%=formData.get("F1042S_CH3STATUSCODE_PAYER") != null ? formData.get("F1042S_CH3STATUSCODE_PAYER") : ""%>"/>
						</td>
					</tr>
					<tr>
						<td width="15%">
							16e. Ch. 4 status code
						</td>
						<td width="30%">
							<input type="text" class="input-sm form-control" id="F1042S_CH4STATUSCODE_PAYER" name="F1042S_CH4STATUSCODE_PAYER"
							value="<%=formData.get("F1042S_CH4STATUSCODE_PAYER") != null ? formData.get("F1042S_CH4STATUSCODE_PAYER") : ""%>"/>
						</td>
						<td width="2%">&nbsp;</td>
						<td width="18%">
							17a. State income tax withheld
						</td>
						<td width="30%">
							<input type="text" class="input-sm form-control" id="F1042S_STATEINCTAX_WITHHELD" name="F1042S_STATEINCTAX_WITHHELD"
							value="<%=formData.get("F1042S_STATEINCTAX_WITHHELD") != null ? formData.get("F1042S_STATEINCTAX_WITHHELD") : ""%>"/>
						</td>
					</tr>
					<tr>
						<td width="15%">
							17b. Payer's state tax no.
						</td>
						<td width="30%">
							<input type="text" class="input-sm form-control" id="F1042S_PAYER_STATETAXNO" name="F1042S_PAYER_STATETAXNO"
							value="<%=formData.get("F1042S_PAYER_STATETAXNO") != null ? formData.get("F1042S_PAYER_STATETAXNO") : ""%>"/>
						</td>
						<td width="2%">&nbsp;</td>
						<td width="18%">
							17c. Name of state
						</td>
						<td width="30%">
							<input type="text" class="input-sm form-control" id="F1042S_PAYER_STATENAME" name="F1042S_PAYER_STATENAME"
							value="<%=formData.get("F1042S_PAYER_STATENAME") != null ? formData.get("F1042S_PAYER_STATENAME") : ""%>"/>
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
	<!-- COPY B STARTING -->
	<div class="section" style="padding: 5px 7.5% 0 7.5%;">
		<div class="col-lg-12">
			<div class="card card-primary" style="margin-top: 20px;">
				<div class="card-body">
					<table class="table customHeaderTable" style="text-align: center;">
						<tr>
							<td width="18%" style="border-right: 2px solid black;">
								Form <font style="font-weight: bold; font-size: 20px" face="Helvetica">1042-S</font>
							</td>
							<td width="65%">
								<font style="font-weight: bold; font-size: 20px" face="ITC Franklin Gothic Std Book">Foreign Person's U.S. Source Income Subject to Withholding  </font><font style="font-weight: bold; font-size: 20px" face="Helvetica">2017</font>
							</td>
							<td width="17%" style="border-left: 2px solid black;">
								OMB No. 1545-2246
							</td>
						</tr>
						<tr>
							<td style="border-right: 2px solid black; border-bottom: 2px solid black">
								Department of the Treasury Internal Revenue Service
							</td>
							<td style="border-bottom: 2px solid black">
								Information about Form 1042-S and its separate instructions is at <a href="javascript:void(0)" onclick="window.open('http://www.irs.gov/form1024s')">www.irs.gov/form1024s</a>.
							</td>
							<td style="border-left: 2px solid black; border-bottom: 2px solid black">
								<font style="font-weight: bold; font-size: 20px" face="Helvetica">Copy B </font>for Recepient
							</td>
						</tr>
						<tr style="text-align: left;">
							<td colspan="3">
								<table width="100%">
									<tr>
										<td width="44%">
											<label for="REPORT_TYPE_FATCA2">
												Unique Form Identifier <input type="text" class="input-sm form-control" name="F1042S_UNQFORMID" id="F1042S_UNQFORMID" 
												value="<%=formData.get("F1042S_UNQFORMID") != null ? formData.get("F1042S_UNQFORMID") : "" %>"/>
											</label>
										</td>
										<td width="17%">
											<label for="REPORT_TYPE_FATCA4">
												Amended   <input type="checkbox" id="F1042S_AMENDEDREPORT_B" name="F1042S_AMENDEDREPORT_B" value="1024S_AMENDED"
												<% if("1024S_AMENDED".equals(formData.get("F1042S_AMENDEDREPORT_B"))){ %> checked="checked" <%} %>/>
											</label>
										</td>
										<td width="49%">
											<label for="REPORT_TYPE_FATCA3">
												Amendment No. <input type="text" class="input-sm form-control" name="F1042S_AMENDMENTNO" id="F1042S_AMENDMENTNO" 
												value="<%=formData.get("F1042S_AMENDMENTNO") != null ? formData.get("F1042S_AMENDMENTNO") : "" %>"/>
											</label>
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
				</div>
			</div>
		</div>
	</div>
	<div class="section" style="padding: 0 7.5% 0 7.5%;">
		<div class="col-lg-12">
			<div class="card card-danger" style="margin-bottom: 0; margin-top: 20px;">
				<table class="table">
					<tr>
						<td width="15%">
							1. Income Code
						</td>
						<td width="30%">
							<input type="text" class="input-sm form-control" id="F1042S_INCOMECODE" name="F1042S_INCOMECODE"
							value="<%=formData.get("F1042S_INCOMECODE") != null ? formData.get("F1042S_INCOMECODE") : ""%>"/>
						</td>
						<td width="2%">&nbsp;</td>
						<td width="18%">
							2. Gross Income
						</td>
						<td width="30%">
							<input type="text" class="input-sm form-control" id="F1042S_GROSSINCOME" name="F1042S_GROSSINCOME"
							value="<%=formData.get("F1042S_GROSSINCOME") != null ? formData.get("F1042S_GROSSINCOME") : ""%>"/>
						</td>
						
					</tr>
					<tr>
						<td colspan="5">
							3. Chapter indicator (Enter"3"
							<input type="radio" class="input-sm form-control" id="F1042S_CHAPTER3INDICATOR_B" name="F1042S_CHAPTERINDICATOR_B" value="3"
							<%if("3".equals(formData.get("F1042S_CHAPTER3INDICATOR_B"))){ %> checked="checked" <%} %>/>
							or "4"
							<input type="radio" class="input-sm form-control" id="F1042S_CHAPTER4INDICATOR_B" name="F1042S_CHAPTERINDICATOR_B" value="4"
							<%if("4".equals(formData.get("F1042S_CHAPTERINDICATOR_B"))){ %> checked="checked" <%} %>/>)
							<table style="width: 100%; id="chapterIndicator3">
								<tr>
									<td width="2%">&nbsp;</td>
									<td width="15%">
										3a. Exemption code 
									</td>
									<td width="30%">
										<input type="text" class="input-sm form-control" id="F1042S_CHAP3_EXEMCODE" name="F1042S_CHAP3_EXEMCODE"
										value="<%=formData.get("F1042S_CHAP3_EXEMCODE") != null ? formData.get("F1042S_CHAP3_EXEMCODE") : ""%>"/>
									</td>
									<td width="2%">&nbsp;</td>
									<td width="18%">
										3b. Tax rate
									</td>
									<td width="30%">
										<input type="text" class="input-sm form-control" id="F1042S_CHAP3_TAXRATE" name="F1042S_CHAP3_TAXRATE"
										value="<%=formData.get("F1042S_CHAP3_TAXRATE") != null ? formData.get("F1042S_CHAP3_TAXRATE") : ""%>"/>
									</td>
								</tr>
							</table>
							<table>
								<tr>
									<td colspan="6">&nbsp;</td>
								</tr>
							</table>
							<table style="width: 100%; id="chapterIndicator4">
								<tr>
									<td width="2%">&nbsp;</td>
									<td width="15%">
										4a. Exemption code 
									</td>
									<td width="30%">
										<input type="text" class="input-sm form-control" id="F1042S_CHAP4_EXEMCODE" name="F1042S_CHAP4_EXEMCODE"
										value="<%=formData.get("F1042S_CHAP4_EXEMCODE") != null ? formData.get("F1042S_CHAP4_EXEMCODE") : ""%>"/>
									</td>
									<td width="2%">&nbsp;</td>
									<td width="18%">
										4b. Tax rate
									</td>
									<td width="30%">
										<input type="text" class="input-sm form-control" id="F1042S_CHAP4_TAXRATE" name="F1042S_CHAP4_TAXRATE"
										value="<%=formData.get("F1042S_CHAP4_TAXRATE") != null ? formData.get("F1042S_CHAP4_TAXRATE") : ""%>"/>
									</td>
								</tr>
							</table>
						</td>					
					</tr>
					<tr>
						<td width="15%">
							5. Withholding allowance
						</td>
						<td width="30%">
							<input type="text" class="input-sm form-control" id="F1042S_WITHHOLD_ALLOWANCE" name="F1042S_WITHHOLD_ALLOWANCE"
							value="<%=formData.get("F1042S_WITHHOLD_ALLOWANCE") != null ? formData.get("F1042S_WITHHOLD_ALLOWANCE") : ""%>"/>
						</td>
						<td width="2%">&nbsp;</td>
						<td width="18%">
							6. Net income
						</td>
						<td width="30%">
							<input type="text" class="input-sm form-control" id="F1042S_NETINCOME" name="F1042S_NETINCOME"
							value="<%=formData.get("F1042S_NETINCOME") != null ? formData.get("F1042S_NETINCOME") : ""%>"/>
						</td>
					</tr>
					<tr>
						<td width="15%">
							7a. Federal tax withheld
						</td>
						<td width="30%">
							<input type="text" class="input-sm form-control" id="F1042S_FEDERALTAX_WITHHELD" name="F1042S_FEDERALTAX_WITHHELD"
							value="<%=formData.get("F1042S_FEDERALTAX_WITHHELD") != null ? formData.get("F1042S_FEDERALTAX_WITHHELD") : ""%>"/>
						</td>
						<td width="2%">&nbsp;</td>
						<td colspan="2">
							7b.  Check if tax not deposited with IRS pursuant to escrow procedure&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="checkbox" class="input-sm form-control" id="F1042S_NOTAX_DEPOSIT" name="F1042S_NOTAX_DEPOSIT_B" value="NOTAX_DEPOSITED" 
							 <% if("NOTAX_DEPOSITED".equals(formData.get("F1042S_NOTAX_DEPOSIT"))){ %> checked="checked" <%} %>/>
						</td>
					</tr>
					<tr>
						<td width="15%">
							8. Tax withheld by other agents 
						</td>
						<td width="30%">
							<input type="text" class="input-sm form-control" id="F1042S_WITHHELD_OTHERAGENT" name="F1042S_WITHHELD_OTHERAGENT"
							value="<%=formData.get("F1042S_WITHHELD_OTHERAGENT") != null ? formData.get("F1042S_WITHHELD_OTHERAGENT") : ""%>"/>
						</td>
						<td width="2%">&nbsp;</td>
						<td width="18%">
							9. Tax paid by withholding agent 
						</td>
						<td width="30%">
							<input type="text" class="input-sm form-control" id="F1042S_WITHHOLDAGENT_TAX" name="F1042S_WITHHOLDAGENT_TAX"
							value="<%=formData.get("F1042S_WITHHOLDAGENT_TAX") != null ? formData.get("F1042S_WITHHOLDAGENT_TAX") : ""%>"/>
						</td>
					</tr>
					<tr>
						<td width="15%">
							10. Total withholding credit
						</td>
						<td width="30%">
							<input type="text" class="input-sm form-control" id="F1042S_TOTALWITHHOLD_CREDIT" name="F1042S_TOTALWITHHOLD_CREDIT"
							value="<%=formData.get("F1042S_TOTALWITHHOLD_CREDIT") != null ? formData.get("F1042S_TOTALWITHHOLD_CREDIT") : ""%>"/>
						</td>
						<td width="2%">&nbsp;</td>
						<td width="18%">
							11. Amount repaid to recipient
						</td>
						<td width="30%">
							<input type="text" class="input-sm form-control" id="F1042S_RECIPIENT_REPAIDAMT" name="F1042S_RECIPIENT_REPAIDAMT"
							value="<%=formData.get("F1042S_RECIPIENT_REPAIDAMT") != null ? formData.get("F1042S_RECIPIENT_REPAIDAMT") : ""%>"/>
						</td>
					</tr>
					<tr>
						<td width="15%">
							12a. Withholding agent's EIN
						</td>
						<td width="30%">
							<input type="text" class="input-sm form-control" id="F1042S_WITHHOLDAGENT_EIN" name="F1042S_WITHHOLDAGENT_EIN"
							value="<%=formData.get("F1042S_WITHHOLDAGENT_EIN") != null ? formData.get("F1042S_WITHHOLDAGENT_EIN") : ""%>"/>
						</td>
						<td width="2%">&nbsp;</td>
						<td width="18%">
							12b. Ch.3 status code
						</td>
						<td width="30%">
							<input type="text" class="input-sm form-control" id="F1042S_CH3STATUSCODE_WITHHOLD" name="F1042S_CH3STATUSCODE_WITHHOLD"
							value="<%=formData.get("F1042S_CH3STATUSCODE_WITHHOLD") != null ? formData.get("F1042S_CH3STATUSCODE_WITHHOLD") : ""%>"/>
						</td>
					</tr>
					<tr>
						<td width="15%">
							12c. Ch.4 status code
						</td>
						<td width="30%">
							<input type="text" class="input-sm form-control" id="F1042S_CH4STATUSCODE_WITHHOLD" name="F1042S_CH4STATUSCODE_WITHHOLD"
							value="<%=formData.get("F1042S_CH4STATUSCODE_WITHHOLD") != null ? formData.get("F1042S_CH4STATUSCODE_WITHHOLD") : ""%>"/>
						</td>
						<td width="2%">&nbsp;</td>
						<td width="18%">
							12d. Withholding agent's name 
						</td>
						<td width="30%">
							<input type="text" class="input-sm form-control" id="F1042S_WITHHOLDAGENT_NAME" name="F1042S_WITHHOLDAGENT_NAME"
							value="<%=formData.get("F1042S_WITHHOLDAGENT_NAME") != null ? formData.get("F1042S_WITHHOLDAGENT_NAME") : ""%>"/>
						</td>
					</tr>
					<tr>
						<td colspan="3">
							12e.  Withholding agent's Global Intermediary Identification Number (GIIN)
						</td>
						<td colspan="2" >
							<input type="text" class="input-sm form-control" id="F1042S_WITHHOLDAGENT_GIIN" name="F1042S_WITHHOLDAGENT_GIIN"
							value="<%=formData.get("F1042S_WITHHOLDAGENT_GIIN") != null ? formData.get("F1042S_WITHHOLDAGENT_GIIN") : ""%>"/>
						</td>
					</tr>
					<tr>
						<td width="15%">
							12f. Country code
						</td>
						<td width="30%">
							<input type="text" class="input-sm form-control" id="F1042S_WITHHOLD_COUNTRYCODE" name="F1042S_WITHHOLD_COUNTRYCODE"
							value="<%=formData.get("F1042S_WITHHOLD_COUNTRYCODE") != null ? formData.get("F1042S_WITHHOLD_COUNTRYCODE") : ""%>"/>
						</td>
						<td width="2%">&nbsp;</td>
						<td width="18%">
							12g. Foreign taxpayer identification number, if any
						</td>
						<td width="30%">
							<input type="text" class="input-sm form-control" id="F1042S_FOREIGN_TIN" name="F1042S_FOREIGN_TIN"
							value="<%=formData.get("F1042S_FOREIGN_TIN") != null ? formData.get("F1042S_FOREIGN_TIN") : ""%>"/>
						</td>
					</tr>
					<tr>
						<td width="15%">
							12h. Address (number and street)
						</td>
						<td width="30%">
							<input type="text" class="input-sm form-control" id="F1042S_WITHHOLDAGENT_ADDR1" name="F1042S_WITHHOLDAGENT_ADDR1"
							value="<%=formData.get("F1042S_WITHHOLDAGENT_ADDR1") != null ? formData.get("F1042S_WITHHOLDAGENT_ADDR1") : ""%>"/>
						</td>
						<td width="2%">&nbsp;</td>
						<td width="18%">
							12i. City or town, state or province, country, ZIP or foreign postal code
						</td>
						<td width="30%">
							<input type="text" class="input-sm form-control" id="F1042S_WITHHOLDAGENT_ADDR2" name="F1042S_WITHHOLDAGENT_ADDR2"
							value="<%=formData.get("F1042S_WITHHOLDAGENT_ADDR2") != null ? formData.get("F1042S_WITHHOLDAGENT_ADDR2") : ""%>"/>
						</td>
					</tr>
					<tr>
						<td width="15%">
							13a. Recipient's name
						</td>
						<td width="30%">
							<input type="text" class="input-sm form-control" id="F1042S_RECIPIENT_NAME" name="F1042S_RECIPIENT_NAME"
							value="<%=formData.get("F1042S_RECIPIENT_NAME") != null ? formData.get("F1042S_RECIPIENT_NAME") : ""%>"/>
						</td>
						<td width="2%">&nbsp;</td>
						<td width="18%">
							13b. Recipient's country code
						</td>
						<td width="30%">
							<input type="text" class="input-sm form-control" id="F1042S_RECIPIENT_COUNTRYCODE" name="F1042S_RECIPIENT_COUNTRYCODE"
							value="<%=formData.get("F1042S_RECIPIENT_COUNTRYCODE") != null ? formData.get("F1042S_RECIPIENT_COUNTRYCODE") : ""%>"/>
						</td>
					</tr>
					<tr>
						<td width="15%">
							13c. Address (number and street)
						</td>
						<td width="30%">
							<input type="text" class="input-sm form-control" id="F1042S_RECIPIENT_ADDR1" name="F1042S_RECIPIENT_ADDR1"
							value="<%=formData.get("F1042S_RECIPIENT_ADDR1") != null ? formData.get("F1042S_RECIPIENT_ADDR1") : ""%>"/>
						</td>
						<td width="2%">&nbsp;</td>
						<td width="18%">
							13d. City or town, state or province, country, ZIP or foreign postal code
						</td>
						<td width="30%">
							<input type="text" class="input-sm form-control" id="F1042S_RECIPIENT_ADDR2" name="F1042S_RECIPIENT_ADDR2"
							value="<%=formData.get("F1042S_RECIPIENT_ADDR2") != null ? formData.get("F1042S_RECIPIENT_ADDR2") : ""%>"/>
						</td>
					</tr>
					<tr>
						<td width="15%">
							13e. Recipient's U.S. TIN, if any
						</td>
						<td width="30%">
							<input type="text" class="input-sm form-control" id="F1042S_RECIPIENT_USTIN" name="F1042S_RECIPIENT_USTIN"
							value="<%=formData.get("F1042S_RECIPIENT_USTIN") != null ? formData.get("F1042S_RECIPIENT_USTIN") : ""%>"/>
						</td>
						<td width="2%">&nbsp;</td>
						<td width="18%">
							13f. Ch.3 status code
						</td>
						<td width="30%">
							<input type="text" class="input-sm form-control" id="F1042S_CH3STATUSCODE_RCIPIENT" name="F1042S_CH3STATUSCODE_RCIPIENT"
							value="<%=formData.get("F1042S_CH3STATUSCODE_RCIPIENT") != null ? formData.get("F1042S_CH3STATUSCODE_RCIPIENT") : ""%>"/>
						</td>
					</tr>
					<tr>
						<td width="15%">
							13g. Ch.4 status code 
						</td>
						<td width="30%">
							<input type="text" class="input-sm form-control" id="F1042S_CH4STATUSCODE_RCIPIENT" name="F1042S_CH4STATUSCODE_RCIPIENT"
							value="<%=formData.get("F1042S_CH4STATUSCODE_RCIPIENT") != null ? formData.get("F1042S_CH4STATUSCODE_RCIPIENT") : ""%>"/>
						</td>
						<td width="2%">&nbsp;</td>
						<td width="18%">
							13h. Recipient's GIIN
						</td>
						<td width="30%">
							<input type="text" class="input-sm form-control" id="F1042S_RECIPIENT_GIIN" name="F1042S_RECIPIENT_GIIN"
							value="<%=formData.get("F1042S_RECIPIENT_GIIN") != null ? formData.get("F1042S_RECIPIENT_GIIN") : ""%>"/>
						</td>
					</tr>
					<tr>
						<td width="15%">
							13i. Recipient's foreign tax identification number, if any
						</td>
						<td width="30%">
							<input type="text" class="input-sm form-control" id="F1042S_RECIPIENT_FTIN" name="F1042S_RECIPIENT_FTIN"
							value="<%=formData.get("F1042S_RECIPIENT_FTIN") != null ? formData.get("F1042S_RECIPIENT_FTIN") : ""%>"/>
						</td>
						<td width="2%">&nbsp;</td>
						<td width="18%">
							13j. LOB code 
						</td>
						<td width="30%">
							<input type="text" class="input-sm form-control" id="F1042S_RECIPIENT_LOBCODE" name="F1042S_RECIPIENT_LOBCODE"
							value="<%=formData.get("F1042S_RECIPIENT_LOBCODE") != null ? formData.get("F1042S_RECIPIENT_LOBCODE") : ""%>"/>
						</td>
					</tr>
					<tr>
						<td width="15%">
							13k. Recipient's account number
						</td>
						<td width="30%">
							<input type="text" class="input-sm form-control" id="F1042S_RECIPIENT_ACCNO" name="F1042S_RECIPIENT_ACCNO"
							value="<%=formData.get("F1042S_RECIPIENT_ACCNO") != null ? formData.get("F1042S_RECIPIENT_ACCNO") : ""%>"/>
						</td>
						<td width="2%">&nbsp;</td>
						<td width="18%">
							13l. Recipient's date of birth 
						</td>
						<td width="30%">
							<input type="text" class="input-sm form-control" id="F1042S_RECIPIENT_DOB" name="F1042S_RECIPIENT_DOB"
							value="<%=formData.get("F1042S_RECIPIENT_DOB") != null ? formData.get("F1042S_RECIPIENT_DOB") : ""%>"/>
						</td>
					</tr>
					<tr>
						<td width="15%">
							14a. Primary Withholding Agent's Name (if applicable)
						</td>
						<td width="30%">
							<input type="text" class="input-sm form-control" id="F1042S_PRIWHAGENT_NAME" name="F1042S_PRIWHAGENT_NAME"
							value="<%=formData.get("F1042S_PRIWHAGENT_NAME") != null ? formData.get("F1042S_PRIWHAGENT_NAME") : ""%>"/>
						</td>
						<td width="2%">&nbsp;</td>
						<td width="18%">
							14b. Primary Withholding Agent's EIN
						</td>
						<td width="30%">
							<input type="text" class="input-sm form-control" id="F1042S_PRIWHAGENT_EIN" name="F1042S_PRIWHAGENT_EIN"
							value="<%=formData.get("F1042S_PRIWHAGENT_EIN") != null ? formData.get("F1042S_PRIWHAGENT_EIN") : ""%>"/>
						</td>
					</tr>
					<tr>
						<td colspan="2">
							15. Check if pro-rata basis reporting&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="checkbox" class="input-sm form-control" id="F1042S_PRORATA" name="F1042S_PRORATA_B" value="PRORATA" 
							 <% if("PRORATA".equals(formData.get("F1042S_PRORATA"))){ %> checked="checked" <%} %>/>
						</td>
						<td width="2%">&nbsp;</td>
						<td width="18%">
							15a. Intermediary or flow-through entity's EIN, if any
						</td>
						<td width="30%">
							<input type="text" class="input-sm form-control" id="F1042S_INTERMED_EIN" name="F1042S_INTERMED_EIN"
							value="<%=formData.get("F1042S_INTERMED_EIN") != null ? formData.get("F1042S_INTERMED_EIN") : ""%>"/>
						</td>
					</tr>
					<tr>
						<td width="15%">
							15b. Ch.3 status code
						</td>
						<td width="30%">
							<input type="text" class="input-sm form-control" id="F1042S_CH3STATUSCODE_INTERMED" name="F1042S_CH3STATUSCODE_INTERMED"
							value="<%=formData.get("F1042S_CH3STATUSCODE_INTERMED") != null ? formData.get("F1042S_CH3STATUSCODE_INTERMED") : ""%>"/>
						</td>
						<td width="2%">&nbsp;</td>
						<td width="18%">
							15c. Ch.4 status code 
						</td>
						<td width="30%">
							<input type="text" class="input-sm form-control" id="F1042S_CH4STATUSCODE_INTERMED" name="F1042S_CH4STATUSCODE_INTERMED"
							value="<%=formData.get("F1042S_CH4STATUSCODE_INTERMED") != null ? formData.get("F1042S_CH4STATUSCODE_INTERMED") : ""%>"/>
						</td>
					</tr>
					<tr>
						<td width="15%">
							15d. Intermediary or flow-through entity's name 
						</td>
						<td width="30%">
							<input type="text" class="input-sm form-control" id="F1042S_INTERMED_ENTITYNAME" name="F1042S_INTERMED_ENTITYNAME"
							value="<%=formData.get("F1042S_INTERMED_ENTITYNAME") != null ? formData.get("F1042S_INTERMED_ENTITYNAME") : ""%>"/>
						</td>
						<td width="2%">&nbsp;</td>
						<td width="18%">
							15e. Intermediary or flow-through entity's GIIN 
						</td>
						<td width="30%">
							<input type="text" class="input-sm form-control" id="F1042S_INTERMED_GIIN" name="F1042S_INTERMED_GIIN"
							value="<%=formData.get("F1042S_INTERMED_GIIN") != null ? formData.get("F1042S_INTERMED_GIIN") : ""%>"/>
						</td>
					</tr>
					<tr>
						<td width="15%">
							15f. Country code
						</td>
						<td width="30%">
							<input type="text" class="input-sm form-control" id="F1042S_INTERMED_COUNTRYCODE" name="F1042S_INTERMED_COUNTRYCODE"
							value="<%=formData.get("F1042S_INTERMED_COUNTRYCODE") != null ? formData.get("F1042S_INTERMED_COUNTRYCODE") : ""%>"/>
						</td>
						<td width="2%">&nbsp;</td>
						<td width="18%">
							15g. Foreign tax identification number, if any 
						</td>
						<td width="30%">
							<input type="text" class="input-sm form-control" id="F1042S_INTERMED_FTIN" name="F1042S_INTERMED_FTIN"
							value="<%=formData.get("F1042S_INTERMED_FTIN") != null ? formData.get("F1042S_INTERMED_FTIN") : ""%>"/>
						</td>
					</tr>
					<tr>
						<td width="15%">
							15h. Address (number and street)
						</td>
						<td width="30%">
							<input type="text" class="input-sm form-control" id="F1042S_INTERMED_ADDR1" name="F1042S_INTERMED_ADDR1"
							value="<%=formData.get("F1042S_INTERMED_ADDR1") != null ? formData.get("F1042S_INTERMED_ADDR1") : ""%>"/>
						</td>
						<td width="2%">&nbsp;</td>
						<td width="18%">
							15i. City or town, state or province, country, ZIP or foreign postal code
						</td>
						<td width="30%">
							<input type="text" class="input-sm form-control" id="F1042S_INTERMED_ADDR2" name="F1042S_INTERMED_ADDR2"
							value="<%=formData.get("F1042S_INTERMED_ADDR2") != null ? formData.get("F1042S_INTERMED_ADDR2") : ""%>"/>
						</td>
					</tr>
					<tr>
						<td width="15%">
							16a. Payer's name
						</td>
						<td width="30%">
							<input type="text" class="input-sm form-control" id="F1042S_PAYER_NAME" name="F1042S_PAYER_NAME"
							value="<%=formData.get("F1042S_PAYER_NAME") != null ? formData.get("F1042S_PAYER_NAME") : ""%>"/>
						</td>
						<td width="2%">&nbsp;</td>
						<td width="18%">
							16b. Payer's TIN
						</td>
						<td width="30%">
							<input type="text" class="input-sm form-control" id="F1042S_PAYER_TIN" name="F1042S_PAYER_TIN"
							value="<%=formData.get("F1042S_PAYER_TIN") != null ? formData.get("F1042S_PAYER_TIN") : ""%>"/>
						</td>
					</tr>
					<tr>
						<td width="15%">
							16c. Payer's GIIN
						</td>
						<td width="30%">
							<input type="text" class="input-sm form-control" id="F1042S_PAYER_GIIN" name="F1042S_PAYER_GIIN"
							value="<%=formData.get("F1042S_PAYER_GIIN") != null ? formData.get("F1042S_PAYER_GIIN") : ""%>"/>
						</td>
						<td width="2%">&nbsp;</td>
						<td width="18%">
							16d. Ch.3 status code
						</td>
						<td width="30%">
							<input type="text" class="input-sm form-control" id="F1042S_CH3STATUSCODE_PAYER" name="F1042S_CH3STATUSCODE_PAYER"
							value="<%=formData.get("F1042S_CH3STATUSCODE_PAYER") != null ? formData.get("F1042S_CH3STATUSCODE_PAYER") : ""%>"/>
						</td>
					</tr>
					<tr>
						<td width="15%">
							16e. Ch. 4 status code
						</td>
						<td width="30%">
							<input type="text" class="input-sm form-control" id="F1042S_CH4STATUSCODE_PAYER" name="F1042S_CH4STATUSCODE_PAYER"
							value="<%=formData.get("F1042S_CH4STATUSCODE_PAYER") != null ? formData.get("F1042S_CH4STATUSCODE_PAYER") : ""%>"/>
						</td>
						<td width="2%">&nbsp;</td>
						<td width="18%">
							17a. State income tax withheld
						</td>
						<td width="30%">
							<input type="text" class="input-sm form-control" id="F1042S_STATEINCTAX_WITHHELD" name="F1042S_STATEINCTAX_WITHHELD"
							value="<%=formData.get("F1042S_STATEINCTAX_WITHHELD") != null ? formData.get("F1042S_STATEINCTAX_WITHHELD") : ""%>"/>
						</td>
					</tr>
					<tr>
						<td width="15%">
							17b. Payer's state tax no.
						</td>
						<td width="30%">
							<input type="text" class="input-sm form-control" id="F1042S_PAYER_STATETAXNO" name="F1042S_PAYER_STATETAXNO"
							value="<%=formData.get("F1042S_PAYER_STATETAXNO") != null ? formData.get("F1042S_PAYER_STATETAXNO") : ""%>"/>
						</td>
						<td width="2%">&nbsp;</td>
						<td width="18%">
							17c. Name of state
						</td>
						<td width="30%">
							<input type="text" class="input-sm form-control" id="F1042S_PAYER_STATENAME" name="F1042S_PAYER_STATENAME"
							value="<%=formData.get("F1042S_PAYER_STATENAME") != null ? formData.get("F1042S_PAYER_STATENAME") : ""%>"/>
						</td>
					</tr>
				</table>
			</div>
			<div>
				<table>
					<tr>
						<td width="65%">(keep for your records)</td>
						<td width="15%">&nbsp;</td>
						<td width="20%">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Form <font style="font-weight: bold;">1042-S</font> (2017)</td>
					</tr>
				</table>
			</div>			
		</div>
	</div>
	<div class="section" style="padding: 5px 7.5% 0 7.5%;">
		<div class="col-lg-12">
			<div class="card card-danger" style="margin-bottom: 0; margin-top: 20px;">
				<table>
					<tr>
						<td width="45%" style="padding-top: -100px !important ; padding-left: 10px; "><font style="font-weight: bold;">U.S. Income Tax Filing Requirements</font></br>Generally, every 
										nonresident alien individual, nonresident alien fiduciary, and foreign corporation with United States 
										income, including income that is effectively connected with the conduct of a trade or business in the
										United States, must file a United States income tax return. However, no return is required to be filed 
										by a nonresident alien individual, nonresident alien fiduciary, or foreign corporation if such person 
										was not engaged in a trade or business in the United States at any time during the tax year and if the 
										tax liability of such person was fully satisfied by the withholding of United States tax at the source.
										Corporations file Form 1120-F; all others file Form 1040NR (or Form 1040NR-EZ if eligible). You may get 
										the return forms and instructions at IRS.gov, at any United States Embassy or consulate, or by writing 
										to: Internal Revenue Service, 1201 N. Mitsubishi Motorway, Bloomington, IL 61705-6613. </br></br>
										&nbsp;&nbsp;&nbsp;&nbsp;En règle générale, tout étranger non-résident, tout organisme fidéicommissaire étranger
										non-résident et toute société étrangère percevant un revenu aux Etats-Unis, y compris tout revenu
										dérivé, en fait, du fonctionnement d’un commerce ou d’une affaire aux EtatsUnis, doit produire une 
										déclaration d’impôt sur le revenu auprès des services fiscaux des Etats-Unis. Cependant aucune 
										déclaration d’impôt sur le revenu n’est exigée d’un étranger non-résident, d’un organisme 
										fidéicommissaire étranger non-résident, ou d’une société étrangère s’ils n’ont pris part à aucun 
										commerce ou affaire aux EtatsUnis à aucun moment pendant l’année fiscale et si les impôts dont ils 
										sont redevables, ont été entièrement acquittés par une retenue à la source sur leur salaire. 
										Les sociétés doivent faire leur déclaration d’impôt en remplissant le formulaire 1120-F; tous les 
										autres redevables doivent remplir le formulaire 1040NR (ou 1040NR-EZ s'ils en remplissent les 
										conditions). On peut se procurer les formulaires de déclarations d’impôts et les instructions y 
										afférentes à IRS.gov et dans toutes les ambassades et tous les consulats des Etats-Unis. L’on peut 
										également s’adresser pour tout renseignement à: Internal Revenue Service, 1201 N. Mitsubishi Motorway, 
										Bloomington, IL 61705-6613.
						</td>
						<td width="10%">&nbsp;</td>
						<td width="45%"></br></br>Por regla general, todo extranjero no residente, todo organismo fideicomisario extranjero no residente 
										y toda sociedad anónima extranjera que reciba ingresos en los Estados Unidos, incluyendo ingresos 
										relacionados con la conducción de un negocio o comercio dentro de los Estados Unidos, deberá presentar 
										una declaración estadounidense de impuestos sobre el ingreso. Sin embargo, no se requiere declaración 
										alguna a un individuo extranjero, una sociedad anónima extranjera u organismo fideicomisario 
										extranjero no residente, si tal persona no ha efectuado comercio o negocio en los Estados Unidos 
										durante el año fiscal y si la responsabilidad con los impuestos de tal persona ha sido satisfecha 
										plenamente mediante retención del impuesto de los Estados Unidos en la fuente. Las sociedades anónimas 
										envían el Formulario 1120-F; todos los demás contribuyentes envían el Formulario 1040NR
										(o el Formulario  1040NR-EZ si les corresponde). Se podrá obtener formularios e instrucciones 
										en IRS.gov y en cualquier Embajada o Consulado de los Estados Unidos o escribiendo 
										directamente a: Internal Revenue Service, 1201 N. Mitsubishi Motorway, Bloomington, IL 61705-6613. </br></br>
										&nbsp;&nbsp;&nbsp;&nbsp;Im allgemeinen muss jede ausländische Einzelperson, jeder ausländische Bevollmächtigte und jede 
										ausländische Gesellschaft mit Einkommen in den Vereinigten Staaten, einschliesslich des Einkommens, 
										welches direkt mit der Ausübung von Handel oder Gewerbe innerhalb der Staaten verbunden ist, eine 
										Einkommensteuererklärung der Vereinigten Staaten abgeben. Eine Erklärung, muss jedoch nicht von 
										Ausländern, ausländischen Bevollmächtigten oder ausländischen Gesellschaften in den Vereinigten 
										Staaten eingereicht werden, falls eine solche Person während des Steuerjahres kein Gewerbe oder 
										Handel in den Vereinigten Staaten ausgeübt hat und die Steuerschuld durch Einbehaltung der Steuern 
										der Vereinigten Staaten durch die Einkommensquelle abgegolten ist. Gesellschaften reichen den Vordruck 
										1120-F ein; alle anderen reichen das Formblatt 1040NR (oder wenn passend das Formblatt 1040NR-EZ) ein.
										Einkommensteuererklärungen und Instruktionen können unter IRS.gov und bei den Botschaften und 
										Konsulaten der Vereiningten Staaten eingeholt werden. Um weitere Informationen wende man sich 
										bitte an: Internal Revenue Service, 1201 N. Mitsubishi Motorway,  Bloomington, IL 61705-6613.
						</td>
					</tr>
					<tr>
						<td colspan="3" style="padding: 0 10px 0 10px;"><hr style=" border: solid 1px; color: black;"></td>
					</tr>
					<tr>
						<td width="45%" style="padding-left: 10px; "><font style="font-weight: bold;">Explanation of Codes</br></br>Box 1. Income Code. </font></br>
							<table>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;Code</font></td>
									<td width="90%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;Types of Income (Interest)</font></td>
								</tr>
								<!--  <tr>
									<td colspan="10%"><font class="vertical-text">Interest</font></td>
								</tr>-->
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;01</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Interest paid by U.S. obligors—general</td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;02</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Interest paid on real property mortgages</td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;03</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Interest paid to controlling foreign corporations</td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;04</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Interest paid by foreign corporations</td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;05</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Interest on tax-free covenant bonds</td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;22</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Interest paid on deposit with a foreign branch of a &nbsp;&nbsp;&nbsp;&nbsp;domestic corporation or partnership</td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;29</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Deposit Interest</td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;30</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Original issue discount (OID)</td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;31</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Short-term OID</td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;33</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Substitute payment—interest </td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;51</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Interest paid on certain actively traded or publicly &nbsp;&nbsp;&nbsp;&nbsp;offered securities<sup>1</sup></td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;54</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Substitute payments—interest from certain &nbsp;&nbsp;&nbsp;&nbsp;actively traded or publicly offered securities<sup>1</sup></td>
								</tr>
								<tr>
									<td colspan="2" style="padding: 0 10px 0 10px;"><hr style=" border: solid 1px; color: black;"></td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;</font></td>
									<td width="90%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;(Dividend)</font></td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;06</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Dividends paid by U.S. corporations—general </td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;07</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Dividends qualifying for direct dividend rate </td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;08</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Dividends paid by foreign corporations </td>
								</tr>
							</table>
						</td>
						<td width="10%">&nbsp;</td>
						<td width="45%">
							<table>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;</font></td>
									<td width="90%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;(Dividend)</font></td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;34</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Substitute payment - dividends</td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;40</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Other dividend equivalents under IRC section &nbsp;&nbsp;&nbsp;&nbsp;871(m) (formerly 871(l))</td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;52</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Dividends paid on certain actively traded or publicly &nbsp;&nbsp;&nbsp;&nbsp;offered securities<sup>1</sup></td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;53</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Substitute payments-dividends from certain actively &nbsp;&nbsp;&nbsp;&nbsp;traded or publicly offered securities<sup>1</sup></td>
								</tr>
								<tr>
									<td colspan="2" style="padding: 0 10px 0 10px;"><hr style=" border: solid 1px; color: black;"></td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;</font></td>
									<td width="90%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;(Other)</font></td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;09</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Capital gains </td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;10</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Industrial royalties </td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;11</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Motion picture or television copyright royalties </td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;12</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Other royalties (for example, copyright, software, &nbsp;&nbsp;&nbsp;&nbsp;broadcasting, endorsement payments) </td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;13</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Royalties paid on certain publicly offered securities<sup>1</sup></td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;14</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Real property income and natural resources &nbsp;&nbsp;&nbsp;&nbsp;royalties </td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;15</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Pensions, annuities, alimony, and/or insurance &nbsp;&nbsp;&nbsp;&nbsp;premiums </td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;16</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Scholarship or fellowship grants </td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;17</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Compensation for independent personal services<sup>2</sup></td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;18</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Compensation for dependent personal services<sup>2</sup></td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;19</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Compensation for teaching<sup>2</sup></td>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td colspan="3" style="padding: 0 10px 0 10px;" >
							<font></br><i style="float:right;font-size: xx-small;">See back of Copy C for additional codes</i>
								<hr style=" border: solid 1px; color: black; margin-bottom: 0; ">	
								<font style="font-size: xx-small;">
									<sup>1</sup> This code should only be used if the income paid is described in Regulations section 1.1441-6(c)(2) and withholding agent has reduced the rate of withholding under an income tax treaty without the recipient providing a U.S. or foreign TIN.
									</br>
									<sup>2</sup> If compensation that otherwise would be covered under Income Codes 17 through 20 is directly attributable to the recipient's occupation as an artist or athlete, use Income Code 42 or 43 instead.
								</font>
							</font>
						</td>
					</tr>
					
				</table>
			</div>
		</div>
	</div>
	<!-- COPY B ENDING -->
	<!-- COPY C STARTING -->
	<div class="section" style="padding: 5px 7.5% 0 7.5%;">
		<div class="col-lg-12">
			<div class="card card-primary" style="margin-top: 20px;">
				<div class="card-body">
					<table class="table customHeaderTable" style="text-align: center;">
						<tr>
							<td width="18%" style="border-right: 2px solid black;">
								Form <font style="font-weight: bold; font-size: 20px" face="Helvetica">1042-S</font>
							</td>
							<td width="65%">
								<font style="font-weight: bold; font-size: 20px" face="ITC Franklin Gothic Std Book">Foreign Person's U.S. Source Income Subject to Withholding  </font><font style="font-weight: bold; font-size: 20px" face="Helvetica">2017</font>
							</td>
							<td width="17%" style="border-left: 2px solid black;">
								OMB No. 1545-2246
							</td>
						</tr>
						<tr>
							<td style="border-right: 2px solid black; border-bottom: 2px solid black">
								Department of the Treasury Internal Revenue Service
							</td>
							<td style="border-bottom: 2px solid black">
								Information about Form 1042-S and its separate instructions is at <a href="javascript:void(0)" onclick="window.open('http://www.irs.gov/form1024s')">www.irs.gov/form1024s</a>.
							</td>
							<td style="border-left: 2px solid black; border-bottom: 2px solid black">
								<font style="font-weight: bold; font-size: 20px" face="Helvetica">Copy C </font>for Recipient 
									</br><font style="font-size: 10px"">Attach to any Federal tax return you file</font>
							</td>
						</tr>
						<tr style="text-align: left;">
							<td colspan="3">
								<table width="100%">
									<tr>
										<td width="44%">
											<label for="REPORT_TYPE_FATCA2">
												Unique Form Identifier <input type="text" class="input-sm form-control" name="F1042S_UNQFORMID" id="F1042S_UNQFORMID" 
												value="<%=formData.get("F1042S_UNQFORMID") != null ? formData.get("F1042S_UNQFORMID") : "" %>"/>
											</label>
										</td>
										<td width="17%">
											<label for="REPORT_TYPE_FATCA4">
												Amended   <input type="checkbox" id="F1042S_AMENDEDREPORT_C" name="F1042S_AMENDEDREPORT_C" value="1024S_AMENDED"
												<% if("1024S_AMENDED".equals(formData.get("F1042S_AMENDEDREPORT_C"))){ %> checked="checked" <%} %>/>
											</label>
										</td>
										<td width="49%">
											<label for="REPORT_TYPE_FATCA3">
												Amendment No. <input type="text" class="input-sm form-control" name="F1042S_AMENDMENTNO" id="F1042S_AMENDMENTNO" 
												value="<%=formData.get("F1042S_AMENDMENTNO") != null ? formData.get("F1042S_AMENDMENTNO") : "" %>"/>
											</label>
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
				</div>
			</div>
		</div>
	</div>
	<div class="section" style="padding: 0 7.5% 0 7.5%;">
	<div class="col-lg-12">
		<div class="card card-danger" style="margin-bottom: 0; margin-top: 20px;">
			<table class="table">
				<tr>
					<td width="15%">
						1. Income Code
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_INCOMECODE" name="F1042S_INCOMECODE"
						value="<%=formData.get("F1042S_INCOMECODE") != null ? formData.get("F1042S_INCOMECODE") : ""%>"/>
					</td>
					<td width="2%">&nbsp;</td>
					<td width="18%">
						2. Gross Income
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_GROSSINCOME" name="F1042S_GROSSINCOME"
						value="<%=formData.get("F1042S_GROSSINCOME") != null ? formData.get("F1042S_GROSSINCOME") : ""%>"/>
					</td>
					
				</tr>
				<tr>
					<td colspan="5">
						3. Chapter indicator (Enter"3"
						<input type="radio" class="input-sm form-control" id="F1042S_CHAPTER3INDICATOR_C" name="F1042S_CHAPTERINDICATOR_C" value="3"
						<%if("3".equals(formData.get("F1042S_CHAPTERINDICATOR_C"))){ %> checked="checked" <%} %>/>
						or "4"
						<input type="radio" class="input-sm form-control" id="F1042S_CHAPTER4INDICATOR_C" name="F1042S_CHAPTERINDICATOR_C" value="4"
						<%if("4".equals(formData.get("F1042S_CHAPTERINDICATOR_C"))){ %> checked="checked" <%} %>/>)
						<table style="width: 100%; id="chapterIndicator3">
							<tr>
								<td width="2%">&nbsp;</td>
								<td width="15%">
									3a. Exemption code 
								</td>
								<td width="30%">
									<input type="text" class="input-sm form-control" id="F1042S_CHAP3_EXEMCODE" name="F1042S_CHAP3_EXEMCODE"
									value="<%=formData.get("F1042S_CHAP3_EXEMCODE") != null ? formData.get("F1042S_CHAP3_EXEMCODE") : ""%>"/>
								</td>
								<td width="2%">&nbsp;</td>
								<td width="18%">
									3b. Tax rate
								</td>
								<td width="30%">
									<input type="text" class="input-sm form-control" id="F1042S_CHAP3_TAXRATE" name="F1042S_CHAP3_TAXRATE"
									value="<%=formData.get("F1042S_CHAP3_TAXRATE") != null ? formData.get("F1042S_CHAP3_TAXRATE") : ""%>"/>
								</td>
							</tr>
						</table>
						<table>
							<tr>
								<td colspan="6">&nbsp;</td>
							</tr>
						</table>
						<table style="width: 100%; id="chapterIndicator4">
							<tr>
								<td width="2%">&nbsp;</td>
								<td width="15%">
									4a. Exemption code 
								</td>
								<td width="30%">
									<input type="text" class="input-sm form-control" id="F1042S_CHAP4_EXEMCODE" name="F1042S_CHAP4_EXEMCODE"
									value="<%=formData.get("F1042S_CHAP4_EXEMCODE") != null ? formData.get("F1042S_CHAP4_EXEMCODE") : ""%>"/>
								</td>
								<td width="2%">&nbsp;</td>
								<td width="18%">
									4b. Tax rate
								</td>
								<td width="30%">
									<input type="text" class="input-sm form-control" id="F1042S_CHAP4_TAXRATE" name="F1042S_CHAP4_TAXRATE"
									value="<%=formData.get("F1042S_CHAP4_TAXRATE") != null ? formData.get("F1042S_CHAP4_TAXRATE") : ""%>"/>
								</td>
							</tr>
						</table>
					</td>					
				</tr>
				<tr>
					<td width="15%">
						5. Withholding allowance
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_WITHHOLD_ALLOWANCE" name="F1042S_WITHHOLD_ALLOWANCE"
						value="<%=formData.get("F1042S_WITHHOLD_ALLOWANCE") != null ? formData.get("F1042S_WITHHOLD_ALLOWANCE") : ""%>"/>
					</td>
					<td width="2%">&nbsp;</td>
					<td width="18%">
						6. Net income
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_NETINCOME" name="F1042S_NETINCOME"
						value="<%=formData.get("F1042S_NETINCOME") != null ? formData.get("F1042S_NETINCOME") : ""%>"/>
					</td>
				</tr>
				<tr>
					<td width="15%">
						7a. Federal tax withheld
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_FEDERALTAX_WITHHELD" name="F1042S_FEDERALTAX_WITHHELD"
						value="<%=formData.get("F1042S_FEDERALTAX_WITHHELD") != null ? formData.get("F1042S_FEDERALTAX_WITHHELD") : ""%>"/>
					</td>
					<td width="2%">&nbsp;</td>
					<td colspan="2">
						7b.  Check if tax not deposited with IRS pursuant to escrow procedure&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<input type="checkbox" class="input-sm form-control" id="F1042S_NOTAX_DEPOSIT" name="F1042S_NOTAX_DEPOSIT_C" value="NOTAX_DEPOSITED" 
						 <% if("NOTAX_DEPOSITED".equals(formData.get("F1042S_NOTAX_DEPOSIT"))){ %> checked="checked" <%} %>/>
					</td>
				</tr>
				<tr>
					<td width="15%">
						8. Tax withheld by other agents 
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_WITHHELD_OTHERAGENT" name="F1042S_WITHHELD_OTHERAGENT"
						value="<%=formData.get("F1042S_WITHHELD_OTHERAGENT") != null ? formData.get("F1042S_WITHHELD_OTHERAGENT") : ""%>"/>
					</td>
					<td width="2%">&nbsp;</td>
					<td width="18%">
						9. Tax paid by withholding agent 
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_WITHHOLDAGENT_TAX" name="F1042S_WITHHOLDAGENT_TAX"
						value="<%=formData.get("F1042S_WITHHOLDAGENT_TAX") != null ? formData.get("F1042S_WITHHOLDAGENT_TAX") : ""%>"/>
					</td>
				</tr>
				<tr>
					<td width="15%">
						10. Total withholding credit
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_TOTALWITHHOLD_CREDIT" name="F1042S_TOTALWITHHOLD_CREDIT"
						value="<%=formData.get("F1042S_TOTALWITHHOLD_CREDIT") != null ? formData.get("F1042S_TOTALWITHHOLD_CREDIT") : ""%>"/>
					</td>
					<td width="2%">&nbsp;</td>
					<td width="18%">
						11. Amount repaid to recipient
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_RECIPIENT_REPAIDAMT" name="F1042S_RECIPIENT_REPAIDAMT"
						value="<%=formData.get("F1042S_RECIPIENT_REPAIDAMT") != null ? formData.get("F1042S_RECIPIENT_REPAIDAMT") : ""%>"/>
					</td>
				</tr>
				<tr>
					<td width="15%">
						12a. Withholding agent's EIN
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_WITHHOLDAGENT_EIN" name="F1042S_WITHHOLDAGENT_EIN"
						value="<%=formData.get("F1042S_WITHHOLDAGENT_EIN") != null ? formData.get("F1042S_WITHHOLDAGENT_EIN") : ""%>"/>
					</td>
					<td width="2%">&nbsp;</td>
					<td width="18%">
						12b. Ch.3 status code
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_CH3STATUSCODE_WITHHOLD" name="F1042S_CH3STATUSCODE_WITHHOLD"
						value="<%=formData.get("F1042S_CH3STATUSCODE_WITHHOLD") != null ? formData.get("F1042S_CH3STATUSCODE_WITHHOLD") : ""%>"/>
					</td>
				</tr>
				<tr>
					<td width="15%">
						12c. Ch.4 status code
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_CH4STATUSCODE_WITHHOLD" name="F1042S_CH4STATUSCODE_WITHHOLD"
						value="<%=formData.get("F1042S_CH4STATUSCODE_WITHHOLD") != null ? formData.get("F1042S_CH4STATUSCODE_WITHHOLD") : ""%>"/>
					</td>
					<td width="2%">&nbsp;</td>
					<td width="18%">
						12d. Withholding agent's name 
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_WITHHOLDAGENT_NAME" name="F1042S_WITHHOLDAGENT_NAME"
						value="<%=formData.get("F1042S_WITHHOLDAGENT_NAME") != null ? formData.get("F1042S_WITHHOLDAGENT_NAME") : ""%>"/>
					</td>
				</tr>
				<tr>
					<td colspan="3">
						12e.  Withholding agent's Global Intermediary Identification Number (GIIN)
					</td>
					<td colspan="2" >
						<input type="text" class="input-sm form-control" id="F1042S_WITHHOLDAGENT_GIIN" name="F1042S_WITHHOLDAGENT_GIIN"
						value="<%=formData.get("F1042S_WITHHOLDAGENT_GIIN") != null ? formData.get("F1042S_WITHHOLDAGENT_GIIN") : ""%>"/>
					</td>
				</tr>
				<tr>
					<td width="15%">
						12f. Country code
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_WITHHOLD_COUNTRYCODE" name="F1042S_WITHHOLD_COUNTRYCODE"
						value="<%=formData.get("F1042S_WITHHOLD_COUNTRYCODE") != null ? formData.get("F1042S_WITHHOLD_COUNTRYCODE") : ""%>"/>
					</td>
					<td width="2%">&nbsp;</td>
					<td width="18%">
						12g. Foreign taxpayer identification number, if any
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_FOREIGN_TIN" name="F1042S_FOREIGN_TIN"
						value="<%=formData.get("F1042S_FOREIGN_TIN") != null ? formData.get("F1042S_FOREIGN_TIN") : ""%>"/>
					</td>
				</tr>
				<tr>
					<td width="15%">
						12h. Address (number and street)
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_WITHHOLDAGENT_ADDR1" name="F1042S_WITHHOLDAGENT_ADDR1"
						value="<%=formData.get("F1042S_WITHHOLDAGENT_ADDR1") != null ? formData.get("F1042S_WITHHOLDAGENT_ADDR1") : ""%>"/>
					</td>
					<td width="2%">&nbsp;</td>
					<td width="18%">
						12i. City or town, state or province, country, ZIP or foreign postal code
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_WITHHOLDAGENT_ADDR2" name="F1042S_WITHHOLDAGENT_ADDR2"
						value="<%=formData.get("F1042S_WITHHOLDAGENT_ADDR2") != null ? formData.get("F1042S_WITHHOLDAGENT_ADDR2") : ""%>"/>
					</td>
				</tr>
				<tr>
					<td width="15%">
						13a. Recipient's name
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_RECIPIENT_NAME" name="F1042S_RECIPIENT_NAME"
						value="<%=formData.get("F1042S_RECIPIENT_NAME") != null ? formData.get("F1042S_RECIPIENT_NAME") : ""%>"/>
					</td>
					<td width="2%">&nbsp;</td>
					<td width="18%">
						13b. Recipient's country code
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_RECIPIENT_COUNTRYCODE" name="F1042S_RECIPIENT_COUNTRYCODE"
						value="<%=formData.get("F1042S_RECIPIENT_COUNTRYCODE") != null ? formData.get("F1042S_RECIPIENT_COUNTRYCODE") : ""%>"/>
					</td>
				</tr>
				<tr>
					<td width="15%">
						13c. Address (number and street)
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_RECIPIENT_ADDR1" name="F1042S_RECIPIENT_ADDR1"
						value="<%=formData.get("F1042S_RECIPIENT_ADDR1") != null ? formData.get("F1042S_RECIPIENT_ADDR1") : ""%>"/>
					</td>
					<td width="2%">&nbsp;</td>
					<td width="18%">
						13d. City or town, state or province, country, ZIP or foreign postal code
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_RECIPIENT_ADDR2" name="F1042S_RECIPIENT_ADDR2"
						value="<%=formData.get("F1042S_RECIPIENT_ADDR2") != null ? formData.get("F1042S_RECIPIENT_ADDR2") : ""%>"/>
					</td>
				</tr>
				<tr>
					<td width="15%">
						13e. Recipient's U.S. TIN, if any
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_RECIPIENT_USTIN" name="F1042S_RECIPIENT_USTIN"
						value="<%=formData.get("F1042S_RECIPIENT_USTIN") != null ? formData.get("F1042S_RECIPIENT_USTIN") : ""%>"/>
					</td>
					<td width="2%">&nbsp;</td>
					<td width="18%">
						13f. Ch.3 status code
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_CH3STATUSCODE_RCIPIENT" name="F1042S_CH3STATUSCODE_RCIPIENT"
						value="<%=formData.get("F1042S_CH3STATUSCODE_RCIPIENT") != null ? formData.get("F1042S_CH3STATUSCODE_RCIPIENT") : ""%>"/>
					</td>
				</tr>
				<tr>
					<td width="15%">
						13g. Ch.4 status code 
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_CH4STATUSCODE_RCIPIENT" name="F1042S_CH4STATUSCODE_RCIPIENT"
						value="<%=formData.get("F1042S_CH4STATUSCODE_RCIPIENT") != null ? formData.get("F1042S_CH4STATUSCODE_RCIPIENT") : ""%>"/>
					</td>
					<td width="2%">&nbsp;</td>
					<td width="18%">
						13h. Recipient's GIIN
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_RECIPIENT_GIIN" name="F1042S_RECIPIENT_GIIN"
						value="<%=formData.get("F1042S_RECIPIENT_GIIN") != null ? formData.get("F1042S_RECIPIENT_GIIN") : ""%>"/>
					</td>
				</tr>
				<tr>
					<td width="15%">
						13i. Recipient's foreign tax identification number, if any
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_RECIPIENT_FTIN" name="F1042S_RECIPIENT_FTIN"
						value="<%=formData.get("F1042S_RECIPIENT_FTIN") != null ? formData.get("F1042S_RECIPIENT_FTIN") : ""%>"/>
					</td>
					<td width="2%">&nbsp;</td>
					<td width="18%">
						13j. LOB code 
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_RECIPIENT_LOBCODE" name="F1042S_RECIPIENT_LOBCODE"
						value="<%=formData.get("F1042S_RECIPIENT_LOBCODE") != null ? formData.get("F1042S_RECIPIENT_LOBCODE") : ""%>"/>
					</td>
				</tr>
				<tr>
					<td width="15%">
						13k. Recipient's account number
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_RECIPIENT_ACCNO" name="F1042S_RECIPIENT_ACCNO"
						value="<%=formData.get("F1042S_RECIPIENT_ACCNO") != null ? formData.get("F1042S_RECIPIENT_ACCNO") : ""%>"/>
					</td>
					<td width="2%">&nbsp;</td>
					<td width="18%">
						13l. Recipient's date of birth 
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_RECIPIENT_DOB" name="F1042S_RECIPIENT_DOB"
						value="<%=formData.get("F1042S_RECIPIENT_DOB") != null ? formData.get("F1042S_RECIPIENT_DOB") : ""%>"/>
					</td>
				</tr>
				<tr>
					<td width="15%">
						14a. Primary Withholding Agent's Name (if applicable)
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_PRIWHAGENT_NAME" name="F1042S_PRIWHAGENT_NAME"
						value="<%=formData.get("F1042S_PRIWHAGENT_NAME") != null ? formData.get("F1042S_PRIWHAGENT_NAME") : ""%>"/>
					</td>
					<td width="2%">&nbsp;</td>
					<td width="18%">
						14b. Primary Withholding Agent's EIN
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_PRIWHAGENT_EIN" name="F1042S_PRIWHAGENT_EIN"
						value="<%=formData.get("F1042S_PRIWHAGENT_EIN") != null ? formData.get("F1042S_PRIWHAGENT_EIN") : ""%>"/>
					</td>
				</tr>
				<tr>
					<td colspan="2">
						15. Check if pro-rata basis reporting&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<input type="checkbox" class="input-sm form-control" id="F1042S_PRORATA" name="F1042S_PRORATA_C" value="PRORATA" 
						 <% if("PRORATA".equals(formData.get("F1042S_PRORATA"))){ %> checked="checked" <%} %>/>
					</td>
					<td width="2%">&nbsp;</td>
					<td width="18%">
						15a. Intermediary or flow-through entity's EIN, if any
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_INTERMED_EIN" name="F1042S_INTERMED_EIN"
						value="<%=formData.get("F1042S_INTERMED_EIN") != null ? formData.get("F1042S_INTERMED_EIN") : ""%>"/>
					</td>
				</tr>
				<tr>
					<td width="15%">
						15b. Ch.3 status code
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_CH3STATUSCODE_INTERMED" name="F1042S_CH3STATUSCODE_INTERMED"
						value="<%=formData.get("F1042S_CH3STATUSCODE_INTERMED") != null ? formData.get("F1042S_CH3STATUSCODE_INTERMED") : ""%>"/>
					</td>
					<td width="2%">&nbsp;</td>
					<td width="18%">
						15c. Ch.4 status code 
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_CH4STATUSCODE_INTERMED" name="F1042S_CH4STATUSCODE_INTERMED"
						value="<%=formData.get("F1042S_CH4STATUSCODE_INTERMED") != null ? formData.get("F1042S_CH4STATUSCODE_INTERMED") : ""%>"/>
					</td>
				</tr>
				<tr>
					<td width="15%">
						15d. Intermediary or flow-through entity's name 
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_INTERMED_ENTITYNAME" name="F1042S_INTERMED_ENTITYNAME"
						value="<%=formData.get("F1042S_INTERMED_ENTITYNAME") != null ? formData.get("F1042S_INTERMED_ENTITYNAME") : ""%>"/>
					</td>
					<td width="2%">&nbsp;</td>
					<td width="18%">
						15e. Intermediary or flow-through entity's GIIN 
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_INTERMED_GIIN" name="F1042S_INTERMED_GIIN"
						value="<%=formData.get("F1042S_INTERMED_GIIN") != null ? formData.get("F1042S_INTERMED_GIIN") : ""%>"/>
					</td>
				</tr>
				<tr>
					<td width="15%">
						15f. Country code
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_INTERMED_COUNTRYCODE" name="F1042S_INTERMED_COUNTRYCODE"
						value="<%=formData.get("F1042S_INTERMED_COUNTRYCODE") != null ? formData.get("F1042S_INTERMED_COUNTRYCODE") : ""%>"/>
					</td>
					<td width="2%">&nbsp;</td>
					<td width="18%">
						15g. Foreign tax identification number, if any 
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_INTERMED_FTIN" name="F1042S_INTERMED_FTIN"
						value="<%=formData.get("F1042S_INTERMED_FTIN") != null ? formData.get("F1042S_INTERMED_FTIN") : ""%>"/>
					</td>
				</tr>
				<tr>
					<td width="15%">
						15h. Address (number and street)
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_INTERMED_ADDR1" name="F1042S_INTERMED_ADDR1"
						value="<%=formData.get("F1042S_INTERMED_ADDR1") != null ? formData.get("F1042S_INTERMED_ADDR1") : ""%>"/>
					</td>
					<td width="2%">&nbsp;</td>
					<td width="18%">
						15i. City or town, state or province, country, ZIP or foreign postal code
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_INTERMED_ADDR2" name="F1042S_INTERMED_ADDR2"
						value="<%=formData.get("F1042S_INTERMED_ADDR2") != null ? formData.get("F1042S_INTERMED_ADDR2") : ""%>"/>
					</td>
				</tr>
				<tr>
					<td width="15%">
						16a. Payer's name
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_PAYER_NAME" name="F1042S_PAYER_NAME"
						value="<%=formData.get("F1042S_PAYER_NAME") != null ? formData.get("F1042S_PAYER_NAME") : ""%>"/>
					</td>
					<td width="2%">&nbsp;</td>
					<td width="18%">
						16b. Payer's TIN
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_PAYER_TIN" name="F1042S_PAYER_TIN"
						value="<%=formData.get("F1042S_PAYER_TIN") != null ? formData.get("F1042S_PAYER_TIN") : ""%>"/>
					</td>
				</tr>
				<tr>
					<td width="15%">
						16c. Payer's GIIN
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_PAYER_GIIN" name="F1042S_PAYER_GIIN"
						value="<%=formData.get("F1042S_PAYER_GIIN") != null ? formData.get("F1042S_PAYER_GIIN") : ""%>"/>
					</td>
					<td width="2%">&nbsp;</td>
					<td width="18%">
						16d. Ch.3 status code
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_CH3STATUSCODE_PAYER" name="F1042S_CH3STATUSCODE_PAYER"
						value="<%=formData.get("F1042S_CH3STATUSCODE_PAYER") != null ? formData.get("F1042S_CH3STATUSCODE_PAYER") : ""%>"/>
					</td>
				</tr>
				<tr>
					<td width="15%">
						16e. Ch. 4 status code
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_CH4STATUSCODE_PAYER" name="F1042S_CH4STATUSCODE_PAYER"
						value="<%=formData.get("F1042S_CH4STATUSCODE_PAYER") != null ? formData.get("F1042S_CH4STATUSCODE_PAYER") : ""%>"/>
					</td>
					<td width="2%">&nbsp;</td>
					<td width="18%">
						17a. State income tax withheld
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_STATEINCTAX_WITHHELD" name="F1042S_STATEINCTAX_WITHHELD"
						value="<%=formData.get("F1042S_STATEINCTAX_WITHHELD") != null ? formData.get("F1042S_STATEINCTAX_WITHHELD") : ""%>"/>
					</td>
				</tr>
				<tr>
					<td width="15%">
						17b. Payer's state tax no.
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_PAYER_STATETAXNO" name="F1042S_PAYER_STATETAXNO"
						value="<%=formData.get("F1042S_PAYER_STATETAXNO") != null ? formData.get("F1042S_PAYER_STATETAXNO") : ""%>"/>
					</td>
					<td width="2%">&nbsp;</td>
					<td width="18%">
						17c. Name of state
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_PAYER_STATENAME" name="F1042S_PAYER_STATENAME"
						value="<%=formData.get("F1042S_PAYER_STATENAME") != null ? formData.get("F1042S_PAYER_STATENAME") : ""%>"/>
					</td>
				</tr>
			</table>
		</div>
		<div>
			<table>
				<tr>
					<td width="65%">&nbsp;</td>
					<td width="15%">&nbsp;</td>
					<td width="20%">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Form <font style="font-weight: bold;">1042-S</font> (2017)</td>
				</tr>
			</table>
			</div>			
		</div>
	</div>
	<div class="section" style="padding: 5px 7.5% 0 7.5%;">
		<div class="col-lg-12">
			<div class="card card-danger" style="margin-bottom: 0; margin-top: 20px;">
				<table>
					<tr>
						<td width="45%" style="padding-left: 10px; "><font style="font-weight: bold;">Explanation of Codes (continued)</br></font>
							<table>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;</font></td>
									<td width="90%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;(Other)</font></td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;20</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Compensation during studying and training<sup>2</sup></td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;23</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Other income </td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;24</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Qualified investment entity (QIE) distributions of &nbsp;&nbsp;&nbsp;&nbsp;capital gains</td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;25</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Trust distributions subject to IRC section 1445 </td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;26</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Unsevered growing crops and timber distributions &nbsp;&nbsp;&nbsp;&nbsp;by a trust subject to IRC section 1445</td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;27</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Publicly traded partnership distributions subject to &nbsp;&nbsp;&nbsp;&nbsp;IRC section 1446</td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;28</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Gambling winnings<sup>3</sup></td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;32</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Notional principal contract income<sup>4</sup></td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;35</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Substitute payment—other </td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;36</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Capital gains distributions </td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;37</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Return of capital </td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;38</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Eligible deferred compensation items subject to &nbsp;&nbsp;&nbsp;&nbsp;IRC section 877A(d)(1) </td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;39</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Distributions from a nongrantor trust subject to &nbsp;&nbsp;&nbsp;&nbsp;IRC section 877A(f)(1)</td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;41</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Guarantee of indebtedness </td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;42</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Earnings as an artist or athlete—no central &nbsp;&nbsp;&nbsp;&nbsp;withholding agreement<sup>5</sup></td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;43</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Earnings as an artist or athlete—central &nbsp;&nbsp;&nbsp;&nbsp;withholding agreement<sup>5</sup></td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;44</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Specified federal procurement payments </td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;50</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Income previously reported under escrow &nbsp;&nbsp;&nbsp;&nbsp;procedure<sup>6</sup></td>
								</tr>
								<tr>
									<td colspan="2" style="padding-left: 10px;"><font style="font-weight: bold;">Boxes 3a and 4a. Exemption Code (applies if the tax rate entered in boxes 3b and 4b is 00.00).</font></td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;Code</font></td>
									<td width="90%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;Authority for Exemption</font></td>
								</tr>
								<tr>
									<td colspan="2"><font style="font-weight: bold;">&nbsp;&nbsp;Chapter 3</font></td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;01</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Effectively connected income </td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;02</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Exempt under IRC (other than portfolio interest) </td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;03</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Income is not from U.S. sources </td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;04</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Exempt under tax treaty </td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;05</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Portfolio interest exempt under IRC</td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;06</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;QI that assumes primary withholding &nbsp;&nbsp;&nbsp;&nbsp;responsibility </td>
								</tr>
							</table>
						</td>
						<td width="10%">&nbsp;</td>
						<td width="45%">
							<table>
								</br>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;07</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;WFP or WFT </td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;08</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;U.S. branch treated as U.S. Person </td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;09</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Territory FI treated as U.S. Person </td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;10</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;QI represents that income is exempt </td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;11</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;QSL that assumes primary withholding &nbsp;&nbsp;&nbsp;&nbsp;responsibility </td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;12</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Payee subjected to chapter 4 withholding </td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;22</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;QDD that assumes primary withholding &nbsp;&nbsp;&nbsp;&nbsp;responsibility </td>
								</tr>
								<tr>
									<td colspan="2"><font style="font-weight: bold;">&nbsp;&nbsp;Chapter 4</font></td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;13</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Grandfathered payment </td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;14</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Effectively connected income </td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;15</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Payee not subject to chapter 4 withholding </td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;16</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Excluded nonfinancial payment </td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;17</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Foreign Entity that assumes primary withholding &nbsp;&nbsp;&nbsp;&nbsp;responsibility</td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;18</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;U.S. Payees—of participating FFI or registered &nbsp;&nbsp;&nbsp;&nbsp;deemedcompliant FFI </td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;19</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Exempt from withholding under IGA<sup>7</sup></td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;20</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Dormant account<sup>8</sup></td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;21</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Other—payment not subject to chapter 4 &nbsp;&nbsp;&nbsp;&nbsp;withholding </td>
								</tr>
								<tr>
									<td colspan="2" style="padding-left: 10px;"><font style="font-weight: bold;">Boxes 12b, 12c, 13f, 13g, 15b, 15c, 16d, and 16e.  Withholding Agent, Recipient, Intermediary, and Payer Chapter 3 and Chapter 4 Status Codes. 
																				</font>
									</td>
								</tr>
								<tr>
									<td colspan="2" style="padding-left: 10px;"><font style="font-weight: bold;">Type of Recipient, Withholding Agent, Payer, or Intermediary</font></td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;Code</font></td>
									<td width="90%">&nbsp;</td>
								</tr>
								<tr>
									<td colspan="2"><font style="font-weight: bold;">&nbsp;&nbsp;Chapter 3&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Status Codes </font></td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;01</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;U.S. Withholding Agent—FI </td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;02</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;U.S. Withholding Agent—Other</td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;03</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Territory FI—treated as U.S. Person </td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;04</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Territory FI—not treated as U.S. Person </td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;05</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;U.S. branch—treated as U.S. Person </td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;06</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;U.S. branch—not treated as U.S. Person </td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;07</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;U.S. branch—ECI presumption applied </td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;08</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Partnership other than Withholding Foreign &nbsp;&nbsp;&nbsp;&nbsp;Partnership </td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;09</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Withholding Foreign Partnership </td>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td colspan="3" style="padding: 0 10px 0 10px;" >
							<font></br><i style="float:right;font-size: xx-small;">See back of Copy D for additional codes</i>
								<hr style=" border: solid 1px; color: black; margin-bottom: 0; ">	
								<font style="font-size: xx-small;">
									<sup>2</sup> If compensation that otherwise would be covered under Income Codes 17 through 20 is directly attributable to the recipient's occupation as an artist or athlete, use Income Code 42 or 43 instead. 
									</br>
									<sup>3</sup> Subject to 30% withholding rate unless the recipient is from one of the treaty countries listed under Gambling winnings (Income Code 28) in Pub. 515.
									</br>
									<sup>4</sup> Use appropriate Interest Income Code for embedded interest in a notional principal contract.
									</br>
									<sup>5</sup> Income Code 43 should only be used if Letter 4492, Venue Notification has been issued by the Internal Revenue Service (otherwise use Income Code 42 for earnings as an artist or athlete). If Income Code 42 or 43 is used, Recipient Code 22 (artist or athlete) should be used instead of Recipient Code 16 (individual), 15 (corporation), or 08 (partnership other than withholding foreign partnership). 
									</br>
									<sup>6</sup> Use only to report gross income the tax for which is being deposited in the current year because such tax was previously escrowed for chapters 3 and 4 and the withholding agent previously reported the gross income in a prior year and checked the box to report the tax as not deposited under the escrow procedure. See the instructions to this form for further explanation. 
									</br>
									<sup>7</sup> Use only to report a U.S. reportable account or nonconsenting U.S. account that is receiving a payment subject to chapter 3 withholding. 
									</br>
									<sup>8</sup> Use only if applying the escrow procedure for dormant accounts under Regulations section 1.1471-4(b)(6). If tax was withheld and deposited under chapter 3, do not check box 7b ("tax not deposited with IRS pursuant to escrow procedure"). You must instead enter "3" in box 3 and complete box 3b.		
								</font>
							</font>
						</td>
					</tr>
					
				</table>
			</div>
		</div>
	</div>
	<!-- COPY C ENDING -->
	<!-- COPY D STARTING -->
	<div class="section" style="padding: 5px 7.5% 0 7.5%;">
		<div class="col-lg-12">
			<div class="card card-primary" style="margin-top: 20px;">
				<div class="card-body">
					<table class="table customHeaderTable" style="text-align: center;">
						<tr>
							<td width="18%" style="border-right: 2px solid black;">
								Form <font style="font-weight: bold; font-size: 20px" face="Helvetica">1042-S</font>
							</td>
							<td width="65%">
								<font style="font-weight: bold; font-size: 20px" face="ITC Franklin Gothic Std Book">Foreign Person's U.S. Source Income Subject to Withholding  </font><font style="font-weight: bold; font-size: 20px" face="Helvetica">2017</font>
							</td>
							<td width="17%" style="border-left: 2px solid black;">
								OMB No. 1545-2246
							</td>
						</tr>
						<tr>
							<td style="border-right: 2px solid black; border-bottom: 2px solid black">
								Department of the Treasury Internal Revenue Service
							</td>
							<td style="border-bottom: 2px solid black">
								Information about Form 1042-S and its separate instructions is at <a href="javascript:void(0)" onclick="window.open('http://www.irs.gov/form1024s')">www.irs.gov/form1024s</a>.
							</td>
							<td style="border-left: 2px solid black; border-bottom: 2px solid black">
								<font style="font-weight: bold; font-size: 20px" face="Helvetica">Copy D </font>for Recipient 
									</br><font style="font-size: 10px"">Attach to any state tax return you file</font>
							</td>
						</tr>
						<tr style="text-align: left;">
							<td colspan="3">
								<table width="100%">
									<tr>
										<td width="44%">
											<label for="REPORT_TYPE_FATCA2">
												Unique Form Identifier <input type="text" class="input-sm form-control" name="F1042S_UNQFORMID" id="F1042S_UNQFORMID" 
												value="<%=formData.get("F1042S_UNQFORMID") != null ? formData.get("F1042S_UNQFORMID") : "" %>"/>
											</label>
										</td>
										<td width="17%">
											<label for="REPORT_TYPE_FATCA4">
												Amended  <input type="checkbox" id="F1042S_AMENDEDREPORT_D" name="F1042S_AMENDEDREPORT_D" value="1024S_AMENDED"
												<% if("1024S_AMENDED".equals(formData.get("F1042S_AMENDEDREPORT_D"))){ %> checked="checked" <%} %>/>
											</label>
										</td>
										<td width="49%">
											<label for="REPORT_TYPE_FATCA3">
												Amendment No. <input type="text" class="input-sm form-control" name="F1042S_AMENDMENTNO" id="F1042S_AMENDMENTNO" 
												value="<%=formData.get("F1042S_AMENDMENTNO") != null ? formData.get("F1042S_AMENDMENTNO") : "" %>"/>
											</label>
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
				</div>
			</div>
		</div>
	</div>	
	<div class="section" style="padding: 0 7.5% 0 7.5%;">
	<div class="col-lg-12">
		<div class="card card-danger" style="margin-bottom: 0; margin-top: 20px;">
			<table class="table">
				<tr>
					<td width="15%">
						1. Income Code
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_INCOMECODE" name="F1042S_INCOMECODE"
						value="<%=formData.get("F1042S_INCOMECODE") != null ? formData.get("F1042S_INCOMECODE") : ""%>"/>
					</td>
					<td width="2%">&nbsp;</td>
					<td width="18%">
						2. Gross Income
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_GROSSINCOME" name="F1042S_GROSSINCOME"
						value="<%=formData.get("F1042S_GROSSINCOME") != null ? formData.get("F1042S_GROSSINCOME") : ""%>"/>
					</td>
					
				</tr>
				<tr>
					<td colspan="5">
						3. Chapter indicator (Enter"3"
						<input type="radio" class="input-sm form-control" id="F1042S_CHAPTER3INDICATOR" name="F1042S_CHAPTERINDICATOR_D" value="3"
						<%if("3".equals(formData.get("F1042S_CHAPTERINDICATOR_D"))){ %> checked="checked" <%} %>/>
						or "4"
						<input type="radio" class="input-sm form-control" id="F1042S_CHAPTER4INDICATOR" name="F1042S_CHAPTERINDICATOR_D" value="4"
						<%if("4".equals(formData.get("F1042S_CHAPTERINDICATOR_D"))){ %> checked="checked" <%} %>/>)
						<table style="width: 100%; id="chapterIndicator3">
							<tr>
								<td width="2%">&nbsp;</td>
								<td width="15%">
									3a. Exemption code 
								</td>
								<td width="30%">
									<input type="text" class="input-sm form-control" id="F1042S_CHAP3_EXEMCODE" name="F1042S_CHAP3_EXEMCODE"
									value="<%=formData.get("F1042S_CHAP3_EXEMCODE") != null ? formData.get("F1042S_CHAP3_EXEMCODE") : ""%>"/>
								</td>
								<td width="2%">&nbsp;</td>
								<td width="18%">
									3b. Tax rate
								</td>
								<td width="30%">
									<input type="text" class="input-sm form-control" id="F1042S_CHAP3_TAXRATE" name="F1042S_CHAP3_TAXRATE"
									value="<%=formData.get("F1042S_CHAP3_TAXRATE") != null ? formData.get("F1042S_CHAP3_TAXRATE") : ""%>"/>
								</td>
							</tr>
						</table>
						<table>
							<tr>
								<td colspan="6">&nbsp;</td>
							</tr>
						</table>
						<table style="width: 100%; id="chapterIndicator4">
							<tr>
								<td width="2%">&nbsp;</td>
								<td width="15%">
									4a. Exemption code 
								</td>
								<td width="30%">
									<input type="text" class="input-sm form-control" id="F1042S_CHAP4_EXEMCODE" name="F1042S_CHAP4_EXEMCODE"
									value="<%=formData.get("F1042S_CHAP4_EXEMCODE") != null ? formData.get("F1042S_CHAP4_EXEMCODE") : ""%>"/>
								</td>
								<td width="2%">&nbsp;</td>
								<td width="18%">
									4b. Tax rate
								</td>
								<td width="30%">
									<input type="text" class="input-sm form-control" id="F1042S_CHAP4_TAXRATE" name="F1042S_CHAP4_TAXRATE"
									value="<%=formData.get("F1042S_CHAP4_TAXRATE") != null ? formData.get("F1042S_CHAP4_TAXRATE") : ""%>"/>
								</td>
							</tr>
						</table>
					</td>					
				</tr>
				<tr>
					<td width="15%">
						5. Withholding allowance
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_WITHHOLD_ALLOWANCE" name="F1042S_WITHHOLD_ALLOWANCE"
						value="<%=formData.get("F1042S_WITHHOLD_ALLOWANCE") != null ? formData.get("F1042S_WITHHOLD_ALLOWANCE") : ""%>"/>
					</td>
					<td width="2%">&nbsp;</td>
					<td width="18%">
						6. Net income
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_NETINCOME" name="F1042S_NETINCOME"
						value="<%=formData.get("F1042S_NETINCOME") != null ? formData.get("F1042S_NETINCOME") : ""%>"/>
					</td>
				</tr>
				<tr>
					<td width="15%">
						7a. Federal tax withheld
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_FEDERALTAX_WITHHELD" name="F1042S_FEDERALTAX_WITHHELD"
						value="<%=formData.get("F1042S_FEDERALTAX_WITHHELD") != null ? formData.get("F1042S_FEDERALTAX_WITHHELD") : ""%>"/>
					</td>
					<td width="2%">&nbsp;</td>
					<td colspan="2">
						7b.  Check if tax not deposited with IRS pursuant to escrow procedure&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<input type="checkbox" class="input-sm form-control" id="F1042S_NOTAX_DEPOSIT" name="F1042S_NOTAX_DEPOSIT_D" value="NOTAX_DEPOSITED" 
						 <% if("NOTAX_DEPOSITED".equals(formData.get("F1042S_NOTAX_DEPOSIT"))){ %> checked="checked" <%} %>/>
					</td>
				</tr>
				<tr>
					<td width="15%">
						8. Tax withheld by other agents 
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_WITHHELD_OTHERAGENT" name="F1042S_WITHHELD_OTHERAGENT"
						value="<%=formData.get("F1042S_WITHHELD_OTHERAGENT") != null ? formData.get("F1042S_WITHHELD_OTHERAGENT") : ""%>"/>
					</td>
					<td width="2%">&nbsp;</td>
					<td width="18%">
						9. Tax paid by withholding agent 
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_WITHHOLDAGENT_TAX" name="F1042S_WITHHOLDAGENT_TAX"
						value="<%=formData.get("F1042S_WITHHOLDAGENT_TAX") != null ? formData.get("F1042S_WITHHOLDAGENT_TAX") : ""%>"/>
					</td>
				</tr>
				<tr>
					<td width="15%">
						10. Total withholding credit
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_TOTALWITHHOLD_CREDIT" name="F1042S_TOTALWITHHOLD_CREDIT"
						value="<%=formData.get("F1042S_TOTALWITHHOLD_CREDIT") != null ? formData.get("F1042S_TOTALWITHHOLD_CREDIT") : ""%>"/>
					</td>
					<td width="2%">&nbsp;</td>
					<td width="18%">
						11. Amount repaid to recipient
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_RECIPIENT_REPAIDAMT" name="F1042S_RECIPIENT_REPAIDAMT"
						value="<%=formData.get("F1042S_RECIPIENT_REPAIDAMT") != null ? formData.get("F1042S_RECIPIENT_REPAIDAMT") : ""%>"/>
					</td>
				</tr>
				<tr>
					<td width="15%">
						12a. Withholding agent's EIN
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_WITHHOLDAGENT_EIN" name="F1042S_WITHHOLDAGENT_EIN"
						value="<%=formData.get("F1042S_WITHHOLDAGENT_EIN") != null ? formData.get("F1042S_WITHHOLDAGENT_EIN") : ""%>"/>
					</td>
					<td width="2%">&nbsp;</td>
					<td width="18%">
						12b. Ch.3 status code
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_CH3STATUSCODE_WITHHOLD" name="F1042S_CH3STATUSCODE_WITHHOLD"
						value="<%=formData.get("F1042S_CH3STATUSCODE_WITHHOLD") != null ? formData.get("F1042S_CH3STATUSCODE_WITHHOLD") : ""%>"/>
					</td>
				</tr>
				<tr>
					<td width="15%">
						12c. Ch.4 status code
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_CH4STATUSCODE_WITHHOLD" name="F1042S_CH4STATUSCODE_WITHHOLD"
						value="<%=formData.get("F1042S_CH4STATUSCODE_WITHHOLD") != null ? formData.get("F1042S_CH4STATUSCODE_WITHHOLD") : ""%>"/>
					</td>
					<td width="2%">&nbsp;</td>
					<td width="18%">
						12d. Withholding agent's name 
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_WITHHOLDAGENT_NAME" name="F1042S_WITHHOLDAGENT_NAME"
						value="<%=formData.get("F1042S_WITHHOLDAGENT_NAME") != null ? formData.get("F1042S_WITHHOLDAGENT_NAME") : ""%>"/>
					</td>
				</tr>
				<tr>
					<td colspan="3">
						12e.  Withholding agent's Global Intermediary Identification Number (GIIN)
					</td>
					<td colspan="2" >
						<input type="text" class="input-sm form-control" id="F1042S_WITHHOLDAGENT_GIIN" name="F1042S_WITHHOLDAGENT_GIIN"
						value="<%=formData.get("F1042S_WITHHOLDAGENT_GIIN") != null ? formData.get("F1042S_WITHHOLDAGENT_GIIN") : ""%>"/>
					</td>
				</tr>
				<tr>
					<td width="15%">
						12f. Country code
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_WITHHOLD_COUNTRYCODE" name="F1042S_WITHHOLD_COUNTRYCODE"
						value="<%=formData.get("F1042S_WITHHOLD_COUNTRYCODE") != null ? formData.get("F1042S_WITHHOLD_COUNTRYCODE") : ""%>"/>
					</td>
					<td width="2%">&nbsp;</td>
					<td width="18%">
						12g. Foreign taxpayer identification number, if any
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_FOREIGN_TIN" name="F1042S_FOREIGN_TIN"
						value="<%=formData.get("F1042S_FOREIGN_TIN") != null ? formData.get("F1042S_FOREIGN_TIN") : ""%>"/>
					</td>
				</tr>
				<tr>
					<td width="15%">
						12h. Address (number and street)
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_WITHHOLDAGENT_ADDR1" name="F1042S_WITHHOLDAGENT_ADDR1"
						value="<%=formData.get("F1042S_WITHHOLDAGENT_ADDR1") != null ? formData.get("F1042S_WITHHOLDAGENT_ADDR1") : ""%>"/>
					</td>
					<td width="2%">&nbsp;</td>
					<td width="18%">
						12i. City or town, state or province, country, ZIP or foreign postal code
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_WITHHOLDAGENT_ADDR2" name="F1042S_WITHHOLDAGENT_ADDR2"
						value="<%=formData.get("F1042S_WITHHOLDAGENT_ADDR2") != null ? formData.get("F1042S_WITHHOLDAGENT_ADDR2") : ""%>"/>
					</td>
				</tr>
				<tr>
					<td width="15%">
						13a. Recipient's name
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_RECIPIENT_NAME" name="F1042S_RECIPIENT_NAME"
						value="<%=formData.get("F1042S_RECIPIENT_NAME") != null ? formData.get("F1042S_RECIPIENT_NAME") : ""%>"/>
					</td>
					<td width="2%">&nbsp;</td>
					<td width="18%">
						13b. Recipient's country code
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_RECIPIENT_COUNTRYCODE" name="F1042S_RECIPIENT_COUNTRYCODE"
						value="<%=formData.get("F1042S_RECIPIENT_COUNTRYCODE") != null ? formData.get("F1042S_RECIPIENT_COUNTRYCODE") : ""%>"/>
					</td>
				</tr>
				<tr>
					<td width="15%">
						13c. Address (number and street)
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_RECIPIENT_ADDR1" name="F1042S_RECIPIENT_ADDR1"
						value="<%=formData.get("F1042S_RECIPIENT_ADDR1") != null ? formData.get("F1042S_RECIPIENT_ADDR1") : ""%>"/>
					</td>
					<td width="2%">&nbsp;</td>
					<td width="18%">
						13d. City or town, state or province, country, ZIP or foreign postal code
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_RECIPIENT_ADDR2" name="F1042S_RECIPIENT_ADDR2"
						value="<%=formData.get("F1042S_RECIPIENT_ADDR2") != null ? formData.get("F1042S_RECIPIENT_ADDR2") : ""%>"/>
					</td>
				</tr>
				<tr>
					<td width="15%">
						13e. Recipient's U.S. TIN, if any
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_RECIPIENT_USTIN" name="F1042S_RECIPIENT_USTIN"
						value="<%=formData.get("F1042S_RECIPIENT_USTIN") != null ? formData.get("F1042S_RECIPIENT_USTIN") : ""%>"/>
					</td>
					<td width="2%">&nbsp;</td>
					<td width="18%">
						13f. Ch.3 status code
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_CH3STATUSCODE_RCIPIENT" name="F1042S_CH3STATUSCODE_RCIPIENT"
						value="<%=formData.get("F1042S_CH3STATUSCODE_RCIPIENT") != null ? formData.get("F1042S_CH3STATUSCODE_RCIPIENT") : ""%>"/>
					</td>
				</tr>
				<tr>
					<td width="15%">
						13g. Ch.4 status code 
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_CH4STATUSCODE_RCIPIENT" name="F1042S_CH4STATUSCODE_RCIPIENT"
						value="<%=formData.get("F1042S_CH4STATUSCODE_RCIPIENT") != null ? formData.get("F1042S_CH4STATUSCODE_RCIPIENT") : ""%>"/>
					</td>
					<td width="2%">&nbsp;</td>
					<td width="18%">
						13h. Recipient's GIIN
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_RECIPIENT_GIIN" name="F1042S_RECIPIENT_GIIN"
						value="<%=formData.get("F1042S_RECIPIENT_GIIN") != null ? formData.get("F1042S_RECIPIENT_GIIN") : ""%>"/>
					</td>
				</tr>
				<tr>
					<td width="15%">
						13i. Recipient's foreign tax identification number, if any
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_RECIPIENT_FTIN" name="F1042S_RECIPIENT_FTIN"
						value="<%=formData.get("F1042S_RECIPIENT_FTIN") != null ? formData.get("F1042S_RECIPIENT_FTIN") : ""%>"/>
					</td>
					<td width="2%">&nbsp;</td>
					<td width="18%">
						13j. LOB code 
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_RECIPIENT_LOBCODE" name="F1042S_RECIPIENT_LOBCODE"
						value="<%=formData.get("F1042S_RECIPIENT_LOBCODE") != null ? formData.get("F1042S_RECIPIENT_LOBCODE") : ""%>"/>
					</td>
				</tr>
				<tr>
					<td width="15%">
						13k. Recipient's account number
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_RECIPIENT_ACCNO" name="F1042S_RECIPIENT_ACCNO"
						value="<%=formData.get("F1042S_RECIPIENT_ACCNO") != null ? formData.get("F1042S_RECIPIENT_ACCNO") : ""%>"/>
					</td>
					<td width="2%">&nbsp;</td>
					<td width="18%">
						13l. Recipient's date of birth 
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_RECIPIENT_DOB" name="F1042S_RECIPIENT_DOB"
						value="<%=formData.get("F1042S_RECIPIENT_DOB") != null ? formData.get("F1042S_RECIPIENT_DOB") : ""%>"/>
					</td>
				</tr>
				<tr>
					<td width="15%">
						14a. Primary Withholding Agent's Name (if applicable)
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_PRIWHAGENT_NAME" name="F1042S_PRIWHAGENT_NAME"
						value="<%=formData.get("F1042S_PRIWHAGENT_NAME") != null ? formData.get("F1042S_PRIWHAGENT_NAME") : ""%>"/>
					</td>
					<td width="2%">&nbsp;</td>
					<td width="18%">
						14b. Primary Withholding Agent's EIN
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_PRIWHAGENT_EIN" name="F1042S_PRIWHAGENT_EIN"
						value="<%=formData.get("F1042S_PRIWHAGENT_EIN") != null ? formData.get("F1042S_PRIWHAGENT_EIN") : ""%>"/>
					</td>
				</tr>
				<tr>
					<td colspan="2">
						15. Check if pro-rata basis reporting&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<input type="checkbox" class="input-sm form-control" id="F1042S_PRORATA" name="F1042S_PRORATA_D" value="PRORATA" 
						 <% if("PRORATA".equals(formData.get("F1042S_PRORATA"))){ %> checked="checked" <%} %>/>
					</td>
					<td width="2%">&nbsp;</td>
					<td width="18%">
						15a. Intermediary or flow-through entity's EIN, if any
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_INTERMED_EIN" name="F1042S_INTERMED_EIN"
						value="<%=formData.get("F1042S_INTERMED_EIN") != null ? formData.get("F1042S_INTERMED_EIN") : ""%>"/>
					</td>
				</tr>
				<tr>
					<td width="15%">
						15b. Ch.3 status code
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_CH3STATUSCODE_INTERMED" name="F1042S_CH3STATUSCODE_INTERMED"
						value="<%=formData.get("F1042S_CH3STATUSCODE_INTERMED") != null ? formData.get("F1042S_CH3STATUSCODE_INTERMED") : ""%>"/>
					</td>
					<td width="2%">&nbsp;</td>
					<td width="18%">
						15c. Ch.4 status code 
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_CH4STATUSCODE_INTERMED" name="F1042S_CH4STATUSCODE_INTERMED"
						value="<%=formData.get("F1042S_CH4STATUSCODE_INTERMED") != null ? formData.get("F1042S_CH4STATUSCODE_INTERMED") : ""%>"/>
					</td>
				</tr>
				<tr>
					<td width="15%">
						15d. Intermediary or flow-through entity's name 
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_INTERMED_ENTITYNAME" name="F1042S_INTERMED_ENTITYNAME"
						value="<%=formData.get("F1042S_INTERMED_ENTITYNAME") != null ? formData.get("F1042S_INTERMED_ENTITYNAME") : ""%>"/>
					</td>
					<td width="2%">&nbsp;</td>
					<td width="18%">
						15e. Intermediary or flow-through entity's GIIN 
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_INTERMED_GIIN" name="F1042S_INTERMED_GIIN"
						value="<%=formData.get("F1042S_INTERMED_GIIN") != null ? formData.get("F1042S_INTERMED_GIIN") : ""%>"/>
					</td>
				</tr>
				<tr>
					<td width="15%">
						15f. Country code
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_INTERMED_COUNTRYCODE" name="F1042S_INTERMED_COUNTRYCODE"
						value="<%=formData.get("F1042S_INTERMED_COUNTRYCODE") != null ? formData.get("F1042S_INTERMED_COUNTRYCODE") : ""%>"/>
					</td>
					<td width="2%">&nbsp;</td>
					<td width="18%">
						15g. Foreign tax identification number, if any 
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_INTERMED_FTIN" name="F1042S_INTERMED_FTIN"
						value="<%=formData.get("F1042S_INTERMED_FTIN") != null ? formData.get("F1042S_INTERMED_FTIN") : ""%>"/>
					</td>
				</tr>
				<tr>
					<td width="15%">
						15h. Address (number and street)
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_INTERMED_ADDR1" name="F1042S_INTERMED_ADDR1"
						value="<%=formData.get("F1042S_INTERMED_ADDR1") != null ? formData.get("F1042S_INTERMED_ADDR1") : ""%>"/>
					</td>
					<td width="2%">&nbsp;</td>
					<td width="18%">
						15i. City or town, state or province, country, ZIP or foreign postal code
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_INTERMED_ADDR2" name="F1042S_INTERMED_ADDR2"
						value="<%=formData.get("F1042S_INTERMED_ADDR2") != null ? formData.get("F1042S_INTERMED_ADDR2") : ""%>"/>
					</td>
				</tr>
				<tr>
					<td width="15%">
						16a. Payer's name
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_PAYER_NAME" name="F1042S_PAYER_NAME"
						value="<%=formData.get("F1042S_PAYER_NAME") != null ? formData.get("F1042S_PAYER_NAME") : ""%>"/>
					</td>
					<td width="2%">&nbsp;</td>
					<td width="18%">
						16b. Payer's TIN
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_PAYER_TIN" name="F1042S_PAYER_TIN"
						value="<%=formData.get("F1042S_PAYER_TIN") != null ? formData.get("F1042S_PAYER_TIN") : ""%>"/>
					</td>
				</tr>
				<tr>
					<td width="15%">
						16c. Payer's GIIN
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_PAYER_GIIN" name="F1042S_PAYER_GIIN"
						value="<%=formData.get("F1042S_PAYER_GIIN") != null ? formData.get("F1042S_PAYER_GIIN") : ""%>"/>
					</td>
					<td width="2%">&nbsp;</td>
					<td width="18%">
						16d. Ch.3 status code
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_CH3STATUSCODE_PAYER" name="F1042S_CH3STATUSCODE_PAYER"
						value="<%=formData.get("F1042S_CH3STATUSCODE_PAYER") != null ? formData.get("F1042S_CH3STATUSCODE_PAYER") : ""%>"/>
					</td>
				</tr>
				<tr>
					<td width="15%">
						16e. Ch. 4 status code
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_CH4STATUSCODE_PAYER" name="F1042S_CH4STATUSCODE_PAYER"
						value="<%=formData.get("F1042S_CH4STATUSCODE_PAYER") != null ? formData.get("F1042S_CH4STATUSCODE_PAYER") : ""%>"/>
					</td>
					<td width="2%">&nbsp;</td>
					<td width="18%">
						17a. State income tax withheld
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_STATEINCTAX_WITHHELD" name="F1042S_STATEINCTAX_WITHHELD"
						value="<%=formData.get("F1042S_STATEINCTAX_WITHHELD") != null ? formData.get("F1042S_STATEINCTAX_WITHHELD") : ""%>"/>
					</td>
				</tr>
				<tr>
					<td width="15%">
						17b. Payer's state tax no.
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_PAYER_STATETAXNO" name="F1042S_PAYER_STATETAXNO"
						value="<%=formData.get("F1042S_PAYER_STATETAXNO") != null ? formData.get("F1042S_PAYER_STATETAXNO") : ""%>"/>
					</td>
					<td width="2%">&nbsp;</td>
					<td width="18%">
						17c. Name of state
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_PAYER_STATENAME" name="F1042S_PAYER_STATENAME"
						value="<%=formData.get("F1042S_PAYER_STATENAME") != null ? formData.get("F1042S_PAYER_STATENAME") : ""%>"/>
					</td>
				</tr>
			</table>
		</div>
		<div>
			<table>
				<tr>
					<td width="65%">&nbsp;</td>
					<td width="15%">&nbsp;</td>
					<td width="20%">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Form <font style="font-weight: bold;">1042-S</font> (2017)</td>
				</tr>
			</table>
			</div>			
		</div>
	</div>
	<div class="section" style="padding: 5px 7.5% 0 7.5%;">
		<div class="col-lg-12">
			<div class="card card-danger" style="margin-bottom: 0; margin-top: 20px;">
				<table>
					<tr>
						<td width="45%" style="padding-left: 10px; "><font style="font-weight: bold;">Explanation of Codes (continued)</br></font>
							<table>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;10</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Trust other than Withholding Foreign Trust</td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;11</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Withholding Foreign Trust </td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;12</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Qualified Intermediary</td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;13</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Qualified Securities Lender—Qualified &nbsp;&nbsp;&nbsp;&nbsp;Intermediary </td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;14</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Qualified Securities Lender—Other</td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;15</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Corporation</td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;16</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Individual</td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;17</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Estate</td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;18</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Private Foundation </td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;19</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Government or International Organization</td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;20</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Tax Exempt Organization (Section 501(c) entities)</td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;21</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Unknown Recipient </td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;22</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Artist or Athlete</td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;23</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Pension</td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;24</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Foreign Central Bank of Issue </td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;25</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Nonqualified Intermediary </td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;26</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Hybrid entity making Treaty Claim </td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;34</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;U.S. Withholding Agent—Foreign branch of FI </td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;35</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Qualified Derivatives Dealer </td>
								</tr>
								<tr>
									<td colspan="2" style="padding-left: 10px;"><font style="font-weight: bold;">Pooled Reporting Codes<sup>9</sup></font></td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;27</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Withholding Rate Pool—General </td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;28</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Withholding Rate Pool—Exempt Organization </td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;29</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;PAI Withholding Rate Pool—General </td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;30</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;PAI Withholding Rate Pool—Exempt Organization </td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;31</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Agency Withholding Rate Pool—General </td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;32</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Agency Withholding Rate Pool—Exempt &nbsp;&nbsp;&nbsp;&nbsp;Organization </td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;33</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Joint account withholding rate pool </td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;36</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Qualifying dividend equivalent offsetting payments &nbsp;&nbsp;&nbsp;&nbsp;to U.S. persons</td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;37</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Nonqualifying dividend equivalent payments to &nbsp;&nbsp;&nbsp;&nbsp;U.S.  persons—Undisclosed </td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;38</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Other qualifying dividend equivalent offsetting &nbsp;&nbsp;&nbsp;&nbsp;payments (ECI)</td>
								</tr>
								<tr>
									<td colspan="2"><font style="font-weight: bold;">&nbsp;&nbsp;Chapter 3&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Status Codes </font></td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;01</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;U.S. Withholding Agent—FI </td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;02</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;U.S. Withholding Agent—Other </td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;03</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Territory FI—not treated as U.S. Person </td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;04</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Territory FI—treated as U.S. Person </td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;05</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Participating  FFI—Other </td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;06</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Participating  FFI—Reporting Model 2 FFI </td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;07</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Registered Deemed-Compliant FFI—Reporting &nbsp;&nbsp;&nbsp;&nbsp;Model 1 FFI </td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;08</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Registered Deemed-Compliant FFI—Sponsored &nbsp;&nbsp;&nbsp;&nbsp;Entity </td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;09</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Registered Deemed-Compliant FFI—Other </td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;10</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Certified Deemed-Compliant FFI—Other </td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;11</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Certified Deemed-Compliant FFI—FFI with Low &nbsp;&nbsp;&nbsp;&nbsp;Value Accounts</td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;12</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Certified Deemed-Compliant FFI—Nonregistering &nbsp;&nbsp;&nbsp;&nbsp;Local Bank</td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;13</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Certified Deemed-Compliant FFI—Sponsored &nbsp;&nbsp;&nbsp;&nbsp;Entity </td>
								</tr>
							</table>
						</td>
						<td width="10%">&nbsp;</td>
						<td width="45%">
							<table>
								</br>
								
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;14</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Certified Deemed-Compliant FFI—Investment &nbsp;&nbsp;&nbsp;&nbsp;Advisor or Investment Manager</td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;15</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Nonparticipating FFI </td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;16</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Owner-Documented FFI </td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;19</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Passive NFFE identifying Substantial U.S. Owners </td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;20</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Passive NFFE with no Substantial U.S. Owners </td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;21</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Publicly Traded NFFE or Affiliate of Publicly Traded &nbsp;&nbsp;&nbsp;&nbsp;NFFE </td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;22</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Active NFFE  </td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;23</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Individual</td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;24</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Section 501(c) Entities </td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;25</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Excepted Territory NFFE </td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;26</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Excepted NFFE—Other </td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;27</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Exempt Beneficial Owner </td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;28</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Entity Wholly Owned by Exempt Beneficial Owners </td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;29</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Unknown Recipient </td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;30</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Recalcitrant Account Holder </td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;31</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Nonreporting IGA FFI </td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;32</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Direct reporting NFFE </td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;33</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;U.S. reportable account </td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;34</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Nonconsenting U.S. account </td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;35</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Sponsored direct reporting NFFE </td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;36</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Excepted Inter-affiliate FFI </td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;37</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Undocumented Preexisting Obligation </td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;38</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;U.S. Branch—ECI presumption applied </td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;39</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Account Holder of Excluded Financial Account<sup>10</sup> </td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;40</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Passive NFFE reported by FFI<sup>11</sup> </td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;41</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;NFFE subject to 1472 withholding </td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;50</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;U.S. Withholding Agent—Foreign branch of FI</td>
								</tr>
								<tr>
									<td colspan="2"><font style="font-weight: bold;">Pooled Reporting Codes</font></td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;42</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Recalcitrant Pool—No U.S. Indicia </td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;43</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Recalcitrant Pool—U.S. Indicia </td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;44</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Recalcitrant Pool—Dormant Account </td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;45</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Recalcitrant Pool—U.S. Persons </td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;46</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Recalcitrant Pool—Passive NFFEs </td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;47</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Nonparticipating FFI Pool </td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;48</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;U.S. Payees Pool </td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;49</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;QI-Recalcitrant Pool—GeneraI<sup>12</sup> </td>
								</tr>
								<tr>
									<td colspan="2" ><font style="font-weight: bold;">Box 13j. LOB Code (enter the code that best describes the applicable limitation on benefits (LOB) category that qualifies the taxpayer for the requested treaty benefits).</font></td>
								</tr>
								<tr>
									<td colspan="2"><font style="font-weight: bold;">LOB Code&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;LOB Treaty Category </font></td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;01</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Individual </td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;02</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Government – contracting state/political &nbsp;&nbsp;&nbsp;&nbsp;subdivision/local authority</td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;03</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Tax exempt pension trust/Pension fund </td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;04</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Tax exempt/Charitable organization </td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;05</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Publicly traded corporation </td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;06</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Subsidiary of publicly traded corporation </td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;07</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Company that meets the ownership and base &nbsp;&nbsp;&nbsp;&nbsp;erosion test </td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;08</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Company that meets the derivative benefits test </td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;09</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Company with an item of income that meets the &nbsp;&nbsp;&nbsp;&nbsp;active trade or business test</td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;10</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Discretionary determination </td>
								</tr>
								<tr>
									<td width="10%"><font style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;11</font></td>
									<td width="90%">&nbsp;&nbsp;&nbsp;&nbsp;Other</td>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td colspan="3" style="padding: 0 10px 0 10px;" >
							<font>
								<hr style=" border: solid 1px; color: black; margin-bottom: 0; ">	
								<font style="font-size: xx-small;">
									<sup>9</sup> Codes 27 through 33 should only be used by a QI (including a QI acting as a QDD), QSL, WP, or WT.  Codes 36 through 38 should only be used by a QI acting as a QDD. 
									</br>
									<sup>10</sup> This code should only be used if income is paid to an account that is excluded from the definition of financial account under Regulations section 1.1471-5(b)(2) or under Annex II of the applicable Model 1 IGA or Model 2 IGA. 
									</br>
									<sup>11</sup> This code should only be used when the withholding agent has received a certification on the FFI withholding statement of a participating FFI or registered deemedcompliant FFI that maintains the account that the FFI has reported the account held by the passive NFFE as a U.S. account (or U.S. reportable account) under its FATCA requirements. The withholding agent must report the name and GIIN of such FFA in boxes 15d and 15e.
									</br>
									<sup>12</sup> This code should only be used by a withholding agent that is reporting a payment (or portion of a payment) made to a QI with respect to the QI's recalcitrant account holders. 		
								</font>
							</font>
						</td>
					</tr>
					
				</table>
			</div>
		</div>
	</div>
	<!-- COPY D ENDING -->
	<!-- COPY E STARTING -->
	<div class="section" style="padding: 5px 7.5% 0 7.5%;">
		<div class="col-lg-12">
			<div class="card card-primary" style="margin-top: 20px;">
				<div class="card-body">
					<table class="table customHeaderTable" style="text-align: center;">
						<tr>
							<td width="18%" style="border-right: 2px solid black;">
								Form <font style="font-weight: bold; font-size: 20px" face="Helvetica">1042-S</font>
							</td>
							<td width="65%">
								<font style="font-weight: bold; font-size: 20px" face="ITC Franklin Gothic Std Book">Foreign Person's U.S. Source Income Subject to Withholding  </font><font style="font-weight: bold; font-size: 20px" face="Helvetica">2017</font>
							</td>
							<td width="17%" style="border-left: 2px solid black;">
								OMB No. 1545-2246
							</td>
						</tr>
						<tr>
							<td style="border-right: 2px solid black; border-bottom: 2px solid black">
								Department of the Treasury Internal Revenue Service
							</td>
							<td style="border-bottom: 2px solid black">
								Information about Form 1042-S and its separate instructions is at <a href="javascript:void(0)" onclick="window.open('http://www.irs.gov/form1024s')">www.irs.gov/form1024s</a>.
							</td>
							<td style="border-left: 2px solid black; border-bottom: 2px solid black">
								<font style="font-weight: bold; font-size: 20px" face="Helvetica">Copy E </font>for Withholding Agent 
							</td>
						</tr>
						<tr style="text-align: left;">
							<td colspan="3">
								<table width="100%">
									<tr>
										<td width="44%">
											<label for="REPORT_TYPE_FATCA2">
												Unique Form Identifier <input type="text" class="input-sm form-control" name="F1042S_UNQFORMID" id="F1042S_UNQFORMID" 
												value="<%=formData.get("F1042S_UNQFORMID") != null ? formData.get("F1042S_UNQFORMID") : "" %>"/>
											</label>
										</td>
										<td width="17%">
											<label for="REPORT_TYPE_FATCA4">
												Amended <input type="checkbox" id="F1042S_AMENDEDREPORT_E" name="F1042S_AMENDEDREPORT_E" value="1024S_AMENDED"
												<% if("1024S_AMENDED".equals(formData.get("F1042S_AMENDEDREPORT_E"))){ %> checked="checked" <%} %>/>
											</label>
										</td>
										<td width="49%">
											<label for="REPORT_TYPE_FATCA3">
												Amendment No. <input type="text" class="input-sm form-control" name="F1042S_AMENDMENTNO" id="F1042S_AMENDMENTNO" 
												value="<%=formData.get("F1042S_AMENDMENTNO") != null ? formData.get("F1042S_AMENDMENTNO") : "" %>"/>
											</label>
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
				</div>
			</div>
		</div>
	</div>	
	<div class="section" style="padding: 0 7.5% 0 7.5%; ">
	<div class="col-lg-12">
		<div class="card card-danger" style="margin-bottom: 0; margin-top: 20px;">
			<table class="table">
				<tr>
					<td width="15%">
						1. Income Code
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_INCOMECODE" name="F1042S_INCOMECODE"
						value="<%=formData.get("F1042S_INCOMECODE") != null ? formData.get("F1042S_INCOMECODE") : ""%>"/>
					</td>
					<td width="2%">&nbsp;</td>
					<td width="18%">
						2. Gross Income
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_GROSSINCOME" name="F1042S_GROSSINCOME"
						value="<%=formData.get("F1042S_GROSSINCOME") != null ? formData.get("F1042S_GROSSINCOME") : ""%>"/>
					</td>
					
				</tr>
				<tr>
					<td colspan="5">
						3. Chapter indicator (Enter"3"
							<input type="radio" class="input-sm form-control" id="F1042S_CHAPTER3INDICATOR" name="F1042S_CHAPTERINDICATOR_E" value="3"
							<%if("3".equals(formData.get("F1042S_CHAPTERINDICATOR_E"))){ %> checked="checked" <%} %>/>
							or "4"
							<input type="radio" class="input-sm form-control" id="F1042S_CHAPTER4INDICATOR" name="F1042S_CHAPTERINDICATOR_E" value="4"
							<%if("4".equals(formData.get("F1042S_CHAPTERINDICATOR_E"))){ %> checked="checked" <%} %>/>)
						<table style="width: 100%; id="chapterIndicator3">
							<tr>
								<td width="2%">&nbsp;</td>
								<td width="15%">
									3a. Exemption code 
								</td>
								<td width="30%">
									<input type="text" class="input-sm form-control" id="F1042S_CHAP3_EXEMCODE" name="F1042S_CHAP3_EXEMCODE"
									value="<%=formData.get("F1042S_CHAP3_EXEMCODE") != null ? formData.get("F1042S_CHAP3_EXEMCODE") : ""%>"/>
								</td>
								<td width="2%">&nbsp;</td>
								<td width="18%">
									3b. Tax rate
								</td>
								<td width="30%">
									<input type="text" class="input-sm form-control" id="F1042S_CHAP3_TAXRATE" name="F1042S_CHAP3_TAXRATE"
									value="<%=formData.get("F1042S_CHAP3_TAXRATE") != null ? formData.get("F1042S_CHAP3_TAXRATE") : ""%>"/>
								</td>
							</tr>
						</table>
						<table>
							<tr>
								<td colspan="6">&nbsp;</td>
							</tr>
						</table>
						<table style="width: 100%; id="chapterIndicator4">
							<tr>
								<td width="2%">&nbsp;</td>
								<td width="15%">
									4a. Exemption code 
								</td>
								<td width="30%">
									<input type="text" class="input-sm form-control" id="F1042S_CHAP4_EXEMCODE" name="F1042S_CHAP4_EXEMCODE"
									value="<%=formData.get("F1042S_CHAP4_EXEMCODE") != null ? formData.get("F1042S_CHAP4_EXEMCODE") : ""%>"/>
								</td>
								<td width="2%">&nbsp;</td>
								<td width="18%">
									4b. Tax rate
								</td>
								<td width="30%">
									<input type="text" class="input-sm form-control" id="F1042S_CHAP4_TAXRATE" name="F1042S_CHAP4_TAXRATE"
									value="<%=formData.get("F1042S_CHAP4_TAXRATE") != null ? formData.get("F1042S_CHAP4_TAXRATE") : ""%>"/>
								</td>
							</tr>
						</table>
					</td>					
				</tr>
				<tr>
					<td width="15%">
						5. Withholding allowance
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_WITHHOLD_ALLOWANCE" name="F1042S_WITHHOLD_ALLOWANCE"
						value="<%=formData.get("F1042S_WITHHOLD_ALLOWANCE") != null ? formData.get("F1042S_WITHHOLD_ALLOWANCE") : ""%>"/>
					</td>
					<td width="2%">&nbsp;</td>
					<td width="18%">
						6. Net income
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_NETINCOME" name="F1042S_NETINCOME"
						value="<%=formData.get("F1042S_NETINCOME") != null ? formData.get("F1042S_NETINCOME") : ""%>"/>
					</td>
				</tr>
				<tr>
					<td width="15%">
						7a. Federal tax withheld
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_FEDERALTAX_WITHHELD" name="F1042S_FEDERALTAX_WITHHELD"
						value="<%=formData.get("F1042S_FEDERALTAX_WITHHELD") != null ? formData.get("F1042S_FEDERALTAX_WITHHELD") : ""%>"/>
					</td>
					<td width="2%">&nbsp;</td>
					<td colspan="2">
						7b.  Check if tax not deposited with IRS pursuant to escrow procedure&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<input type="checkbox" class="input-sm form-control" id="F1042S_NOTAX_DEPOSIT" name="F1042S_NOTAX_DEPOSIT_E" value="NOTAX_DEPOSITED" 
						 <% if("NOTAX_DEPOSITED".equals(formData.get("F1042S_NOTAX_DEPOSIT"))){ %> checked="checked" <%} %>/>
					</td>
				</tr>
				<tr>
					<td width="15%">
						8. Tax withheld by other agents 
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_WITHHELD_OTHERAGENT" name="F1042S_WITHHELD_OTHERAGENT"
						value="<%=formData.get("F1042S_WITHHELD_OTHERAGENT") != null ? formData.get("F1042S_WITHHELD_OTHERAGENT") : ""%>"/>
					</td>
					<td width="2%">&nbsp;</td>
					<td width="18%">
						9. Tax paid by withholding agent 
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_WITHHOLDAGENT_TAX" name="F1042S_WITHHOLDAGENT_TAX"
						value="<%=formData.get("F1042S_WITHHOLDAGENT_TAX") != null ? formData.get("F1042S_WITHHOLDAGENT_TAX") : ""%>"/>
					</td>
				</tr>
				<tr>
					<td width="15%">
						10. Total withholding credit
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_TOTALWITHHOLD_CREDIT" name="F1042S_TOTALWITHHOLD_CREDIT"
						value="<%=formData.get("F1042S_TOTALWITHHOLD_CREDIT") != null ? formData.get("F1042S_TOTALWITHHOLD_CREDIT") : ""%>"/>
					</td>
					<td width="2%">&nbsp;</td>
					<td width="18%">
						11. Amount repaid to recipient
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_RECIPIENT_REPAIDAMT" name="F1042S_RECIPIENT_REPAIDAMT"
						value="<%=formData.get("F1042S_RECIPIENT_REPAIDAMT") != null ? formData.get("F1042S_RECIPIENT_REPAIDAMT") : ""%>"/>
					</td>
				</tr>
				<tr>
					<td width="15%">
						12a. Withholding agent's EIN
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_WITHHOLDAGENT_EIN" name="F1042S_WITHHOLDAGENT_EIN"
						value="<%=formData.get("F1042S_WITHHOLDAGENT_EIN") != null ? formData.get("F1042S_WITHHOLDAGENT_EIN") : ""%>"/>
					</td>
					<td width="2%">&nbsp;</td>
					<td width="18%">
						12b. Ch.3 status code
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_CH3STATUSCODE_WITHHOLD" name="F1042S_CH3STATUSCODE_WITHHOLD"
						value="<%=formData.get("F1042S_CH3STATUSCODE_WITHHOLD") != null ? formData.get("F1042S_CH3STATUSCODE_WITHHOLD") : ""%>"/>
					</td>
				</tr>
				<tr>
					<td width="15%">
						12c. Ch.4 status code
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_CH4STATUSCODE_WITHHOLD" name="F1042S_CH4STATUSCODE_WITHHOLD"
						value="<%=formData.get("F1042S_CH4STATUSCODE_WITHHOLD") != null ? formData.get("F1042S_CH4STATUSCODE_WITHHOLD") : ""%>"/>
					</td>
					<td width="2%">&nbsp;</td>
					<td width="18%">
						12d. Withholding agent's name 
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_WITHHOLDAGENT_NAME" name="F1042S_WITHHOLDAGENT_NAME"
						value="<%=formData.get("F1042S_WITHHOLDAGENT_NAME") != null ? formData.get("F1042S_WITHHOLDAGENT_NAME") : ""%>"/>
					</td>
				</tr>
				<tr>
					<td colspan="3">
						12e.  Withholding agent's Global Intermediary Identification Number (GIIN)
					</td>
					<td colspan="2" >
						<input type="text" class="input-sm form-control" id="F1042S_WITHHOLDAGENT_GIIN" name="F1042S_WITHHOLDAGENT_GIIN"
						value="<%=formData.get("F1042S_WITHHOLDAGENT_GIIN") != null ? formData.get("F1042S_WITHHOLDAGENT_GIIN") : ""%>"/>
					</td>
				</tr>
				<tr>
					<td width="15%">
						12f. Country code
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_WITHHOLD_COUNTRYCODE" name="F1042S_WITHHOLD_COUNTRYCODE"
						value="<%=formData.get("F1042S_WITHHOLD_COUNTRYCODE") != null ? formData.get("F1042S_WITHHOLD_COUNTRYCODE") : ""%>"/>
					</td>
					<td width="2%">&nbsp;</td>
					<td width="18%">
						12g. Foreign taxpayer identification number, if any
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_FOREIGN_TIN" name="F1042S_FOREIGN_TIN"
						value="<%=formData.get("F1042S_FOREIGN_TIN") != null ? formData.get("F1042S_FOREIGN_TIN") : ""%>"/>
					</td>
				</tr>
				<tr>
					<td width="15%">
						12h. Address (number and street)
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_WITHHOLDAGENT_ADDR1" name="F1042S_WITHHOLDAGENT_ADDR1"
						value="<%=formData.get("F1042S_WITHHOLDAGENT_ADDR1") != null ? formData.get("F1042S_WITHHOLDAGENT_ADDR1") : ""%>"/>
					</td>
					<td width="2%">&nbsp;</td>
					<td width="18%">
						12i. City or town, state or province, country, ZIP or foreign postal code
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_WITHHOLDAGENT_ADDR2" name="F1042S_WITHHOLDAGENT_ADDR2"
						value="<%=formData.get("F1042S_WITHHOLDAGENT_ADDR2") != null ? formData.get("F1042S_WITHHOLDAGENT_ADDR2") : ""%>"/>
					</td>
				</tr>
				<tr>
					<td width="15%">
						13a. Recipient's name
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_RECIPIENT_NAME" name="F1042S_RECIPIENT_NAME"
						value="<%=formData.get("F1042S_RECIPIENT_NAME") != null ? formData.get("F1042S_RECIPIENT_NAME") : ""%>"/>
					</td>
					<td width="2%">&nbsp;</td>
					<td width="18%">
						13b. Recipient's country code
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_RECIPIENT_COUNTRYCODE" name="F1042S_RECIPIENT_COUNTRYCODE"
						value="<%=formData.get("F1042S_RECIPIENT_COUNTRYCODE") != null ? formData.get("F1042S_RECIPIENT_COUNTRYCODE") : ""%>"/>
					</td>
				</tr>
				<tr>
					<td width="15%">
						13c. Address (number and street)
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_RECIPIENT_ADDR1" name="F1042S_RECIPIENT_ADDR1"
						value="<%=formData.get("F1042S_RECIPIENT_ADDR1") != null ? formData.get("F1042S_RECIPIENT_ADDR1") : ""%>"/>
					</td>
					<td width="2%">&nbsp;</td>
					<td width="18%">
						13d. City or town, state or province, country, ZIP or foreign postal code
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_RECIPIENT_ADDR2" name="F1042S_RECIPIENT_ADDR2"
						value="<%=formData.get("F1042S_RECIPIENT_ADDR2") != null ? formData.get("F1042S_RECIPIENT_ADDR2") : ""%>"/>
					</td>
				</tr>
				<tr>
					<td width="15%">
						13e. Recipient's U.S. TIN, if any
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_RECIPIENT_USTIN" name="F1042S_RECIPIENT_USTIN"
						value="<%=formData.get("F1042S_RECIPIENT_USTIN") != null ? formData.get("F1042S_RECIPIENT_USTIN") : ""%>"/>
					</td>
					<td width="2%">&nbsp;</td>
					<td width="18%">
						13f. Ch.3 status code
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_CH3STATUSCODE_RCIPIENT" name="F1042S_CH3STATUSCODE_RCIPIENT"
						value="<%=formData.get("F1042S_CH3STATUSCODE_RCIPIENT") != null ? formData.get("F1042S_CH3STATUSCODE_RCIPIENT") : ""%>"/>
					</td>
				</tr>
				<tr>
					<td width="15%">
						13g. Ch.4 status code 
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_CH4STATUSCODE_RCIPIENT" name="F1042S_CH4STATUSCODE_RCIPIENT"
						value="<%=formData.get("F1042S_CH4STATUSCODE_RCIPIENT") != null ? formData.get("F1042S_CH4STATUSCODE_RCIPIENT") : ""%>"/>
					</td>
					<td width="2%">&nbsp;</td>
					<td width="18%">
						13h. Recipient's GIIN
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_RECIPIENT_GIIN" name="F1042S_RECIPIENT_GIIN"
						value="<%=formData.get("F1042S_RECIPIENT_GIIN") != null ? formData.get("F1042S_RECIPIENT_GIIN") : ""%>"/>
					</td>
				</tr>
				<tr>
					<td width="15%">
						13i. Recipient's foreign tax identification number, if any
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_RECIPIENT_FTIN" name="F1042S_RECIPIENT_FTIN"
						value="<%=formData.get("F1042S_RECIPIENT_FTIN") != null ? formData.get("F1042S_RECIPIENT_FTIN") : ""%>"/>
					</td>
					<td width="2%">&nbsp;</td>
					<td width="18%">
						13j. LOB code 
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_RECIPIENT_LOBCODE" name="F1042S_RECIPIENT_LOBCODE"
						value="<%=formData.get("F1042S_RECIPIENT_LOBCODE") != null ? formData.get("F1042S_RECIPIENT_LOBCODE") : ""%>"/>
					</td>
				</tr>
				<tr>
					<td width="15%">
						13k. Recipient's account number
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_RECIPIENT_ACCNO" name="F1042S_RECIPIENT_ACCNO"
						value="<%=formData.get("F1042S_RECIPIENT_ACCNO") != null ? formData.get("F1042S_RECIPIENT_ACCNO") : ""%>"/>
					</td>
					<td width="2%">&nbsp;</td>
					<td width="18%">
						13l. Recipient's date of birth 
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_RECIPIENT_DOB" name="F1042S_RECIPIENT_DOB"
						value="<%=formData.get("F1042S_RECIPIENT_DOB") != null ? formData.get("F1042S_RECIPIENT_DOB") : ""%>"/>
					</td>
				</tr>
				<tr>
					<td width="15%">
						14a. Primary Withholding Agent's Name (if applicable)
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_PRIWHAGENT_NAME" name="F1042S_PRIWHAGENT_NAME"
						value="<%=formData.get("F1042S_PRIWHAGENT_NAME") != null ? formData.get("F1042S_PRIWHAGENT_NAME") : ""%>"/>
					</td>
					<td width="2%">&nbsp;</td>
					<td width="18%">
						14b. Primary Withholding Agent's EIN
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_PRIWHAGENT_EIN" name="F1042S_PRIWHAGENT_EIN"
						value="<%=formData.get("F1042S_PRIWHAGENT_EIN") != null ? formData.get("F1042S_PRIWHAGENT_EIN") : ""%>"/>
					</td>
				</tr>
				<tr>
					<td colspan="2">
						15. Check if pro-rata basis reporting&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<input type="checkbox" class="input-sm form-control" id="F1042S_PRORATA" name="F1042S_PRORATA_E" value="PRORATA" 
						 <% if("PRORATA".equals(formData.get("F1042S_PRORATA"))){ %> checked="checked" <%} %>/>
					</td>
					<td width="2%">&nbsp;</td>
					<td width="18%">
						15a. Intermediary or flow-through entity's EIN, if any
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_INTERMED_EIN" name="F1042S_INTERMED_EIN"
						value="<%=formData.get("F1042S_INTERMED_EIN") != null ? formData.get("F1042S_INTERMED_EIN") : ""%>"/>
					</td>
				</tr>
				<tr>
					<td width="15%">
						15b. Ch.3 status code
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_CH3STATUSCODE_INTERMED" name="F1042S_CH3STATUSCODE_INTERMED"
						value="<%=formData.get("F1042S_CH3STATUSCODE_INTERMED") != null ? formData.get("F1042S_CH3STATUSCODE_INTERMED") : ""%>"/>
					</td>
					<td width="2%">&nbsp;</td>
					<td width="18%">
						15c. Ch.4 status code 
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_CH4STATUSCODE_INTERMED" name="F1042S_CH4STATUSCODE_INTERMED"
						value="<%=formData.get("F1042S_CH4STATUSCODE_INTERMED") != null ? formData.get("F1042S_CH4STATUSCODE_INTERMED") : ""%>"/>
					</td>
				</tr>
				<tr>
					<td width="15%">
						15d. Intermediary or flow-through entity's name 
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_INTERMED_ENTITYNAME" name="F1042S_INTERMED_ENTITYNAME"
						value="<%=formData.get("F1042S_INTERMED_ENTITYNAME") != null ? formData.get("F1042S_INTERMED_ENTITYNAME") : ""%>"/>
					</td>
					<td width="2%">&nbsp;</td>
					<td width="18%">
						15e. Intermediary or flow-through entity's GIIN 
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_INTERMED_GIIN" name="F1042S_INTERMED_GIIN"
						value="<%=formData.get("F1042S_INTERMED_GIIN") != null ? formData.get("F1042S_INTERMED_GIIN") : ""%>"/>
					</td>
				</tr>
				<tr>
					<td width="15%">
						15f. Country code
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_INTERMED_COUNTRYCODE" name="F1042S_INTERMED_COUNTRYCODE"
						value="<%=formData.get("F1042S_INTERMED_COUNTRYCODE") != null ? formData.get("F1042S_INTERMED_COUNTRYCODE") : ""%>"/>
					</td>
					<td width="2%">&nbsp;</td>
					<td width="18%">
						15g. Foreign tax identification number, if any 
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_INTERMED_FTIN" name="F1042S_INTERMED_FTIN"
						value="<%=formData.get("F1042S_INTERMED_FTIN") != null ? formData.get("F1042S_INTERMED_FTIN") : ""%>"/>
					</td>
				</tr>
				<tr>
					<td width="15%">
						15h. Address (number and street)
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_INTERMED_ADDR1" name="F1042S_INTERMED_ADDR1"
						value="<%=formData.get("F1042S_INTERMED_ADDR1") != null ? formData.get("F1042S_INTERMED_ADDR1") : ""%>"/>
					</td>
					<td width="2%">&nbsp;</td>
					<td width="18%">
						15i. City or town, state or province, country, ZIP or foreign postal code
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_INTERMED_ADDR2" name="F1042S_INTERMED_ADDR2"
						value="<%=formData.get("F1042S_INTERMED_ADDR2") != null ? formData.get("F1042S_INTERMED_ADDR2") : ""%>"/>
					</td>
				</tr>
				<tr>
					<td width="15%">
						16a. Payer's name
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_PAYER_NAME" name="F1042S_PAYER_NAME"
						value="<%=formData.get("F1042S_PAYER_NAME") != null ? formData.get("F1042S_PAYER_NAME") : ""%>"/>
					</td>
					<td width="2%">&nbsp;</td>
					<td width="18%">
						16b. Payer's TIN
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_PAYER_TIN" name="F1042S_PAYER_TIN"
						value="<%=formData.get("F1042S_PAYER_TIN") != null ? formData.get("F1042S_PAYER_TIN") : ""%>"/>
					</td>
				</tr>
				<tr>
					<td width="15%">
						16c. Payer's GIIN
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_PAYER_GIIN" name="F1042S_PAYER_GIIN"
						value="<%=formData.get("F1042S_PAYER_GIIN") != null ? formData.get("F1042S_PAYER_GIIN") : ""%>"/>
					</td>
					<td width="2%">&nbsp;</td>
					<td width="18%">
						16d. Ch.3 status code
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_CH3STATUSCODE_PAYER" name="F1042S_CH3STATUSCODE_PAYER"
						value="<%=formData.get("F1042S_CH3STATUSCODE_PAYER") != null ? formData.get("F1042S_CH3STATUSCODE_PAYER") : ""%>"/>
					</td>
				</tr>
				<tr>
					<td width="15%">
						16e. Ch. 4 status code
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_CH4STATUSCODE_PAYER" name="F1042S_CH4STATUSCODE_PAYER"
						value="<%=formData.get("F1042S_CH4STATUSCODE_PAYER") != null ? formData.get("F1042S_CH4STATUSCODE_PAYER") : ""%>"/>
					</td>
					<td width="2%">&nbsp;</td>
					<td width="18%">
						17a. State income tax withheld
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_STATEINCTAX_WITHHELD" name="F1042S_STATEINCTAX_WITHHELD"
						value="<%=formData.get("F1042S_STATEINCTAX_WITHHELD") != null ? formData.get("F1042S_STATEINCTAX_WITHHELD") : ""%>"/>
					</td>
				</tr>
				<tr>
					<td width="15%">
						17b. Payer's state tax no.
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_PAYER_STATETAXNO" name="F1042S_PAYER_STATETAXNO"
						value="<%=formData.get("F1042S_PAYER_STATETAXNO") != null ? formData.get("F1042S_PAYER_STATETAXNO") : ""%>"/>
					</td>
					<td width="2%">&nbsp;</td>
					<td width="18%">
						17c. Name of state
					</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" id="F1042S_PAYER_STATENAME" name="F1042S_PAYER_STATENAME"
						value="<%=formData.get("F1042S_PAYER_STATENAME") != null ? formData.get("F1042S_PAYER_STATENAME") : ""%>"/>
					</td>
				</tr>
			</table>
		</div>
		<div>
			<table>
				<tr>
					<td width="65%">&nbsp;</td>
					<td width="15%">&nbsp;</td>
					<td width="20%">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Form <font style="font-weight: bold;">1042-S</font> (2017)</td>
				</tr>
			</table>
			</div>			
		</div>
	</div>
	<!-- COPY E ENDING -->
	<div class="section" style="padding: 15px 7.5% 0 7.5%; text-align: center;">
		<div class="col-lg-12">
			<div class="card card-danger" style="padding: 5px 0; margin-top: 20px;">
				<button class="btn btn-primary btn-sm" type="button" id="saveFATCA1042SForm">Save</button>
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