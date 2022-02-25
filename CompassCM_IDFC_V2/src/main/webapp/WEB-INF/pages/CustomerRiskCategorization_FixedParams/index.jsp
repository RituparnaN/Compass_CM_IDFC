<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../tags/tags.jsp"%>
<script type="text/javascript">
	$(document).ready(function(){
		var id = '${UNQID}';
		$.ajax({
			url: "${pageContext.request.contextPath}/admin/getCRCTabContent",
			cache: false,
			type: "POST",
			data: "id="+id,
			success: function(res){
				$("#CRCTabContent").html(res);
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
					<a class="subTab" href="#staticCRC" aria-controls="tab" role="tab" data-toggle="tab">Static CRC</a>
				</li>
				<li role="presentation" >
					<a class="subTab" href="#dynamicCRC" aria-controls="tab" role="tab" data-toggle="tab">Dynamic CRC</a>
				</li>
			</ul>
			<div class="tab-content" id="CRCTabContent"></div>
		</div>
	</div>
</div>
