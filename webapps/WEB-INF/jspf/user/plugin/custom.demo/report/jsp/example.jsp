<%@ page import="java.util.Enumeration"%>

<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/WEB-INF/jspf/taglibs.jsp"%>

<div class="center1020">
	<%--
	Переменная form - объект класса ru.bgcrm.struts.form.DynActionForm, содержащий параметры запроса.
	--%>
	<c:set var="date" value="${form.getParamDate('date')}"/>
	<c:set var="groups" value="${form.getParamValues('group')}"/>
	<c:set var="executors" value="${form.getParamValues('executor')}"/>
	<c:set var="processTypeIds" value="${form.getParamValues('type')}" scope="request"/>
	<c:set var="listParamIds" value="${form.getParamValues('listParam')}"/>

	<html:form action="/user/empty">
		<input type="hidden" name="forwardFile" value="${form.forwardFile}"/>

		<div class="mb1">Примеры элементов интерфейса доступны <a onclick="$$.shell.contentLoad('/user/demo'); return false;" href="/user/demo">здесь</a>.</div>
		<div class="mb1">
			В качестве справочников вы можете использовать <a href="https://bgerp.org/version/3.0/javadoc/ru/bgcrm/servlet/filter/SetRequestParamsFilter.html#getContextVariables">переменные</a>, установленные из request.<br/><br/>
		</div>

		Дата закрытия:
		<ui:date-time paramName="date" value="0"/>

		<!-- пример фильтра по параметру типа list, 31 - заменить на код параметра -->
		<c:set var="listParam" value="${ctxParameterMap[u:int(31)]}"/>
		<ui:combo-check
			list="${listParam.listParamValues}" values="${listParamIds}"
			prefixText="List:" widthTextValue="12em"
			showFilter="1" paramName="listParam"/>

		<ui:combo-check
			styleClass="ml05"
			list="${ctxUserGroupList}" values="${groups}"
			prefixText="Группы:" widthTextValue="12em"
			showFilter="1" paramName="group"/>

		<%-- фильтр по исполнителям не связан с фильтром по группам, просто весь список пользователей
			 пример связки можно изучить в user/process/queue/filter_executor.jsp --%>
		<ui:combo-check
			styleClass="ml05"
			list="${ctxUserList}" values="${executors}"
			prefixText="Исполнители:" widthTextValue="12em"
			showFilter="1" paramName="executor"/>

		<br/>

		Типы:
		<c:set var="treeId" value="${u:uiid()}"/>
		<ul id="${treeId}" style="display: block; height: 25em; overflow: auto;">
			<c:forEach var="node" items="${ctxProcessTypeTreeRoot.children}">
				<c:set var="node" value="${node}" scope="request"/>
				<jsp:include page="/WEB-INF/jspf/admin/process/process_type_check_tree_item.jsp"/>
			</c:forEach>
		</ul>

		<script>
			$(function () {
				$("#${treeId}").Tree();
			});
		</script>

		<button type="button"  class="btn-grey ml1 mt05" onclick="$$.ajax.load(this.form, $(this.form).parent())">Сформировать</button>
	</html:form>

	<%--
	Генерация отчёта, если в запросе пришёл параметр date.
	--%>
	<c:if test="${not empty date}">
		<%-- в случае, если Slave база не настроена - будет использована обычная --%>
		<sql:query var="result" dataSource="${ctxSlaveDataSource}">
			SELECT process.id, process.description, status.title, DATE_FORMAT(process.create_dt, '%Y-%m-%d %H.%i.%s'), DATE_FORMAT(process.close_dt, '%Y-%m-%d %H.%i.%s')
			FROM process
			LEFT JOIN process_status_title AS status ON process.status_id=status.id
			<c:if test="${not empty groups}">
				INNER JOIN process_group AS pg ON process.id=pg.process_id AND pg.group_id IN (${u.toString(groups)})
			</c:if>
			<c:if test="${not empty executors}">
				INNER JOIN process_executor AS pe ON process.id=pe.process_id AND pe.user_id IN (${u.toString(executors)})
			</c:if>
			<c:if test="${not empty listParamIds}">
				INNER JOIN param_list AS pl ON process.id=pl.id AND pl.param_id=${listParam.id} AND pl.value IN (${u.toString(listParamIds)})
			</c:if>
			WHERE close_dt>=? AND close_dt<DATE_ADD(?, INTERVAL 1 DAY)
			<c:if test="${not empty processTypeIds}">
				 AND type_id IN (${u.toString(processTypeIds)})
			</c:if>
			ORDER BY process.id

			<sql:param value="${date}"/>
			<sql:param value="${date}"/>
		</sql:query>

		<table class="data mt1 hl">
			<tr>
				<td>ID</td>
				<td>${l.l('Description')}</td>
				<td>${l.l('Status')}</td>
				<td>${l.l('Created')}</td>
				<td>${l.l('process.closed')}</td>
			</tr>

			<c:forEach var="row" items="${result.rowsByIndex}">
				<c:set var="id" value="${row[0]}"/>
				<c:set var="description" value="${row[1]}"/>
				<c:set var="status" value="${row[2]}"/>
				<c:set var="createTime" value="${row[3]}"/>
				<c:set var="closeTime" value="${row[4]}"/>

				<tr>
					<td><a href="#" onclick="$$.process.open(${id}); return false;">${id}</a></td>
					<td>${description}</td>
					<td>${status}</td>
					<td>${createTime}</td>
					<td>${closeTime}</td>
				</tr>
			</c:forEach>
		</table>
	</c:if>
</div>