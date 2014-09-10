<%@ page language="java" import="javax.naming.InitialContext, javax.naming.NamingEnumeration, javax.naming.Binding" %>

<%
  StringBuffer output = new StringBuffer();
  String ctxName = "java:comp/env";
  int bindingsIndex = 0;

  output.append("{\n  \"" + ctxName + "\": {");
  NamingEnumeration<Binding> ctxBindings = new InitialContext().listBindings(ctxName);
  while (ctxBindings.hasMore()) {
    if (bindingsIndex == 0) {
      output.append("\n");
      bindingsIndex++;
    } else {
      output.append(",\n");
    }
    Binding ctxBinding = ctxBindings.next();
    String ctxBindingName = ctxBinding.getName();
    Object ctxBindingObject = ctxBinding.getObject();
    output.append("    \"" + ctxBindingName + "\": \""  + ctxBindingObject.toString().replace("\"","\\\"") + "\"");
  }
  output.append("\n  }\n}");
%>
<%= output.toString() %>

