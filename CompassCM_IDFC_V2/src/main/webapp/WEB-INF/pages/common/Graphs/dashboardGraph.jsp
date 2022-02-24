<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ include file="../../tags/tags.jsp"%>
<!--PIE CHART-->
<div class="row">
	<div class="col-sm-4">
		<div class="card card-primary" style="height:450px;" >
			<div class="card-header">Customer Risk Rating</div>
			<div style="padding: 30px 60px 80px 60px;" ><canvas  id="customerRiskGraph" style="height:50px;width:50px;"></canvas ></div>
		</div>		
	</div>
	<div class="col-sm-4">
		<div class="card card-primary" style="height:450px;">
			<div class="card-header">Account Risk Rating</div>
			<div style="padding: 30px 60px 80px 60px;"><canvas id="accountRiskGraph" style="height: 50px;width:50px;"></canvas></div>
			<%-- <ul data-pie-id="accountRiskGraph" class="compassDataGraphs">
				<c:forEach var="accountRiskGraph" items="${ACCOUNTRISKGRAPH}">
					<li data-value="${accountRiskGraph['percentage']}">${accountRiskGraph['name']} : ${accountRiskGraph['value']}</li>
				</c:forEach>
		  	</ul> --%>
		</div>
	</div>
	<div class="col-sm-4">
		<div class="card card-primary" style="height:450px;">
			<div class="card-header">Alert Statistics</div>
			<div style="padding: 30px 50px 80px 50px;"><canvas id="alertStatistics" style="height: 50px;width:50px;"></canvas></div>
			<%-- <ul data-pie-id="alertStatistics" class="compassDataGraphs">
				<c:forEach var="alertStatistics" items="${ALERTSTATISTICS}">
					<li data-value="${alertStatistics['percentage']}">${alertStatistics['name']} : ${alertStatistics['value']}</li>
				</c:forEach>
		  	</ul> --%>
		</div>
	</div>
</div>
	
<!-- HORIZONTAL BAR -->
<div class="row">
	<div class="col-sm-12">
		<div class="card card-primary" >
			<div class="card-header">TopMost Generated Alert Scenarios</div>
				<div class="bar_group" style=" margin: 5px 25px 5px 10px;">
				    <c:forEach var="nTopMostAlerts" items="${NTOPMOSTALERTS}" varStatus = "loop" >
					    <c:if test="${(loop.index eq '0')}">
					        <div style="margin-bottom: 5px;" class='bar_group__bar thick elastic c_red' tooltip="true" label="${nTopMostAlerts['ALERTCODE']}" value="${nTopMostAlerts['ALERTSCOUNT']}"></div>
                        </c:if>
					    <c:if test="${(loop.index eq '1')}">
					        <div class='bar_group__bar thick elastic c_orange' tooltip="true" label="${nTopMostAlerts['ALERTCODE']}" value="${nTopMostAlerts['ALERTSCOUNT']}"></div>
                        </c:if>
					    <c:if test="${(loop.index eq '2')}">
					        <div class='bar_group__bar thick elastic c_yellow' tooltip="true" label="${nTopMostAlerts['ALERTCODE']}" value="${nTopMostAlerts['ALERTSCOUNT']}"></div>
                        </c:if>
					    <c:if test="${(loop.index eq '3')}">
					        <div class='bar_group__bar thick elastic c_green' tooltip="true" label="${nTopMostAlerts['ALERTCODE']}" value="${nTopMostAlerts['ALERTSCOUNT']}"></div>
                        </c:if>
					    <c:if test="${(loop.index eq '4')}">
					        <div class='bar_group__bar thick elastic c_blue' tooltip="true" label="${nTopMostAlerts['ALERTCODE']}" value="${nTopMostAlerts['ALERTSCOUNT']}"></div>
                        </c:if>
					    <c:if test="${(loop.index eq '5')}">
					        <div class='bar_group__bar thick elastic c_indigo' tooltip="true" label="${nTopMostAlerts['ALERTCODE']}" value="${nTopMostAlerts['ALERTSCOUNT']}"></div>
                        </c:if>
					    <c:if test="${(loop.index eq '6')}">
					        <div class='bar_group__bar thick elastic c_violet' tooltip="true" label="${nTopMostAlerts['ALERTCODE']}" value="${nTopMostAlerts['ALERTSCOUNT']}"></div>
                        </c:if>
 				    </c:forEach>
					<!--
					<div style="margin-bottom: 5px;" class='bar_group__bar thick elastic c_red' tooltip="true" label="OFL_IBA_HGH_VOLUME_CSH_WDL_MONTHLY" value='490'></div>
					<div class='bar_group__bar thick elastic c_orange' tooltip="true" label="OFL_IBA_HGH_VALUE_NONCSH_DEP_MONTHLY"  value='391'></div>
					<div class='bar_group__bar thick elastic c_yellow' tooltip="true" label="OFL_IBA_HGH_VALUE_NONCSH_WDL_MONTHLY" value='380'></div>
					<div class='bar_group__bar thick elastic c_green' tooltip="true" label="OFL_IBA_HGH_VOLUME_NONCSH_WDL_MONTHLY" value='227'></div>
					<div class='bar_group__bar thick elastic c_blue' tooltip="true" label="OFL_IBA_HGH_VOLUME_NONCSH_DEP_MONTHLY" value='197'></div>
					<div class='bar_group__bar thick elastic c_indigo' tooltip="true" label="OFL_IBA_HGH_VALUE_CSH_WDL_MONTHLY" value='141'></div>
					<div class='bar_group__bar thick elastic c_violet' tooltip="true" label="OFL_IBA_HGH_VALUE_CSH_DEP_MONTHLY" value='132'></div>
					-->
				</div>
		</div>		
	</div>
</div>
<script type="text/javascript">
$(document).ready(function(){
	Pizza.init();
	bars();
	let customerRiskGraphsDetails = {};
	customerRiskGraphsDetails["DATA"] = [];//[0,0,50];
	customerRiskGraphsDetails["LABELS"] = [];//["High: 0","Medium: 0","Low: 50"];
	customerRiskGraphsDetails["PERCENTAGE"] = [];
	 <c:forEach var="customerRiskGraph" items="${CUSTOMERRISKGRAPH}">
		customerRiskGraphsDetails["DATA"].push(parseInt("${customerRiskGraph.value}"));  
		customerRiskGraphsDetails["LABELS"].push("${customerRiskGraph.name}"+" : "+"${customerRiskGraph.value}");
		//customerRiskGraphsDetails["LABELS"].push("${customerRiskGraph.name}");
		customerRiskGraphsDetails["PERCENTAGE"].push("${customerRiskGraph.percentage}");
	</c:forEach> 
	
	var customerRiskRatinggraphChart = document.getElementById("customerRiskGraph").getContext("2d");
	new Chart(customerRiskRatinggraphChart, {
	    type: 'pie',
	    data: {
	      labels:customerRiskGraphsDetails["LABELS"],
	      datasets: [{
	        label: "Rating",
	        backgroundColor: ["#0080ff", "#e8c3b9",  "#adea38", "#c45850"],
	        data: customerRiskGraphsDetails["DATA"]
	      }]
	    },
	    options: {
	    	responsive:true,
	        tooltips: {
	        	callbacks: {
	                title: function(tooltipItem, data) {
	                  return customerRiskGraphsDetails["LABELS"][tooltipItem[0]['index']];;
	                },
	                label: function(tooltipItem, data) {
	                  return customerRiskGraphsDetails["DATA"][tooltipItem['index']];
	                },
	                afterLabel: function(tooltipItem, data) {
	                  var percent = customerRiskGraphsDetails["PERCENTAGE"][tooltipItem['index']];
	                  console.log(percent);
	                  return '(' + percent + '%)';
	                }
	              },
	       },
	       legend: {
	            display: true,
	            position:'bottom',
	        }/* ,
	        layout: {
	            padding: {
	                left: 30,
	                right: 30,
	                top: 40,
	                bottom: 20
	            }
	        } */
	    	
	    }
	});
	
//------------------------------------------------------------------------------------------
let accountrRiskGraphsDetails = {};
accountrRiskGraphsDetails["DATA"] = [];//[0,0,50];
accountrRiskGraphsDetails["LABELS"] = [];//["High: 0","Medium: 0","Low: 50"];
accountrRiskGraphsDetails["PERCENTAGE"] = [];
<c:forEach var="accountRiskGraph" items="${ACCOUNTRISKGRAPH}">
	 accountrRiskGraphsDetails["DATA"].push(parseInt("${accountRiskGraph.value}"));  
	 accountrRiskGraphsDetails["LABELS"].push("${accountRiskGraph.name}"+" : "+"${accountRiskGraph.value}");
	 accountrRiskGraphsDetails["PERCENTAGE"].push("${accountRiskGraph.percentage}");
</c:forEach> 

var accountrRiskGraphsDetailsChart = document.getElementById("accountRiskGraph").getContext("2d");
new Chart(accountrRiskGraphsDetailsChart, {
    type: 'pie',
    data: {
      labels:accountrRiskGraphsDetails["LABELS"],
      datasets: [{
        label: "Rating",
        backgroundColor: ["#0080ff", "#e8c3b9",  "#adea38", "#c45850"],
        data: accountrRiskGraphsDetails["DATA"]
      }]
    },
    options: {
    	responsive:true,
        tooltips: {
        	callbacks: {
                title: function(tooltipItem, data) {
                  return accountrRiskGraphsDetails["LABELS"][tooltipItem[0]['index']];;
                },
                label: function(tooltipItem, data) {
                  return accountrRiskGraphsDetails["DATA"][tooltipItem['index']];
                },
                afterLabel: function(tooltipItem, data) {
                  var percent = accountrRiskGraphsDetails["PERCENTAGE"][tooltipItem['index']];
                  //console.log(percent);
                  return '(' + percent + '%)';
                }
              },
       },
       legend: {
            display: true,
            position:'bottom',
        }/* ,
        layout: {
            padding: {
                left: 30,
                right: 30,
                top: 40,
                bottom: 20
            }
        } */
    	
    }
});
	
//------------------------------------------------------------------------------------------	
	
	let alertStatsGraphsDetails = {};
	alertStatsGraphsDetails["DATA"] = [];
	alertStatsGraphsDetails["LABELS"] = [];
	alertStatsGraphsDetails["PERCENTAGE"] = [];
	<c:forEach var="alertStatistics" items="${ALERTSTATISTICS}">
		alertStatsGraphsDetails["DATA"].push(parseInt("${alertStatistics.value}"));  
		alertStatsGraphsDetails["LABELS"].push("${alertStatistics.name}"+" : "+"${alertStatistics.value}");
		alertStatsGraphsDetails["PERCENTAGE"].push("${alertStatistics.percentage}");
	</c:forEach>
	
	var alertStatsgraphChart = document.getElementById("alertStatistics").getContext("2d");
	new Chart(alertStatsgraphChart, {
	    type: 'pie',
	    data: {
	      labels:alertStatsGraphsDetails["LABELS"],
	      datasets: [{
	        label: "Rating",
	        backgroundColor: ["#0080ff", "#e8c3b9",  "#adea38", "#c45850"],
	        data: alertStatsGraphsDetails["DATA"]
	      }]
	    },
	    options: {
	    	responsive:true,
	        tooltips: {
	        	callbacks: {
	                title: function(tooltipItem, data) {
	                  return alertStatsGraphsDetails["LABELS"][tooltipItem[0]['index']];;
	                },
	                label: function(tooltipItem, data) {
	                  return alertStatsGraphsDetails["DATA"][tooltipItem['index']];
	                },
	                afterLabel: function(tooltipItem, data) {
	                  var percent = alertStatsGraphsDetails["PERCENTAGE"][tooltipItem['index']];
	                  console.log(percent);
	                  return '(' + percent + '%)';
	                }
	              },
	       },
	       legend: {
	            display: true,
	            position:'bottom',
	        }/* ,
	        layout: {
	            padding: {
	                left: 30,
	                right: 30,
	                top: 40,
	                bottom: 20
	            }
	        } */
	    	
	    }
	});
});
</script>
