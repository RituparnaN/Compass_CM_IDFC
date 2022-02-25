<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../../../tags/tags.jsp"%>
<c:set var="MODULETYPE" value="${moduleType}"/>
<c:set var="MODULENAME" value="${moduleName}"/>
<c:set var="UNQID" value="${UNQID}"/>
<c:set var="HEADER" value="${SEARCHRESULT['HEADER']}"/>
<c:set var="DATA" value="${SEARCHRESULT['DATA']}"/>
<c:set var="RECORDCOUNT" value="${f:length(DATA)}"/>

<script type="text/javascript">
	$(document).ready(function(){
		var tableClass = '${MODULETYPE}${UNQID}';
		compassDatatable.construct(tableClass, "${MODULENAME}", true);
		compassDatatable.enableCheckBoxSelection();
	
	});
	
	/* function downloadGeneratedXMLFile(fileName, filePath){
		window.open("${pageContext.request.contextPath}/common/downloadRegulatoryFiles?fileName="+fileName+"&filePath="+filePath);
	} */
	
	function downloadGeneratedXMLFile(fileSeqNo, fileName, filePath){
		compassFileUpload.init("viewGeneratedCBWTRFiles","${pageContext.request.contextPath}","generatedCBWTRFiles","","N","N", fileSeqNo);
	}
	
</script>

<div>
<div id="searchResultGenericDiv">
	<table class="table table-bordered table-striped searchResultGenericTable ${MODULETYPE}${UNQID}" id="searchResultGenericTable ${MODULETYPE}${UNQID}">
		<thead>
			<tr>
				<th class="info no-sort">
					<input type="checkbox"  compassTable="${MODULETYPE}${UNQID}"
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
						<input type="checkbox" class="checkbox-check-one" value="${RECORD[0]}" compassId="${RECORD[0]}" /> 
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
	<div class="card-footer clearfix">
		<div class="pull-${dirR}">
			<button type="button" class="btn btn-primary btn-sm" id="editCbwtr${UNQID}">Edit Details</button>
		</div>
	</div>
</div>
<script>
	var id = "${UNQID}";
	var moduleType = "${MODULETYPE}";
	var viewCbwtrButton = "${viewCbwtrButton}";
	//alert(viewCbwtrButton);
	$("#editCbwtr"+id).click(function(){
		var selectedFileSeq;
		$(".searchResultGenericTable:visible").children("tbody").children("tr").each(function(){
			var selectedCases = "";
			var row = $(this).children("td").children("input[type='checkbox']");
			if($(row).prop("checked")){
				selectedFileSeq = $(row).val();
			}
		});
		
		if(selectedFileSeq !== undefined){
			//alert(selectedFileSeq);
			// update code
			$.ajax({
				url: "${pageContext.request.contextPath}/common/editCBWTRDetails",
				cache:	false,
				type: "POST",
				data: {selectedFileSeq:selectedFileSeq, viewCbwtrButton:viewCbwtrButton},
				success: function(response){
					$("#compassGenericModal").modal("show");
					$("#compassGenericModal-title").html("Edit Reference and Remarks:");
					$("#compassGenericModal-body").html(response);
				},
				error: function(a,b,c){
					alert(a+b+c);
				}
			});
		}else{
			alert("select at least one file");
		}
		
	});
</script>