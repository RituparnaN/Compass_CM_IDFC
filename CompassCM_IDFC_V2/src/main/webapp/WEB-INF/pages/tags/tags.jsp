<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="f" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<c:set var="dirL" value=""/>
<c:set var="dirR" value=""/>
<c:choose>
	<c:when test="${sessionScope.LABELDIR == 'rtl'}">
		<c:set var="dirL" value="${'right'}"/>
		<c:set var="dirR" value="${'left'}"/>
	</c:when>
	<c:otherwise>
		<c:set var="dirL" value="${'left'}"/>
		<c:set var="dirR" value="${'right'}"/>
	</c:otherwise>
</c:choose>
<c:set var="label" value="${sessionScope['LANG']}"/>