<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../../tags/tags.jsp"%>
<script type="text/javascript">
	$(document).ready(function() {
		
		var id = '${UNQID}';
		$(".compassrow"+id).find("select").select2({
			dropdownAutoWidth : true
		});
		var searchFieldId = '${searchFieldId}';
		var serachFor = '${serachFor}';
		var viewName = '${viewName}';
		var isMultipleSelect = '${isMultipleSelect}';
		
		var enteredValue = $("#"+searchFieldId).val();
		if(enteredValue != "" && enteredValue.trim().length > 0 && enteredValue.indexOf(",") < 0){
			$("#moduleSearchValue"+id).val(enteredValue);
			searchModuleValue();
		}
		
		$("#searchModuleValue"+id).click(function(){
			searchModuleValue();
		});
		
		$("#selectValuesFromSearch").click(function(){
			var selectedValArr = [];
			var selectedVal;
			var colIndex = $("#moduleResultPanel").find("table").children("thead").children("tr").find("TH#"+serachFor).index()+1;
			var tr = $("#moduleResultPanel").find("table").children("tbody").children("tr");
			$(tr).each(function(i,k){
				if($(this).children("td:first-child").children("input").prop("checked")){
					selectedValArr.push($(this).children("td:nth-child("+colIndex+")").html());
					selectedVal = $(this).children("td:nth-child("+colIndex+")").html();
				}
			});
			
			if(selectedValArr.length != 0){
				if(isMultipleSelect == "Y"){
					if(enteredValue != "" && enteredValue.trim().length > 0){
						if(confirm("Do you want to append selected record data to the existing?")){
							var str = enteredValue+",";
							for(var i = 0; i < selectedValArr.length; i++){
								if((i+1) == selectedValArr.length)
									str = str + selectedValArr[i];
								else
									str = str + selectedValArr[i]+",";
							}
							$("#"+searchFieldId).val(str);
						}else{
							var str = "";
							for(var i = 0; i < selectedValArr.length; i++){
								if((i+1) == selectedValArr.length)
									str = str + selectedValArr[i];
								else
									str = str + selectedValArr[i]+",";
							}
							$("#"+searchFieldId).val(str);
						}
					}else{
						var str = "";
						for(var i = 0; i < selectedValArr.length; i++){
							if((i+1) == selectedValArr.length)
								str = str + selectedValArr[i];
							else
								str = str + selectedValArr[i]+",";
						}
						$("#"+searchFieldId).val(str);
					}
				}else{
					$("#"+searchFieldId).val(selectedVal);
				}
				$("#compassSearchModuleModal").modal("hide");
			}else{
				alert("Select record");
			}
		});
	});
	
	function searchModuleValue(){
		var id = '${UNQID}';
		var searchFieldId = '${searchFieldId}';
		var serachFor = '${serachFor}';
		var viewName = '${viewName}';
		var isMultipleSelect = '${isMultipleSelect}';
		var moduleSearchBy = $("#moduleSearchBy"+id).val();
		var moduleSearchType = $("#moduleSearchType"+id).val();
		var moduleSearchValue = $("#moduleSearchValue"+id).val();
		
		$.ajax({
			url : "${pageContext.request.contextPath}/common/searchGenericModuleFields",
			cache : false,
			data : "searchFieldId="+searchFieldId+"&serachFor="+serachFor+"&viewName="+viewName+"&isMultipleSelect="+isMultipleSelect+"&moduleSearchBy="+moduleSearchBy+"&moduleSearchType="+moduleSearchType+"&moduleSearchValue="+moduleSearchValue,
			type : "POST",
			success : function(resData){
				$("#selectValuesFromSearchDiv").css("display","block");
				$("#moduleResultPanel").html(resData);
			},
			error : function(a,b,c){
				alert("Something went wrong");
			}
		});
	}
</script>
<style type="text/css">
	select{
		width: 100%;
	}
</style>
<div class="row compassrow${UNQID}">
	<div class="col-sm-12">
		<div class="card card-primary panel_moduleSearch">
			<div class="moduleSearchPanel">
				<table class="table table-striped">
					<tr>
						<td width="15%">Search By</td>
						<td width="30%">
							<select class="form-control input-sm" id="moduleSearchBy${UNQID}" style="width: 100%">
								<c:forEach var="colName" items="${VIEWCOLS}">
									<option value="${colName}">${colName}</option>
								</c:forEach>
							</select>
						</td>
						<td width="10%">&nbsp;</td>
						<td width="15%">Search Type</td>
						<td width="30%">
							<select class="form-control input-sm" id="moduleSearchType${UNQID}" style="width: 100%">
								<option value="StartsWith">Starts With</option>
								<option value="InString">In String</option>
								<option value="WholeWord">Whole Word</option>
							</select>
						</td>
					</tr>
					<tr>
						<td>Search Value</td>
						<td>
							<input type="text" class="form-control input-sm" id="moduleSearchValue${UNQID}">
						</td>
						<td colspan="2">&nbsp;</td>
						<td>
							<button type="button" class="btn btn-success btn-sm" id="searchModuleValue${UNQID}">Search</button>
						</td>
					</tr>
				</table>
			</div>
			<div id="moduleResultPanel" style="max-height: 315px; overflow-y: auto;">
			</div>
			<div class="card-footer clearfix" id="selectValuesFromSearchDiv" style="display: none;">
				<div class="pull-right">
					<button class="btn btn-primary btn-sm" id="selectValuesFromSearch">Select</button>
				</div>
			</div>
		</div>
	</div>
</div>