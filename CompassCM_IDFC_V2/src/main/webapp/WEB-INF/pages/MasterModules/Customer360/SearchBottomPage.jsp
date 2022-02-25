<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../../tags/tags.jsp"%>
<%
String CustomerId = (String) request.getAttribute("CUSTOMERID");
String CustomerName = (String) request.getAttribute("CUSTOMERNAME");
%>
<html>
<style>
.link {
   fill: none;
   stroke: #ccc;
   stroke-width: 2px;
 }
 .keyText{
 	text-transform: lowercase;
 }
</style>



<body>
<script>
	var margin = {top: 520, right: 200, bottom: 400, left: 600},
	width = 1260 - margin.right - margin.left,
	height = 1020 - margin.top - margin.bottom;
	
	var r = 960 / 2;
	var tree = d3.layout.tree()
		.size([360, r - 120])
		.separation(function(a, b) { return (a.parent == b.parent ? 1 : 2) / a.depth; });
		
	var diagonal = d3.svg.diagonal.radial()
		.projection(function(d) { return [d.y, d.x / 180 * Math.PI]; });
		
	
	var vis = d3.select("#chart").append("svg:svg")
		.attr("width", width + margin.right + margin.left)
      	.attr("height", height + margin.top + margin.bottom)
		.append("svg:g")
		.attr("transform", "translate(" + margin.left + "," + margin.top + ")");

		
	var url = "${pageContext.request.contextPath}/common/searchCustomer360DataGraph?CustomerId=<%=CustomerId%>&CustomerName=<%=CustomerName%>";
	d3.json(url, function(error, flare) {
	
		  root = flare;
		  root.x0 = height / 2;
		  root.y0 = 0;
		  update(root);
	});

	function update(source){
		
		var nodes = tree.nodes(root);
		
		var link = vis.selectAll("path.link")
			.data(tree.links(nodes));
		
		
		link.enter().insert("path", "g").attr("dy", ".35em").attr("class", "link")
	 		.attr("d", diagonal);
		
		var node = vis.selectAll("g.node")
			.data(nodes)
			.enter().append("svg:g")
			.attr("class", "node")
			.attr("transform", function(d) { return "rotate(" + (d.x - 90) + ")translate(" + d.y + ")"; })
			
		node.append("svg:circle")
			.attr("r", 3.5);
		
		/* node.append("svg:text")
			.attr("dx", function(d) { return d.x < 180 ? 8 : -8; })
			.attr("dy", ".3em")
			.attr("text-anchor", function(d) { return d.x < 180 ? "start" : "end"; })
			.attr("transform", function(d) { return d.x < 180 ? null : "rotate(180)"; })
			.text(function(d) { return d.value; });  */
		
		node.append("svg:text")
		.attr("dx", function(d) {return d.x < 180 ? 8 : -8; })
		.attr("dy", ".51em")
		.attr("class","keyText")
		.on("mouseover", flareDataDialogBox).attr(
				"text-anchor", function(d) {
					return d.children || d._children ? "end" : "start";
				}).text(function(d) {
			return d.value;
		 })
		.attr("text-anchor", function(d) { return d.x < 180 ? "start" : "end"; })
		.attr("transform", function(d) { return d.x < 180 ? null : "rotate(180)"; })
		.text(function(d) { return d.name; });
		
	}

	function flareDataDialogBox(d) {
		console.log(d.value);
		$("#flareDataDialogBox > #SEARCHVALUE").val(d.value);
		$("#flareDataDialogBox > #SEARCHVALUE").html(d.value);
		findPosition(event);
	}
	function findPosition(elm) {
		var mouseX = elm.pageX;
		var mouseY = elm.pageY - 80;

		if ($("#flareDataDialogBox > #SEARCHVALUE").val() != ""){
			/* alert("in if");
			alert($("#flareDataDialogBox > #SEARCHVALUE").val()); */
			$("#flareDataDialogBox").css({"top" : mouseY, "left" : mouseX}).show();
		}else
			hidePosition();
	}

	function hidePosition() {
		$("#flareDataDialogBox").hide();
	}
</script>
<script type="text/javascript">
	$(document).ready(function(){
		 $(document).keydown(function(event){
		        if(event.which=="27"){
		        	hidePosition();
		        }
		 });			
	});
</script>
<div id="flareDataDialogBox">
	VALUE : <span id="SEARCHVALUE"></span>	
</div>
<div id="chart">
</div>

<style type="text/css">
	#flareDataDialogBox{
		padding: 10px;
		position: absolute;
		border-radius : 4px;
		background-color: #DDDDDD;
		font-size: 10px;
		box-shadow: 0px 0px 10px #555;
		opacity : 1.7;
		display: none;
	}
	#flareDataDialogBox > span{
		font-weight: 600;
	}
	#flareDataDialogBox:HOVER{
		background-color: #EEEEEE;
		box-shadow: 0px 0px 10px #000000;
		opacity : 1;
	}
	.hyperlink{
		cursor: pointer;
		color: #0000FF;
	}
</style>


</body>
</html>
