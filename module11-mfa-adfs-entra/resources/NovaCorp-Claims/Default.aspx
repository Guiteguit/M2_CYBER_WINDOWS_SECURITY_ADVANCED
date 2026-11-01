<%@ Page Language="C#" %>
<%@ Import Namespace="System.Security.Claims" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <meta charset="utf-8" />
    <title>NovaCorp Claims Portal</title>
    <style>
        body { font-family: Segoe UI, Arial; background: #10141c; color: #e6edf3; margin: 40px; }
        .container { max-width: 1100px; margin: auto; }
        .card { background: #161b22; border: 1px solid #30363d; border-radius: 10px; padding: 25px; margin-bottom: 20px; }
        h1, th { color: #58a6ff; }
        table { width: 100%; border-collapse: collapse; }
        th, td { text-align: left; padding: 10px; border-bottom: 1px solid #30363d; }
        code { color: #7ee787; }
    </style>
</head>
<body>
<div class="container">
<h1>NovaCorp Claims Portal</h1>

<div class="card">
<h2>Utilisateur authentifié</h2>
<%
ClaimsPrincipal principal = System.Threading.Thread.CurrentPrincipal as ClaimsPrincipal;
if (principal != null && principal.Identity != null && principal.Identity.IsAuthenticated) {
%>
<p>Utilisateur : <code><%= Server.HtmlEncode(principal.Identity.Name) %></code></p>
<p>Méthode : <code><%= Server.HtmlEncode(principal.Identity.AuthenticationType) %></code></p>
<% } else { %>
<p>Utilisateur non authentifié.</p>
<% } %>
</div>

<div class="card">
<h2>Claims reçus d'AD FS</h2>
<table>
<tr><th>Type</th><th>Valeur</th><th>Issuer</th></tr>
<%
if (principal != null) {
    foreach (Claim claim in principal.Claims) {
%>
<tr>
<td><%= Server.HtmlEncode(claim.Type) %></td>
<td><%= Server.HtmlEncode(claim.Value) %></td>
<td><%= Server.HtmlEncode(claim.Issuer) %></td>
</tr>
<% }} %>
</table>
</div>
</div>
</body>
</html>
