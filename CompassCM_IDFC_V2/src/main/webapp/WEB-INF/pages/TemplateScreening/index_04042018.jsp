<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../tags/tags.jsp"%>
<script>
$(document).ready(function() {
	var id = '${UNQID}';
	var searchButtonId = "searchTemplate${UNQID}";
	compassTopFrame.init(id, 'compassModuleDetailsSearchTable'+id, 'dd/mm/yy');
	
	
	
	$('.panelSlidingScreeningTemplate'+id).on("click", function (e) {
		var mainRow = $(this).parents(".compassrow"+id);
		compassTopFrame.searchPanelSliding(id, mainRow, 'templateScreeningCreateResultPanel');
	});
	
	//for reset form
	$('#formReset'+id).click(function(){
		
		$("#screeningTemplateForm"+id)[0].reset();
	});
	//for open a window for manage template 
	
	
	//for checking uniques template id ...
	
	function chkDuplicateTemplateId(templateId,callback) {
		var duplicateTemplateId = false;
		$.ajax({
			url: "${pageContext.request.contextPath}/common/checkTemplateId",
			cache: false,
			type: "GET",
			data: {templateId:templateId},
			success: function(res) {
				if(res['duplicate'] == true)
				{
					alert(res['message']);
					duplicateTemplateId =  true;
				}
			},
			complete: function(){
				if(duplicateTemplateId == false){
					callback();
				}
			},
			error: function(a,b,c) {
				console.log();
				return true;
			}
		});
		
	    	
	  }
	
	
	//ajax call for creation of templates.. 
	$("#createTemplate"+id).click(function(){
		
		var templateId = $("#templateId"+id).val();
		var templateType = $('input[name = "templateType"]:checked').val();
		var templateName = $("#templateName"+id).val();
		
		if($('input:radio[name = "templateType"]').is(':checked') === false) {
			templateType = "r";
	    }
		var url = "${pageContext.request.contextPath}/common/createTemplateScreening";
		if(templateType == "a")
		{
			alert("Please select proper template type");
			return false;
		}
		if(templateId == "")
		{
			alert("Enter template id");
			$("#templateId"+id).focus();
			return false;
		}else if(templateId != ""){
			chkDuplicateTemplateId(templateId, function() {
				if(templateName == "")
				{
					alert("Please enter Template Name");
					$("#templateName"+id).focus();
					return false;
				}
					var mainRow = $(this).parents("div.compassrow"+id);
					var slidingDiv = $(mainRow).children().children().children();
					var panelBody = $(mainRow).children().children().find(".panelSearchForm");
					
					$.ajax({
						url: url,
						cache: false,
						type: "POST",
						data: {templateId:templateId,templateType:templateType,templateName:templateName,searchButtonId:searchButtonId},
						success: function(res) {
							/* console.log(res);
							alert(res); */
							alert('Template added successfully')
							$("#templateScreeningCreateResultPanel"+id).css("display", "block");
							$("#templateScreeningCreateResult"+id).html(res);
							$(panelBody).slideUp();
							$(slidingDiv).addClass('card-collapsed');
							$(slidingDiv).find('i.collapsable').removeClass('fa-chevron-up').addClass('fa-chevron-down');
							$(mainRow).next().find(".compassrow"+id).find(".card-header").next().slideDown();
						},
						error: function(a,b,c) {
							console.log();
							alert(a+b+c);
						}
					});
			});
		}
			
		
	})
	
	// ajax call for searching template 
	$("#searchTemplate"+id).click(function(){
		var url = "${pageContext.request.contextPath}/common/searchTemplateScreening";
		var templateId = $("#templateId"+id).val();
		var templateType = $('input[type="radio"]:checked').val();
		var templateName = $("#templateName"+id).val();
		
		
			var mainRow = $(this).parents("div.compassrow"+id);
			var slidingDiv = $(mainRow).children().children().children();
			var panelBody = $(mainRow).children().children().find(".panelSearchForm");
			
			$.ajax({
				url: url,
				cache: false,
				type: "POST",
				data: {templateId:templateId,templateType:templateType,templateName:templateName,searchButtonId:searchButtonId},
				success: function(res) {
					/*  console.log(res);
					alert(res); */ 
					$("#templateScreeningCreateResultPanel"+id).css("display", "block");
					$("#templateScreeningCreateResult"+id).html(res);
					$(panelBody).slideUp();
					$(slidingDiv).addClass('card-collapsed');
					$(slidingDiv).find('i.collapsable').removeClass('fa-chevron-up').addClass('fa-chevron-down');
					$(mainRow).next().find(".compassrow"+id).find(".card-header").next().slideDown();
				},
				error: function(a,b,c) {
					console.log();
					alert(a+b+c);
				}
			});
	});

});
</script>
<div class="row compassrow${UNQID}">
<div class="col-sm-12">

	
		<div class="card card-primary">
			<div class="card-header panelSlidingScreeningTemplate${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}"><spring:message code="app.common.createTemplateScreeningHeader"/></h6>
				<div class="btn-group pull-${dirR} clearfix">
					<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
				</div>
			</div>
		
			<div class="panelSearchForm">
			<form action="javascript:void(0)" method="POST" id="screeningTemplateForm${UNQID}" >
				<table class="table table-striped compassModuleDetailsSearchTable" style="margin-bottom: 0px;">
					<tbody>
						<tr>
							<td width="18%">Template id</td>
							<td width="30%">
								<input type="text" class="form-control input-sm" name="templateId" id="templateId${UNQID}" autocomplete="off" />
							</td>
							<td width="4%">&nbsp;</td>
							<td>Template Name</td>
							<td>
								<input type="text" class="form-control input-sm" id="templateName${UNQID}" name="templateName" placeholder="Enter Template Name" />
							</td>
						</tr>
						
						<tr>
							<td>Template Type:</td>
							<td>
								<label class="btn btn-default btn-sm"><input type="radio" name="templateType"  value="i" >Individual</label>
								<label class="btn btn-default btn-sm"><input type="radio" name="templateType"  value="c" >Company </label>
								<label class="btn btn-default btn-sm"><input type="radio" name="templateType"  value="r" >Remittance</label>
								<label class="btn btn-default btn-sm"><input type="radio" name="templateType"  value="a" >All</label>
							</td>
							<td width="4%">&nbsp;</td>
							<td width="18%"></td>
							<td width="30%">
								
							</td>
						</tr>
						
					</tbody>
				</table>
			
				<div class="card-footer clearfix">
						<div class="pull-${dirR} createUserPanelButtons">
							<button type="button" class="btn btn-success templateOperation${UNQID}" name="createTemplate" value = "createTemplate" id="createTemplate${UNQID}" >Create Template</button>
							<button type="button" class="btn btn-primary templateOperation${UNQID}" name="searchTemplate" value = "searchTemplate" id="searchTemplate${UNQID}" >Search Template</button>
			      			<button type="button" class="btn btn-warning"  id="formReset${UNQID}">Clear</button> 
						</div>
				</div>
			</form>
			</div>
		</div>
	
	<div class="card card-primary" id="templateScreeningCreateResultPanel${UNQID}" style="display: none;">
			<div class="card-header panelSlidingScreeningTemplate${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}"><spring:message code="app.common.createTemplateScreeningResult"/></h6>
				<div class="btn-group pull-${dirR} clearfix">
					<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
				</div>
			</div>
			<div id="templateScreeningCreateResult${UNQID}"></div>
	</div>

</div>
</div>

