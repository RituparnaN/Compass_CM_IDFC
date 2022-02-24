<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../tags/tags.jsp"%>
<script type="text/javascript">
	$(document).ready(function(){
		var id = '${UNQID}';
		$.ajax({
			url: "${pageContext.request.contextPath}/admin/getRiskCategorizationBottomFrame",
			cache: false,
			type: "POST",
			data: "id="+id,
			success: function(res){
				$("#riskCategorizationBottomFrame").html(res);
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
					<a class="subTab nav-link active" href="#RP" aria-controls="tab" role="tab" data-toggle="tab">Risk Parameters</a>
				</li>
				<li role="presentation" >
					<a class="subTab nav-link" href="#RA" aria-controls="tab" role="tab" data-toggle="tab">Risk Assignment</a>
				</li>
				<li role="presentation" >
					<a class="subTab nav-link" href="#RC" aria-controls="tab" role="tab" data-toggle="tab">Risk Calculation</a>
				</li>
			</ul>
			<div class="tab-content" id="riskCategorizationBottomFrame">
			</div>
		</div>
	</div>
</div>
