<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../tags/tags.jsp"%>
<script type="text/javascript">
	$(document).ready(function(){
		var id = '${UNQID}';
		compassTopFrame.init(id, 'compassUserHierarchySearchTable'+id, 'dd/mm/yy');
		
		$('.panelSlidingUserHierarchy'+id).on("click", function (e) {
			var mainRow = $(this).parents(".compassrow"+id);
			compassTopFrame.searchPanelSliding(id, mainRow, 'userHierarchySerachResultPanel'+id);
	    });
 
		$("#mappingType"+id).on("change", function(){
			if($(this).val() == "AMLUserAMLO"){
				$(".amluserListFields").css("display", "table-row");
				$(".amloListFields").css("display", "block");
				$(".mlroListFields").css("display", "none");
			}
			else if($(this).val() == "AMLOMLRO"){
				$(".amluserListFields").css("display", "none");
				$(".amloListFields").css("display", "block");
				$(".mlroListFields").css("display", "table-row");
			}
		});
		
		$("#searchUserHierarchyMapping"+id).click(function(){
			var mainRow = $(this).parents(".compassrow"+id);
			var slidingDiv = $(mainRow).children().children().children();
			var panelBody = $(mainRow).children().children().find(".panelSearchForm");
			var mappingType = $("#mappingType"+id).val();
			var mappingAMLUsersCode = $("#amlUserList"+id).val();
			var	mappingAMLOUsersCode = $("#amloList"+id).val();
			var	mappingMLROUsersCode = $("#mlroList"+id).val();
				
			var fullData = "mappingType="+mappingType+"&mappingAMLUsersCode="+mappingAMLUsersCode+"&mappingAMLOUsersCode="+mappingAMLOUsersCode+"&mappingMLROUsersCode="+mappingMLROUsersCode;
			//alert(fullData);
			if(mappingType != 'ALL'){
			$.ajax({
				url: "${pageContext.request.contextPath}/admin/searchUserHierarchyMapping",
				cache: false,
				type: "POST",
				data: fullData,
				success: function(res) {
					$("#userHierarchySerachResultPanel"+id).css("display", "block");
					$("#userHierarchySerachResult"+id).html(res);
					$(panelBody).slideUp();
					$(slidingDiv).addClass('card-collapsed');
					$(slidingDiv).find('i.collapsable').removeClass('fa-chevron-up').addClass('fa-chevron-down');
					$(mainRow).next().find(".compassrow"+id).find(".card-header").next().slideDown();
				},
				error: function(a,b,c) {
					alert(a+b+c);
				}
			});
			}else{
				alert("Mapping type selection is mandatory.");
			}
		});
		
		$("#saveMapping"+id).click(function(){
			var searchButton = "searchUserHierarchy${UNQID}"; 
			var mappingType = $("#mappingType"+id).val();
			var fullData = "";
			var tr = $("#userHierarchySerachResult"+id).find("table").children("tbody").children("tr");
			$(tr).each(function(){
				var isChecked = ($(this).children("td:first-child").children("input").prop("checked") === true)? "Y" : "N";
				fullData = fullData + isChecked+",";
				if(mappingType == 'AMLUserAMLO'){
						var amluserCode = $(this).children("td:nth-child(2)").html();
						var amloCode = $(this).children("td:nth-child(3)").children("select").val();
						fullData = fullData + amluserCode+","+amloCode+";" ;
					}else{
						var amloCode = $(this).children("td:nth-child(2)").html();
						var mlroCode = $(this).children("td:nth-child(3)").children("select").val();
						fullData = fullData + amloCode+","+mlroCode+";" ;
					}
			});
			
			//alert("fullData="+fullData);
			$.ajax({
				url: "${pageContext.request.contextPath}/admin/saveMapping",
				cache: false,
				type: "POST",
				data: "fullData="+fullData+"&mappingType="+mappingType,
				success: function(res) {
					alert(res);
					$("#"+searchButton).click();
				},
				error: function(a,b,c) {
					alert(a+b+c);
				} 
			});
		});
});
</script>
<div class="row compassrow${UNQID}">
	<div class="col-sm-12">
		<div class="card card-primary panel_userHierarchy">
			<div class="card-header panelSlidingUserHierarchy${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}">User Hierarchy Mapping</h6>
				<div class="btn-group pull-${dirR} clearfix">
					<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
				</div>
			</div>
			<div class="panelSearchForm">
			<form action="javascript:void(0)" method="POST" id="searchMasterForm${UNQID}">
				<table class="table compassUserHierarchySearchTable${UNQID}" style="margin-bottom: 0px;">
					<tr>
						<td width="15%">Mapping Type</td>
						<td width="30%">
							<select class="form-control input-sm" id="mappingType${UNQID}" name="mappingType" style="width: 100%;">
								<option value="ALL">ALL</option>
								<option value="AMLUserAMLO">AMLUser-AMLO Mapping</option>
								<option value="AMLOMLRO">AMLO-MLRO Mapping</option>
							</select>
						</td>
						<td width="10%">&nbsp;</td>
						<td width="15%">
							 <div class="amloListFields" style="display: none;">AMLO List</div>
						</td>
						<td width="30%">
							<div class="amloListFields" style="display: none;">
								<select class="form-control input-sm" id="amloList${UNQID}" name="amloList" style="width: 100%;">
									<option value="ALL">ALL</option>
									<c:forEach var="LISTVALUE" items="${AMLOLIST}">
										<option value="${LISTVALUE.key}">${LISTVALUE.value}</option>
									</c:forEach>
								</select>
							</div>
						</td>
					</tr>
					<tr class="amluserListFields" style="display: none;">
						<td width="15%">AMLUser List</td>
						<td width="30%">
							<select class="form-control input-sm" id="amlUserList${UNQID}" name="amlUserList" style="width: 100%;">
								<option value="ALL">ALL</option>
								<c:forEach var="LISTVALUE" items="${AMLUSERLIST}">
									<option value="${LISTVALUE.key}">${LISTVALUE.value}</option>
								</c:forEach>							
							</select>
						</td>
						<td colspan="3">&nbsp;</td>
					</tr>
					<tr class="mlroListFields" style="display: none;">
						<td width="15%">MLRO List</td>
						<td width="30%">
							<select class="form-control input-sm" id="mlroList${UNQID}" name="mlroList" style="width: 100%;">
								<option value="ALL">ALL</option>
								<c:forEach var="LISTVALUE" items="${MLROLIST}">
									<option value="${LISTVALUE.key}">${LISTVALUE.value}</option>
								</c:forEach>
							</select>
						</td>
						<td colspan="3">&nbsp;</td>
					</tr>
				</table>
				<div class="card-footer clearfix">
					<div class="pull-${dirR}">
						<button type="button" id="searchUserHierarchyMapping${UNQID}" class="btn btn-primary btn-sm" name="Search" value="Search">Search</button>
						<input type="reset" id="clearUserHierarchyMapping${UNQID}" class="btn btn-danger btn-sm" name="Clear" value="Clear">
					</div>
				</div>
			</form>
			</div>
		</div>
		<div class="card card-primary" id="userHierarchySerachResultPanel${UNQID}" style="display: none;">
			<div class="card-header panelSlidingUserHierarchy${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}">User Hierarchy Mapping List</h6>
				<div class="btn-group pull-${dirR} clearfix">
					<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
				</div>
			</div>
			<div id="userHierarchySerachResult${UNQID}"></div>
			 <div class="card-footer clearfix">
				<div class="pull-${dirR}">
					<input type="button" class="btn btn-success btn-sm" id="saveMapping${UNQID}" name="saveMapping" value="Save Mapping"/>
				</div>
			</div>
		</div>
	</div>
</div>