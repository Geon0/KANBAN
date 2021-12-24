<%@ include file="/jspf/head.xml.jsp" %>
<registry>
	<properties>
		<id>
			<hidden component="HiddenFieldEditor" parent="null" id="id"/>
			<search>
				<header label="<fmt:message key="doc.098"/>" search="id"/>
			</search>
		</id>
		<title>
			<write component="TextFieldEditor" focus="true">
				<header label="<fmt:message key="doc.001"/>" required="true"/>
				<style maxLength="55"/>
			</write>
		</title>
		<content>
			<write component="ComboFieldEditor" id="category">
				<header label="<kfmt:message key="pd.card.039"/>"/>
				<style ajaxOptions="/jsl/KbItemOwner.ReadCategory.json?id=@{id}&amp;mdId=@{mdId}&amp;csId=@{csId}&amp;appId=@{appId}&amp;spId=@{spId}"/>
			</write>
		</content>
		<rgstUser>
			<read component="EmpHtmlViewer">
				<header label="<fmt:message key="doc.003"/>"/>
				<style vrtl="<fmt:message key="sys.vrtl.userId"/>"/>
			</read>
			<write component="EmpFieldEditor" id="rgstUser">
				<header label="<fmt:message key="hrm.004"/>" required="true"/>
				<style width="150px" imgAdd="<fmt:message key="btn.pub.search_small"/>"/>
			</write>
		</rgstUser>
	</properties>
</registry>
<%@ include file="/jspf/tail.xml.jsp" %>