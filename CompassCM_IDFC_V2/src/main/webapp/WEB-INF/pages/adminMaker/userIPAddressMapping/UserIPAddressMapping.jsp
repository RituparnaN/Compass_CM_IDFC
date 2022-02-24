<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../../tags/tags.jsp"%>
<script type="text/javascript">
	$(document).ready(function(){
		var id = '${UNQID}';
		
		var tableClass = 'userIPMappingSearchResultTable${UNQID}';
		compassDatatable.construct(tableClass, "UserIPAddressMapping", true);
		compassDatatable.enableCheckBoxSelection();
		
		
		$("#selectIPAddressToAssign"+id).click(function(){
			var selectedCount = 0;
			var selectedValue = "";
			var selectedValueDisaplay = "";
			var userCode = $("#userCodeForUserIPMApping"+id).val();
			$(".userIPMappingSearchResultTable"+id).children("tbody").children("tr").each(function(){
				if($(this).children("td").children().is(":checked")){
					selectedValue = selectedValue + $(this).find("td").children().attr("compassId")+",";
					selectedValueDisaplay = selectedValueDisaplay + $(this).find("td").children().attr("compassId")+"\n";
					selectedCount++;
				}
			});
			if(selectedCount > 0){
				if(confirm("Do you want to assign below listed IPAddress to "+userCode+"\n\n"+selectedValueDisaplay)){
					$(this).attr("disabled","disabled");
					$(this).html("Assigning...");
					$.ajax({
			    		url : "${pageContext.request.contextPath}/adminMaker/assignIPAddressToUser?userCode="+userCode+"&selectedIPs="+escape(selectedValue),
			    		cache : false,
			    		type : 'POST',
			    		success : function(resData){
			    			alert(resData);
			    			searchIPAddressForMapping(userCode);
			    		},
			    		error : function(){
			    			alert("Something went wrong");
			    		}
			    	});
				}
			}else{
				alert("Select some IPAddress and try to assign");
			}
		});
	});
</script>
<div class="row">
	<div class="col-sm-12">
		<div class="card card-primary">
			<div class="card-header clearfix">
		   		<h6 class="card-title pull-${dirL}">Assign IPAddress to ${USERCODE}</h6>
			</div>
			<div class="searchResult">
				<input type="hidden" id="userCodeForUserIPMApping${UNQID}" value="${USERCODE}"/>
				<table class="table table-bordered table-striped searchResultGenericTable userIPMappingSearchResultTable${UNQID}" id="userIPMappingSearchResultTable${UNQID}">
					<thead>
						<tr>
							<th class="info no-sort">
								<input type="checkbox" class="checkbox-check-all" compassTable="userIPMappingSearchResultTable${UNQID}"/>
							</th>
							<th class="info">IPAddress</th>
							<th class="info">System Name</th>
							<th class="info">Status</th>
							<th class="info">User Assigned</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="searchIP" items="${ALLIPADDRESS}">
						<c:set var="otherUsers" value="${searchIP['OTHERUSERS']}"/>
							<tr>
								<td>
									<input type="checkbox" compassId="${searchIP['IPADDRESS']}"	<c:if test="${not empty searchIP['IPSTATUS']}">checked = "checked"</c:if> /> 
								</td>
								<td>${searchIP['IPADDRESS']}</td>
								<td>${searchIP['SYSTEMNAME']}</td>
								<td>${searchIP['IPSTATUS']}</td>
								<td>
									<c:forEach var="otherUser" items="${otherUsers}">${otherUser}&#x200E;<br/></c:forEach>
								</td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>
			<div id="userIPMappingSearchResultButtons" class="card-footer">
				<div class="action-footer clearfix">
					<div class="pull-${dirR}">
						<div class="btn-group">
							<button type="button" class="btn btn-primary btn-sm" id="selectIPAddressToAssign${UNQID}">Assign</button>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
