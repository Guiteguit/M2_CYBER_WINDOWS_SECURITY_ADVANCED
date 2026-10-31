<%@ Language="VBScript" %>
<%
Option Explicit
Response.Buffer = True

Dim user, authType, serverName, serverSoftware, serverTime
user = Request.ServerVariables("LOGON_USER")
authType = Request.ServerVariables("AUTH_TYPE")
serverName = Request.ServerVariables("SERVER_NAME")
serverSoftware = Request.ServerVariables("SERVER_SOFTWARE")
serverTime = Now()

If Len(user) = 0 Then user = "Utilisateur non transmis"
If Len(authType) = 0 Then authType = "Non disponible"
If Len(serverName) = 0 Then serverName = "Non disponible"
If Len(serverSoftware) = 0 Then serverSoftware = "Microsoft IIS"
%>
<!doctype html>
<html lang="fr">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>NovaCorp — Intranet sécurisé</title>
  <style>
    :root {
      color-scheme: dark;
      --bg: #09111f;
      --panel: #111c2e;
      --panel2: #17243a;
      --text: #edf4ff;
      --muted: #9eb0c8;
      --accent: #70b7ff;
      --ok: #8be2b0;
      --border: rgba(255,255,255,.10);
    }
    * { box-sizing: border-box; }
    body {
      margin: 0;
      min-height: 100vh;
      font-family: Segoe UI, Inter, Arial, sans-serif;
      background: radial-gradient(circle at top right, #17345d 0, var(--bg) 42%);
      color: var(--text);
      display: grid;
      place-items: center;
      padding: 32px;
    }
    main { width: min(900px, 100%); }
    .brand {
      font-weight: 800;
      letter-spacing: .06em;
      color: var(--accent);
      margin-bottom: 10px;
    }
    h1 { font-size: clamp(2rem, 4vw, 3.3rem); margin: 0 0 10px; }
    .lead { color: var(--muted); font-size: 1.05rem; margin-bottom: 28px; }
    .status {
      display: inline-flex;
      gap: 8px;
      align-items: center;
      padding: 8px 12px;
      border: 1px solid var(--border);
      border-radius: 999px;
      background: rgba(17,28,46,.72);
      color: var(--ok);
      margin-bottom: 22px;
    }
    .dot { width: 9px; height: 9px; border-radius: 50%; background: var(--ok); }
    .grid {
      display: grid;
      grid-template-columns: repeat(2, minmax(0,1fr));
      gap: 14px;
    }
    .card {
      background: linear-gradient(145deg, var(--panel), var(--panel2));
      border: 1px solid var(--border);
      border-radius: 16px;
      padding: 20px;
      box-shadow: 0 12px 35px rgba(0,0,0,.18);
    }
    .label { color: var(--muted); font-size: .82rem; text-transform: uppercase; letter-spacing: .08em; }
    .value { margin-top: 7px; font-size: 1.08rem; word-break: break-word; }
    footer { margin-top: 20px; color: var(--muted); font-size: .85rem; }
    code { color: var(--accent); }
    @media (max-width: 650px) { .grid { grid-template-columns: 1fr; } }
  </style>
</head>
<body>
<main>
  <div class="brand">NOVACORP</div>
  <h1>Intranet sécurisé</h1>
  <p class="lead">IIS · TLS · Windows Authentication · gMSA · Kerberos</p>

  <div class="status"><span class="dot"></span> Session Windows authentifiée</div>

  <section class="grid">
    <article class="card">
      <div class="label">Utilisateur Active Directory</div>
      <div class="value"><%= Server.HTMLEncode(user) %></div>
    </article>
    <article class="card">
      <div class="label">Authentification IIS</div>
      <div class="value"><%= Server.HTMLEncode(authType) %></div>
    </article>
    <article class="card">
      <div class="label">Serveur Web</div>
      <div class="value"><%= Server.HTMLEncode(serverName) %></div>
    </article>
    <article class="card">
      <div class="label">Heure serveur</div>
      <div class="value"><%= Server.HTMLEncode(CStr(serverTime)) %></div>
    </article>
  </section>

  <footer>
    <div>Serveur : <%= Server.HTMLEncode(serverSoftware) %></div>
    <div>Attention : <code>AUTH_TYPE</code> ne prouve pas à lui seul l'utilisation de Kerberos.</div>
  </footer>
</main>
</body>
</html>
