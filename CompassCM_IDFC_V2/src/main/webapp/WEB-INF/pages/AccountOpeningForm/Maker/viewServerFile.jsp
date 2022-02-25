<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
String contextPath = request.getContextPath() == null ? "" : request.getContextPath();
String fileRefNo = (String) request.getAttribute("fileRefNo");
String accountNo = (String) request.getAttribute("accountNo");
String isServerFile = (String) request.getAttribute("isServerFile");
%>
<html>
<head>
<title>
<% if("Y".equals(isServerFile)){ %>
	Account Opening Mandate for : <%=accountNo%>
<%}else{ %>
	Uploaded Document for <%=accountNo%>
<%} %>
</title>
<meta http-equiv="X-UA-Compatible" content="IE=9">
<meta name="Content-Type" content="txt/html; charset=ISO-8859-1">
<!--[if lt IE 9]>
                <script src="${pageContext.request.contextPath}/includes/scripts/html5shiv.js"></script>
                <script src="${pageContext.request.contextPath}/includes/scripts/html5shiv.min.js"></script>
                <script src="${pageContext.request.contextPath}/includes/scripts/respond.min.js"></script>
<![endif]-->
 
<script type="text/javascript"	src="${pageContext.request.contextPath}/includes/scripts/jquery.js"></script>
<script type="text/javascript"	src="${pageContext.request.contextPath}/includes/scripts/jquery-ui.js"></script>
<script type="text/javascript"	src="${pageContext.request.contextPath}/includes/scripts/bootstrap.min.js"></script>

<link rel="StyleSheet" type="text/css"	href="${pageContext.request.contextPath}/includes/styles/bootstrap.min.css" />
<link rel="StyleSheet" type="text/css"	href="${pageContext.request.contextPath}/includes/styles/jquery-ui.min.css" />
<style type="text/css">
	.imagePagination{
		display: inline;
	}
	.rotate{
		-ms-filter: progid:DXImageTransform.Microsoft.BasicImage(rotation=3); 
	}
</style>
<script type="text/javascript">
	var fileRefNo = '<%=fileRefNo%>';
	var maxPart = 1;
	var currPart = 1;
$(document).ready(function(){
	$("#serverImage").html("<center><br/><br/>Loading file. Please wait...<br/><br/></center>");
	var isServerFile= '<%=isServerFile%>';
	if(isServerFile == 'Y'){
		viewServerFile(<%=fileRefNo%>, 1);
	}else{
		$.ajax({
			type : "POST",
			url : "<%=contextPath%>/cpuMaker/downloadUploadFile?serverFileRefNo=<%=fileRefNo%>&serverFile=<%=isServerFile%>",
			cache : false,
			success : function(response){
				$("#serverImage").html("<center><img src='data:image/jpeg;base64," + response +"' alt='<%=accountNo%>' width='100%' height='100%' /></center>");		
			},
			error : function(a,b,c){
				$("#serverImage").html("<center><br/><br/>Could not process the request<br/><br/></center>");
			}
		});
	}

	$(document).keyup(function(event){
		currPart = parseInt(currPart);
		if(event.which == 37){
			if(currPart > 1){
				currPart = currPart - 1;
				display(fileRefNo, currPart);
			}
		}
		
		if(event.which == 39){
			if(currPart < maxPart){
				currPart = currPart + 1;
				display(fileRefNo, currPart);
			}
		}
	});
});

function viewServerFile(serverFileNo, part){
	if(serverFileNo == 0){
		$("#serverImage").html("<center><br/><br/>File not available<br/><br/></center>");
		return;
	}
	$.ajax({
		type : "POST",
		url : "<%=contextPath%>/cpuMaker/downloadServerFile?serverFileRefNo="+serverFileNo+"&part="+part+"&_csrf=${_csrf.token}",
		cache : false,
		success : function(response){
			var status = response.STATUS;
			var message = response.MESSAGE;
			if(status == "1"){
				maxPart = (response.TOTALPAGE);
				currPart = response.CURRENTPAGE;
				var html = "<nav aria-label='Page navigation'><ul class='pagination'>";
				for(var i = response.CURRENTPAGE; i <= response.TOTALPAGE; i++){
					if(response.CURRENTPAGE == i){
						html = html + "<li><div class='btn btn-success btn-small btn-class-"+i+"' onclick='display("+serverFileNo+","+i+")'>"+i+"</div></li>";
					}else{
						html = html + "<li><div class='btn btn-primary btn-small btn-class-"+i+"' onclick='display("+serverFileNo+","+i+")'>"+i+"</div></li>";
					}					
				}
				html = html + "</ul></nav>"
				$("#pagination").html(html);
				$("#imageTools").html("<nav aria-label='Page navigation'><ul class='pagination'> <li><div class='btn btn-primary btn-small' onclick='changeZoom(1)'>Zoom In</div></li><li><div class='btn btn-info btn-small' id='zoomLevel'></div></li><li><div class='btn btn-primary btn-small' onclick='changeZoom(2)'>Zoom Out</div></li><li><div class='btn btn-danger btn-small' onclick='changeZoom(0)'>Normal</div></li><li><div class='btn btn-primary btn-small' onclick='rotate(1)'>Rotate Left</div></li><li><div class='btn btn-primary btn-small' onclick='rotate(2)'>Rotate Right</div></li></ul></nav>");
				display(serverFileNo, part);
			}else{
				alert(message);
			}		
		},
		error : function(a,b,c){
			$("#serverImage").html("<center><br/><br/>Could not process the request<br/><br/></center>");
		}
	});
}

var height = "100";
var width = "100";
	

function display(serverFileNo, part){
	$("#serverImage").html("<center><br/><br/>Loading file. Please wait...<br/><br/></center>");
	currPart = part;
	$(".btn-small").each(function() {
		$(this).removeClass("btn-success").addClass("btn-primary");
	});
	$("#pagination").find(".btn-class-"+part).removeClass("btn-primary").addClass("btn-success");
	$("#serverImage").html("<center><img id='mandateImage' data-rotate='0' src='<%=contextPath%>/getTiffImage?serverFileRefNo="+serverFileNo+"&part="+part+"'/></center>");
	changeZoom(3);
}

function rotate(side){
	var deg = parseInt($("#mandateImage").attr('data-rotate'));
	if(deg == 360 || deg == -360){
		deg = 0;
	}
	var rotate = 'rotate(' + deg + 'deg)';
	if(side == 0){
		deg = 0;
	}else if(side == 1){
		deg = deg - 90;
	}else{
		deg = deg + 90;
	}
	var rotate = 'rotate(' + deg + 'deg)';
	$("#mandateImage").css('-ms-filter', "progid:DXImageTransform.Microsoft.Matrix(SizingMethod='auto expand', M11=0.7071067811865476, M12=-0.7071067811865475, M21=0.7071067811865475, M22=0.7071067811865476)");

	$("#mandateImage").css({
		'-webkit-transform': rotate,
		'-moz-transform': rotate,
		'-o-transform': rotate,
		'-ms-transform': rotate,
		'transform': rotate 
	});

	$("#mandateImage").attr("data-rotate", deg);
	if(deg == 90 || deg == -90 || deg == 270 || deg == -270){
		$("#mandateImage").css('margin-left','200px');
	}else{
		$("#mandateImage").css('margin-left','0px');
	}
}

function changeZoom(type){
	if(type == 0){
		height = "100";
		width = "100";
		rotate(0);
	}
	if(type == 1){
		height = parseInt($("#mandateImage").attr("height"));
		width = parseInt($("#mandateImage").attr("width"));
		height = height + 10;
		width = width + 10;
	}
	if(type == 2){		
		height = parseInt($("#mandateImage").attr("height"));
		width = parseInt($("#mandateImage").attr("width"));
		height = height - 10;
		width = width - 10;
	}
	$("#mandateImage").attr("height", height+"%");
	$("#mandateImage").attr("width", width+"%");
	$("#zoomLevel").html(height+"%");
}
</script>
</head>
<body onContextMenu="return false">
<div class="card-body">
	<div class="row">
		<div class="col-lg-12">
			<div class="card card-info">
				<div class="card-header">
					<% if("Y".equals(isServerFile)){ %>
					Account Opening Mandate of <%=accountNo%>
					<%}else{ %>
					Uploaded Document for <%=accountNo%>
					<%} %>
				</div>
				<table class="table">
					<tr style="text-align: center;">
						<td width="50%" id="pagination"></td>
						<td width="50%" style="margin-top: 5px;" id="imageTools"></td>
					</tr>
				</table>
				<div class="card-body" id="displayImage">
				<div id="pagination"></div>
				<div id="serverImage"></div>
				</div>
			</div>
		</div>
	</div>
</div>
</body>
</html>