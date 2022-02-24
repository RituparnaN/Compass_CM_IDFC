<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../tags/tags.jsp"%>
<script type="text/javascript">
	$(document).ready(function(){
		var id = '${UNQID}';
		$.ajax({
			url: "${pageContext.request.contextPath}/admin/getCustomerRiskCategorizationBottomFrame",
			cache: false,
			type: "POST",
			data: "id="+id,
			success: function(res){
				$("#customerRiskCategorizationBottomFrame").html(res);
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
					<a class="subTab nav-link active" href="#CRC_RP" aria-controls="tab" role="tab" data-toggle="tab">Risk Parameters</a>
				</li>
				<li role="presentation" >
					<a class="subTab nav-link" href="#CRC_RA" aria-controls="tab" role="tab" data-toggle="tab">Risk Assignment</a>
				</li>
				<li role="presentation" >
					<a class="subTab nav-link" href="#CRC_RC" aria-controls="tab" role="tab" data-toggle="tab">Risk Calculation</a>
				</li>
			</ul>
			<div class="tab-content" id="customerRiskCategorizationBottomFrame">
			</div>
		</div>
	</div>
</div>
