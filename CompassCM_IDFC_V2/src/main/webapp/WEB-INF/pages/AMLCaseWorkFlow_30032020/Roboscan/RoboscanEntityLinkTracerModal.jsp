<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*,com.quantumdataengines.app.compass.util.CommonUtil"%>
<%@ include file="../../tags/tags.jsp"%>
<%-- <jsp:include page="../../tags/staticFiles.jsp"/> --%>

<%
Map<String, Object> EntityTracerData = (Map<String, Object>) request.getAttribute("EntityTracerData");
String headerName = "";
%>
<script type="text/javascript">
	var id = '${UNQID}';
	$(document).ready(function(){
		compassDatatable.construct("entityLinkTracer", "Entity Link Tracer", true);

	$("a").each(function() {
		if($(this).hasClass("count")){
			$(this).parent("td").parent("tr").css("background","#FFFF99");
		}
		if($(this).hasClass("count1")){
			$(this).parent("td").parent("tr").css("background","red");
		}
	});	
		
	});
	
	function openAcctDetails(strval) { 
		var RequestType = '';
		if(strval == 'N.A.') {
			alert('Details not available');
			return false;
		}
		var detailPageUrl = "MasterModules/AccountsMaster/AccountDetails";
		openDetails(this, 'Account Details', strval,'accountsMaster', detailPageUrl);
	}
	
	function openCustDetails(strval) {
		var RequestType = '';
		if(strval == 'N.A.') {
			alert('Details not available');
			return false;
		}
		var detailPageUrl = "KYCModules/CustomerMaster/CustomerDetails";
		openDetails(this, 'Customer Details', strval,'customerMaster', detailPageUrl);
	}

	function openLinkDetails(strAccountNo, strLinkedAcctNo, strLinkedCustId, strLinkedCustName,strLinkedType) {
		var fromDate  = $(".entityLinkAnalysisFromDate"+id).val();
		var toDate  = $(".entityLinkAnalysisToDate"+id).val();
		if(strLinkedType != 'TRANSACTION') {
			alert('Details of only transaction links are available');
			return false;
		}
		var fullData = "l_strAccountNo="+strAccountNo+"&l_strLinkedAcctNo="+strLinkedAcctNo+"&l_strLinkedCustId="+strLinkedCustId+"&l_strLinkedCustName="+strLinkedCustName+"&l_strLinkedType="+strLinkedType+"&l_strFromDate="+fromDate+"&l_strToDate="+toDate;
		
		$("#compassGenericModal").modal("show");
		$("#compassGenericModal-title").html("Linked Transactions");
		$.ajax({
			url: "${pageContext.request.contextPath}/common/getLinkedTransactions",
			cache: false,
			type: "POST",
			data: fullData,
			success: function(res){
				$("#compassGenericModal-body").html(res);
			},
			error: function(a,b,c){
				alert(a+b+c);
			}
		});
	}
	
	function newEntityTracerSearch(customerName, customerId, accountNo){
		if(confirm("Do you want to search with below parameters ? \nCustomer Id: "+
			customerId+"\nCustomer Name: "+customerName+"\n Account No.: "+accountNo)){

			var fromDate  = $("#fromDate").val();
			var toDate  = $("#toDate").val();			  
			$("#FormFromDate").val(fromDate);
			$("#FormToDate").val(toDate);

			$("#accountNumber").val(accountNo);			  
			$("#CustomerId").val(customerId);
			$("#CustomerName").val(customerName);
			$("#FormAccountNumber").val(accountNo);

			var formObj = $("#entityLinkDetailsForm");
			var formData = (formObj).serialize();
			
			$("#Search, #AdvSearch").attr("disabled","disabled");
			$("#Search, #AdvSearch").html("Searching...");
			$("#entityLinkAnalysisSerachResultPanel"+id).css("display", "block");
			$("#entityLinkTracerModal").modal("hide");
			
			$.ajax({
				url: "${pageContext.request.contextPath}/common/getEntityLinkedDetailsTabView",
				cache: false,
				type: "POST",
				data: formData,
				success: function(res) {
					$("#entityLinkAnalysisSerachResult"+id).html(res);
					$("#Search, #AdvSearch").removeAttr("disabled");
					$("#Search, #AdvSearch").html("Show Tab View");
				},
				error: function(a,b,c) {
					alert(a+b+c);
				}
			});
		}
	}
	
</script>

<div class="row">
	<div class="col-sm-12">
		<div class="card card-primary">
<div id="searchResultGenericDiv">
	<%
	if(EntityTracerData != null && EntityTracerData.size() > 0){
		EntityTracerData.remove("TABORDER");
		Iterator<String> tabNameItr = EntityTracerData.keySet().iterator();
	%>
	
	<div role="tabpanel">
		<ul class="nav nav-tabs" role="tablist" id="entityTracerTab">
		<%
			int tabIndex = 1;
			while(tabNameItr.hasNext()){
		%>
				<li role="presentation" class='<%=tabIndex == 1 ? "active" : ""%>' id="liLevel_<%=tabIndex%>">
					<a class="subTab" href="#entityTracerTab<%=tabIndex%>" aria-controls="entityTracerTab<%=tabIndex%>" role="tab" data-toggle="tab"><%=tabNameItr.next()%></a>
				</li>
				<%
				tabIndex++;
			}
				%>
		</ul>
		<div class="tab-content">
			<%
			tabIndex = 1;
			tabNameItr = EntityTracerData.keySet().iterator();
			while(tabNameItr.hasNext()){
				String tabName = tabNameItr.next();
				HashMap<String, ArrayList<ArrayList<String>>> tabDetailsMap = (HashMap<String, ArrayList<ArrayList<String>>>) EntityTracerData.get(tabName);

				ArrayList<ArrayList<String>> headerList = tabDetailsMap.get("listResultHeader");
				ArrayList<ArrayList<String>> dataList = tabDetailsMap.get("listResultData");
			%>
			<div role="tabpanel" class="tab-pane <%=tabIndex == 1 ? "active" : ""%>" id="entityTracerTab<%=tabIndex%>">
			<% if(dataList.size() == 0){%>
				<br/><center>No Record Found</center><br/>
			<%}else{%>
				<table class="table table-striped table-bordered searchResultGenericTable entityLinkTracer">
					<thead>
						<tr>
							<%
								for(int headMainIndex = 0; headMainIndex < headerList.size(); headMainIndex++){
									ArrayList<String> headerListSub = headerList.get(headMainIndex);
							%>
									<th width='6px'><spring:message code="app.common.SONO"/></th>
							<%   
									for(int headSubIndex = 0; headSubIndex < headerListSub.size(); headSubIndex++){
										headerName = CommonUtil.changeColumnName(headerListSub.get(headSubIndex));
							%>
										<th><spring:message code="<%=headerName%>"/></th>
							<%		}
								}
							%>
						</tr>
					</thead>
					<tbody>
					<%
						for(int rowIndex = 0; rowIndex < dataList.size(); rowIndex++){
							ArrayList<String> rowList = dataList.get(rowIndex);
					%>
							<tr>
								<td><%=rowIndex+1%></td>
					<%
							for(int colIndex = 0; colIndex < rowList.size(); colIndex++){
					%>
								<%if(colIndex == 0 || colIndex == 2){ %>
									<td style="font-weight:bold;font-size:12px;color:black">
										<a href="javascript:void()" onclick="openAcctDetails('<%=rowList.get(colIndex)%>')">
											<%=rowList.get(colIndex)%>
										</a>
									</td>
								<%} else if(colIndex == 6 && rowList.get(colIndex) != "N.A.") {%>
									<td>
										<a href="javascript:void()" onclick="entityTracerLevelSearch('<%=rowList.get(2)%>','<%=tabIndex%>','<%=rowList.get(colIndex)%>')"><%=rowList.get(colIndex)%></a>
									</td>
								<%} else if(colIndex == 1){%>
									<td>
										<a href="javascript:void()" onclick="newEntityTracerSearch('<%=rowList.get(4)%>','<%=rowList.get(3)%>','<%=rowList.get(2)%>')"><%=rowList.get(colIndex)%></a>
									</td>
								<%}else if(colIndex == 5){%>
									<td>
										<select name="PossibleLinks" id="PossibleLinks" onchange="return saveForceLink(this,'<%=rowList.get(0)%>', '<%=rowList.get(1)%>', '<%=rowList.get(2)%>', '<%=rowList.get(3)%>', '<%=rowList.get(4)%>')">
											<option value="None" <%= rowList.get(colIndex).equalsIgnoreCase("None") ? "selected" : "" %>>None</option>
											<option value="Parents/Child" <%= rowList.get(colIndex).equalsIgnoreCase("Parents/Child") ? "selected" : "" %>>Parents/Child</option>
											<option value="Spouse" <%= rowList.get(colIndex).equalsIgnoreCase("Spouse") ? "selected" : "" %>>Spouse</option>
											<option value="CloseRelatives" <%= rowList.get(colIndex).equalsIgnoreCase("CloseRelatives") ? "selected" : "" %>>CloseRelatives</option>
											<option value="Friends" <%= rowList.get(colIndex).equalsIgnoreCase("Friends") ? "selected" : "" %>>Friends</option>
											<option value="Others" <%= rowList.get(colIndex).equalsIgnoreCase("Others") ? "selected" : "" %>>Others</option>
										</select>
									</td>
								<%}else if(colIndex == 3){%>
									<td>
										<a href="javascript:void()" onclick="openCustDetails('<%=rowList.get(colIndex)%>')"><%=rowList.get(colIndex)%></a>
									</td>
								<%}else if(colIndex == 7){%>
									<td>
										<a href="javascript:void()" onclick="openLinkDetails('<%=rowList.get(0)%>', '<%=rowList.get(2)%>', '<%=rowList.get(3)%>', '<%=rowList.get(4)%>', '<%=rowList.get(1)%>')"><%=rowList.get(colIndex)%></a>
									</td>
								<%}else if(colIndex == 10){%>
									<td>
										<a href="javascript:void()" onclick="openLinkDetails('<%=rowList.get(0)%>', '<%=rowList.get(2)%>', '<%=rowList.get(3)%>', '<%=rowList.get(4)%>', '<%=rowList.get(1)%>')"
										<%if (!"0".equals(rowList.get(colIndex)) && !"N.A.".equals(rowList.get(colIndex))) { %> class = "count"  <%}%>> <%= rowList.get(colIndex)%>
										</a>
									</td>
								<%}else if(colIndex == 11){%>
									<td>
										<a href="javascript:void()" onclick="openLinkDetails('<%=rowList.get(0)%>', '<%=rowList.get(2)%>', '<%=rowList.get(3)%>', '<%=rowList.get(4)%>', '<%=rowList.get(1)%>')"
										<%if (!"0".equals(rowList.get(colIndex)) && !"N.A.".equals(rowList.get(colIndex))) { %> class = "count1"  <%}%>> <%= rowList.get(colIndex)%>
										</a>
									</td>
								<%} else {%>
									<td><%=rowList.get(colIndex)%></td>
								<% } %>
					<%}%>
							</tr>
				<%}%>
			</tbody>
		</table>
		<%}%>
	</div>
	<%
		tabIndex++;
		}
	}
	%>
</div>
</div>
</div>
</div>
</div>
</div>