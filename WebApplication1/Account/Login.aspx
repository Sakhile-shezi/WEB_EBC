<%@ Page Title="EastBoom Clinical Management System - Log in" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="WebApplication1.Account.Login" Async="true" %>
<%@ Register Src="~/Account/OpenAuthProviders.ascx" TagPrefix="uc" TagName="OpenAuthProviders" %>

<asp:Content runat="server" ID="BodyContent" ContentPlaceHolderID="MainContent">
<style>
/* Scoped styling: does not change Site.Master or other pages. */
.eb-login {
    --forest:#142e23;
    --forest-mid:#20523a;
    --forest-light:#2d7650;
    --primary:#176a4c;
    --ink:#20372f;
    --muted:#6d8078;
    --line:#dfe9e3;
    font-family:"Segoe UI",Arial,sans-serif;
    background:#f5f8f6;
    color:var(--ink);
    min-height:calc(100vh - 130px);
    padding:48px 22px 65px;
}
.eb-login *, .eb-login *::before, .eb-login *::after {box-sizing:border-box;}
.eb-login-shell {max-width:1090px; margin:0 auto; display:grid; grid-template-columns:minmax(0,.96fr) minmax(0,1fr); border:1px solid #dce6df; background:#fff; border-radius:22px; overflow:hidden; box-shadow:0 20px 60px rgba(22,57,41,.09),0 4px 12px rgba(22,57,41,.035); min-height:610px;}
.eb-login-brand {position:relative; isolation:isolate; overflow:hidden; display:flex; flex-direction:column; justify-content:space-between; padding:47px 46px; color:#fff; background:linear-gradient(135deg,var(--forest) 4%,var(--forest-mid) 62%,var(--forest-light) 115%);}
.eb-login-brand::before {content:""; position:absolute; inset:auto -150px -215px auto; width:460px; height:460px; border:1px solid rgba(255,255,255,.14); border-radius:50%; box-shadow:0 0 0 55px rgba(255,255,255,.035),0 0 0 118px rgba(255,255,255,.025); z-index:-1; pointer-events:none;}
.eb-login-brand::after {content:""; position:absolute; width:260px; height:260px; top:-170px; left:-120px; border:1px solid rgba(255,255,255,.12); border-radius:50%; z-index:-1; pointer-events:none;}
.eb-login-brandtag {display:inline-flex; align-self:flex-start; max-width:100%; padding:9px 14px; border-radius:30px; background:rgba(255,255,255,.13); border:1px solid rgba(255,255,255,.08); text-transform:uppercase; letter-spacing:.07em; font-size:10px; font-weight:750; line-height:1.5;}
.eb-login-brandcenter {padding:55px 0 45px;}
.eb-login-brandmark {width:58px; height:58px; display:grid; place-items:center; background:rgba(255,255,255,.13); border:1px solid rgba(255,255,255,.20); border-radius:17px; margin-bottom:29px; box-shadow:0 10px 24px rgba(0,0,0,.08);}
.eb-login-brandmark svg {width:31px; height:31px; stroke:#fff;}
.eb-login-brand h1 {color:#fff; font-size:clamp(28px,3vw,39px); font-weight:750; letter-spacing:-.035em; line-height:1.15; margin:0 0 17px;}
.eb-login-brand p {font-size:14px; line-height:1.85; color:#d5e9de; max-width:340px; margin:0;}
.eb-login-brandfoot {border-top:1px solid rgba(255,255,255,.17); padding-top:19px; font-size:11px; color:#c5e0d1; letter-spacing:.02em;}
.eb-login-formpanel {display:flex; align-items:center; justify-content:center; padding:52px clamp(25px,5vw,66px);}
.eb-login-forminner {width:100%; max-width:410px;}
.eb-login-eyebrow {margin:0 0 9px; text-transform:uppercase; color:#187356; font-size:11px; font-weight:800; letter-spacing:.12em;}
.eb-login-forminner h2 {font-size:30px; font-weight:750; letter-spacing:-.035em; color:#20372f; margin:0 0 10px;}
.eb-login-intro {font-size:13px; color:#71827b; line-height:1.6; margin:0 0 31px;}
.eb-login-field {margin-bottom:20px;}
.eb-login-label {display:block; font-size:12px; font-weight:700; color:#33483e; margin-bottom:9px;}
.eb-login .eb-login-input {display:block; width:100%; min-height:48px; padding:12px 14px; color:#213a30; background:#fff; border:1px solid #d8e4dc; border-radius:9px; font-family:inherit; font-size:14px; outline:none; box-shadow:none; transition:border-color .18s ease,box-shadow .18s ease;}
.eb-login .eb-login-input:focus {border-color:#318d66; box-shadow:0 0 0 3px rgba(36,127,84,.12);}
.eb-login .eb-login-input::placeholder {color:#9aaba0;}
.eb-login-passwordwrap {position:relative;}
.eb-login .eb-login-passwordwrap .eb-login-input {padding-right:70px;}
.eb-login-eye {position:absolute; right:9px; top:50%; transform:translateY(-50%); border:0; background:transparent; color:#22694c; font-size:12px; font-weight:700; cursor:pointer; border-radius:5px; padding:8px 7px;}
.eb-login-eye:hover, .eb-login-eye:focus-visible {background:#eaf5ee; outline:none;}
.eb-login-error {display:block; margin-top:7px; color:#b73535; font-size:12px; line-height:1.5;}
.eb-login-alert {background:#fff1ef; border:1px solid #f5c8c1; color:#982f2d; border-radius:9px; padding:13px 15px; margin-bottom:22px; font-size:13px; line-height:1.6;}
.eb-login-remember {display:flex; align-items:center; gap:8px; font-size:12px; color:#62756a; margin:4px 0 24px;}
.eb-login-remember input {accent-color:#176a4c; width:15px; height:15px; margin:0;}
.eb-login-remember label {margin:0; cursor:pointer;}
.eb-login .eb-login-submit {display:block; width:100%; border:1px solid #176a4c; background:#176a4c; color:white; border-radius:10px; min-height:48px; font-family:inherit; font-size:14px; font-weight:750; cursor:pointer; box-shadow:0 5px 14px rgba(23,106,76,.17); transition:transform .18s ease,background .18s ease,box-shadow .18s ease;}
.eb-login .eb-login-submit:hover {background:#10543b; transform:translateY(-1px); box-shadow:0 9px 18px rgba(23,106,76,.2);}
.eb-login .eb-login-submit:focus-visible {outline:3px solid rgba(23,106,76,.28); outline-offset:3px;}
.eb-login-register {text-align:center; font-size:13px; color:#6d8078; margin:26px 0 0;}
.eb-login-register a {color:#176a4c!important; font-weight:750; text-decoration:none!important;}
.eb-login-register a:hover {text-decoration:underline!important;}
.eb-login-privacy {display:flex; align-items:center; justify-content:center; gap:7px; margin-top:28px; color:#84968a; font-size:11px; text-align:center;}
.eb-login-privacy svg {width:14px; height:14px; flex:none;}
.eb-login-social {margin-top:19px;}
.eb-login-social:empty {display:none;}
@media(max-width:850px){.eb-login-shell {grid-template-columns:1fr; max-width:560px;} .eb-login-brand {padding:29px 30px;} .eb-login-brandcenter {padding:22px 0 14px;} .eb-login-brandmark {display:none;} .eb-login-brand h1 {font-size:28px; margin-bottom:9px;} .eb-login-brand p {font-size:12px;} .eb-login-brandfoot {display:none;} .eb-login-formpanel {padding:38px 35px 44px;}}
@media(max-width:520px){.eb-login {padding:20px 12px 35px; min-height:auto;} .eb-login-shell {border-radius:15px;} .eb-login-brand {padding:24px 23px;} .eb-login-brand h1 {font-size:25px;} .eb-login-formpanel {padding:31px 22px 36px;} .eb-login-forminner h2 {font-size:26px;}}
@media(prefers-reduced-motion:reduce){.eb-login *, .eb-login *::before, .eb-login *::after {transition:none!important; animation:none!important;}}

/* Clear system identity above the login panel */
.eb-login-system-header {max-width:1090px;margin:0 auto 23px;display:flex;align-items:center;gap:15px;}
.eb-login-system-symbol {width:47px;height:47px;border-radius:13px;display:grid;place-items:center;flex:none;color:#fff;background:linear-gradient(145deg,#142e23,#2d7650);box-shadow:0 7px 16px rgba(20,70,44,.16);}
.eb-login-system-symbol svg {width:25px;height:25px;stroke:currentColor;}
.eb-login-system-name {margin:0;color:#193c2d;font-size:clamp(19px,2.4vw,26px);font-weight:780;letter-spacing:-.025em;line-height:1.2;}
.eb-login-system-subtitle {margin:5px 0 0;color:#688274;font-size:12px;}
.eb-login-brand-system {display:block;color:#fff;font-size:clamp(27px,3vw,37px);font-weight:760;line-height:1.17;letter-spacing:-.03em;margin:0 0 16px;}
.eb-login-brand-description {margin-top:6px!important;}
@media(max-width:520px){.eb-login-system-header{gap:11px;margin-bottom:17px}.eb-login-system-symbol{width:40px;height:40px}.eb-login-system-name{font-size:20px}}
</style>

<main class="eb-login" aria-labelledby="ebLoginTitle">
  <header class="eb-login-system-header" aria-label="Application name">
    <span class="eb-login-system-symbol" aria-hidden="true">
      <svg viewBox="0 0 24 24" fill="none" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
        <path d="M12 3v18M3 12h18" />
      </svg>
    </span>
    <div>
      <p class="eb-login-system-name">EastBoom Clinical Management System</p>
      <p class="eb-login-system-subtitle">Eastboom Clinic &middot; Secure healthcare portal</p>
    </div>
  </header>
  <div class="eb-login-shell">
    <section class="eb-login-brand" aria-label="Eastboom Clinic patient portal">
      <div class="eb-login-brandtag">Pietermaritzburg Health Services</div>
      <div class="eb-login-brandcenter">
        <div class="eb-login-brandmark" aria-hidden="true">
          <svg viewBox="0 0 24 24" fill="none" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
            <path d="M12 3v18M3 12h18" />
            <path d="M5 5l3 3M19 19l-3-3M19 5l-3 3M5 19l3-3" opacity=".5" />
          </svg>
        </div>
        <h1 class="eb-login-brand-system">EastBoom Clinical<br />Management System</h1>
        <p class="eb-login-brand-description">Healthcare made more accessible. Securely access your account, manage appointments and stay connected to your care.</p>
      </div>
      <div class="eb-login-brandfoot">EASTBOOM CLINIC &nbsp; / &nbsp; PATIENT SERVICES</div>
    </section>

    <section class="eb-login-formpanel" id="loginForm" aria-labelledby="ebLoginTitle">
      <div class="eb-login-forminner">
        <p class="eb-login-eyebrow">Patient portal</p>
        <h2 id="ebLoginTitle">Welcome back</h2>
        <p class="eb-login-intro">Sign in with your registered email address and password to continue.</p>

        <asp:PlaceHolder runat="server" ID="ErrorMessage" Visible="false">
          <div class="eb-login-alert" role="alert">
            <asp:Literal runat="server" ID="FailureText" Mode="Encode" />
          </div>
        </asp:PlaceHolder>

        <div class="eb-login-field">
          <asp:Label runat="server" AssociatedControlID="Email" CssClass="eb-login-label">Email address</asp:Label>
          <asp:TextBox runat="server" ID="Email" CssClass="eb-login-input" TextMode="Email" placeholder="name@example.com" autocomplete="username" />
          <asp:RequiredFieldValidator runat="server" ControlToValidate="Email" CssClass="eb-login-error" Display="Dynamic" ErrorMessage="The email field is required." />
        </div>

        <div class="eb-login-field">
          <asp:Label runat="server" AssociatedControlID="Password" CssClass="eb-login-label">Password</asp:Label>
          <div class="eb-login-passwordwrap">
            <asp:TextBox runat="server" ID="Password" TextMode="Password" CssClass="eb-login-input" placeholder="Enter your password" autocomplete="current-password" />
            <button type="button" id="ebToggleLoginPassword" class="eb-login-eye" aria-label="Show password" aria-pressed="false">Show</button>
          </div>
          <asp:RequiredFieldValidator runat="server" ControlToValidate="Password" CssClass="eb-login-error" Display="Dynamic" ErrorMessage="The password field is required." />
        </div>

        <div class="eb-login-remember">
          <asp:CheckBox runat="server" ID="RememberMe" Text="Remember me" />
        </div>

        <asp:Button runat="server" OnClick="LogIn" Text="Log in securely" CssClass="eb-login-submit" />

        <p class="eb-login-register">New to Eastboom Clinic? <asp:HyperLink runat="server" ID="RegisterHyperLink" ViewStateMode="Disabled">Create an account</asp:HyperLink></p>

        <%-- Optional: add your ForgotPasswordHyperLink here once password reset is enabled. --%>
        <div class="eb-login-privacy">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><rect x="5" y="10" width="14" height="11" rx="2"/><path d="M8 10V7a4 4 0 0 1 8 0v3"/></svg>
          Secure access to your patient account
        </div>
        <div class="eb-login-social" id="socialLoginForm">
          <uc:OpenAuthProviders runat="server" ID="OpenAuthLogin" />
        </div>
      </div>
    </section>
  </div>
</main>

<script type="text/javascript">
    (function () {
        function initLoginPage() {
            var field = document.getElementById('<%= Password.ClientID %>');
            var toggle = document.getElementById('ebToggleLoginPassword');
            if (!field || !toggle || toggle.getAttribute('data-ready') === 'true') return;
            toggle.setAttribute('data-ready', 'true');
            toggle.addEventListener('click', function () {
                var show = field.type === 'password';
                field.type = show ? 'text' : 'password';
                toggle.textContent = show ? 'Hide' : 'Show';
                toggle.setAttribute('aria-pressed', show ? 'true' : 'false');
                toggle.setAttribute('aria-label', show ? 'Hide password' : 'Show password');
            });
        }
        if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', initLoginPage);
        else initLoginPage();
        if (window.Sys && window.Sys.Application) window.Sys.Application.add_load(initLoginPage);
    })();
</script>
</asp:Content>
