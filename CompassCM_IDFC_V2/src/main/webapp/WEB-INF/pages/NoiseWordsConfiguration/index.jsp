<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../tags/tags.jsp"%>
<script type="text/javascript">
	$(document).ready(function(){
	var id = '${UNQID}';
	compassTopFrame.init(id, 'compassNoiseWordsSearchTable'+id, 'dd/mm/yy');
	
	$('.panelSlidingNoiseWords'+id).on("click", function (e) {
		var mainRow = $(this).parents(".compassrow"+id);
		compassTopFrame.searchPanelSliding(id, mainRow, 'noiseWordsSerachResultPanel'+id);
    });
	
	$("#searchMasterForm"+id).submit(function(e){
		var submitButton = $("#searchNoiseWords"+id);
		compassTopFrame.submitForm(id, e, submitButton, 'noiseWordsSerachResultPanel', 
				'noiseWordsSerachResult', '${pageContext.request.contextPath}/common/searchGenericMaster',
				'${pageContext.request.contextPath}/includes/images/qde-loadder.gif');
	});
	
	$("#saveNoiseWord"+id).click(function(){
		var noiseWord = $("#noiseWordField"+id).val();
		var isEnabled = $(document).find("#isEnabledField"+id).val();
		//alert("noiseWord = "+noiseWord+", isEnabled = "+isEnabled);
		
		if(noiseWord != ""){
			$.ajax({
				url : "${pageContext.request.contextPath}/common/saveNoiseWord",
				cache : false,
				data : "noiseWord="+noiseWord+"&isEnabled="+isEnabled,
				type : 'POST',
				success : function(resData){
					alert(resData);
					$("#fromDateField"+id).val("");
					$("#toDateField"+id).val("");
					$("#searchNoiseWords"+id).click();
				},
				error : function(a,b,c){
					alert("Something went wrong");
				}
			});
		}else{
			alert("Please enter any noise word to save");
		}
	});
	
	$("#clearNoiseWords"+id).click(function(){
		reloadTabContent();
	});
	
	$("#updateNoiseWord"+id).click(function(){
		var isEnabled = "";
		var noiseWord = "";
		var noiseWordsList = "";
		var selectedCount = 0;
		
		$("#noiseWordsSerachResult"+id).find("table").children("tbody").children("tr").each(function(){
			var row = $(this).children("td").eq(0).children("input[type='checkbox']");
			if($(row).prop("checked")){
				isEnabled = $(this).children("td:nth-child(2)").find("select").val();
				noiseWord = $(this).children("td:nth-child(3)").text().trim();
				noiseWordsList += noiseWord+"="+isEnabled+"---";
				selectedCount++;
			}
		});
		//alert("noiseWordsList = "+noiseWordsList);
		
		if(selectedCount >= 1){
			if(confirm("Do you want to update the status?")){
				$.ajax({
					url : "${pageContext.request.contextPath}/common/updateNoiseWord",
					cache : false,
					data : "noiseWordsList="+noiseWordsList,
					type : 'POST',
					success : function(resData){
						alert(resData);
						$("#searchNoiseWords"+id).click();
					},
					error : function(a,b,c){
						alert("Something went wrong");
					}
				});
			}
		}else{
			alert("Please select a record to update.");
		}
		
	});
	
	
});
</script>
<div class="row compassrow${UNQID}">
	<div class="col-sm-12">
		<div class="card card-primary panel_noiseWords">
			<div class="card-header panelSlidingNoiseWords${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}">Noise Words</h6>
				<div class="btn-group pull-${dirR} clearfix">
					<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
				</div>
			</div>
			<div class="panelSearchForm">
			<form action="javascript:void(0)" method="POST" id="searchMasterForm${UNQID}">
				<input type="hidden" name="moduleType" value="${MODULETYPE}">
				<input type="hidden" name="bottomPageUrl" value="NoiseWordsConfiguration/SearchBottomPage">
				<table class="table compassNoiseWordsSearchTable${UNQID}" style="margin-bottom: 0px;">
					<tr>
						<td width="15%">From Date</td>
						<td width="30%">
							<input type="text" class="form-control input-sm datepicker" name="1_FROMDATE" id="fromDateField${UNQID}"></input>
						</td>
						<td width="10%">&nbsp;</td>
						<td width="15%">To Date</td>
						<td width="30%">
							<input type="text" class="form-control input-sm datepicker" name="2_TODATE" id="toDateField${UNQID}"></input>
						</td>
					</tr>
					<tr>
						<td width="15%">Noise Word</td>
						<td width="30%">
							<input type="text" class="form-control input-sm" name="3_NOISEWORD" id="noiseWordField${UNQID}"></input>
						</td>
						<td width="10%">&nbsp;</td>
						<td width="15%">Is Enabled</td>
						<td width="30%">
							<select class="form-control input-sm" name="4_ISENABLED" id="isEnabledField${UNQID}" style="width: 100%;">
								<option value="ALL">ALL</option>
								<option value="Y">Yes</option>
								<option value="N">No</option>
							</select>
						</td>
					</tr>
				</table>
				<div class="card-footer clearfix">
					<div class="pull-${dirR}">
						<button type="button" id="saveNoiseWord${UNQID}" class="btn btn-success btn-sm">Add</button>
						<button type="submit" id="searchNoiseWords${UNQID}" class="btn btn-primary btn-sm" name="Search" value="Search">Search</button>
						<input type="button" id="clearNoiseWords${UNQID}" class="btn btn-danger btn-sm" name="Clear" value="Clear">
					</div>
				</div>
			</form>
			</div>
		</div>
		
		<div class="card card-primary" id="noiseWordsSerachResultPanel${UNQID}" style="display: none;">
			<div class="card-header panelSlidingNoiseWords${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}">Noise Words List</h6>
				<div class="btn-group pull-${dirR} clearfix">
					<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
				</div>
			</div>
			<div id="noiseWordsSerachResult${UNQID}"></div>
			<div class="card-footer clearfix">
				<div class="pull-${dirR}">
					<button type="button" id="updateNoiseWord${UNQID}" class="btn btn-success btn-sm">Update</button>
				</div>
			</div>
		</div>
	</div>
</div>