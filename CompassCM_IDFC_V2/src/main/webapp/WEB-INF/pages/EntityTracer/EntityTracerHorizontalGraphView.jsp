
<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../tags/tags.jsp"%>
<%
String EXCULDEDPRODUCTCODE = (String) request.getAttribute("EXCULDEDPRODUCTCODE");
String FromDate = (String) request.getAttribute("FromDate");
String ToDate = (String) request.getAttribute("ToDate");
String AccountNumber = (String) request.getAttribute("AccountNumber");
String CustomerId = (String) request.getAttribute("CustomerId");
String CustomerName = (String) request.getAttribute("CustomerName");
String StaticLink = (String) request.getAttribute("StaticLink");
String TransactionLink = (String) request.getAttribute("TransactionLink");
String MinLinks = (String) request.getAttribute("MinLinks");
String CounterAccountNo = (String) request.getAttribute("CounterAccountNo");
String CounterAccountGroup = (String) request.getAttribute("CounterAccountGroup");
String LevelCount = (String) request.getAttribute("LevelCount");
%>

<!DOCTYPE html>
<meta charset="utf-8">
<style>

.node {
  cursor: pointer;  
}

.node circle {
  stroke: steelblue;
  stroke-width: 1.5px;
}

.node text {
  font: 15px sans-serif;
}

.link {
  fill: none;
  stroke: #ccc;
  stroke-width: 1.5px;
}



</style>
<body>
<script>

var margin = {top: 20, right: 120, bottom: 20, left: 150},
    width = 960 - margin.right - margin.left,
    height = 500 - margin.top - margin.bottom;

var i = 0,
    duration = 750,
    root;

var tree = d3.layout.tree()
    .size([height, width]);

var nodeColor = d3.scale.ordinal()
.domain(['1', '2', '3', '4', '5', '6'])
.range(['black', '#ffaa00', 'grey', 'red', 'green', 'blue'])

var diagonal = d3.svg.diagonal()
    .projection(function(d) { return [d.y, d.x]; });

$("#d3flare").html("");

var svg = d3.select("#d3flare").append("svg")
    .attr("width", width + margin.right + margin.left)
    .attr("height", height + margin.top + margin.bottom)
  .append("g")
    .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

//var url = "${pageContext.request.contextPath}/common/getEntityLinkedDetailsGraphView?AccountNumber=078908902&FromDate="+FromDate+"&ToDate=01/01/2017&LevelCount=8&TransactionLink=y";
var url = "${pageContext.request.contextPath}/common/getEntityLinkedDetailsGraphView?AccountNumber=<%=AccountNumber%>"+
		  "&FromDate=<%=FromDate%>&ToDate=<%=ToDate%>&LevelCount=<%=LevelCount%>&TransactionLink=<%=TransactionLink%>"+
		  "&EXCULDEDPRODUCTCODE=<%=EXCULDEDPRODUCTCODE%>&CustomerId=<%=CustomerId%>&CustomerName=<%=CustomerName%>"+
		  "&StaticLink=<%=StaticLink%>&MinLinks=<%=MinLinks%>&CounterAccountNo=<%=CounterAccountNo%>&CounterAccountGroup=<%=CounterAccountGroup%>";
		  
d3.json(url, function(error, flare) {
  if (error) throw error;

  root = flare;
  root.x0 = height / 2;
  root.y0 = 0;

  function collapse(d) {
    if (d.children) {
      d._children = d.children;
      d._children.forEach(collapse);
      d.children = null;
    }
  }

  root.children.forEach(collapse);
  update(root);
});

d3.select(self.frameElement).style("height", "800px");

function update(source) {

  // Compute the new tree layout.
  var nodes = tree.nodes(root).reverse(),
      links = tree.links(nodes);

  // Normalize for fixed-depth.
  nodes.forEach(function(d) { d.y = d.depth * 180; });

  // Update the nodes…
  var node = svg.selectAll("g.node")
      .data(nodes, function(d) { return d.id || (d.id = ++i); });

  // Enter any new nodes at the parent's previous position.
  var nodeEnter = node.enter().append("g")
      .attr("class", "node")
      .attr("transform", function(d) { return "translate(" + source.y0 + "," + source.x0 + ")"; })
      .on("click", click);

/*  nodeEnter.append("image")
  .attr("xlink:href", "")
  .attr("x", "-12px")
  .attr("y", "-12px")
  .attr("width", "24px")
  .attr("height", "24px");
 */ 
   nodeEnter.append("circle")
      .attr("r", 1e-6)
      .on("mouseover", flareDataDialogBox)
      .style("fill", color);

  nodeEnter.append("text")
      .attr("x", function(d) { return d.children || d._children ? -10 : 10; })
      .attr("dy", ".35em")
      .on("mouseover", flareDataDialogBox)
      .attr("text-anchor", function(d) { return d.children || d._children ? "end" : "start"; })
      .text(function(d) { return d.name; })
      .style("fill-opacity", 1e-6);

  // Transition nodes to their new position.
  var nodeUpdate = node.transition()
      .duration(duration)
      .attr("transform", function(d) { return "translate(" + d.y + "," + d.x + ")"; });
	
  nodeUpdate.select("circle")
      .attr("r", 5)
      .style("fill", color);

  nodeUpdate.select("text")
  .style("fill-opacity", 1);
  
  

  // Transition exiting nodes to the parent's new position.
  var nodeExit = node.exit().transition()
      .duration(duration)
      .attr("transform", function(d) { return "translate(" + source.y + "," + source.x + ")"; })
      .remove();

  nodeExit.select("circle")
      .attr("r", 5);

  nodeExit.select("text")
      .style("fill-opacity", 1e-6);

  // Update the links…
  var link = svg.selectAll("path.link")
      .data(links, function(d) { return d.target.id; });

  // Enter any new links at the parent's previous position.
  link.enter().insert("path", "g")
      .attr("class", "link")
      .attr("d", function(d) {
        var o = {x: source.x0, y: source.y0};
        return diagonal({source: o, target: o});
      });

  // Transition links to their new position.
  link.transition()
      .duration(duration)
      .attr("d", diagonal);

  // Transition exiting nodes to the parent's new position.
  link.exit().transition()
      .duration(duration)
      .attr("d", function(d) {
        var o = {x: source.x, y: source.y};
        return diagonal({source: o, target: o});
      })
      .remove();

  // Stash the old positions for transition.
  nodes.forEach(function(d) {
    d.x0 = d.x;
    d.y0 = d.y;
  });
}

function color(d) {
	return nodeColor(d.levelName);
}

// Toggle children on click.
function click(d) {
  if (d.children) {
    d._children = d.children;
    d.children = null;
  } else {
    d.children = d._children;
    d._children = null;
  }
  update(d);
}

function flareDataDialogBox(d){
	$("#flareDataDialogBox > #SEARCHACCOUNTNO").val(d.SEARCHACCOUNTNO);
	$("#flareDataDialogBox > #LINKEDNAME").html(d.LINKEDNAME);
	$("#flareDataDialogBox > #LINKEDTYPE").html(d.LINKEDTYPE);
	$("#flareDataDialogBox > #LINKEDACCOUNTNO").html(d.LINKEDACCOUNTNO);
	$("#flareDataDialogBox > #LINKEDCUSTOMERID").html(d.LINKEDCUSTOMERID);
	$("#flareDataDialogBox > #LINKEDCUSTOMERTYPE").html(d.LINKEDCUSTOMERTYPE);
	$("#flareDataDialogBox > #FORCELINK").html(d.FORCELINK);
	$("#flareDataDialogBox > #TRANSACTEDAMOUNT").html(d.TRANSACTEDAMOUNT);
	$("#flareDataDialogBox > #TRANSACTEDCOUNT").html(d.TRANSACTEDCOUNT);
	$("#flareDataDialogBox > #DUPLICATEVALUE").html(d.DUPLICATEVALUE);
	$("#flareDataDialogBox > #IFEXISTINGTAB").html(d.IFEXISTINGTAB);
	findPosition(event);
}

function findPosition(elm){
	var mouseX = elm.pageX;
	var mouseY = elm.pageY - 80;
	
	if($("#flareDataDialogBox > #SEARCHACCOUNTNO").val() != "")
		$("#flareDataDialogBox").css({"top" : mouseY, "left" : mouseX}).show();
	else
		hidePosition();
}

function hidePosition(){
	$("#flareDataDialogBox").hide();	
}

function openLinkGraphDetails(elm, type){
	var value = $(elm).html();
	if(type == "ACCOUNT")
		openAcctDetails(value);
	else if(type == "CUSTID")
		openCustDetails(value);
	else if(type == "TXNCOUNT"){
		var SEARCHACCOUNTNO = $("#flareDataDialogBox > #SEARCHACCOUNTNO").val();
		var LINKEDACCOUNTNO = $("#flareDataDialogBox > #LINKEDACCOUNTNO").html();
		var strLinkedCustId = $("#flareDataDialogBox > #LINKEDCUSTOMERID").html();
		var strLinkedCustName = $("#flareDataDialogBox > #LINKEDNAME").html();
		var strLinkedType = $("#flareDataDialogBox > #LINKEDTYPE").html();
		openLinkDetails(SEARCHACCOUNTNO, LINKEDACCOUNTNO, strLinkedCustId, strLinkedCustName,strLinkedType); 
	}else if(type == "LINKTYPE"){
		var LINKEDACCOUNTNO = $("#flareDataDialogBox > #LINKEDACCOUNTNO").html();
		var strLinkedCustId = $("#flareDataDialogBox > #LINKEDCUSTOMERID").html();
		var strLinkedCustName = $("#flareDataDialogBox > #LINKEDNAME").html();
		newGraphycalEntityTracerSearch(strLinkedCustName, strLinkedCustId, LINKEDACCOUNTNO);
	}
}

</script>
<div id="flareDataDialogBox">
	<input type="hidden" id="SEARCHACCOUNTNO"/>
	LINKEDNAME : <span id="LINKEDNAME"></span>, LINKEDTYPE : <span class="hyperlink" id="LINKEDTYPE" onclick="openLinkGraphDetails(this, 'LINKTYPE')"></span>, LINKEDACCOUNTNO : <span class="hyperlink" id="LINKEDACCOUNTNO" onclick="openLinkGraphDetails(this, 'ACCOUNT')"></span>, <br/>
	LINKEDCUSTOMERID : <span class="hyperlink" id="LINKEDCUSTOMERID" onclick="openLinkGraphDetails(this, 'CUSTID')"></span>, LINKEDCUSTOMERTYPE : <span id="LINKEDCUSTOMERTYPE"></span>, TRANSACTEDAMOUNT : <span id="TRANSACTEDAMOUNT"></span>, </br>
	TRANSACTEDCOUNT : <span class="hyperlink" id="TRANSACTEDCOUNT" onclick="openLinkGraphDetails(this, 'TXNCOUNT')"></span>, FORCELINK : <span id="FORCELINK"></span>, DUPLICATEVALUE : <span id="DUPLICATEVALUE"></span>, IFEXISTINGTAB : <span id="IFEXISTINGTAB"></span>
</div>

<div id="d3flare"></div>

<style type="text/css">
	#flareDataDialogBox{
		padding: 10px;
		position: absolute;
		border-radius : 4px;
		background-color: #DDDDDD;
		font-size: 10px;
		box-shadow: 0px 0px 10px #555;
		opacity : 0.7;
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
<script type="text/javascript">
	$(document).ready(function(){
		 $(document).keydown(function(event){
		        if(event.which=="27"){
		        	hidePosition();
		        }
		 });
	});
</script>