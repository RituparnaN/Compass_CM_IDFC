<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="java.util.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
String contextPath = request.getContextPath() == null ? "" : request.getContextPath();
String caseNo = (String) request.getAttribute("caseNo");
String lineNo = (String) request.getAttribute("lineNo");

Map<String, String> formData = request.getAttribute("ACCOUNTHOLDERDETAILS") != null ? (Map<String, String>) request.getAttribute("ACCOUNTHOLDERDETAILS") : new HashMap<String, String>();

List<String[]> allTitles = request.getAttribute("ALLTITLES") != null ? (List<String[]>) request.getAttribute("ALLTITLES") : new ArrayList<String[]>();
List<String[]> allContries = request.getAttribute("ALLCOUNTRIES") != null ? (List<String[]>) request.getAttribute("ALLCOUNTRIES") : new ArrayList<String[]>();
%>
<style type="text/css">
.FATCAdatepicker{
	background-image:url("${pageContext.request.contextPath}/includes/images/calendar.png");
	background-repeat:no-repeat;
	background-position: 98%;
}
</style>
<script type="text/javascript">
	$(document).ready(function(){
		$(".FATCAdatepicker").datepicker({
			 dateFormat : "yy-mm-dd",
			 changeMonth: true,
		     changeYear: true
		 });

		$(".titleChange").change(function(){
			var targetattr = $(this).attr("targetattr");
			var sourceattr = $(this).attr("sourceattr");
			changeName(sourceattr, targetattr);
		});
		$(".nameChange").keyup(function(){
			var targetattr = $(this).attr("targetattr");
			var sourceattr = $(this).attr("sourceattr");
			changeName(sourceattr, targetattr);
		});
	});
	
	
	
	$("#saveFATCAAccountHolder").submit(function(e){
		var formObj = $("#saveFATCAAccountHolder");
		var formData = $(formObj).serialize();
		var caseNo = $(formObj).find("input#caseNo").val();
		$.ajax({
			url : "<%=contextPath%>/common/saveFATCAAccountHolder",
			type : 'POST',
			cache : false,
			data : formData,
			success : function(res){
				alert(res);
				$("#addNewIndividualModal").modal("hide");
				$("#compassCaseWorkFlowGenericModal-body").html("<br/><center><img alt='Loading...' src='${pageContext.request.contextPath}/includes/images/qde-loadder.gif'></center><br/>");
				$.ajax({
					url: "${pageContext.request.contextPath}/common/get8966Form",
					cache: false,
					type: 'POST',
					data: "caseNo="+caseNo,
					success: function(res) {
						$("#compassCaseWorkFlowGenericModal-body").html(res);
					},
					error: function(a,b,c) {
						alert(a+b+c);
					}
				});
			},
			error : function(a,b,c){
				$('#addNewIndividualModal').modal('hide');
				alert("Error occured while getting data : "+c);
			}
		});
		e.preventDefault();
	});

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
</script>
</head>
<body style="z-index: 9999">
	<form action="javascript:void(0)" method="POST" id="saveFATCAAccountHolder">
		<input type="hidden" name="caseNo" id="caseNo" value="<%=caseNo%>">
		<input type="hidden" name="lineNo" value="<%=lineNo%>">
		<table class="table">
			<tr>
				<td colspan="4">
					<table width="100%" class="table">
						<tr>
							<td width="15%">
								Title
								<select name="ACC_HLDR_TITLE" id="ACC_HLDR_TITLE" class="form-control input-sm titleChange" targetattr="ACC_HLDR_NAME" sourceattr="ACC_HLDR">
									<option value=""></option>
									<%
									for(int i = 0; i < allTitles.size(); i++){
										String[] title = allTitles.get(i);
									%>
										<option value="<%=title[0]%>" <%=title[0].equals(formData.get("II_TITLE")) ? "selected='selected'" : ""%> > <%=title[1]%> </option>
									<%}%>
								</select>
							</td>
							<td width="28%">
								First Name
								<br/>
								<input type="text" class="input-sm form-control nameChange" id="ACC_HLDR_FIRSTNAME" targetattr="ACC_HLDR_NAME"  sourceattr="ACC_HLDR" name="ACC_HLDR_FIRSTNAME"
								value="<%=formData.get("ACC_HLDR_FIRSTNAME") != null ? formData.get("ACC_HLDR_FIRSTNAME") : ""%>"/>
							</td>
							<td width="28%">
								Middle Name
								<br/>
								<input type="text" class="input-sm form-control nameChange" id="ACC_HLDR_MIDDLENAME" targetattr="ACC_HLDR_NAME"  sourceattr="ACC_HLDR" name="ACC_HLDR_MIDDLENAME"
								value="<%=formData.get("ACC_HLDR_MIDDLENAME") != null ? formData.get("ACC_HLDR_MIDDLENAME") : ""%>"/>
							</td>
							<td width="29%">
								Last Name
								<br/>
								<input type="text" class="input-sm form-control nameChange" id="ACC_HLDR_LASTNAME" targetattr="ACC_HLDR_NAME"  sourceattr="ACC_HLDR" name="ACC_HLDR_LASTNAME"
								value="<%=formData.get("ACC_HLDR_LASTNAME") != null ? formData.get("ACC_HLDR_LASTNAME") : ""%>"/>
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td colspan="4">
					1 Name of Account Holder or Payee
					<br/>
					<input type="text" class="input-sm form-control" id="ACC_HLDR_NAME" name="ACC_HLDR_NAME" 
					value="<%=formData.get("ACC_HLDR_NAME") != null ? formData.get("ACC_HLDR_NAME") : ""%>" readonly="readonly"/>
				</td>
			</tr>
			<tr>
				<td colspan="4">
					2 Number, street, and room or suite no. (if P.O. box, see instructions)
					<br/>
					<input type="text" class="input-sm form-control" id="ACC_HLDR_ROOM_STREET" name="ACC_HLDR_ROOM_STREET" 
					value="<%=formData.get("ACC_HLDR_ROOM_STREET") != null ? formData.get("ACC_HLDR_ROOM_STREET") : ""%>"/>
				</td>
			</tr>
			<tr>
				<td width="25%">
					3a City or town
					<br/>
					<input type="text" class="input-sm form-control" id="ACC_HLDR_CITY" name="ACC_HLDR_CITY" 
					value="<%=formData.get("ACC_HLDR_CITY") != null ? formData.get("ACC_HLDR_CITY") : ""%>"/>
				</td>
				<td width="25%">
					3b State/Province/Region
					<br/>
					<input type="text" class="input-sm form-control" id="ACC_HLDR_STATE" name="ACC_HLDR_STATE" 
					value="<%=formData.get("ACC_HLDR_STATE") != null ? formData.get("ACC_HLDR_STATE") : ""%>"/>
				</td>
				<td width="25%">
					3c Country
					<br/>
					<select class="input-sm form-control" id="ACC_HLDR_COUNTRY" name="ACC_HLDR_COUNTRY">
						<option value=""></option>
						<%
							for(int i = 0; i < allContries.size(); i++){
								String[] country = allContries.get(i);
							%>
							<option value="<%=country[0]%>" <%=country[0].equals(formData.get("ACC_HLDR_COUNTRY")) ? "selected='selected'" : ""%> > <%=country[1]%> </option>
						<%}%>
					</select>
				</td>
				<td width="25%">
					3d Postal Code
					<br/>
					<input type="text" class="input-sm form-control" id="ACC_HLDR_POSTALCODE" name="ACC_HLDR_POSTALCODE" 
					value="<%=formData.get("ACC_HLDR_POSTALCODE") != null ? formData.get("ACC_HLDR_POSTALCODE") : ""%>"/>
				</td>
			</tr>
			<tr>
				<td colspan="2">
					4 Nationality
					<br/>
					<input type="text" class="input-sm form-control" id="ACC_HLDR_NATIONALITY" name="ACC_HLDR_NATIONALITY" 
					value="<%=formData.get("ACC_HLDR_NATIONALITY") != null ? formData.get("ACC_HLDR_NATIONALITY") : ""%>"/>
				</td>
				<td colspan="2">
					5 TIN
					<br/>
					<input type="text" class="input-sm form-control" id="ACC_HLDR_TIN" name="ACC_HLDR_TIN" 
					value="<%=formData.get("ACC_HLDR_TIN") != null ? formData.get("ACC_HLDR_TIN") : ""%>"/>
				</td>
			</tr>
			<tr>
				<td>
					6a Date of Birth
					<br/>
					<input type="text" class="input-sm form-control FATCAdatepicker" id="ACC_HLDR_DOB" name="ACC_HLDR_DOB" 
					value="<%=formData.get("ACC_HLDR_DOB") != null ? formData.get("ACC_HLDR_DOB") : ""%>"/>
				</td>
				<td>
					6b Birth City
					<br/>
					<input type="text" class="input-sm form-control" id="ACC_HLDR_BIRTHCITY" name="ACC_HLDR_BIRTHCITY" 
					value="<%=formData.get("ACC_HLDR_BIRTHCITY") != null ? formData.get("ACC_HLDR_BIRTHCITY") : ""%>"/>
				</td>
				<td>
					6c Birth Country
					<br/>
					<select class="input-sm form-control" class="input-sm form-control" id="ACC_HLDR_BIRTHCOUNTRY">
						<option value=""></option>
						<%
							for(int i = 0; i < allContries.size(); i++){
								String[] country = allContries.get(i);
							%>
							<option value="<%=country[0]%>" <%=country[0].equals(formData.get("ACC_HLDR_BIRTHCOUNTRY")) ? "selected='selected'" : ""%> > <%=country[1]%> </option>
						<%}%>
					</select>
				</td>
				<td>
					6d Formar Country Name
					<br/>
					<input type="text" class="input-sm form-control" id="ACC_HLDR_BIRTHFORMARCOUNTRY" name="ACC_HLDR_BIRTHFORMARCOUNTRY" 
					value="<%=formData.get("ACC_HLDR_BIRTHFORMARCOUNTRY") != null ? formData.get("ACC_HLDR_BIRTHFORMARCOUNTRY") : ""%>"/>
				</td>
			</tr>
			<tr>
				<td colspan="4">
					5 If account holder or payee is an entity, check applicable box to specify the entity's type:
					<br/>
					<table width="100%">
						<tr>
							<td width="50%">
								<label for="ACC_HLDR_OWNR_DOC_FFI">
									<input type="checkbox" id="ACC_HLDR_OWNR_DOC_FFI" name="ACC_HLDR_OWNR_DOC_FFI" value="FATCA101"
									<% if("FATCA101".equals(formData.get("ACC_HLDR_OWNR_DOC_FFI"))){ %> checked="checked" <%} %>
									/>
									Owner-Documented FFI with specified U.S. owner(s)
								</label>
							</td>
							<td width="50%">
								<label for="ACC_HLDR_PSSV_NFFE">
									<input type="checkbox" id="ACC_HLDR_PSSV_NFFE" name="ACC_HLDR_PSSV_NFFE" value="FATCA102"
									<% if("FATCA102".equals(formData.get("ACC_HLDR_PSSV_NFFE"))){ %> checked="checked" <%} %>
									/>
									Passive NFFE with substantial U.S. owner(s)
								</label>
							</td>
						</tr>
						<tr>
							<td>
								<label for="ACC_HLDR_NONPRTCIPTING_FFI">
									<input type="checkbox" id="ACC_HLDR_NONPRTCIPTING_FFI" name="ACC_HLDR_NONPRTCIPTING_FFI" value="FATCA103"
									<% if("FATCA103".equals(formData.get("ACC_HLDR_NONPRTCIPTING_FFI"))){ %> checked="checked" <%} %>
									/>
									Non-Participating FFI
								</label>
							</td>
							<td>
								<label for="ACC_HLDR_US_PERSON">
									<input type="checkbox" id="ACC_HLDR_US_PERSON" name="ACC_HLDR_US_PERSON" value="FATCA104"
									<% if("FATCA104".equals(formData.get("ACC_HLDR_US_PERSON"))){ %> checked="checked" <%} %>
									/>
									Specified U.S. Person
								</label>
							</td>
						</tr>
						<tr>
							<td colspan="2">
								<label for="ACC_HLDR_DRCT_REPORTING">
									<input type="checkbox" id="ACC_HLDR_DRCT_REPORTING" name="ACC_HLDR_DRCT_REPORTING" value="FATCA105"
									<% if("FATCA105".equals(formData.get("ACC_HLDR_DRCT_REPORTING"))){ %> checked="checked" <%} %>
									/>
									Direct Reporting NFFE
								</label>
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td colspan="2">
					1 Account Number
					<br/>
					<input type="text" class="input-sm form-control" id="FI_ACCOUNT_NO" name="FI_ACCOUNT_NO"  
					value="<%=formData.get("FI_ACCOUNT_NO") != null ? formData.get("FI_ACCOUNT_NO") : ""%>"/>
				</td>
				<td colspan="2">
					2 Currency Code
					<br/>
					<input type="text" class="input-sm form-control" id="FI_CURRENCY_CODE" name="FI_CURRENCY_CODE"  
					value="<%=formData.get("FI_CURRENCY_CODE") != null ? formData.get("FI_CURRENCY_CODE") : ""%>"/>
				</td>
			</tr>
			<tr>
				<td colspan="4">
					3 Account Balance
					<br/>
					<input type="text" class="input-sm form-control" id="FI_ACCOUNT_BAL" name="FI_ACCOUNT_BAL"  
					value="<%=formData.get("FI_ACCOUNT_BAL") != null ? formData.get("FI_ACCOUNT_BAL") : ""%>"/>
				</td>
			</tr>
			<tr>
				<td colspan="2">
					4a Interest
					<br/>
					<input type="text" class="input-sm form-control" id="FI_INTEREST" name="FI_INTEREST"  
					value="<%=formData.get("FI_INTEREST") != null ? formData.get("FI_INTEREST") : ""%>"/>
				</td>
				<td colspan="2">
					4c Gross proceeds/Redemptions
					<br/>
					<input type="text" class="input-sm form-control" id="FI_GROSS_PRCD_RDMPTN" name="FI_GROSS_PRCD_RDMPTN"  
					value="<%=formData.get("FI_GROSS_PRCD_RDMPTN") != null ? formData.get("FI_GROSS_PRCD_RDMPTN") : ""%>"/>
				</td>
			</tr>
			<tr>
				<td colspan="2">
					4b Dividends
					<br/>
					<input type="text" class="input-sm form-control" id="FI_DIVIDENTS" name="FI_DIVIDENTS"  
					value="<%=formData.get("FI_DIVIDENTS") != null ? formData.get("FI_DIVIDENTS") : ""%>"/>
				</td>
				<td colspan="2">
					4d Other
					<br/>
					<input type="text" class="input-sm form-control" id="FI_OTHERS" name="FI_OTHERS"  
					value="<%=formData.get("FI_OTHERS") != null ? formData.get("FI_OTHERS") : ""%>"/>
				</td>
			</tr>
		</table>		
		<div class="modal-footer">
	      	<button type="submit" class="btn btn-sm btn-success">
	      	<% if("0".equals(lineNo)){ %>
	      		Save
	      	<% }else{ %>
	      		Update
	      	<%} %>
	      	</button>
	      	<button type="button" class="btn btn-sm btn-danger" data-dismiss="modal">Close</button>
      </div>
	</form>
</body>
</html>