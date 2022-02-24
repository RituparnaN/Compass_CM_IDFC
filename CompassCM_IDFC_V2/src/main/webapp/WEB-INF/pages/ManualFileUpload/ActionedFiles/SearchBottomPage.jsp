<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../../tags/tags.jsp"%>
<c:set var="MODULETYPE" value="${moduleType}"/>
<c:set var="MODULENAME" value="${moduleName}"/>
<c:set var="UNQID" value="${UNQID}"/>
<c:set var="HEADER" value="${SEARCHRESULT['HEADER']}"/>
<c:set var="DATA" value="${SEARCHRESULT['DATA']}"/>
<c:set var="RECORDCOUNT" value="${f:length(DATA)}"/>

<script type="text/javascript">
$(document).ready(function(){
	var id = '${UNQID}';
	var parameters = '${PARAMETERS}';
	var tableClass = '${MODULETYPE}${UNQID}';
	var searchButton = '${submitButton}';
	var fileName = "";
	var fileType = "";
	var isLoggedData = "Y";
	
	
	console.log(parameters.split(","));
		
	compassDatatable.construct(tableClass, "${MODULENAME}", true);
	compassDatatable.enableCheckBoxSelection();
	
	function getFileTypeAndName(number,callback){
		var status = false;
		var url = "${pageContext.request.contextPath}/common/getFileTypeAndName";
		$.ajax({
			url: url,
			cache: false,
			type: "GET",
			data: {number:number,parameters:parameters,isLoggedData:isLoggedData},
			success: function(res) {
				if(res['STATUS'] == true)
				{ let fileData = res["FILEDATA"]; 
					fileName = fileData["FILENAME"];
					fileType =  fileData["FILETYPE"];
					status =  true;
				}
			},
			complete: function(){
				if(status == true){
					callback();
				}else{
					alert("error while getting file type and name");
				}
			},
			error: function(a,b,c) {
				console.log();
				return true;
			}
		});
	}
	
	$("#viewEvidence"+id).click(function(){
			var caseNo = "";
			var count = 0;
			var sequenceNo;
			var uploadType;
			var uploadReferenceNo;
			$("#searchResultGenericTable"+tableClass).children("tbody").children("tr").each(function(){
				var row = $(this).children("td").children("input[type='checkbox']");
				if($(row).prop("checked")){
					sequenceNo =  $(this).children("td:nth-child(2)").html();
					uploadType =  $(this).children("td:nth-child(3)").html();
					uploadReferenceNo =  $(this).children("td:nth-child(4)").html();
					count ++;
				}
			});
			if(count == 0){
				alert("Select a record");
			}else if(count > 1){
				alert("Select only one record");
			} else {
				//alert("select sequence = "+sequenceNo);
				//fileName,fileType  add these variable as needed.
				/* 
				getFileTypeAndName(sequenceNo,function(){
					// fileName = '5678';
					// fileType = '119901';
					// alert("file name = "+fileName+" , type = "+fileType);
					compassFileUpload.init("attachEvedence","${pageContext.request.contextPath}",fileName,"actionedFilesSerachResult"+id,"N","N",fileType);
				});
				 */
				compassFileUpload.init("attachEvedence","${pageContext.request.contextPath}",uploadType,"pendingFilesSerachResult"+id,"N","N",uploadReferenceNo); 
			}	
		});
});
</script>

<div id="searchResultGenericDiv">
	<table class="table table-bordered table-striped searchResultGenericTable ${MODULETYPE}${UNQID}" id="searchResultGenericTable${MODULETYPE}${UNQID}">
		<thead>
			<tr>
				<th class="info no-sort">
					<input type="checkbox" class="checkbox-check-all" compassTable="${MODULETYPE}${UNQID}"
					id="${MODULETYPE}${UNQID}" />
				</th>
				<c:forEach var="TH" items="${HEADER}">
					<c:set var="colArray" value="${f:split(TH, '.')}" />
					<c:set var="colArrayCnt" value="${f:length(colArray)}" />
					<th class="info" id="${colArray[colArrayCnt-1]}"><spring:message code="${TH}"/></th>
				</c:forEach>
			</tr>
		</thead>
		<tbody>
			<c:forEach var="RECORD" items="${DATA}">
				<tr>
					<td>
						<input type="checkbox" class="checkbox-check-many" value="${RECORD[1]}" compassId="${RECORD[1]}" /> 
					</td>
					<c:forEach var="TD" items="${RECORD}">
						<c:choose>
							<c:when test="${TD ne ' ' and TD ne ''}">
								<td data-toggle="tooltip" data-placement="auto"  title="${TD}" data-container="body">${TD}</td>
							</c:when>
							<c:otherwise>
								<td>${TD}</td>
							</c:otherwise>
						</c:choose>
					</c:forEach>
				</tr>
			</c:forEach>
		</tbody>
	</table>
</div>
<div class="card-footer action-footer clearfix">
	<div class="pull-${dirR} clearfix">
		<button type="button" class="btn btn-warning btn-sm" id="viewEvidence${UNQID}">View File</button>
	</div>
</div>