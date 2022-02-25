<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ include file="../../tags/tags.jsp"%>
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
  margin: 0 0 20px 0;
  padding: 0 0 5px 0;
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
  background: #666;
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
  height: 300px;
  width: 40px;
  margin-right: 25px;
}

.vertical .progress-track {
  position: relative;
  width: 40px;
  height: 100%;
  background: #ebebeb;
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
  box-shadow: inset 0 0 5px rgba(0,0,0,.2);
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
						<h2>Horizontal, Rounded</h2>
					  <div class="progress-bar horizontal">
					    <div class="progress-track">
					      <div class="progress-fill">
					        <span>100%</span>
					      </div>
					    </div>
					  </div>
					
					  <div class="progress-bar horizontal">
					    <div class="progress-track">
					      <div class="progress-fill">
					        <span>75%</span>
					      </div>
					    </div>
					  </div>
					
					  <div class="progress-bar horizontal">
					    <div class="progress-track">
					      <div class="progress-fill">
					        <span>60%</span>
					      </div>
					    </div>
					  </div>
					
					  <div class="progress-bar horizontal">
					    <div class="progress-track">
					      <div class="progress-fill">
					        <span>20%</span>
					      </div>
					    </div>
					  </div>
					
					  <div class="progress-bar horizontal">
					    <div class="progress-track">
					      <div class="progress-fill">
					        <span>34%</span>
					      </div>
					    </div>
					  </div>
					
					  <div class="progress-bar horizontal">
					    <div class="progress-track">
					      <div class="progress-fill">
					        <span>82%</span>
					      </div>
					    </div>
					  </div>
					</div>
					</td>
					<td width="10%">&nbsp;</td>
					
					<!-- Horizontal, flat -->
					
					<td width="45%">
						<div class="container horizontal flat">
					  <h2>Horizontal, Flat</h2>
					  <div class="progress-bar horizontal">
					    <div class="progress-track">
					      <div class="progress-fill">
					        <span>100%</span>
					      </div>
					    </div>
					  </div>
					
					  <div class="progress-bar horizontal">
					    <div class="progress-track">
					      <div class="progress-fill">
					        <span>75%</span>
					      </div>
					    </div>
					  </div>
					
					  <div class="progress-bar horizontal">
					    <div class="progress-track">
					      <div class="progress-fill">
					        <span>60%</span>
					      </div>
					    </div>
					  </div>
					
					  <div class="progress-bar horizontal">
					    <div class="progress-track">
					      <div class="progress-fill">
					        <span>20%</span>
					      </div>
					    </div>
					  </div>
					
					  <div class="progress-bar horizontal">
					    <div class="progress-track">
					      <div class="progress-fill">
					        <span>34%</span>
					      </div>
					    </div>
					  </div>
					
					  <div class="progress-bar horizontal">
					    <div class="progress-track">
					      <div class="progress-fill">
					        <span>82%</span>
					      </div>
					    </div>
					  </div>
					</div>
				</td>
				</tr>
				
				<tr>
					<td width="45%">
					<!-- Vertical, rounded -->
					<div class="container vertical rounded">
					  <h2>Vertical, Rounded</h2>
					  <div class="progress-bar">
					    <div class="progress-track">
					      <div class="progress-fill">
					        <span>100%</span>
					      </div>
					    </div>
					  </div>
					
					  <div class="progress-bar">
					    <div class="progress-track">
					      <div class="progress-fill">
					        <span>75%</span>
					      </div>
					    </div>
					  </div>
					
					  <div class="progress-bar">
					    <div class="progress-track">
					      <div class="progress-fill">
					        <span>60%</span>
					      </div>
					    </div>
					  </div>
					
					  <div class="progress-bar">
					    <div class="progress-track">
					      <div class="progress-fill">
					        <span>20%</span>
					      </div>
					    </div>
					  </div>
					
					  <div class="progress-bar">
					    <div class="progress-track">
					      <div class="progress-fill">
					        <span>34%</span>
					      </div>
					    </div>
					  </div>
					
					  <div class="progress-bar">
					    <div class="progress-track">
					      <div class="progress-fill">
					        <span>82%</span>
					      </div>
					    </div>
					  </div>
					</div>
					</td>
					<td width="10%">&nbsp;</td>
					<td width="45%">
					<!-- Vertical, flat -->
					<div class="container vertical flat">
					  <h2>Vertical, Flat</h2>
					  <div class="progress-bar">
					    <div class="progress-track">
					      <div class="progress-fill">
					        <span>100%</span>
					      </div>
					    </div>
					  </div>
					
					  <div class="progress-bar">
					    <div class="progress-track">
					      <div class="progress-fill">
					        <span>75%</span>
					      </div>
					    </div>
					  </div>
					
					  <div class="progress-bar">
					    <div class="progress-track">
					      <div class="progress-fill">
					        <span>60%</span>
					      </div>
					    </div>
					  </div>
					
					  <div class="progress-bar">
					    <div class="progress-track">
					      <div class="progress-fill">
					        <span>20%</span>
					      </div>
					    </div>
					  </div>
					
					  <div class="progress-bar">
					    <div class="progress-track">
					      <div class="progress-fill">
					        <span>34%</span>
					      </div>
					    </div>
					  </div>
					
					  <div class="progress-bar">
					    <div class="progress-track">
					      <div class="progress-fill">
					        <span>82%</span>
					      </div>
					    </div>
					  </div>
					</div>
				</td>
				</tr>
			</table>
	</div>
</div>

