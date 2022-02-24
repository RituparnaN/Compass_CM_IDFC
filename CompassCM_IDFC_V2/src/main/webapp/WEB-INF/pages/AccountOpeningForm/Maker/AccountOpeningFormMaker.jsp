<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="java.util.*, com.quantumdataengines.app.compass.model.AOFDisabledFiledsMap"%>
<%
String contextPath = request.getContextPath()==null?"":request.getContextPath();
String userID = request.getAttribute("userID") != null ? (String) request.getAttribute("userID") : "";
String caseNo = request.getAttribute("CASE_NO") != null ? (String) request.getAttribute("CASE_NO") : "";
String accountNo = request.getAttribute("ACCOUNT_NO") != null ? (String) request.getAttribute("ACCOUNT_NO") : "";
String cifNo = request.getAttribute("CIF_NO") != null ? (String) request.getAttribute("CIF_NO") : "";
String canEdit = request.getAttribute("CAN_EDIT") != null ? (String) request.getAttribute("CAN_EDIT") : "N";

Map<String, String> allCountries = request.getAttribute("ALLCOUNTRIES") != null ? (Map<String, String>) request.getAttribute("ALLCOUNTRIES") : new HashMap<String, String>();
Iterator<String> countryItr = allCountries.keySet().iterator();

Map<String, List<Map<String, String>>> accountsAndMandates = request.getAttribute("ACCOUNTS_AND_MANDATES") != null ? (Map<String, List<Map<String, String>>>) request.getAttribute("ACCOUNTS_AND_MANDATES") : new HashMap<String, List<Map<String, String>>>();
Map<String, String> cifData = (Map<String, String>) request.getAttribute("CIF_DATA");
List<Map<String, String>> jointHolder = (List<Map<String, String>>) request.getAttribute("JOINT_HOLDER");
List<Map<String, String>> uploadData = (List<Map<String, String>>) request.getAttribute("UPLOAD_DATA");
Map<String, String> FORMSTATUS = request.getAttribute("FORMSTATUS") != null ? (Map<String, String>) request.getAttribute("FORMSTATUS") : new HashMap<String, String>();

String MESSAGE = request.getAttribute("MESSAGE") != null ? (String) request.getAttribute("MESSAGE") : "";
boolean SEARCHDONE = request.getAttribute("SEARCHDONE") != null ? (Boolean) request.getAttribute("SEARCHDONE") : false;
String FORM_SECTION = request.getAttribute("FORM_SECTION") != null ? (String) request.getAttribute("FORM_SECTION") : "";
%>
<script type="text/javascript">
$(document).ready(function(){
	
	var form_section_cat = '<%=FORM_SECTION%>';
	if(form_section_cat == ''){
		$('.nav-tabs a[href="#category1"]').tab('show');
	}else{
		$('.nav-tabs a[href="#'+form_section_cat+'"]').tab('show');
	}
	
	$('[id^=riskRating]').click(function(){
		var rrCat1 = 0;
		var rrCat2 = 0;
		var rrCat3 = 0;
		var rrCat4 = 0;
		var riskRatingCat5 = $("#riskRatingCat5").prop("checked");
		var rrFinal = 00;
		
		$('[id^=riskRatingCat1]').each(function(){
			if($(this).prop("checked")){
				rrCat1 = parseInt($(this).attr("riskRating"));
			}
		});
		
		$('[id^=riskRatingCat2]').each(function(){
			if($(this).prop("checked")){
				rrCat2 = parseInt($(this).attr("riskRating"));
			}
		});
		
		$('[id^=riskRatingCat3]').each(function(){
			if($(this).prop("checked")){
				rrCat3 = parseInt($(this).attr("riskRating"));
			}
		});
		
		$('[id^=riskRatingCat4]').each(function(){
			if($(this).prop("checked")){
				rrCat4 = parseInt($(this).attr("riskRating"));
			}
		});
		
		rrFinal = rrCat1 + rrCat2 + rrCat3 + rrCat4;
		
		if(rrCat1 > 2){
			$("#RISK_RATING_FINAL_L").prop("checked", false);
			$("#RISK_RATING_FINAL_M").prop("checked", false);
			$("#RISK_RATING_FINAL_H").prop("checked", true);
		}else if(riskRatingCat5){
			$("#RISK_RATING_FINAL_L").prop("checked", false);
			$("#RISK_RATING_FINAL_M").prop("checked", false);
			$("#RISK_RATING_FINAL_H").prop("checked", true);
		}else if(rrFinal <= 4){
			$("#RISK_RATING_FINAL_M").prop("checked", false);
			$("#RISK_RATING_FINAL_H").prop("checked", false);
			$("#RISK_RATING_FINAL_L").prop("checked", true);
		}else if(rrFinal > 4 && rrFinal <= 8){
			$("#RISK_RATING_FINAL_L").prop("checked", false);
			$("#RISK_RATING_FINAL_H").prop("checked", false);
			$("#RISK_RATING_FINAL_M").prop("checked", true);
		}else if(rrFinal > 8 && rrFinal <= 12){
			$("#RISK_RATING_FINAL_L").prop("checked", false);
			$("#RISK_RATING_FINAL_M").prop("checked", false);
			$("#RISK_RATING_FINAL_H").prop("checked", true);
		}
		$("#RISK_RATING_FINAL_VALUE").val(rrFinal);
	});
	
	$(".addAccountHolderModal").click(function(){
		var cSector = $(this).attr("cSector");
		var cType = $(this).attr("cType");
		var cCIF = $(this).attr("cCIF");
		var cAccountNo = $(this).attr("cAccountNo");
		var cLineNo = $(this).attr("cLineNo");
		var cCaseNo = $(this).attr("cCaseNo");
		var canEdit = $("#canEdit").val();
		$("#modal-title").html("...");
		$("#accountHolderDetails").html("");
		$('#accountHolderModal').modal('show');
		
		if(cSector == "BIH"){
			$.ajax({
				type : "GET",
				url : "<%=contextPath%>/cpumaker/addAccountHolder?type="+cType+"&CIF="+cCIF+"&AccountNo="+cAccountNo+"&LineNo="+cLineNo+"&caseNo="+cCaseNo+"&canEdit="+canEdit,
				cache : false,
				success : function(res){
					$("#modal-title").html("BASIC INFORMATION OF "+cType+" ACCOUNT HOLDER");
					$("#accountHolderDetails").html(res);
					$("#accountHolderDetails").css("height",$(window).height()-80);
				},
				error : function(){
					$('#accountHolderModal').modal('hide');
					alert("error");
				}
			});
		}else if(cSector == "ACC"){
			$.ajax({
				type : "GET",
				url : "<%=contextPath%>/cpumaker/addAccountNo?CIF="+cCIF+"&AccountNo="+cAccountNo+"&CaseNo="+cCaseNo+"&canEdit="+canEdit,
				cache : false,
				success : function(res){
					$("#modal-title").html("ACCOUNT INFORMATION : "+cAccountNo);
					$("#accountHolderDetails").html(res);
					$("#accountHolderDetails").css("height",$(window).height()-80);
				},
				error : function(){
					$('#accountHolderModal').modal('hide');
					alert("error");
				}
			});
		}else if(cSector == "UPL"){
			$.ajax({
				type : "GET",
				url : "<%=contextPath%>/cpumaker/uploadDocument?CIF="+cCIF+"&AccountNo="+cAccountNo+"&CaseNo="+cCaseNo,
				cache : false,
				success : function(res){
					$("#modal-title").html("Upload Document");
					$("#accountHolderDetails").html(res);
					$("#accountHolderDetails").css("height",$(window).height()-80);
				},
				error : function(){
					$('#accountHolderModal').modal('hide');
					alert("error");
				}
			});
		}
	});
	
	$("#aof_saveMainFormData").submit(function(e){
		var saveForm = true;
		var formObj = $(this);
		var formData = $(formObj).serialize();
		var btn = $(this).find("input[type=submit]:focus" ).attr("name");
		
		var rrCat1 = 0;
		var rrCat2 = 0;
		var rrCat3 = 0;
		var rrCat4 = 0;
		var riskRatingCat5 = $("#riskRatingCat5").prop("checked");
		var rrFinal = 00;
		
		$('[id^=riskRatingCat1]').each(function(){
			if($(this).prop("checked")){
				rrCat1 = parseInt($(this).attr("riskRating"));
			}
		});
		
		$('[id^=riskRatingCat2]').each(function(){
			if($(this).prop("checked")){
				rrCat2 = parseInt($(this).attr("riskRating"));
			}
		});
		
		$('[id^=riskRatingCat3]').each(function(){
			if($(this).prop("checked")){
				rrCat3 = parseInt($(this).attr("riskRating"));
			}
		});
		
		$('[id^=riskRatingCat4]').each(function(){
			if($(this).prop("checked")){
				rrCat4 = parseInt($(this).attr("riskRating"));
			}
		});
		
		rrFinal = rrCat1 + rrCat2 + rrCat3 + rrCat4;
				
		if(btn == "formClose"){
			if(rrFinal > 0){
				if(!confirm("Are you sure you want to save and escalate this CIF?")){
					saveForm = false;
				}
			}else{
				alert("Please Enter Risk Rating Before Closing.");
				saveForm = false;
			}			
		}
		
		if(saveForm){
			$.ajax({
				url : '<%=contextPath%>/cpumaker/saveMainFormData?'+btn,
				type : "POST",
				data : formData,
				cache : false,
				success : function(res){
					alert(res.MESSAGE);
					if(res.HIDESUBMIT == "Y"){
						$("#canEdit").val("N");
						$("#aof_saveMainFormData").find(".sectionFooter").each(function(){
							$(this).css("display", "none");
						});
					}
				},
				error : function(a,b,c){
					alert("error"+a+b+c);
				}
			});
		}
		e.preventDefault();
	});
});
</script>
<input type="hidden" id="canEdit" value="<%=canEdit%>">
<% if(SEARCHDONE && cifData != null) { %>	
<ul class="nav nav-tabs" role="tablist">
   	<li role="presentation" class="active">
   		<a href="#category1" class="subTab nav-link active" aria-controls="category1" role="tab" data-toggle="tab">Customer Information</a>
   	</li>
   	<li role="presentation">
   		<a href="#category2" class="subTab nav-link"  aria-controls="category2" role="tab" data-toggle="tab">Account Information</a>
   	</li>
   	<li role="presentation">
   		<a href="#category3" class="subTab nav-link"  aria-controls="category3" role="tab" data-toggle="tab">Corporate Information</a>
   	</li>
   	<li role="presentation">
		<a href="#category8" class="subTab nav-link"  aria-controls="category8" role="tab" data-toggle="tab">Risk Rating</a>
	</li>
   	<li role="presentation">
   		<a href="#category6" class="subTab nav-link"  aria-controls="category6" role="tab" data-toggle="tab">Guardian Information</a>
   	</li>
   	<li role="presentation">
   		<a href="#category4"  class="subTab nav-link" aria-controls="category4" role="tab" data-toggle="tab">Bank Use</a>
   	</li>
   	<li role="presentation">
   		<a href="#category5" class="subTab nav-link"  aria-controls="category5" role="tab" data-toggle="tab">Documents</a>
   	</li>
	<li role="presentation">
		<a href="#category7" class="subTab nav-link"  aria-controls="category7" role="tab" data-toggle="tab">Checker</a>
	</li>
 	</ul>		
				  <!-- Tab panes -->
	<form action="javascript:void(0)" id="aof_saveMainFormData" method="POST">
		<input type="hidden" name="CIF_NO" id="CIF_NO" value="<%=cifNo%>"/>
		<input type="hidden" name="ACCOUNT_NO" id="ACCOUNT_NO" value="<%=accountNo%>"/>
		<input type="hidden" name="CASE_NO" id="CASE_NO" value="<%=caseNo%>"/>
		<input type="hidden" name="FORM_SECTION" id="FORM_SECTION" />
  			
  		<div class="tab-content" id="informationPanel">
			<div role="tabpanel" class="tab-pane active" id="category1">
				<div class="section">
					<div class="sectionHeader">
				    	TYPE OF ACCOUNT OPENING FORM
				    </div>
				    
				    <div class="sectionBody">
				    	<table class="table">
				    		<tr>
				    			<td>
				    				<table width="100%">
				    					<tr>
				    						<td width="33%">
				    							<input type="radio" name="typeOfAccount1" id="typeOfAccount11" value="I" <% if("I".equals(cifData.get("CIF_TYPE"))){ %>checked="checked"<%} %>
				    								<% if(AOFDisabledFiledsMap.isFieldDisabled("typeOfAccount1")){ %> onclick="return forceCheck(this,'<%=cifData.get("CIF_TYPE")%>')" <%} %>>
							    					<label <% if(AOFDisabledFiledsMap.isFieldDisabled("typeOfAccount1")){ %>class="red" <%} %> for="typeOfAccount11">Individual&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>
							    					<% if("I".equals(cifData.get("CIF_TYPE"))){ %>(<%=cifData.get("CIF_TYPE_NAME")%>)<%} %>
				    						</td>
				    						<td width="33%">
				    							<input type="radio" name="typeOfAccount1" id="typeOfAccount12" value="J" <% if("J".equals(cifData.get("CIF_TYPE"))){ %>checked="checked"<%} %>
				    							<% if(AOFDisabledFiledsMap.isFieldDisabled("typeOfAccount1")){ %> onclick="return forceCheck(this,'<%=cifData.get("CIF_TYPE")%>')" <%} %>>
								    			<label <% if(AOFDisabledFiledsMap.isFieldDisabled("typeOfAccount1")){ %>class="red" <%} %> for="typeOfAccount12">Joint&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>
								    			<% if("J".equals(cifData.get("CIF_TYPE"))){ %>(<%=cifData.get("CIF_TYPE_NAME")%>)<%} %>
				    						</td>
				    						<td width="33%">
				    							<input type="radio" name="typeOfAccount1" id="typeOfAccount15" value="C" <% if("C".equals(cifData.get("CIF_TYPE"))){ %>checked="checked"<%} %>
				    							<% if(AOFDisabledFiledsMap.isFieldDisabled("typeOfAccount1")){ %> onclick="return forceCheck(this,'<%=cifData.get("CIF_TYPE")%>')" <%} %>>
								    			<label <% if(AOFDisabledFiledsMap.isFieldDisabled("typeOfAccount1")){ %>class="red" <%} %> for="typeOfAccount15">Public / Private Ltd. Company&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>
								    			<% if("C".equals(cifData.get("CIF_TYPE"))){ %>(<%=cifData.get("CIF_TYPE_NAME")%>)<%} %>
				    						</td>
				    					</tr>
				    					<tr>
				    						<td>
				    							<input type="radio" name="typeOfAccount1" id="typeOfAccount16" value="M" <% if("M".equals(cifData.get("CIF_TYPE"))){ %>checked="checked"<%} %>
				    							<% if(AOFDisabledFiledsMap.isFieldDisabled("typeOfAccount1")){ %> onclick="return forceCheck(this,'<%=cifData.get("CIF_TYPE")%>')" <%} %>>
								    			<label <% if(AOFDisabledFiledsMap.isFieldDisabled("typeOfAccount1")){ %>class="red" <%} %> for="typeOfAccount16">Minor&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>
								    			<% if("M".equals(cifData.get("CIF_TYPE"))){ %>(<%=cifData.get("CIF_TYPE_NAME")%>)<%} %>
				    						</td>
				    						<td>
				    							<input type="radio" name="typeOfAccount1" id="typeOfAccount19" value="SCA" <% if("SCA".equals(cifData.get("CIF_TYPE"))){ %>checked="checked"<%} %>
				    							<% if(AOFDisabledFiledsMap.isFieldDisabled("typeOfAccount1")){ %> onclick="return forceCheck(this,'<%=cifData.get("CIF_TYPE")%>')" <%} %>>
								    			<label <% if(AOFDisabledFiledsMap.isFieldDisabled("typeOfAccount1")){ %>class="red" <%} %> for="typeOfAccount19">Society/Club/Association&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>
								    			<% if("SCA".equals(cifData.get("CIF_TYPE"))){ %>(<%=cifData.get("CIF_TYPE_NAME")%>)<%} %>
				    						</td>
				    						<td>
				    							<input type="radio" name="typeOfAccount1" id="typeOfAccount111" value="SPP" <% if("SPP".equals(cifData.get("CIF_TYPE"))){ %>checked="checked"<%} %>
				    							<% if(AOFDisabledFiledsMap.isFieldDisabled("typeOfAccount1")){ %> onclick="return forceCheck(this,'<%=cifData.get("CIF_TYPE")%>')" <%} %>>
								    			<label <% if(AOFDisabledFiledsMap.isFieldDisabled("typeOfAccount1")){ %>class="red" <%} %> for="typeOfAccount111">SoleProprietorship/Partnership&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>
								    			<% if("SPP".equals(cifData.get("CIF_TYPE"))){ %>(<%=cifData.get("CIF_TYPE_NAME")%>)<%} %>
				    						</td>
				    					</tr>
				    					<tr>
				    						<td colspan="3">
				    							<input type="radio" name="typeOfAccount1" id="typeOfAccount112" value="OT" <% if("OT".equals(cifData.get("CIF_TYPE"))){ %>checked="checked"<%} %>
				    							<% if(AOFDisabledFiledsMap.isFieldDisabled("typeOfAccount1")){ %> onclick="return forceCheck(this,'<%=cifData.get("CIF_TYPE")%>')" <%} %>>
								    			<label <% if(AOFDisabledFiledsMap.isFieldDisabled("typeOfAccount1")){ %>class="red" <%} %> for="typeOfAccount112">
									    			Other : <input type="text" name="typeOfAccountOther" <% if("OT".equals(cifData.get("CIF_TYPE"))){ %>value="<%=cifData.get("CIF_TYPE_CODE")%>"<%} %>
									    			<% if(AOFDisabledFiledsMap.isFieldDisabled("typeOfAccount1")){ %> readonly="readonly" class="input-ovr bacred" <%}else{ %> class="input-ovr" <%} %>> 
									    			<% if("OT".equals(cifData.get("CIF_TYPE"))){ %><%=cifData.get("CIF_TYPE_NAME")%><%} %>
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
				    		<div class="sectionHeader">
				    			BASIC INFORMATION OF ACCOUNT HOLDER/S
				    		</div>
				    		<div class="sectionBody">
				    			<table class="table table-bordered">
				    				<tr>
				    					<td width="50%">
				    						<% if("M".equals(cifData.get("CIF_TYPE"))){ %>
				    							Minor Account Holder
				    						<%} else { %>
				    						Primary Account Holder
				    						<% } %>
				    					</td>
				    					<td width="50%">
				    						Joint Account Holder
				    					</td>
				    				</tr>
				    				<tr>
				    					<td>
				    						<button type="button" class="btn btn-sm <% if(FORMSTATUS.get("REJECTED_SECTION") != null && FORMSTATUS.get("REJECTED_SECTION").contains("reject_section1")){  %> btn-danger <%}else{ %> btn-primary <%} %> addAccountHolderModal" cSector="BIH" cType="PRIMARY" cCIF="<%=cifNo%>" cAccountNo="<%=accountNo%>" cLineNo="0" cCaseNo=<%=caseNo%>><%=cifData.get("FULLNAME")%></button>
				    					</td>
				    					<td>
				    						<% for(int i = 0; i < jointHolder.size(); i++){ 
				    							String lineNo = jointHolder.get(i).get("LINE_NO");
				    							String jointHolderName = jointHolder.get(i).get("NAME");
				    						%>
				    						<button type="button" class="btn btn-sm <% if(FORMSTATUS.get("REJECTED_SECTION") != null && FORMSTATUS.get("REJECTED_SECTION").contains("reject_section2"+lineNo)){  %> btn-danger <%}else{ %> btn-primary <%} %> addAccountHolderModal" cSector="BIH" cType="JOINT" cCIF="<%=cifNo%>" cAccountNo="<%=accountNo%>" cLineNo="<%=lineNo%>" cCaseNo=<%=caseNo%>><%=jointHolderName%></button>
				    						<% } %>
				    					</td>
				    				</tr>
				    			</table>
				    		</div>
				    	</div>
				    	<div class="section">
				    		<div class="<% if(FORMSTATUS.get("REJECTED_SECTION") != null && FORMSTATUS.get("REJECTED_SECTION").contains("reject_section3")){  %> sectionHeaderRej <%}else{ %> sectionHeader <%} %>">
				    			EXISTING ACCOUNTS MAINTAINED WITH AMANA BANK
				    		</div>
				    		<div class="sectionBody">
				    			<table class="table table-bordered">
				    				<tr>
				    					<td>
				    						<table width="100%">
				    							<tr>
				    								<td <% if(AOFDisabledFiledsMap.isFieldDisabled("EXIST_BANK_ACC_NO_1")){ %>class="red" <%} %>>Account No</td>
				    								<td><input type="text" class="form-control input-sm" name="EXIST_BANK_ACC_NO_1" value="<%= cifData.get("EXIST_BANK_ACC_NO_1") != null ? cifData.get("EXIST_BANK_ACC_NO_1") : "" %>"
				    								<% if(AOFDisabledFiledsMap.isFieldDisabled("EXIST_BANK_ACC_NO_1")){ %> readonly="readonly" <%} %>/></td>
				    							</tr>
				    							<tr>
				    								<td <% if(AOFDisabledFiledsMap.isFieldDisabled("EXIST_BANK_ACC_TYPE_1")){ %>class="red" <%} %>>Account Type</td>
				    								<td>
				    									<table width="100%">
				    										<tr>
				    											<td>
				    												<input type="radio" name="EXIST_BANK_ACC_TYPE_1" id="existingAccountTypeAmana11" value="SA" <% if("SA".equals(cifData.get("EXIST_BANK_ACC_TYPE_1"))){ %> checked="checked" <% }%>
				    												<% if(AOFDisabledFiledsMap.isFieldDisabled("EXIST_BANK_ACC_TYPE_1")){ %> onclick="return forceCheck(this,'<%=cifData.get("EXIST_BANK_ACC_TYPE_1")%>')" <%} %>>
				    												<label for="existingAccountTypeAmana11">Savings Account</label>
				    											</td>
				    											<td>
				    												<input type="radio" name="EXIST_BANK_ACC_TYPE_1" id="existingAccountTypeAmana12" value="CA" <% if("CA".equals(cifData.get("EXIST_BANK_ACC_TYPE_1"))){ %> checked="checked" <% }%>
				    												<% if(AOFDisabledFiledsMap.isFieldDisabled("EXIST_BANK_ACC_TYPE_1")){ %> onclick="return forceCheck(this,'<%=cifData.get("EXIST_BANK_ACC_TYPE_1")%>')" <%} %>>
				    												<label for="existingAccountTypeAmana12">Current Account</label>
				    											</td>
				    											<td>
				    												<input type="radio" name="EXIST_BANK_ACC_TYPE_1" id="existingAccountTypeAmana13" value="TD" <% if("TD".equals(cifData.get("EXIST_BANK_ACC_TYPE_1"))){ %> checked="checked" <% }%>
				    												<% if(AOFDisabledFiledsMap.isFieldDisabled("EXIST_BANK_ACC_TYPE_1")){ %> onclick="return forceCheck(this,'<%=cifData.get("EXIST_BANK_ACC_TYPE_1")%>')" <%} %>>
				    												<label for="existingAccountTypeAmana13">Term Deposite</label>
				    											</td>
				    											<td>
				    												<input type="radio" name="EXIST_BANK_ACC_TYPE_1" id="existingAccountTypeAmana14" value="OT" <% if("OT".equals(cifData.get("EXIST_BANK_ACC_TYPE_1"))){ %> checked="checked" <% }%>
				    												<% if(AOFDisabledFiledsMap.isFieldDisabled("EXIST_BANK_ACC_TYPE_1")){ %> onclick="return forceCheck(this,'<%=cifData.get("EXIST_BANK_ACC_TYPE_1")%>')" <%} %>>
				    												<label for="existingAccountTypeAmana14">
				    													Other: <input type="text" name="EXIST_BANK_ACC_TYPE_1_OTR" class="input-ovr"
				    													<% if(AOFDisabledFiledsMap.isFieldDisabled("EXIST_BANK_ACC_TYPE_1")){ %> readonly="readonly" <%} %>
							    										<% if("OT".equals(cifData.get("EXIST_BANK_ACC_TYPE_1"))){ %>
							    											value="<%= cifData.get("EXIST_BANK_ACC_TYPE_1_OTR") != null ? cifData.get("EXIST_BANK_ACC_TYPE_1_OTR") : "" %>"
							    										<% }%>
							    										/>
				    												</label>
				    											</td>
				    										</tr>
				    									</table>
				    								</td>
				    							</tr>
				    							<tr>
				    								<td <% if(AOFDisabledFiledsMap.isFieldDisabled("EXIST_BANK_ACC_BRANCH_1")){ %>class="red" <%} %>>Name of Account Branch</td>
				    								<td><input type="text" class="form-control input-sm" name="EXIST_BANK_ACC_BRANCH_1" value="<%= cifData.get("EXIST_BANK_ACC_BRANCH_1") != null ? cifData.get("EXIST_BANK_ACC_BRANCH_1") : "" %>"
				    								<% if(AOFDisabledFiledsMap.isFieldDisabled("EXIST_BANK_ACC_BRANCH_1")){ %> readonly="readonly" <%} %>/></td>
				    							</tr>
				    						</table>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td>
				    						<table width="100%">
				    							<tr>
				    								<td <% if(AOFDisabledFiledsMap.isFieldDisabled("EXIST_BANK_ACC_NO_2")){ %>class="red" <%} %>>Account No</td>
				    								<td><input type="text" class="form-control input-sm" name="EXIST_BANK_ACC_NO_2" value="<%= cifData.get("EXIST_BANK_ACC_NO_2") != null ? cifData.get("EXIST_BANK_ACC_NO_2") : "" %>"
				    								<% if(AOFDisabledFiledsMap.isFieldDisabled("EXIST_BANK_ACC_NO_2")){ %> readonly="readonly" <%} %>/></td>
				    							</tr>
				    							<tr>
				    								<td <% if(AOFDisabledFiledsMap.isFieldDisabled("EXIST_BANK_ACC_TYPE_2")){ %>class="red" <%} %>>Account Type</td>
				    								<td>
				    									<table width="100%">
				    										<tr>
				    											<td>
				    												<input type="radio" name="EXIST_BANK_ACC_TYPE_2" id="existingAccountTypeAmana21" value="SA" <% if("SA".equals(cifData.get("EXIST_BANK_ACC_TYPE_2"))){ %> checked="checked" <% }%>
				    												<% if(AOFDisabledFiledsMap.isFieldDisabled("EXIST_BANK_ACC_TYPE_2")){ %> onclick="return forceCheck(this,'<%=cifData.get("EXIST_BANK_ACC_TYPE_2")%>')" <%} %>>
				    												<label for="existingAccountTypeAmana21">Savings Account</label>
				    											</td>
				    											<td>
				    												<input type="radio" name="EXIST_BANK_ACC_TYPE_2" id="existingAccountTypeAmana22" value="CA" <% if("CA".equals(cifData.get("EXIST_BANK_ACC_TYPE_2"))){ %> checked="checked" <% }%>
				    												<% if(AOFDisabledFiledsMap.isFieldDisabled("EXIST_BANK_ACC_TYPE_2")){ %> onclick="return forceCheck(this,'<%=cifData.get("EXIST_BANK_ACC_TYPE_2")%>')" <%} %>>
				    												<label for="existingAccountTypeAmana22">Current Account</label>
				    											</td>
				    											<td>
				    												<input type="radio" name="EXIST_BANK_ACC_TYPE_2" id="existingAccountTypeAmana23" value="TD" <% if("TD".equals(cifData.get("EXIST_BANK_ACC_TYPE_2"))){ %> checked="checked" <% }%>
				    												<% if(AOFDisabledFiledsMap.isFieldDisabled("EXIST_BANK_ACC_TYPE_2")){ %> onclick="return forceCheck(this,'<%=cifData.get("EXIST_BANK_ACC_TYPE_2")%>')" <%} %>>
				    												<label for="existingAccountTypeAmana23">Term Deposite</label>
				    											</td>
				    											<td>
				    												<input type="radio" name="EXIST_BANK_ACC_TYPE_2" id="existingAccountTypeAmana24" value="OT" <% if("OT".equals(cifData.get("EXIST_BANK_ACC_TYPE_2"))){ %> checked="checked" <% }%>
				    												<% if(AOFDisabledFiledsMap.isFieldDisabled("EXIST_BANK_ACC_TYPE_2")){ %> onclick="return forceCheck(this,'<%=cifData.get("EXIST_BANK_ACC_TYPE_2")%>')" <%} %>>
				    												<label for="existingAccountTypeAmana24">
				    													Other: <input type="text" name="EXIST_BANK_ACC_TYPE_2_OTR" class="input-ovr"
				    													<% if(AOFDisabledFiledsMap.isFieldDisabled("EXIST_BANK_ACC_TYPE_2")){ %> readonly="readonly" <%} %>
							    										<% if("OT".equals(cifData.get("EXIST_BANK_ACC_TYPE_2"))){ %>
							    											value="<%= cifData.get("EXIST_BANK_ACC_TYPE_2_OTR") != null ? cifData.get("EXIST_BANK_ACC_TYPE_2_OTR") : "" %>"
							    										<% }%>
							    										/>
				    												</label>
				    											</td>
				    										</tr>
				    									</table>
				    								</td>
				    							</tr>
				    							<tr>
				    								<td <% if(AOFDisabledFiledsMap.isFieldDisabled("EXIST_BANK_ACC_BRANCH_2")){ %>class="red" <%} %>>Name of Account Branch</td>
				    								<td><input type="text" class="form-control input-sm" name="EXIST_BANK_ACC_BRANCH_2" value="<%= cifData.get("EXIST_BANK_ACC_BRANCH_2") != null ? cifData.get("EXIST_BANK_ACC_BRANCH_2") : "" %>"
				    								<% if(AOFDisabledFiledsMap.isFieldDisabled("EXIST_BANK_ACC_BRANCH_2")){ %> readonly="readonly" <%} %>/></td>
				    							</tr>
				    						</table>
				    					</td>
				    				</tr>
				    			</table>
				    		</div>
				    		<% if(canEdit.equals("Y")){ %>
					    	<div class="sectionFooter">
				    			<input name="formSave" type="submit" value="Save" class="btn btn-success"/>
				    			<input name="formClose" type="submit" value="Save & Close" class="btn btn-info"/>
				    		</div>
				    		<%} %>
				    	</div>
				    	<div class="section">
				    		<div class="<% if(FORMSTATUS.get("REJECTED_SECTION") != null && FORMSTATUS.get("REJECTED_SECTION").contains("reject_section4")){  %> sectionHeaderRej <%}else{ %> sectionHeader <%} %>">
				    			ACCOUNTS HELD IN OTHER BANKS
				    		</div>
				    		<div class="sectionBody">
				    			<table class="table table-bordered">
				    				<tr>
				    					<td>
				    						<table width="100%">
				    							<tr>
				    								<td <% if(AOFDisabledFiledsMap.isFieldDisabled("EXIST_OTHER_ACC_NO_1")){ %>class="red" <%} %>>Account No</td>
				    								<td><input type="text" class="form-control input-sm" name="EXIST_OTHER_ACC_NO_1"  value="<%= cifData.get("EXIST_OTHER_ACC_NO_1") != null ? cifData.get("EXIST_OTHER_ACC_NO_1") : "" %>"
				    								<% if(AOFDisabledFiledsMap.isFieldDisabled("EXIST_OTHER_ACC_NO_1")){ %> readonly="readonly" <%} %>/></td>
				    							</tr>
				    							<tr>
				    								<td <% if(AOFDisabledFiledsMap.isFieldDisabled("EXIST_OTHER_ACC_TYPE_1")){ %>class="red" <%} %>>Account Type</td>
				    								<td>
				    									<table width="100%">
							    							<tr>
							    								<td>
							    									<input type="radio" name="EXIST_OTHER_ACC_TYPE_1" id="existingAccountTypeOther11" value="SA" <% if("SA".equals(cifData.get("EXIST_OTHER_ACC_TYPE_1"))){ %> checked="checked" <% }%>
							    									<% if(AOFDisabledFiledsMap.isFieldDisabled("EXIST_OTHER_ACC_TYPE_1")){ %> onclick="return forceCheck(this,'<%=cifData.get("EXIST_OTHER_ACC_TYPE_1")%>')" <%} %>>
							    									<label for="existingAccountTypeOther11">Savings Account</label>
							    								</td>
							    								<td>
							    									<input type="radio" name="EXIST_OTHER_ACC_TYPE_1" id="existingAccountTypeOther12" value="CA" <% if("CA".equals(cifData.get("EXIST_OTHER_ACC_TYPE_1"))){ %> checked="checked" <% }%>
							    									<% if(AOFDisabledFiledsMap.isFieldDisabled("EXIST_OTHER_ACC_TYPE_1")){ %> onclick="return forceCheck(this,'<%=cifData.get("EXIST_OTHER_ACC_TYPE_1")%>')" <%} %>>
							    									<label for="existingAccountTypeOther12">Current Account</label>
							    								</td>
							    								<td>
							    									<input type="radio" name="EXIST_OTHER_ACC_TYPE_1" id="existingAccountTypeOther13" value="TD" <% if("TD".equals(cifData.get("EXIST_OTHER_ACC_TYPE_1"))){ %> checked="checked" <% }%>
							    									<% if(AOFDisabledFiledsMap.isFieldDisabled("EXIST_OTHER_ACC_TYPE_1")){ %> onclick="return forceCheck(this,'<%=cifData.get("EXIST_OTHER_ACC_TYPE_1")%>')" <%} %>>
							    									<label for="existingAccountTypeOther13">Term Deposite</label>
							    								</td>
							    								<td>
							    									<input type="radio" name="EXIST_OTHER_ACC_TYPE_1" id="existingAccountTypeOther14" value="OT" <% if("OT".equals(cifData.get("EXIST_OTHER_ACC_TYPE_1"))){ %> checked="checked" <% }%>
							    									<% if(AOFDisabledFiledsMap.isFieldDisabled("EXIST_OTHER_ACC_TYPE_1")){ %> onclick="return forceCheck(this,'<%=cifData.get("EXIST_OTHER_ACC_TYPE_1")%>')" <%} %>>
							    									<label for="existingAccountTypeOther14">
							    										Other: <input type="text" name="EXIST_OTHER_ACC_TYPE_1_OTR" class="input-ovr"
							    										<% if(AOFDisabledFiledsMap.isFieldDisabled("EXIST_OTHER_ACC_TYPE_1")){ %> readonly="readonly" <%} %>
							    										<% if("OT".equals(cifData.get("EXIST_OTHER_ACC_TYPE_1"))){ %>
							    											value="<%= cifData.get("EXIST_OTHER_ACC_TYPE_1_OTR") != null ? cifData.get("EXIST_OTHER_ACC_TYPE_1_OTR") : "" %>"
							    										<% }%>
							    										/>
							    									</label>
							    								</td>
							    							</tr>
							    						</table>
				    								</td>
				    							</tr>
				    							<tr>
				    								<td <% if(AOFDisabledFiledsMap.isFieldDisabled("EXIST_OTHER_ACC_BRANCH_1")){ %>class="red" <%} %>>Name of Account Branch</td>
				    								<td><input type="text" class="form-control input-sm" name="EXIST_OTHER_ACC_BRANCH_1" value="<%= cifData.get("EXIST_OTHER_ACC_BRANCH_1") != null ? cifData.get("EXIST_OTHER_ACC_BRANCH_1") : "" %>"
				    								<% if(AOFDisabledFiledsMap.isFieldDisabled("EXIST_OTHER_ACC_BRANCH_1")){ %> readonly="readonly" <%} %>/>
				    							</tr>
				    						</table>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td>
				    						<table width="100%">
				    							<tr>
				    								<td <% if(AOFDisabledFiledsMap.isFieldDisabled("EXIST_OTHER_ACC_NO_2")){ %>class="red" <%} %>>Account No</td>
				    								<td><input type="text" class="form-control input-sm" name="EXIST_OTHER_ACC_NO_2" value="<%= cifData.get("EXIST_OTHER_ACC_NO_2") != null ? cifData.get("EXIST_OTHER_ACC_NO_2") : "" %>"
				    								<% if(AOFDisabledFiledsMap.isFieldDisabled("EXIST_OTHER_ACC_NO_2")){ %> readonly="readonly" <%} %>/></td>
				    							</tr>
				    							<tr>
				    								<td <% if(AOFDisabledFiledsMap.isFieldDisabled("EXIST_OTHER_ACC_TYPE_2")){ %>class="red" <%} %>>Account Type</td>
				    								<td>
				    									<table width="100%">
							    							<tr>
							    								<td>
							    									<input type="radio" name="EXIST_OTHER_ACC_TYPE_2" id="existingAccountTypeOther21" value="SA" <% if("SA".equals(cifData.get("EXIST_OTHER_ACC_TYPE_2"))){ %> checked="checked" <% }%>
							    									<% if(AOFDisabledFiledsMap.isFieldDisabled("EXIST_OTHER_ACC_TYPE_2")){ %> onclick="return forceCheck(this,'<%=cifData.get("EXIST_OTHER_ACC_TYPE_2")%>')" <%} %>>
							    									<label for="existingAccountTypeOther21">Savings Account</label>
							    								</td>
							    								<td>
							    									<input type="radio" name="EXIST_OTHER_ACC_TYPE_2" id="existingAccountTypeOther22" value="CA" <% if("CA".equals(cifData.get("EXIST_OTHER_ACC_TYPE_2"))){ %> checked="checked" <% }%>
							    									<% if(AOFDisabledFiledsMap.isFieldDisabled("EXIST_OTHER_ACC_TYPE_2")){ %> onclick="return forceCheck(this,'<%=cifData.get("EXIST_OTHER_ACC_TYPE_2")%>')" <%} %>>
							    									<label for="existingAccountTypeOther22">Current Account</label>
							    								</td>
							    								<td>
							    									<input type="radio" name="EXIST_OTHER_ACC_TYPE_2" id="existingAccountTypeOther23" value="TD" <% if("TD".equals(cifData.get("EXIST_OTHER_ACC_TYPE_2"))){ %> checked="checked" <% }%>
							    									<% if(AOFDisabledFiledsMap.isFieldDisabled("EXIST_OTHER_ACC_TYPE_2")){ %> onclick="return forceCheck(this,'<%=cifData.get("EXIST_OTHER_ACC_TYPE_2")%>')" <%} %>>
							    									<label for="existingAccountTypeOther23">Term Deposite</label>
							    								</td>
							    								<td>
							    									<input type="radio" name="EXIST_OTHER_ACC_TYPE_2" id="existingAccountTypeOther24" value="OT" <% if("OT".equals(cifData.get("EXIST_OTHER_ACC_TYPE_2"))){ %> checked="checked" <% }%>
							    									<% if(AOFDisabledFiledsMap.isFieldDisabled("EXIST_OTHER_ACC_TYPE_2")){ %> onclick="return forceCheck(this,'<%=cifData.get("EXIST_OTHER_ACC_TYPE_2")%>')" <%} %>>
							    									<label for="existingAccountTypeOther24">
							    										Other: <input type="text" name="EXIST_OTHER_ACC_TYPE_2_OTR" class="input-ovr"
							    										<% if(AOFDisabledFiledsMap.isFieldDisabled("EXIST_OTHER_ACC_TYPE_2")){ %> readonly="readonly" <%} %>
							    										<% if("OT".equals(cifData.get("EXIST_OTHER_ACC_TYPE_2"))){ %>
							    											value="<%= cifData.get("EXIST_OTHER_ACC_TYPE_2_OTR") != null ? cifData.get("EXIST_OTHER_ACC_TYPE_2_OTR") : "" %>"
							    										<% }%>
							    										/>
							    									</label>
							    								</td>
							    							</tr>
							    						</table>
				    								</td>
				    							</tr>
				    							<tr>
				    								<td <% if(AOFDisabledFiledsMap.isFieldDisabled("EXIST_OTHER_ACC_BRANCH_2")){ %>class="red" <%} %>>Name of Account Branch</td>
				    								<td><input type="text" class="form-control input-sm" name="EXIST_OTHER_ACC_BRANCH_2" value="<%= cifData.get("EXIST_OTHER_ACC_BRANCH_2") != null ? cifData.get("EXIST_OTHER_ACC_BRANCH_2") : "" %>"
				    								<% if(AOFDisabledFiledsMap.isFieldDisabled("EXIST_OTHER_ACC_BRANCH_2")){ %> readonly="readonly" <%} %>/></td>
				    							</tr>
				    						</table>
				    					</td>
				    				</tr>
				    			</table>
				    		</div>
				    		<% if(canEdit.equals("Y")){ %>
					    	<div class="sectionFooter">
				    			<input name="formSave" type="submit" value="Save" class="btn btn-success"/>
				    			<input name="formClose" type="submit" value="Save & Close" class="btn btn-info"/>
				    		</div>
				    		<%} %>
				    	</div>
				    	<div class="section">
				    		<div class="<% if(FORMSTATUS.get("REJECTED_SECTION") != null && FORMSTATUS.get("REJECTED_SECTION").contains("reject_section5")){  %> sectionHeaderRej <%}else{ %> sectionHeader <%} %>">
				    			INSTRUCTIONS TO BANK
				    		</div>
				    		<div class="sectionBody">
				    			<table class="table">
				    				<tr>
				    					<td <% if(AOFDisabledFiledsMap.isFieldDisabled("INSTRUCTION_TO_BANK")){ %> class="red" <%} %>>
				    						We authorise the Bank to act on instruction given by us by Facsimile message / Email or other similar medium
				    					</td>
				    				</tr>
				    				<tr>
				    					<td>
				    						<ul class="inlineUL">
				    							<li>
				    								<input type="radio" name="INSTRUCTION_TO_BANK" id="instractionToBank1" value="Y" <% if("Y".equals(cifData.get("INSTRUCTION_TO_BANK"))){%> checked="checked" <%} %>
				    								<% if(AOFDisabledFiledsMap.isFieldDisabled("INSTRUCTION_TO_BANK")){ %> onclick="return forceCheck(this,'<%=cifData.get("INSTRUCTION_TO_BANK")%>')" <%} %>>
				    								<label for="instractionToBank1">Yes - Duly completed Indemnity form is attached</label>
				    							</li>
				    							<li>
				    								<input type="radio" name="INSTRUCTION_TO_BANK" id="instractionToBank2" value="N" <% if("N".equals(cifData.get("INSTRUCTION_TO_BANK"))){%> checked="checked" <%} %>
				    								<% if(AOFDisabledFiledsMap.isFieldDisabled("INSTRUCTION_TO_BANK")){ %> onclick="return forceCheck(this,'<%=cifData.get("INSTRUCTION_TO_BANK")%>')" <%} %>>
				    								<label for="instractionToBank2">No</label>
				    							</li>
				    						</ul>
				    					</td>
				    				</tr>
				    			</table>
				    		</div>
				    		<% if(canEdit.equals("Y")){ %>
					    	<div class="sectionFooter">
				    			<input name="formSave" type="submit" value="Save" class="btn btn-success"/>
				    			<input name="formClose" type="submit" value="Save & Close" class="btn btn-info"/>
				    		</div>
				    		<%} %>
				    	</div>
				    </div>
				    <div role="tabpanel" class="tab-pane" id="category2">
				    	<div class="section">
				    		<div class="sectionHeader">
				    			Accounts assigned for Modification
				    		</div>
				    		<div class="sectionBody">
				    			<table class="table table-bordered table-stripped" width="100%">
				    			<%
				    			if(accountsAndMandates != null && accountsAndMandates.size() > 0){
				    				Iterator<String> accountItr = accountsAndMandates.keySet().iterator();
				    				while(accountItr.hasNext()){
				    					String listAccountNo = accountItr.next();
				    					List<Map<String, String>> mandates = accountsAndMandates.get(listAccountNo);
					    					%>
					    					<tr>
					    						<td style="text-align: center;">
					    							<button type="button" class="btn btn-sm <% if(FORMSTATUS.get("REJECTED_SECTION") != null && FORMSTATUS.get("REJECTED_SECTION").contains("accountSection_"+listAccountNo)){  %> btn-danger <%}else{ %> btn-primary <%} %> addAccountHolderModal" cSector="ACC" cCIF="<%=cifNo%>" cAccountNo="<%=listAccountNo%>" cCaseNo=<%=caseNo%>><%=listAccountNo%></button>
					    						</td>
					    						<td style="text-align: center;">
					    							<% for(int i = 0; i < mandates.size(); i++){
								    					Map<String, String> mandate = mandates.get(i); 
								    				%>
								    					<a class="nav-link" href="javascript:void(0)" onclick="viewServerDocument('<%=mandate.get("SEQ_NO")%>','<%=listAccountNo%>','Y')"><%=mandate.get("FILE_NAME")%></a>
								    					<br/><br/>
								    				<% } %>
					    						</td>
					    					</tr>
					    					<%
				    					}
				    				}
				    			%>
					    		</table>
					    	</div>
					    	<% if(canEdit.equals("Y")){ %>
					    	<div class="sectionFooter">
				    			<input name="formSave" type="submit" value="Save" class="btn btn-success"/>
				    			<input name="formClose" type="submit" value="Save & Close" class="btn btn-info"/>
				    		</div>
				    		<%} %>
					    </div>
				    </div>
				    <div role="tabpanel" class="tab-pane" id="category8">
				    	<div class="section">
				    		<div class="<% if(FORMSTATUS.get("REJECTED_SECTION") != null && FORMSTATUS.get("REJECTED_SECTION").contains("reject_section8")){  %> sectionHeaderRej <%}else{ %> sectionHeader <%} %>">
				    			AML Risk Categorization : Client Type
				    		</div>
				    		<div class="sectionBody">
				    			<table class="table table-bordered table-stripped" width="100%">
				    				<tr>
				    					<th width="33%" style="text-align: center;">Low</th>
				    					<th width="33%" style="text-align: center;">Medium</th>
				    					<th width="34%" style="text-align: center;">High</th>
				    				</tr>
				    				<tr>
				    					<td>
				    						<input type="radio" id="riskRatingCat1Low1" riskRating="1" name="RISK_RATING_CAT1" value="RR_CAT1_L1" <%if("RR_CAT1_L1".equals(cifData.get("RISK_RATING_CAT1"))){%> checked="checked" <%} %>
				    						<% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT1")){ %> onclick="return forceCheck(this,'<%=cifData.get("RISK_RATING_CAT1")%>')" <%} %>>
				    						<label <% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT1")){ %> class="red" <%} %> for="riskRatingCat1Low1">Student / Housewife / Pensioner</label>
				    					</td>
				    					<td>
				    						<input type="radio" id="riskRatingCat1Mid1" riskRating="2" name="RISK_RATING_CAT1" value="RR_CAT1_M1" <%if("RR_CAT1_M1".equals(cifData.get("RISK_RATING_CAT1"))){%> checked="checked" <%} %>
				    						<% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT1")){ %> onclick="return forceCheck(this,'<%=cifData.get("RISK_RATING_CAT1")%>')" <%} %>>
				    						<label <% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT1")){ %> class="red" <%} %> for="riskRatingCat1Mid1">Employee Executive Government</label>
				    					</td>
				    					<td>
				    						<input type="radio" id="riskRatingCat1High1" riskRating="3" name="RISK_RATING_CAT1" value="RR_CAT1_H1" <%if("RR_CAT1_H1".equals(cifData.get("RISK_RATING_CAT1"))){%> checked="checked" <%} %>
				    						<% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT1")){ %> onclick="return forceCheck(this,'<%=cifData.get("RISK_RATING_CAT1")%>')" <%} %>>
				    						<label <% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT1")){ %> class="red" <%} %> for="riskRatingCat1High1">Government Institution</label>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td>
				    						<input type="radio" id="riskRatingCat1Low2" riskRating="1" name="RISK_RATING_CAT1" value="RR_CAT1_L2" <%if("RR_CAT1_L2".equals(cifData.get("RISK_RATING_CAT1"))){%> checked="checked" <%} %>
				    						<% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT1")){ %> onclick="return forceCheck(this,'<%=cifData.get("RISK_RATING_CAT1")%>')" <%} %>>
				    						<label <% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT1")){ %> class="red" <%} %> for="riskRatingCat1Low2">Employee - Non Executive Private</label>
				    					</td>
				    					<td>
				    						<input type="radio" id="riskRatingCat1Mid2" riskRating="2" name="RISK_RATING_CAT1" value="RR_CAT1_M2" <%if("RR_CAT1_M2".equals(cifData.get("RISK_RATING_CAT1"))){%> checked="checked" <%} %>
				    						<% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT1")){ %> onclick="return forceCheck(this,'<%=cifData.get("RISK_RATING_CAT1")%>')" <%} %>>
				    						<label <% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT1")){ %> class="red" <%} %> for="riskRatingCat1Mid2">Employee - Non Executive Government</label>
				    					</td>
				    					<td>
				    						<input type="radio" id="riskRatingCat1High2" riskRating="3" name="RISK_RATING_CAT1" value="RR_CAT1_H2" <%if("RR_CAT1_H2".equals(cifData.get("RISK_RATING_CAT1"))){%> checked="checked" <%} %>
				    						<% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT1")){ %> onclick="return forceCheck(this,'<%=cifData.get("RISK_RATING_CAT1")%>')" <%} %>>
				    						<label <% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT1")){ %> class="red" <%} %> for="riskRatingCat1High2">Charity/NGO</label>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td>
				    						<input type="radio" id="riskRatingCat1Low3" riskRating="1" name="RISK_RATING_CAT1" value="RR_CAT1_L3" <%if("RR_CAT1_L3".equals(cifData.get("RISK_RATING_CAT1"))){%> checked="checked" <%} %>
				    						<% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT1")){ %> onclick="return forceCheck(this,'<%=cifData.get("RISK_RATING_CAT1")%>')" <%} %>>
				    						<label <% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT1")){ %> class="red" <%} %> for="riskRatingCat1Low3">Public Limited Liability Company</label>
				    					</td>
				    					<td>
				    						<input type="radio" id="riskRatingCat1Mid3" riskRating="2" name="RISK_RATING_CAT1" value="RR_CAT1_M3" <%if("RR_CAT1_M3".equals(cifData.get("RISK_RATING_CAT1"))){%> checked="checked" <%} %>
				    						<% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT1")){ %> onclick="return forceCheck(this,'<%=cifData.get("RISK_RATING_CAT1")%>')" <%} %>>
				    						<label <% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT1")){ %> class="red" <%} %> for="riskRatingCat1Mid3">Employee - Executive Privater</label>
				    					</td>
				    					<td>
				    						<input type="radio" id="riskRatingCat1High3" riskRating="3" name="RISK_RATING_CAT1" value="RR_CAT1_H3" <%if("RR_CAT1_H3".equals(cifData.get("RISK_RATING_CAT1"))){%> checked="checked" <%} %>
				    						<% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT1")){ %> onclick="return forceCheck(this,'<%=cifData.get("RISK_RATING_CAT1")%>')" <%} %>>
				    						<label <% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT1")){ %> class="red" <%} %> for="riskRatingCat1High3">PEP's</label>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td>
				    						<input type="radio" id="riskRatingCat1Low4" riskRating="1" name="RISK_RATING_CAT1" value="RR_CAT1_L4" <%if("RR_CAT1_L4".equals(cifData.get("RISK_RATING_CAT1"))){%> checked="checked" <%} %>
				    						<% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT1")){ %> onclick="return forceCheck(this,'<%=cifData.get("RISK_RATING_CAT1")%>')" <%} %>>
				    						<label <% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT1")){ %> class="red" <%} %> for="riskRatingCat1Low4">Business - Individual</label>
				    					</td>
				    					<td>
				    						<input type="radio" id="riskRatingCat1Mid4" riskRating="2" name="RISK_RATING_CAT1" value="RR_CAT1_M4" <%if("RR_CAT1_M4".equals(cifData.get("RISK_RATING_CAT1"))){%> checked="checked" <%} %>
				    						<% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT1")){ %> onclick="return forceCheck(this,'<%=cifData.get("RISK_RATING_CAT1")%>')" <%} %>>
				    						<label <% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT1")){ %> class="red" <%} %> for="riskRatingCat1Mid4">Lawyer & Accountant</label>
				    					</td>
				    					<td>
				    						<input type="radio" id="riskRatingCat1High4" riskRating="3" name="RISK_RATING_CAT1" value="RR_CAT1_H4" <%if("RR_CAT1_H4".equals(cifData.get("RISK_RATING_CAT1"))){%> checked="checked" <%} %>
				    						<% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT1")){ %> onclick="return forceCheck(this,'<%=cifData.get("RISK_RATING_CAT1")%>')" <%} %>>
				    						<label <% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT1")){ %> class="red" <%} %> for="riskRatingCat1High4">Off shore/Nonresident Company</label>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td>
				    						<input type="radio" id="riskRatingCat1Low5" riskRating="1" name="RISK_RATING_CAT1" value="RR_CAT1_L5" <%if("RR_CAT1_L5".equals(cifData.get("RISK_RATING_CAT1"))){%> checked="checked" <%} %>
				    						<% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT1")){ %> onclick="return forceCheck(this,'<%=cifData.get("RISK_RATING_CAT1")%>')" <%} %>>
				    						<label <% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT1")){ %> class="red" <%} %> for="riskRatingCat1Low5">Club / Society / Association</label>
				    					</td>
				    					<td>
				    						<input type="radio" id="riskRatingCat1Mid5" riskRating="2" name="RISK_RATING_CAT1" value="RR_CAT1_M5" <%if("RR_CAT1_M5".equals(cifData.get("RISK_RATING_CAT1"))){%> checked="checked" <%} %>
				    						<% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT1")){ %> onclick="return forceCheck(this,'<%=cifData.get("RISK_RATING_CAT1")%>')" <%} %>>
				    						<label <% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT1")){ %> class="red" <%} %> for="riskRatingCat1Mid5">Private Limited Liability Company</label>
				    					</td>
				    					<td>
				    						<input type="radio" id="riskRatingCat1High5" riskRating="3" name="RISK_RATING_CAT1" value="RR_CAT1_H5" <%if("RR_CAT1_H5".equals(cifData.get("RISK_RATING_CAT1"))){%> checked="checked" <%} %>
				    						<% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT1")){ %> onclick="return forceCheck(this,'<%=cifData.get("RISK_RATING_CAT1")%>')" <%} %>>
				    						<label <% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT1")){ %> class="red" <%} %> for="riskRatingCat1High5">Foreign Citizen</label>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td>
				    						<input type="radio" id="riskRatingCat1Low6" riskRating="1" name="RISK_RATING_CAT1" value="RR_CAT1_L6" <%if("RR_CAT1_L6".equals(cifData.get("RISK_RATING_CAT1"))){%> checked="checked" <%} %>
				    						<% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT1")){ %> onclick="return forceCheck(this,'<%=cifData.get("RISK_RATING_CAT1")%>')" <%} %>>
				    						<label <% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT1")){ %> class="red" <%} %> for="riskRatingCat1Low6">Educational Institution</label>
				    					</td>
				    					<td>
				    						<input type="radio" id="riskRatingCat1Mid6" riskRating="2" name="RISK_RATING_CAT1" value="RR_CAT1_M6" <%if("RR_CAT1_M6".equals(cifData.get("RISK_RATING_CAT1"))){%> checked="checked" <%} %>
				    						<% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT1")){ %> onclick="return forceCheck(this,'<%=cifData.get("RISK_RATING_CAT1")%>')" <%} %>>
				    						<label <% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT1")){ %> class="red" <%} %> for="riskRatingCat1Mid6">Business- Proprietor / Partnership</label>
				    					</td>
				    					<td>
				    						<input type="radio" id="riskRatingCat1High6" riskRating="3" name="RISK_RATING_CAT1" value="RR_CAT1_H6" <%if("RR_CAT1_H6".equals(cifData.get("RISK_RATING_CAT1"))){%> checked="checked" <%} %>
				    						<% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT1")){ %> onclick="return forceCheck(this,'<%=cifData.get("RISK_RATING_CAT1")%>')" <%} %>>
				    						<label <% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT1")){ %> class="red" <%} %> for="riskRatingCat1High6">BOI/Foreign Collaborations</label>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td>
				    						<input type="radio" id="riskRatingCat1Low7" riskRating="1" name="RISK_RATING_CAT1" value="RR_CAT1_L7" <%if("RR_CAT1_L7".equals(cifData.get("RISK_RATING_CAT1"))){%> checked="checked" <%} %>
				    						<% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT1")){ %> onclick="return forceCheck(this,'<%=cifData.get("RISK_RATING_CAT1")%>')" <%} %>>
				    						<label <% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT1")){ %> class="red" <%} %> for="riskRatingCat1Low7">Self Employed - Professional</label>
				    					</td>
				    					<td>
				    						<input type="radio" id="riskRatingCat1Mid7" riskRating="2" name="RISK_RATING_CAT1" value="RR_CAT1_M7" <%if("RR_CAT1_M7".equals(cifData.get("RISK_RATING_CAT1"))){%> checked="checked" <%} %>
				    						<% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT1")){ %> onclick="return forceCheck(this,'<%=cifData.get("RISK_RATING_CAT1")%>')" <%} %>>
				    						<label <% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT1")){ %> class="red" <%} %> for="riskRatingCat1Mid7">Other Individuals</label>
				    					</td>
				    					<td>
				    						&nbsp;
				    					</td>
				    				</tr>
				    			</table>
				    		</div>
				    	</div>
				    	<div class="section">
				    		<div class="<% if(FORMSTATUS.get("REJECTED_SECTION") != null && FORMSTATUS.get("REJECTED_SECTION").contains("reject_section8")){  %> sectionHeaderRej <%}else{ %> sectionHeader <%} %>">
				    			AML Risk Categorization : Business Trade Usage
				    		</div>
				    		<div class="sectionBody">
				    			<table class="table table-bordered table-stripped" width="100%">
				    				<tr>
				    					<th width="33%" style="text-align: center;">Low</th>
				    					<th width="33%" style="text-align: center;">Medium</th>
				    					<th width="34%" style="text-align: center;">High</th>
				    				</tr>
				    				<tr>
				    					<td>
				    						<input type="radio" id="riskRatingCat2Low1" riskRating="1" name="RISK_RATING_CAT2" value="RR_CAT2_L1" <%if("RR_CAT2_L1".equals(cifData.get("RISK_RATING_CAT2"))){%> checked="checked" <%} %>
				    						<% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT2")){ %> onclick="return forceCheck(this,'<%=cifData.get("RISK_RATING_CAT2")%>')" <%} %>>
				    						<label <% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT2")){ %> class="red" <%} %> for="riskRatingCat2Low1">Dealer in petroleum products</label>
				    					</td>
				    					<td>
				    						<input type="radio" id="riskRatingCat2Mid1" riskRating="2" name="RISK_RATING_CAT2" value="RR_CAT2_M1" <%if("RR_CAT2_M1".equals(cifData.get("RISK_RATING_CAT2"))){%> checked="checked" <%} %>
				    						<% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT2")){ %> onclick="return forceCheck(this,'<%=cifData.get("RISK_RATING_CAT2")%>')" <%} %>>
				    						<label <% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT2")){ %> class="red" <%} %> for="riskRatingCat2Mid1">Personal/ Family Use</label>
				    					</td>
				    					<td>
				    						<input type="radio" id="riskRatingCat2High1" riskRating="3" name="RISK_RATING_CAT2" value="RR_CAT2_H1" <%if("RR_CAT2_H1".equals(cifData.get("RISK_RATING_CAT2"))){%> checked="checked" <%} %>
				    						<% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT2")){ %> onclick="return forceCheck(this,'<%=cifData.get("RISK_RATING_CAT2")%>')" <%} %>>
				    						<label <% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT2")){ %> class="red" <%} %> for="riskRatingCat2High1">Professional Services</label>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td>
				    						<input type="radio" id="riskRatingCat2Low2" riskRating="1" name="RISK_RATING_CAT2" value="RR_CAT2_L2" <%if("RR_CAT2_L2".equals(cifData.get("RISK_RATING_CAT2"))){%> checked="checked" <%} %>
				    						<% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT2")){ %> onclick="return forceCheck(this,'<%=cifData.get("RISK_RATING_CAT2")%>')" <%} %>>
				    						<label <% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT2")){ %> class="red" <%} %> for="riskRatingCat2Low2">Dealer in Brand New Vehicles</label>
				    					</td>
				    					<td>
				    						<input type="radio" id="riskRatingCat2Mid2" riskRating="2" name="RISK_RATING_CAT2" value="RR_CAT2_M2" <%if("RR_CAT2_M2".equals(cifData.get("RISK_RATING_CAT2"))){%> checked="checked" <%} %>
				    						<% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT2")){ %> onclick="return forceCheck(this,'<%=cifData.get("RISK_RATING_CAT2")%>')" <%} %>>
				    						<label <% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT2")){ %> class="red" <%} %> for="riskRatingCat2Mid2">Art / Antique dealers</label>
				    					</td>
				    					<td>
				    						<input type="radio" id="riskRatingCat2High2" riskRating="3" name="RISK_RATING_CAT2" value="RR_CAT2_H2" <%if("RR_CAT2_H2".equals(cifData.get("RISK_RATING_CAT2"))){%> checked="checked" <%} %>
				    						<% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT2")){ %> onclick="return forceCheck(this,'<%=cifData.get("RISK_RATING_CAT2")%>')" <%} %>>
				    						<label <% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT2")){ %> class="red" <%} %> for="riskRatingCat2High2">Dealer / Trader in gem & jewelry</label>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td>
				    						<input type="radio" id="riskRatingCat2Low3" riskRating="1" name="RISK_RATING_CAT2" value="RR_CAT2_L3" <%if("RR_CAT2_L3".equals(cifData.get("RISK_RATING_CAT2"))){%> checked="checked" <%} %>
				    						<% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT2")){ %> onclick="return forceCheck(this,'<%=cifData.get("RISK_RATING_CAT2")%>')" <%} %>>
				    						<label <% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT2")){ %> class="red" <%} %> for="riskRatingCat2Low3">Exporter of Local Products</label>
				    					</td>
				    					<td>
				    						<input type="radio" id="riskRatingCat2Mid3" riskRating="2" name="RISK_RATING_CAT2" value="RR_CAT2_M3" <%if("RR_CAT2_M3".equals(cifData.get("RISK_RATING_CAT2"))){%> checked="checked" <%} %>
				    						<% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT2")){ %> onclick="return forceCheck(this,'<%=cifData.get("RISK_RATING_CAT2")%>')" <%} %>>
				    						<label <% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT2")){ %> class="red" <%} %> for="riskRatingCat2Mid3">Service provider</label>
				    					</td>
				    					<td>
				    						<input type="radio" id="riskRatingCat2High3" riskRating="3" name="RISK_RATING_CAT2" value="RR_CAT2_H3" <%if("RR_CAT2_H3".equals(cifData.get("RISK_RATING_CAT2"))){%> checked="checked" <%} %>
				    						<% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT2")){ %> onclick="return forceCheck(this,'<%=cifData.get("RISK_RATING_CAT2")%>')" <%} %>>
				    						<label <% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT2")){ %> class="red" <%} %> for="riskRatingCat2High3">Mobile phone & accessories</label>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td>
				    						<input type="radio" id="riskRatingCat2Low4" riskRating="1" name="RISK_RATING_CAT2" value="RR_CAT2_L4" <%if("RR_CAT2_L4".equals(cifData.get("RISK_RATING_CAT2"))){%> checked="checked" <%} %>
				    						<% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT2")){ %> onclick="return forceCheck(this,'<%=cifData.get("RISK_RATING_CAT2")%>')" <%} %>>
				    						<label <% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT2")){ %> class="red" <%} %> for="riskRatingCat2Low4">Printers & Publishers</label>
				    					</td>
				    					<td>
				    						<input type="radio" id="riskRatingCat2Mid4" riskRating="2" name="RISK_RATING_CAT2" value="RR_CAT2_M4" <%if("RR_CAT2_M4".equals(cifData.get("RISK_RATING_CAT2"))){%> checked="checked" <%} %>
				    						<% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT2")){ %> onclick="return forceCheck(this,'<%=cifData.get("RISK_RATING_CAT2")%>')" <%} %>>
				    						<label <% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT2")){ %> class="red" <%} %> for="riskRatingCat2Mid4">Construction Buildings / Roads</label>
				    					</td>
				    					<td>
				    						<input type="radio" id="riskRatingCat2High4" riskRating="3" name="RISK_RATING_CAT2" value="RR_CAT2_H4" <%if("RR_CAT2_H4".equals(cifData.get("RISK_RATING_CAT2"))){%> checked="checked" <%} %>
				    						<% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT2")){ %> onclick="return forceCheck(this,'<%=cifData.get("RISK_RATING_CAT2")%>')" <%} %>>
				    						<label <% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT2")){ %> class="red" <%} %> for="riskRatingCat2High4">Money Changers / Remitters</label>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td>
				    						<input type="radio" id="riskRatingCat2Low5" riskRating="1" name="RISK_RATING_CAT2" value="RR_CAT2_L5" <%if("RR_CAT2_L5".equals(cifData.get("RISK_RATING_CAT2"))){%> checked="checked" <%} %>
				    						<% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT2")){ %> onclick="return forceCheck(this,'<%=cifData.get("RISK_RATING_CAT2")%>')" <%} %>>
				    						<label <% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT2")){ %> class="red" <%} %> for="riskRatingCat2Low5">Nursing homes / health care centers</label>
				    					</td>
				    					<td>
				    						<input type="radio" id="riskRatingCat2Mid5" riskRating="2" name="RISK_RATING_CAT2" value="RR_CAT2_M5" <%if("RR_CAT2_M5".equals(cifData.get("RISK_RATING_CAT2"))){%> checked="checked" <%} %>
				    						<% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT2")){ %> onclick="return forceCheck(this,'<%=cifData.get("RISK_RATING_CAT2")%>')" <%} %>>
				    						<label <% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT2")){ %> class="red" <%} %> for="riskRatingCat2Mid5">Importer & Distributor of Commercial goods</label>
				    					</td>
				    					<td>
				    						<input type="radio" id="riskRatingCat2High5" riskRating="3" name="RISK_RATING_CAT2" value="RR_CAT2_H5" <%if("RR_CAT2_H5".equals(cifData.get("RISK_RATING_CAT2"))){%> checked="checked" <%} %>
				    						<% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT2")){ %> onclick="return forceCheck(this,'<%=cifData.get("RISK_RATING_CAT2")%>')" <%} %>>
				    						<label <% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT2")){ %> class="red" <%} %> for="riskRatingCat2High5">Buying & Selling of real estate</label>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td>
				    						<input type="radio" id="riskRatingCat2Low6" riskRating="1" name="RISK_RATING_CAT2" value="RR_CAT2_L6" <%if("RR_CAT2_L6".equals(cifData.get("RISK_RATING_CAT2"))){%> checked="checked" <%} %>
				    						<% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT2")){ %> onclick="return forceCheck(this,'<%=cifData.get("RISK_RATING_CAT2")%>')" <%} %>>
				    						<label <% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT2")){ %> class="red" <%} %> for="riskRatingCat2Low6">Manufacturing / Industry</label>
				    					</td>
				    					<td>
				    						<input type="radio" id="riskRatingCat2Mid6" riskRating="2" name="RISK_RATING_CAT2" value="RR_CAT2_M6" <%if("RR_CAT2_M6".equals(cifData.get("RISK_RATING_CAT2"))){%> checked="checked" <%} %>
				    						<% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT2")){ %> onclick="return forceCheck(this,'<%=cifData.get("RISK_RATING_CAT2")%>')" <%} %>>
				    						<label <% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT2")){ %> class="red" <%} %> for="riskRatingCat2Mid6">Wholesale Trader</label>
				    					</td>
				    					<td>
				    						<input type="radio" id="riskRatingCat2High6" riskRating="3" name="RISK_RATING_CAT2" value="RR_CAT2_H6" <%if("RR_CAT2_H6".equals(cifData.get("RISK_RATING_CAT2"))){%> checked="checked" <%} %>
				    						<% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT2")){ %> onclick="return forceCheck(this,'<%=cifData.get("RISK_RATING_CAT2")%>')" <%} %>>
				    						<label <% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT2")){ %> class="red" <%} %> for="riskRatingCat2High6">Shares & Stock Brokers</label>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td>
				    						&nbsp;
				    					</td>
				    					<td>
				    						<input type="radio" id="riskRatingCat2Mid7" riskRating="2" name="RISK_RATING_CAT2" value="RR_CAT2_M7" <%if("RR_CAT2_M7".equals(cifData.get("RISK_RATING_CAT2"))){%> checked="checked" <%} %>
				    						<% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT2")){ %> onclick="return forceCheck(this,'<%=cifData.get("RISK_RATING_CAT2")%>')" <%} %>>
				    						<label <% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT2")){ %> class="red" <%} %> for="riskRatingCat2Mid7">Shipping Airline & Freight Forwarding</label>
				    					</td>
				    					<td>
				    						<input type="radio" id="riskRatingCat2High7" riskRating="3" name="RISK_RATING_CAT2" value="RR_CAT2_H7" <%if("RR_CAT2_H7".equals(cifData.get("RISK_RATING_CAT2"))){%> checked="checked" <%} %>
				    						<% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT2")){ %> onclick="return forceCheck(this,'<%=cifData.get("RISK_RATING_CAT2")%>')" <%} %>>
				    						<label <% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT2")){ %> class="red" <%} %> for="riskRatingCat2High7">Investing / Administering / Managing / Public funds</label>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td>
				    						&nbsp;
				    					</td>
				    					<td>
				    						<input type="radio" id="riskRatingCat2Mid8" riskRating="2" name="RISK_RATING_CAT2" value="RR_CAT2_M8" <%if("RR_CAT2_M8".equals(cifData.get("RISK_RATING_CAT2"))){%> checked="checked" <%} %>
				    						<% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT2")){ %> onclick="return forceCheck(this,'<%=cifData.get("RISK_RATING_CAT2")%>')" <%} %>>
				    						<label <% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT2")){ %> class="red" <%} %> for="riskRatingCat2Mid8">Small / Medium work shop / repair shop</label>
				    					</td>
				    					<td>
				    						<input type="radio" id="riskRatingCat2High8" riskRating="3" name="RISK_RATING_CAT2" value="RR_CAT2_H8" <%if("RR_CAT2_H8".equals(cifData.get("RISK_RATING_CAT2"))){%> checked="checked" <%} %>
				    						<% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT2")){ %> onclick="return forceCheck(this,'<%=cifData.get("RISK_RATING_CAT2")%>')" <%} %>>
				    						<label <% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT2")){ %> class="red" <%} %> for="riskRatingCat2High8">Restaurant / Hotelier / Food Outlets</label>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td>
				    						&nbsp;
				    					</td>
				    					<td>
				    						<input type="radio" id="riskRatingCat2Mid9" riskRating="2" name="RISK_RATING_CAT2" value="RR_CAT2_M9" <%if("RR_CAT2_M9".equals(cifData.get("RISK_RATING_CAT2"))){%> checked="checked" <%} %>
				    						<% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT2")){ %> onclick="return forceCheck(this,'<%=cifData.get("RISK_RATING_CAT2")%>')" <%} %>>
				    						<label <% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT2")){ %> class="red" <%} %> for="riskRatingCat2Mid9">Transport Operations</label>
				    					</td>
				    					<td>
				    						<input type="radio" id="riskRatingCat2High9" riskRating="3" name="RISK_RATING_CAT2" value="RR_CAT2_H9" <%if("RR_CAT2_H9".equals(cifData.get("RISK_RATING_CAT2"))){%> checked="checked" <%} %>
				    						<% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT2")){ %> onclick="return forceCheck(this,'<%=cifData.get("RISK_RATING_CAT2")%>')" <%} %>>
				    						<label <% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT2")){ %> class="red" <%} %> for="riskRatingCat2High9">Importer dealer in 2nd hand motor vehicles</label>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td>
				    						&nbsp;
				    					</td>
				    					<td>
				    						<input type="radio" id="riskRatingCat2Mid10" riskRating="2" name="RISK_RATING_CAT2" value="RR_CAT2_M10" <%if("RR_CAT2_M10".equals(cifData.get("RISK_RATING_CAT2"))){%> checked="checked" <%} %>
				    						<% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT2")){ %> onclick="return forceCheck(this,'<%=cifData.get("RISK_RATING_CAT2")%>')" <%} %>>
				    						<label <% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT2")){ %> class="red" <%} %> for="riskRatingCat2Mid10">Telephone / Communication Providers</label>
				    					</td>
				    					<td>
				    						<input type="radio" id="riskRatingCat2High10" riskRating="3" name="RISK_RATING_CAT2" value="RR_CAT2_H10" <%if("RR_CAT2_H10".equals(cifData.get("RISK_RATING_CAT2"))){%> checked="checked" <%} %>
				    						<% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT2")){ %> onclick="return forceCheck(this,'<%=cifData.get("RISK_RATING_CAT2")%>')" <%} %>>
				    						<label <% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT2")){ %> class="red" <%} %> for="riskRatingCat2High10">Lotteries</label>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td>
				    						&nbsp;
				    					</td>
				    					<td>
				    						&nbsp;
				    					</td>
				    					<td>
				    						<input type="radio" id="riskRatingCat2High11" riskRating="3" name="RISK_RATING_CAT2" value="RR_CAT2_H11" <%if("RR_CAT2_H11".equals(cifData.get("RISK_RATING_CAT2"))){%> checked="checked" <%} %>
				    						<% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT2")){ %> onclick="return forceCheck(this,'<%=cifData.get("RISK_RATING_CAT2")%>')" <%} %>>
				    						<label <% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT2")){ %> class="red" <%} %> for="riskRatingCat2High11">Travel Agent</label>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td>
				    						&nbsp;
				    					</td>
				    					<td>
				    						&nbsp;
				    					</td>
				    					<td>
				    						<input type="radio" id="riskRatingCat2High12" riskRating="3" name="RISK_RATING_CAT2" value="RR_CAT2_H12" <%if("RR_CAT2_H12".equals(cifData.get("RISK_RATING_CAT2"))){%> checked="checked" <%} %>
				    						<% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT2")){ %> onclick="return forceCheck(this,'<%=cifData.get("RISK_RATING_CAT2")%>')" <%} %>>
				    						<label <% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT2")){ %> class="red" <%} %> for="riskRatingCat2High12">Retail trader/ Business</label>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td>
				    						&nbsp;
				    					</td>
				    					<td>
				    						&nbsp;
				    					</td>
				    					<td>
				    						<input type="radio" id="riskRatingCat2High13" riskRating="3" name="RISK_RATING_CAT2" value="RR_CAT2_H13" <%if("RR_CAT2_H13".equals(cifData.get("RISK_RATING_CAT2"))){%> checked="checked" <%} %>
				    						<% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT2")){ %> onclick="return forceCheck(this,'<%=cifData.get("RISK_RATING_CAT2")%>')" <%} %>>
				    						<label <% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT2")){ %> class="red" <%} %> for="riskRatingCat2High13">Marketing & Advertising</label>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td>
				    						&nbsp;
				    					</td>
				    					<td>
				    						&nbsp;
				    					</td>
				    					<td>
				    						<input type="radio" id="riskRatingCat2High14" riskRating="3" name="RISK_RATING_CAT2" value="RR_CAT2_H14" <%if("RR_CAT2_H14".equals(cifData.get("RISK_RATING_CAT2"))){%> checked="checked" <%} %>
				    						<% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT2")){ %> onclick="return forceCheck(this,'<%=cifData.get("RISK_RATING_CAT2")%>')" <%} %>>
				    						<label <% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT2")){ %> class="red" <%} %> for="riskRatingCat2High14">Commission Agent</label>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td>
				    						&nbsp;
				    					</td>
				    					<td>
				    						&nbsp;
				    					</td>
				    					<td>
				    						<input type="radio" id="riskRatingCat2High15" riskRating="3" name="RISK_RATING_CAT2" value="RR_CAT2_H15" <%if("RR_CAT2_H15".equals(cifData.get("RISK_RATING_CAT2"))){%> checked="checked" <%} %>
				    						<% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT2")){ %> onclick="return forceCheck(this,'<%=cifData.get("RISK_RATING_CAT2")%>')" <%} %>>
				    						<label <% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT2")){ %> class="red" <%} %> for="riskRatingCat2High15">Finance / Insurance Companies</label>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td>
				    						&nbsp;
				    					</td>
				    					<td>
				    						&nbsp;
				    					</td>
				    					<td>
				    						<input type="radio" id="riskRatingCat2High16" riskRating="3" name="RISK_RATING_CAT2" value="RR_CAT2_H16" <%if("RR_CAT2_H16".equals(cifData.get("RISK_RATING_CAT2"))){%> checked="checked" <%} %>
				    						<% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT2")){ %> onclick="return forceCheck(this,'<%=cifData.get("RISK_RATING_CAT2")%>')" <%} %>>
				    						<label <% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT2")){ %> class="red" <%} %> for="riskRatingCat2High16">Scrap Metal Dealers</label>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td>
				    						&nbsp;
				    					</td>
				    					<td>
				    						&nbsp;
				    					</td>
				    					<td>
				    						<input type="radio" id="riskRatingCat2High17" riskRating="3" name="RISK_RATING_CAT2" value="RR_CAT2_H17" <%if("RR_CAT2_H17".equals(cifData.get("RISK_RATING_CAT2"))){%> checked="checked" <%} %>
				    						<% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT2")){ %> onclick="return forceCheck(this,'<%=cifData.get("RISK_RATING_CAT2")%>')" <%} %>>
				    						<label <% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT2")){ %> class="red" <%} %> for="riskRatingCat2High17">Social / Religious Activities</label>
				    					</td>
				    				</tr>
				    			</table>
				    		</div>
				    	</div>
				    	<div class="section">
				    		<div class="<% if(FORMSTATUS.get("REJECTED_SECTION") != null && FORMSTATUS.get("REJECTED_SECTION").contains("reject_section8")){  %> sectionHeaderRej <%}else{ %> sectionHeader <%} %>">
				    			AML Risk Categorization : Turn over per month
				    		</div>
				    		<div class="sectionBody">
				    			<table class="table table-bordered table-stripped" width="100%">
				    				<tr>
				    					<th width="33%" style="text-align: center;">Low</th>
				    					<th width="33%" style="text-align: center;">Medium</th>
				    					<th width="34%" style="text-align: center;">High</th>
				    				</tr>
				    				<tr>
				    					<td>
				    						<input type="radio" id="riskRatingCat3Low1" riskRating="1" name="RISK_RATING_CAT3" value="RR_CAT3_L1" <%if("RR_CAT3_L1".equals(cifData.get("RISK_RATING_CAT3"))){%> checked="checked" <%} %>
				    						<% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT3")){ %> onclick="return forceCheck(this,'<%=cifData.get("RISK_RATING_CAT3")%>')" <%} %>>
				    						<label <% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT3")){ %> class="red" <%} %> for="riskRatingCat3Low1">Less than Rs. 1,000,000</label>
				    					</td>
				    					<td>
				    						<input type="radio" id="riskRatingCat3Mid1" riskRating="2" name="RISK_RATING_CAT3" value="RR_CAT3_M1" <%if("RR_CAT3_M1".equals(cifData.get("RISK_RATING_CAT3"))){%> checked="checked" <%} %>
				    						<% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT3")){ %> onclick="return forceCheck(this,'<%=cifData.get("RISK_RATING_CAT3")%>')" <%} %>>
				    						<label <% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT3")){ %> class="red" <%} %> for="riskRatingCat3Mid1">From Rs. 1,000,000 to Rs. 3,000,000</label>
				    					</td>
				    					<td>
				    						<input type="radio" id="riskRatingCat3High1" riskRating="3" name="RISK_RATING_CAT3" value="RR_CAT3_H1" <%if("RR_CAT3_H1".equals(cifData.get("RISK_RATING_CAT3"))){%> checked="checked" <%} %>
				    						<% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT3")){ %> onclick="return forceCheck(this,'<%=cifData.get("RISK_RATING_CAT3")%>')" <%} %>>
				    						<label <% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT3")){ %> class="red" <%} %> for="riskRatingCat3High1">Above Rs. 3,000,000</label>
				    					</td>
				    				</tr>
				    			</table>
				    		</div>
				    	</div>
				    	<div class="section">
				    		<div class="<% if(FORMSTATUS.get("REJECTED_SECTION") != null && FORMSTATUS.get("REJECTED_SECTION").contains("reject_section8")){  %> sectionHeaderRej <%}else{ %> sectionHeader <%} %>">
				    			AML Risk Categorization : Product type
				    		</div>
				    		<div class="sectionBody">
				    			<table class="table table-bordered table-stripped" width="100%">
				    				<tr>
				    					<th width="33%" style="text-align: center;">Low</th>
				    					<th width="33%" style="text-align: center;">Medium</th>
				    					<th width="34%" style="text-align: center;">High</th>
				    				</tr>
				    				<tr>
				    					<td>
				    						<input type="checkbox" id="riskRatingCat4Low1" riskRating="1" name="RISK_RATING_CAT4LOW1" value="RR_CAT4_L1" <%if("RR_CAT4_L1".equals(cifData.get("RISK_RATING_CAT4LOW1"))){%> checked="checked" <%} %>
				    						<% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT4")){ %> onclick="return forceCheck(this,'<%=cifData.get("RISK_RATING_CAT4LOW1")%>')" <%} %>>
				    						<label <% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT4")){ %> class="red" <%} %> for="riskRatingCat4Low1">Savings Account / Term Deposit</label>
				    					</td>
				    					<td>
				    						<input type="checkbox" id="riskRatingCat4Mid1" riskRating="2" name="RISK_RATING_CAT4MID1" value="RR_CAT4_M1" <%if("RR_CAT4_M1".equals(cifData.get("RISK_RATING_CAT4MID1"))){%> checked="checked" <%} %>
				    						<% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT4")){ %> onclick="return forceCheck(this,'<%=cifData.get("RISK_RATING_CAT4MID1")%>')" <%} %>>
				    						<label <% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT4")){ %> class="red" <%} %> for="riskRatingCat4Mid1">Current Account</label>
				    					</td>
				    					<td>
				    						<input type="checkbox" id="riskRatingCat4High1" riskRating="3" name="RISK_RATING_CAT4HIGH1" value="RR_CAT4_H1" <%if("RR_CAT4_H1".equals(cifData.get("RISK_RATING_CAT4HIGH1"))){%> checked="checked" <%} %>
				    						<% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT4")){ %> onclick="return forceCheck(this,'<%=cifData.get("RISK_RATING_CAT4HIGH1")%>')" <%} %>>
				    						<label <% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT4")){ %> class="red" <%} %> for="riskRatingCat4High1">Foreign currency Account</label>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td>
				    						<input type="checkbox" id="riskRatingCat4Low2" riskRating="1" name="RISK_RATING_CAT4LOW2" value="RR_CAT4_L2" <%if("RR_CAT4_L2".equals(cifData.get("RISK_RATING_CAT4LOW2"))){%> checked="checked" <%} %>
				    						<% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT4")){ %> onclick="return forceCheck(this,'<%=cifData.get("RISK_RATING_CAT4LOW2")%>')" <%} %>>
				    						<label <% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT4")){ %> class="red" <%} %> for="riskRatingCat4Low2">Leasing / Home finance</label>
				    					</td>
				    					<td>
				    						<input type="checkbox" id="riskRatingCat4Mid2" riskRating="2" name="RISK_RATING_CAT4MID2" value="RR_CAT4_M2" <%if("RR_CAT4_M2".equals(cifData.get("RISK_RATING_CAT4MID2"))){%> checked="checked" <%} %>
				    						<% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT4")){ %> onclick="return forceCheck(this,'<%=cifData.get("RISK_RATING_CAT4MID2")%>')" <%} %>>
				    						<label <% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT4")){ %> class="red" <%} %> for="riskRatingCat4Mid2">Small Medium Entrepreneur</label>
				    					</td>
				    					<td>
				    						<input type="checkbox" id="riskRatingCat4High2" riskRating="3" name="RISK_RATING_CAT4HIGH2" value="RR_CAT4_H2" <%if("RR_CAT4_H2".equals(cifData.get("RISK_RATING_CAT4HIGH2"))){%> checked="checked" <%} %>
				    						<% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT4")){ %> onclick="return forceCheck(this,'<%=cifData.get("RISK_RATING_CAT4HIGH2")%>')" <%} %>>
				    						<label <% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT4")){ %> class="red" <%} %> for="riskRatingCat4High2">Multiple A/c's without any specified reason</label>
				    					</td>
				    				</tr>
				    			</table>
				    		</div>
				    	</div>
				    	<div class="section">
				    		<div class="<% if(FORMSTATUS.get("REJECTED_SECTION") != null && FORMSTATUS.get("REJECTED_SECTION").contains("reject_section8")){  %> sectionHeaderRej <%}else{ %> sectionHeader <%} %>">
				    			AML Risk Categorization : General Identifies
				    		</div>
				    		<div class="sectionBody">
				    			<table class="table table-bordered table-stripped" width="100%">
				    				<tr>
				    					<td>
				    						<input type="checkbox" id="riskRatingCat5" name="RISK_RATING_CAT5" value="RR_CAT5" <%if("RR_CAT5".equals(cifData.get("RISK_RATING_CAT5"))){%> checked="checked" <%} %>
				    						<% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT5")){ %> onclick="return forceCheck(this,'<%=cifData.get("RISK_RATING_CAT5")%>')" <%} %>>
				    						<label <% if(AOFDisabledFiledsMap.isFieldDisabled("RISK_RATING_CAT5")){ %> class="red" <%} %> for="riskRatingCat5">
				    							Strange behavior / Not willing to diverse any details / Not providing proper documentation
				    						</label>
				    					</td>
				    				</tr>
				    			</table>
				    		</div>
				    	</div>
				    	<div class="section">
				    		<div class="<% if(FORMSTATUS.get("REJECTED_SECTION") != null && FORMSTATUS.get("REJECTED_SECTION").contains("reject_section8")){  %> sectionHeaderRej <%}else{ %> sectionHeader <%} %>">
				    			AML Risk Categorization : Overall Risk Calculation
				    		</div>
				    		<div class="sectionBody">
				    			<table class="table table-bordered table-stripped" width="100%">
				    				<tr>
				    					<th width="25">Risk Value : <input type="text" id="RISK_RATING_FINAL_VALUE" name="RISK_RATING_FINAL_VALUE" readonly="readonly" class="input-ovr"
				    								value="<%=cifData.get("RISK_RATING_FINAL_VALUE") != null ? cifData.get("RISK_RATING_FINAL_VALUE") : ""%>"/></th>
				    					<th width="25%">
					    					<input type="radio" id="RISK_RATING_FINAL_L" name="RISK_RATING_FINAL" <% if("1".equals(cifData.get("RISK_RATING_FINAL"))){ %> checked="checked" <% } %>
					    					onclick="return false;" value="1"/>
					    					Low
				    					</th>
				    					<th width="25%">
					    					<input type="radio" id="RISK_RATING_FINAL_M" name="RISK_RATING_FINAL" <% if("2".equals(cifData.get("RISK_RATING_FINAL"))){ %> checked="checked" <% } %>
					    					onclick="return false;" value="2"/>
					    					Medium
				    					</th>
				    					<th width="25%">
				    						<input type="radio" id="RISK_RATING_FINAL_H" name="RISK_RATING_FINAL" <% if("3".equals(cifData.get("RISK_RATING_FINAL"))){ %> checked="checked" <% } %>
				    						onclick="return false;" value="3"/>
				    						High
				    					</th>
				    				</tr>
				    			</table>
				    		</div>
				    		<% if(canEdit.equals("Y")){ %>
					    	<div class="sectionFooter">
				    			<input name="formSave" type="submit" value="Save" class="btn btn-success"/>
				    			<input name="formClose" type="submit" value="Save & Close" class="btn btn-info"/>
				    		</div>
				    		<%} %>
				    	</div>
				    </div>
				    <!-- CATEGORY3 START -->
				    <div role="tabpanel" class="tab-pane" id="category3">
				    	<div class="section">
				    		<div class="<% if(FORMSTATUS.get("REJECTED_SECTION") != null && FORMSTATUS.get("REJECTED_SECTION").contains("reject_section7")){  %> sectionHeaderRej <%}else{ %> sectionHeader <%} %>">
				    			DOCUMENT CHECK LIST
				    		</div>
				    		<div class="sectionBody">
				    			<table class="table">
				    				<tr>
				    					<td>
				    						The following documents (duly certified by the Directory / Secretary of the Company) to be
				    						submitted upon verification of originals by the Bank Officer where necessary
				    					</td>
				    				</tr>
				    				<tr>
				    					<td>
				    						<input type="checkbox" id="documentCheckList1" name="CORP_AOM_COMPLETED" value="Y" <%if("Y".equals(cifData.get("CORP_AOM_COMPLETED"))){%> checked="checked" <%} %>
				    						<% if(AOFDisabledFiledsMap.isFieldDisabled("CORP_AOM_COMPLETED")){ %> onclick="return forceCheck(this,'<%=cifData.get("CORP_AOM_COMPLETED")%>')" <%} %>>
				    						<label <% if(AOFDisabledFiledsMap.isFieldDisabled("CORP_AOM_COMPLETED")){ %> class="red" <%} %> for="documentCheckList1">Completed Account opening mandate</label>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td>
				    						<input type="checkbox" id="documentCheckList2" name="CORP_INCROP_CERT_COPY" value="Y" <%if("Y".equals(cifData.get("CORP_INCROP_CERT_COPY"))){%> checked="checked" <%} %>
				    						<% if(AOFDisabledFiledsMap.isFieldDisabled("CORP_INCROP_CERT_COPY")){ %> onclick="return forceCheck(this,'<%=cifData.get("CORP_INCROP_CERT_COPY")%>')" <%} %>>
				    						<label <% if(AOFDisabledFiledsMap.isFieldDisabled("CORP_INCROP_CERT_COPY")){ %> class="red" <%} %> for="documentCheckList2">Certified copy of the Certificate of Incorporation</label>
				    						<ul class="inlineUL">
				    							<li>
				    								<input type="radio" id="documentCheckList211" name="COPR_CERT_COPY_TYPE" value="1" <%if("1".equals(cifData.get("COPR_CERT_COPY_TYPE"))){%> checked="checked" <%} %>
				    								<% if(AOFDisabledFiledsMap.isFieldDisabled("COPR_CERT_COPY_TYPE")){ %> onclick="return forceCheck(this,'<%=cifData.get("COPR_CERT_COPY_TYPE")%>')" <%} %>>
				    								<label <% if(AOFDisabledFiledsMap.isFieldDisabled("COPR_CERT_COPY_TYPE")){ %> class="red" <%} %> for="documentCheckList211">Re-registered Company : Form 41</label>
				    							</li>
				    							<li>
				    								<input type="radio" id="documentCheckList212" name="COPR_CERT_COPY_TYPE" value="2" <%if("2".equals(cifData.get("COPR_CERT_COPY_TYPE"))){%> checked="checked" <%} %>
				    								<% if(AOFDisabledFiledsMap.isFieldDisabled("COPR_CERT_COPY_TYPE")){ %> onclick="return forceCheck(this,'<%=cifData.get("COPR_CERT_COPY_TYPE")%>')" <%} %>>
				    								<label <% if(AOFDisabledFiledsMap.isFieldDisabled("COPR_CERT_COPY_TYPE")){ %> class="red" <%} %> for="documentCheckList212">New Company : Form 2 A</label>
				    							</li>
				    						</ul>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td>
				    						<input type="checkbox" id="documentCheckList3" name="COPR_ART_ASSOC_COMP" value="Y" <%if("Y".equals(cifData.get("COPR_ART_ASSOC_COMP"))){%> checked="checked" <%} %>
				    						<% if(AOFDisabledFiledsMap.isFieldDisabled("COPR_ART_ASSOC_COMP")){ %> onclick="return forceCheck(this,'<%=cifData.get("COPR_ART_ASSOC_COMP")%>')" <%} %>>
				    						<label <% if(AOFDisabledFiledsMap.isFieldDisabled("COPR_ART_ASSOC_COMP")){ %> class="red" <%} %> for="documentCheckList3">Articles of Association of the Company</label>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td>
				    						<input type="checkbox" id="documentCheckList4" name="CORP_RC_FORM" value="Y" <%if("Y".equals(cifData.get("CORP_RC_FORM"))){%> checked="checked" <%} %>
				    						<% if(AOFDisabledFiledsMap.isFieldDisabled("CORP_RC_FORM")){ %> onclick="return forceCheck(this,'<%=cifData.get("CORP_RC_FORM")%>')" <%} %>>
				    						<label <% if(AOFDisabledFiledsMap.isFieldDisabled("CORP_RC_FORM")){ %> class="red" <%} %> for="documentCheckList4">Copies of the following forms issued by the Registrar of Companies</label>
				    						<table width="100%">
				    							<tr>
				    								<td>
				    									<input type="radio" id="documentCheckList411" name="CORP_RC_FORM_TYPE" value="1" <%if("1".equals(cifData.get("CORP_RC_FORM_TYPE"))){%> checked="checked" <%} %>
				    									<% if(AOFDisabledFiledsMap.isFieldDisabled("CORP_RC_FORM_TYPE")){ %> onclick="return forceCheck(this,'<%=cifData.get("CORP_RC_FORM_TYPE")%>')" <%} %>>
				    									<label <% if(AOFDisabledFiledsMap.isFieldDisabled("CORP_RC_FORM_TYPE")){ %> class="red" <%} %> for="documentCheckList411">Re-registered Company : Form 48 - Director / Secretary details</label>
				    								</td>
				    								<td>
					    								<input type="radio" id="documentCheckList412" name="CORP_RC_FORM_TYPE" value="2" <%if("2".equals(cifData.get("CORP_RC_FORM_TYPE"))){%> checked="checked" <%} %>
					    								<% if(AOFDisabledFiledsMap.isFieldDisabled("CORP_RC_FORM_TYPE")){ %> onclick="return forceCheck(this,'<%=cifData.get("CORP_RC_FORM_TYPE")%>')" <%} %>>
					    								<label <% if(AOFDisabledFiledsMap.isFieldDisabled("CORP_RC_FORM_TYPE")){ %> class="red" <%} %> for="documentCheckList412">New Company : Certified copy of Form 1 - List of Directors</label>
				    								</td>
				    								<td>
				    									<input type="radio" id="documentCheckList413" name="CORP_RC_FORM_TYPE" value="3" <%if("3".equals(cifData.get("CORP_RC_FORM_TYPE"))){%> checked="checked" <%} %>
				    									<% if(AOFDisabledFiledsMap.isFieldDisabled("CORP_RC_FORM_TYPE")){ %> onclick="return forceCheck(this,'<%=cifData.get("CORP_RC_FORM_TYPE")%>')" <%} %>>
				    									<label <% if(AOFDisabledFiledsMap.isFieldDisabled("CORP_RC_FORM_TYPE")){ %> class="red" <%} %> for="documentCheckList413">Form 20 - If any changes on Directors / Secretary</label>
				    								</td>
				    							</tr>
				    						</table>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td>
				    						<input type="checkbox" id="documentCheckList5" name="COPR_COMMRC_BUSS_CERT" value="Y" <%if("Y".equals(cifData.get("COPR_COMMRC_BUSS_CERT"))){%> checked="checked" <%} %>
				    						<% if(AOFDisabledFiledsMap.isFieldDisabled("COPR_COMMRC_BUSS_CERT")){ %> onclick="return forceCheck(this,'<%=cifData.get("COPR_COMMRC_BUSS_CERT")%>')" <%} %>>
				    						<label <% if(AOFDisabledFiledsMap.isFieldDisabled("COPR_COMMRC_BUSS_CERT")){ %> class="red" <%} %> for="documentCheckList5">Cerificate to Commence Business (Only for Public Companies)</label>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td>
				    						<input type="checkbox" id="documentCheckList6" name="CORP_BORD_RESOL_CERT" value="Y" <%if("Y".equals(cifData.get("CORP_BORD_RESOL_CERT"))){%> checked="checked" <%} %>
				    						<% if(AOFDisabledFiledsMap.isFieldDisabled("CORP_BORD_RESOL_CERT")){ %> onclick="return forceCheck(this,'<%=cifData.get("CORP_BORD_RESOL_CERT")%>')" <%} %>>
				    						<label <% if(AOFDisabledFiledsMap.isFieldDisabled("CORP_BORD_RESOL_CERT")){ %> class="red" <%} %> for="documentCheckList6">Cerified copy of the Board Resolution</label>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td>
				    						<input type="checkbox" id="documentCheckList7" name="CORP_REG_ADDR_COPY_FRM_13_36" value="Y" <%if("Y".equals(cifData.get("CORP_REG_ADDR_COPY_FRM_13_36"))){%> checked="checked" <%} %>
				    						<% if(AOFDisabledFiledsMap.isFieldDisabled("CORP_REG_ADDR_COPY_FRM_13_36")){ %> onclick="return forceCheck(this,'<%=cifData.get("CORP_REG_ADDR_COPY_FRM_13_36")%>')" <%} %>>
				    						<label <% if(AOFDisabledFiledsMap.isFieldDisabled("CORP_REG_ADDR_COPY_FRM_13_36")){ %> class="red" <%} %> for="documentCheckList7">Cerified copy of Form 13/36 - 'Registered Address' issued by the Resistrar  of the Companies</label>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td>
				    						<input type="checkbox" id="documentCheckList8" name="CORP_ADDR_VERF_DOC" value="Y" <%if("Y".equals(cifData.get("CORP_ADDR_VERF_DOC"))){%> checked="checked" <%} %>
				    						<% if(AOFDisabledFiledsMap.isFieldDisabled("CORP_ADDR_VERF_DOC")){ %> onclick="return forceCheck(this,'<%=cifData.get("CORP_ADDR_VERF_DOC")%>')" <%} %>>
				    						<label <% if(AOFDisabledFiledsMap.isFieldDisabled("CORP_ADDR_VERF_DOC")){ %> class="red" <%} %> for="documentCheckList8">Copy of Address verification document</label>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td>
				    						<input type="checkbox" id="documentCheckList9" name="CORP_AUTH_SIGNTR_COPY" value="Y" <%if("Y".equals(cifData.get("CORP_AUTH_SIGNTR_COPY"))){%> checked="checked" <%} %>
				    						<% if(AOFDisabledFiledsMap.isFieldDisabled("CORP_AUTH_SIGNTR_COPY")){ %> onclick="return forceCheck(this,'<%=cifData.get("CORP_AUTH_SIGNTR_COPY")%>')" <%} %>>
				    						<label <% if(AOFDisabledFiledsMap.isFieldDisabled("CORP_AUTH_SIGNTR_COPY")){ %> class="red" <%} %> for="documentCheckList9">Specimen copy of authorised signatories</label>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td>
				    						<input type="checkbox" id="documentCheckList10" name="COPR_DIR_SIGNTR_NIC_PASPRT" value="Y" <%if("Y".equals(cifData.get("COPR_DIR_SIGNTR_NIC_PASPRT"))){%> checked="checked" <%} %>
				    						<% if(AOFDisabledFiledsMap.isFieldDisabled("COPR_DIR_SIGNTR_NIC_PASPRT")){ %> onclick="return forceCheck(this,'<%=cifData.get("COPR_DIR_SIGNTR_NIC_PASPRT")%>')" <%} %>>
				    						<label <% if(AOFDisabledFiledsMap.isFieldDisabled("COPR_DIR_SIGNTR_NIC_PASPRT")){ %> class="red" <%} %> for="documentCheckList10">Cerified copy of the National Identity card / Valid Passport of Directors and Authorised Signatories</label>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td>
				    						<input type="checkbox" id="documentCheckList11" name="CORP_DIR_SIGNTR_KYC" value="Y" <%if("Y".equals(cifData.get("CORP_DIR_SIGNTR_KYC"))){%> checked="checked" <%} %>
				    						<% if(AOFDisabledFiledsMap.isFieldDisabled("CORP_DIR_SIGNTR_KYC")){ %> onclick="return forceCheck(this,'<%=cifData.get("CORP_DIR_SIGNTR_KYC")%>')" <%} %>>
				    						<label <% if(AOFDisabledFiledsMap.isFieldDisabled("CORP_DIR_SIGNTR_KYC")){ %> class="red" <%} %> for="documentCheckList11">KYC Profile Form for Directors and Authorised Signatories</label>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td>
				    						<input type="checkbox" id="documentCheckList12" name="CORP_OTHER_DOC" value="Y" <%if("Y".equals(cifData.get("CORP_OTHER_DOC"))){%> checked="checked" <%} %>
				    						<% if(AOFDisabledFiledsMap.isFieldDisabled("CORP_OTHER_DOC")){ %> onclick="return forceCheck(this,'<%=cifData.get("CORP_OTHER_DOC")%>')" <%} %>>
				    						<label <% if(AOFDisabledFiledsMap.isFieldDisabled("CORP_OTHER_DOC")){ %> class="red" <%} %> for="documentCheckList12">
				    							Other : <input type="text" name="CORP_OTHER_DOC_NAME"
				    							<% if(AOFDisabledFiledsMap.isFieldDisabled("CORP_OTHER_DOC")){ %> readonly="readonly" class="input-ovr bacred" <%}else{ %> class="input-ovr" <%} %>
				    							<%if("Y".equals(cifData.get("CORP_OTHER_DOC"))){%> 
				    								value="<%=cifData.get("CORP_OTHER_DOC_NAME") != null ? cifData.get("CORP_OTHER_DOC_NAME") : ""%>"
				    							<%} %>
				    							/>
				    						</label>
				    					</td>
				    				</tr>
				    			</table>
				    		</div>
				    		<% if(canEdit.equals("Y")){ %>
					    	<div class="sectionFooter">
				    			<input name="formSave" type="submit" value="Save" class="btn btn-success"/>
				    			<input name="formClose" type="submit" value="Save & Close" class="btn btn-info"/>
				    		</div>
				    		<%} %>
				    	</div>
				    </div>
				    <div role="tabpanel" class="tab-pane" id="category6">
				    	<div class="section">
				    		<div class="<% if(FORMSTATUS.get("REJECTED_SECTION") != null && FORMSTATUS.get("REJECTED_SECTION").contains("reject_section8")){  %> sectionHeaderRej <%}else{ %> sectionHeader <%} %>">
				    			DETAILS OF PARENT / GUARDIAN / INITIATOR
				    		</div>
				    		<div class="sectionBody">
				    			<table class="table table-bordered">
				    				<tr>
				    					<td <% if(AOFDisabledFiledsMap.isFieldDisabled("MNR_GURDN_RELATN")){ %> class="red" <%} %>>
				    						Relation with Primary Account Holder
				    					</td>
				    					<td>
				    						<select class="form-control input-sm" name="MNR_GURDN_RELATN" <% if(AOFDisabledFiledsMap.isFieldDisabled("MNR_GURDN_RELATN")){ %> onchange="return forceCheckSelect(this,'<%=cifData.get("MNR_GURDN_RELATN")%>')" <%} %>>
				    							<option value=""></option>
				    							<option value="1" <%if("1".equals(cifData.get("MNR_GURDN_RELATN"))){%> selected="selected" <%} %>>Parent</option>
				    							<option value="2" <%if("2".equals(cifData.get("MNR_GURDN_RELATN"))){%> selected="selected" <%} %>>Guardian</option>
				    							<option value="3" <%if("3".equals(cifData.get("MNR_GURDN_RELATN"))){%> selected="selected" <%} %>>Initiator</option>
				    						</select>
				    					</td>
				    				</tr>
					    			<tr>
										<td width="25%" <% if(AOFDisabledFiledsMap.isFieldDisabled("MNR_TITLE")){ %> class="red" <%} %>>
											Title
										</td>
										<td width="75%">
											<ul class="inlineUL">
									    		<li>
									    			<input type="radio" name="MNR_TITLE" id="minorTitleMr" value="1" <%if("1".equals(cifData.get("MNR_TITLE"))){%> checked="checked" <%} %>
													<% if(AOFDisabledFiledsMap.isFieldDisabled("MNR_TITLE")){ %> onclick="return forceCheck(this,'<%=cifData.get("MNR_TITLE")%>')" <%} %>>
									    			<label for="minorTitleMr">Mr.</label>
									    		</li>
									    		<li>
									    			<input type="radio" name="MNR_TITLE" id="minorTitleMiss" value="2" <%if("2".equals(cifData.get("MNR_TITLE"))){%> checked="checked" <%} %>
									    			<% if(AOFDisabledFiledsMap.isFieldDisabled("MNR_TITLE")){ %> onclick="return forceCheck(this,'<%=cifData.get("MNR_TITLE")%>')" <%} %>>
									    			<label for="minorTitleMiss">Miss.</label>
									    		</li>
									    	</ul>
										</td>
									</tr>
									<tr>
										<td <% if(AOFDisabledFiledsMap.isFieldDisabled("MNR_TITLE")){ %> class="red" <%} %>>
											Name
										</td>
										<td>
											<input type="text" class="form-control input-sm" name="MNR_FULLNAME" value="<%= cifData.get("MNR_FULLNAME") != null ? cifData.get("MNR_FULLNAME") : "" %>"
											<% if(AOFDisabledFiledsMap.isFieldDisabled("MNR_TITLE")){ %> readonly="readonly" <%} %>>
										</td>
									</tr>
									<tr>
										<td <% if(AOFDisabledFiledsMap.isFieldDisabled("MNR_TITLE")){ %> class="red" <%} %>>
											Date of Birth
										</td>
										<td>
											<input type="text" name="MNR_DOB" value="<%= cifData.get("MNR_DOB") != null ? cifData.get("MNR_DOB") : "" %>"
											<% if(AOFDisabledFiledsMap.isFieldDisabled("MNR_DOB")){ %> readonly="readonly" class="input-ovr" <%}else{ %> class="datepicker input-ovr" <% } %>>
										</td>
									</tr>
									<tr>
										<td <% if(AOFDisabledFiledsMap.isFieldDisabled("MNR_BIRTHCERT_NO")){ %> class="red" <%} %>>
											NIC / Passport / DL No
										</td>
										<td>
											<input type="text" class="input-ovr" name="MNR_BIRTHCERT_NO" value="<%= cifData.get("MNR_BIRTHCERT_NO") != null ? cifData.get("MNR_BIRTHCERT_NO") : "" %>"
											<% if(AOFDisabledFiledsMap.isFieldDisabled("MNR_BIRTHCERT_NO")){ %> readonly="readonly" <%} %>>
										</td>
									</tr>
									<tr>
										<td <% if(AOFDisabledFiledsMap.isFieldDisabled("MNR_BIRTHCERT_ISS_DATE")){ %> class="red" <%} %>>
											Date of Issue
										</td>
										<td>
											<input type="text" name="MNR_BIRTHCERT_ISS_DATE" value="<%= cifData.get("MNR_BIRTHCERT_ISS_DATE") != null ? cifData.get("MNR_BIRTHCERT_ISS_DATE") : "" %>"
											<% if(AOFDisabledFiledsMap.isFieldDisabled("MNR_BIRTHCERT_ISS_DATE")){ %> readonly="readonly" class="input-ovr" <%}else{ %> class="datepicker input-ovr" <% } %>>
										</td>
									</tr>
									<tr>
										<td <% if(AOFDisabledFiledsMap.isFieldDisabled("MNR_NATIONALITY")){ %> class="red" <%} %>>
											Nationality
										</td>
										<td>
											<select name="MNR_NATIONALITY" class="form-control input-sm" <% if(AOFDisabledFiledsMap.isFieldDisabled("MNR_NATIONALITY")){ %> onchange="return forceCheckSelect(this,'<%=cifData.get("MNR_NATIONALITY")%>')" <%} %>>
												<option value=""></option>
												<%
													while(countryItr.hasNext()){
														String countryCode = countryItr.next();
														String countryName = allCountries.get(countryCode);
												%>
												<option value="<%=countryCode%>" <% if(countryCode.equals(cifData.get("MNR_NATIONALITY"))){ %> selected="selected" <%} %>><%=countryName%></option>
												<%
													}
												%>
											</select>
										</td>
									</tr>
									<tr>
										<td <% if(AOFDisabledFiledsMap.isFieldDisabled("MNR_GENDER")){ %> class="red" <%} %>>Gender</td>
										<td>
											<table width="100%">
												<tr>
													<td>
														<input type="radio" name="MNR_GENDER" id="minorGuardianGenderM" value="M" <% if("M".equals(cifData.get("MNR_GENDER"))){ %> checked="checked" <%} %>
														<% if(AOFDisabledFiledsMap.isFieldDisabled("MNR_GENDER")){ %> onclick="return forceCheck(this,'<%=cifData.get("MNR_GENDER")%>')" <%} %>/>
														<label for="minorGuardianGenderM"> &nbsp;&nbsp;Male</label>
													</td>
													<td>
														<input type="radio" name="MNR_GENDER" id="minorGuardianGenderF" value="F" <% if("F".equals(cifData.get("MNR_GENDER"))){ %> checked="checked" <%} %>
														<% if(AOFDisabledFiledsMap.isFieldDisabled("MNR_GENDER")){ %> onclick="return forceCheck(this,'<%=cifData.get("MNR_GENDER")%>')" <%} %>/>
														<label for="minorGuardianGenderF"> &nbsp;&nbsp;Female</label>
													</td>
												</tr>
											</table>
										</td>
									</tr>
									<tr>
										<td>
											Address and Contact
										</td>
										<td>
											<table width="100%">
												<tr>
													<td width="15%" <% if(AOFDisabledFiledsMap.isFieldDisabled("MNR_ADDR1")){ %> class="red" <%} %>>Address</td>
													<td width="85%"><input type="text" name="MNR_ADDR1" class="form-control input-sm" value="<%= cifData.get("MNR_ADDR1") != null ? cifData.get("MNR_ADDR1") : ""%>"
													<% if(AOFDisabledFiledsMap.isFieldDisabled("MNR_ADDR1")){ %> readonly="readonly" <%} %>></td>
												</tr>
												<tr>
													<td <% if(AOFDisabledFiledsMap.isFieldDisabled("MNR_ADDR2")){ %> class="red" <%} %>>Mobile No</td>
													<td><input type="text" name="MNR_ADDR2" class="form-control input-sm" value="<%= cifData.get("MNR_ADDR2") != null ? cifData.get("MNR_ADDR2") : ""%>"
													<% if(AOFDisabledFiledsMap.isFieldDisabled("MNR_ADDR2")){ %> readonly="readonly" <%} %>></td>
												</tr>
												<tr>
													<td <% if(AOFDisabledFiledsMap.isFieldDisabled("MNR_ADDR3")){ %> class="red" <%} %>>Email ID</td>
													<td><input type="text" name="MNR_ADDR3" class="form-control input-sm" value="<%= cifData.get("MNR_ADDR3") != null ? cifData.get("MNR_ADDR3") : ""%>"
													<% if(AOFDisabledFiledsMap.isFieldDisabled("MNR_ADDR3")){ %> readonly="readonly" <%} %>></td>
												</tr>
											</table>
										</td>
									</tr>
									<tr>
										<td <% if(AOFDisabledFiledsMap.isFieldDisabled("MNR_TELEPHONE")){ %> class="red" <%} %>>
											Telephone No
										</td>
										<td>
											<input type="text" class="form-control input-sm" name="MNR_TELEPHONE" value="<%= cifData.get("MNR_TELEPHONE") != null ? cifData.get("MNR_TELEPHONE") : ""%>"
											<% if(AOFDisabledFiledsMap.isFieldDisabled("MNR_TELEPHONE")){ %> readonly="readonly" <%} %>>
										</td>
									</tr>
									<tr>
										<td <% if(AOFDisabledFiledsMap.isFieldDisabled("MNR_OCCUPATION")){ %> class="red" <%} %>>
											Occupation
										</td>
										<td>
											<input type="text" class="form-control input-sm" name="MNR_OCCUPATION" value="<%= cifData.get("MNR_OCCUPATION") != null ? cifData.get("MNR_OCCUPATION") : ""%>"
											<% if(AOFDisabledFiledsMap.isFieldDisabled("MNR_OCCUPATION")){ %> readonly="readonly" <%} %>>
										</td>
									</tr>
									<tr>
										<td <% if(AOFDisabledFiledsMap.isFieldDisabled("MNR_GURDN_CORRESPONDENCE")){ %> class="red" <%} %>>
											Correspondence
										</td>
										<td>
											<table width="100%">
												<tr>
													<td>
														<input type="radio" name="MNR_GURDN_CORRESPONDENCE" id="minorGuardianCorrespondence1" value="1" <% if("1".equals(cifData.get("MNR_GURDN_CORRESPONDENCE"))){ %> checked="checked" <%} %>
														<% if(AOFDisabledFiledsMap.isFieldDisabled("MNR_GURDN_CORRESPONDENCE")){ %> onclick="return forceCheck(this,'<%=cifData.get("MNR_GURDN_CORRESPONDENCE")%>')" <%} %>>
														<label for="minorGuardianCorrespondence1">Minor's Res. Address</label>
													</td>
													<td>
														<input type="radio" name="MNR_GURDN_CORRESPONDENCE" id="minorGuardianCorrespondence2" value="2" <% if("2".equals(cifData.get("MNR_GURDN_CORRESPONDENCE"))){ %> checked="checked" <%} %>
														<% if(AOFDisabledFiledsMap.isFieldDisabled("MNR_GURDN_CORRESPONDENCE")){ %> onclick="return forceCheck(this,'<%=cifData.get("MNR_GURDN_CORRESPONDENCE")%>')" <%} %>>
														<label for="minorGuardianCorrespondence2">Parent / Guardian / Initiator's Res. Address</label>
													</td>
													<td>
														<input type="radio" name="MNR_GURDN_CORRESPONDENCE" id="minorGuardianCorrespondence3" value="3" <% if("3".equals(cifData.get("MNR_GURDN_CORRESPONDENCE"))){ %> checked="checked" <%} %>
														<% if(AOFDisabledFiledsMap.isFieldDisabled("MNR_GURDN_CORRESPONDENCE")){ %> onclick="return forceCheck(this,'<%=cifData.get("MNR_GURDN_CORRESPONDENCE")%>')" <%} %>>
														<label for="minorGuardianCorrespondence3">Parent / Guardian / Initiator's Off. Address</label>
													</td>
												</tr>
											</table>
										</td>
									</tr>
									<tr>
										<td colspan="2" <% if(AOFDisabledFiledsMap.isFieldDisabled("MNR_GURDN_TAX_DECL")){ %> class="red" <%} %>>
											Declaration by Parent / Guardian / Inititator for withholding tax on profit earning
											as required by the Inland Revenue Act 10 of 2007
											<br/>
											<input type="checkbox" value="Y" name="MNR_GURDN_TAX_DECL" id="minorTax" <% if("Y".equals(cifData.get("MNR_GURDN_TAX_DECL"))){ %> checked="checked" <%} %>
											<% if(AOFDisabledFiledsMap.isFieldDisabled("MNR_GURDN_TAX_DECL")){ %> onclick="return forceCheck(this,'<%=cifData.get("MNR_GURDN_TAX_DECL")%>')" <%} %>>
											<label for="minorTax">Declaration attached in order to obtain WHT exemption</label>										
										</td>
									</tr>
				    			</table>
				    		</div>
				    		<% if(canEdit.equals("Y")){ %>
					    	<div class="sectionFooter">
				    			<input name="formSave" type="submit" value="Save" class="btn btn-success"/>
				    			<input name="formClose" type="submit" value="Save & Close" class="btn btn-info"/>
				    		</div>
				    		<%} %>
				    	</div>
				    </div>
				    <div role="tabpanel" class="tab-pane" id="category4">
				    	<div class="section">
				    		<div class="<% if(FORMSTATUS.get("REJECTED_SECTION") != null && FORMSTATUS.get("REJECTED_SECTION").contains("reject_section9")){  %> sectionHeaderRej <%}else{ %> sectionHeader <%} %>">
				    			FOR BANK USE ONLY 
				    		</div>
				    		<div class="sectionBody">
				    			<table class="table table-bodered">
				    				<tr>
				    					<td width="25%" <% if(AOFDisabledFiledsMap.isFieldDisabled("NAME_DOB_NTNATLY_VERF_BY")){ %> class="red" <%} %>>Name, Date of Birth and Nationality Verification By</td>
				    					<td width="75%">
				    						<table width="100%">
				    							<tr>
				    								<td width="50%">
				    								<input type="checkbox" name="NDN_VRF_BY_NIC" id="nameDobNationalityVerificationBy1" value="Y" <% if("Y".equals(cifData.get("NDN_VRF_BY_NIC"))){ %> checked="checked" <%} %>
				    								<% if(AOFDisabledFiledsMap.isFieldDisabled("NAME_DOB_NTNATLY_VERF_BY")){ %> onclick="return forceCheck(this,'<%=cifData.get("NAME_DOB_NTNATLY_VERF_BY")%>')" <%} %>>
				    								<label for="nameDobNationalityVerificationBy1">National Identity card</label>
				    								</td>
				    								<td width="50%">
				    								<input type="checkbox" name="NDN_VRF_BY_ARM_FRCE" id="nameDobNationalityVerificationBy2" value="Y" <% if("Y".equals(cifData.get("NDN_VRF_BY_ARM_FRCE"))){ %> checked="checked" <%} %>
				    								<% if(AOFDisabledFiledsMap.isFieldDisabled("NAME_DOB_NTNATLY_VERF_BY")){ %> onclick="return forceCheck(this,'<%=cifData.get("NAME_DOB_NTNATLY_VERF_BY")%>')" <%} %>>
				    								<label for="nameDobNationalityVerificationBy2">Official Armed Forces Service card</label>
				    								</td>
				    							</tr>
				    							<tr>
				    								<td>
				    								<input type="checkbox" name="NDN_VRF_BY_PASSPORT" id="nameDobNationalityVerificationBy3" value="Y" <% if("Y".equals(cifData.get("NDN_VRF_BY_PASSPORT"))){ %> checked="checked" <%} %>
				    								<% if(AOFDisabledFiledsMap.isFieldDisabled("NAME_DOB_NTNATLY_VERF_BY")){ %> onclick="return forceCheck(this,'<%=cifData.get("NAME_DOB_NTNATLY_VERF_BY")%>')" <%} %>>
				    								<label for="nameDobNationalityVerificationBy3">Passport / Visa</label>
				    								</td>
				    								<td>
				    								<input type="checkbox" name="NDN_VRF_BY_DL" id="nameDobNationalityVerificationBy4" value="Y" <% if("Y".equals(cifData.get("NDN_VRF_BY_DL"))){ %> checked="checked" <%} %>
				    								<% if(AOFDisabledFiledsMap.isFieldDisabled("NAME_DOB_NTNATLY_VERF_BY")){ %> onclick="return forceCheck(this,'<%=cifData.get("NAME_DOB_NTNATLY_VERF_BY")%>')" <%} %>>
				    								<label for="nameDobNationalityVerificationBy4">Official Driving License</label>
				    								</td>
				    							</tr>
				    							<tr>
				    								<td>
				    								<input type="checkbox" name="NDN_VRF_BY_POSTALID" id="nameDobNationalityVerificationBy5" value="Y" <% if("Y".equals(cifData.get("NDN_VRF_BY_POSTALID"))){ %> checked="checked" <%} %>
				    								<% if(AOFDisabledFiledsMap.isFieldDisabled("NAME_DOB_NTNATLY_VERF_BY")){ %> onclick="return forceCheck(this,'<%=cifData.get("NAME_DOB_NTNATLY_VERF_BY")%>')" <%} %>>
				    								<label for="nameDobNationalityVerificationBy5">Postal ID (for person under 18 years of age)</label>
				    								</td>
				    								<td>
				    								<input type="checkbox" name="NDN_VRF_BY_MARIG_CERT" id="nameDobNationalityVerificationBy6" value="Y" <% if("Y".equals(cifData.get("NDN_VRF_BY_MARIG_CERT"))){ %> checked="checked" <%} %>
				    								<% if(AOFDisabledFiledsMap.isFieldDisabled("NAME_DOB_NTNATLY_VERF_BY")){ %> onclick="return forceCheck(this,'<%=cifData.get("NAME_DOB_NTNATLY_VERF_BY")%>')" <%} %>>
				    								<label for="nameDobNationalityVerificationBy6">Marriage Certificate (for only Name Change purpose)</label>
				    								</td>
				    							</tr>
				    							<tr>
				    								<td>
					    								<input type="checkbox" name="NDN_VRF_BY_BRANCH" id="nameDobNationalityVerificationBy7" value="Y" <% if("Y".equals(cifData.get("NDN_VRF_BY_BRANCH"))){ %> checked="checked" <%} %>
					    								<% if(AOFDisabledFiledsMap.isFieldDisabled("NAME_DOB_NTNATLY_VERF_BY")){ %> onclick="return forceCheck(this,'<%=cifData.get("NAME_DOB_NTNATLY_VERF_BY")%>')" <%} %>>
					    								<label for="nameDobNationalityVerificationBy7">Branch Officials</label>
					    								</td>
				    								<td>
				    									<input type="checkbox" name="NDN_VRF_BY_OTR" id="nameDobNationalityVerificationBy8" value="Y" <% if("Y".equals(cifData.get("NDN_VRF_BY_OTR"))){ %> checked="checked" <%} %>
					    								<% if(AOFDisabledFiledsMap.isFieldDisabled("NAME_DOB_NTNATLY_VERF_BY")){ %> onclick="return forceCheck(this,'<%=cifData.get("NAME_DOB_NTNATLY_VERF_BY")%>')" <%} %>>
					    								<label for="nameDobNationalityVerificationBy8">
					    									Other: <input type="text" name="NDN_VRF_BY_OTR_NAME"  class="input-ovr"
					    									<% if(AOFDisabledFiledsMap.isFieldDisabled("NAME_DOB_NTNATLY_VERF_BY")){ %> readonly="readonly" <%} %>
					    									<% if("Y".equals(cifData.get("NDN_VRF_BY_OTR"))){ %>
					    										value="<%= cifData.get("NDN_VRF_BY_OTR_NAME") != null ? cifData.get("NDN_VRF_BY_OTR_NAME") : "" %>"
					    									<%} %>
					    									/>
					    								</label>
				    								</td>
				    							</tr>
				    						</table>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td>
				    						Address Verification By
				    					</td>
				    					<td>
				    						<table width="100%">
				    							<tr>
				    								<td width="50%">
				    								<input type="checkbox" name="ADDR_VERF_UTILITY_BILL" id="addressVerificationBy1" value="Y" <% if("Y".equals(cifData.get("ADDR_VERF_UTILITY_BILL"))){ %> checked="checked" <%} %>
				    								<% if(AOFDisabledFiledsMap.isFieldDisabled("ADDR_VERF_UTILITY_BILL")){ %> onclick="return forceCheck(this,'<%=cifData.get("ADDR_VERF_UTILITY_BILL")%>')" <%} %>>
				    								<label <% if(AOFDisabledFiledsMap.isFieldDisabled("ADDR_VERF_UTILITY_BILL")){ %> class="red" <%} %> for="addressVerificationBy1">
				    									Utility Bill: <input type="text" name="ADDR_VERF_UTILITY_BILL_NAME"
				    									<% if(AOFDisabledFiledsMap.isFieldDisabled("ADDR_VERF_UTILITY_BILL")){ %> readonly="readonly" class="input-ovr bacred"<%}else{ %> class="input-ovr" <%} %>
				    									<% if("Y".equals(cifData.get("ADDR_VERF_UTILITY_BILL"))){ %>
				    										value="<%= cifData.get("ADDR_VERF_UTILITY_BILL_NAME") != null ? cifData.get("ADDR_VERF_UTILITY_BILL_NAME") : "" %>"
				    									<%} %>
				    									/>
				    								</label>
				    								</td>
				    								<td width="50%">
				    								<input type="checkbox" name="ADDR_VERF_BANK_STMNT" id="addressVerificationBy2" value="Y" <% if("Y".equals(cifData.get("ADDR_VERF_BANK_STMNT"))){ %> checked="checked" <%} %>
				    								<% if(AOFDisabledFiledsMap.isFieldDisabled("ADDR_VERF_BANK_STMNT")){ %> onclick="return forceCheck(this,'<%=cifData.get("ADDR_VERF_BANK_STMNT")%>')" <%} %>>
				    								<label <% if(AOFDisabledFiledsMap.isFieldDisabled("ADDR_VERF_BANK_STMNT")){ %> class="red" <%} %> for="addressVerificationBy2">Statement of Other Bank</label>
				    								</td>
				    							</tr>
				    							<tr>
				    								<td>
				    								<input type="checkbox" name="ADDR_VERF_TENANCY_AGGR" id="addressVerificationBy3" value="Y" <% if("Y".equals(cifData.get("ADDR_VERF_TENANCY_AGGR"))){ %> checked="checked" <%} %>
				    								<% if(AOFDisabledFiledsMap.isFieldDisabled("ADDR_VERF_TENANCY_AGGR")){ %> onclick="return forceCheck(this,'<%=cifData.get("ADDR_VERF_TENANCY_AGGR")%>')" <%} %>>
				    								<label <% if(AOFDisabledFiledsMap.isFieldDisabled("ADDR_VERF_TENANCY_AGGR")){ %> class="red" <%} %> for="addressVerificationBy3">Tenancy Agreement</label>
				    								</td>
				    								<td>
				    								<input type="checkbox" name="ADDR_VERF_EMP_CONTRACT" id="addressVerificationBy4" value="Y" <% if("Y".equals(cifData.get("ADDR_VERF_EMP_CONTRACT"))){ %> checked="checked" <%} %>
				    								<% if(AOFDisabledFiledsMap.isFieldDisabled("ADDR_VERF_EMP_CONTRACT")){ %> onclick="return forceCheck(this,'<%=cifData.get("ADDR_VERF_EMP_CONTRACT")%>')" <%} %>>
				    								<label <% if(AOFDisabledFiledsMap.isFieldDisabled("ADDR_VERF_EMP_CONTRACT")){ %> class="red" <%} %> for="addressVerificationBy4">Employment Contract</label>
				    								</td>
				    							</tr>
				    							<tr>
				    								<td>
				    								<input type="checkbox" name="ADDR_VERF_NIC" id="addressVerificationBy5" value="Y" <% if("Y".equals(cifData.get("ADDR_VERF_NIC"))){ %> checked="checked" <%} %>
				    								<% if(AOFDisabledFiledsMap.isFieldDisabled("ADDR_VERF_NIC")){ %> onclick="return forceCheck(this,'<%=cifData.get("ADDR_VERF_NIC")%>')" <%} %>>
				    								<label <% if(AOFDisabledFiledsMap.isFieldDisabled("ADDR_VERF_NIC")){ %> class="red" <%} %> for="addressVerificationBy5">National Identity card</label>
				    								</td>
				    								<td>
				    								<input type="checkbox" name="ADDR_VERF_PUB_AUTH_LTTR" id="addressVerificationBy6" value="Y" <% if("Y".equals(cifData.get("ADDR_VERF_PUB_AUTH_LTTR"))){ %> checked="checked" <%} %>
				    								<% if(AOFDisabledFiledsMap.isFieldDisabled("ADDR_VERF_PUB_AUTH_LTTR")){ %> onclick="return forceCheck(this,'<%=cifData.get("ADDR_VERF_PUB_AUTH_LTTR")%>')" <%} %>>
				    								<label <% if(AOFDisabledFiledsMap.isFieldDisabled("ADDR_VERF_PUB_AUTH_LTTR")){ %> class="red" <%} %> for="addressVerificationBy6">Letter from a Public Authority</label>
				    								</td>
				    							</tr>
				    							<tr>
				    								<td>
				    								<input type="checkbox" name="ADDR_VERF_INCOM_TAX_RECPT" id="addressVerificationBy7" value="Y" <% if("Y".equals(cifData.get("ADDR_VERF_INCOM_TAX_RECPT"))){ %> checked="checked" <%} %>
				    								<% if(AOFDisabledFiledsMap.isFieldDisabled("ADDR_VERF_INCOM_TAX_RECPT")){ %> onclick="return forceCheck(this,'<%=cifData.get("ADDR_VERF_INCOM_TAX_RECPT")%>')" <%} %>>
				    								<label <% if(AOFDisabledFiledsMap.isFieldDisabled("ADDR_VERF_INCOM_TAX_RECPT")){ %> class="red" <%} %> for="addressVerificationBy7">Income Tax Receipts / Assessment Notice</label>
				    								</td>
				    								<td>
				    								<input type="checkbox" name="ADDR_VERF_OTR" id="addressVerificationBy8" value="Y" <% if("Y".equals(cifData.get("ADDR_VERF_OTR"))){ %> checked="checked" <%} %>
				    								<% if(AOFDisabledFiledsMap.isFieldDisabled("ADDR_VERF_OTR")){ %> onclick="return forceCheck(this,'<%=cifData.get("ADDR_VERF_OTR")%>')" <%} %>>
				    								<label <% if(AOFDisabledFiledsMap.isFieldDisabled("ADDR_VERF_OTR")){ %> class="red" <%} %> for="addressVerificationBy8">
				    									Other: <input type="text" name="ADDR_VERF_OTR_NAME" 
				    									<% if(AOFDisabledFiledsMap.isFieldDisabled("ADDR_VERF_OTR")){ %> readonly="readonly" class="input-ovr bacred" <%}else{ %> class="input-ovr"  <%} %>
				    									<% if("Y".equals(cifData.get("ADDR_VERF_OTR"))){ %>
				    										value="<%= cifData.get("ADDR_VERF_OTR_NAME") != null ? cifData.get("ADDR_VERF_OTR_NAME") : "" %>"
				    									<%} %>
				    									/>
				    								</label>
				    								</td>
				    							</tr>
				    						</table>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td>Documents to be obtained</td>
				    					<td>
				    						<table width="100%">
				    							<tr>
				    								<td width="50%">
				    								<input type="checkbox" name="DOC_AOM" id="documentsObtained1" value="Y" <% if("Y".equals(cifData.get("DOC_AOM"))){ %> checked="checked" <%} %>
				    								<% if(AOFDisabledFiledsMap.isFieldDisabled("DOC_AOM")){ %> onclick="return forceCheck(this,'<%=cifData.get("DOC_AOM")%>')" <%} %>>
				    								<label <% if(AOFDisabledFiledsMap.isFieldDisabled("DOC_AOM")){ %> class="red" <%} %> for="documentsObtained1">Completed Account Opoening Mandate</label>
				    								</td>
				    								<td width="50%">
				    								<input type="checkbox" name="DOC_SIGN_CARD" id="documentsObtained2" value="Y" <% if("Y".equals(cifData.get("DOC_SIGN_CARD"))){ %> checked="checked" <%} %>
				    								<% if(AOFDisabledFiledsMap.isFieldDisabled("DOC_SIGN_CARD")){ %> onclick="return forceCheck(this,'<%=cifData.get("DOC_SIGN_CARD")%>')" <%} %>>
				    								<label <% if(AOFDisabledFiledsMap.isFieldDisabled("DOC_SIGN_CARD")){ %> class="red" <%} %> for="documentsObtained2">Specimen Signature card</label>
				    								</td>
				    							</tr>
				    							<tr>
				    								<td>
				    								<input type="checkbox" name="DOC_NIC_PP_DL" id="documentsObtained3" value="Y" <% if("Y".equals(cifData.get("DOC_NIC_PP_DL"))){ %> checked="checked" <%} %>
				    								<% if(AOFDisabledFiledsMap.isFieldDisabled("DOC_NIC_PP_DL")){ %> onclick="return forceCheck(this,'<%=cifData.get("DOC_NIC_PP_DL")%>')" <%} %>>
				    								<label <% if(AOFDisabledFiledsMap.isFieldDisabled("DOC_NIC_PP_DL")){ %> class="red" <%} %> for="documentsObtained3">Copy of NIC/PP/DL</label>
				    								</td>
				    								<td>
				    								<input type="checkbox" name="DOC_MUDARABA_AGGR" id="documentsObtained4" value="Y" <% if("Y".equals(cifData.get("DOC_MUDARABA_AGGR"))){ %> checked="checked" <%} %>
				    								<% if(AOFDisabledFiledsMap.isFieldDisabled("DOC_MUDARABA_AGGR")){ %> onclick="return forceCheck(this,'<%=cifData.get("DOC_MUDARABA_AGGR")%>')" <%} %>>
				    								<label <% if(AOFDisabledFiledsMap.isFieldDisabled("DOC_MUDARABA_AGGR")){ %> class="red" <%} %> for="documentsObtained4">Signed Mudaraba Agreement</label>
				    								</td>
				    							</tr>
				    							<tr>
				    								<td>
				    								<input type="checkbox" name="DOC_MINOR_BIRTH_CERT" id="documentsObtained7" value="Y" <% if("Y".equals(cifData.get("DOC_MINOR_BIRTH_CERT"))){ %> checked="checked" <%} %>
				    								<% if(AOFDisabledFiledsMap.isFieldDisabled("DOC_MINOR_BIRTH_CERT")){ %> onclick="return forceCheck(this,'<%=cifData.get("DOC_MINOR_BIRTH_CERT")%>')" <%} %>>
				    								<label <% if(AOFDisabledFiledsMap.isFieldDisabled("DOC_MINOR_BIRTH_CERT")){ %> class="red" <%} %> for="documentsObtained7">Copy of Minor's Birth Certificate</label>
				    								</td>
				    								<td>
				    								<input type="checkbox" name="DOC_NIC_GUARDIAN" id="documentsObtained8" value="Y" <% if("Y".equals(cifData.get("DOC_NIC_GUARDIAN"))){ %> checked="checked" <%} %>
				    								<% if(AOFDisabledFiledsMap.isFieldDisabled("DOC_NIC_GUARDIAN")){ %> onclick="return forceCheck(this,'<%=cifData.get("DOC_NIC_GUARDIAN")%>')" <%} %>>
				    								<label <% if(AOFDisabledFiledsMap.isFieldDisabled("DOC_NIC_GUARDIAN")){ %> class="red" <%} %> for="documentsObtained8">NIC Copy of Parent/Guardian/Initiator</label>
				    								</td>
				    							</tr>
				    							<tr>
				    								<td>
				    								<input type="checkbox" name="DOC_REG_CERT" id="documentsObtained9" value="Y" <% if("Y".equals(cifData.get("DOC_REG_CERT"))){ %> checked="checked" <%} %>
				    								<% if(AOFDisabledFiledsMap.isFieldDisabled("DOC_REG_CERT")){ %> onclick="return forceCheck(this,'<%=cifData.get("DOC_REG_CERT")%>')" <%} %>>
				    								<label <% if(AOFDisabledFiledsMap.isFieldDisabled("DOC_REG_CERT")){ %> class="red" <%} %> for="documentsObtained9">Certified copy of the Registration Certificate</label>
				    								</td>
				    								<td>
				    								<input type="checkbox" name="DOC_RULES_CONSTITUTION" id="documentsObtained10" value="Y" <% if("Y".equals(cifData.get("DOC_RULES_CONSTITUTION"))){ %> checked="checked" <%} %>
				    								<% if(AOFDisabledFiledsMap.isFieldDisabled("DOC_RULES_CONSTITUTION")){ %> onclick="return forceCheck(this,'<%=cifData.get("DOC_RULES_CONSTITUTION")%>')" <%} %>>
				    								<label <% if(AOFDisabledFiledsMap.isFieldDisabled("DOC_RULES_CONSTITUTION")){ %> class="red" <%} %> for="documentsObtained10">Certified copy of Rules / Constitution</label>
				    								</td>
				    							</tr>
				    							<tr>
				    								<td>
				    								<input type="checkbox" name="DOC_OFF_BEARERS_MEET_EXTRCT" id="documentsObtained11" value="Y" <% if("Y".equals(cifData.get("DOC_OFF_BEARERS_MEET_EXTRCT"))){ %> checked="checked" <%} %>
				    								<% if(AOFDisabledFiledsMap.isFieldDisabled("DOC_OFF_BEARERS_MEET_EXTRCT")){ %> onclick="return forceCheck(this,'<%=cifData.get("DOC_OFF_BEARERS_MEET_EXTRCT")%>')" <%} %>>
				    								<label <% if(AOFDisabledFiledsMap.isFieldDisabled("DOC_OFF_BEARERS_MEET_EXTRCT")){ %> class="red" <%} %> for="documentsObtained11">Certified copy of the extracts of the meeting minutes where Office Bearers were elected</label>
				    								</td>
				    								<td>
				    								<input type="checkbox" name="DOC_ACC_OPEN_RESOL_MEET" id="documentsObtained12" value="Y" <% if("Y".equals(cifData.get("DOC_ACC_OPEN_RESOL_MEET"))){ %> checked="checked" <%} %>
				    								<% if(AOFDisabledFiledsMap.isFieldDisabled("DOC_ACC_OPEN_RESOL_MEET")){ %> onclick="return forceCheck(this,'<%=cifData.get("DOC_ACC_OPEN_RESOL_MEET")%>')" <%} %>>
				    								<label <% if(AOFDisabledFiledsMap.isFieldDisabled("DOC_ACC_OPEN_RESOL_MEET")){ %> class="red" <%} %> for="documentsObtained12">Copy of the minutes of the meeting where it was resolved to open an account with Amana Bank</label>
				    								</td>
				    							</tr>
				    							<tr>
				    								<td>
				    								<input type="checkbox" name="DOC_KYC" id="documentsObtained13" value="Y" <% if("Y".equals(cifData.get("DOC_KYC"))){ %> checked="checked" <%} %>
				    								<% if(AOFDisabledFiledsMap.isFieldDisabled("DOC_KYC")){ %> onclick="return forceCheck(this,'<%=cifData.get("DOC_KYC")%>')" <%} %>>
				    								<label <% if(AOFDisabledFiledsMap.isFieldDisabled("DOC_KYC")){ %> class="red" <%} %> for="documentsObtained13">KYC Form</label>
				    								</td>
				    								<td>
				    								<input type="checkbox" name="DOC_BUSS_REG" id="documentsObtained14" value="Y" <% if("Y".equals(cifData.get("DOC_BUSS_REG"))){ %> checked="checked" <%} %>
				    								<% if(AOFDisabledFiledsMap.isFieldDisabled("DOC_BUSS_REG")){ %> onclick="return forceCheck(this,'<%=cifData.get("DOC_BUSS_REG")%>')" <%} %>>
				    								<label <% if(AOFDisabledFiledsMap.isFieldDisabled("DOC_BUSS_REG")){ %> class="red" <%} %> for="documentsObtained14">Copy of Business Registration</label>
				    								</td>
				    							</tr>
				    							<tr>
				    								<td>
				    								<input type="checkbox" name="DOC_ADDR_VERF_COPY" id="documentsObtained5" value="Y" <% if("Y".equals(cifData.get("DOC_ADDR_VERF_COPY"))){ %> checked="checked" <%} %>
				    								<% if(AOFDisabledFiledsMap.isFieldDisabled("DOC_ADDR_VERF_COPY")){ %> onclick="return forceCheck(this,'<%=cifData.get("DOC_ADDR_VERF_COPY")%>')" <%} %>>
				    								<label <% if(AOFDisabledFiledsMap.isFieldDisabled("DOC_ADDR_VERF_COPY")){ %> class="red" <%} %> for="documentsObtained5">Copy of Address Verification Document</label>
				    								</td>
				    								<td>
				    								<input type="checkbox" name="DOC_OTHER" id="documentsObtained6" value="Y" <% if("Y".equals(cifData.get("DOC_OTHER"))){ %> checked="checked" <%} %>
				    								<% if(AOFDisabledFiledsMap.isFieldDisabled("DOC_OTHER")){ %> onclick="return forceCheck(this,'<%=cifData.get("DOC_OTHER")%>')" <%} %>>
				    								<label <% if(AOFDisabledFiledsMap.isFieldDisabled("DOC_OTHER")){ %> class="red" <%} %> for="documentsObtained6">
				    									Other: <input type="text" name="DOC_OTHER_NANE" 
				    									<% if(AOFDisabledFiledsMap.isFieldDisabled("DOC_OTHER_NANE")){ %> readonly="readonly" class="input-ovr bacred" <%}else{ %> class="input-ovr" <%} %>
				    									<% if("Y".equals(cifData.get("DOC_OTHER"))){ %>
				    										value="<%= cifData.get("DOC_OTHER_NANE") != null ? cifData.get("DOC_OTHER_NANE") : "" %>"
				    									<%} %>
				    									/>
				    								</label>
				    								</td>
				    							</tr>
				    						</table>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td <% if(AOFDisabledFiledsMap.isFieldDisabled("CLIENT_BLACK_LISTED")){ %> class="red" <%} %>>
				    						Does the client/s appear in any know suspected terrorist list or any other alert list
				    					</td>
				    					<td>
				    						<ul class="inlineUL">
				    							<li>
				    								<input type="radio" name="CLIENT_BLACK_LISTED" id="clientInBlackListY" value="Y" <% if("Y".equals(cifData.get("CLIENT_BLACK_LISTED"))){ %> checked="checked" <%} %>
				    								<% if(AOFDisabledFiledsMap.isFieldDisabled("CLIENT_BLACK_LISTED")){ %> onclick="return forceCheck(this,'<%=cifData.get("CLIENT_BLACK_LISTED")%>')" <%} %>>
				    								<label for="clientInBlackListY">Yes</label>
				    							</li>
				    							<li>
				    								<input type="radio" name="CLIENT_BLACK_LISTED" id="clientInBlackListN" value="N" <% if("N".equals(cifData.get("CLIENT_BLACK_LISTED"))){ %> checked="checked" <%} %>
				    								<% if(AOFDisabledFiledsMap.isFieldDisabled("CLIENT_BLACK_LISTED")){ %> onclick="return forceCheck(this,'<%=cifData.get("CLIENT_BLACK_LISTED")%>')" <%} %>>
				    								<label for="clientInBlackListN">No</label>
				    							</li>
				    						</ul>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td <% if(AOFDisabledFiledsMap.isFieldDisabled("CIF_PRIORITY")){ %> class="red" <%} %>>Priority</td>
				    					<td>
				    						<ul class="inlineUL">
				    							<li>
				    								<input type="radio" name="CIF_PRIORITY" id="priority1" value="1" <% if("1".equals(cifData.get("CIF_PRIORITY"))){ %> checked="checked" <%} %>
				    								<% if(AOFDisabledFiledsMap.isFieldDisabled("CIF_PRIORITY")){ %> onclick="return forceCheck(this,'<%=cifData.get("CIF_PRIORITY")%>')" <%} %>>
				    								<label for="priority1">Ordinary</label>
				    							</li>
				    							<li>
				    								<input type="radio" name="CIF_PRIORITY" id="priority2" value="2" <% if("2".equals(cifData.get("CIF_PRIORITY"))){ %> checked="checked" <%} %>
				    								<% if(AOFDisabledFiledsMap.isFieldDisabled("CIF_PRIORITY")){ %> onclick="return forceCheck(this,'<%=cifData.get("CIF_PRIORITY")%>')" <%} %>>
				    								<label for="priority2">Prime</label>
				    							</li>
				    							<li>
				    								<input type="radio" name="CIF_PRIORITY" id="priority3" value="3" <% if("3".equals(cifData.get("CIF_PRIORITY"))){ %> checked="checked" <%} %>
				    								<% if(AOFDisabledFiledsMap.isFieldDisabled("CIF_PRIORITY")){ %> onclick="return forceCheck(this,'<%=cifData.get("CIF_PRIORITY")%>')" <%} %>>
				    								<label for="priority3">VIP</label>
				    							</li>
				    						</ul>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td <% if(AOFDisabledFiledsMap.isFieldDisabled("BANK_USER_CIF_TYPE")){ %> class="red" <%} %>>CIF Type</td>
				    					<td>
				    						<input type="text" name="BANK_USER_CIF_TYPE"  class="form-control input-sm" value="<%= cifData.get("BANK_USER_CIF_TYPE") != null ? cifData.get("BANK_USER_CIF_TYPE") : "" %>"
				    						<% if(AOFDisabledFiledsMap.isFieldDisabled("BANK_USER_CIF_TYPE")){ %> readonly="readonly" <%}%>/>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td <% if(AOFDisabledFiledsMap.isFieldDisabled("ECO_SECTOR")){ %> class="red" <%} %>>Economic Sector</td>
				    					<td>
				    						<input type="text" name="ECO_SECTOR" class="form-control input-sm" value="<%= cifData.get("ECO_SECTOR") != null ? cifData.get("ECO_SECTOR") : "" %>"
				    						<% if(AOFDisabledFiledsMap.isFieldDisabled("ECO_SECTOR")){ %> readonly="readonly" <%}%>/>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td <% if(AOFDisabledFiledsMap.isFieldDisabled("ECO_SUB_SECTOR")){ %> class="red" <%} %>>Economic Sub Sector</td>
				    					<td>
				    						<input type="text" name="ECO_SUB_SECTOR" class="form-control input-sm" value="<%= cifData.get("ECO_SUB_SECTOR") != null ? cifData.get("ECO_SUB_SECTOR") : "" %>"
				    						<% if(AOFDisabledFiledsMap.isFieldDisabled("ECO_SUB_SECTOR")){ %> readonly="readonly" <%}%>/>
				    						<br/>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td <% if(AOFDisabledFiledsMap.isFieldDisabled("DEVISION_CODE")){ %> class="red" <%} %>>Division</td>
				    					<td>
				    						<input type="text" name="DEVISION_CODE" class="form-control input-sm" value="<%= cifData.get("DEVISION_CODE") != null ? cifData.get("DEVISION_CODE") : "" %>"
				    						<% if(AOFDisabledFiledsMap.isFieldDisabled("DEVISION_CODE")){ %> readonly="readonly" <%}%>/>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td <% if(AOFDisabledFiledsMap.isFieldDisabled("DEPT_CODE")){ %> class="red" <%} %>>Department</td>
				    					<td>
				    						<input type="text" name="DEPT_CODE" class="form-control input-sm" value="<%= cifData.get("DEPT_CODE") != null ? cifData.get("DEPT_CODE") : "" %>"
				    						<% if(AOFDisabledFiledsMap.isFieldDisabled("DEPT_CODE")){ %> readonly="readonly" <%}%>/>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td <% if(AOFDisabledFiledsMap.isFieldDisabled("ACCOUNT_TYPE")){ %> class="red" <%} %>>Account Type</td>
				    					<td>
				    						<input type="text" name="ACCOUNT_TYPE" class="form-control input-sm" value="<%= cifData.get("ACCOUNT_TYPE") != null ? cifData.get("ACCOUNT_TYPE") : "" %>"
				    						<% if(AOFDisabledFiledsMap.isFieldDisabled("ACCOUNT_TYPE")){ %> readonly="readonly" <%}%>/>
				    					</td>
				    				</tr>
				    				<!-- 
				    				<tr>
				    					<td>For Branch Approval</td>
				    					<td>
				    						<table class="table table-bordered">
				    							<tr>
				    								<td width="30%" <% if(AOFDisabledFiledsMap.isFieldDisabled("BRNCH_APPROVL_ACC_OPND_DATE")){ %> class="red" <%} %>>Account Opened On</td>
				    								<td width="70%">
				    									<input type="text" name="BRNCH_APPROVL_ACC_OPND_DATE" value="<%= cifData.get("BRNCH_APPROVL_ACC_OPND_DATE") != null ? cifData.get("BRNCH_APPROVL_ACC_OPND_DATE") : "" %>"
				    									<% if(AOFDisabledFiledsMap.isFieldDisabled("BRNCH_APPROVL_ACC_OPND_DATE")){ %> readonly="readonly" class="input-ovr" <%}else{%> class="input-ovr datepicker" <%} %>/>
				    								</td>
				    							</tr>
				    							<tr>
				    								<td <% if(AOFDisabledFiledsMap.isFieldDisabled("BRNCH_APPROVL_ACC_OPND_BY")){ %> class="red" <%} %>>Account Opened By</td>
				    								<td>
				    									<input type="text" name="BRNCH_APPROVL_ACC_OPND_BY" class="form-control input-sm" value="<%= cifData.get("BRNCH_APPROVL_ACC_OPND_BY") != null ? cifData.get("BRNCH_APPROVL_ACC_OPND_BY") : "" %>"
				    									<% if(AOFDisabledFiledsMap.isFieldDisabled("BRNCH_APPROVL_ACC_OPND_BY")){ %> readonly="readonly" <%}%>/>
				    								</td>
				    							</tr>
				    							<tr>
				    								<td <% if(AOFDisabledFiledsMap.isFieldDisabled("BRNCH_APPROVL_AUTH_OFF")){ %> class="red" <%} %>>Authorised Officer</td>
				    								<td>
				    									<input type="text" name="BRNCH_APPROVL_AUTH_OFF" class="form-control input-sm" value="<%= cifData.get("BRNCH_APPROVL_AUTH_OFF") != null ? cifData.get("BRNCH_APPROVL_AUTH_OFF") : "" %>"
				    									<% if(AOFDisabledFiledsMap.isFieldDisabled("BRNCH_APPROVL_AUTH_OFF")){ %> readonly="readonly" <%}%>/>
				    								</td>
				    							</tr>
				    							<tr>
				    								<td <% if(AOFDisabledFiledsMap.isFieldDisabled("BRNCH_APPROVL_AUDT_OFF")){ %> class="red" <%} %>>Audited By</td>
				    								<td>
				    									<input type="text" name="BRNCH_APPROVL_AUDT_OFF" class="form-control input-sm" value="<%= cifData.get("BRNCH_APPROVL_AUDT_OFF") != null ? cifData.get("BRNCH_APPROVL_AUDT_OFF") : "" %>"
				    									<% if(AOFDisabledFiledsMap.isFieldDisabled("BRNCH_APPROVL_AUDT_OFF")){ %> readonly="readonly" <%}%>/>
				    								</td>
				    							</tr>
				    						</table>
				    					</td>
				    				</tr>
				    				 -->
				    				<tr>
				    					<td>For Central Operation</td>
				    					<td>
				    						<table class="table table-bordered">
				    							<tr>
				    								<td width="30%" <% if(AOFDisabledFiledsMap.isFieldDisabled("CPU_OP_RECV_DATE")){ %> class="red" <%} %>>Received Date</td>
				    								<td width="70%">
				    									<input type="text" name="CPU_OP_RECV_DATE" value="<%= cifData.get("CPU_OP_RECV_DATE") != null ? cifData.get("CPU_OP_RECV_DATE") : "" %>"
				    									<% if(AOFDisabledFiledsMap.isFieldDisabled("CPU_OP_RECV_DATE")){ %> readonly="readonly" class="input-ovr" <%}else{%> class="input-ovr datepicker" <%} %>/>
				    								</td>
				    							</tr>
				    							<tr>
				    								<td colspan="2">
				    									<table width="100%">
				    										<tr>
				    											<td>
				    												<input type="checkbox" name="CPU_OP_CIF_COMPLETED" id="cpuCifCompleted" value="Y" <% if("Y".equals(cifData.get("CPU_OP_CIF_COMPLETED"))){ %> checked="checked" <%} %>
				    												<% if(AOFDisabledFiledsMap.isFieldDisabled("CPU_OP_CIF_COMPLETED")){ %> onclick="return forceCheck(this,'<%=cifData.get("CPU_OP_CIF_COMPLETED")%>')" <%} %>>
				    												<label <% if(AOFDisabledFiledsMap.isFieldDisabled("CPU_OP_CIF_COMPLETED")){ %> class="red" <%} %> for="cpuCifCompleted">CIF Completed</label>
				    											</td>
				    											<td>
				    												<input type="checkbox" name="CPU_OP_DOC_CHECKED" id="cpuDocumentsChecked" value="Y" <% if("Y".equals(cifData.get("CPU_OP_DOC_CHECKED"))){ %> checked="checked" <%} %>
				    												<% if(AOFDisabledFiledsMap.isFieldDisabled("CPU_OP_DOC_CHECKED")){ %> onclick="return forceCheck(this,'<%=cifData.get("CPU_OP_DOC_CHECKED")%>')" <%} %>>
				    												<label <% if(AOFDisabledFiledsMap.isFieldDisabled("CPU_OP_DOC_CHECKED")){ %> class="red" <%} %> for="cpuDocumentsChecked">Documents Checked</label>
				    											</td>
				    											<td>
				    												<input type="checkbox" name="CPU_OP_STANDING_ORDER_SETUP" id="cpuStandingOrdersSetup" value="Y" <% if("Y".equals(cifData.get("CPU_OP_STANDING_ORDER_SETUP"))){ %> checked="checked" <%} %>
				    												<% if(AOFDisabledFiledsMap.isFieldDisabled("CPU_OP_STANDING_ORDER_SETUP")){ %> onclick="return forceCheck(this,'<%=cifData.get("CPU_OP_STANDING_ORDER_SETUP")%>')" <%} %>>
				    												<label <% if(AOFDisabledFiledsMap.isFieldDisabled("CPU_OP_STANDING_ORDER_SETUP")){ %> class="red" <%} %> for="cpuStandingOrdersSetup">Standing Orders Setup</label>
				    											</td>
				    										</tr>
				    										<tr>
				    											<td>
				    												<input type="checkbox" name="CPU_OP_MANDATE_COMPLETED" id="cpuMandatesCompleted" value="Y" <% if("Y".equals(cifData.get("CPU_OP_MANDATE_COMPLETED"))){ %> checked="checked" <%} %>
				    												<% if(AOFDisabledFiledsMap.isFieldDisabled("CPU_OP_MANDATE_COMPLETED")){ %> onclick="return forceCheck(this,'<%=cifData.get("CPU_OP_MANDATE_COMPLETED")%>')" <%} %>>
				    												<label <% if(AOFDisabledFiledsMap.isFieldDisabled("CPU_OP_MANDATE_COMPLETED")){ %> class="red" <%} %> for="cpuMandatesCompleted">Mandates Completed</label>
				    											</td>
				    											<td>
				    												<input type="checkbox" name="CPU_OP_SIGN_SCANNED" id="cpuSignatureScanned" value="Y" <% if("Y".equals(cifData.get("CPU_OP_SIGN_SCANNED"))){ %> checked="checked" <%} %>
				    												<% if(AOFDisabledFiledsMap.isFieldDisabled("CPU_OP_SIGN_SCANNED")){ %> onclick="return forceCheck(this,'<%=cifData.get("CPU_OP_SIGN_SCANNED")%>')" <%} %>>
				    												<label <% if(AOFDisabledFiledsMap.isFieldDisabled("CPU_OP_SIGN_SCANNED")){ %> class="red" <%} %> for="cpuSignatureScanned">Signature Scanned</label>
				    											</td>
				    											<td>
				    												<input type="checkbox" name="CPU_OP_STATEMENT_SETUP" id="cpuStatementSetup" value="Y" <% if("Y".equals(cifData.get("CPU_OP_STATEMENT_SETUP"))){ %> checked="checked" <%} %>
				    												<% if(AOFDisabledFiledsMap.isFieldDisabled("CPU_OP_STATEMENT_SETUP")){ %> onclick="return forceCheck(this,'<%=cifData.get("CPU_OP_STATEMENT_SETUP")%>')" <%} %>>
				    												<label <% if(AOFDisabledFiledsMap.isFieldDisabled("CPU_OP_STATEMENT_SETUP")){ %> class="red" <%} %> for="cpuStatementSetup">Statement Setup</label>
				    											</td>
				    										</tr>
				    									</table>
				    								</td>
				    							</tr>
				    							<tr>
				    								<td <% if(AOFDisabledFiledsMap.isFieldDisabled("CPU_OP_DATA_INPUT_BY")){ %> class="red" <%} %>>Data Input By</td>
				    								<td>
				    									<input type="text" name="CPU_OP_DATA_INPUT_BY" class="form-control input-sm" value="<%= cifData.get("CPU_OP_DATA_INPUT_BY") != null ? cifData.get("CPU_OP_DATA_INPUT_BY") : "" %>"
				    									<% if(AOFDisabledFiledsMap.isFieldDisabled("CPU_OP_DATA_INPUT_BY")){ %> readonly="readonly" <%}%>/>
				    								</td>
				    							</tr>
				    							<tr>
				    								<td <% if(AOFDisabledFiledsMap.isFieldDisabled("CPU_OP_AUTH_OFF1")){ %> class="red" <%} %>>Authorised Officer</td>
				    								<td>
				    									<input type="text" name="CPU_OP_AUTH_OFF1" class="form-control input-sm" value="<%= cifData.get("CPU_OP_AUTH_OFF1") != null ? cifData.get("CPU_OP_AUTH_OFF1") : "" %>"
				    									<% if(AOFDisabledFiledsMap.isFieldDisabled("CPU_OP_AUTH_OFF1")){ %> readonly="readonly" <%}%>/>
				    								</td>
				    							</tr>
				    							<tr>
				    								<td <% if(AOFDisabledFiledsMap.isFieldDisabled("CPU_OP_AUTH_OFF2")){ %> class="red" <%} %>>Authorised Officer</td>
				    								<td>
				    									<input type="text" name="CPU_OP_AUTH_OFF2" class="form-control input-sm" value="<%= cifData.get("CPU_OP_AUTH_OFF2") != null ? cifData.get("CPU_OP_AUTH_OFF2") : "" %>"
				    									<% if(AOFDisabledFiledsMap.isFieldDisabled("CPU_OP_AUTH_OFF2")){ %> readonly="readonly" <%}%>/>
				    								</td>
				    							</tr>
				    							<tr>
				    								<td <% if(AOFDisabledFiledsMap.isFieldDisabled("CPU_OP_AUTD_OFF")){ %> class="red" <%} %>>Audited By</td>
				    								<td>
				    									<input type="text" name="CPU_OP_AUTD_OFF" class="form-control input-sm" value="<%= cifData.get("CPU_OP_AUTD_OFF") != null ? cifData.get("CPU_OP_AUTD_OFF") : "" %>"
				    									<% if(AOFDisabledFiledsMap.isFieldDisabled("CPU_OP_AUTD_OFF")){ %> readonly="readonly" <%}%>/>
				    								</td>
				    							</tr>
				    						</table>
				    					</td>
				    				</tr>
				    			</table>
				    		</div>
				    		<% if(canEdit.equals("Y")){ %>
					    	<div class="sectionFooter">
				    			<input name="formSave" type="submit" value="Save" class="btn btn-success"/>
				    			<input name="formClose" type="submit" value="Save & Close" class="btn btn-info"/>
				    		</div>
				    		<%} %>
				    	</div>
				    </div>
				    <div role="tabpanel" class="tab-pane" id="category5">
				    	<div class="section">
				    		<div class="<% if(FORMSTATUS.get("REJECTED_SECTION") != null && FORMSTATUS.get("REJECTED_SECTION").contains("reject_section10")){  %>sectionHeaderRej<%}else{ %>sectionHeader<%} %>">
				    			DOCUMENTS
				    		</div>
				    		<div class="sectionBody">
				    			<table class="table table-bordered">
				    				<% if(canEdit.equals("Y")){ %>
				    				<tr>
				    					<td width="35%">Upload new document</td>
				    					<td width="65%">
				    						<button type="button" class="btn btn-sm btn-primary addAccountHolderModal" cSector="UPL" cCIF="<%=cifNo%>" cAccountNo="<%=accountNo%>" cCaseNo=<%=caseNo%>>Upload</button>
				    					</td>
				    				</tr>
				    				<%} %>
				    				<tr>
				    					<td>
				    						Uploaded files
				    					</td>
				    					<td>
				    						<%
				    						if(uploadData != null && uploadData.size() > 0){
				    							%>
				    							<table class="table table-bordered">
				    							<tr>
				    								<th>Document Name</th>
				    								<th>File Name</th>
				    								<th>Uploaded By</th>
				    								<th>Uploaded on</th>
				    								<th>Download</th>
				    							</tr>
				    							<%
				    							for(int i = 0; i < uploadData.size(); i++){
				    								Map<String, String> upload = uploadData.get(i);
				    								%>
				    								<tr>
				    									<td><%=upload.get("DOC_NAME") != null ? upload.get("DOC_NAME") : ""%></td>
				    									<td><%=upload.get("FILENAME") != null ? upload.get("FILENAME") : ""%></td>
				    									<td><%=upload.get("UPLOADBY") != null ? upload.get("UPLOADBY") : ""%></td>
				    									<td><%=upload.get("UPLOADTIME") != null ? upload.get("UPLOADTIME") : ""%></td>
				    									<td>
				    										<a class="nav-link" href="javascript:void(0)" onclick="viewServerDocument('<%=upload.get("UPLOAD_REF_NO")%>','<%=accountNo%>','N')">View</a>
				    										<% if(canEdit.equals("Y")){ %>
				    										&nbsp;&nbsp;&nbsp;
				    										<a class="nav-link" href="javascript:void(0)" onclick="deleteDocument(this,'<%=upload.get("UPLOAD_REF_NO")%>')">Remove</a>
				    										<%} %>
				    									</td>
				    								</tr>
				    								<%
				    							}
				    							%>
				    							</table>
				    							<%
				    						}
				    						%>
				    					</td>
				    				</tr>
				    			</table>
				    		</div>
				    	</div>
				    </div>
				    <div role="tabpanel" class="tab-pane" id="category7">
						<div class="section">
					    	<div class="sectionHeader">
					    		Checker Response
					    	</div>
					    	<div class="sectionBody">
					    		<table class="table table-bordered">
					    			<tr>
					    				<td>CIF Number</td>
					    				<td>
					    					<%=cifNo%>
					    					<input type="hidden" value="<%=cifNo%>" name="cifNumber"/>
					    				</td>
					    			</tr>
					    			<tr>
					    				<td>Account Number</td>
					    				<td>
					    					<%=accountNo%>
					    					<input type="hidden" value="<%=accountNo%>" name="accNumber"/>
					    				</td>
					    			</tr>
					    			<tr>
					    				<td>Last Modified By</td>
					    				<td><%=FORMSTATUS.get("DATA_UPDATED_BY") != null ? FORMSTATUS.get("DATA_UPDATED_BY") : ""%></td>
					    			</tr>
					    			<tr>
					    				<td>Last Modify time</td>
					    				<td><%=FORMSTATUS.get("DATA_UPDATE_TIMESTAMP") != null ? FORMSTATUS.get("DATA_UPDATE_TIMESTAMP") : ""%></td>
					    			</tr>
					    			<tr>
					    				<td>Status</td>
					    				<td><%=FORMSTATUS.get("STATUS") != null ? FORMSTATUS.get("STATUS") : ""%></td>
					    			</tr>
					    			<tr>
					    				<td>Remarks</td>
					    				<td><%=FORMSTATUS.get("REMARKS") != null ? FORMSTATUS.get("REMARKS") : ""%></td>
					    			</tr>
					    			<tr>
					    				<td>Reason for Reject</td>
					    				<td><%=FORMSTATUS.get("DETAILS_REASON") != null ? FORMSTATUS.get("DETAILS_REASON") : ""%></td>
					    			</tr>
					    			<tr>
					    				<td>Checked By</td>
					    				<td><%=FORMSTATUS.get("DATA_CHECKED_BY") != null ? FORMSTATUS.get("DATA_CHECKED_BY") : ""%></td>
					    			</tr>
					    			<tr>
					    				<td>Checked time</td>
					    				<td><%=FORMSTATUS.get("DATA_CHECK_TIMESTAMP") != null ? FORMSTATUS.get("DATA_CHECK_TIMESTAMP") : ""%></td>
					    			</tr>
					    		</table>
					    	</div>
					    </div>
					</div>
				  </div>
				  </form>
			<%} %>