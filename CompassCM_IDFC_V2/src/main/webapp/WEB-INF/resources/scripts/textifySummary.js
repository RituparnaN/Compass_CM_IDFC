var textifySummary = textifySummary || (function() {
	var ctx = window.location.href;
	ctx = ctx.substring(0, ctx.split("/", 4).join("/").length);
	return {
		getSummary: function(ele) {
			$(ele).siblings().each(function() {
				msg = $(this).val()
				$("#compassCaseWorkFlowGenericModal").modal("show");
				$("#compassCaseWorkFlowGenericModal-title").html("Comment Summary");
				$("#compassCaseWorkFlowGenericModal-body").html("<br/><center><img alt='Loading...' src='${pageContext.request.contextPath}/includes/images/qde-loadder.gif'></center><br/>");
				$.ajax({
					url: 'http://127.0.0.1:5555/predict',
					cache: true,
					type: 'POST',
					data: "message=" + msg,
					success: function(res) {
						var summaryHtml = `<div class="card card-primary" style="width:95%;margin:auto;margin-top:1%;margin-bottom:1%" >
												<div class="card-header clearfix" 
													id="slidingSummaryPanel"" data-toggle="collapse"
													 style = "background-color:#95f1a7">
													<h6 class="card-title pull-left">Generated Summary</h6>
													
												</div>
												<div id="summarySection" class="summarySection" >
													
															<table class="table table-striped">
																<tr style = "width:100%">
																	<td width="100%">
																		<textarea class = "form-control input-sm" readonly>`+ res + `</textarea>
																	</td>
																</tr>
															</table>
													</div>
												</div>`

						$("#compassCaseWorkFlowGenericModal-body").html(summaryHtml);
					},
					error: function(a, b, c) {
						alert(a + b + c);
					}
				});

			});
		},
	}
}
());