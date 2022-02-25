<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../../tags/tags.jsp"%>
<script type="text/javascript">
	$(document).ready(function(){
		var id = '${UNQID}';

		$.ajax({
			url: "${pageContext.request.contextPath}/common/getRequiredFields",
			cache: false,
			type: "POST",
			data: "id="+id,
			success: function(res){
				$("#missingFieldsTemplate"+id).html(res);
			},
			error: function(a,b,c){
				alert(a+b+c);
			}
		});
	});
</script>
<div class="row">
	<div class="col-sm-12">
		<div class="card card-default">
			<ul class="nav nav-pills modalNav" role="tablist">
				<li role="presentation" class= "active">
					<a class="subTab nav-link active" href="#Tab1" aria-controls="tab" role="tab" data-toggle="tab"><spring:message code="app.common.missingFieldsTemplateSearchHeader"/></a>
				</li>
				<li role="presentation" >
					<a class="subTab nav-link" href="#Tab2" aria-controls="tab" role="tab" data-toggle="tab"><spring:message code="app.common.addUpdateFieldsTemplateSearchHeader"/></a>
				</li>
			</ul>
			<div class="tab-content" id="missingFieldsTemplate${UNQID}"></div>
		</div>
	</div>
</div>
