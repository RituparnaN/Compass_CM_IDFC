<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="java.util.*, com.quantumdataengines.app.compass.model.AOFDisabledFiledsMap"%>
<%
	String contextPath = request.getContextPath() == null ? "" : request.getContextPath();
	String userID = request.getAttribute("userID") != null ? (String) request.getAttribute("userID") : "";
	String cifNo = (String) request.getAttribute("CIF");
	String accountNo = (String) request.getAttribute("AccountNo");
	String caseNo = (String) request.getAttribute("caseNo");
	String canEdit = (String) request.getAttribute("canEdit");
	String MESSAGE = (String) request.getAttribute("MESSAGE");
	
	Map<String, String> accountData = request.getAttribute("accountData") != null ? (Map<String, String>) request.getAttribute("accountData") : new HashMap<String, String>();
	Map<String, String> FORMSTATUS = request.getAttribute("FORMSTATUS") != null ? (Map<String, String>) request.getAttribute("FORMSTATUS") : new HashMap<String, String>();
	List<Map<String, String>> jointHolder = request.getAttribute("JOINT_HOLDER") != null ? (List<Map<String, String>>) request.getAttribute("JOINT_HOLDER") : new ArrayList<Map<String, String>>();
%>
<style>
	.red{
		color: #E77471;
	}
	.bacred{
		background: #FFCCCC;
	}
	.section{
		width: 100%;
		margin: 2px 0 10px 0;
		border: 1px solid #000000;
	}
	.sectionHeader{
		background: gray;
		color: #FFFFFF;
		font-weight: bold;
		font-size: 15px;
		padding: 2px;
		height: 30px;
	}
	.sectionHeaderRej{
		background: red;
		color: #FFFFFF;
		font-weight: bold;
		font-size: 15px;
		padding: 2px;
		height: 30px;
	}
	.sectionBody{
		padding: 3px;
	}
	.sectionFooter{
		background: gray;
		padding-left: 70%;
		padding-right: 5%;
	}
	ul.inlineUL{
		line-height: 0px;
		margin-bottom: 0px;
		list-style-type: none;
	}
	ul.inlineUL li{
		display: inline;
		padding: 0 5px;
		line-height: 0px;
		margin-bottom: 3px;
	}
	.datepicker{
		background-image:url("<%=contextPath%>/images/calendar.png");
		background-repeat:no-repeat;
		background-position: 98%;
	}
	input[type=text]{		
		margin: 2px 0;
	}
	select{		
		margin: 2px 0;
	}
	input[type=text].input-ovr {
		text-align: justify;
		padding:2px 5px;
		height: 28px;
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
	#accountHolderDetails{
		overflow: auto;
	}
	#informationPanel{
		overflow: auto;
		margin-top: 2px;
	}
	
	.nav-tabs{
	  background-color: #ACBAE6;
	}
	
	.nav-tabs > li > a{
	  color: #191970 !important;
	}
	
	.nav-tabs > li > a:hover{
	  color: #4B0082 !important;
	}
	
	.fullWidthTable{
		width: 100%;
	}
	
	.card-header{
		font-size: 13px;
		padding: 3px 5px;
		line-height: 20px; 
	}

.fullWidthTable {
	width: 100%;
}
</style>
<script type="text/javascript">
	$(document).ready(function() {
		
		var MESSAGE = '<%=MESSAGE%>';
		if(MESSAGE != '' && MESSAGE.length > 0){
			alert(MESSAGE);
		}
		
		$(".datepicker").datepicker({
			dateFormat : "dd/mm/yy",
			changeMonth : true,
			changeYear : true
		});
		
		$(".valueAddedServiceModal").click(function(){
			$("#vas-modal-title").html("...");
			$("#valueAddedServiceDetails").html("");
			$('#valueAddedServiceModal').modal('show');
			
			var cifNumber = $(this).attr("cCIF");
			var cifAccountNo = $(this).attr("cAccountNo");
			var lineNo = $(this).attr("cLineNo");
			var caseNo = '<%=caseNo%>';
			var canEdit = '<%=canEdit%>';
			
			$.ajax({
				type : "GET",
				url : "<%=contextPath%>/addValueAddedService?CIF="+cifNumber+"&AccountNo="+cifAccountNo+"&LineNo="+lineNo+"&caseNo="+caseNo+"&canEdit="+canEdit,
				cache : false,
				success : function(res){
					$("#vas-modal-title").html("VALUE ADDED SERVICE");
					$("#valueAddedServiceDetails").html(res);
				},
				error : function(){
					$('#valueAddedServiceModal').modal('hide');
					alert("error");
				}
			});
		});
		
		$("#aof_saveAccountDetails").submit(function(e){
			var formObj = $(this);
			var formData = $(formObj).serialize();
			$.ajax({
				url : '<%=contextPath%>/cpumaker/saveAccountDetails',
				type : "POST",
				data : formData,
				cache : false,
				success : function(res){
					alert(res);
				},
				error : function(a,b,c){
					alert("error"+a+b+c);
				}
			});
			e.preventDefault();
		});
	});
	
	function forceCheck(elm, chkVal){
		if(chkVal != 'null'){
			$("input[name="+elm.name+"][value="+chkVal+"]").prop("checked", "checked");
		}
		return false;
	}
	
	function forceCheckSelect(elm, chkVal){
		if(chkVal != 'null'){
			$("select[name="+elm.name+"] > option[value="+chkVal+"]").attr("selected", "selected");
		}else{
			$("select[name="+elm.name+"] > option[value='']").attr("selected", "selected");
		}
		return false;
	}
</script>
</head>
<body>
<div class="modal fade bs-example-modal-sm" id="valueAddedServiceModal" tabindex="2" role="dialog" aria-labelledby="myLargeModalLabel">
  <div class="modal-dialog modal-lg">
    <div class="modal-content card-primary">
      <div class="modal-header card-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
        <span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="vas-modal-title">...</h4>
      </div>
	  <div class="modal-body" id="valueAddedServiceDetails">
      	Loading...
      </div>
    </div>
  </div>
</div>
<form action="javascript:void(0)" id="aof_saveAccountDetails" method="POST">
	<input type="hidden" value="<%=cifNo%>" name="CIF_NO" /> 
	<input type="hidden" value="<%=accountNo%>" name="ACCOUNT_NO" /> 
	<input type="hidden" value="<%=caseNo%>" name="CASE_NO" />
	<div class="section">
		<div class="sectionHeader">ACCOUNT TYPE</div>
		<div class="sectionBody">
		<table width="100%">
		<tr>
			<td>
				<table>
					<tr>
						<td>
							<input type="radio" name="typeOfAccount2" id="typeOfAccount21" value="C" <%if ("C".equals(accountData.get("ACCOUNT_TYPE_CODE"))) {%> checked="checked" <%}%>
							<%if (AOFDisabledFiledsMap.isFieldDisabled("ACCOUNT_TYPE_CODE")) {%>
								onclick="return forceCheck(this,'<%=accountData.get("ACCOUNT_TYPE_CODE")%>')"
							<%}%>> 
							<label for="typeOfAccount21" <%if (AOFDisabledFiledsMap.isFieldDisabled("ACCOUNT_TYPE_CODE")) {%> class="red" <%}%>>Current&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>
						</td>
						<td>
							<input type="radio" name="typeOfAccount2" id="typeOfAccount22" value="S" <%if ("S".equals(accountData.get("ACCOUNT_TYPE_CODE"))) {%> checked="checked" <%}%>
							<%if (AOFDisabledFiledsMap.isFieldDisabled("ACCOUNT_TYPE_CODE")) {%>
								onclick="return forceCheck(this,'<%=accountData.get("ACCOUNT_TYPE_CODE")%>')"
							<%}%>> 
							<label for="typeOfAccount22" <%if (AOFDisabledFiledsMap.isFieldDisabled("ACCOUNT_TYPE_CODE")) {%> class="red" <%}%>>Savings&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>
						</td>
						<td>
							<input type="radio" name="typeOfAccount2" id="typeOfAccount23" value="TI" <%if ("TI".equals(accountData.get("ACCOUNT_TYPE_CODE"))) {%> checked="checked" <%}%>
							<%if (AOFDisabledFiledsMap.isFieldDisabled("ACCOUNT_TYPE_CODE")) {%>
								onclick="return forceCheck(this,'<%=accountData.get("ACCOUNT_TYPE_CODE")%>')"
							<%}%>> 
							<label for="typeOfAccount23" <%if (AOFDisabledFiledsMap.isFieldDisabled("ACCOUNT_TYPE_CODE")) {%> class="red" <%}%>>Term Investment&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>
						</td>
						<td>
							<input type="radio" name="typeOfAccount2" id="typeOfAccount24" value="OT" <%if ("OT".equals(accountData.get("ACCOUNT_TYPE_CODE"))) {%> checked="checked" <%}%>
							<%if (AOFDisabledFiledsMap.isFieldDisabled("ACCOUNT_TYPE_CODE")) {%>
								onclick="return forceCheck(this,'<%=accountData.get("ACCOUNT_TYPE_CODE")%>')"
							<%}%>> 
							<label for="typeOfAccount24" <%if (AOFDisabledFiledsMap.isFieldDisabled("ACCOUNT_TYPE_CODE")) {%> class="red" <%}%>> 
								Other: <input type="text" name="typeOfAccount2Other" 
								<%if (AOFDisabledFiledsMap.isFieldDisabled("ACCOUNT_TYPE_CODE")) {%>
									readonly="readonly" class="input-ovr bacred" 
								<%} else {%>
								class="input-ovr" 
								<%}%>
								<%if ("OT".equals(accountData.get("ACCOUNT_TYPE_CODE"))) {%> value="<%=accountData.get("PRODUCT_NAME") != null ? accountData.get("PRODUCT_NAME") : ""%>"
								<%}%> />
						</label></td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td>
				<table width="100%">
					<tr>
						<td width="25%">&nbsp;</td>
						<td width="25%">&nbsp;</td>
						<td width="25%">&nbsp;</td>
						<td width="25%">&nbsp;</td>
					</tr>
					<tr>
						<td colspan="1" <%if (AOFDisabledFiledsMap.isFieldDisabled("GL_CODE")) {%> class="red" <%}%>>GL CODE</td>
						<td colspan="3">
							<input type="text" name="gl_code" class="input-ovr" value="<%=accountData.get("GL_CODE") != null ? accountData .get("GL_CODE") : ""%>"
							<%if (AOFDisabledFiledsMap.isFieldDisabled("GL_CODE")) {%>
							readonly="readonly" <%}%> />
						</td>
					</tr>
					<tr>
						<td colspan="1" <%if (AOFDisabledFiledsMap.isFieldDisabled("ACCOUNT_CURRENCY")) {%> class="red" <%}%>>Account Currency Code &amp; Name:</td>
						<td colspan="3">
							<input type="text" name="foreignCurrency" class="input-ovr" value="<%=accountData.get("ACCOUNT_CURRENCY") != null ? accountData.get("ACCOUNT_CURRENCY") : ""%>"
							<%if (AOFDisabledFiledsMap.isFieldDisabled("ACCOUNT_CURRENCY")) {%>
							readonly="readonly" <%}%>> 
							<%=accountData.get("CURRENCY_NAME") != null ? accountData.get("CURRENCY_NAME") : ""%>
						</td>
					</tr>
					<tr>
						<td>
							<input type="radio" name="typeOfAccount3" id="typeOfAccount31" value="RFC" <%if ("RFC".equals(accountData.get("SPECIAL_ACC_TYPE"))) {%> checked="checked" <%}%>
							<%if (AOFDisabledFiledsMap.isFieldDisabled("SPECIAL_ACC_TYPE")) {%>
								onclick="return forceCheck(this,'<%=accountData.get("SPECIAL_ACC_TYPE")%>')"
							<%}%>> 
							<label <%if (AOFDisabledFiledsMap.isFieldDisabled("SPECIAL_ACC_TYPE")) {%> class="red" <%}%> for="typeOfAccount31">RFC&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>
						</td>
						<td>
							<input type="radio" name="typeOfAccount3" id="typeOfAccount32" value="FEEA" <%if ("FEEA".equals(accountData.get("SPECIAL_ACC_TYPE"))) {%> checked="checked" <%}%>
							<%if (AOFDisabledFiledsMap.isFieldDisabled("SPECIAL_ACC_TYPE")) {%>
								onclick="return forceCheck(this,'<%=accountData.get("SPECIAL_ACC_TYPE")%>')"
							<%}%>> 
							<label <%if (AOFDisabledFiledsMap.isFieldDisabled("SPECIAL_ACC_TYPE")) {%> class="red" <%}%> for="typeOfAccount32">FEEA&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>
						</td>
						<td>
							<input type="radio" name="typeOfAccount3" id="typeOfAccount33" value="FCAISPE" <%if ("FCAISPE".equals(accountData.get("SPECIAL_ACC_TYPE"))) {%> checked="checked" <%}%>
							<%if (AOFDisabledFiledsMap.isFieldDisabled("SPECIAL_ACC_TYPE")) {%>
								onclick="return forceCheck(this,'<%=accountData.get("SPECIAL_ACC_TYPE")%>')"
							<%}%>> 
							<label <%if (AOFDisabledFiledsMap.isFieldDisabled("SPECIAL_ACC_TYPE")) {%> class="red" <%}%> for="typeOfAccount33">FCAISPE&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>
						</td>
						<td>
							<input type="radio" name="typeOfAccount3" id="typeOfAccount34" value="OIA" <%if ("OIA".equals(accountData.get("SPECIAL_ACC_TYPE"))) {%> checked="checked" <%}%>
							<%if (AOFDisabledFiledsMap.isFieldDisabled("SPECIAL_ACC_TYPE")) {%>
							onclick="return forceCheck(this,'<%=accountData.get("SPECIAL_ACC_TYPE")%>')"
							<%}%>> 
							<label <%if (AOFDisabledFiledsMap.isFieldDisabled("SPECIAL_ACC_TYPE")) {%> class="red" <%}%> for="typeOfAccount34">OIA&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>
						</td>
					</tr>
					<tr>
						<td>
							<input type="radio" name="typeOfAccount3" id="typeOfAccount35" value="RNNFC" <%if ("RNNFC".equals(accountData.get("SPECIAL_ACC_TYPE"))) {%> checked="checked" <%}%>
							<%if (AOFDisabledFiledsMap.isFieldDisabled("SPECIAL_ACC_TYPE")) {%>
								onclick="return forceCheck(this,'<%=accountData.get("SPECIAL_ACC_TYPE")%>')"
							<%}%>> 
							<label <%if (AOFDisabledFiledsMap.isFieldDisabled("SPECIAL_ACC_TYPE")) {%> class="red" <%}%> for="typeOfAccount35">RNNFC&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>
						</td>
						<td>
							<input type="radio" name="typeOfAccount3" id="typeOfAccount36" value="FCAASA" <%if ("FCAASA".equals(accountData.get("SPECIAL_ACC_TYPE"))) {%> checked="checked" <%}%>
							<%if (AOFDisabledFiledsMap.isFieldDisabled("SPECIAL_ACC_TYPE")) {%>
								onclick="return forceCheck(this,'<%=accountData.get("SPECIAL_ACC_TYPE")%>')"
							<%}%>> 
							<label <%if (AOFDisabledFiledsMap.isFieldDisabled("SPECIAL_ACC_TYPE")) {%> class="red" <%}%> for="typeOfAccount36">FCAASA&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>
						</td>
						<td>
							<input type="radio" name="typeOfAccount3" id="typeOfAccount37" value="IRDA" <%if ("IRDA".equals(accountData.get("SPECIAL_ACC_TYPE"))) {%> checked="checked" <%}%>
							<%if (AOFDisabledFiledsMap.isFieldDisabled("SPECIAL_ACC_TYPE")) {%>
								onclick="return forceCheck(this,'<%=accountData.get("SPECIAL_ACC_TYPE")%>')"
							<%}%>> 
							<label <%if (AOFDisabledFiledsMap.isFieldDisabled("SPECIAL_ACC_TYPE")) {%> class="red" <%}%> for="typeOfAccount37">IRDA&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>
						</td>
						<td>
							<input type="radio" name="typeOfAccount3" id="typeOfAccount38" value="PITRA" <%if ("PITRA".equals(accountData.get("SPECIAL_ACC_TYPE"))) {%> checked="checked" <%}%>
							<%if (AOFDisabledFiledsMap.isFieldDisabled("SPECIAL_ACC_TYPE")) {%>
								onclick="return forceCheck(this,'<%=accountData.get("SPECIAL_ACC_TYPE")%>')"
							<%}%>> 
							<label <%if (AOFDisabledFiledsMap.isFieldDisabled("SPECIAL_ACC_TYPE")) {%> class="red" <%}%> for="typeOfAccount38">PITRA&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>
						</td>
					</tr>
					<tr>
						<td><input type="radio" name="typeOfAccount3" id="typeOfAccount39" value="SFNFDA" <%if ("SFNFDA".equals(accountData.get("SPECIAL_ACC_TYPE"))) {%> checked="checked" <%}%>
							<%if (AOFDisabledFiledsMap.isFieldDisabled("SPECIAL_ACC_TYPE")) {%>
								onclick="return forceCheck(this,'<%=accountData.get("SPECIAL_ACC_TYPE")%>')"
							<%}%>> 
							<label <%if (AOFDisabledFiledsMap.isFieldDisabled("SPECIAL_ACC_TYPE")) {%> class="red" <%}%> for="typeOfAccount39">SFNFDA&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>
						</td>
						<td><input type="radio" name="typeOfAccount3" id="typeOfAccount310" value="SFNRA" <%if ("SFNRA".equals(accountData.get("SPECIAL_ACC_TYPE"))) {%> checked="checked" <%}%>
							<%if (AOFDisabledFiledsMap.isFieldDisabled("SPECIAL_ACC_TYPE")) {%>
							onclick="return forceCheck(this,'<%=accountData.get("SPECIAL_ACC_TYPE")%>')"
							<%}%>> 
							<label <%if (AOFDisabledFiledsMap.isFieldDisabled("SPECIAL_ACC_TYPE")) {%> class="red" <%}%> for="typeOfAccount310">SFNRA&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>
						</td>
						<td><input type="radio" name="typeOfAccount3" id="typeOfAccount311" value="MBA" <%if ("MBA".equals(accountData.get("SPECIAL_ACC_TYPE"))) {%> checked="checked" <%}%>
							<%if (AOFDisabledFiledsMap.isFieldDisabled("SPECIAL_ACC_TYPE")) {%>
								onclick="return forceCheck(this,'<%=accountData.get("SPECIAL_ACC_TYPE")%>')"
							<%}%>> 
							<label <%if (AOFDisabledFiledsMap.isFieldDisabled("SPECIAL_ACC_TYPE")) {%> class="red" <%}%> for="typeOfAccount311">MBA&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>
						</td>
						<td><input type="radio" name="typeOfAccount3" id="typeOfAccount312" value="NRBA" <%if ("NRBA".equals(accountData.get("SPECIAL_ACC_TYPE"))) {%> checked="checked" <%}%>
							<%if (AOFDisabledFiledsMap.isFieldDisabled("SPECIAL_ACC_TYPE")) {%>
								onclick="return forceCheck(this,'<%=accountData.get("SPECIAL_ACC_TYPE")%>')"
							<%}%>> 
							<label <%if (AOFDisabledFiledsMap.isFieldDisabled("SPECIAL_ACC_TYPE")) {%> class="red" <%}%> for="typeOfAccount312">NRBA&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>
						</td>
					</tr>
					<tr>
						<td><input type="radio" name="typeOfAccount3" id="typeOfAccount313" value="NRFC" <%if ("NRFC".equals(accountData.get("SPECIAL_ACC_TYPE"))) {%> checked="checked" <%}%>
							<%if (AOFDisabledFiledsMap.isFieldDisabled("SPECIAL_ACC_TYPE")) {%>
							onclick="return forceCheck(this,'<%=accountData.get("SPECIAL_ACC_TYPE")%>')"
							<%}%>> 
							<label <%if (AOFDisabledFiledsMap.isFieldDisabled("SPECIAL_ACC_TYPE")) {%> class="red" <%}%> for="typeOfAccount313">NRFC&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>
						</td>
						<td><input type="radio" name="typeOfAccount3" id="typeOfAccount314" value="SIA" <%if ("SIA".equals(accountData.get("SPECIAL_ACC_TYPE"))) {%> checked="checked" <%}%>
							<%if (AOFDisabledFiledsMap.isFieldDisabled("SPECIAL_ACC_TYPE")) {%>
							onclick="return forceCheck(this,'<%=accountData.get("SPECIAL_ACC_TYPE")%>')"
							<%}%>> 
							<label <%if (AOFDisabledFiledsMap.isFieldDisabled("SPECIAL_ACC_TYPE")) {%> class="red" <%}%> for="typeOfAccount314">SIA&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>
						</td>
						<td><input type="radio" name="typeOfAccount3" id="typeOfAccount315" value="SFIDA" <%if ("SFIDA".equals(accountData.get("SPECIAL_ACC_TYPE"))) {%> checked="checked" <%}%>
							<%if (AOFDisabledFiledsMap.isFieldDisabled("SPECIAL_ACC_TYPE")) {%>
								onclick="return forceCheck(this,'<%=accountData.get("SPECIAL_ACC_TYPE")%>')"
							<%}%>> 
							<label <%if (AOFDisabledFiledsMap.isFieldDisabled("SPECIAL_ACC_TYPE")) {%> class="red" <%}%> for="typeOfAccount315">SFIDA&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>
						</td>
						<td>
							<input type="radio" name="typeOfAccount3" id="typeOfAccount316" value="NRNNFA" <%if ("NRNNFA".equals(accountData.get("SPECIAL_ACC_TYPE"))) {%> checked="checked" <%}%>
							<%if (AOFDisabledFiledsMap.isFieldDisabled("SPECIAL_ACC_TYPE")) {%>
							onclick="return forceCheck(this,'<%=accountData.get("SPECIAL_ACC_TYPE")%>')"
							<%}%>> 
							<label <%if (AOFDisabledFiledsMap.isFieldDisabled("SPECIAL_ACC_TYPE")) {%> class="red" <%}%> for="typeOfAccount316">NRNNFA&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>
						</td>
					</tr>
					<tr>
						<td><input type="radio" name="typeOfAccount3" id="typeOfAccount317" value="DFA" <%if ("DFA".equals(accountData.get("SPECIAL_ACC_TYPE"))) {%> checked="checked" <%}%>
							<%if (AOFDisabledFiledsMap.isFieldDisabled("SPECIAL_ACC_TYPE")) {%>
								onclick="return forceCheck(this,'<%=accountData.get("SPECIAL_ACC_TYPE")%>')"
							<%}%>> 
							<label <%if (AOFDisabledFiledsMap.isFieldDisabled("SPECIAL_ACC_TYPE")) {%> class="red" <%}%> for="typeOfAccount317">SIA&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>
						</td>
							<td><input type="radio" name="typeOfAccount3" id="typeOfAccount318" value="OBU" <%if ("OBU".equals(accountData.get("SPECIAL_ACC_TYPE"))) {%> checked="checked" <%}%>
							<%if (AOFDisabledFiledsMap.isFieldDisabled("SPECIAL_ACC_TYPE")) {%>
								onclick="return forceCheck(this,'<%=accountData.get("SPECIAL_ACC_TYPE")%>')"
							<%}%>> 
							<label <%if (AOFDisabledFiledsMap.isFieldDisabled("SPECIAL_ACC_TYPE")) {%> class="red" <%}%> for="typeOfAccount318">SFIDA&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>
						</td>
						<td><input type="radio" name="typeOfAccount3" id="typeOfAccount319" value="FCBU" <%if ("FCBU".equals(accountData.get("SPECIAL_ACC_TYPE"))) {%> checked="checked" <%}%>
							<%if (AOFDisabledFiledsMap.isFieldDisabled("SPECIAL_ACC_TYPE")) {%>
								onclick="return forceCheck(this,'<%=accountData.get("SPECIAL_ACC_TYPE")%>')"
							<%}%>> 
							<label <%if (AOFDisabledFiledsMap.isFieldDisabled("SPECIAL_ACC_TYPE")) {%> class="red" <%}%> for="typeOfAccount319">NRNNFA&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>
						</td>
						<td><input type="radio" name="typeOfAccount3" id="typeOfAccount320" value="Other" <%if ("OT".equals(accountData.get("SPECIAL_ACC_TYPE"))) {%> checked="checked" <%}%>
							<%if (AOFDisabledFiledsMap.isFieldDisabled("SPECIAL_ACC_TYPE")) {%>
								onclick="return forceCheck(this,'<%=accountData.get("SPECIAL_ACC_TYPE")%>')"
							<%}%>> 
							<label <%if (AOFDisabledFiledsMap.isFieldDisabled("SPECIAL_ACC_TYPE")) {%> class="red" <%}%> for="typeOfAccount320">
								Other: <input type="text" name="typeOfAccount3Other" <%if (AOFDisabledFiledsMap.isFieldDisabled("SPECIAL_ACC_TYPE")) {%> readonly="readonly" class="input-ovr bacred" 
								<%} else {%>class="input-ovr" <%}%>
								<%if ("OT".equals(accountData.get("SPECIAL_ACC_TYPE"))) {%> value="<%=accountData.get("PRODUCT_NAME") != null ? accountData .get("PRODUCT_NAME") : ""%>"<%}%> />
							</label>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
	</div>
	</div>
	<div class="section">
		<div class="<%if (FORMSTATUS.get("REJECTED_SECTION") != null && FORMSTATUS.get("REJECTED_SECTION").contains("reject_section61"+accountNo)) {%> sectionHeaderRej <%} else {%> sectionHeader <%}%>">
			OTHER INFORMATION</div>
		<div class="sectionBody">
			<table class="table table-bordered">
				<tr>
					<td width="25%">Purpose of Opening Account</td>
					<td width="75%">
						<table width="100%">
							<tr>
								<td width="25%">
									<input type="checkbox" name="PORPOSE_OF_ACCOUNT_SA" id="PORPOSE_OF_ACCOUNT_SA" value="Y" <%if ("Y".equals(accountData.get("PORPOSE_OF_ACCOUNT_SA"))) {%> checked="checked" <%}%>
									<%if (AOFDisabledFiledsMap.isFieldDisabled("PORPOSE_OF_ACCOUNT_SA")) {%>
										onclick="return forceCheck(this,'<%=accountData.get("PORPOSE_OF_ACCOUNT_SA")%>')"
									<%}%>> 
									<label <%if (AOFDisabledFiledsMap.isFieldDisabled("PORPOSE_OF_ACCOUNT_SA")) {%> class="red" <%}%> for="PORPOSE_OF_ACCOUNT_SA">Savings</label>
								</td>
								<td width="25%">
									<input type="checkbox" name="PORPOSE_OF_ACCOUNT_BT" id="PORPOSE_OF_ACCOUNT_BT" value="Y" <%if ("Y".equals(accountData.get("PORPOSE_OF_ACCOUNT_BT"))) {%> checked="checked" <%}%>
									<%if (AOFDisabledFiledsMap.isFieldDisabled("PORPOSE_OF_ACCOUNT_BT")) {%>
									onclick="return forceCheck(this,'<%=accountData.get("PORPOSE_OF_ACCOUNT_BT")%>')"
									<%}%>> 
									<label <%if (AOFDisabledFiledsMap.isFieldDisabled("PORPOSE_OF_ACCOUNT_BT")) {%> class="red" <%}%> for="PORPOSE_OF_ACCOUNT_BT">Business Transaction</label>
								</td>
								<td width="25%">
									<input type="checkbox" name="PORPOSE_OF_ACCOUNT_LR" id="PORPOSE_OF_ACCOUNT_LR" value="Y" <%if ("Y".equals(accountData.get("PORPOSE_OF_ACCOUNT_LR"))) {%> checked="checked" <%}%>
									<%if (AOFDisabledFiledsMap.isFieldDisabled("PORPOSE_OF_ACCOUNT_LR")) {%>
										onclick="return forceCheck(this,'<%=accountData.get("PORPOSE_OF_ACCOUNT_LR")%>')"
									<%}%>> 
									<label <%if (AOFDisabledFiledsMap.isFieldDisabled("PORPOSE_OF_ACCOUNT_LR")) {%> class="red" <%}%> for="PORPOSE_OF_ACCOUNT_LR">Loan Re-payment</label>
								</td>
								<td width="25%">
									<input type="checkbox" name="PORPOSE_OF_ACCOUNT_SCW" id="PORPOSE_OF_ACCOUNT_SCW" value="Y" <%if ("Y".equals(accountData.get("PORPOSE_OF_ACCOUNT_SCW"))) {%> checked="checked" <%}%>
									<%if (AOFDisabledFiledsMap.isFieldDisabled("PORPOSE_OF_ACCOUNT_SCW")) {%>
										onclick="return forceCheck(this,'<%=accountData.get("PORPOSE_OF_ACCOUNT_SCW")%>')"
									<%}%>> 
									<label <%if (AOFDisabledFiledsMap.isFieldDisabled("PORPOSE_OF_ACCOUNT_SCW")) {%> class="red" <%}%> for="PORPOSE_OF_ACCOUNT_SCW">Social Charity Work</label>
								</td>
							</tr>
							<tr>
								<td>
									<input type="checkbox" name="PORPOSE_OF_ACCOUNT_SPI" id="PORPOSE_OF_ACCOUNT_SPI" value="Y" <%if ("Y".equals(accountData.get("PORPOSE_OF_ACCOUNT_SPI"))) {%> checked="checked" <%}%>
									<%if (AOFDisabledFiledsMap.isFieldDisabled("PORPOSE_OF_ACCOUNT_SPI")) {%>
										onclick="return forceCheck(this,'<%=accountData.get("PORPOSE_OF_ACCOUNT_SPI")%>')"
									<%}%>> 
									<label <%if (AOFDisabledFiledsMap.isFieldDisabled("PORPOSE_OF_ACCOUNT_SPI")) {%> class="red" <%}%> for="PORPOSE_OF_ACCOUNT_SPI">Salary Professional Income</label>
								</td>
								<td>
									<input type="checkbox" name="PORPOSE_OF_ACCOUNT_FIR" id="PORPOSE_OF_ACCOUNT_FIR" value="Y" <%if ("Y".equals(accountData.get("PORPOSE_OF_ACCOUNT_FIR"))) {%> checked="checked" <%}%>
									<%if (AOFDisabledFiledsMap.isFieldDisabled("PORPOSE_OF_ACCOUNT_FIR")) {%>
										onclick="return forceCheck(this,'<%=accountData.get("PORPOSE_OF_ACCOUNT_FIR")%>')"
									<%}%>> 
									<label <%if (AOFDisabledFiledsMap.isFieldDisabled("PORPOSE_OF_ACCOUNT_FIR")) {%> class="red" <%}%> for="PORPOSE_OF_ACCOUNT_FIR">Family Inward Remittance</label>
								</td>
								<td>
									<input type="checkbox" name="PORPOSE_OF_ACCOUNT_IP" id="PORPOSE_OF_ACCOUNT_IP" value="Y" <%if ("Y".equals(accountData.get("PORPOSE_OF_ACCOUNT_IP"))) {%> checked="checked" <%}%>
									<%if (AOFDisabledFiledsMap.isFieldDisabled("PORPOSE_OF_ACCOUNT_IP")) {%>
										onclick="return forceCheck(this,'<%=accountData.get("PORPOSE_OF_ACCOUNT_IP")%>')"
									<%}%>> 
									<label <%if (AOFDisabledFiledsMap.isFieldDisabled("PORPOSE_OF_ACCOUNT_IP")) {%> class="red" <%}%> for="PORPOSE_OF_ACCOUNT_IP">Investment Purpose</label>
								</td>
								<td>
									<input type="checkbox" name="PORPOSE_OF_ACCOUNT_ST" id="PORPOSE_OF_ACCOUNT_ST" value="Y" <%if ("Y".equals(accountData.get("PORPOSE_OF_ACCOUNT_ST"))) {%> checked="checked" <%}%>
									<%if (AOFDisabledFiledsMap.isFieldDisabled("PORPOSE_OF_ACCOUNT_ST")) {%>
										onclick="return forceCheck(this,'<%=accountData.get("PORPOSE_OF_ACCOUNT_ST")%>')"
									<%}%>> 
									<label <%if (AOFDisabledFiledsMap.isFieldDisabled("PORPOSE_OF_ACCOUNT_ST")) {%> class="red" <%}%> for="PORPOSE_OF_ACCOUNT_ST">Share Transactions</label>
								</td>
							</tr>
							<tr>
								<td>
									<input type="checkbox" name="PORPOSE_OF_ACCOUNT_UBP" id="PORPOSE_OF_ACCOUNT_UBP" value="Y" <%if ("Y".equals(accountData.get("PORPOSE_OF_ACCOUNT_UBP"))) {%> checked="checked" <%}%>
									<%if (AOFDisabledFiledsMap.isFieldDisabled("PORPOSE_OF_ACCOUNT_UBP")) {%>
										onclick="return forceCheck(this,'<%=accountData.get("PORPOSE_OF_ACCOUNT_UBP")%>')"
									<%}%>> 
									<label <%if (AOFDisabledFiledsMap.isFieldDisabled("PORPOSE_OF_ACCOUNT_UBP")) {%> class="red" <%}%> for="PORPOSE_OF_ACCOUNT_UBP">Utility Bill Payment</label>
								</td>
								<td>
									<input type="checkbox" name="PORPOSE_OF_ACCOUNT_UF" id="PORPOSE_OF_ACCOUNT_UF" value="Y" <%if ("Y".equals(accountData.get("PORPOSE_OF_ACCOUNT_UF"))) {%> checked="checked" <%}%>
									<%if (AOFDisabledFiledsMap.isFieldDisabled("PORPOSE_OF_ACCOUNT_UF")) {%>
										onclick="return forceCheck(this,'<%=accountData.get("PORPOSE_OF_ACCOUNT_UF")%>')"
									<%}%>> 
									<label <%if (AOFDisabledFiledsMap.isFieldDisabled("PORPOSE_OF_ACCOUNT_UF")) {%> class="red" <%}%> for="PORPOSE_OF_ACCOUNT_UF">Upkeep of Family/Person</label>
								</td>
								<td>
									<input type="checkbox" name="PORPOSE_OF_ACCOUNT_OT" id="PORPOSE_OF_ACCOUNT_OT" value="Y" <%if ("Y".equals(accountData.get("PORPOSE_OF_ACCOUNT_OT"))) {%> checked="checked" <%}%>
									<%if (AOFDisabledFiledsMap.isFieldDisabled("PORPOSE_OF_ACCOUNT_OT")) {%>
										onclick="return forceCheck(this,'<%=accountData.get("PORPOSE_OF_ACCOUNT_OT")%>')"
									<%}%>> 
									<label <%if (AOFDisabledFiledsMap.isFieldDisabled("PORPOSE_OF_ACCOUNT_OT")) {%> class="red" <%}%> for="PORPOSE_OF_ACCOUNT_OT"> 
										Other: <input type="text" name="PORPOSE_OF_ACCOUNT_OTR" 
										<%if (AOFDisabledFiledsMap.isFieldDisabled("PORPOSE_OF_ACCOUNT_OT")) {%>
										readonly="readonly" class="input-ovr bacred" 
										<%} else {%>
										class="input-ovr" <%}%>
										<%if ("Y".equals(accountData.get("PORPOSE_OF_ACCOUNT_OT"))) {%>
										value="<%=accountData.get("PORPOSE_OF_ACCOUNT_OTR") != null ? accountData .get("PORPOSE_OF_ACCOUNT_OTR") : ""%>"
										<%}%> />
									</label>
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td>Source of Funds</td>
					<td>
						<table width="100%">
							<tr>
								<td width="25%">
									<input type="checkbox" name="SOURCE_OF_FUND_S" id="SOURCE_OF_FUND_S" value="Y" <%if ("Y".equals(accountData.get("SOURCE_OF_FUND_S"))) {%> checked="checked" <%}%>
									<%if (AOFDisabledFiledsMap.isFieldDisabled("SOURCE_OF_FUND_S")) {%> onclick="return forceCheck(this,'<%=accountData.get("SOURCE_OF_FUND_S")%>')" <%}%>>
									<label <%if (AOFDisabledFiledsMap.isFieldDisabled("SOURCE_OF_FUND_S")) {%> class="red" <%}%> for="SOURCE_OF_FUND_S">Salary</label>
								</td>
								<td width="25%">
									<input type="checkbox" name="SOURCE_OF_FUND_B" id="SOURCE_OF_FUND_B" value="Y" <%if ("Y".equals(accountData.get("SOURCE_OF_FUND_B"))) {%> checked="checked" <%}%>
									<%if (AOFDisabledFiledsMap.isFieldDisabled("SOURCE_OF_FUND_B")) {%> onclick="return forceCheck(this,'<%=accountData.get("SOURCE_OF_FUND_B")%>')"<%}%>> 
									<label <%if (AOFDisabledFiledsMap.isFieldDisabled("SOURCE_OF_FUND_B")) {%> class="red" <%}%> for="SOURCE_OF_FUND_B">Business</label>
								</td>
								<td width="25%">
									<input type="checkbox" name="SOURCE_OF_FUND_FR" id="SOURCE_OF_FUND_FR" value="Y" <%if ("Y".equals(accountData.get("SOURCE_OF_FUND_FR"))) {%> checked="checked" <%}%>
									<%if (AOFDisabledFiledsMap.isFieldDisabled("SOURCE_OF_FUND_FR")) {%> onclick="return forceCheck(this,'<%=accountData.get("SOURCE_OF_FUND_FR")%>')" <%}%>> 
									<label <%if (AOFDisabledFiledsMap.isFieldDisabled("SOURCE_OF_FUND_FR")) {%> class="red" <%}%> for="SOURCE_OF_FUND_FR">Family Remittances</label>
								</td>
								<td width="25%">
									<input type="checkbox" name="SOURCE_OF_FUND_EP" id="SOURCE_OF_FUND_EP" value="Y" <%if ("Y".equals(accountData.get("SOURCE_OF_FUND_EP"))) {%> checked="checked" <%}%>
									<%if (AOFDisabledFiledsMap.isFieldDisabled("SOURCE_OF_FUND_EP")) {%> onclick="return forceCheck(this,'<%=accountData.get("SOURCE_OF_FUND_EP")%>')" <%}%>> 
									<label <%if (AOFDisabledFiledsMap.isFieldDisabled("SOURCE_OF_FUND_EP")) {%> class="red" <%}%> for="SOURCE_OF_FUND_EP">Export Proceeds</label>
								</td>
							</tr>
							<tr>
								<td>
									<input type="checkbox" name="SOURCE_OF_FUND_IP" id="SOURCE_OF_FUND_IP" value="Y" <%if ("Y".equals(accountData.get("SOURCE_OF_FUND_IP"))) {%> checked="checked" <%}%>
									<%if (AOFDisabledFiledsMap.isFieldDisabled("SOURCE_OF_FUND_IP")) {%> onclick="return forceCheck(this,'<%=accountData.get("SOURCE_OF_FUND_IP")%>')" <%}%>> 
									<label <%if (AOFDisabledFiledsMap.isFieldDisabled("SOURCE_OF_FUND_IP")) {%> class="red" <%}%> for="SOURCE_OF_FUND_IP">Investments Proceeds</label>
								</td>
								<td>
									<input type="checkbox" name="SOURCE_OF_FUND_D" id="SOURCE_OF_FUND_D" value="Y" <%if ("Y".equals(accountData.get("SOURCE_OF_FUND_D"))) {%> checked="checked" <%}%>
									<%if (AOFDisabledFiledsMap.isFieldDisabled("SOURCE_OF_FUND_D")) {%> onclick="return forceCheck(this,'<%=accountData.get("SOURCE_OF_FUND_D")%>')" <%}%>> 
									<label <%if (AOFDisabledFiledsMap.isFieldDisabled("SOURCE_OF_FUND_D")) {%> class="red" <%}%> for="SOURCE_OF_FUND_D">Donations / Charities</label>
								</td>
								<td>
									<input type="checkbox" name="SOURCE_OF_FUND_CI" id="SOURCE_OF_FUND_CI" value="Y" <%if ("Y".equals(accountData.get("SOURCE_OF_FUND_CI"))) {%> checked="checked" <%}%>
									<%if (AOFDisabledFiledsMap.isFieldDisabled("SOURCE_OF_FUND_CI")) {%> onclick="return forceCheck(this,'<%=accountData.get("SOURCE_OF_FUND_CI")%>')" <%}%>> 
									<label <%if (AOFDisabledFiledsMap.isFieldDisabled("SOURCE_OF_FUND_CI")) {%> class="red" <%}%> for="SOURCE_OF_FUND_CI">Commission Income</label>
								</td>
								<td>
									<input type="checkbox" name="SOURCE_OF_FUND_OT" id="SOURCE_OF_FUND_OT" value="Y" <%if ("Y".equals(accountData.get("SOURCE_OF_FUND_OT"))) {%> checked="checked" <%}%>
									<%if (AOFDisabledFiledsMap.isFieldDisabled("SOURCE_OF_FUND_OT")) {%> onclick="return forceCheck(this,'<%=accountData.get("SOURCE_OF_FUND_OT")%>')" <%}%>> 
									<label <%if (AOFDisabledFiledsMap.isFieldDisabled("SOURCE_OF_FUND_OT")) {%> class="red" <%}%> for="SOURCE_OF_FUND_OT"> 
										Others : <input type="text" name="SOURCE_OF_FUND_OTR" 
										<%if (AOFDisabledFiledsMap.isFieldDisabled("SOURCE_OF_FUND_OT")) {%>
											readonly="readonly" class="input-ovr bacred" 
										<%} else {%>
											class="input-ovr" <%}%>
										<%if ("Y".equals(accountData.get("SOURCE_OF_FUND_OT"))) {%> 
											value="<%=accountData.get("SOURCE_OF_FUND_OTR") != null ? accountData.get("SOURCE_OF_FUND_OTR") : ""%>"<%}%> />
									</label>
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td>Anticipated Deposits to the Account</td>
					<td>
						<table width="100%">
							<tr>
								<td width="25%"><input type="radio" name="ACCOUNT_DEPOSITE"
									id="depositAmountInAccount1" value="1"
									<%if ("1".equals(accountData.get("ACCOUNT_DEPOSITE"))) {%>
									checked="checked" <%}%>
									<%if (AOFDisabledFiledsMap.isFieldDisabled("ACCOUNT_DEPOSITE")) {%>
									onclick="return forceCheck(this,'<%=accountData.get("ACCOUNT_DEPOSITE")%>')"
									<%}%>> <label
									<%if (AOFDisabledFiledsMap.isFieldDisabled("SOURCE_OF_FUND")) {%>
									class="red" <%}%> for="depositAmountInAccount1">Less
										than 100,000</label></td>
								<td width="25%"><input type="radio" name="ACCOUNT_DEPOSITE"
									id="depositAmountInAccount2" value="2"
									<%if ("2".equals(accountData.get("ACCOUNT_DEPOSITE"))) {%>
									checked="checked" <%}%>
									<%if (AOFDisabledFiledsMap.isFieldDisabled("ACCOUNT_DEPOSITE")) {%>
									onclick="return forceCheck(this,'<%=accountData.get("ACCOUNT_DEPOSITE")%>')"
									<%}%>> <label
									<%if (AOFDisabledFiledsMap.isFieldDisabled("SOURCE_OF_FUND")) {%>
									class="red" <%}%> for="depositAmountInAccount2">100,000
										- 500,000</label></td>
								<td width="25%"><input type="radio" name="ACCOUNT_DEPOSITE"
									id="depositAmountInAccount3" value="3"
									<%if ("3".equals(accountData.get("ACCOUNT_DEPOSITE"))) {%>
									checked="checked" <%}%>
									<%if (AOFDisabledFiledsMap.isFieldDisabled("ACCOUNT_DEPOSITE")) {%>
									onclick="return forceCheck(this,'<%=accountData.get("ACCOUNT_DEPOSITE")%>')"
									<%}%>> <label
									<%if (AOFDisabledFiledsMap.isFieldDisabled("SOURCE_OF_FUND")) {%>
									class="red" <%}%> for="depositAmountInAccount3">500,000
										- 1,000,000</label></td>
								<td width="25%"><input type="radio" name="ACCOUNT_DEPOSITE"
									id="depositAmountInAccount4" value="4"
									<%if ("4".equals(accountData.get("ACCOUNT_DEPOSITE"))) {%>
									checked="checked" <%}%>
									<%if (AOFDisabledFiledsMap.isFieldDisabled("ACCOUNT_DEPOSITE")) {%>
									onclick="return forceCheck(this,'<%=accountData.get("ACCOUNT_DEPOSITE")%>')"
									<%}%>> <label
									<%if (AOFDisabledFiledsMap.isFieldDisabled("SOURCE_OF_FUND")) {%>
									class="red" <%}%> for="depositAmountInAccount4">1,000,000
										- 2,000,000</label></td>
							</tr>
							<tr>
								<td><input type="radio" name="ACCOUNT_DEPOSITE"
									id="depositAmountInAccount5" value="5"
									<%if ("5".equals(accountData.get("ACCOUNT_DEPOSITE"))) {%>
									checked="checked" <%}%>
									<%if (AOFDisabledFiledsMap.isFieldDisabled("ACCOUNT_DEPOSITE")) {%>
									onclick="return forceCheck(this,'<%=accountData.get("ACCOUNT_DEPOSITE")%>')"
									<%}%>> <label
									<%if (AOFDisabledFiledsMap.isFieldDisabled("SOURCE_OF_FUND")) {%>
									class="red" <%}%> for="depositAmountInAccount5">2,000,000
										- 3,000,000</label></td>
								<td><input type="radio" name="ACCOUNT_DEPOSITE"
									id="depositAmountInAccount6" value="6"
									<%if ("6".equals(accountData.get("ACCOUNT_DEPOSITE"))) {%>
									checked="checked" <%}%>
									<%if (AOFDisabledFiledsMap.isFieldDisabled("ACCOUNT_DEPOSITE")) {%>
									onclick="return forceCheck(this,'<%=accountData.get("ACCOUNT_DEPOSITE")%>')"
									<%}%>> <label
									<%if (AOFDisabledFiledsMap.isFieldDisabled("SOURCE_OF_FUND")) {%>
									class="red" <%}%> for="depositAmountInAccount6">3,000,000
										- 4,000,000</label></td>
								<td><input type="radio" name="ACCOUNT_DEPOSITE"
									id="depositAmountInAccount7" value="7"
									<%if ("7".equals(accountData.get("ACCOUNT_DEPOSITE"))) {%>
									checked="checked" <%}%>
									<%if (AOFDisabledFiledsMap.isFieldDisabled("ACCOUNT_DEPOSITE")) {%>
									onclick="return forceCheck(this,'<%=accountData.get("ACCOUNT_DEPOSITE")%>')"
									<%}%>> <label
									<%if (AOFDisabledFiledsMap.isFieldDisabled("SOURCE_OF_FUND")) {%>
									class="red" <%}%> for="depositAmountInAccount7">4,000,000
										- 5,000,000</label></td>
								<td><input type="radio" name="ACCOUNT_DEPOSITE"
									id="depositAmountInAccount8" value="8"
									<%if ("8".equals(accountData.get("ACCOUNT_DEPOSITE"))) {%>
									checked="checked" <%}%>
									<%if (AOFDisabledFiledsMap.isFieldDisabled("ACCOUNT_DEPOSITE")) {%>
									onclick="return forceCheck(this,'<%=accountData.get("ACCOUNT_DEPOSITE")%>')"
									<%}%>> <label
									<%if (AOFDisabledFiledsMap.isFieldDisabled("SOURCE_OF_FUND")) {%>
									class="red" <%}%> for="depositAmountInAccount8">5,000,000
										and above</label></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td>Initial Deposit Amount</td>
					<td><input type="text" name="INITIAL_DEPOSITE"
						value="<%=accountData.get("INITIAL_DEPOSITE") != null ? accountData.get("INITIAL_DEPOSITE") : ""%>"
						<%if (AOFDisabledFiledsMap.isFieldDisabled("INITIAL_DEPOSITE")) {%>
						readonly="readonly" class="form-control imput-sm red" <%} else {%>
						class="form-control imput-sm" <%}%>></td>
				</tr>
				<%
					if("4".equals(accountData.get("CIF_TYPE"))) {
				%>
				<tr>
					<td <% if(AOFDisabledFiledsMap.isFieldDisabled("INCOME_DET")){ %> class="red" <%} %>>Minor's Gurdian Income Details (Rs.)</td>
					<td>
					<select class="form-control input-sm" name="INCOME_DET" <% if(AOFDisabledFiledsMap.isFieldDisabled("INCOME_DET")){ %> onchange="return forceCheckSelect(this,'<%=accountData.get("INCOME_DET")%>')" <%} %>>
							<option value=""></option>
							<option value="1" <% if("1".equals(accountData.get("INCOME_DET"))){ %> selected="selected" <%} %>>Less than 14,999</option>
							<option value="2" <% if("2".equals(accountData.get("INCOME_DET"))){ %> selected="selected" <%} %>>15,000 - 24,999</option>
							<option value="3" <% if("3".equals(accountData.get("INCOME_DET"))){ %> selected="selected" <%} %>>25,000 - 39,999</option>
							<option value="4" <% if("4".equals(accountData.get("INCOME_DET"))){ %> selected="selected" <%} %>>40,000 - 59,999</option>
							<option value="5" <% if("5".equals(accountData.get("INCOME_DET"))){ %> selected="selected" <%} %>>60,000 - 79,999</option>
							<option value="6" <% if("6".equals(accountData.get("INCOME_DET"))){ %> selected="selected" <%} %>>80,000 - 99,999</option>
							<option value="7" <% if("7".equals(accountData.get("INCOME_DET"))){ %> selected="selected" <%} %>>100,000 and above</option>
					</select>
					</td>
				</tr>
				<%}%>
			</table>
		</div>
		<% if(canEdit.equals("Y")){ %>
			<div class="sectionFooter">
				<input name="formSave" type="submit" value="Save" class="btn btn-success" /> 
				<input id="closeModal" type="button" value="Close" class="btn btn-danger" onclick="parent.closeModal()"/>
			</div>
		<% } %>
	</div>
	<div class="section">
				    		<div class="<% if(FORMSTATUS.get("REJECTED_SECTION") != null && FORMSTATUS.get("REJECTED_SECTION").contains("reject_section62"+accountNo)){  %> sectionHeaderRej <%}else{ %> sectionHeader <%} %>">
				    			Mudaraba Agreement (For all Savings and Term Investment Accounts only)
				    		</div>
				    		<div class="sectionBody">
				    			This Mudaraba Agreement is made and entered into on this <input type="text" name="MUDARABA_AAGGR_DATE" value="<%= accountData.get("MUDARABA_AAGGR_DATE") != null ? accountData.get("MUDARABA_AAGGR_DATE") : ""%>"
				    			<% if(AOFDisabledFiledsMap.isFieldDisabled("MUDARABA_AAGGR_DATE")){ %> readonly="readonly" class="input-ovr bacred" <%}else{ %> class="datepicker input-ovr" <% } %>/>
				    			at <input type="text" name="MUDARABA_AGGR_PLCE" value="<%= accountData.get("MUDARABA_AGGR_PLCE") != null ? accountData.get("MUDARABA_AGGR_PLCE") : ""%>"
				    			<% if(AOFDisabledFiledsMap.isFieldDisabled("MUDARABA_AGGR_PLCE")){ %> readonly="readonly" class="input-ovr bacred" <%}else{ %> class="input-ovr" <%} %>/> by and between 
				    			<input type="text" name="MUDARABA_AGGR_1" value="<%= accountData.get("MUDARABA_AGGR_1") != null ? accountData.get("MUDARABA_AGGR_1") : ""%>"
				    			<% if(AOFDisabledFiledsMap.isFieldDisabled("MUDARABA_AGGR_1")){ %> readonly="readonly" class="input-ovr bacred" <%}else{ %> class="input-ovr" <%} %>/>
				    			
				    			of <input type="text" name="MUDARABA_AGGR_2" value="<%= accountData.get("MUDARABA_AGGR_2") != null ? accountData.get("MUDARABA_AGGR_2") : ""%>"
				    			<% if(AOFDisabledFiledsMap.isFieldDisabled("MUDARABA_AGGR_2")){ %> readonly="readonly" class="input-ovr bacred"  <%}else{ %> class="input-ovr" <%} %>/> herein referred to as the Investor/s (which expression where the 
				    			context shall so admit, mean ans include the said 
				    			<input type="text" name="MUDARABA_AGGR_3" value="<%= accountData.get("MUDARABA_AGGR_3") != null ? accountData.get("MUDARABA_AGGR_3") : ""%>"
				    			<% if(AOFDisabledFiledsMap.isFieldDisabled("MUDARABA_AGGR_3")){ %> readonly="readonly" class="input-ovr bacred" <%}else{%> class="input-ovr" <%} %>/> his/her/their heirs
				    			 executors administrators successors in interest and assign) of the ONE PART and Amana Bank PLC (hereinafter sometimes referred to as
				    			  the "Mudarib" or the Bank) a company duly incorporated under the Companies Act No. 7 of 2007 and a Licensed Commercial Bank having 
				    			  its registered office at No. 480, Galle Road, Colombo 03, Sri Lanka (Which expression where the context shall so admit mean and include 
				    			  Amana Bank Limited its successors in interest and assigns) of the OTHER PART.
				    			<br/>
				    			AND WHEREAS the Investor/s is/are desirous of opening a savings account/term investment account with the Bank for the purpose pf investing from time to time
				    			in the Mudaraba Fund of the Bank to invest in the Bank's business activities that are expected to generate profits.
				    			<br/>
				    			AND WHEREAS the Bank is willing to accept such funds for investment in the Bank's business activities that are excepted to generate profits and share such
				    			profits on the following Terms and Condition
				    			<br/><br/>
				    			<table width="100%">
				    				<tr>
				    					<td colspan="2">Profit Sharing Ratio</td>
				    				</tr>
				    				<tr>
				    					<td <% if(AOFDisabledFiledsMap.isFieldDisabled("PSR_ACC_TYPE_1")){ %>class="red" <%} %>>Account Type</td>
				    					<td>
				    						<table width="100%">
				    							<tr>
				    								<td>
				    									<input type="radio" name="PSR_ACC_TYPE_1" id="mudarabaagreementAccountType11" value="SA" <% if("SA".equals(accountData.get("PSR_ACC_TYPE_1"))){ %> checked="checked" <% }%>
				    									<% if(AOFDisabledFiledsMap.isFieldDisabled("PSR_ACC_TYPE_1")){ %> onclick="return forceCheck(this,'<%=accountData.get("PSR_ACC_TYPE_1")%>')" <%} %>>
				    									<label for="mudarabaagreementAccountType11">Savings Account</label>
				    								</td>
				    								<td>
				    									<input type="radio" name="PSR_ACC_TYPE_1" id="mudarabaagreementAccountType12" value="CA" <% if("CA".equals(accountData.get("PSR_ACC_TYPE_1"))){ %> checked="checked" <% }%>
														<% if(AOFDisabledFiledsMap.isFieldDisabled("PSR_ACC_TYPE_1")){ %> onclick="return forceCheck(this,'<%=accountData.get("PSR_ACC_TYPE_1")%>')" <%} %>>
				    									<label for="mudarabaagreementAccountType12">Current Account</label>
				    								</td>
				    								<td>
				    									<input type="radio" name="PSR_ACC_TYPE_1" id="mudarabaagreementAccountType13" value="TD" <% if("TD".equals(accountData.get("PSR_ACC_TYPE_1"))){ %> checked="checked" <% }%>
				    									<% if(AOFDisabledFiledsMap.isFieldDisabled("PSR_ACC_TYPE_1")){ %> onclick="return forceCheck(this,'<%=accountData.get("PSR_ACC_TYPE_1")%>')" <%} %>>
				    									<label for="mudarabaagreementAccountType13">Term Deposite</label>
				    								</td>
				    								<td>
				    									<input type="radio" name="PSR_ACC_TYPE_1" id="mudarabaagreementAccountType14" value="OT" <% if("OT".equals(accountData.get("PSR_ACC_TYPE_1"))){ %> checked="checked" <% }%>
				    									<% if(AOFDisabledFiledsMap.isFieldDisabled("PSR_ACC_TYPE_1")){ %> onclick="return forceCheck(this,'<%=accountData.get("PSR_ACC_TYPE_1")%>')" <%} %>>
				    									<label for="mudarabaagreementAccountType14">
				    										Other: <input type="text" name="PSR_ACC_TYPE_1_OTR" class="input-ovr"
				    										<% if(AOFDisabledFiledsMap.isFieldDisabled("PSR_ACC_TYPE_1")){ %> readonly="readonly" <%} %>
				    										<% if("OT".equals(accountData.get("PSR_ACC_TYPE_1"))){ %>
				    											value="<%= accountData.get("PSR_ACC_TYPE_1_OTR") != null ? accountData.get("PSR_ACC_TYPE_1_OTR") : "" %>"
				    										<% }%>
				    										/>
				    										
				    									</label>
				    								</td>
				    							</tr>
				    						</table>
				    					</td>
				    					<td colspan="3">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
										<!--
				    					<td <% if(AOFDisabledFiledsMap.isFieldDisabled("PSR_ACC_TYPE_2")){ %>class="red" <%} %>>Account Type</td>
				    					<td>
				    						<table width="100%">
				    							<tr>
				    								<td>
				    									<input type="radio" name="PSR_ACC_TYPE_2" id="mudarabaagreementAccountType21" value="SA" <% if("SA".equals(accountData.get("PSR_ACC_TYPE_2"))){ %> checked="checked" <% }%>
				    									<% if(AOFDisabledFiledsMap.isFieldDisabled("PSR_ACC_TYPE_2")){ %> onclick="return forceCheck(this,'<%=accountData.get("PSR_ACC_TYPE_2")%>')" <%} %>>
				    									<label for="mudarabaagreementAccountType21">Savings Account</label>
				    								</td>
				    								<td>
				    									<input type="radio" name="PSR_ACC_TYPE_2" id="mudarabaagreementAccountType22" value="CA" <% if("CA".equals(accountData.get("PSR_ACC_TYPE_2"))){ %> checked="checked" <% }%>
				    									<% if(AOFDisabledFiledsMap.isFieldDisabled("PSR_ACC_TYPE_2")){ %> onclick="return forceCheck(this,'<%=accountData.get("PSR_ACC_TYPE_2")%>')" <%} %>>
				    									<label for="mudarabaagreementAccountType22">Current Account</label>
				    								</td>
				    								<td>
				    									<input type="radio" name="PSR_ACC_TYPE_2" id="mudarabaagreementAccountType23" value="TD" <% if("TD".equals(accountData.get("PSR_ACC_TYPE_2"))){ %> checked="checked" <% }%>
				    									<% if(AOFDisabledFiledsMap.isFieldDisabled("PSR_ACC_TYPE_2")){ %> onclick="return forceCheck(this,'<%=accountData.get("PSR_ACC_TYPE_2")%>')" <%} %>>
				    									<label for="mudarabaagreementAccountType23">Term Deposite</label>
				    								</td>
				    								<td>
				    									<input type="radio" name="PSR_ACC_TYPE_2" id="mudarabaagreementAccountType24" value="OT" <% if("OT".equals(accountData.get("PSR_ACC_TYPE_2"))){ %> checked="checked" <% }%>
				    									<% if(AOFDisabledFiledsMap.isFieldDisabled("PSR_ACC_TYPE_2")){ %> onclick="return forceCheck(this,'<%=accountData.get("PSR_ACC_TYPE_2")%>')" <%} %>>
				    									<label for="mudarabaagreementAccountType24">
				    										Other: <input type="text" name="PSR_ACC_TYPE_2_OTR" class="input-ovr"
				    										<% if(AOFDisabledFiledsMap.isFieldDisabled("PSR_ACC_TYPE_2")){ %> readonly="readonly" <%} %>
				    										<% if("OT".equals(accountData.get("PSR_ACC_TYPE_2"))){ %>
				    											value="<%= accountData.get("PSR_ACC_TYPE_2_OTR") != null ? accountData.get("PSR_ACC_TYPE_2_OTR") : "" %>"
				    										<% }%>
				    										/>
				    									</label>
				    								</td>
				    							</tr>
				    						</table>
				    					</td>
										-->
				    				</tr>
				    				<tr>
				    					<td <% if(AOFDisabledFiledsMap.isFieldDisabled("PSR_BANK_1")){ %>class="red" <%} %>>Amana Bank</td>
				    					<td><input type="text" name="PSR_BANK_1" class="input-ovr" value="<%=accountData.get("PSR_BANK_1") != null ? accountData.get("PSR_BANK_1") : "" %>"
				    					<% if(AOFDisabledFiledsMap.isFieldDisabled("PSR_BANK_1")){ %> readonly="readonly" <%} %>/> %</td>
				    					<td colspan="3">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
										<!--
				    					<td <% if(AOFDisabledFiledsMap.isFieldDisabled("PSR_BANK_2")){ %>class="red" <%} %>>Amana Bank</td>
				    					<td><input type="text" name="PSR_BANK_2" class="input-ovr" value="<%=accountData.get("PSR_BANK_2") != null ? accountData.get("PSR_BANK_2") : "" %>"
				    					<% if(AOFDisabledFiledsMap.isFieldDisabled("PSR_BANK_2")){ %> readonly="readonly" <%} %>/> %</td>
										-->
				    				</tr>
				    				<tr>
				    					<td <% if(AOFDisabledFiledsMap.isFieldDisabled("PSR_CUSTOMER_1")){ %>class="red" <%} %>>Customer</td>
				    					<td><input type="text" name="PSR_CUSTOMER_1" class="input-ovr" value="<%=accountData.get("PSR_CUSTOMER_1") != null ? accountData.get("PSR_CUSTOMER_1") : "" %>"
				    					<% if(AOFDisabledFiledsMap.isFieldDisabled("PSR_CUSTOMER_1")){ %> readonly="readonly" <%} %>/> %</td>
				    					<td colspan="3">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
										<!--
				    					<td <% if(AOFDisabledFiledsMap.isFieldDisabled("PSR_CUSTOMER_2")){ %>class="red" <%} %>>Customer</td>
				    					<td><input type="text" name="PSR_CUSTOMER_2" class="input-ovr" value="<%=accountData.get("PSR_CUSTOMER_2") != null ? accountData.get("PSR_CUSTOMER_2") : "" %>"
				    					<% if(AOFDisabledFiledsMap.isFieldDisabled("PSR_CUSTOMER_2")){ %> readonly="readonly" <%} %>/> %</td>
										-->
				    				</tr>
				    			</table>
				    		</div>
				    		<% if(canEdit.equals("Y")){ %>
					    		<div class="sectionFooter">
									<input name="formSave" type="submit" value="Save" class="btn btn-success" /> 
									<input id="closeModal" type="button" value="Close" class="btn btn-danger" onclick="parent.closeModal()"/>
								</div>
				    		<% } %>
				    	</div>
						
	<div class="section">
		<div
			class="<%if (FORMSTATUS.get("REJECTED_SECTION") != null
					&& FORMSTATUS.get("REJECTED_SECTION").contains("reject_section63"+accountNo)) {%> sectionHeaderRej <%} else {%> sectionHeader <%}%>">
			FOR TERM INVESTMENT ACCOUNTS ONLY</div>
		<div class="sectionBody">
			<table class="table table-bordered">
				<tr>
					<td width="25%">Investment Period</td>
					<td width="75%"><input type="text" name="INVST_PERIOD_YEAR"
						value="<%=accountData.get("INVST_PERIOD_YEAR") != null ? accountData
					.get("INVST_PERIOD_YEAR") : ""%>"
						<%if (AOFDisabledFiledsMap.isFieldDisabled("INVST_PERIOD_YEAR")) {%>
						readonly="readonly" class="input-ovr bacred" <%} else {%>
						class="input-ovr" <%}%>> Years <input type="text"
						name="INVST_PERIOD_MONTH"
						value="<%=accountData.get("INVST_PERIOD_MONTH") != null ? accountData
					.get("INVST_PERIOD_MONTH") : ""%>"
						<%if (AOFDisabledFiledsMap.isFieldDisabled("INVST_PERIOD_MONTH")) {%>
						readonly="readonly" class="input-ovr bacred" <%} else {%>
						class="input-ovr" <%}%>> Months</td>
				</tr>
				<tr>
					<td width="25%">Investment Amount Details</td>
					<td width="75%">Amount : <input type="text"
						name="INVST_AMOUNT"
						value="<%=accountData.get("INVST_AMOUNT") != null ? accountData
					.get("INVST_AMOUNT") : ""%>"
						<%if (AOFDisabledFiledsMap.isFieldDisabled("INVST_AMOUNT")) {%>
						readonly="readonly" class="input-ovr bacred" <%} else {%>
						class="input-ovr" <%}%>><br /> Mode of Deposit: <input
						type="radio" name="DEPOSIT_MODE" id="modeOfDepositCash"
						value="CSH"
						<%if ("CSH".equals(accountData.get("DEPOSIT_MODE"))) {%>
						checked="checked" <%}%>
						<%if (AOFDisabledFiledsMap.isFieldDisabled("DEPOSIT_MODE")) {%>
						onclick="return forceCheck(this,'<%=accountData.get("DEPOSIT_MODE")%>')"
						<%}%>> <label
						<%if (AOFDisabledFiledsMap.isFieldDisabled("DEPOSIT_MODE")) {%>
						class="red" <%}%> for="modeOfDepositCash">Cash</label> <input
						type="radio" name="DEPOSIT_MODE" id="modeOfDepositCheque"
						value="CHQ"
						<%if ("CHQ".equals(accountData.get("DEPOSIT_MODE"))) {%>
						checked="checked" <%}%>
						<%if (AOFDisabledFiledsMap.isFieldDisabled("DEPOSIT_MODE")) {%>
						onclick="return forceCheck(this,'<%=accountData.get("DEPOSIT_MODE")%>')"
						<%}%>> <label
						<%if (AOFDisabledFiledsMap.isFieldDisabled("DEPOSIT_MODE")) {%>
						class="red" <%}%> for="modeOfDepositCheque"> Cheque No:<input
							type="text" name="DEPOSIT_CHQ_NO"
							<%if (AOFDisabledFiledsMap.isFieldDisabled("DEPOSIT_MODE")) {%>
							readonly="readonly" class="input-ovr bacred" <%} else {%>
							class="input-ovr" <%}%>
							<%if ("CHQ".equals(accountData.get("DEPOSIT_MODE"))) {%>
							value="<%=accountData.get("DEPOSIT_CHQ_NO") != null ? accountData
						.get("DEPOSIT_CHQ_NO") : ""%>"
							<%}%> />
					</label>
					</td>
				</tr>
				<tr>
					<td width="25%"
						<%if (AOFDisabledFiledsMap.isFieldDisabled("PROFIT_PAYMENT_METHOD")) {%>
						class="red" <%}%>>Profit Payment</td>
					<td width="75%">
						<ul class="inlineUL">
							<li><input type="radio" name="PROFIT_PAYMENT_METHOD"
								id="profitPayment1" value="1"
								<%if ("1".equals(accountData.get("PROFIT_PAYMENT_METHOD"))) {%>
								checked="checked" <%}%>
								<%if (AOFDisabledFiledsMap.isFieldDisabled("PROFIT_PAYMENT_METHOD")) {%>
								onclick="return forceCheck(this,'<%=accountData.get("PROFIT_PAYMENT_METHOD")%>')"
								<%}%>> <label for="profitPayment1">Paid at
									Maturity</label></li>
							<li><input type="radio" name="PROFIT_PAYMENT_METHOD"
								id="profitPayment2" value="2"
								<%if ("2".equals(accountData.get("PROFIT_PAYMENT_METHOD"))) {%>
								checked="checked" <%}%>
								<%if (AOFDisabledFiledsMap.isFieldDisabled("PROFIT_PAYMENT_METHOD")) {%>
								onclick="return forceCheck(this,'<%=accountData.get("PROFIT_PAYMENT_METHOD")%>')"
								<%}%>> <label for="profitPayment2">Paid at
									Monthly</label></li>
						</ul>
					</td>
				</tr>
				<tr>
					<td width="25%">Please credit/remit profilts at
						maturity/monthly to</td>
					<td width="75%">
						<table width="100%">
							<tr>
								<td
									<%if (AOFDisabledFiledsMap.isFieldDisabled("PROFIT_PAYMENT_ACC_NO")) {%>
									class="red" <%}%>>Account No</td>
								<td><input type="text" name="PROFIT_PAYMENT_ACC_NO"
									class="form-control input-sm"
									value="<%=accountData.get("PROFIT_PAYMENT_ACC_NO") != null ? accountData
					.get("PROFIT_PAYMENT_ACC_NO") : ""%>"
									<%if (AOFDisabledFiledsMap.isFieldDisabled("PROFIT_PAYMENT_ACC_NO")) {%>
									readonly="readonly" <%}%>></td>
							</tr>
							<tr>
								<td
									<%if (AOFDisabledFiledsMap.isFieldDisabled("PROFIT_PAYMENT_ACC_NAME")) {%>
									class="red" <%}%>>Account Holder Name</td>
								<td><input type="text" name="PROFIT_PAYMENT_ACC_NAME"
									class="form-control input-sm"
									value="<%=accountData.get("PROFIT_PAYMENT_ACC_NAME") != null ? accountData
					.get("PROFIT_PAYMENT_ACC_NAME") : ""%>"
									<%if (AOFDisabledFiledsMap.isFieldDisabled("PROFIT_PAYMENT_ACC_NAME")) {%>
									readonly="readonly" <%}%>></td>
							</tr>
							<tr>
								<td
									<%if (AOFDisabledFiledsMap.isFieldDisabled("PROFIT_PAYMENT_BANK")) {%>
									class="red" <%}%>>Bank Name</td>
								<td><input type="text" name="PROFIT_PAYMENT_BANK"
									class="form-control input-sm"
									value="<%=accountData.get("PROFIT_PAYMENT_BANK") != null ? accountData
					.get("PROFIT_PAYMENT_BANK") : ""%>"
									<%if (AOFDisabledFiledsMap.isFieldDisabled("PROFIT_PAYMENT_BANK")) {%>
									readonly="readonly" <%}%>></td>
							</tr>
							<tr>
								<td
									<%if (AOFDisabledFiledsMap.isFieldDisabled("PROFIT_PAYMENT_BRANCH")) {%>
									class="red" <%}%>>Branch Name</td>
								<td><input type="text" name="PROFIT_PAYMENT_BRANCH"
									class="form-control input-sm"
									value="<%=accountData.get("PROFIT_PAYMENT_BRANCH") != null ? accountData
					.get("PROFIT_PAYMENT_BRANCH") : ""%>"
									<%if (AOFDisabledFiledsMap.isFieldDisabled("PROFIT_PAYMENT_BRANCH")) {%>
									readonly="readonly" <%}%>></td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</div>
		<% if(canEdit.equals("Y")){ %>
			<div class="sectionFooter">
				<input name="formSave" type="submit" value="Save" class="btn btn-success" /> 
				<input id="closeModal" type="button" value="Close" class="btn btn-danger" onclick="parent.closeModal()"/>
			</div>
		<% } %>
	</div>
	
	<%
	System.out.println("jointHolder details : "+jointHolder);
	%>
	<div class="section">
		<div
			class="<%if (FORMSTATUS.get("REJECTED_SECTION") != null
					&& FORMSTATUS.get("REJECTED_SECTION").contains("reject_section64"+accountNo)) {%> sectionHeaderRej <%} else {%> sectionHeader <%}%>">
			CORRESPONDENCE</div>
		<div class="sectionBody">
			<table class="table table-bordered">
				<tr>
					<td width="25%"
						<%if (AOFDisabledFiledsMap.isFieldDisabled("CORRESPONDENCE_TYPE")) {%>
						class="red" <%}%>>Bank Correspondence</td>
					<td width="75%">
						<table width="100%">
							<%
								if (jointHolder.size() > 0) {
									for (int i = 0; i < jointHolder.size(); i++) {
										String lineNo = jointHolder.get(i).get("LINE_NO");
										String jointHolderName = jointHolder.get(i).get("FULLNAME");
										if(lineNo != null){
							%>
							<tr>
								<td><input type="radio" name="CORRESPONDENCE_TYPE" id="bankCorrespondence<%=lineNo%>" value="<%=lineNo%>"
									<%if (lineNo.equals(accountData.get("CORRESPONDENCE_TYPE"))) {%>
									checked="checked" <%}%>
									<%if (AOFDisabledFiledsMap.isFieldDisabled("CORRESPONDENCE_TYPE")) {%>
										onclick="return forceCheck(this,'<%=accountData.get("CORRESPONDENCE_TYPE")%>')"
									<%}%>> <label for="bankCorrespondence<%=lineNo%>"><%=jointHolderName%></label>
								</td>
							</tr>
							<%
										}
								}
								} else {
							%>
							<tr>
								<td><input type="radio" name="CORRESPONDENCE_TYPE"
									id="bankCorrespondence1" value="1" checked="checked"
									<%if (AOFDisabledFiledsMap.isFieldDisabled("CORRESPONDENCE_TYPE")) {%>
									onclick="return forceCheck(this,'<%=accountData.get("CORRESPONDENCE_TYPE")%>')"
									<%}%>> <label for="bankCorrespondence1"></label>
								</td>
							</tr>
							<%
								}
							%>
						</table>
					</td>
				</tr>
				<tr>
					<td width="25%"
						<%if (AOFDisabledFiledsMap.isFieldDisabled("SAVINGS_ACC_STMNT_TYPE")) {%>
						class="red" <%}%>>For Savings Account</td>
					<td width="75%">
						<ul class="inlineUL">
							<li><input type="radio" name="SAVINGS_ACC_STMNT_TYPE"
								id="forSavingsAccount1" value="1"
								<%if ("1".equals(accountData.get("SAVINGS_ACC_STMNT_TYPE"))) {%>
								checked="checked" <%}%>
								<%if (AOFDisabledFiledsMap.isFieldDisabled("SAVINGS_ACC_STMNT_TYPE")) {%>
								onclick="return forceCheck(this,'<%=accountData.get("SAVINGS_ACC_STMNT_TYPE")%>')"
								<%}%>> <label for="forSavingsAccount1">Passbook</label>
							</li>
							<li><input type="radio" name="SAVINGS_ACC_STMNT_TYPE"
								id="forSavingsAccount2" value="2"
								<%if ("2".equals(accountData.get("SAVINGS_ACC_STMNT_TYPE"))) {%>
								checked="checked" <%}%>
								<%if (AOFDisabledFiledsMap.isFieldDisabled("SAVINGS_ACC_STMNT_TYPE")) {%>
								onclick="return forceCheck(this,'<%=accountData.get("SAVINGS_ACC_STMNT_TYPE")%>')"
								<%}%>> <label for="forSavingsAccount2">Account
									Statement</label></li>
						</ul>
					</td>
				</tr>
				<tr>
					<td width="25%">Statement Frequencys</td>
					<td width="75%">
						<table>
							<tr>
								<td width="25%"
									<%if (AOFDisabledFiledsMap.isFieldDisabled("CURRENT_ACC_STMNT_FREQ")) {%>
									class="red" <%}%>>For Current Account</td>
								<td width="75%">
									<ul class="inlineUL">
										<li><input type="radio" name="CURRENT_ACC_STMNT_FREQ"
											id="statementFrequencyCurr1" value="1"
											<%if ("1".equals(accountData.get("CURRENT_ACC_STMNT_FREQ"))) {%>
											checked="checked" <%}%>
											<%if (AOFDisabledFiledsMap.isFieldDisabled("CURRENT_ACC_STMNT_FREQ")) {%>
											onclick="return forceCheck(this,'<%=accountData.get("CURRENT_ACC_STMNT_FREQ")%>')"
											<%}%>> <label for="statementFrequencyCurr1">Monthly</label>
										</li>
										<li><input type="radio" name="CURRENT_ACC_STMNT_FREQ"
											id="statementFrequencyCurr2" value="2"
											<%if ("2".equals(accountData.get("CURRENT_ACC_STMNT_FREQ"))) {%>
											checked="checked" <%}%>
											<%if (AOFDisabledFiledsMap.isFieldDisabled("CURRENT_ACC_STMNT_FREQ")) {%>
											onclick="return forceCheck(this,'<%=accountData.get("CURRENT_ACC_STMNT_FREQ")%>')"
											<%}%>> <label for="statementFrequencyCurr2">Quarterly</label>
										</li>
										<li><input type="radio" name="CURRENT_ACC_STMNT_FREQ"
											id="statementFrequencyCurr3" value="3"
											<%if ("3".equals(accountData.get("CURRENT_ACC_STMNT_FREQ"))) {%>
											checked="checked" <%}%>
											<%if (AOFDisabledFiledsMap.isFieldDisabled("CURRENT_ACC_STMNT_FREQ")) {%>
											onclick="return forceCheck(this,'<%=accountData.get("CURRENT_ACC_STMNT_FREQ")%>')"
											<%}%>> <label for="statementFrequencyCurr3">
												Other : <input type="text" name="CURRENT_ACC_STMNT_FREQ_OTR"
												class="input-ovr"
												<%if (AOFDisabledFiledsMap.isFieldDisabled("CURRENT_ACC_STMNT_FREQ")) {%>
												readonly="readonly" <%}%>
												<%if ("3".equals(accountData.get("CURRENT_ACC_STMNT_FREQ"))) {%>
												value="<%=accountData.get("CURRENT_ACC_STMNT_FREQ_OTR") != null ? accountData
						.get("CURRENT_ACC_STMNT_FREQ_OTR") : ""%>"
												<%}%> />
										</label></li>
									</ul>
								</td>
							</tr>
							<tr>
								<td width="25%"
									<%if (AOFDisabledFiledsMap.isFieldDisabled("SAVINGS_ACC_STMNT_FREQ")) {%>
									class="red" <%}%>>For Savings Account</td>
								<td width="75%">
									<ul class="inlineUL">
										<li><input type="radio" name="SAVINGS_ACC_STMNT_FREQ"
											id="statementFrequencySav1" value="1"
											<%if ("1".equals(accountData.get("SAVINGS_ACC_STMNT_FREQ"))) {%>
											checked="checked" <%}%>
											<%if (AOFDisabledFiledsMap.isFieldDisabled("SAVINGS_ACC_STMNT_FREQ")) {%>
											onclick="return forceCheck(this,'<%=accountData.get("SAVINGS_ACC_STMNT_FREQ")%>')"
											<%}%>> <label for="statementFrequencySav1">Monthly</label>
										</li>
										<li><input type="radio" name="SAVINGS_ACC_STMNT_FREQ"
											id="statementFrequencySav2" value="2"
											<%if ("2".equals(accountData.get("SAVINGS_ACC_STMNT_FREQ"))) {%>
											checked="checked" <%}%>
											<%if (AOFDisabledFiledsMap.isFieldDisabled("SAVINGS_ACC_STMNT_FREQ")) {%>
											onclick="return forceCheck(this,'<%=accountData.get("SAVINGS_ACC_STMNT_FREQ")%>')"
											<%}%>> <label for="statementFrequencySav2">Quarterly</label>
										</li>
										<li><input type="radio" name="SAVINGS_ACC_STMNT_FREQ"
											id="statementFrequencySav3" value="3"
											<%if ("3".equals(accountData.get("SAVINGS_ACC_STMNT_FREQ"))) {%>
											checked="checked" <%}%>
											<%if (AOFDisabledFiledsMap.isFieldDisabled("SAVINGS_ACC_STMNT_FREQ")) {%>
											onclick="return forceCheck(this,'<%=accountData.get("SAVINGS_ACC_STMNT_FREQ")%>')"
											<%}%>> <label for="statementFrequencySav3">
												Other : <input type="text" name="SAVINGS_ACC_STMNT_FREQ_OTR"
												class="input-ovr"
												<%if (AOFDisabledFiledsMap.isFieldDisabled("SAVINGS_ACC_STMNT_FREQ")) {%>
												readonly="readonly" <%}%>
												<%if ("3".equals(accountData.get("SAVINGS_ACC_STMNT_FREQ"))) {%>
												value="<%=accountData.get("SAVINGS_ACC_STMNT_FREQ_OTR") != null ? accountData
						.get("SAVINGS_ACC_STMNT_FREQ_OTR") : ""%>"
												<%}%> />
										</label></li>
									</ul>
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td width="25%"
						<%if (AOFDisabledFiledsMap.isFieldDisabled("STMNT_DISPTCH_MODE")) {%>
						class="red" <%}%>>Mode of Dispatch</td>
					<td width="75%">
						<ul class="inlineUL">
							<li><input type="radio" name="STMNT_DISPTCH_MODE"
								id="modeOfDispatch1" value="1"
								<%if ("1".equals(accountData.get("STMNT_DISPTCH_MODE"))) {%>
								checked="checked" <%}%>
								<%if (AOFDisabledFiledsMap.isFieldDisabled("STMNT_DISPTCH_MODE")) {%>
								onclick="return forceCheck(this,'<%=accountData.get("STMNT_DISPTCH_MODE")%>')"
								<%}%>> <label for="modeOfDispatch2">by Post</label></li>
							<li><input type="radio" name="STMNT_DISPTCH_MODE"
								id="modeOfDispatch2" value="2"
								<%if ("2".equals(accountData.get("STMNT_DISPTCH_MODE"))) {%>
								checked="checked" <%}%>
								<%if (AOFDisabledFiledsMap.isFieldDisabled("STMNT_DISPTCH_MODE")) {%>
								onclick="return forceCheck(this,'<%=accountData.get("STMNT_DISPTCH_MODE")%>')"
								<%}%>> <label for="modeOfDispatch2">Collect at
									Branch</label></li>
							<li><input type="radio" name="STMNT_DISPTCH_MODE"
								id="modeOfDispatch3" value="3"
								<%if ("3".equals(accountData.get("STMNT_DISPTCH_MODE"))) {%>
								checked="checked" <%}%>
								<%if (AOFDisabledFiledsMap.isFieldDisabled("STMNT_DISPTCH_MODE")) {%>
								onclick="return forceCheck(this,'<%=accountData.get("STMNT_DISPTCH_MODE")%>')"
								<%}%>> <label for="modeOfDispatch3"> by Email.
									Email Address: <input type="text" name="STMNT_DISPTCH_EMAIL"
									class="input-ovr"
									<%if (AOFDisabledFiledsMap.isFieldDisabled("STMNT_DISPTCH_MODE")) {%>
									readonly="readonly" <%}%>
									<%if ("3".equals(accountData.get("STMNT_DISPTCH_MODE"))) {%>
									value="<%=accountData.get("STMNT_DISPTCH_EMAIL") != null ? accountData
						.get("STMNT_DISPTCH_EMAIL") : ""%>"
									<%}%> />
							</label></li>
						</ul>
					</td>
				</tr>
			</table>
		</div>
		<% if(canEdit.equals("Y")){ %>
			<div class="sectionFooter">
				<input name="formSave" type="submit" value="Save" class="btn btn-success" /> 
				<input id="closeModal" type="button" value="Close" class="btn btn-danger" onclick="parent.closeModal()"/>
			</div>
		<% } %>
	</div>
	<div class="section">
		<div
			class="<%if (FORMSTATUS.get("REJECTED_SECTION") != null
					&& FORMSTATUS.get("REJECTED_SECTION").contains("reject_section65"+accountNo)) {%> sectionHeaderRej <%} else {%> sectionHeader <%}%>">
			CHEQUE BOOK REQUISITION (for Current Accounts only)</div>
		<div class="sectionBody">
			<table class="table table-bordered">
				<tr>
					<td width="25%"
						<%if (AOFDisabledFiledsMap.isFieldDisabled("CHEQUE_BOOK_PAGE")) {%>
						class="red" <%}%>>Please issue me / us a Cheque Book with</td>
					<td width="75%">
						<ul class="inlineUL">
							<li><input type="radio" name="CHEQUE_BOOK_PAGE"
								id="chequeBook1" value="1"
								<%if ("1".equals(accountData.get("CHEQUE_BOOK_PAGE"))) {%>
								checked="checked" <%}%>
								<%if (AOFDisabledFiledsMap.isFieldDisabled("CHEQUE_BOOK_PAGE")) {%>
								onclick="return forceCheck(this,'<%=accountData.get("CHEQUE_BOOK_PAGE")%>')"
								<%}%>> <label for="chequeBook1">25 Leaves</label></li>
							<li><input type="radio" name="CHEQUE_BOOK_PAGE"
								id="chequeBook2" value="2"
								<%if ("2".equals(accountData.get("CHEQUE_BOOK_PAGE"))) {%>
								checked="checked" <%}%>
								<%if (AOFDisabledFiledsMap.isFieldDisabled("CHEQUE_BOOK_PAGE")) {%>
								onclick="return forceCheck(this,'<%=accountData.get("CHEQUE_BOOK_PAGE")%>')"
								<%}%>> <label for="chequeBook2">50 Leaves</label></li>
							<li><input type="radio" name="CHEQUE_BOOK_PAGE"
								id="chequeBook3" value="3"
								<%if ("3".equals(accountData.get("CHEQUE_BOOK_PAGE"))) {%>
								checked="checked" <%}%>
								<%if (AOFDisabledFiledsMap.isFieldDisabled("CHEQUE_BOOK_PAGE")) {%>
								onclick="return forceCheck(this,'<%=accountData.get("CHEQUE_BOOK_PAGE")%>')"
								<%}%>> <label for="chequeBook3">100 Leaves</label></li>
						</ul>
					</td>
				</tr>
			</table>
		</div>
		<% if(canEdit.equals("Y")){ %>
			<div class="sectionFooter">
				<input name="formSave" type="submit" value="Save" class="btn btn-success" /> 
				<input id="closeModal" type="button" value="Close" class="btn btn-danger" onclick="parent.closeModal()"/>
			</div>
		<% } %>
	</div>
	
	<div class="section">
		<div class="sectionHeader">VALUE ADDED SERVICES</div>
		<div class="sectionBody">
			<table width="100%">
				<tr>
					<%
						if (jointHolder.size() > 0) {
							for (int i = 0; i < jointHolder.size(); i++) {
								String lineNo = jointHolder.get(i).get("LINE_NO");
								String jointHolderName = jointHolder.get(i).get("FULLNAME");
								if(lineNo != null){
					%>
					<td>
						<button type="button" class="btn btn-sm 
							<%if (FORMSTATUS.get("REJECTED_SECTION") != null && FORMSTATUS.get("REJECTED_SECTION").contains("reject_section66"+lineNo+accountNo)) {%> 
								btn-danger 
							<%} else {%> 
								btn-primary 
							<%}%> valueAddedServiceModal" cCIF="<%=cifNo%>" cAccountNo="<%=accountNo%>" cLineNo="<%=lineNo%>"><%=jointHolderName%></button>
					</td>
					<%
						if (i % 3 == 0) {
					%>
				</tr>
				<tr>
					<%
						}
							}
							}
						} 
					%>
				</tr>
			</table>
		</div>
	</div>
	<div class="section">
		<div
			class="<%if (FORMSTATUS.get("REJECTED_SECTION") != null
					&& FORMSTATUS.get("REJECTED_SECTION").contains("reject_section67"+accountNo)) {%> sectionHeaderRej <%} else {%> sectionHeader <%}%>">
			INTRODUCTION (for Current Accounts Only)</div>
		<div class="sectionBody">
			I certify that I am well acquainted with the above person for the
			past <input type="text" name="INTRODUCTOR_RELN_YEAR"
				value="<%=accountData.get("INTRODUCTOR_RELN_YEAR") != null ? accountData
					.get("INTRODUCTOR_RELN_YEAR") : ""%>"
				<%if (AOFDisabledFiledsMap.isFieldDisabled("INTRODUCTOR_RELN_YEAR")) {%>
				readonly="readonly" class="input-ovr bacred" <%} else {%>
				class="input-ovr" <%}%> /> years and I confirm and further certify
			that the above person is suitable to open and maintain a current
			account with Amana Bank
			<table width="100%" class="table table-bordered">
				<tr>
					<td width="25%">Name</td>
					<td width="75%"><input type="text" name="INTRODUCTOR_NAME"
						value="<%=accountData.get("INTRODUCTOR_NAME") != null ? accountData
					.get("INTRODUCTOR_NAME") : ""%>"
						<%if (AOFDisabledFiledsMap.isFieldDisabled("INTRODUCTOR_NAME")) {%>
						readonly="readonly" class="form-control input-sm bacred"
						<%} else {%> class="form-control input-sm" <%}%> /></td>
				</tr>
				<tr>
					<td>NIC/Passport/DL No</td>
					<td><input type="text" name="INTRODUCTOR_ID_NO"
						value="<%=accountData.get("INTRODUCTOR_ID_NO") != null ? accountData
					.get("INTRODUCTOR_ID_NO") : ""%>"
						<%if (AOFDisabledFiledsMap.isFieldDisabled("INTRODUCTOR_ID_NO")) {%>
						readonly="readonly" class="form-control input-sm bacred"
						<%} else {%> class="form-control input-sm" <%}%> /></td>
				</tr>
				<tr>
					<td>Address</td>
					<td><input type="text" name="INTRODUCTOR_ADDR"
						value="<%=accountData.get("INTRODUCTOR_ADDR") != null ? accountData
					.get("INTRODUCTOR_ADDR") : ""%>"
						<%if (AOFDisabledFiledsMap.isFieldDisabled("INTRODUCTOR_ADDR")) {%>
						readonly="readonly" class="form-control input-sm bacred"
						<%} else {%> class="form-control input-sm" <%}%> /></td>
				</tr>
				<tr>
					<td>Account No at Amana Bank</td>
					<td><input type="text" name="INTRODUCTOR_ACC_NO"
						value="<%=accountData.get("INTRODUCTOR_ACC_NO") != null ? accountData
					.get("INTRODUCTOR_ACC_NO") : ""%>"
						<%if (AOFDisabledFiledsMap.isFieldDisabled("INTRODUCTOR_ACC_NO")) {%>
						readonly="readonly" class="form-control input-sm bacred"
						<%} else {%> class="form-control input-sm" <%}%> /></td>
				</tr>
				<tr>
					<td>Designation</td>
					<td><input type="text" name="INTRODUCTOR_DESG"
						value="<%=accountData.get("INTRODUCTOR_DESG") != null ? accountData
					.get("INTRODUCTOR_DESG") : ""%>"
						<%if (AOFDisabledFiledsMap.isFieldDisabled("INTRODUCTOR_DESG")) {%>
						readonly="readonly" class="form-control input-sm bacred"
						<%} else {%> class="form-control input-sm" <%}%> /></td>
				</tr>
				<tr>
					<td>Tel No</td>
					<td>
						<table width="100%">
							<tr>
								<td width="15%">Res.</td>
								<td width="85%"><input type="text"
									name="INTRODUCTOR_TEL_NO"
									value="<%=accountData.get("INTRODUCTOR_TEL_NO") != null ? accountData
					.get("INTRODUCTOR_TEL_NO") : ""%>"
									<%if (AOFDisabledFiledsMap.isFieldDisabled("INTRODUCTOR_TEL_NO")) {%>
									readonly="readonly" class="form-control input-sm bacred"
									<%} else {%> class="form-control input-sm" <%}%> /></td>
							</tr>
							<tr>
								<td>Off.</td>
								<td><input type="text" name="INTRODUCTOR_OFF_NO"
									value="<%=accountData.get("INTRODUCTOR_OFF_NO") != null ? accountData
					.get("INTRODUCTOR_OFF_NO") : ""%>"
									<%if (AOFDisabledFiledsMap.isFieldDisabled("INTRODUCTOR_OFF_NO")) {%>
									readonly="readonly" class="form-control input-sm bacred"
									<%} else {%> class="form-control input-sm" <%}%> /></td>
							</tr>
							<tr>
								<td>Mob.</td>
								<td><input type="text" name="INTRODUCTOR_MOB_NO"
									value="<%=accountData.get("INTRODUCTOR_MOB_NO") != null ? accountData
					.get("INTRODUCTOR_MOB_NO") : ""%>"
									<%if (AOFDisabledFiledsMap.isFieldDisabled("INTRODUCTOR_MOB_NO")) {%>
									readonly="readonly" class="form-control input-sm bacred"
									<%} else {%> class="form-control input-sm" <%}%> /></td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</div>
		<% if(canEdit.equals("Y")){ %>
			<div class="sectionFooter">
				<input name="formSave" type="submit" value="Save" class="btn btn-success" /> 
				<input id="closeModal" type="button" value="Close" class="btn btn-danger" onclick="parent.closeModal()"/>
			</div>
		<% } %>
	</div>
	<div class="section">
		<div class="<%if (FORMSTATUS.get("REJECTED_SECTION") != null
					&& FORMSTATUS.get("REJECTED_SECTION").contains("reject_section68"+accountNo)) {%> sectionHeaderRej <%} else {%> sectionHeader <%}%>">
			OPERATING INSTRUCTIONS (For Savings and Current Accounts only)</div>
		<div class="sectionBody">
			<table class="table table-bordered">
				<tr>
					<td
						<%if (AOFDisabledFiledsMap.isFieldDisabled("ACC_SIGN_TYPE")) {%>
						class="red" <%}%>>Signature Requirement</td>
					<td>
						<ul class="inlineUL">
							<li><input type="radio" name="ACC_SIGN_TYPE"
								id="signatureRequirement1" value="1"
								<%if ("1".equals(accountData.get("ACC_SIGN_TYPE"))) {%>
								checked="checked" <%}%>
								<%if (AOFDisabledFiledsMap.isFieldDisabled("ACC_SIGN_TYPE")) {%>
								onclick="return forceCheck(this,'<%=accountData.get("ACC_SIGN_TYPE")%>')"
								<%}%>> <label for="signatureRequirement1">Self</label>
							</li>
							<li><input type="radio" name="ACC_SIGN_TYPE"
								id="signatureRequirement2" value="2"
								<%if ("2".equals(accountData.get("ACC_SIGN_TYPE"))) {%>
								checked="checked" <%}%>
								<%if (AOFDisabledFiledsMap.isFieldDisabled("ACC_SIGN_TYPE")) {%>
								onclick="return forceCheck(this,'<%=accountData.get("ACC_SIGN_TYPE")%>')"
								<%}%>> <label for="signatureRequirement2">Anyone
									of us</label></li>
							<li><input type="radio" name="ACC_SIGN_TYPE"
								id="signatureRequirement3" value="3"
								<%if ("3".equals(accountData.get("ACC_SIGN_TYPE"))) {%>
								checked="checked" <%}%>
								<%if (AOFDisabledFiledsMap.isFieldDisabled("ACC_SIGN_TYPE")) {%>
								onclick="return forceCheck(this,'<%=accountData.get("ACC_SIGN_TYPE")%>')"
								<%}%>> <label for="signatureRequirement3">Both
									of us</label></li>
							<li><input type="radio" name="ACC_SIGN_TYPE"
								id="signatureRequirement4" value="4"
								<%if ("4".equals(accountData.get("ACC_SIGN_TYPE"))) {%>
								checked="checked" <%}%>
								<%if (AOFDisabledFiledsMap.isFieldDisabled("ACC_SIGN_TYPE")) {%>
								onclick="return forceCheck(this,'<%=accountData.get("ACC_SIGN_TYPE")%>')"
								<%}%>> <label for="signatureRequirement4">
									Other: <input type="text" name="ACC_SIGN_TYPE_OTR"
									class="input-ovr"
									<%if (AOFDisabledFiledsMap.isFieldDisabled("ACC_SIGN_TYPE")) {%>
									readonly="readonly" <%}%>
									<%if ("4".equals(accountData.get("ACC_SIGN_TYPE"))) {%>
									value="<%=accountData.get("ACC_SIGN_TYPE_OTR") != null ? accountData
						.get("ACC_SIGN_TYPE_OTR") : ""%>"
									<%}%> />
							</label></li>
						</ul>
					</td>
				</tr>
			</table>
		</div>
		<% if(canEdit.equals("Y")){ %>
			<div class="sectionFooter">
				<input name="formSave" type="submit" value="Save" class="btn btn-success" /> 
				<input id="closeModal" type="button" value="Close" class="btn btn-danger" onclick="parent.closeModal()"/>
			</div>
		<% } %>
	</div>
	<div class="section">
		<div class="<%if (FORMSTATUS.get("REJECTED_SECTION") != null
					&& FORMSTATUS.get("REJECTED_SECTION").contains("reject_section69"+accountNo)) {%> sectionHeaderRej <%} else {%> sectionHeader <%}%>">
			BANK USE (Only Account Level)</div>
		<div class="sectionBody">
			<table width="100%">
				<tr>
				    <td>For Term Investment Account Only</td>
				    <td>
				    	<table class="table table-bordered">
				    		<tr>
				    			<td width="45%">Term Investment Certificate No</td>
				    			<td width="55%"><input type="text" name="TERM_INVST_CERT_NO" value="<%= accountData.get("TERM_INVST_CERT_NO") != null ? accountData.get("TERM_INVST_CERT_NO") : "" %>"
				    			<% if(AOFDisabledFiledsMap.isFieldDisabled("TERM_INVST_CERT_NO")){ %> readonly="readonly" class="form-control input-sm bacred" <%}else{ %> class="form-control input-sm" <%} %>/> </td>
				    		</tr>
				    		<tr>
				    			<td>Certificate Issued On</td>
				    			<td><input type="text" name="TERM_INVST_CERT_ISS_DATE" value="<%= accountData.get("TERM_INVST_CERT_ISS_DATE") != null ? accountData.get("TERM_INVST_CERT_ISS_DATE") : "" %>"
				    			<% if(AOFDisabledFiledsMap.isFieldDisabled("TERM_INVST_CERT_ISS_DATE")){ %> readonly="readonly" class="input-ovr bacred" <%}else{ %> class="datepicker input-ovr" <% } %>/> </td>
				    		</tr>
				    		<tr>
				    			<td>Investment Txn No</td>
				    			<td><input type="text" name="TERM_INVST_TAX_NO" value="<%= accountData.get("TERM_INVST_TAX_NO") != null ? accountData.get("TERM_INVST_TAX_NO") : "" %>"
				    			<% if(AOFDisabledFiledsMap.isFieldDisabled("TERM_INVST_TAX_NO")){ %> readonly="readonly" class="form-control input-sm bacred" <%}else{ %> class="form-control input-sm" <%} %>/> </td>
				    		</tr>
				    	</table>
				    </td>
				</tr>
				<tr>
				    <td>Account Canvassed by</td>
				    <td>
				    	<table class="table table-bordered">
				    		<tr>
				    			<td width="25%">Employee Name</td>
				    			<td width="75%"><input type="text" name="ACC_CANVASSED_BY_EMP_NAME" value="<%= accountData.get("ACC_CANVASSED_BY_EMP_NAME") != null ? accountData.get("ACC_CANVASSED_BY_EMP_NAME") : "" %>"
				    				<% if(AOFDisabledFiledsMap.isFieldDisabled("ACC_CANVASSED_BY_EMP_NAME")){ %> readonly="readonly" class="form-control input-sm bacred" <%}else{ %> class="form-control input-sm" <%} %>/></td>
				    		</tr>
				    		<tr>
				    			<td>Employee No</td>
				    			<td><input type="text" name="ACC_CANVASSED_BY_EMP_NO" value="<%= accountData.get("ACC_CANVASSED_BY_EMP_NO") != null ? accountData.get("ACC_CANVASSED_BY_EMP_NO") : "" %>"
				    				<% if(AOFDisabledFiledsMap.isFieldDisabled("ACC_CANVASSED_BY_EMP_NO")){ %> readonly="readonly" class="form-control input-sm bacred" <%}else{ %> class="form-control input-sm" <%} %>/></td>
				    		</tr>
				    		<tr>
				    			<td>Branch</td>
				    			<td><input type="text" name="ACC_CANVASSED_BY_BRANCH" value="<%= accountData.get("ACC_CANVASSED_BY_BRANCH") != null ? accountData.get("ACC_CANVASSED_BY_BRANCH") : "" %>"
				    				<% if(AOFDisabledFiledsMap.isFieldDisabled("ACC_CANVASSED_BY_BRANCH")){ %> readonly="readonly" class="form-control input-sm bacred" <%}else{ %> class="form-control input-sm" <%} %>/></td>
				    		</tr>
				    	</table>
				    </td>
				</tr>
				<tr>
   					<td>For Branch Approval</td>
   					<td>
   						<table class="table table-bordered">
   							<tr>
   								<td width="30%" <% if(AOFDisabledFiledsMap.isFieldDisabled("BRNCH_APPROVL_ACC_OPND_DATE")){ %> class="red" <%} %>>Account Opened On</td>
   								<td width="70%">
   									<input type="text" name="BRNCH_APPROVL_ACC_OPND_DATE" value="<%= accountData.get("BRNCH_APPROVL_ACC_OPND_DATE") != null ? accountData.get("BRNCH_APPROVL_ACC_OPND_DATE") : "" %>"
   									<% if(AOFDisabledFiledsMap.isFieldDisabled("BRNCH_APPROVL_ACC_OPND_DATE")){ %> readonly="readonly" class="input-ovr" <%}else{%> class="input-ovr datepicker" <%} %>/>
   								</td>
   							</tr>
   							<tr>
   								<td <% if(AOFDisabledFiledsMap.isFieldDisabled("BRNCH_APPROVL_ACC_OPND_BY")){ %> class="red" <%} %>>Account Opened By</td>
   								<td>
   									<input type="text" name="BRNCH_APPROVL_ACC_OPND_BY" class="form-control input-sm" value="<%= accountData.get("BRNCH_APPROVL_ACC_OPND_BY") != null ? accountData.get("BRNCH_APPROVL_ACC_OPND_BY") : "" %>"
   									<% if(AOFDisabledFiledsMap.isFieldDisabled("BRNCH_APPROVL_ACC_OPND_BY")){ %> readonly="readonly" <%}%>/>
   								</td>
   							</tr>
   							<tr>
   								<td <% if(AOFDisabledFiledsMap.isFieldDisabled("BRNCH_APPROVL_AUTH_OFF")){ %> class="red" <%} %>>Authorised Officer</td>
   								<td>
   									<input type="text" name="BRNCH_APPROVL_AUTH_OFF" class="form-control input-sm" value="<%= accountData.get("BRNCH_APPROVL_AUTH_OFF") != null ? accountData.get("BRNCH_APPROVL_AUTH_OFF") : "" %>"
   									<% if(AOFDisabledFiledsMap.isFieldDisabled("BRNCH_APPROVL_AUTH_OFF")){ %> readonly="readonly" <%}%>/>
   								</td>
   							</tr>
   							<tr>
   								<td <% if(AOFDisabledFiledsMap.isFieldDisabled("BRNCH_APPROVL_AUDT_OFF")){ %> class="red" <%} %>>Audited By</td>
   								<td>
   									<input type="text" name="BRNCH_APPROVL_AUDT_OFF" class="form-control input-sm" value="<%= accountData.get("BRNCH_APPROVL_AUDT_OFF") != null ? accountData.get("BRNCH_APPROVL_AUDT_OFF") : "" %>"
   									<% if(AOFDisabledFiledsMap.isFieldDisabled("BRNCH_APPROVL_AUDT_OFF")){ %> readonly="readonly" <%}%>/>
   								</td>
   							</tr>
   						</table>
   					</td>
   				</tr>
			</table>
		</div>
		<% if(canEdit.equals("Y")){ %>
			<div class="sectionFooter">
				<input name="formSave" type="submit" value="Save" class="btn btn-success" /> 
				<input id="closeModal" type="button" value="Close" class="btn btn-danger" onclick="parent.closeModal()"/>
			</div>
		<% } %>
	</div>
</form>