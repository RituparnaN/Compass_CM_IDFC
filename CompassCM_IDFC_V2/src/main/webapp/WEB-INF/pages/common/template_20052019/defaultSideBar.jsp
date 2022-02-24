<%@ page language="java" contentType="text/html;charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../../tags/tags.jsp"%>
<div class="navbar-default sidebar" role="navigation" >
	<div class="sidebar-nav navbar-collapse collapse">
		<ul class="nav" id="compassSideBar">
			<li>
				<a href="javascript:void(0)" onclick="navigate('Dashboard','dashboard','','0')"> Dashboard </a>
			</li>
			<c:forEach var="ALLMODULES" items="${MODULES}">
			<c:forEach var="MODULES"  items="${ALLMODULES.value}" >
				<c:if test="${MODULES.key eq 'MAINMODULE'}">
					<c:set var="MAINMODULES" value="${MODULES.value}"/>
				</c:if>
				<c:if test="${MODULES.key eq 'SUBMODULE'}">
					<c:set var="SUBMODULES" value="${MODULES.value}"/>
				</c:if>
			</c:forEach>
			<c:forEach var="MAIN" items="${MAINMODULES}">
				<c:set var="MAINMODULE" value="${MAIN.value}"/>
			</c:forEach>
				
				<li>
						<a href="javascript:void(0)" <c:if test='${f:length(SUBMODULES) == 0 }'> onclick="navigate('${MAINMODULE['MODULENAME']}','${MAINMODULE['MODULECODE']}','${MAINMODULE['MODULEURL']}','${MAINMODULE['ISMULTIPLE']}')"</c:if> >  ${MAINMODULE['MODULENAME']}
							<c:if test="${f:length(SUBMODULES) > 0 }">
								<span class="fa arrow"></span>
							</c:if>				
						</a>
						<c:if test="${f:length(SUBMODULES) > 0 }">
							<ul class="nav nav-second-level">
								<c:forEach var="SUB" items="${SUBMODULES}">
								<c:set var="SUBMODULE" value="${SUB.value}"/>
									<li><a href="javascript:void(0)" onclick="navigate('${SUBMODULE['MODULENAME']}','${SUBMODULE['MODULECODE']}','${SUBMODULE['MODULEURL']}','${SUBMODULE['ISMULTIPLE']}')">${SUBMODULE['MODULENAME']}</a></li>
								</c:forEach>
							</ul>
						</c:if>
					</li>
				 
				<c:set var="MAINMODULES" value=""/>
				<c:set var="SUBMODULES" value=""/>
				<c:set var="MAINITEMS" value=""/>
				<c:set var="SUBMITEMS" value=""/>
		</c:forEach>
		</ul>
	</div>
</div>