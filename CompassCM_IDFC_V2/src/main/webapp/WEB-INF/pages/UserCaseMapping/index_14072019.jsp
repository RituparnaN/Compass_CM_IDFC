<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../tags/tags.jsp"%>
<script type="text/javascript">
	$(document).ready(function(){
		var id = '${UNQID}';
		
		var tableClass = 'userCaseMappingTable';
		compassDatatable.construct(tableClass, "User Case Mapping", true);
		compassDatatable.enableCheckBoxSelection();
		
		$("#saveUserCaseAssignment"+id).click(function(){
			var fullData = "";
			var tr = $("."+tableClass).children("tbody").children("tr");
			$(tr).each(function(){
				if ($(this).children("td:first-child").children("input").prop("checked")){
					var userCode = $(this).children("td:nth-child(2)").html();					
					var count = $(this).children("td:nth-child(3)").children("select").val();
					fullData = fullData + userCode+","+count+";" ;
				}
			});
			//alert("total="+total);
			//alert("fullData="+fullData);
			var intSelectedCount = ((fullData.split(";").length)-1);
			if(intSelectedCount == 0 ) {
			   alert('Please select atleast one record to assign');
			   return false;
			}else{
		       $.ajax({
					url: "${pageContext.request.contextPath}/admin/saveUserCaseAssignment",
					cache: false,
					type: "POST",
					data: "fullData="+fullData,
					success: function(res) {
						alert(res);
						reloadTabContent();
					},
					error: function(a,b,c) {
						alert(a+b+c);
					} 
				}); 
			}
		});
	});
	
</script>
<style>
	.selectPercentage{
		display: inline-block;
	}
</style>
<div class="row compassrow${UNQID}">
	<div class="col-sm-12">
		<div class="card card-primary panel_userCaseMapping">
			<div class="card-header panelSlidingUserCaseMapping${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}"><spring:message code="app.common.userCaseMappingSearchHeader"/></h6>
				<div class="btn-group pull-${dirR} clearfix">
					<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
				</div>
			</div>
			<div class="panelSearchForm">
				<table class="table table-bordered table-striped userCaseMappingTable" style="margin-bottom: 0px;">
					<thead>
						<tr>
							<th class="info no-sort" style="text-align: center;">
								<input type="checkbox" class="checkbox-check-all" compassTable="userCaseMappingTable" id="userCaseMappingTable"></th>
							<th class="info">User Code</th>
							<th class="info">Count</th>
						</tr>
					</thead>
					<tbody>
							<c:forEach var="dataList" items="${DATALIST}">
							<tr>
								<td class="no-sort" style="text-align: center;">
									<input type="checkbox" id="isEnabled${UNQID}" <c:if test="${dataList['ISENABLED'] eq 'Y'}" >checked="checked"</c:if>/>	
								</td>
								<td>${dataList['USERCODE']}</td>
								<td>
									<select class="form-control input-sm" id="count${UNQID}">
										<c:forEach var="i" begin="0" end="20">
											<option value="${i}" <c:if test="${dataList['PERCENTAGE'] eq i}">selected="selected"</c:if>>${i}</option>
										</c:forEach>
									</select>
									<%-- <input type="text" class="form-control input-sm" id="count${UNQID}" 
										   onkeyup="$(this).val($(this).val().replace(/[^\d]/ig, ''))"
										   value="${dataList['PERCENTAGE']}"> --%>
								</td>
							</tr>
							</c:forEach>
					</tbody>
				</table>
				<div class="card-footer clearfix">
					<div class="pull-${dirR}">
					<input type="button" class="btn btn-primary btn-sm" id="saveUserCaseAssignment${UNQID}" name="SaveAssignment" value="Save Assignment"/>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>