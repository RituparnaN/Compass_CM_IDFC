<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%> 
<%@ include file="../tags/tags.jsp"%>
<script type="text/javascript">
	$(document).ready(function(){
		var processing = 0;
		$("#checkerIPAddressActionButtons > button").click(function(){
			var action = $(this).attr("id");
			var button = $(this);
			var makerId = $("#ipMakerCodeToApprove").val();
			var remarks = escape($("#checkerIPAddressRemarks").val());
			var ipaddress = escape($("#ipAddressToApprove").val());
			var ipmaker = ipaddress+","+makerId;
			
			
			if(remarks.trim() == ""){
				alert("Enter remakrs");
				$("#checkerIPAddressRemarks").focus();
			}else if(processing == 1){
				alert("Processing previous request...");
			}else {
				var buttonText = $(button).html();
				var updateText = "";
				var fulldata = "makercode="+makerId+"&remakrs="+remarks+"&ipaddress="+ipaddress;
				var url = "";
				if(action == "approveIPAddress"){
					url = "${pageContext.request.contextPath}/checker/checkIPAddressApprove";
					updateText = "Approving...";
				}else if(action == "rejectIPAddress"){
					url = "${pageContext.request.contextPath}/checker/checkIPAddressReject";
					updateText = "Rejecting...";
				}
				
				if(confirm("Do you really want to "+buttonText)){
					processing = 1;
					$(button).attr("disabled","disabled");
					$(button).html(updateText);					
					$.ajax({
			    		url : url,
			    		cache : false,
			    		data : fulldata,
			    		type : 'POST',
			    		success : function(resData){
			    			alert(resData);
			    			$(button).parents(".resultRow").html("");
			    			$("#approveIPAddressForCheck option[value='"+ipmaker+"']").remove();
			    			$(button).removeAttr("disabled");
							$(button).html(buttonText);		
			    		},
			    		error : function(){
			    			alert("Something went wrong");
			    		}
			    	});	
				}		
			}
		});
	});
</script>
<div class="row resultRow">
	<div class="col-sm-12">
		<div class="card card-default">
			<div class="card-header clearfix">
		      <h6 class="card-title pull-${dirL}">Checker IPAddress </h6>
		      </div>
		      	<c:choose>
		      		<c:when test="${f:length(IPDETAILS) > 0}">
					<table class="table table-striped">						
						<c:choose>
							<c:when test="${IPDETAILS['ISNEWIPADDRESS'] == 'Yes'}">
								<tr>
									<td width="18%">IPAddress</td>
									<td width="82%">${IPDETAILS['IPADDRESS']}</td>
								</tr>
								<tr>
									<td width="18%">Newly Created</td>
									<td width="82%">
										${IPDETAILS['ISNEWIPADDRESS']}
										<input type="hidden" id="ipMakerCodeToApprove" value="${IPDETAILS['MAKERCODE']}"/>
									</td>
								</tr>
								<tr>
									<td width="18%">System Name</td>
									<td width="82%">${IPDETAILS['MAKERSYSTEMNAME']}</td>
								</tr>
								<tr>
									<td width="18%">IP Enabled</td>
									<td width="82%">${IPDETAILS['MAKERISENABLED']}</td>
								</tr>
								<tr>
									<td width="18%">Created By</td>
									<td width="82%">${IPDETAILS['MAKERUPDATEDBY']}</td>
								</tr>
								<tr>
									<td width="18%">Created on</td>
									<td width="82%">${IPDETAILS['MAKERUPDATETIMESTAMP']}</td>
								</tr>
								<tr>
									<td width="18%">Remarks</td>
									<td width="82%" colspan="2">
										<textarea rows="2" class="form-control" id="checkerIPAddressRemarks"></textarea>
									</td>
								</tr>
							</c:when>
							<c:otherwise>
								<tr>
									<td width="18%">IPAddress</td>
									<td width="82%" colspan="2">${IPDETAILS['IPADDRESS']}</td>
								</tr>
								<tr>
									<td width="18%">Newly Created</td>
									<td width="82%" colspan="2">
										${IPDETAILS['ISNEWIPADDRESS']}
										<input type="hidden" id="ipMakerCodeToApprove" value="${IPDETAILS['MAKERCODE']}"/>
									</td>
								</tr>
								<tr>
									<th width="20%" class="success">Fields</th>
									<th width="40%" class="success">Current</th>
									<th width="40%" class="success">Update</th>
								</tr>
								<tr>
									<td width="20%">System Name</td>
									<td width="40%">${IPDETAILS['SYSTEMNAME']}</td>
									<td width="40%">${IPDETAILS['MAKERSYSTEMNAME']}</td>
								</tr>
								<tr>
									<td width="20%">IP Enabled</td>
									<td width="40%">${IPDETAILS['ISENABLED']}</td>
									<td width="40%">${IPDETAILS['MAKERISENABLED']}</td>
								</tr>
								<tr>
									<td width="20%">Created By</td>
									<td width="40%">${IPDETAILS['UPDATEDBY']}</td>
									<td width="40%">${IPDETAILS['MAKERUPDATEDBY']}</td>
								</tr>
								<tr>
									<td width="20%">Created on</td>
									<td width="40%">${IPDETAILS['UPDATETIMESTAMP']}</td>
									<td width="40%">${IPDETAILS['MAKERUPDATETIMESTAMP']}</td>
								</tr>
								<tr>
									<td width="20%">Remarks</td>
									<td width="80%" colspan="2">
										<textarea rows="2" class="form-control input-sm" id="checkerIPAddressRemarks"></textarea>
									</td>
								</tr>
							</c:otherwise>
						</c:choose>
						
					</table>
					<input type="hidden" id="ipAddressToApprove" value="${IPDETAILS['IPADDRESS']}"/>
					<div class="card-footer clearfix">
				        <div class="pull-${dirR}" id="checkerIPAddressActionButtons">
				            <button type="button" class="btn btn-primary btn-sm" id="approveIPAddress">Approve</button>
				            <button type="button" class="btn btn-primary btn-sm" id="rejectIPAddress">Reject</button>
				        </div>
			    	</div>
			    	</c:when>
			    	<c:otherwise>
			    		No Pending details found
			    	</c:otherwise>
		      	</c:choose>
		      	
			</div>
	</div>
</div>