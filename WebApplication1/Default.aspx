
<%@ Page Title="East Boom CHC - Pietermaritzburg"
    Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true"
    CodeBehind="Default.aspx.cs"
    Inherits="WebApplication1._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
<style>
  .ebm-home {
    --ebm-deep:#0d3e32; --ebm-forest:#155b47; --ebm-green:#187858;
    --ebm-bright:#c6f17e; --ebm-cream:#f7faf7; --ebm-mint:#ebf6ef;
    --ebm-ink:#143e32; --ebm-soft:#657c70; --ebm-border:#e2ece5;
    max-width:1320px; width:100%; margin:22px auto 62px;
    color:var(--ebm-ink); font-family:'Segoe UI',Arial,sans-serif;
  }
  .ebm-home, .ebm-home *, .ebm-home *::before, .ebm-home *::after { box-sizing:border-box; }
  .ebm-home h1,.ebm-home h2,.ebm-home h3,.ebm-home p { margin-top:0; }
  .ebm-home a { text-decoration:none; }
  .ebm-home a:focus-visible,.ebm-home button:focus-visible,.ebm-home summary:focus-visible {outline:3px solid #e0bd58;outline-offset:4px;}
  .ebm-home button {font:inherit; cursor:pointer;}
  .ebm-hidden-symbols {position:absolute;width:0;height:0;overflow:hidden;}

  /* HERO: photography, automatic cross-fade, ambient glow and small motion */
  .ebm-hero {
    position:relative; isolation:isolate; display:grid;
    grid-template-columns:minmax(0,1.02fr) minmax(0,.98fr);
    min-height:555px; overflow:hidden; border-radius:27px;
    background:radial-gradient(circle at 3% 0%,#236b4e 0%,transparent 38%),linear-gradient(123deg,#0a392f 3%,#116049 95%);
    box-shadow:0 25px 60px rgba(15,60,43,.13);
  }
  .ebm-hero::before {content:"";position:absolute;z-index:-1;left:-160px;bottom:-210px;width:530px;height:530px;border:1px solid rgba(208,246,204,.14);border-radius:50%;box-shadow:0 0 0 65px rgba(210,246,204,.022),0 0 0 145px rgba(210,246,204,.028);pointer-events:none;}
  .ebm-hero::after {content:"";position:absolute;left:41%;top:-240px;width:420px;height:420px;background:radial-gradient(circle,rgba(168,231,162,.18),transparent 68%);pointer-events:none;}
  .ebm-hero-copy {position:relative;z-index:2;padding:78px 15px 89px 66px;display:flex;align-items:flex-start;flex-direction:column;justify-content:center;}
  .ebm-eyebrow {display:inline-flex;align-items:center;gap:10px;padding:9px 14px;border:1px solid rgba(198,241,126,.34);border-radius:50px;background:rgba(255,255,255,.085);color:#e8fbeb;font-size:10.5px;font-weight:800;letter-spacing:1.08px;text-transform:uppercase;}
  .ebm-live-dot {width:8px;height:8px;background:#c7f185;border-radius:50%;box-shadow:0 0 0 5px rgba(201,244,136,.14);animation:ebm-pulse 2.8s ease-in-out infinite;}
  .ebm-hero h1 {max-width:650px;margin:24px 0 22px;color:#fff;font-weight:800;font-size:clamp(40px,4.15vw,62px);line-height:1.065;letter-spacing:-2.45px;}
  .ebm-hero h1 em {font-style:normal;color:var(--ebm-bright);}
  .ebm-hero-lead {max-width:500px;margin:0 0 31px;color:#d7eadf;font-size:15px;line-height:1.86;}
  .ebm-hero-actions,.ebm-cta-actions {display:flex;flex-wrap:wrap;gap:12px;}
  .ebm-btn {min-height:50px;padding:13px 23px;border:1px solid transparent;border-radius:12px;display:inline-flex;align-items:center;justify-content:center;gap:11px;font-size:13px;font-weight:800;transition:transform .24s ease,box-shadow .24s ease,background .24s ease;}
  .ebm-btn:hover {transform:translateY(-3px);}
  .ebm-btn svg {width:17px;height:17px;stroke-width:2.1;}
  .ebm-btn-lime {background:var(--ebm-bright);color:#15472d;box-shadow:0 11px 22px rgba(4,29,19,.14);}
  .ebm-btn-lime:hover {background:#d7faa5;color:#15472d;box-shadow:0 15px 27px rgba(4,29,19,.22);}
  .ebm-btn-ghost {background:rgba(255,255,255,.075);border-color:rgba(255,255,255,.46);color:white;}
  .ebm-btn-ghost:hover {background:rgba(255,255,255,.17);color:#fff;}
  .ebm-btn-green {background:#187656;color:#fff;}
  .ebm-btn-green:hover {background:#105b43;color:#fff;box-shadow:0 12px 24px rgba(24,118,86,.18);}
  .ebm-hero-mini {display:flex;align-items:center;gap:14px;margin-top:35px;color:#d7ecdf;font-size:11px;font-weight:600;}
  .ebm-hero-mini span {display:flex;align-items:center;gap:7px;}
  .ebm-hero-mini svg {width:15px;height:15px;color:var(--ebm-bright);}
  .ebm-hero-mini i {display:block;width:4px;height:4px;background:rgba(220,249,223,.45);border-radius:50%;}
  .ebm-hero-media {position:relative;min-height:555px;overflow:hidden;background:#438a6d;border-radius:150px 0 0 150px;}
  .ebm-slide {position:absolute;inset:0;opacity:0;visibility:hidden;transition:opacity 1.1s ease,visibility 1.1s ease;}
  .ebm-slide.is-active {opacity:1;visibility:visible;}
  .ebm-slide img {display:block;width:100%;height:100%;object-fit:cover;}
  .ebm-slide.is-active img {animation:ebm-photo-zoom 6s ease-out both;}
  .ebm-slide-photo-1 img {object-position:71% center;}
  .ebm-slide-photo-2 img {object-position:54% center;}
  .ebm-slide-photo-3 img {object-position:50% center;}
  .ebm-hero-media::before {content:"";position:absolute;inset:0;z-index:1;background:linear-gradient(180deg,transparent 52%,rgba(5,40,26,.64) 100%);pointer-events:none;}
  .ebm-photo-glow {position:absolute;z-index:2;right:-66px;top:-80px;width:225px;height:225px;border:1px solid rgba(255,255,255,.33);border-radius:50%;box-shadow:0 0 0 52px rgba(255,255,255,.045),0 0 0 115px rgba(255,255,255,.04);pointer-events:none;}
  .ebm-floating-note {position:absolute;left:20px;top:36px;z-index:4;display:flex;align-items:center;gap:10px;border:1px solid rgba(255,255,255,.70);border-radius:15px;padding:11px 15px;background:rgba(255,255,255,.9);box-shadow:0 16px 32px rgba(9,40,32,.17);backdrop-filter:blur(12px);-webkit-backdrop-filter:blur(12px);animation:ebm-bob 5s ease-in-out infinite;}
  .ebm-floating-note-icon {width:36px;height:36px;border-radius:11px;display:grid;place-items:center;background:#dff4e5;color:#17845a;}
  .ebm-floating-note svg {width:19px;height:19px;}
  .ebm-floating-note strong {display:block;font-size:12px;color:#173c30;}
  .ebm-floating-note small {display:block;margin-top:3px;font-size:10px;color:#638173;}
  .ebm-slide-bottom {position:absolute;z-index:3;bottom:37px;left:55px;right:34px;display:flex;align-items:end;justify-content:space-between;gap:10px;color:white;}
  .ebm-slide-cap {font-weight:800;font-size:15px;letter-spacing:.1px;}
  .ebm-slide-count {display:block;margin-bottom:6px;font-size:10px;font-weight:900;letter-spacing:1.7px;color:#e2f2dd;}
  .ebm-slide-controls {display:flex;align-items:center;gap:8px;}
  .ebm-slide-controls button {width:36px;height:36px;display:grid;place-items:center;background:rgba(255,255,255,.18);border:1px solid rgba(255,255,255,.48);border-radius:50%;color:white;transition:background .2s,transform .2s;}
  .ebm-slide-controls button:hover {background:rgba(255,255,255,.35);transform:scale(1.06);}
  .ebm-slide-controls svg {width:16px;height:16px;}
  .ebm-slide-controls .ebm-slideshow-toggle {font-size:11px;font-weight:800;}
  .ebm-slide-progress {position:absolute;z-index:3;left:55px;right:34px;bottom:20px;height:3px;border-radius:20px;background:rgba(255,255,255,.36);overflow:hidden;}
  .ebm-slide-progress-bar {display:block;width:100%;height:100%;background:var(--ebm-bright);transform-origin:left;transform:scaleX(0);}
  .ebm-hero.is-playing .ebm-slide-progress-bar {animation:ebm-progress 5.8s linear forwards;}

  /* overlapping quick actions */
  .ebm-quick {position:relative;z-index:4;margin:-37px 30px 0;display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:15px;}
  .ebm-quick-card {display:flex;align-items:center;gap:15px;padding:18px 19px 18px 17px;min-height:106px;background:#fff;color:var(--ebm-ink);border:1px solid #e6eee7;border-radius:18px;box-shadow:0 16px 37px rgba(29,71,51,.10);transition:transform .28s ease,box-shadow .28s ease,border-color .28s ease;}
  .ebm-quick-card:hover {transform:translateY(-7px);box-shadow:0 23px 35px rgba(29,71,51,.17);border-color:#a7d8b9;color:var(--ebm-ink);}
  .ebm-quick-icon {width:56px;height:56px;flex:0 0 56px;display:grid;place-items:center;border-radius:16px;background:#e8f7ee;color:#167c52;}
  .ebm-quick-icon svg {width:27px;height:27px;}
  .ebm-quick-copy {min-width:0;flex:1;}
  .ebm-quick-copy strong {display:block;margin-bottom:5px;font-size:15px;letter-spacing:-.2px;}
  .ebm-quick-copy small {display:block;color:#738579;font-size:11px;line-height:1.48;}
  .ebm-quick-arrow {width:30px;height:30px;flex:0 0 30px;display:grid;place-items:center;border-radius:50%;background:#1b7858;color:#fff;transition:transform .25s;}
  .ebm-quick-arrow svg {width:15px;height:15px;}
  .ebm-quick-card:hover .ebm-quick-arrow {transform:translateX(3px) rotate(-18deg);}

  /* content rhythm: photos and asymmetric editorial section */
  .ebm-main {margin-top:-67px;padding:145px 40px 53px;background:linear-gradient(180deg,#f4faf6 0%,#fff 45%,#f4f9f5 100%);border:1px solid #e5eee7;border-radius:0 0 28px 28px;}
  .ebm-section-label {display:inline-flex;align-items:center;gap:9px;color:#26845d;font-size:10.5px;font-weight:900;letter-spacing:1.9px;text-transform:uppercase;}
  .ebm-section-label::before {content:"";width:25px;height:2px;background:#8ecc9e;border-radius:99px;}
  .ebm-story {display:grid;grid-template-columns:minmax(0,.98fr) minmax(0,1.02fr);align-items:center;gap:60px;padding:6px 11px 81px;}
  .ebm-photo-collage {position:relative;min-height:428px;}
  .ebm-photo-main {position:absolute;left:3%;top:8px;width:78%;height:365px;overflow:hidden;border-radius:26px 75px 26px 26px;background:#d2e7db;box-shadow:0 26px 48px rgba(28,75,52,.14);}
  .ebm-photo-main img {display:block;width:100%;height:100%;object-fit:cover;object-position:53% center;transition:transform .7s ease;}
  .ebm-photo-collage:hover .ebm-photo-main img {transform:scale(1.055);}
  .ebm-photo-small {position:absolute;right:0;bottom:12px;width:43%;height:210px;overflow:hidden;border:8px solid #fff;border-radius:23px;background:#bee3c8;box-shadow:0 12px 35px rgba(24,66,46,.18);}
  .ebm-photo-small img {display:block;width:100%;height:100%;object-fit:cover;object-position:55%;}
  .ebm-photo-sticker {position:absolute;top:5px;right:6px;display:grid;place-items:center;width:106px;height:106px;border-radius:50%;background:#daf4df;color:#186b49;box-shadow:0 12px 25px rgba(28,75,52,.1);transform:rotate(13deg);animation:ebm-sticker 8s ease-in-out infinite;}
  .ebm-photo-sticker svg {width:33px;height:33px;}
  .ebm-story-copy h2 {margin:17px 0 17px;max-width:540px;color:#123d2e;font-size:clamp(30px,3.2vw,43px);font-weight:800;letter-spacing:-1.48px;line-height:1.2;}
  .ebm-story-copy h2 em {color:#198158;font-style:normal;}
  .ebm-story-copy>p {max-width:510px;color:var(--ebm-soft);font-size:14px;line-height:1.86;margin-bottom:22px;}
  .ebm-story-points {display:grid;gap:15px;margin:0 0 29px;padding:0;list-style:none;}
  .ebm-story-points li {display:flex;gap:12px;align-items:center;color:#264c3c;font-size:13px;font-weight:650;}
  .ebm-story-points span {width:30px;height:30px;flex:0 0 30px;display:grid;place-items:center;background:#e4f5e7;border-radius:10px;color:#208a5c;}
  .ebm-story-points svg {width:16px;height:16px;}
  .ebm-photo-disclaimer {display:block;margin-top:16px;color:#81948a;font-size:10px;line-height:1.55;}

  /* visual steps */
  .ebm-how {position:relative;overflow:hidden;background:#eef8f0;border:1px solid #e1f0e3;border-radius:24px;padding:44px 42px 40px;}
  .ebm-how::after {content:"";position:absolute;right:-180px;top:-200px;width:520px;height:520px;border-radius:50%;border:1px solid #cee9d6;pointer-events:none;box-shadow:0 0 0 52px rgba(194,227,201,.19);}
  .ebm-how-top {display:flex;align-items:end;justify-content:space-between;gap:25px;position:relative;z-index:1;}
  .ebm-how h2,.ebm-help h2 {margin:12px 0 9px;font-size:clamp(26px,2.8vw,36px);line-height:1.22;letter-spacing:-1.2px;font-weight:800;color:#133b2f;}
  .ebm-how-top p {color:#6c8275;font-size:13px;line-height:1.7;margin:0;}
  .ebm-how-link {white-space:nowrap;color:#1b7554;font-size:12px;font-weight:800;}
  .ebm-how-link:hover {color:#11523a;text-decoration:underline;}
  .ebm-steps {position:relative;display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:18px;margin-top:28px;z-index:1;}
  .ebm-steps::before {content:"";position:absolute;z-index:-1;left:15%;right:15%;top:45px;border-top:2px dashed #c1dfc9;}
  .ebm-step {padding:26px 25px 23px;background:#fff;border:1px solid #e3ece5;border-radius:19px;box-shadow:0 10px 26px rgba(33,78,53,.04);transition:transform .25s,box-shadow .25s;}
  .ebm-step:hover {transform:translateY(-6px);box-shadow:0 18px 27px rgba(33,78,53,.1);}
  .ebm-step-top {display:flex;align-items:center;justify-content:space-between;gap:10px;}
  .ebm-step-icon {display:grid;place-items:center;width:56px;height:56px;background:#e3f5e9;color:#177651;border-radius:17px;}
  .ebm-step-icon svg {width:29px;height:29px;}
  .ebm-step-n {font-size:22px;font-weight:850;letter-spacing:-1px;color:#b5d8bd;}
  .ebm-step h3 {margin:20px 0 8px;font-size:16px;font-weight:800;}
  .ebm-step p {margin:0;color:#71867a;font-size:12px;line-height:1.75;}

  /* FAQ and footer CTA */
  .ebm-help {display:grid;grid-template-columns:minmax(0,.79fr) minmax(0,1.21fr);gap:56px;padding:76px 11px 62px;}
  .ebm-help-title>p {max-width:290px;font-size:13px;line-height:1.85;color:#75887d;}
  .ebm-faq {border-top:1px solid #dfeae2;}
  .ebm-faq details {border-bottom:1px solid #dfeae2;padding:0;}
  .ebm-faq summary {position:relative;list-style:none;padding:19px 47px 19px 0;cursor:pointer;font-size:13px;font-weight:800;color:#184233;}
  .ebm-faq summary::-webkit-details-marker {display:none;}
  .ebm-faq summary::after {content:'+';position:absolute;right:1px;top:14px;width:28px;height:28px;display:grid;place-items:center;border-radius:50%;background:#e8f5ed;color:#277d59;font-size:18px;font-weight:600;transition:transform .25s,background .25s;}
  .ebm-faq details[open] summary::after {content:'−';background:#caebd4;}
  .ebm-faq details p {max-width:620px;margin:0;padding:0 40px 20px 0;color:#6d8275;font-size:12px;line-height:1.8;}
  .ebm-final {position:relative;min-height:228px;overflow:hidden;border-radius:24px;background:#103e31;color:#fff;display:grid;grid-template-columns:minmax(0,1fr) auto;align-items:center;gap:30px;padding:42px 46px;isolation:isolate;}
  .ebm-final::before {content:"";position:absolute;inset:0;background:radial-gradient(circle at 12% 12%,rgba(126,206,129,.22),transparent 35%);pointer-events:none;}
  .ebm-final-photo {position:absolute;z-index:-1;right:0;top:0;bottom:0;width:42%;opacity:.28;-webkit-mask-image:linear-gradient(90deg,transparent,#000 40%);mask-image:linear-gradient(90deg,transparent,#000 40%);}
  .ebm-final-photo img {width:100%;height:100%;object-fit:cover;object-position:65% center;}
  .ebm-final h2 {position:relative;max-width:570px;margin:0 0 13px;font-size:clamp(25px,3vw,37px);font-weight:800;letter-spacing:-1px;line-height:1.18;}
  .ebm-final p {position:relative;margin:0;color:#d4e7da;font-size:13px;line-height:1.8;}
  .ebm-final .ebm-btn {position:relative;white-space:nowrap;}
  .ebm-bottom-note {text-align:center;padding:19px 10px;color:#90a399;font-size:10px;letter-spacing:.2px;}

  .ebm-home.ebm-motion .ebm-reveal {opacity:0;transform:translateY(25px);transition:opacity .76s ease,transform .76s cubic-bezier(.2,.7,.2,1);}
  .ebm-home.ebm-motion .ebm-reveal.ebm-in {opacity:1;transform:translateY(0);}
  @keyframes ebm-bob {0%,100%{transform:translateY(0)}50%{transform:translateY(-9px)}}
  @keyframes ebm-sticker {0%,100%{transform:rotate(13deg) translateY(0)}50%{transform:rotate(6deg) translateY(-7px)}}
  @keyframes ebm-photo-zoom {from{transform:scale(1)}to{transform:scale(1.075)}}
  @keyframes ebm-progress {from{transform:scaleX(0)}to{transform:scaleX(1)}}
  @keyframes ebm-pulse {0%,100%{box-shadow:0 0 0 5px rgba(201,244,136,.14)}50%{box-shadow:0 0 0 9px rgba(201,244,136,0)}}

  @media(max-width:1110px){
    .ebm-hero-copy{padding-left:43px;padding-right:10px;}
    .ebm-hero h1{font-size:clamp(38px,4.2vw,52px);}
    .ebm-quick{margin-left:19px;margin-right:19px;gap:10px;}
    .ebm-quick-card{gap:10px;padding:15px 12px;}
    .ebm-quick-icon{width:46px;height:46px;flex-basis:46px;}
    .ebm-quick-copy strong{font-size:13px;}
    .ebm-main{padding-left:25px;padding-right:25px;}
    .ebm-story{gap:37px;}
    .ebm-help{gap:33px;}
  }
  @media(max-width:850px){
    .ebm-hero{grid-template-columns:1fr;}
    .ebm-hero-copy{padding:62px 45px 48px;}
    .ebm-hero h1{max-width:650px;font-size:clamp(42px,6vw,58px);}
    .ebm-hero-media{min-height:380px;border-radius:150px 150px 0 0;}
    .ebm-slide-photo-1 img{object-position:65% 34%;}
    .ebm-floating-note{left:28px;top:26px;}
    .ebm-quick{grid-template-columns:1fr 1fr;margin-top:-26px;}
    .ebm-quick-card:nth-child(3){grid-column:span 2;}
    .ebm-main{margin-top:-80px;padding-top:155px;}
    .ebm-story{grid-template-columns:1fr;gap:26px;}
    .ebm-photo-collage{max-width:630px;width:100%;margin:auto;}
    .ebm-help{grid-template-columns:1fr;gap:18px;}
  }
  @media(max-width:600px){
    .ebm-home{margin:11px auto 35px;}
    .ebm-hero{border-radius:19px;}
    .ebm-hero-copy{padding:34px 22px 25px;}
    .ebm-eyebrow{font-size:9px;letter-spacing:.7px;}
    .ebm-hero h1{margin:17px 0 13px;font-size:clamp(35px,8.5vw,46px);letter-spacing:-1.5px;}
    .ebm-hero-lead{font-size:12.5px;line-height:1.63;margin-bottom:22px;}
    .ebm-hero-mini{flex-wrap:wrap;gap:8px;margin-top:18px;}
    .ebm-hero-mini i{display:none;}
    .ebm-hero-mini span{margin-right:9px;}
    .ebm-btn{min-height:43px;font-size:11px;padding:10px 12px;}
    .ebm-hero-media{min-height:330px;border-radius:84px 84px 0 0;}
    .ebm-floating-note{padding:8px 10px;top:16px;left:14px;}
    .ebm-floating-note-icon{width:29px;height:29px;}
    .ebm-floating-note strong{font-size:10px;}
    .ebm-floating-note small{font-size:9px;}
    .ebm-slide-bottom{left:23px;bottom:34px;right:17px;}
    .ebm-slide-progress{left:23px;right:17px;}
    .ebm-slide-cap{font-size:13px;}
    .ebm-slide-controls button{width:31px;height:31px;}
    .ebm-quick{grid-template-columns:1fr;gap:10px;margin:12px 11px 0;}
    .ebm-quick-card:nth-child(3){grid-column:auto;}
    .ebm-quick-card{min-height:84px;padding:14px 15px;}
    .ebm-main{margin-top:-40px;padding:88px 15px 30px;border-radius:0 0 18px 18px;}
    .ebm-story{padding:0 0 46px;gap:10px;}
    .ebm-photo-collage{min-height:298px;}
    .ebm-photo-main{height:260px;width:82%;}
    .ebm-photo-small{height:140px;width:43%;bottom:0;border-width:5px;}
    .ebm-photo-sticker{width:67px;height:67px;right:3px;}
    .ebm-photo-sticker svg{width:24px;height:24px;}
    .ebm-story-copy h2{font-size:31px;letter-spacing:-1px;}
    .ebm-how{padding:29px 18px 26px;border-radius:18px;}
    .ebm-how-top{display:block;}
    .ebm-how-link{display:inline-block;margin-top:16px;}
    .ebm-steps{grid-template-columns:1fr;gap:11px;margin-top:22px;}
    .ebm-steps::before{display:none;}
    .ebm-step{padding:18px;}
    .ebm-step-icon{width:44px;height:44px;}
    .ebm-step-icon svg{width:23px;height:23px;}
    .ebm-step h3{margin-top:12px;}
    .ebm-help{padding:47px 2px 44px;}
    .ebm-final{grid-template-columns:1fr;gap:20px;padding:29px 22px;min-height:255px;border-radius:18px;}
    .ebm-final-photo{width:72%;opacity:.19;}
    .ebm-final h2{font-size:29px;}
  }

  /* INFORMATION FROM KZN HEALTH - ADDED SECTIONS ONLY; ORIGINAL STYLE IS UNCHANGED */
  .ebm-official { margin:3px 11px 81px; }
  .ebm-official-heading h2,.ebm-care-heading h2,.ebm-leaders-heading h2 {font-size:clamp(29px,3.1vw,40px);font-weight:830;line-height:1.19;letter-spacing:-1.15px;margin:13px 0 14px;color:#163f32;}
  .ebm-official-heading h2 em,.ebm-care-heading h2 em,.ebm-leaders-heading h2 em {font-style:normal;color:#24865e;}
  .ebm-official-desc {color:#667e70;font-size:13px;line-height:1.88;max-width:675px;margin-bottom:14px;}
  .ebm-official-layout {display:grid;grid-template-columns:minmax(0,1.1fr) minmax(0,.9fr);gap:34px;align-items:stretch;}
  .ebm-official-copy {padding:13px 12px 8px 0;}
  .ebm-official-values {display:flex;flex-wrap:wrap;gap:9px;margin:21px 0 0;}
  .ebm-official-values span {font-size:11px;font-weight:740;border:1px solid #d4e9da;color:#25694c;background:#f5fcf7;border-radius:50px;padding:9px 12px;}
  .ebm-official-visit {padding:27px 27px 25px;border-radius:21px;background:linear-gradient(155deg,#eaf7ed,#fafffb);border:1px solid #dceae0;box-shadow:0 15px 28px rgba(25,85,51,.045);}
  .ebm-official-visit small {color:#32815c;text-transform:uppercase;letter-spacing:1.5px;font-size:10px;font-weight:900;}
  .ebm-official-visit h3 {font-size:20px;letter-spacing:-.5px;margin:12px 0 21px;}
  .ebm-visit-item {display:flex;align-items:start;gap:12px;margin:17px 0;}
  .ebm-visit-icon {height:37px;width:37px;flex:0 0 37px;display:grid;place-items:center;border-radius:11px;background:#d7eee0;color:#1a7b56;}
  .ebm-visit-icon svg {height:19px;width:19px;}
  .ebm-visit-item strong {display:block;color:#1d4d39;font-size:12px;margin-bottom:4px;}
  .ebm-visit-item span:last-child {font-size:12px;color:#687d70;line-height:1.6;}
  .ebm-visit-note {font-size:10.5px;line-height:1.7;color:#6d7f72;border-top:1px solid #d9e9de;margin:20px 0 17px;padding-top:14px;}
  .ebm-official-link {display:inline-flex;align-items:center;gap:7px;color:#17734f!important;text-decoration:none!important;font-size:12px;font-weight:850;}
  .ebm-official-link:hover{text-decoration:underline!important;}
  .ebm-care {padding:30px 8px 83px;}
  .ebm-care-top {display:flex;align-items:end;justify-content:space-between;gap:25px;margin:0 4px 24px;}
  .ebm-care-heading p,.ebm-leaders-heading p {font-size:12.5px;line-height:1.75;color:#75877b;max-width:640px;margin:0;}
  .ebm-care-grid {display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:15px;}
  .ebm-care-card {border:1px solid #e0eae3;border-radius:18px;background:#fff;padding:22px;min-height:180px;transition:transform .28s ease,box-shadow .28s ease,border-color .28s ease;}
  .ebm-care-card:hover{transform:translateY(-5px);box-shadow:0 18px 30px rgba(27,85,49,.09);border-color:#b1d9bb;}
  .ebm-care-card-top{display:flex;align-items:center;justify-content:space-between;margin-bottom:20px;}
  .ebm-care-symbol{width:46px;height:46px;display:grid;place-items:center;background:#e4f6e9;color:#147a51;border-radius:14px;}
  .ebm-care-symbol svg{width:24px;height:24px;}
  .ebm-care-tag{font-size:9px;text-transform:uppercase;letter-spacing:.9px;color:#39795c;background:#edf8f1;border-radius:30px;padding:7px 10px;font-weight:850;}
  .ebm-care-card h3 {font-size:15px;font-weight:830;margin:0 0 9px;color:#194330;}
  .ebm-care-card p {font-size:11.4px;color:#758a7e;line-height:1.7;margin:0;}
  .ebm-care-disclaimer {margin:15px 4px 0;font-size:11px;line-height:1.75;color:#768b7f;}
  .ebm-leaders {margin:0 0 78px;padding:32px 30px 34px;background:linear-gradient(145deg,#f1faf3 0%,#e9f5ed 100%);border:1px solid #dcebe0;border-radius:25px;}
  .ebm-leaders-header{display:flex;justify-content:space-between;align-items:end;gap:20px;margin-bottom:27px;}
  .ebm-leaders-heading h2{margin-bottom:10px;}
  .ebm-leaders-feature {display:flex;align-items:center;gap:22px;padding:21px 24px;margin-bottom:15px;border-radius:19px;background:#14503d;color:#fff;box-shadow:0 14px 33px rgba(14,83,49,.12);}
  .ebm-manager-portrait{width:77px;height:77px;flex:0 0 77px;border-radius:18px;overflow:hidden;background:#c8e6d0;border:3px solid #eaf6ee;box-shadow:0 10px 18px rgba(9,60,32,.09);}
  .ebm-manager-portrait img{display:block;width:100%;height:100%;object-fit:cover;}
  .ebm-leaders-feature .ebm-manager-portrait{height:102px;width:102px;flex-basis:102px;border-radius:23px;border-color:rgba(255,255,255,.25);}
  .ebm-leaders-feature small {text-transform:uppercase;letter-spacing:1.5px;color:#c5edb1;font-size:9.5px;font-weight:850;}
  .ebm-leaders-feature h3 {font-size:21px;color:#fff;margin:8px 0 5px;}
  .ebm-leaders-feature p {color:#d5eadf;font-size:12.5px;margin:0;line-height:1.55;}
  .ebm-leaders-grid{display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:13px;}
  .ebm-leader-card{display:flex;align-items:center;gap:14px;min-height:120px;background:#fff;border:1px solid #dce9df;padding:17px;border-radius:18px;transition:transform .28s,box-shadow .28s;}
  .ebm-leader-card:hover{transform:translateY(-5px);box-shadow:0 14px 23px rgba(19,82,49,.1);}
  .ebm-leader-card h3 {color:#234e39;font-size:12.6px;line-height:1.35;margin:0 0 6px;font-weight:830;}
  .ebm-leader-card p {font-size:10.5px;line-height:1.55;color:#76917f;margin:0;}
  .ebm-leaders-foot{display:flex;justify-content:space-between;align-items:center;gap:15px;flex-wrap:wrap;margin:20px 2px 0;}
  .ebm-leaders-foot p{font-size:10.5px;color:#7b8c7f;margin:0;line-height:1.6;max-width:680px;}
  @media(max-width:980px) {.ebm-official-layout{gap:20px}.ebm-care-grid{grid-template-columns:repeat(2,minmax(0,1fr))}.ebm-leaders-grid{grid-template-columns:repeat(2,minmax(0,1fr))}}
  @media(max-width:850px) {.ebm-official-layout{grid-template-columns:1fr}.ebm-official-desc{max-width:100%}.ebm-leaders-header{display:block}.ebm-leaders-header .ebm-official-link{margin-top:15px}}
  @media(max-width:600px) {
    .ebm-official{margin:0 0 54px}.ebm-official-heading h2,.ebm-care-heading h2,.ebm-leaders-heading h2{font-size:29px;letter-spacing:-.8px}
    .ebm-official-visit{padding:21px 18px}.ebm-official-values span{font-size:10px}
    .ebm-care{padding:0 0 57px}.ebm-care-top{display:block}.ebm-care-top .ebm-official-link{margin-top:16px}
    .ebm-care-grid{grid-template-columns:1fr;gap:12px}.ebm-care-card{min-height:unset;padding:18px}.ebm-care-card-top{margin-bottom:13px}
    .ebm-leaders{margin-bottom:58px;padding:21px 15px;border-radius:18px}.ebm-leaders-feature{padding:18px;gap:14px}.ebm-leaders-feature .ebm-manager-portrait{width:78px;height:78px;flex-basis:78px;border-radius:18px}.ebm-leaders-feature h3{font-size:18px}
    .ebm-leaders-grid{grid-template-columns:1fr;gap:9px}.ebm-leader-card{min-height:93px;padding:12px}.ebm-manager-portrait{width:62px;height:62px;flex-basis:62px;border-radius:14px}
  }

  @media(prefers-reduced-motion:reduce){
    .ebm-home *, .ebm-home *::before,.ebm-home *::after {animation:none!important;transition:none!important;scroll-behavior:auto!important;}
    .ebm-home.ebm-motion .ebm-reveal{opacity:1;transform:none;}
    .ebm-slide:not(.is-active){visibility:hidden;}
  }
  #ebmServicesGrid, #ebmLeadersGrid {scroll-margin-top:86px;}
</style>

<div class="ebm-home" id="ebmHome">
  <!-- Tiny icon set: embedded so the design needs no icon library. -->
  <svg class="ebm-hidden-symbols" aria-hidden="true" xmlns="http://www.w3.org/2000/svg">
    <symbol id="ebm-i-arrow" viewBox="0 0 24 24"><path d="M5 12h14m-7-7 7 7-7 7" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/></symbol>
    <symbol id="ebm-i-back" viewBox="0 0 24 24"><path d="m14 6-6 6 6 6" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/></symbol>
    <symbol id="ebm-i-next" viewBox="0 0 24 24"><path d="m10 6 6 6-6 6" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/></symbol>
    <symbol id="ebm-i-calendar" viewBox="0 0 24 24"><rect x="3" y="5" width="18" height="16" rx="2" fill="none" stroke="currentColor" stroke-width="1.9"/><path d="M7 3v4m10-4v4M3 10h18M8 14h3m3 0h2m-8 3h3" fill="none" stroke="currentColor" stroke-width="1.9" stroke-linecap="round"/></symbol>
    <symbol id="ebm-i-user" viewBox="0 0 24 24"><circle cx="12" cy="8" r="4" fill="none" stroke="currentColor" stroke-width="1.9"/><path d="M5 21v-2c0-4 3-6 7-6s7 2 7 6v2" fill="none" stroke="currentColor" stroke-width="1.9" stroke-linecap="round"/></symbol>
    <symbol id="ebm-i-grid" viewBox="0 0 24 24"><rect x="3" y="3" width="7" height="7" rx="1" fill="none" stroke="currentColor" stroke-width="1.8"/><rect x="14" y="3" width="7" height="7" rx="1" fill="none" stroke="currentColor" stroke-width="1.8"/><rect x="3" y="14" width="7" height="7" rx="1" fill="none" stroke="currentColor" stroke-width="1.8"/><rect x="14" y="14" width="7" height="7" rx="1" fill="none" stroke="currentColor" stroke-width="1.8"/></symbol>
    <symbol id="ebm-i-check" viewBox="0 0 24 24"><path d="m5 12 4.5 4.5L19 7" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"/></symbol>
    <symbol id="ebm-i-clock" viewBox="0 0 24 24"><circle cx="12" cy="12" r="9" fill="none" stroke="currentColor" stroke-width="1.8"/><path d="M12 7v5l4 2" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round"/></symbol>
    <symbol id="ebm-i-heart" viewBox="0 0 24 24"><path d="M20.8 5.6c-2.2-2.3-5.7-2.1-7.8.1L12 6.8l-1-1.1C8.9 3.5 5.4 3.3 3.2 5.6 1 7.8 1.7 11 4 13.3L12 21l8-7.7c2.3-2.3 3-5.5.8-7.7Z" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linejoin="round"/></symbol>
  </svg>

  <section class="ebm-hero" aria-labelledby="ebmHeroTitle">
    <div class="ebm-hero-copy">
      <span class="ebm-eyebrow"><span class="ebm-live-dot"></span> Pietermaritzburg Health Services</span>
      <h1 id="ebmHeroTitle">Care feels better when it starts <em>with ease.</em></h1>
      <p class="ebm-hero-lead">Welcome to the <strong>EastBoom Clinical Management System</strong>. Arrange your clinic visit, keep track of appointments and stay organised from one welcoming place.</p>
      <div class="ebm-hero-actions">
        <a class="ebm-btn ebm-btn-lime" href='<%= ResolveUrl("~/Private/Appointments/Appointments.aspx") %>'>Book an appointment <svg aria-hidden="true"><use href="#ebm-i-arrow" /></svg></a>
        <a class="ebm-btn ebm-btn-ghost" href='<%= ResolveUrl("~/Private/Patient/PatientDashboard.aspx") %>'>My dashboard <svg aria-hidden="true"><use href="#ebm-i-arrow" /></svg></a>
      </div>
      <div class="ebm-hero-mini" aria-label="Online appointment steps">
        <span><svg aria-hidden="true"><use href="#ebm-i-check" /></svg> Choose a date</span><i aria-hidden="true"></i>
        <span><svg aria-hidden="true"><use href="#ebm-i-check" /></svg> Select your care team</span><i aria-hidden="true"></i>
        <span><svg aria-hidden="true"><use href="#ebm-i-check" /></svg> Confirm your visit</span>
      </div>
    </div>
    <div class="ebm-hero-media" aria-label="Healthcare photography slideshow" id="ebmSlideshow">
      <div class="ebm-slide ebm-slide-photo-1 is-active" data-caption="A warmer way to plan your visit" aria-hidden="false"><img src='<%= ResolveUrl("~/Images/hero-consultation.jpg") %>' alt="Illustration of a doctor having a friendly consultation with a patient" fetchpriority="high" /></div>
      <div class="ebm-slide ebm-slide-photo-2" data-caption="Support from your care team" aria-hidden="true"><img src='<%= ResolveUrl("~/Images/hero-team.jpg") %>' alt="Illustration of healthcare professionals discussing patient care" loading="lazy" /></div>
      <div class="ebm-slide ebm-slide-photo-3" data-caption="Every care journey matters" aria-hidden="true"><img src='<%= ResolveUrl("~/Images/hero-care.jpg") %>' alt="Illustration of a physician speaking with a patient" loading="lazy" /></div>
      <div class="ebm-photo-glow" aria-hidden="true"></div>
      <div class="ebm-floating-note" aria-hidden="true"><span class="ebm-floating-note-icon"><svg><use href="#ebm-i-heart" /></svg></span><span><strong>Your care, made simpler</strong><small>Appointments · Profiles · Updates</small></span></div>
      <div class="ebm-slide-bottom">
        <div><span class="ebm-slide-count">01 / 03</span><span class="ebm-slide-cap" aria-live="polite">A warmer way to plan your visit</span></div>
        <div class="ebm-slide-controls">
          <button type="button" data-ebm-prev aria-label="Previous clinic photo"><svg aria-hidden="true"><use href="#ebm-i-back" /></svg></button>
          <button type="button" data-ebm-next aria-label="Next clinic photo"><svg aria-hidden="true"><use href="#ebm-i-next" /></svg></button>
          <button type="button" class="ebm-slideshow-toggle" data-ebm-toggle aria-label="Pause clinic slideshow" aria-pressed="false">Ⅱ</button>
        </div>
      </div>
      <div class="ebm-slide-progress" aria-hidden="true"><span class="ebm-slide-progress-bar"></span></div>
    </div>
  </section>

  <nav class="ebm-quick" aria-label="Quick patient actions">
    <a class="ebm-quick-card" href='<%= ResolveUrl("~/Private/Appointments/Appointments.aspx") %>'>
      <span class="ebm-quick-icon"><svg aria-hidden="true"><use href="#ebm-i-calendar" /></svg></span>
      <span class="ebm-quick-copy"><strong>Book an appointment</strong><small>Find a date, time and care team</small></span>
      <span class="ebm-quick-arrow"><svg aria-hidden="true"><use href="#ebm-i-arrow" /></svg></span>
    </a>
    <a class="ebm-quick-card" href='<%= ResolveUrl("~/Private/Patient/PatientDashboard.aspx") %>'>
      <span class="ebm-quick-icon"><svg aria-hidden="true"><use href="#ebm-i-grid" /></svg></span>
      <span class="ebm-quick-copy"><strong>Patient dashboard</strong><small>View your upcoming appointments</small></span>
      <span class="ebm-quick-arrow"><svg aria-hidden="true"><use href="#ebm-i-arrow" /></svg></span>
    </a>
    <a class="ebm-quick-card" href='<%= ResolveUrl("~/Private/CompletePatientProfile.aspx") %>'>
      <span class="ebm-quick-icon"><svg aria-hidden="true"><use href="#ebm-i-user" /></svg></span>
      <span class="ebm-quick-copy"><strong>Complete your profile</strong><small>Add the details needed to book</small></span>
      <span class="ebm-quick-arrow"><svg aria-hidden="true"><use href="#ebm-i-arrow" /></svg></span>
    </a>
  </nav>

  <main class="ebm-main">
    <section class="ebm-story ebm-reveal" id="ebmServices" aria-labelledby="ebmStoryTitle">
      <div class="ebm-photo-collage">
        <div class="ebm-photo-main"><img src='<%= ResolveUrl("~/Images/hero-team.jpg") %>' loading="lazy" alt="Illustrative healthcare team working together" /></div>
        <div class="ebm-photo-small"><img src='<%= ResolveUrl("~/Images/hero-care.jpg") %>' loading="lazy" alt="Illustrative doctor and patient in a welcoming clinic" /></div>
        <span class="ebm-photo-sticker" aria-hidden="true"><svg><use href="#ebm-i-heart" /></svg></span>
      </div>
      <div class="ebm-story-copy">
        <span class="ebm-section-label">A better clinic experience</span>
        <h2 id="ebmStoryTitle">Less back-and-forth.<br /><em>More peace of mind.</em></h2>
        <p>Planning a clinic visit should feel straightforward. EastBoom brings your appointment options, patient information and visit overview together in one easy-to-use space.</p>
        <ul class="ebm-story-points">
          <li><span><svg aria-hidden="true"><use href="#ebm-i-check" /></svg></span>Browse appointment options before completing your profile</li>
          <li><span><svg aria-hidden="true"><use href="#ebm-i-check" /></svg></span>Choose your doctor, nurse and appointment time</li>
          <li><span><svg aria-hidden="true"><use href="#ebm-i-check" /></svg></span>Keep track of your visits on the patient dashboard</li>
        </ul>
        <a class="ebm-btn ebm-btn-green" href='<%= ResolveUrl("~/Private/Appointments/Appointments.aspx") %>'>Explore appointments <svg aria-hidden="true"><use href="#ebm-i-arrow" /></svg></a>
        <small class="ebm-photo-disclaimer">Healthcare photographs are illustrative and do not depict actual EastBoom staff or premises.</small>
      </div>
    </section>


    <!-- NEW: OFFICIAL COMMUNITY HEALTH CENTRE INFORMATION (KZN HEALTH) -->
    <section class="ebm-official ebm-reveal" id="ebmAboutCHC" aria-labelledby="ebmAboutCHCTitle">
      <div class="ebm-official-layout">
        <div class="ebm-official-copy">
          <span class="ebm-section-label">About East Boom CHC</span>
          <div class="ebm-official-heading"><h2 id="ebmAboutCHCTitle">Rooted in Pietermaritzburg.<br /><em>Here for our community.</em></h2></div>
          <p class="ebm-official-desc">East Boom Community Health Centre is an urban public healthcare facility within the uMgungundlovu Health District, serving communities in and around uMsunduzi Municipality.</p>
          <p class="ebm-official-desc">Located in central Pietermaritzburg near the N3, the centre supports preventive, promotive, curative and rehabilitative primary healthcare. Its service philosophy reflects the Batho Pele principles and the Patients' Rights Charter.</p>
          <div class="ebm-official-values" aria-label="East Boom CHC core values"><span>Trust &amp; integrity</span><span>Teamwork &amp; respect</span><span>Open communication</span><span>Commitment to care</span></div>
        </div>
        <aside class="ebm-official-visit" aria-labelledby="ebmVisitTitle">
          <small>Facility information</small><h3 id="ebmVisitTitle">Visit East Boom CHC</h3>
          <div class="ebm-visit-item"><span class="ebm-visit-icon"><svg aria-hidden="true"><use href="#ebm-i-grid" /></svg></span><span><strong>Find us</strong>541 Boom Street, Pietermaritzburg, KwaZulu-Natal</span></div>
          <div class="ebm-visit-item"><span class="ebm-visit-icon"><svg aria-hidden="true"><use href="#ebm-i-clock" /></svg></span><span><strong>Published general hours</strong>Monday–Friday: 07:00–16:30<br />Saturday: 08:00–14:00</span></div>
          <div class="ebm-visit-item"><span class="ebm-visit-icon"><svg aria-hidden="true"><use href="#ebm-i-heart" /></svg></span><span><strong>24-hour services listed</strong>Casualty, trauma and emergency care, alongside other specified services</span></div>
          <div class="ebm-visit-item"><span class="ebm-visit-icon"><svg aria-hidden="true"><use href="#ebm-i-user" /></svg></span><span><strong>Public Relations Officer</strong>Ms Nosipho Dlamini<br /><a href="mailto:nosipho.dlamini@kznhealth.gov.za">nosipho.dlamini@kznhealth.gov.za</a></span></div>
          <p class="ebm-visit-note">Individual departments have different consultation hours. The Department of Health published a telephone-line disruption notice on 26 February 2026; check the official site for its latest status.</p>
          <a class="ebm-official-link" href="https://www.kznhealth.gov.za/east-boom-chc/" target="_blank" rel="noopener noreferrer">Official KZN Health facility page &rarr;</a>
        </aside>
      </div>
    </section>

    <section class="ebm-how ebm-reveal" id="ebmHow" aria-labelledby="ebmHowTitle">
      <div class="ebm-how-top">
        <div><span class="ebm-section-label">Your visit, your way</span><h2 id="ebmHowTitle">Three simple steps to book</h2><p>A guided process on your existing appointment page.</p></div>
        <a class="ebm-how-link" href='<%= ResolveUrl("~/Private/Appointments/Appointments.aspx") %>'>Go to appointments →</a>
      </div>
      <div class="ebm-steps">
        <article class="ebm-step"><div class="ebm-step-top"><span class="ebm-step-icon"><svg aria-hidden="true"><use href="#ebm-i-calendar" /></svg></span><span class="ebm-step-n">01</span></div><h3>Choose a date &amp; time</h3><p>See available booking options and choose a suitable slot.</p></article>
        <article class="ebm-step"><div class="ebm-step-top"><span class="ebm-step-icon"><svg aria-hidden="true"><use href="#ebm-i-user" /></svg></span><span class="ebm-step-n">02</span></div><h3>Select your care team</h3><p>Choose the doctor and nurse for your appointment.</p></article>
        <article class="ebm-step"><div class="ebm-step-top"><span class="ebm-step-icon"><svg aria-hidden="true"><use href="#ebm-i-check" /></svg></span><span class="ebm-step-n">03</span></div><h3>Confirm your visit</h3><p>Complete your profile, add your reason and confirm your booking.</p></article>
      </div>
    </section>


    <!-- NEW: SERVICES DESCRIBED BY THE KZN DEPARTMENT OF HEALTH -->
    <section class="ebm-care ebm-reveal" id="ebmClinicServices" aria-labelledby="ebmClinicServicesTitle">
      <div class="ebm-care-top">
        <div class="ebm-care-heading"><span class="ebm-section-label">Community healthcare</span><h2 id="ebmClinicServicesTitle">Care for every stage <em>of life.</em></h2><p>A selection of services listed by KwaZulu-Natal Department of Health for East Boom CHC.</p></div>
        <a class="ebm-official-link" href="#ebmServicesGrid">Explore the services below &#8595;</a>
      </div>
      <div class="ebm-care-grid" id="ebmServicesGrid">
        <article class="ebm-care-card"><div class="ebm-care-card-top"><span class="ebm-care-symbol"><svg aria-hidden="true"><use href="#ebm-i-heart" /></svg></span><span class="ebm-care-tag">24-hour listing</span></div><h3>Emergency &amp; trauma care</h3><p>Casualty, trauma and emergency support, listed as a 24-hour service.</p></article>
        <article class="ebm-care-card"><div class="ebm-care-card-top"><span class="ebm-care-symbol"><svg aria-hidden="true"><use href="#ebm-i-grid" /></svg></span><span class="ebm-care-tag">24-hour listing</span></div><h3>Primary healthcare</h3><p>Primary Health Care and outpatient services (OPD), listed as operating 24 hours.</p></article>
        <article class="ebm-care-card"><div class="ebm-care-card-top"><span class="ebm-care-symbol"><svg aria-hidden="true"><use href="#ebm-i-user" /></svg></span><span class="ebm-care-tag">Family health</span></div><h3>Maternal &amp; child health</h3><p>Antenatal care, paediatric services, well-baby support and reproductive health.</p></article>
        <article class="ebm-care-card"><div class="ebm-care-card-top"><span class="ebm-care-symbol"><svg aria-hidden="true"><use href="#ebm-i-check" /></svg></span><span class="ebm-care-tag">Prevention &amp; treatment</span></div><h3>HIV, TB &amp; counselling</h3><p>HAST, TB clinic, ARV programme and voluntary counselling and testing.</p></article>
        <article class="ebm-care-card"><div class="ebm-care-card-top"><span class="ebm-care-symbol"><svg aria-hidden="true"><use href="#ebm-i-calendar" /></svg></span><span class="ebm-care-tag">Weekday services</span></div><h3>Dental &amp; radiology</h3><p>Dental services and radiology, subject to the departments' published hours.</p></article>
        <article class="ebm-care-card"><div class="ebm-care-card-top"><span class="ebm-care-symbol"><svg aria-hidden="true"><use href="#ebm-i-heart" /></svg></span><span class="ebm-care-tag">Specialist support</span></div><h3>Pharmacy &amp; mental health</h3><p>Dispensing services and weekday psychiatry consultations, according to the official listing.</p></article>
      </div>
      <p class="ebm-care-disclaimer">Service information is for general guidance; it does not imply that every service can be booked through this online portal. The official page also states that deliveries are suspended during renovations; verify the latest arrangements directly with the facility.</p>
    </section>


    <!-- SENIOR MANAGEMENT: USER-SUPPLIED PHOTOGRAPHS -->
    <section class="ebm-leaders ebm-reveal" id="ebmLeadership" aria-labelledby="ebmLeadershipTitle">
      <div class="ebm-leaders-header">
        <div class="ebm-leaders-heading"><span class="ebm-section-label">People behind the care</span><h2 id="ebmLeadershipTitle">Meet our <em>senior management.</em></h2><p>Meet the leaders listed on East Boom CHC's official KwaZulu-Natal Department of Health page.</p></div>
        <a class="ebm-official-link" href="#ebmLeadersGrid">Explore management photos below &#8595;</a>
      </div>
<article class="ebm-leaders-feature"><span class="ebm-manager-portrait"><img src='<%= ResolveUrl("~/Images/s-chetty.png") %>' alt="Photo of Dr S Chetty" loading="lazy" /></span><div><small>Facility leadership</small><h3>Dr S Chetty</h3><p>CEO &amp; Medical Manager</p></div></article>
      <div class="ebm-leaders-grid" id="ebmLeadersGrid">
        <article class="ebm-leader-card"><span class="ebm-manager-portrait"><img src='<%= ResolveUrl("~/Images/m-gopichand.png") %>' alt="Photo of Mrs M Gopichand" loading="lazy" /></span><div><h3>Mrs M Gopichand</h3><p>Deputy Nurse Manager</p></div></article>
        <article class="ebm-leader-card"><span class="ebm-manager-portrait"><img src='<%= ResolveUrl("~/Images/s-xatyiswa.png") %>' alt="Photo of Ms S Xatyiswa" loading="lazy" /></span><div><h3>Ms S Xatyiswa</h3><p>Acting HR Manager</p></div></article>
        <article class="ebm-leader-card"><span class="ebm-manager-portrait"><img src='<%= ResolveUrl("~/Images/nf-cele.png") %>' alt="Photo of Ms NF Cele" loading="lazy" /></span><div><h3>Ms NF Cele</h3><p>Finance Manager</p></div></article>
        <article class="ebm-leader-card"><span class="ebm-manager-portrait"><img src='<%= ResolveUrl("~/Images/e-wynia.png") %>' alt="Photo of Mr E Wynia" loading="lazy" /></span><div><h3>Mr E Wynia</h3><p>Systems Manager</p></div></article>
        <article class="ebm-leader-card"><span class="ebm-manager-portrait"><img src='<%= ResolveUrl("~/Images/ss-ngcobo.png") %>' alt="Photo of Mrs S.S Ngcobo" loading="lazy" /></span><div><h3>Mrs S.S Ngcobo</h3><p>Acting Director of PHCC</p></div></article>
        <article class="ebm-leader-card"><span class="ebm-manager-portrait"><img src='<%= ResolveUrl("~/Images/l-majozi.png") %>' alt="Photo of Miss L Majozi" loading="lazy" /></span><div><h3>Miss L Majozi</h3><p>Pharmacy Manager</p></div></article>
      </div>
      <div class="ebm-leaders-foot"><p>Photographs supplied for this project. Please confirm names, roles and consent for public publication with the clinic before deploying.</p></div>
    </section>

    <section class="ebm-help ebm-reveal" aria-labelledby="ebmHelpTitle">
      <div class="ebm-help-title"><span class="ebm-section-label">Good to know</span><h2 id="ebmHelpTitle">A little help, right when you need it.</h2><p>Quick answers to make using the clinical management system easier.</p></div>
      <div class="ebm-faq">
        <details><summary>Can I view appointment options before completing my profile?</summary><p>Yes. You can browse appointment options first, but you must complete your patient profile before confirming a booking.</p></details>
        <details><summary>Where do I view upcoming appointments?</summary><p>Open the Patient Dashboard. It is designed to show your appointment overview, upcoming visits and booking statuses.</p></details>
        <details><summary>What information do I need when booking?</summary><p>On the appointment page, select your date, care team and time, then add the reason for your visit. The booking page handles the availability checks.</p></details>
      </div>
    </section>

    <section class="ebm-final ebm-reveal" aria-labelledby="ebmFinalTitle">
      <div class="ebm-final-photo" aria-hidden="true"><img src='<%= ResolveUrl("~/Images/hero-consultation.jpg") %>' loading="lazy" alt="" /></div>
      <div><h2 id="ebmFinalTitle">Your next clinic visit starts here.</h2><p>Ready to get started? Choose your appointment details when it suits you.</p></div>
      <a class="ebm-btn ebm-btn-lime" href='<%= ResolveUrl("~/Private/Appointments/Appointments.aspx") %>'>Book my appointment <svg aria-hidden="true"><use href="#ebm-i-arrow" /></svg></a>
    </section>
    <p class="ebm-bottom-note">EastBoom Clinical Management System · A welcoming way to manage your clinic visits</p>
  </main>
</div>

<script>
    (function () {
        function initEastBoomHome() {
            var home = document.getElementById('ebmHome');
            if (!home || home.getAttribute('data-ready') === 'yes') return;
            home.setAttribute('data-ready', 'yes');
            var hero = home.querySelector('.ebm-hero');
            var viewport = home.querySelector('#ebmSlideshow');
            var slides = Array.prototype.slice.call(home.querySelectorAll('.ebm-slide'));
            var count = home.querySelector('.ebm-slide-count');
            var caption = home.querySelector('.ebm-slide-cap');
            var progress = home.querySelector('.ebm-slide-progress-bar');
            var toggle = home.querySelector('[data-ebm-toggle]');
            var reduced = window.matchMedia && window.matchMedia('(prefers-reduced-motion: reduce)').matches;
            var current = 0, timer = null, paused = !!reduced, hovering = false;
            function stopTimer() { if (timer) { window.clearInterval(timer); timer = null; } hero.classList.remove('is-playing'); }
            function show(index) {
                current = (index + slides.length) % slides.length;
                slides.forEach(function (slide, i) { var active = (i === current); slide.classList.toggle('is-active', active); slide.setAttribute('aria-hidden', String(!active)); });
                count.textContent = (current + 1 < 10 ? '0' : '') + (current + 1) + ' / 0' + slides.length;
                caption.textContent = slides[current].getAttribute('data-caption') || '';
                if (progress) { progress.style.animation = 'none'; void progress.offsetWidth; progress.style.animation = ''; }
                if (!paused && !hovering && !document.hidden) hero.classList.add('is-playing');
            }
            function startTimer() {
                stopTimer();
                if (paused || hovering || document.hidden || slides.length <= 1) return;
                hero.classList.add('is-playing');
                timer = window.setInterval(function () { show(current + 1); }, 5800);
            }
            var prev = home.querySelector('[data-ebm-prev]');
            var next = home.querySelector('[data-ebm-next]');
            if (prev) prev.addEventListener('click', function () { show(current - 1); startTimer(); });
            if (next) next.addEventListener('click', function () { show(current + 1); startTimer(); });
            if (toggle) toggle.addEventListener('click', function () {
                paused = !paused;
                toggle.textContent = paused ? '▶' : 'Ⅱ';
                toggle.setAttribute('aria-pressed', String(paused));
                toggle.setAttribute('aria-label', paused ? 'Play clinic slideshow' : 'Pause clinic slideshow');
                startTimer();
            });
            if (viewport) {
                viewport.addEventListener('mouseenter', function () { hovering = true; stopTimer(); });
                viewport.addEventListener('mouseleave', function () { hovering = false; startTimer(); });
                viewport.addEventListener('focusin', function () { hovering = true; stopTimer(); });
                viewport.addEventListener('focusout', function (event) { if (!viewport.contains(event.relatedTarget)) { hovering = false; startTimer(); } });
            }
            document.addEventListener('visibilitychange', function () { if (document.hidden) stopTimer(); else startTimer(); });
            show(0); startTimer();

            var reveals = home.querySelectorAll('.ebm-reveal');
            if (!reduced && 'IntersectionObserver' in window) {
                home.classList.add('ebm-motion');
                var observer = new IntersectionObserver(function (items) {
                    items.forEach(function (item) { if (item.isIntersecting) { item.target.classList.add('ebm-in'); observer.unobserve(item.target); } });
                }, { threshold: .07, rootMargin: '0px 0px -25px 0px' });
                Array.prototype.forEach.call(reveals, function (el) { observer.observe(el); });
            }
        }
        if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', initEastBoomHome);
        else initEastBoomHome();
    })();
</script>
</asp:Content>