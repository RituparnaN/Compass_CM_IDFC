<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ include file="../tags/tags.jsp"%>
    
<script type="text/javascript">
	$(document).ready(function(){
		var templateId = '${TEMPLATEID}';
		var templateName = '${TEMPLATENAME}';
		
		var id = '${UNQID}'
		$("#AddCountryButton").click(function(){
			var nameValue = $("#nameValue"+id).val();
			var countryValue = $("#countryValue"+id).val();

			if(nameValue == '' && countryValue == '')
			{
				alert("Please enter atleast one among Name and Country");
				$("nameValue"+id).click();
				return false;
			}
			else {
			// if(confirm("Are you sure?")){
					$.ajax({
						url: "${pageContext.request.contextPath}/common/insertDetailForTemplateScreening?templateId="+templateId+"&templateName="+templateName+"&nameValue="+nameValue+"&countryValue="+countryValue,                                   
						cache: false,
						type: "POST",
						success: function(res){
							alert(res);
							$("#compassGenericModal").modal("hide");
							var doc = $("#compassGenericModal-title")[0].ownerDocument;
							var win = doc.defaultView || doc.parentWindow;
							win.location.reload();
						},
						error: function(Data){
							
							alert(Data);
						}
					});
			// }
			}
			/*
			else{
				alert("Please Enter Value ");
			}
			*/
		});
	});
</script>
<div class="row">
	<div class="col-sm-12">
		<div class="card card-primary">
			<div class="card-header clearfix">
				<h6 class="card-title pull-${dirL}">Enter Field Details</h6>
			</div>
			<div class="panelTemplateScreeningForm">
				<form action="javascript:void(0)" method="POST" id="addCountryToTemplateScreenig">
					<table class="table table-striped" style="margin-bottom: 0px;">
					<!-- 
						<tr>
							<td width="15%">
								Field Type  
							</td>
							<td width="30%">
								<select class="form-control input-sm" id="fieldType${UNQID}">
									<option></option>
									<option value="NAME" selected>Name</option>
									<option value="COUNTRY">Country</option>
								</select>
							</td>
							<td width="10%">&nbsp;</td>
							<td width="15%">
								Field Value
							</td>
							<td width="30%">
								<input type="text" class="form-control input-sm" name="country" id="fieldValue${UNQID}"/>
							</td>
						</tr>
					 -->
						<tr>
							<td width="15%">
								Enter Name  
							</td>
							<td width="30%">
								<input type="text" class="form-control input-sm" name="nameValue" id="nameValue${UNQID}"/>
							</td>
							<td width="15%">
								Enter Country  
							</td>
							<td width="30%">
								<input type="text" class="form-control input-sm" name="countryValue" id="countryValue${UNQID}"/>
							</td>
						</tr>
					</table>
				</form>
			</div>
			<div class="card-footer clearfix">
				<div class="card-title pull-right">
					<button type="button" class="btn btn-primary btn-sm" id="AddCountryButton">Add</button>
				</div>
			</div>
		</div>
	</div>
</div>