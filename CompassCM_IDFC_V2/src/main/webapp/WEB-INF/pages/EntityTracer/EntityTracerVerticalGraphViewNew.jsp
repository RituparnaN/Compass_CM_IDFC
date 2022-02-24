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
  color: red;
}

.link {
  fill: none;
  stroke: #ccc;
  stroke-width: 1.5px;
}

 #d3flare{
     width: 100%;
     overflow: scroll;
     white-space: nowrap;
}

.linkCheckbox {
	width: 85%;
}

.linkCheckbox > div{
	width: 45%;
	/* display: inline-block; */
}

.linkCheckbox label{
	padding:10px;
}
.inlineCheckboxAndButtons{
	display: flex;
	margin-top: -10px;
	padding:10px;
}
div.sticky {
  position: -webkit-sticky;
  position: sticky;
  top: 0;
  padding-top: 60px;
}
.generateButtonDiv{
	float: right;
}

.generateButtonDiv button{
	border-radius:25px;
}
.linkCheckbox input[type=checkbox] {
	-moz-appearance:none;
	-webkit-appearance:none;
	-o-appearance:none;
	outline: none;
	content: none;	
}

.linkCheckbox input[type=checkbox]:before {
	font-family: "FontAwesome";
    content: "\f00c";
    font-size: 12px;
    color: transparent !important;
    background: white;
    display: block;
    width: 20px;
    height: 20px;
    border: 1px solid blue;
    margin-right: 0;
    padding:3px;
    border-radius: 50%;
}

.linkCheckbox input[type=checkbox]:checked:before {
	color: blue !important;
}

foreignObject input[type=checkbox]{
	-moz-appearance:none;
	-webkit-appearance:none;
	-o-appearance:none;
	outline: none;
	content: none;	
}
foreignObject input[type=checkbox]:before {
	font-family: "FontAwesome";
    content: "\f00c";
    font-size: 9px;
    color: transparent !important;
    background: white;
    display: block;
    width: 15px;
    height: 15px;
    border: 1px solid black;
    margin-right: 0;
    padding:2px;
    border-radius: 50%;
}

foreignObject input[type=checkbox]:checked:before {
	color: black !important;
}
#staticLinkChecks{
	display:none;
}
.node image{
	z-index: -1;
}
.checkboxforNode{
	z-index: 1;
}
.nodeSelected{
	font-weight: 700 !important;
}

</style>
<body>
<script>

var selectNodeForAlert = {};
	function expand(d){   
	    var children = (d.children)?d.children:d._children;
	    if (d._children) {        
	        d.children = d._children;
	        d._children = null;       
	    }
	    if(children)
	      children.forEach(expand);
	}
	
	function expandAll(){
	    expand(root); 
	    update(root);
	}
	var margin = {top: 60, right: 120, bottom: 20, left: 0},
	    width = 960 - margin.right - margin.left,
	    height = 620 - margin.top - margin.bottom;
	
	var i = 0,
	    duration = 750,
	    root;
	
	var tree = d3.layout.tree().nodeSize([70, 40]);
	
	var nodeColor = d3.scale.ordinal()
	.domain(['1', '2', '3', '4', '5', '6'])
	.range(['black', '#ffaa00', 'grey', 'red', 'green', 'blue'])
	
	var diagonal = d3.svg.diagonal()
	    .projection(function(d) {
	    	return [d.x, d.y]; 
	    	});

	var svg = d3.select("#d3flare").append("svg") 
      .attr("width", width + margin.right + margin.left)
      .attr("height", height + margin.top + margin.bottom) 
      //svg zoom
	  .call(d3.behavior.zoom().scaleExtent([1 / 2, 96]).on("zoom", function () {
    	svg.attr("transform", "translate(" + d3.event.translate + ")" + " scale(" + d3.event.scale + ")")
       }))
	  .append("g")
	  .attr("transform", "translate(" + margin.left + "," + margin.top + ")");
      
	//var url = "${pageContext.request.contextPath}/common/getEntityLinkedDetailsGraphView?AccountNumber=078908902&FromDate="+FromDate+"&ToDate=01/01/2017&LevelCount=8&TransactionLink=y";
	var url = "${pageContext.request.contextPath}/common/getEntityLinkedDetailsGraphView?AccountNumber=<%=AccountNumber%>"+
		  "&FromDate=<%=FromDate%>&ToDate=<%=ToDate%>&LevelCount=<%=LevelCount%>&TransactionLink=<%=TransactionLink%>"+
		  "&EXCULDEDPRODUCTCODE=<%=EXCULDEDPRODUCTCODE%>&CustomerId=<%=CustomerId%>&CustomerName=<%=CustomerName%>"+
		  "&StaticLink=<%=StaticLink%>&MinLinks=<%=MinLinks%>&CounterAccountNo=<%=CounterAccountNo%>&CounterAccountGroup=<%=CounterAccountGroup%>";

	var staticLinkGraph,transactionLinkGraph;
	
	if("<%=StaticLink%>" == "y"){
		staticLinkGraph = true;
	}else{
		staticLinkGraph = false;
	}
	if("<%=TransactionLink%>" == "y"){
		transactionLinkGraph = true;
	}else{
		transactionLinkGraph = false;
	}

	//append Static & Transaction checkboxes 
	$("#staticLinkLabel").append(
			"<input type='checkbox' id='StaticLinkGraph' name='StaticLinkGraph' value='"
			+ staticLinkGraph
			+ "'><span>    Static Link</span>");
	$("#transactionLinkLabel").append(
			"<input type='checkbox' id='TransactionLinkGraph' name='TransactionLinkGraph' value='"
			+ transactionLinkGraph
			+ "'><span>    Transaction Link</span>");
	
	if(staticLinkGraph == true){
		$('#StaticLinkGraph').prop('checked', true);
	}else{
		$('#StaticLinkGraph').prop('checked', false);
	}
	if(transactionLinkGraph == true){
		$('#TransactionLinkGraph').prop('checked', true);
	}else{
		$('#TransactionLinkGraph').prop('checked', false);
	}

	d3.json(url, function(error, flare) {
		if (error)
			throw error;

		root = flare;
		root.x0 = height / 2;
		root.y0 = 0;

		update(root);
	});
	
	function update(source) {
		
		//calculate svg width using node children
		var levelWidth = [1];
		var childCount = function(level, n) {
		    if (n.children && n.children.length > 0) {
		      if (levelWidth.length <= level + 1) levelWidth.push(0);

		      levelWidth[level + 1] += n.children.length;
		      n.children.forEach(function(d) {
		        childCount(level + 1, d);
		      });
		    }
		};
		childCount(0, root);
		  
		//calculate tree new height using levelWidth
	    var newHeight = d3.max(levelWidth) * 100;
	    var maxBubbleAtAnyLevelWidth = Math.max(...levelWidth)*130;
    	if(maxBubbleAtAnyLevelWidth < 1400){
		  d3.select("svg").attr("width", "100%")
	    }else{
		  d3.select("svg").attr("width", maxBubbleAtAnyLevelWidth)
	    }
	    tree = tree.size([newHeight, width]);
		// Compute the new tree layout.
		var nodes = tree.nodes(root).reverse(), links = tree.links(nodes);
		// Normalize for fixed-depth.
		nodes.forEach(function(d) {
			d.y = d.depth * 100;
		});

		// Update the nodes…
		var node = svg.selectAll("g.node").data(nodes, function(d) {
			return d.id || (d.id = ++i);
		});

		// Enter any new nodes at the parent's previous position.
		var nodeEnter = node.enter().append("g")
			.attr("class", "node")
			.style().attr(
				"transform", function(d) {
					return "translate(" + source.x0 + "," + source.y0 + ")";
			})
			.on("click", function(data){
				if(d3.event.srcElement.nodeName == "image"){
			         click(data); // => Original DOM Event
		        }
				else{
		        	 
	       	 	}
	    });
		
		//append circle to each node with customer risk
 		nodes.forEach(function(d) {
			nodeEnter.append("circle")
			.on("mouseover", flareDataDialogBox)
			.attr("r", 20).attr("fill", "white")
			.style("stroke", function(d) {
				let clr = "";
				if (d.CUSTOMERRISK == "HIGH")
					clr = "red";
				else if (d.CUSTOMERRISK == "MEDIUM")
					clr = "yellow";
				else if (d.CUSTOMERRISK == "LOW" || d.CUSTOMERRISK == "N.A.")
					clr = "green";
				return clr;
			})
		}); 

 		//append icons to each node 
		var images = nodeEnter
			.append("svg:image")
			.on("mouseover",flareDataDialogBox)
			.attr("xlink:href",function(d) {return "${pageContext.request.contextPath}/includes/images/EntityTracer/"+ d.ENTITYICON;
			}).attr("x", function(d) {
				return -15;
			}).attr("y", function(d) {
				return -15;
			}).attr("height", 30)
			.attr("width", 30);
		
		 //append text to each node using click event(node selection is used for generate alert) 
 		nodeEnter.append("text")
	     .attr("y", function(d) {
			return d.children || d._children ? -28 : -28;
		 })
		 .attr("x", function(d){
			return d.children || d._children ? 20 : -15;
		 })
		 .on("mouseover", flareDataDialogBox)
		 .attr("text-anchor", function(d) {
			return d.children || d._children ? "end" : "start";
		 })
		 .text(function(d) {
			return d.name;
		 }) 
		 .on("click", function(d,i) {
	    	    if(selectNodeForAlert[d.id]){
	    			d3.select(this).attr("class","");
		    		delete selectNodeForAlert[d.id];
		    	}else{
		    		d3.select(this).attr("class","nodeSelected");
		    		selectNodeForAlert[d.id] = d;
		    	}
          })
          .style("font-size", 14);
 		
		
		// Transition nodes to their new position.
		var nodeUpdate = node.transition().duration(duration).attr("transform",
			function(d) {
				return "translate(" + d.x + "," + d.y + ")";
			});

		nodeUpdate.select("circle").attr("r", 5).style("fill", color);

		nodeUpdate.select("text").style("fill-opacity", 1);

		// Transition exiting nodes to the parent's new position.
		var nodeExit = node.exit().transition().duration(duration).attr(
			"transform", function(d) {
				return "translate(" + source.x + "," + source.y + ")";
			}).remove();

		nodeExit.select("circle").attr("r", 1e-6);

		nodeExit.select("text").style("fill-opacity", 1e-6);

		// Update the links…
		var link = svg.selectAll("path.link").data(links, function(d) {
			return d.target.id;
		});

		link.enter().insert("path", "g").attr("dy", ".35em").attr("class", "link")
		 .style("stroke-dasharray", function(d) {
			let tempDetails = d.target;
            if (tempDetails.LINKEDTYPE == "TRANSACTION") {return "2"};
         })
         // stroke width with respect to trasaction amount
         .style("stroke-width",
        	function(d){
        	 let tempDetailsData = d.target;
        	 let strokeWidth = "";
	       	 if(tempDetailsData.LINKEDTYPE == "TRANSACTION"){
        		 if(tempDetailsData.TRANSACTEDAMOUNT >= 0 && tempDetailsData.TRANSACTEDAMOUNT <= 100000){
        			 strokeWidth = 3.0;
        		 }else if(tempDetailsData.TRANSACTEDAMOUNT >= 100000 && tempDetailsData.TRANSACTEDAMOUNT <= 1000000){
        			 strokeWidth = 4.0;
        		 }
        	 }else{
        		 strokeWidth = 1.0; 
        	 }
        	 return strokeWidth;
         })
         // stroke with respect to trasaction Risk
		 .style("stroke",
			function(d) {
				let tempDetails = d.target;
				let clr = "";
				if (tempDetails.LINKEDTYPE == "TRANSACTION") {
					if (tempDetails.TRANSACTIONRISK == "HIGH")
						clr = "red";
					else if (tempDetails.TRANSACTIONRISK == "MEDIUM")
						clr = "yellow";
					else if (tempDetails.TRANSACTIONRISK == "N.A.")
						clr = "green";
				} else {
					clr = "grey";
				}
				return clr;
			}).attr("d", function(d) {
			var o = {
				x : source.x0,
				y : source.y0
			};
			return diagonal({
				source : o,
				target : o
			});
		});

		// Transition links to their new position.
		link.transition().duration(duration).attr("d", diagonal);

		// Transition exiting nodes to the parent's new position.
		link.exit().transition().duration(duration).attr("d", function(d) {
			var o = {
				x : source.x,
				y : source.y
			};
			return diagonal({
				source : o,
				target : o
			});
		}).remove();

		// Stash the old positions for transition.
		nodes.forEach(function(d) {
			d.x0 = d.x;
			d.y0 = d.y;
		});
		
		//calculate svg height with respect of level count
		window.setTimeout(function() {
		    var max = d3.max(d3.selectAll(".node")[0], function(g) {
		      return d3.transform(d3.select(g).attr("transform")).translate[1];
		    });
		    d3.select("svg").attr("height", max + 100)
		  }, 800)
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
	function collapse(d) {
		  if (d.children) {
		    d._children = d.children;
		    d._children.forEach(collapse);
		    d.children = null;
		  }
		}

	update(root);
	d3.select(self.frameElement).style("height", "800px");

	function flareDataDialogBox(d) {
		$("#flareDataDialogBox > #SEARCHACCOUNTNO").val(d.SEARCHACCOUNTNO);
		$("#flareDataDialogBox > #LINKEDNAME").html(d.LINKEDNAME);
		$("#flareDataDialogBox > #LINKEDTYPE").html(d.LINKEDTYPE);
		$("#flareDataDialogBox > #LINKEDACCOUNTNO").html(d.LINKEDACCOUNTNO);
		$("#flareDataDialogBox > #LINKEDCUSTOMERID").html(d.LINKEDCUSTOMERID);
		$("#flareDataDialogBox > #LINKEDCUSTOMERTYPE").html(
				d.LINKEDCUSTOMERTYPE);
		$("#flareDataDialogBox > #FORCELINK").html(d.FORCELINK);
		$("#flareDataDialogBox > #TRANSACTEDAMOUNT").html(d.TRANSACTEDAMOUNT);
		$("#flareDataDialogBox > #TRANSACTEDCOUNT").html(d.TRANSACTEDCOUNT);
		$("#flareDataDialogBox > #DUPLICATEVALUE").html(d.DUPLICATEVALUE);
		$("#flareDataDialogBox > #IFEXISTINGTAB").html(d.IFEXISTINGTAB);
		findPosition(event);
	}

	function findPosition(elm) {
		var mouseX = elm.pageX;
		var mouseY = elm.pageY - 80;

		if ($("#flareDataDialogBox > #SEARCHACCOUNTNO").val() != "")
			$("#flareDataDialogBox").css({"top" : mouseY, "left" : mouseX}).show();
		else
			hidePosition();
	}

	function hidePosition() {
		$("#flareDataDialogBox").hide();
	}

	function openLinkGraphDetails(elm, type) {
		var value = $(elm).html();
		if (type == "ACCOUNT")
			openAcctDetails(value);
		else if (type == "CUSTID")
			openCustDetails(value);
		else if (type == "TXNCOUNT") {
			var SEARCHACCOUNTNO = $("#flareDataDialogBox > #SEARCHACCOUNTNO")
					.val();
			var LINKEDACCOUNTNO = $("#flareDataDialogBox > #LINKEDACCOUNTNO")
					.html();
			var strLinkedCustId = $("#flareDataDialogBox > #LINKEDCUSTOMERID")
					.html();
			var strLinkedCustName = $("#flareDataDialogBox > #LINKEDNAME")
					.html();
			var strLinkedType = $("#flareDataDialogBox > #LINKEDTYPE").html();
			openLinkDetails(SEARCHACCOUNTNO, LINKEDACCOUNTNO, strLinkedCustId,
					strLinkedCustName, strLinkedType);
		} else if (type == "LINKTYPE") {
			var LINKEDACCOUNTNO = $("#flareDataDialogBox > #LINKEDACCOUNTNO")
					.html();
			var strLinkedCustId = $("#flareDataDialogBox > #LINKEDCUSTOMERID")
					.html();
			var strLinkedCustName = $("#flareDataDialogBox > #LINKEDNAME")
					.html();
			newGraphycalEntityTracerSearch(strLinkedCustName, strLinkedCustId,
					LINKEDACCOUNTNO);
		}
	}

	//the graph will be re-rendered with transaction link data only
	 $("#StaticLinkGraph").on("change", function(){
			var staticLinkCheckboxValue = $(this).is(":checked");
			var staticLinkValue;
			var transactionLinkValue;
			if(staticLinkCheckboxValue)
				staticLinkValue = "Y";
			else
				staticLinkValue = "N";
			var transactionLinkCheckboxValue = $("#TransactionLinkGraph").is(":checked");
			if(transactionLinkCheckboxValue)
				transactionLinkValue = "Y";
			else
				transactionLinkValue = "N";
			//alert(staticLinkValue+" && "+transactionLinkValue);
			if(staticLinkValue == "Y" || transactionLinkValue == "Y"){
				url = "${pageContext.request.contextPath}/common/getEntityLinkedDetailsGraphView?AccountNumber=<%=AccountNumber%>"+"&FromDate=<%=FromDate%>&ToDate=<%=ToDate%>&LevelCount=<%=LevelCount%>"+"&TransactionLink="+transactionLinkValue+"&EXCULDEDPRODUCTCODE=<%=EXCULDEDPRODUCTCODE%>&CustomerId=<%=CustomerId%>&CustomerName=<%=CustomerName%>"+"&StaticLink="+staticLinkValue+"&MinLinks=<%=MinLinks%>&CounterAccountNo=<%=CounterAccountNo%>&CounterAccountGroup=<%=CounterAccountGroup%>";
			}else if(staticLinkValue == "N" && transactionLinkValue == "N"){
				alert("Atleast one should be checked");
				$(this).prop('checked', true);
				var url = "${pageContext.request.contextPath}/common/getEntityLinkedDetailsGraphView?AccountNumber=<%=AccountNumber%>"+"&FromDate=<%=FromDate%>&ToDate=<%=ToDate%>&LevelCount=<%=LevelCount%>"+"&TransactionLink=N&EXCULDEDPRODUCTCODE=<%=EXCULDEDPRODUCTCODE%>&CustomerId=<%=CustomerId%>&CustomerName=<%=CustomerName%>"+"&StaticLink=Y&MinLinks=<%=MinLinks%>&CounterAccountNo=<%=CounterAccountNo%>&CounterAccountGroup=<%=CounterAccountGroup%>";
			}
			
			if(staticLinkValue == "Y" || transactionLinkValue == "Y"){
				d3.json(url, function(error, flare){
					if(Object.keys(flare).length > 0){
						if (error)
							throw error;
	
						root = flare;
						root.x0 = height / 2;
						root.y0 = 0;

						update(root);
						$("#staticLinkChecks").hide();
					}else{
						svg.selectAll("*").remove();
						$("#staticLinkChecks").show();
			 		}
				});
			}
		});
		//the graph will be re-rendered with static link data only
		 $("#TransactionLinkGraph").on("change", function(){
				var staticLinkCheckboxValue = $("#StaticLinkGraph").is(":checked");
				var transactionLinkCheckboxValue = $(this).is(":checked");
				var staticLinkValue;
				var transactionLinkValue;
				
				if(staticLinkCheckboxValue)
					staticLinkValue = "Y";
				else
					staticLinkValue = "N";
				
				if(transactionLinkCheckboxValue)
					transactionLinkValue = "Y";
				else
					transactionLinkValue = "N";

				if(staticLinkValue == "Y" || transactionLinkValue == "Y"){
					url = "${pageContext.request.contextPath}/common/getEntityLinkedDetailsGraphView?AccountNumber=<%=AccountNumber%>"+"&FromDate=<%=FromDate%>&ToDate=<%=ToDate%>&LevelCount=<%=LevelCount%>"+"&TransactionLink="+transactionLinkValue+"&EXCULDEDPRODUCTCODE=<%=EXCULDEDPRODUCTCODE%>&CustomerId=<%=CustomerId%>&CustomerName=<%=CustomerName%>"+"&StaticLink="+staticLinkValue+"&MinLinks=<%=MinLinks%>&CounterAccountNo=<%=CounterAccountNo%>&CounterAccountGroup=<%=CounterAccountGroup%>";
				}else if(staticLinkValue == "N" && transactionLinkValue == "N"){
					alert("Atleast one should be checked");
					$(this).prop('checked', true);
					var url = "${pageContext.request.contextPath}/common/getEntityLinkedDetailsGraphView?AccountNumber=<%=AccountNumber%>"+"&FromDate=<%=FromDate%>&ToDate=<%=ToDate%>&LevelCount=<%=LevelCount%>"+"&TransactionLink=Y&EXCULDEDPRODUCTCODE=<%=EXCULDEDPRODUCTCODE%>&CustomerId=<%=CustomerId%>&CustomerName=<%=CustomerName%>"+"&StaticLink=N&MinLinks=<%=MinLinks%>&CounterAccountNo=<%=CounterAccountNo%>&CounterAccountGroup=<%=CounterAccountGroup%>";
				}
				if(staticLinkValue == "Y" || transactionLinkValue == "Y"){
					d3.json(url, function(error, flare){
						if(Object.keys(flare).length > 0){
							if (error)
								throw error;
		
							root = flare;
							root.x0 = height / 2;
							root.y0 = 0;
		
							update(root);
							$("#staticLinkChecks").hide();
						}else{
							svg.selectAll("*").remove();
							$("#staticLinkChecks").show();
				 		}
					});
				}		
		 });
	function generateAlert(){
		console.log(selectNodeForAlert);
	}
</script>
<script type="text/javascript">
	$(document).ready(function(){
		 $(document).keydown(function(event){
		        if(event.which=="27"){
		        	hidePosition();
		        }
		 });
		//hiding the dialog box with time period if it is not hovered
		 function hideDataDialogBox(){
		        if($("#flareDataDialogBox").is(":visible")){
			        if($("#flareDataDialogBox").is(':hover')){
			        }else{
			        	$("#flareDataDialogBox").hide();
			        }
		        }
		        myVar = setTimeout(hideDataDialogBox, 2000);
		}
		hideDataDialogBox();
	});
</script>
<div id="flareDataDialogBox">
	<input type="hidden" id="SEARCHACCOUNTNO"/>
	LINKEDNAME : <span id="LINKEDNAME"></span>, LINKEDTYPE : <span class="hyperlink" id="LINKEDTYPE" onclick="openLinkGraphDetails(this, 'LINKTYPE')"></span>, LINKEDACCOUNTNO : <span class="hyperlink" id="LINKEDACCOUNTNO" onclick="openLinkGraphDetails(this, 'ACCOUNT')"></span>, <br/>
	LINKEDCUSTOMERID : <span class="hyperlink" id="LINKEDCUSTOMERID" onclick="openLinkGraphDetails(this, 'CUSTID')"></span>, LINKEDCUSTOMERTYPE : <span id="LINKEDCUSTOMERTYPE"></span>, TRANSACTEDAMOUNT : <span id="TRANSACTEDAMOUNT"></span>, </br>
	TRANSACTEDCOUNT : <span class="hyperlink" id="TRANSACTEDCOUNT" onclick="openLinkGraphDetails(this, 'TXNCOUNT')"></span>, FORCELINK : <span id="FORCELINK"></span>, DUPLICATEVALUE : <span id="DUPLICATEVALUE"></span>, IFEXISTINGTAB : <span id="IFEXISTINGTAB"></span>
</div>

<div class="inlineCheckboxAndButtons sticky">
		<div class="linkCheckbox">
			<div style=position:relative>
				<label id="staticLinkLabel"></label>
				<span style=width:40%;position:absolute;top:22px;border-bottom-width:1px;border-bottom-style:solid;border-bottom-color:grey;></span>
			</div>
			<div>
				<label id="transactionLinkLabel"></label>
				<span style=color:red;>- - - - - - - - - - - - - - - - - - -</span>
			</div>
		</div>
		<!-- <div class="generateButtonDiv">
			<button type="button" class="btn btn-primary btn-sm" onclick="generateAlert()">Generate Alert</button>
		</div> -->
</div>
<div id="d3flare">
	<h1 id="staticLinkChecks" style=margin-left:30%>No data for static link</h1>
</div>


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
