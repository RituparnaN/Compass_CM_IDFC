<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../../tags/tags.jsp"%>
<c:set var="authSignCount" value="${f:length(AUTHORIZEDSIGNATORIES)}"/>
<c:set var="LABELSITRCOUNT" value="0" scope="page"/>
<table class="table table-striped" style="margin-bottom: 0px;">
	<tr>
		<td colspan="3" style="text-align: center;">
			<button type="button" class="btn btn-primary btn-sm" onclick="loadIdentificationForm('${COMPASSREFERENCENO}', '${LINENO}')">Reload</button>
		</td>
	</tr>
	<tr>
		<td style="text-align: center;">
			Identification Form for Customer
		</td>
		<td colspan="2">
			<c:choose>
			 	<c:when test="${f:length(FORMDATA['CUSTOMERNAME']) > 0}">
			 		<button class="btn btn-primary btn-sm" entityType="MAINCUST" lineNo="${FORMDATA['LINENO']}" 
			 		compassRefNo="${FORMDATA['COMPASSREFNO']}" onclick="openIDF(this)" formLineNo="${LINENO}">
			 			${FORMDATA['CUSTOMERNAME']}
			 		</button> 
			 	</c:when>
			 	<c:otherwise>
			 		Enter Customer Name in CDD Form and reload Identification Form Page
			 	</c:otherwise>
			 </c:choose>
		</td>
	</tr>
	<tr>
		<td style="text-align: center;">
			Account Opening Kyogi - Current Account
		</td>
		<td colspan="2">
			<c:choose>
			 	<c:when test="${KYOGICA eq '0'}">
			 		<button class="btn btn-primary btn-sm" kyogiFor="CA" formLineNo="${LINENO}" compassRefNo="${COMPASSREFERENCENO}" onclick="createAFA(this)">
			 			Create New
			 		</button>
			 	</c:when>
			 	<c:otherwise>
			 		<button class="btn btn-success btn-sm" kyogiFor="CA" formLineNo="${LINENO}" compassRefNo="${COMPASSREFERENCENO}" onclick="openAFA(this)">
			 			Open
			 		</button>
			 	</c:otherwise>
			 </c:choose>
		</td>
	</tr>
		<td style="text-align: center;">
			Account Opening Kyogi - Saving Account
		</td>
		<td colspan="2">
			<c:choose>
			 	<c:when test="${KYOGISA eq '0'}">
			 		<button class="btn btn-primary btn-sm" kyogiFor="SA" formLineNo="${LINENO}" compassRefNo="${COMPASSREFERENCENO}" onclick="createAFA(this)">
			 			Create New
			 		</button>
			 	</c:when>
			 	<c:otherwise>
			 		<button class="btn btn-success btn-sm" kyogiFor="SA" formLineNo="${LINENO}" compassRefNo="${COMPASSREFERENCENO}" onclick="openAFA(this)">
			 			Open
			 		</button>
			 	</c:otherwise>
			 </c:choose>
		</td>
	</tr>
	<c:if test="${authSignCount gt 0}">
		<tr>
			<td style="text-align: center;" colspan="3">Identification Form Authorized Signatories </td>
		</tr>
		<c:forEach var="AUTHSIGN" items="${AUTHORIZEDSIGNATORIES}">
			<c:choose>
				<c:when test="${LABELSITRCOUNT % 3 == 0}">
					<tr>
						<td style="text-align: center;">
							<button class="btn btn-primary btn-sm" entityType="AUTHSIGN" lineNo="${AUTHSIGN['LINENO']}" 
							compassRefNo="${AUTHSIGN['COMPASSREFNO']}" onclick="openIDF(this)" formLineNo="${LINENO}">${AUTHSIGN['NAME']}</button>
						</td>
				</c:when>
				<c:when test="${LABELSITRCOUNT % 3 == 1}">
						<td style="text-align: center;">
							<button class="btn btn-primary btn-sm" entityType="AUTHSIGN" lineNo="${AUTHSIGN['LINENO']}" 
							compassRefNo="${AUTHSIGN['COMPASSREFNO']}" onclick="openIDF(this)" formLineNo="${LINENO}">${AUTHSIGN['NAME']}</button>
						</td>
				</c:when>
				<c:otherwise>
						<td style="text-align: center;">
							<button class="btn btn-primary btn-sm" entityType="AUTHSIGN" lineNo="${AUTHSIGN['LINENO']}" 
							compassRefNo="${AUTHSIGN['COMPASSREFNO']}" onclick="openIDF(this)" formLineNo="${LINENO}">${AUTHSIGN['NAME']}</button>
						</td>
					</tr>
				</c:otherwise>
			</c:choose>
			<c:set var="LABELSITRCOUNT" value="${LABELSITRCOUNT + 1}" scope="page"/>
		</c:forEach>
		<c:if test="${LABELSITRCOUNT % 3 == 1}">
				<td>&nbsp;</td>
				<td>&nbsp;</td>
			</tr>
		</c:if>
		<c:if test="${LABELSITRCOUNT % 3 == 2}">
				<td>&nbsp;</td>
			</tr>
		</c:if>
	</c:if>
</table>