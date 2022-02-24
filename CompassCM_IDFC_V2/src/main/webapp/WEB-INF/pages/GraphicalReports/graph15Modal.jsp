<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ include file="../tags/tags.jsp"%>
<script type="text/javascript">
$(document).ready(function(){
	$('.horizontal .progress-fill span').each(function(){
	  var percent = $(this).html();
	  $(this).parent().css('width', percent);
	});
	
	
	$('.vertical .progress-fill span').each(function(){
	  var percent = $(this).html();
	  var pTop = 100 - ( percent.slice(0, percent.length - 1) ) + "%";
	  $(this).parent().css({
	    'height' : percent,
	    'top' : pTop
	  });
	});
});
</script>
<style>

*, *:before, *:after {
  -moz-box-sizing: border-box; -webkit-box-sizing: border-box; box-sizing: border-box;
 }

body {
  background: #999;
}

h2 {
  margin: 0 0 5px 0;
  padding: 0 0 1px 0;
  border-bottom: 1px solid #999;
  font-family: sans-serif;
  font-weight: normal;
  color: #333;
}

.container {
  width: 500px;
  margin: 20px;
  background: #fff;
  padding: 20px;
  overflow: hidden;
  float: left;
}

.horizontal .progress-bar {
  float: left;
  height: 45px;
  width: 100%;
  padding: 12px 0;
}

.horizontal .progress-track {
  position: relative;
  width: 100%;
  height: 20px;
  background: #ebebeb;
}

.horizontal .progress-fill {
  position: relative;
  background: #126;
  height: 20px;
  width: 50%;
  color: #fff;
  text-align: center;
  font-family: "Lato","Verdana",sans-serif;
  font-size: 12px;
  line-height: 20px;
}

.rounded .progress-track,
.rounded .progress-fill {
  border-radius: 3px;
  box-shadow: inset 0 0 5px rgba(0,0,0,.2);
}



/* Vertical */

.vertical .progress-bar {
  float: left;
  height: 330px;
  width: 40px;
  margin-right: 25px;
}

.vertical .progress-track {
  position: relative;
  width: 40px;
  height: 100%;
  background: #e12ef1;
}

.vertical .progress-fill {
  position: relative;
  background: #825;
  height: 50%;
  width: 40px;
  color: #fff;
  text-align: center;
  font-family: "Lato","Verdana",sans-serif;
  font-size: 12px;
  line-height: 20px;
}

.rounded .progress-track,
.rounded .progress-fill {
  box-shadow: inset 0 0 1px rgba(0,0,0,.2);
  border-radius: 3px;
}
</style>

<!-- Horizontal, rounded -->
<div class="row">
	<div class="col-sm-12">
		<div class="table">
			<table>
				<tr>
					<td width="45%">
					<div class="container horizontal rounded">
						<h2>Hourly Breakup Report</h2>
					  <div class="progress-bar horizontal">Between 12-4 AM
					    <div class="progress-track">
					      <div class="progress-fill"> 
					        <span>3%</span>
					      </div>
					    </div>
					  </div>
					
					  <div class="progress-bar horizontal">Between 4-8 AM
					    <div class="progress-track">
					      <div class="progress-fill">
					        <span>2%</span>
					      </div>
					    </div>
					  </div>
					
					  <div class="progress-bar horizontal">Between 8AM - 12 PM
					    <div class="progress-track">
					      <div class="progress-fill">
					        <span>40%</span>
					      </div>
					    </div>
					  </div>
					
					  <div class="progress-bar horizontal">Between 12-4 PM
					    <div class="progress-track">
					      <div class="progress-fill">
					        <span>25%</span>
					      </div>
					    </div>
					  </div>
					
					  <div class="progress-bar horizontal">Between 4-8 PM
					    <div class="progress-track">
					      <div class="progress-fill">
					        <span>10%</span>
					      </div>
					    </div>
					  </div>
					
					  <div class="progress-bar horizontal">Between 8-12 PM
					    <div class="progress-track">
					      <div class="progress-fill">
					        <span>20%</span>
					      </div>
					    </div>
					  </div>
					</div>
					</td>
					<td width="10%">&nbsp;</td>
					
					<!-- Horizontal, flat -->
					
					<td width="45%">
						<div class="container horizontal flat">
					  <h2>Distant Profiled Report</h2>
					  <div class="progress-bar horizontal">Between 1-100 KM 
					    <div class="progress-track">
					      <div class="progress-fill">
					        <span>55%</span>
					      </div>
					    </div>
					  </div>
					
					  <div class="progress-bar horizontal">Between 100-500 KM
					    <div class="progress-track">
					      <div class="progress-fill">
					        <span>20%</span>
					      </div>
					    </div>
					  </div>
					
					  <div class="progress-bar horizontal">More Than 500 KM
					    <div class="progress-track">
					      <div class="progress-fill">
					        <span>10%</span>
					      </div>
					    </div>
					  </div>
					
					  <div class="progress-bar horizontal">Neighbours Country
					    <div class="progress-track">
					      <div class="progress-fill">
					        <span>11%</span>
					      </div>
					    </div>
					  </div>
					
					  <div class="progress-bar horizontal">Others Country
					    <div class="progress-track">
					      <div class="progress-fill">
					        <span>4%</span>
					      </div>
					    </div>
					  </div>
					  <!-- 	
					  <div class="progress-bar horizontal">
					    <div class="progress-track">
					      <div class="progress-fill">
					        <span>82%</span>
					      </div>
					    </div>
					  </div>
					   -->
					</div>
				</td>
				</tr>
				
				<tr>
					<td width="45%">
					<!-- Vertical, rounded -->
					<div class="container vertical rounded">
					  <h2>card Transactions Profiled Report</h2>
					  <div class="progress-bar">Own ATM
					    <div class="progress-track">
					      <div class="progress-fill">
					        <span>63%</span>
					      </div>
					    </div>
					  </div>
					
					  <div class="progress-bar">Others ATM
					    <div class="progress-track">
					      <div class="progress-fill">
					        <span>37%</span>
					      </div>
					    </div>
					  </div>
					
					  <div class="progress-bar">12-6 AM Txns
					    <div class="progress-track">
					      <div class="progress-fill">
					        <span>3.01%</span>
					      </div>
					    </div>
					  </div>
					
					  <div class="progress-bar">Distanct ATM
					    <div class="progress-track">
					      <div class="progress-fill">
					        <span>57%</span>
					      </div>
					    </div>
					  </div>
					
					  <div class="progress-bar">POS vs Others
					    <div class="progress-track">
					      <div class="progress-fill">
					        <span>52%</span>
					      </div>
					    </div>
					  </div>
					
					  <div class="progress-bar">Risky MCC Txns
					    <div class="progress-track">
					      <div class="progress-fill">
					        <span>17%</span>
					      </div>
					    </div>
					  </div>
					</div>
					</td>
					<td width="10%">&nbsp;</td>
					<td width="45%">
					<!-- Vertical, flat -->
					<div class="container vertical flat">
					  <h2>Transfer Transactions Profile</h2>
					  <div class="progress-bar">Own Bank
					    <div class="progress-track">
					      <div class="progress-fill">
					        <span>34%</span>
					      </div>
					    </div>
					  </div>
					
					  <div class="progress-bar">
					    <div class="progress-track">Other Bank
					      <div class="progress-fill">
					        <span>66%</span>
					      </div>
					    </div>
					  </div>
					
					  <div class="progress-bar">
					    <div class="progress-track">Other Country
					      <div class="progress-fill">
					        <span>14%</span>
					      </div>
					    </div>
					  </div>
					
					  <div class="progress-bar">
					    <div class="progress-track">Credits
					      <div class="progress-fill">
					        <span>37%</span>
					      </div>
					    </div>
					  </div>
					
					  <div class="progress-bar">
					    <div class="progress-track">Debits
					      <div class="progress-fill">
					        <span>63%</span>
					      </div>
					    </div>
					  </div>
					
					</div>
				</td>
				</tr>
			</table>
	</div>
</div>

