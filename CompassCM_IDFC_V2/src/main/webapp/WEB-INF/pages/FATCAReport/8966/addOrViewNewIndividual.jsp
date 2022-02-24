<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="java.util.*"%>
<%
String contextPath = request.getContextPath() == null ? "" : request.getContextPath();
String caseNo = (String) request.getAttribute("caseNo");
String lineNo = (String) request.getAttribute("lineNo");

Map<String, String> formData = request.getAttribute("INDIVIDUALDETAILS") != null ? (Map<String, String>) request.getAttribute("INDIVIDUALDETAILS") : new HashMap<String, String>();

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
		
		$("#saveIndividualDetails").submit(function(e){
			var formObj = $("#saveIndividualDetails");
			var formData = $(formObj).serialize();
			var caseNo = $(formObj).find("input#caseNo").val();
			$.ajax({
				url : "<%=contextPath%>/common/saveIndividualDetails",
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
	<form action="<%=contextPath%>/saveIndividualDetails" method="POST" id="saveIndividualDetails">
		<input type="hidden" name="caseNo" id="caseNo" value="<%=caseNo%>">
		<input type="hidden" name="lineNo" value="<%=lineNo%>">
		<table class="table">
			<tr>
				<td colspan="4">
					Account Number
					<br/>
					<input type="text" class="input-sm form-control" id="FI<%=lineNo%>_ACCOUNTNUMBER" name="FI_ACCOUNTNUMBER" 
					value="<%= formData.get("FI_ACCOUNTNUMBER") != null ? formData.get("FI_ACCOUNTNUMBER") : "" %>"/>
				</td>
			</tr>
			<tr>
				<td colspan="4">
					<table class="table">						
						<tr>
							<td width="15%">
								Title
								<select name="II_TITLE" id="II<%=lineNo%>_TITLE" class="form-control input-sm titleChange" targetattr="II<%=lineNo%>_NAME" sourceattr="II<%=lineNo%>">
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
								<input type="text" class="input-sm form-control nameChange" id="II<%=lineNo%>_FIRSTNAME" targetattr="II<%=lineNo%>_NAME"  sourceattr="II<%=lineNo%>" name="II_FIRSTNAME"
								value="<%=formData.get("II_FIRSTNAME") != null ? formData.get("II_FIRSTNAME") : ""%>"/>
							</td>
							<td width="28%">
								Middle Name
								<br/>
								<input type="text" class="input-sm form-control nameChange" id="II<%=lineNo%>_MIDDLENAME" targetattr="II<%=lineNo%>_NAME"  sourceattr="II<%=lineNo%>" name="II_MIDDLENAME"
								value="<%=formData.get("II_MIDDLENAME") != null ? formData.get("II_MIDDLENAME") : ""%>"/>
							</td>
							<td width="29%">
								Last Name
								<br/>
								<input type="text" class="input-sm form-control nameChange" id="II<%=lineNo%>_LASTNAME" targetattr="II<%=lineNo%>_NAME"  sourceattr="II<%=lineNo%>" name="II_LASTNAME"
								value="<%=formData.get("II_LASTNAME") != null ? formData.get("II_LASTNAME") : ""%>"/>
							</td>
						</tr>
					</table>
				</td>				
			</tr>
			<tr>
				<td colspan="4">
					1 Name of Owner
					<br/>
					<input type="text" class="input-sm form-control" id="II<%=lineNo%>_NAME" name="II_NAME" 
					value="<%= formData.get("II_NAME") != null ? formData.get("II_NAME") : "" %>" readonly="readonly"/>
				</td>
			</tr>
			<tr>
				<td colspan="4">
					2 Number, street, and room or suite no. (if P.O. box, see instructions)
					<br/>
					<input type="text" class="input-sm form-control" id="II<%=lineNo%>_ROOM_STREET" name="II_ROOM_STREET" 
					value="<%= formData.get("II_ROOM_STREET") != null ? formData.get("II_ROOM_STREET") : "" %>" />
				</td>
			</tr>
			<tr>
				<td width="25%">
					3a. City or town
					<br/>
					<input type="text" class="input-sm form-control" id="II<%=lineNo%>_CITY" name="II_CITY" 
					value="<%= formData.get("II_CITY") != null ? formData.get("II_CITY") : "" %>" />
				</td>
				<td width="25%">
					3b. State/Province/Region
					<br/>
					<input type="text" class="input-sm form-control" id="II<%=lineNo%>_STATE" name="II_STATE" 
					value="<%= formData.get("II_STATE") != null ? formData.get("II_STATE") : "" %>" />
				</td>
				<td width="25%">
					3c. Country
					<br/>
					<select class="input-sm form-control" id="II<%=lineNo%>_COUNTRY" name="II_COUNTRY">
						<option value=""></option>
						<%
							for(int i = 0; i < allContries.size(); i++){
								String[] country = allContries.get(i);
							%>
							<option value="<%=country[0]%>" <%=country[0].equals(formData.get("II_COUNTRY")) ? "selected='selected'" : ""%> > <%=country[1]%> </option>
						<%}%>
					</select>
				</td>
				<td width="25%">
					3d. Postal Code
					<br/>
					<input type="text" class="input-sm form-control" id="II<%=lineNo%>_POSTALCODE" name="II_POSTALCODE" 
					value="<%= formData.get("II_POSTALCODE") != null ? formData.get("II_POSTALCODE") : "" %>" />
				</td>
			</tr>
			<tr>
				<td colspan="2">
					4 Nationality
					<br/>
					<input type="text" class="input-sm form-control" id="II<%=lineNo%>_NATOINALITY" name="II_NATOINALITY" 
					value="<%= formData.get("II_NATOINALITY") != null ? formData.get("II_NATOINALITY") : "" %>" />
				</td>
				<td colspan="2">
					5 TIN of Owner
					<br/>
					<input type="text" class="input-sm form-control" id="II<%=lineNo%>_TIN" name="II_TIN" 
					value="<%= formData.get("II_TIN") != null ? formData.get("II_TIN") : "" %>" />
				</td>
			</tr>
			<tr>
				<td>
					6a. Date of Birth
					<br/>
					<input type="text" class="input-sm form-control FATCAdatepicker" id="II<%=lineNo%>_DOB" name="II_DOB" 
					value="<%= formData.get("II_DOB") != null ? formData.get("II_DOB") : "" %>" />
				</td>
				<td>
					6b. Birth City
					<br/>
					<input type="text" class="input-sm form-control" id="II<%=lineNo%>_BIRTHCITY" name="II_BIRTHCITY" 
					value="<%= formData.get("II_BIRTHCITY") != null ? formData.get("II_BIRTHCITY") : "" %>" />
				</td>
				<td>
					6c. Birth Country
					<br/>
					<select class="input-sm form-control" id="II<%=lineNo%>_BIRTHCOUNTRY" name="II_BIRTHCOUNTRY">
						<option value=""></option>
						<%
							for(int i = 0; i < allContries.size(); i++){
								String[] country = allContries.get(i);
							%>
							<option value="<%=country[0]%>" <%=country[0].equals(formData.get("II_BIRTHCOUNTRY")) ? "selected='selected'" : ""%> > <%=country[1]%> </option>
						<%}%>
					</select>
				</td>
				<td>
					6d. Formar Country Name
					<br/>
					<input type="text" class="input-sm form-control" id="II<%=lineNo%>_BIRTHFORMARCOUNTRY" name="II_BIRTHFORMARCOUNTRY" 
					value="<%= formData.get("II_BIRTHFORMARCOUNTRY") != null ? formData.get("II_BIRTHFORMARCOUNTRY") : "" %>" />
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