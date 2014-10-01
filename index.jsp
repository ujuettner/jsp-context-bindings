<%@ page language="java" import="javax.naming.*, java.sql.*,javax.sql.*" %>

<%
  StringBuffer output = new StringBuffer();
  Context initCtx = new InitialContext();
  String ctxName = "java:comp/env";
  int bindingsIndex = 0;
  DataSource ds = null;
  Connection con = null;
  Statement stmt = null;
  ResultSet rs = null;

  output.append("{\n  \"" + ctxName + "\": {");
  NamingEnumeration<Binding> ctxBindings = initCtx.listBindings(ctxName);
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
  output.append("\n  },\n");

  output.append("{\n \"databases\": [");
  try {
    ds = (DataSource) initCtx.lookup("java:comp/env/jdbc/mydb");
    con = ds.getConnection();
    stmt = con.createStatement();
    rs = stmt.executeQuery("show databases");
    String separator = "";
    while (rs.next()) {
      output.append(separator);
      separator = ", ";
      output.append("\"" + rs.getString(1) + "\"");
    }
  }
  catch (Exception e) {
  }
  finally {
    output.append("]\n  }\n}");
    try {
      if (rs != null) {
        rs.close();
      }
      if (stmt != null) {
        stmt.close();
      }
      if (con != null) {
        con.close();
      }
    }
    catch (Exception e) {
    }
  }
%>
<%= output.toString() %>

