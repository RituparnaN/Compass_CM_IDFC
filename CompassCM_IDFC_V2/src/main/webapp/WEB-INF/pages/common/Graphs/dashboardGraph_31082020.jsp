<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ include file="../../tags/tags.jsp"%>
<script type="text/javascript">
$(document).ready(function(){
	Pizza.init();
	bars();
});
</script>
<!--PIE CHART-->
<div class="row">
	<div class="col-sm-4">
		<div class="card card-primary" >
			<div class="card-header">Customer Risk Rating</div>
			<div id="customerRiskGraph" style="height: 350px;"></div>
			<ul data-pie-id="customerRiskGraph" class="compassDataGraphs">
				<c:forEach var="customerRiskGraph" items="${CUSTOMERRISKGRAPH}">
					<li data-value="${customerRiskGraph['percentage']}">${customerRiskGraph['name']} : ${customerRiskGraph['value']}</li>
				</c:forEach>
		  	</ul>
		</div>		
	</div>
	<div class="col-sm-4">
		<div class="card card-primary" >
			<div class="card-header">Account Risk Rating</div>
			<div id="accountRiskGraph" style="height: 350px;"></div>
			<ul data-pie-id="accountRiskGraph" class="compassDataGraphs">
				<c:forEach var="accountRiskGraph" items="${ACCOUNTRISKGRAPH}">
					<li data-value="${accountRiskGraph['percentage']}">${accountRiskGraph['name']} : ${accountRiskGraph['value']}</li>
				</c:forEach>
		  	</ul>
		</div>
	</div>
	<div class="col-sm-4">
		<div class="card card-primary" >
			<div class="card-header">Alert Statistics</div>
			<div id="alertStatistics" style="height: 350px;"></div>
			<ul data-pie-id="alertStatistics" class="compassDataGraphs">
				<c:forEach var="alertStatistics" items="${ALERTSTATISTICS}">
					<li data-value="${alertStatistics['percentage']}">${alertStatistics['name']} : ${alertStatistics['value']}</li>
				</c:forEach>
		  	</ul>
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
