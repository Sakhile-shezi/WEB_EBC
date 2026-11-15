<%@ Page Title="Contact Us - East Boom CHC" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Contact.aspx.cs" Inherits="WebApplication1.Contact" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
<style>
/* All styles stay inside this Contact page; Site.Master is unchanged. */
.eb-contact {
    --eb-dark:#103d31; --eb-green:#197b56; --eb-mint:#e9f6ee;
    --eb-lime:#cef397; --eb-ink:#163c2e; --eb-muted:#6b8173;
    --eb-border:#deebe2; color:var(--eb-ink); width:100%;
    font-family:'Segoe UI',Arial,sans-serif; margin:4px auto 30px;
}
.eb-contact,.eb-contact *,.eb-contact *::before,.eb-contact *::after {box-sizing:border-box;}
.eb-contact h1,.eb-contact h2,.eb-contact h3,.eb-contact p {margin-top:0;}
.eb-contact a {text-decoration:none;}
.eb-contact a:focus-visible,.eb-contact summary:focus-visible {outline:3px solid #d1a44b;outline-offset:3px;}
.eb-contact .ebc-icon {display:inline-block;width:22px;height:22px;fill:none;stroke:currentColor;stroke-width:1.9;stroke-linecap:round;stroke-linejoin:round;flex:0 0 auto;}
.eb-contact .ebc-symbols {width:0;height:0;position:absolute;overflow:hidden;}
.eb-contact .ebc-tag {display:inline-flex;gap:9px;align-items:center;color:#2a8962;font-size:10px;font-weight:900;letter-spacing:1.7px;text-transform:uppercase;}
.eb-contact .ebc-tag::before {content:"";height:2px;width:25px;border-radius:20px;background:#89c99d;}
.eb-contact .ebc-heading {font-size:clamp(28px,3vw,40px);font-weight:800;letter-spacing:-1.35px;line-height:1.2;margin:12px 0 13px;}
.eb-contact .ebc-heading em {font-style:normal;color:var(--eb-green);}
.eb-contact .ebc-description {font-size:13px;line-height:1.85;color:var(--eb-muted);max-width:620px;}
.eb-contact .ebc-button {display:inline-flex;gap:11px;align-items:center;justify-content:center;padding:13px 20px;min-height:48px;border-radius:12px;font-weight:800;font-size:12px;transition:transform .2s ease,box-shadow .2s ease,background .2s ease;}
.eb-contact .ebc-button:hover {transform:translateY(-3px);}
.eb-contact .ebc-button .ebc-icon {height:17px;width:17px;}
.eb-contact .ebc-button-lime {background:var(--eb-lime);color:#173c2d;}
.eb-contact .ebc-button-lime:hover {background:#dcffae;color:#173c2d;box-shadow:0 14px 24px rgba(0,30,20,.2);}
.eb-contact .ebc-button-ghost {background:rgba(255,255,255,.09);color:#fff;border:1px solid rgba(239,255,239,.44);}
.eb-contact .ebc-button-ghost:hover {background:rgba(255,255,255,.18);color:#fff;}
.eb-contact .ebc-button-green {background:#1b7956;color:#fff;}
.eb-contact .ebc-button-green:hover {background:#115c42;color:#fff;}

/* PHOTO-LED INTRODUCTION */
.eb-contact .ebc-hero {overflow:hidden;position:relative;isolation:isolate;display:grid;grid-template-columns:1fr .92fr;min-height:435px;border-radius:25px;background:linear-gradient(130deg,#103d31 0%,#125a43 100%);box-shadow:0 22px 52px rgba(13,59,36,.13);}
.eb-contact .ebc-hero::before {content:"";position:absolute;inset:auto auto -220px -130px;width:440px;height:440px;border:1px solid rgba(201,248,210,.17);border-radius:50%;box-shadow:0 0 0 68px rgba(200,244,212,.027),0 0 0 140px rgba(200,244,212,.025);pointer-events:none;}
.eb-contact .ebc-hero-text {position:relative;z-index:2;display:flex;flex-direction:column;justify-content:center;align-items:flex-start;padding:55px 24px 67px 59px;}
.eb-contact .ebc-hero-pill {display:inline-flex;align-items:center;gap:8px;border-radius:50px;padding:9px 13px;border:1px solid rgba(211,255,213,.35);background:rgba(255,255,255,.07);font-size:10px;letter-spacing:1px;font-weight:900;text-transform:uppercase;color:#dff4e3;}
.eb-contact .ebc-spark {height:8px;width:8px;background:var(--eb-lime);border-radius:50%;box-shadow:0 0 0 5px rgba(206,243,151,.13);}
.eb-contact .ebc-hero h1 {font-size:clamp(38px,4.1vw,57px);line-height:1.11;letter-spacing:-1.8px;color:#fff;font-weight:800;margin:23px 0 18px;max-width:550px;}
.eb-contact .ebc-hero h1 em {font-style:normal;color:var(--eb-lime);}
.eb-contact .ebc-hero-text>p {color:#d9e9df;line-height:1.83;font-size:13.5px;margin:0 0 27px;max-width:460px;}
.eb-contact .ebc-hero-actions {display:flex;flex-wrap:wrap;gap:11px;}
.eb-contact .ebc-hero-photo {position:relative;min-height:435px;overflow:hidden;border-radius:135px 0 0 135px;background:#b4d5be;}
.eb-contact .ebc-hero-photo img {position:absolute;inset:0;display:block;width:100%;height:100%;object-fit:cover;object-position:center;animation:ebc-zoom 11s ease-in-out alternate infinite;}
.eb-contact .ebc-hero-photo::after {content:"";position:absolute;inset:0;background:linear-gradient(180deg,transparent 48%,rgba(11,48,31,.48));pointer-events:none;}
.eb-contact .ebc-photo-caption {position:absolute;z-index:2;bottom:25px;left:27px;right:24px;padding:14px 16px;border-radius:13px;background:rgba(255,255,255,.95);box-shadow:0 16px 35px rgba(0,30,16,.15);animation:ebc-float 5s ease-in-out infinite;}
.eb-contact .ebc-photo-caption strong {display:block;color:#14402c;font-size:13px;}
.eb-contact .ebc-photo-caption small {display:block;color:#6a8175;font-size:10.5px;margin-top:5px;}

/* CONTENT + THREE IMMEDIATE CONTACT CARDS */
.eb-contact .ebc-body {background:linear-gradient(180deg,#f5faf6 0%,#fff 33%,#f5faf7 100%);border:1px solid var(--eb-border);border-radius:0 0 25px 25px;padding:0 37px 34px;}
.eb-contact .ebc-cards {position:relative;z-index:3;display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:14px;margin:-35px 0 73px;}
.eb-contact .ebc-card {padding:23px 20px;background:#fff;border:1px solid #e1ece4;border-radius:17px;box-shadow:0 15px 34px rgba(22,64,43,.10);transition:transform .24s,box-shadow .24s;}
.eb-contact .ebc-card:hover {transform:translateY(-5px);box-shadow:0 22px 37px rgba(22,64,43,.14);}
.eb-contact .ebc-card-icon {display:grid;place-items:center;width:45px;height:45px;background:#e6f5e9;color:#168151;border-radius:13px;margin-bottom:17px;}
.eb-contact .ebc-card h3 {font-size:15px;line-height:1.3;font-weight:800;margin:0 0 9px;}
.eb-contact .ebc-card p,.eb-contact .ebc-card address {font-size:11.8px;font-style:normal;line-height:1.75;color:#698171;margin:0;}
.eb-contact .ebc-card a {color:#147b50;font-size:11.8px;font-weight:800;overflow-wrap:anywhere;}
.eb-contact .ebc-card a:hover {text-decoration:underline;}
.eb-contact .ebc-card small {display:block;margin-top:7px;font-size:10px;line-height:1.55;color:#8a998c;}

/* MAP + VISITING INFO */
.eb-contact .ebc-section-heading {margin-bottom:22px;}
.eb-contact .ebc-map-section {padding:0 3px 68px;}
.eb-contact .ebc-map-layout {display:grid;grid-template-columns:1.3fr .7fr;gap:19px;align-items:stretch;}
.eb-contact .ebc-map-frame {position:relative;min-height:438px;overflow:hidden;border-radius:22px;background:#dcece0;box-shadow:0 13px 30px rgba(19,80,44,.08);border:1px solid #dbe8df;}
.eb-contact .ebc-map-frame iframe {border:0;display:block;width:100%;height:100%;min-height:438px;}
.eb-contact .ebc-map-tag {position:absolute;pointer-events:none;left:18px;top:18px;z-index:1;background:rgba(255,255,255,.97);padding:10px 14px;border-radius:12px;color:#15583b;font-size:11px;font-weight:800;box-shadow:0 10px 25px rgba(20,73,38,.14);}
.eb-contact .ebc-visit-panel {background:linear-gradient(145deg,#ebf7ef,#f9fdf9);border:1px solid #dcece1;border-radius:22px;padding:27px 24px;display:flex;flex-direction:column;}
.eb-contact .ebc-visit-panel h3 {font-size:19px;font-weight:800;line-height:1.28;margin:13px 0 17px;}
.eb-contact .ebc-visit-row {display:flex;align-items:flex-start;gap:11px;padding:15px 0;border-top:1px solid #dcebe0;}
.eb-contact .ebc-visit-row:first-of-type {border-top:0;}
.eb-contact .ebc-visit-row .ebc-icon {color:#178556;width:19px;height:19px;margin-top:2px;}
.eb-contact .ebc-visit-row strong {font-size:12px;color:#205340;display:block;margin-bottom:4px;}
.eb-contact .ebc-visit-row p {margin:0;font-size:11.5px;line-height:1.7;color:#6b8274;}
.eb-contact .ebc-visit-panel .ebc-button {margin-top:auto;align-self:flex-start;}

/* VERIFIED PHONE NOTICE / E-MAIL CHOICE */
.eb-contact .ebc-notice {display:flex;align-items:flex-start;gap:15px;border-radius:16px;padding:18px 21px;margin:0 3px 66px;background:#fff8e8;border:1px solid #f1dfb5;}
.eb-contact .ebc-notice-icon {width:33px;height:33px;flex:0 0 33px;border-radius:10px;background:#fbe9ba;color:#886012;display:grid;place-items:center;}
.eb-contact .ebc-notice strong {display:block;font-size:12px;color:#60481b;margin-bottom:5px;}
.eb-contact .ebc-notice p {font-size:11.6px;line-height:1.73;color:#806c49;margin:0;}
.eb-contact .ebc-notice a {color:#6f511d;font-weight:800;text-decoration:underline;}
.eb-contact .ebc-methods {padding:0 3px 66px;}
.eb-contact .ebc-method-grid {display:grid;grid-template-columns:1fr 1fr;gap:16px;}
.eb-contact .ebc-method {background:#fff;border:1px solid var(--eb-border);border-radius:20px;padding:28px 25px;transition:transform .24s,box-shadow .24s;}
.eb-contact .ebc-method:hover {transform:translateY(-5px);box-shadow:0 17px 29px rgba(21,71,42,.085);}
.eb-contact .ebc-method .ebc-card-icon {margin-bottom:17px;}
.eb-contact .ebc-method h3 {font-size:18px;margin:0 0 9px;font-weight:800;}
.eb-contact .ebc-method p {font-size:12px;color:#6d8376;line-height:1.78;margin:0 0 16px;}
.eb-contact .ebc-method a.ebc-contact-address {font-size:14px;color:#177e55;font-weight:800;overflow-wrap:anywhere;}
.eb-contact .ebc-method .ebc-secondary {font-size:10.5px;color:#91a094;line-height:1.6;margin:12px 0 0;}
.eb-contact .ebc-number {font-size:16px;font-weight:800;color:#194b35;display:block;margin:9px 0;}

/* EXTRA HELP AND FINAL CTA */
.eb-contact .ebc-help {display:grid;grid-template-columns:.83fr 1.17fr;gap:43px;padding:0 3px 67px;}
.eb-contact .ebc-help-list {border-top:1px solid #dce9df;}
.eb-contact .ebc-help-list details {border-bottom:1px solid #dce9df;}
.eb-contact .ebc-help-list summary {cursor:pointer;position:relative;font-size:12.5px;font-weight:800;color:#20513b;padding:18px 38px 18px 0;list-style:none;}
.eb-contact .ebc-help-list summary::-webkit-details-marker {display:none;}
.eb-contact .ebc-help-list summary::after {content:"+";position:absolute;right:3px;top:12px;width:27px;height:27px;border-radius:50%;background:#e5f3e8;color:#287e56;display:grid;place-items:center;font-size:19px;}
.eb-contact .ebc-help-list details[open] summary::after {content:"−";}
.eb-contact .ebc-help-list p {font-size:11.8px;line-height:1.85;color:#708579;padding:0 30px 17px 0;margin:0;}
.eb-contact .ebc-ending {background:linear-gradient(120deg,#104231,#176849);border-radius:22px;padding:32px 37px;display:flex;align-items:center;justify-content:space-between;gap:25px;}
.eb-contact .ebc-ending h2 {font-size:26px;letter-spacing:-.6px;font-weight:800;margin:0 0 9px;color:#fff;}
.eb-contact .ebc-ending p {font-size:12px;line-height:1.7;color:#d4ebdb;margin:0;}
.eb-contact .ebc-source {padding:20px 10px 0;text-align:center;font-size:10px;line-height:1.7;color:#889c8d;}
.eb-contact .ebc-source a {color:#267b51;text-decoration:underline;}
.eb-contact.ebc-motion .ebc-reveal {opacity:0;transform:translateY(20px);transition:opacity .7s ease,transform .7s ease;}
.eb-contact.ebc-motion .ebc-reveal.ebc-visible {opacity:1;transform:none;}
@keyframes ebc-zoom {from{transform:scale(1)}to{transform:scale(1.07)}}
@keyframes ebc-float {0%,100%{transform:translateY(0)}50%{transform:translateY(-7px)}}
@media(max-width:950px) {
    .eb-contact .ebc-hero-text {padding-left:35px;}
    .eb-contact .ebc-map-layout {grid-template-columns:1fr;}
    .eb-contact .ebc-map-frame {min-height:360px;}
    .eb-contact .ebc-map-frame iframe {min-height:360px;}
    .eb-contact .ebc-visit-panel .ebc-button {margin-top:12px;}
}
@media(max-width:760px) {
    .eb-contact .ebc-hero {grid-template-columns:1fr;}
    .eb-contact .ebc-hero-text {padding:45px 30px 38px;}
    .eb-contact .ebc-hero-photo {min-height:310px;border-radius:100px 100px 0 0;}
    .eb-contact .ebc-hero-photo img {max-height:370px;}
    .eb-contact .ebc-body {padding:0 19px 25px;}
    .eb-contact .ebc-cards {grid-template-columns:1fr 1fr;gap:12px;margin-bottom:52px;}
    .eb-contact .ebc-card:last-child {grid-column:span 2;}
    .eb-contact .ebc-method-grid {grid-template-columns:1fr;}
    .eb-contact .ebc-help {grid-template-columns:1fr;gap:16px;}
}
@media(max-width:520px) {
    .eb-contact .ebc-hero {border-radius:18px;}
    .eb-contact .ebc-hero-text {padding:33px 21px 28px;}
    .eb-contact .ebc-hero h1 {font-size:38px;letter-spacing:-1.1px;}
    .eb-contact .ebc-hero-photo {min-height:250px;max-height:270px;border-radius:70px 70px 0 0;}
    .eb-contact .ebc-photo-caption {left:13px;right:13px;bottom:13px;}
    .eb-contact .ebc-body {padding:0 13px 25px;}
    .eb-contact .ebc-cards {grid-template-columns:1fr;gap:10px;margin-top:12px;margin-bottom:48px;}
    .eb-contact .ebc-card:last-child {grid-column:auto;}
    .eb-contact .ebc-card {padding:19px;}
    .eb-contact .ebc-map-section,.eb-contact .ebc-methods,.eb-contact .ebc-help {padding-bottom:48px;}
    .eb-contact .ebc-visit-panel,.eb-contact .ebc-method {padding:22px 18px;}
    .eb-contact .ebc-notice {padding:16px 13px;gap:9px;margin-bottom:48px;}
    .eb-contact .ebc-ending {padding:27px 20px;flex-direction:column;align-items:flex-start;}
}
@media(prefers-reduced-motion:reduce) {
    .eb-contact * {animation:none!important;transition:none!important;}
    .eb-contact.ebc-motion .ebc-reveal {opacity:1;transform:none;}
}
</style>

<div class="eb-contact" id="ebContactRoot">
    <svg class="ebc-symbols" xmlns="http://www.w3.org/2000/svg" aria-hidden="true">
        <symbol id="ebc-pin" viewBox="0 0 24 24"><path d="M20 10c0 5-8 12-8 12S4 15 4 10a8 8 0 1 1 16 0Z"/><circle cx="12" cy="10" r="2.8"/></symbol>
        <symbol id="ebc-mail" viewBox="0 0 24 24"><rect x="2" y="5" width="20" height="14" rx="2"/><path d="m3 7 9 7 9-7"/></symbol>
        <symbol id="ebc-clock" viewBox="0 0 24 24"><circle cx="12" cy="12" r="9"/><path d="M12 7v5l4 2"/></symbol>
        <symbol id="ebc-phone" viewBox="0 0 24 24"><path d="M7 3h3l1.5 5-2.3 2a15 15 0 0 0 5 5L16 13l5 1.5v3A3.5 3.5 0 0 1 17.5 21C9.5 21 3 14.5 3 6.5A3.5 3.5 0 0 1 6.5 3Z"/></symbol>
        <symbol id="ebc-arrow" viewBox="0 0 24 24"><path d="M5 12h14m-7-7 7 7-7 7"/></symbol>
        <symbol id="ebc-heart" viewBox="0 0 24 24"><path d="M20.8 6c-2.2-2.4-5.7-2.4-7.8 0L12 7l-1-1c-2.1-2.4-5.6-2.4-7.8 0S1 12 3.2 14L12 22l8.8-8c2.2-2 2.2-5.6 0-8Z"/></symbol>
        <symbol id="ebc-alert" viewBox="0 0 24 24"><path d="M12 3 2 21h20L12 3Z"/><path d="M12 9v5m0 3v.5"/></symbol>
    </svg>

    <!-- Welcome banner: uses your existing Images/eastboom.jpg -->
    <section class="ebc-hero" aria-labelledby="ebcContactTitle">
        <div class="ebc-hero-text">
            <span class="ebc-hero-pill"><span class="ebc-spark"></span> East Boom Community Health Centre</span>
            <h1 id="ebcContactTitle">Here to help.<br /><em>Close to home.</em></h1>
            <p>Looking for the clinic, planning a visit or making an enquiry? Find the details you need and get in touch with East Boom CHC in Pietermaritzburg.</p>
            <div class="ebc-hero-actions">
                <a class="ebc-button ebc-button-lime" href="https://www.google.com/maps/search/?api=1&amp;query=East+Boom+Community+Health+Centre%2C+541+Boom+Street%2C+Pietermaritzburg" target="_blank" rel="noopener noreferrer">Get directions <svg class="ebc-icon" aria-hidden="true"><use href="#ebc-arrow" /></svg></a>
                <a class="ebc-button ebc-button-ghost" href="mailto:nosipho.dlamini@kznhealth.gov.za?subject=East%20Boom%20CHC%20Enquiry">Send an email <svg class="ebc-icon" aria-hidden="true"><use href="#ebc-mail" /></svg></a>
            </div>
        </div>
        <div class="ebc-hero-photo">
            <img src='<%= ResolveUrl("~/Images/eastboom.jpg") %>' alt="East Boom Community Health Centre building" fetchpriority="high" />
            <div class="ebc-photo-caption"><strong>East Boom Community Health Centre</strong><small>541 Boom Street · Pietermaritzburg, KwaZulu-Natal</small></div>
        </div>
    </section>

    <div class="ebc-body">
        <!-- Contact at a glance -->
        <section class="ebc-cards" aria-label="Clinic contact information">
            <article class="ebc-card">
                <span class="ebc-card-icon"><svg class="ebc-icon" aria-hidden="true"><use href="#ebc-pin" /></svg></span>
                <h3>Visit the clinic</h3>
                <address>541 Boom Street<br />Pietermaritzburg, 3201<br />KwaZulu-Natal, South Africa</address>
            </article>
            <article class="ebc-card">
                <span class="ebc-card-icon"><svg class="ebc-icon" aria-hidden="true"><use href="#ebc-mail" /></svg></span>
                <h3>Email enquiries</h3>
                <p><a href="mailto:nosipho.dlamini@kznhealth.gov.za">nosipho.dlamini@kznhealth.gov.za</a></p>
                <small>Public Relations Office · Non-urgent enquiries</small>
            </article>
            <article class="ebc-card">
                <span class="ebc-card-icon"><svg class="ebc-icon" aria-hidden="true"><use href="#ebc-clock" /></svg></span>
                <h3>General operating hours</h3>
                <p>Mon–Fri: 07:00–16:30<br />Saturday: 08:00–14:00</p>
                <small>Emergency and certain PHC services are listed as 24-hour services.</small>
            </article>
        </section>

        <!-- Map from the original Contact.aspx, preserving the working Google embed -->
        <section class="ebc-map-section ebc-reveal" aria-labelledby="ebcFindTitle">
            <div class="ebc-section-heading">
                <span class="ebc-tag">Visit us</span>
                <h2 class="ebc-heading" id="ebcFindTitle">Find us in <em>Pietermaritzburg.</em></h2>
                <p class="ebc-description">East Boom CHC is situated near the lower end of the city centre. The official facility description notes bus and taxi access nearby.</p>
            </div>
            <div class="ebc-map-layout">
                <div class="ebc-map-frame">
                    <span class="ebc-map-tag">East Boom CHC · 541 Boom Street</span>
                    <iframe title="Google map of East Boom Community Health Centre in Pietermaritzburg"
                        src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3469.509278690973!2d30.383773176291495!3d-29.588878175156182!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x1ef6bc86d3023c99%3A0x7ae9b4633cbba5bb!2sEast%20Boom%20Community%20Health%20Centre!5e0!3m2!1sen!2sza!4v1787252484055!5m2!1sen!2sza"
                        allowfullscreen loading="lazy" referrerpolicy="strict-origin-when-cross-origin"></iframe>
                </div>
                <aside class="ebc-visit-panel">
                    <span class="ebc-tag">Before you travel</span>
                    <h3>Plan your visit with confidence.</h3>
                    <div class="ebc-visit-row"><svg class="ebc-icon" aria-hidden="true"><use href="#ebc-pin" /></svg><div><strong>Clinic address</strong><p>541 Boom Street, Pietermaritzburg, 3201</p></div></div>
                    <div class="ebc-visit-row"><svg class="ebc-icon" aria-hidden="true"><use href="#ebc-clock" /></svg><div><strong>General opening hours</strong><p>Monday–Friday, 07:00–16:30<br />Saturday, 08:00–14:00</p></div></div>
                    <div class="ebc-visit-row"><svg class="ebc-icon" aria-hidden="true"><use href="#ebc-heart" /></svg><div><strong>24-hour care</strong><p>Emergency/trauma and certain primary healthcare services are listed as available 24 hours. Other departments have separate hours.</p></div></div>
                    <div class="ebc-visit-row"><svg class="ebc-icon" aria-hidden="true"><use href="#ebc-pin" /></svg><div><strong>Public transport</strong><p>Bus and taxi access is described near the clinic on the official KZN Health website.</p></div></div>
                    <a class="ebc-button ebc-button-green" href="https://www.kznhealth.gov.za/services-offered-at-east-boom-chc/" target="_blank" rel="noopener noreferrer">View service hours <svg class="ebc-icon" aria-hidden="true"><use href="#ebc-arrow" /></svg></a>
                </aside>
            </div>
        </section>

        <!-- The official telephone notice is important for patients -->
        <aside class="ebc-notice ebc-reveal" role="note" aria-label="Telephone service advisory">
            <span class="ebc-notice-icon"><svg class="ebc-icon" aria-hidden="true"><use href="#ebc-alert" /></svg></span>
            <div>
                <strong>Telephone service advisory</strong>
                <p>On 26 February 2026, KZN Health reported that East Boom CHC's telephone lines were not working. The restoration status has not been confirmed here. If you cannot get through, use the published email address for non-urgent enquiries and check the <a href="https://www.kznhealth.gov.za/east-boom-chc/" target="_blank" rel="noopener noreferrer">official facility page</a> for updates.</p>
            </div>
        </aside>

        <!-- Email and phone contacts; no database or email-sending functionality added -->
        <section class="ebc-methods ebc-reveal" aria-labelledby="ebcTalkTitle">
            <div class="ebc-section-heading">
                <span class="ebc-tag">Get in touch</span>
                <h2 class="ebc-heading" id="ebcTalkTitle">The right way to <em>reach us.</em></h2>
                <p class="ebc-description">For enquiries, feedback or general information, use the contact details published by the KwaZulu-Natal Department of Health.</p>
            </div>
            <div class="ebc-method-grid">
                <article class="ebc-method">
                    <span class="ebc-card-icon"><svg class="ebc-icon" aria-hidden="true"><use href="#ebc-mail" /></svg></span>
                    <h3>Public Relations Office</h3>
                    <p>For general questions, compliments, concerns or suggestions, the official site lists Ms Nosipho Dlamini as Public Relations Officer.</p>
                    <a class="ebc-contact-address" href="mailto:nosipho.dlamini@kznhealth.gov.za?subject=East%20Boom%20CHC%20Enquiry">nosipho.dlamini@kznhealth.gov.za</a>
                    <p class="ebc-secondary">Please avoid sharing confidential medical or patient information in an ordinary email.</p>
                </article>
                <article class="ebc-method">
                    <span class="ebc-card-icon"><svg class="ebc-icon" aria-hidden="true"><use href="#ebc-phone" /></svg></span>
                    <h3>Published telephone numbers</h3>
                    <p>The KZN Health facility page lists these numbers for East Boom CHC. Availability may be affected by the telephone disruption notice above.</p>
                    <a class="ebc-number" href="tel:+27333426021">033 342 6021</a>
                    <a class="ebc-number" href="tel:+27333426022">033 342 6022</a>
                    <p class="ebc-secondary">For more numbers and official updates, use the KZN Health facility page.</p>
                </article>
            </div>
        </section>

        <!-- Simple interactive FAQ; no server-side logic -->
        <section class="ebc-help ebc-reveal" aria-labelledby="ebcHelpTitle">
            <div><span class="ebc-tag">Helpful information</span><h2 class="ebc-heading" id="ebcHelpTitle">Questions before <em>your visit?</em></h2><p class="ebc-description">A few quick answers can make your visit easier to plan.</p></div>
            <div class="ebc-help-list">
                <details><summary>Can I book an appointment online?</summary><p>Yes. Use the Book an Appointment page in the EastBoom Clinical Management System. You can browse options before completing the patient profile required to confirm a booking.</p></details>
                <details><summary>Is the clinic open outside general office hours?</summary><p>The official services page lists emergency/trauma and certain primary healthcare services as 24-hour services. Other departments have different consultation hours. Always check the relevant department before travelling.</p></details>
                <details><summary>Can I use this page to send a medical message?</summary><p>This page provides contact information; it is not a confidential medical messaging service. The email link opens your email application and does not send any information through the website.</p></details>
            </div>
        </section>

        <section class="ebc-ending ebc-reveal" aria-labelledby="ebcEndingTitle">
            <div><h2 id="ebcEndingTitle">Ready to plan your clinic visit?</h2><p>Your existing appointment booking system is just one click away.</p></div>
            <a class="ebc-button ebc-button-lime" href='<%= ResolveUrl("~/Private/Appointments/Appointments.aspx") %>'>Book an appointment <svg class="ebc-icon" aria-hidden="true"><use href="#ebc-arrow" /></svg></a>
        </section>
        <p class="ebc-source">Facility details and hours sourced from <a href="https://www.kznhealth.gov.za/east-boom-chc/" target="_blank" rel="noopener noreferrer">KZN Health – East Boom CHC</a> and its <a href="https://www.kznhealth.gov.za/services-offered-at-east-boom-chc/" target="_blank" rel="noopener noreferrer">published services page</a>. Please check for current updates before travelling.</p>
    </div>
</div>

<script>
(function() {
    function initEastBoomContact() {
        var root = document.getElementById('ebContactRoot');
        if (!root || root.getAttribute('data-ready') === 'true') return;
        root.setAttribute('data-ready', 'true');
        var reduceMotion = window.matchMedia && window.matchMedia('(prefers-reduced-motion: reduce)').matches;
        if (reduceMotion || !('IntersectionObserver' in window)) return;
        root.classList.add('ebc-motion');
        var observer = new IntersectionObserver(function(entries) {
            entries.forEach(function(entry) {
                if (entry.isIntersecting) {
                    entry.target.classList.add('ebc-visible');
                    observer.unobserve(entry.target);
                }
            });
        }, { threshold: 0.05, rootMargin: '0px 0px -15px 0px' });
        Array.prototype.forEach.call(root.querySelectorAll('.ebc-reveal'), function(el) {
            observer.observe(el);
        });
    }
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', initEastBoomContact);
    } else {
        initEastBoomContact();
    }
})();
</script>
</asp:Content>