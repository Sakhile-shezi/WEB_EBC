<%@ Page Title="Book Appointment" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Appointments.aspx.cs" Inherits="WebApplication1.Private.Appointments.Appointments" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
<style>
    /* Eastboom patient portal — scoped to this page so Site.Master is unaffected */
    .eb-booking { --eb-ink:#19283a; --eb-muted:#718092; --eb-line:#e7eaf0; --eb-purple:#7b32db; --eb-teal:#078977; --eb-blue:#346de0; --eb-red:#dc4029; background:#f6f7fc; color:var(--eb-ink); padding:36px 20px 55px; font-family:system-ui,-apple-system,"Segoe UI",Arial,sans-serif; }
    .eb-booking *, .eb-booking *:before, .eb-booking *:after {box-sizing:border-box;}
    .eb-wrap {max-width:1190px; margin:0 auto;}
    .eb-eyebrow {color:#008875; text-transform:uppercase; letter-spacing:.16em; font-size:11px; font-weight:800; margin:0 0 10px;}
    .eb-page-head {display:flex; align-items:flex-end; justify-content:space-between; gap:24px; margin-bottom:25px;}
    .eb-page-head h1 {font-size:34px; line-height:1.13; letter-spacing:-.035em; margin:0 0 8px; font-weight:780;}
    .eb-page-head p {font-size:14px; color:var(--eb-muted); margin:0;}
    .eb-steps-top {display:flex; gap:12px; flex-wrap:wrap; padding-bottom:6px;}
    .eb-step-pill {display:inline-flex; align-items:center; gap:7px; white-space:nowrap; font-size:12px; font-weight:650;}
    .eb-step-pill b,.eb-step-number {display:inline-grid; place-items:center; flex:none; color:white; background:var(--eb-teal); border-radius:7px; width:23px; height:23px; font-size:12px;}
    .eb-step-pill:nth-child(2) b,.eb-step-section.purple .eb-step-number {background:var(--eb-purple);}
    .eb-step-pill:nth-child(3) b,.eb-step-section.blue .eb-step-number {background:var(--eb-blue);}
    .eb-alert {display:flex; align-items:center; gap:14px; background:#fffae6; border:1px solid #f8e9a8; border-radius:13px; padding:16px 19px; margin-bottom:22px; box-shadow:0 3px 10px rgba(36,48,70,.025);}
    .eb-alert-icon {flex:none; width:36px; height:36px; border-radius:9px; background:#fff1b9; color:#ad7814; display:grid; place-items:center; font-size:19px;}
    .eb-alert-copy {flex:1; min-width:0;}
    .eb-alert-copy strong {display:block; font-size:13px; margin-bottom:3px;}
    .eb-alert-copy span {display:block; font-size:12px; color:#786d50;}
    .eb-profile-link {display:inline-flex; justify-content:center; align-items:center; min-height:37px; padding:9px 16px; background:var(--eb-purple); color:#fff!important; text-decoration:none!important; border-radius:9px; font-size:12px; font-weight:750; white-space:nowrap; box-shadow:0 3px 8px rgba(123,50,219,.18);}
    .eb-layout {display:grid; grid-template-columns:minmax(0,1.68fr) minmax(290px,.92fr); gap:20px; align-items:start;}
    .eb-card {background:white; border:1px solid var(--eb-line); border-radius:17px; padding:24px; box-shadow:0 5px 17px rgba(32,54,87,.045); min-width:0;}
    .eb-card h2 {font-size:18px; margin:0 0 5px; font-weight:780; letter-spacing:-.02em;}
    .eb-sub {font-size:12px; color:var(--eb-muted); margin:0;}
    .eb-step-section {margin-top:26px;}
    .eb-step-heading {display:flex; align-items:flex-start; gap:12px; margin-bottom:17px;}
    .eb-step-heading h3 {font-size:14px; font-weight:780; margin:0 0 3px;}
    .eb-step-heading p {font-size:12px; color:var(--eb-muted); margin:0;}
    .eb-datetime {display:grid; grid-template-columns:minmax(0,1fr) minmax(0,1.25fr); gap:18px; align-items:start;}
    .eb-calendar-frame {border:1px solid var(--eb-line); border-radius:12px; padding:10px; min-width:0;}
    .eb-calendar {width:100%; font-size:12px; border-collapse:collapse;}
    .eb-calendar th {font-size:11px; padding:8px 1px; text-align:center; color:#6e7989;}
    .eb-calendar td {padding:5px 2px!important; text-align:center; border:0!important;}
    .eb-calendar a {display:inline-grid; place-items:center; width:29px; height:29px; border-radius:8px; text-decoration:none; font-weight:650; color:#283749;}
    .eb-calendar a:hover {background:#e9f5f2;}
    .eb-calendar .eb-cal-selected a {color:#fff!important; background:var(--eb-teal)!important;}
    .eb-calendar .eb-cal-disabled {color:#c0c5d0!important; background:transparent!important;}
    .eb-cal-legend {display:flex; gap:11px; flex-wrap:wrap; border-top:1px solid var(--eb-line); margin-top:8px; padding-top:10px; color:#808c9b; font-size:10px;}
    .eb-legend-dot {display:inline-block; vertical-align:middle; margin-right:4px; height:7px; width:7px; border-radius:50%; background:var(--eb-teal);}
    .eb-legend-dot.today {background:#d9e7e3; border:1px solid #a7c9c0;}
    .eb-legend-dot.selected {background:#137c70;}
    .eb-selected-date {padding:9px 10px; background:#eaf5f4; border-radius:9px; font-weight:700; font-size:12px; color:#297c76; margin-bottom:12px;}
    .eb-period {font-size:10px; letter-spacing:.11em; color:#7d8696; font-weight:850; margin:13px 0 8px;}
    .eb-time-grid {display:grid; grid-template-columns:repeat(3,minmax(0,1fr)); gap:7px;}
    .eb-slot {border:1px solid #e0e5ee; background:#fff; border-radius:8px; padding:9px 3px; color:#28384a; font-size:11px; font-weight:700; cursor:pointer; text-align:center;}
    .eb-slot:hover {border-color:#118f7e; background:#f2f9f8;}
    .eb-slot.active {border-color:#078977; background:#e1f4ef; color:#006d5c; box-shadow:inset 0 0 0 1px #078977;}
    .eb-empty-slots {padding:16px; color:#7b8795; background:#f6f8fa; border-radius:8px; font-size:12px;}
    .eb-time-help {font-size:11px; color:#84909e; margin:12px 0 0;}
    .eb-time-fallback {width:100%; border:1px solid #d8dfe9; border-radius:8px; padding:10px; margin-bottom:8px;}
    .eb-booking.js-enabled .eb-time-fallback {position:absolute!important; width:1px!important; height:1px!important; padding:0!important; margin:-1px!important; border:0!important; overflow:hidden!important; clip:rect(0,0,0,0)!important; white-space:nowrap!important;}
    .eb-booking.js-enabled .eb-time-fallback:focus {position:static!important; width:100%!important; height:auto!important; clip:auto!important; padding:10px!important; margin:0!important; border:1px solid #d8dfe9!important;}
    .eb-separator {height:1px; background:var(--eb-line); margin:25px 0 0;}
    .eb-field-grid {display:grid; grid-template-columns:1fr 1fr; gap:14px;}
    .eb-label {display:block; font-weight:750; font-size:12px; margin:0 0 9px;}
    .eb-input {width:100%; min-height:42px; padding:11px 12px; border:1px solid #dce3ea; border-radius:9px; background:#fff; color:#253347; font:inherit; font-size:13px; outline:none;}
    .eb-input:focus {border-color:#43a999; box-shadow:0 0 0 3px rgba(14,143,124,.12);}
    .eb-input[readonly] {background:#f8fafc; color:#405166;}
    textarea.eb-input {min-height:110px; resize:vertical;}
    .eb-reason-meta {text-align:right; font-size:11px; color:#8c96a5; margin-top:6px;}
    .eb-sidebar {display:grid; gap:18px;}
    .eb-side-head {display:flex; justify-content:space-between; align-items:center; gap:8px; margin-bottom:13px;}
    .eb-side-head h2 {margin:0; font-size:16px;}
    .eb-status {border-radius:50px; padding:5px 9px; color:#996920; background:#fff2cc; font-size:10px; font-weight:800; white-space:nowrap;}
    .eb-status.complete {color:#056d5b; background:#dbf5e9;}
    .eb-person-row {padding:13px 12px; background:#f9fafc; border:1px solid #f1f3f6; border-radius:10px; margin-bottom:10px; overflow-wrap:anywhere;}
    .eb-person-row .caption {display:block; font-size:10px; color:#8190a1; margin-bottom:4px;}
    .eb-person-row .value {display:block; font-size:12px; font-weight:750;}
    .eb-summary-row {display:grid; grid-template-columns:1fr auto; align-items:center; gap:8px; border-bottom:1px solid var(--eb-line); padding:14px 0; font-size:12px;}
    .eb-summary-row .key {color:#748194;}
    .eb-summary-row .value {text-align:right; font-weight:700; max-width:175px; overflow-wrap:anywhere;}
    .eb-summary-row .value.placeholder {color:#8a96a5; font-style:italic; font-weight:450;}
    .eb-book-button {width:100%; display:block; border:0; border-radius:9px; margin-top:20px; padding:13px 15px; background:var(--eb-red); color:#fff; cursor:pointer; font-size:13px; font-weight:800; box-shadow:0 4px 10px rgba(220,64,41,.14);}
    .eb-book-button:hover {background:#bc3522;}
    .eb-clear {display:block; text-align:center; border:1px solid var(--eb-line); border-radius:9px; padding:11px; color:#526072; margin-top:9px; font-size:12px; font-weight:700; text-decoration:none!important;}
    .eb-clear:hover {background:#f6f8fa; color:#263648;}
    .eb-small-note {color:#84909c; font-size:11px; line-height:1.5; margin:15px 0 0;}
    .eb-booking-message {display:block; font-size:12px; margin:10px 0; font-weight:650;}
    .eb-history {margin-top:20px;}
    .eb-history-head {display:flex; justify-content:space-between; align-items:center; flex-wrap:wrap; gap:12px; margin-bottom:15px;}
    .eb-tabs {display:inline-flex; padding:4px; background:#f1f4f8; border-radius:9px; gap:2px;}
    .eb-tabs button {border:0; background:transparent; color:#6b788a; cursor:pointer; border-radius:7px; padding:8px 12px; font-weight:730; font-size:11px;}
    .eb-tabs button.active {background:#fff; color:#205aaf; box-shadow:0 1px 5px rgba(30,50,80,.1);}
    .eb-table-wrap {overflow-x:auto;}
    .eb-table {border-collapse:collapse; width:100%; min-width:690px; font-size:12px;}
    .eb-table th {background:#f4f6fa; color:#637187; text-align:left; padding:13px 10px; font-size:11px; border-bottom:1px solid var(--eb-line);}
    .eb-table td {padding:13px 10px; border-bottom:1px solid var(--eb-line);}
    .eb-table tr:nth-child(even) td {background:#fbfcfe;}
    .eb-no-history {margin:0; text-align:center; border:1px dashed #dce3ec; border-radius:12px; padding:24px; color:#8290a1; font-size:12px;}
    .eb-booking .eb-table .empty {text-align:center;}
    .eb-foot {display:flex; justify-content:space-between; color:#8995a3; border-top:1px solid #e3e6ee; padding-top:22px; margin-top:30px; font-size:11px; gap:15px;}
    @media(max-width:900px){.eb-layout{grid-template-columns:1fr}.eb-sidebar{grid-template-columns:1fr 1fr}.eb-page-head{align-items:start;flex-direction:column;}}
    @media(max-width:650px){.eb-booking{padding:22px 12px 40px}.eb-card{padding:18px}.eb-datetime,.eb-field-grid,.eb-sidebar{grid-template-columns:1fr}.eb-page-head h1{font-size:28px}.eb-alert{align-items:flex-start;flex-wrap:wrap}.eb-profile-link{margin-left:50px}.eb-foot{flex-direction:column}}



    /* Full-width medical header, fading into the existing booking page */
    .appointment-hero {position:relative; width:100%; min-height:280px; background-position:center 40%; background-size:cover; background-repeat:no-repeat; overflow:hidden;}
    .appointment-hero::before {content:"";position:absolute;inset:0;background:linear-gradient(90deg,rgba(17,35,53,.86) 0%,rgba(17,35,53,.48) 56%,rgba(17,35,53,.12) 100%);}
    .appointment-hero::after {content:"";position:absolute;bottom:0;left:0;right:0;height:125px;background:linear-gradient(to bottom,rgba(246,247,252,0),#f6f7fc);}
    .appointment-hero-content {position:relative;z-index:1;max-width:1190px;min-height:280px;margin:auto;display:flex;flex-direction:column;justify-content:center;padding:30px 20px;color:#fff;}
    .appointment-hero-content h1 {margin:0 0 10px;font-size:clamp(28px,3vw,42px);font-weight:750;}
    .appointment-hero-content p {margin:0;max-width:500px;font-size:16px;line-height:1.5;}
    @media(max-width:650px){.appointment-hero,.appointment-hero-content{min-height:220px}.appointment-hero-content{padding:24px 16px}}



    /* Appointment status row */
.eb-status-row {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 14px 0;
    gap: 12px;
}

/* Scheduled appointment indicator */
.eb-status-scheduled {
    display: inline-flex;
    align-items: center;
    padding: 9px 15px;
    border-radius: 25px;

    background: #fff3e6;
    color: #ea580c;
    border: 1px solid #fb923c;

    font-size: 12px;
    font-weight: 800;
    letter-spacing: 0.4px;

    box-shadow: 0 0 10px rgba(249, 115, 22, 0.4);

    animation: scheduledGlow 2s ease-in-out infinite;
}

@keyframes scheduledGlow {
    0%, 100% {
        box-shadow: 0 0 5px rgba(249, 115, 22, 0.25);
    }

    50% {
        box-shadow:
            0 0 12px rgba(249, 115, 22, 0.65),
            0 0 20px rgba(249, 115, 22, 0.25);
    }
}

@media (prefers-reduced-motion: reduce) {
    .eb-status-scheduled {
        animation: none;
    }
}


    /* =============================================================
       EASTBOOM FOREST GREEN - matches Patient Dashboard
       Presentation-only overrides: existing ASP.NET controls stay intact.
       ============================================================= */
    .eb-booking {
        --eb-ink:#203b35; --eb-muted:#6f817b; --eb-line:#e0e9e4;
        --eb-purple:#27664b; --eb-teal:#176f54; --eb-blue:#337e5e;
        --eb-red:#b84833;
        background:#f6f9f7;
        color:var(--eb-ink);
        padding-top:34px;
    }
    .eb-booking .eb-wrap {max-width:1200px}
    .eb-booking .eb-eyebrow {color:#267455;letter-spacing:.11em}
    .eb-booking .eb-page-head h1 {color:#1d392d;font-size:32px;letter-spacing:-.025em}
    .eb-booking .eb-page-head p {color:#70827b;line-height:1.55}
    .eb-booking .eb-step-pill {color:#3b6150}
    .eb-booking .eb-step-pill b,
    .eb-booking .eb-step-pill:nth-child(2) b,
    .eb-booking .eb-step-pill:nth-child(3) b,
    .eb-booking .eb-step-number,
    .eb-booking .eb-step-section.purple .eb-step-number,
    .eb-booking .eb-step-section.blue .eb-step-number {
        background:#1c704f; color:white; border-radius:7px;
        box-shadow:0 3px 6px rgba(19,72,47,.15);
    }
    .eb-booking .eb-card {
        background:#fff;
        border:1px solid #e0e9e4;
        border-radius:16px;
        box-shadow:0 6px 18px rgba(20,51,36,.045), 0 1px 2px rgba(20,51,36,.025);
        transition:transform .25s ease,box-shadow .25s ease,border-color .25s ease;
    }
    @media (hover:hover) and (pointer:fine) {
        .eb-booking .eb-card:hover {
            transform:translateY(-2px);
            border-color:#cfe0d4;
            box-shadow:0 15px 30px rgba(20,51,36,.09),0 3px 6px rgba(20,51,36,.03);
        }
    }
    .eb-booking .eb-card h2,.eb-booking .eb-step-heading h3 {color:#203b35}
    .eb-booking .eb-sub,.eb-booking .eb-step-heading p {color:#75887e}
    .eb-booking .eb-calendar-frame {border-color:#dae7de;border-radius:12px;background:#fff}
    .eb-booking .eb-calendar a {color:#254739}
    .eb-booking .eb-calendar a:hover {background:#e8f4ec}
    .eb-booking .eb-calendar .eb-cal-selected a {background:#176f54!important;color:#fff!important}
    .eb-booking .eb-selected-date {color:#195e45;background:#e6f3eb}
    .eb-booking .eb-cal-legend {color:#74877b}
    .eb-booking .eb-legend-dot,.eb-booking .eb-legend-dot.selected {background:#176f54}
    .eb-booking .eb-time-grid {gap:8px}
    .eb-booking .eb-slot {
        background:#fff;color:#294b3c;border:1px solid #dce7df;
        border-radius:9px;transition:background .2s ease,transform .2s ease,border-color .2s ease,box-shadow .2s ease;
    }
    .eb-booking .eb-slot:hover {
        background:#f0f7f2;border-color:#4c9773;transform:translateY(-1px);
        box-shadow:0 4px 9px rgba(21,90,57,.07);
    }
    .eb-booking .eb-slot.active {
        background:#e3f2e8;color:#13583d;border-color:#1b7653;
        box-shadow:inset 0 0 0 1px #1b7653,0 3px 8px rgba(21,90,57,.07);
    }
    .eb-booking .eb-input,.eb-booking .eb-time-fallback {color:#244337;border-color:#d9e5dd;background:#fff}
    .eb-booking .eb-input:focus,.eb-booking .eb-time-fallback:focus {
        border-color:#318260;outline:none;box-shadow:0 0 0 3px rgba(43,125,82,.13);
    }
    .eb-booking .eb-input[readonly] {background:#f7faf8;color:#365b49}
    .eb-booking .eb-person-row {background:#f8faf9;border-color:#eaf0ec}
    .eb-booking .eb-person-row .value {color:#254538}
    .eb-booking .eb-summary-row {border-color:#e2ebe5}
    .eb-booking .eb-summary-row .key {color:#70867a}
    .eb-booking .eb-summary-row .value {color:#244438}
    .eb-booking .eb-status.complete {background:#e4f3ea;color:#176842}
    .eb-booking .eb-alert {background:#fffbef;border-color:#eee0b7}
    .eb-booking .eb-profile-link {background:#216c4f;box-shadow:none}
    .eb-booking .eb-profile-link:hover {background:#164e39}
    .eb-booking .eb-book-button {
        background:#1e704f;color:#fff;border-radius:10px;
        box-shadow:0 5px 12px rgba(17,81,51,.16);
        transition:background .2s ease,transform .2s ease,box-shadow .2s ease;
    }
    .eb-booking .eb-book-button:hover {
        background:#145a3e;transform:translateY(-2px);
        box-shadow:0 9px 18px rgba(17,81,51,.2);
    }
    .eb-booking .eb-clear {color:#38624b;border-color:#dce7de}
    .eb-booking .eb-clear:hover {background:#f0f7f2;color:#154d37}
    .eb-booking .eb-tabs {background:#edf4ee}
    .eb-booking .eb-tabs button {color:#61806c}
    .eb-booking .eb-tabs button.active {color:#195e43;box-shadow:0 1px 5px rgba(18,76,44,.10)}
    .eb-booking .eb-table th {background:#f2f7f3;color:#587667}
    .eb-booking .eb-table tr:nth-child(even) td {background:#fafcfb}
    .eb-booking .eb-table tbody tr {transition:background .2s ease}
    .eb-booking .eb-table tbody tr:hover td {background:#f0f7f2}
    .eb-booking .eb-no-history {border-color:#dce9df;color:#708679}
    .eb-booking .eb-foot {border-color:#e0e9e4;color:#849589}
    /* Forest green photo banner with layered depth */
    .appointment-hero {
        background-color:#183b2c;
        min-height:275px;
        box-shadow:inset 0 -8px 20px rgba(12,35,23,.12);
    }
    .appointment-hero::before {
        background:linear-gradient(110deg,rgba(15,42,31,.97) 0%,rgba(25,67,46,.89) 52%,rgba(45,112,76,.66) 100%);
    }
    .appointment-hero::after {
        height:80px;
        background:linear-gradient(to bottom,rgba(246,249,247,0),#f6f9f7);
    }
    .appointment-hero-content {max-width:1200px;padding:34px 20px 52px}
    .appointment-hero-content h1 {
        font-size:clamp(30px,3.2vw,43px);letter-spacing:-.025em;
        text-shadow:0 3px 12px rgba(0,0,0,.12);
    }
    .appointment-hero-content p {color:#e0efe6;font-size:15px}
    .appointment-hero-label {
        display:inline-block;align-self:flex-start;
        background:rgba(255,255,255,.14);color:#fff;
        padding:8px 13px;border-radius:30px;
        font-size:11px;font-weight:800;letter-spacing:.06em;
        margin-bottom:17px;backdrop-filter:blur(3px);
    }
    /* Status shown after a successful database save */
    .eb-booking .eb-status-row {border-top:1px solid #e2ebe5;margin-top:4px}
    .eb-booking .eb-status-scheduled {
        background:#e7f4eb;color:#195d40;border:1px solid #bcdcc8;
        box-shadow:0 2px 7px rgba(19,83,48,.07);
        animation:none;
    }
    .eb-booking .eb-booking-message:empty {display:none}
    .eb-booking .eb-appointment-status:empty {display:none}
    .eb-booking .eb-appointment-status {display:block;margin:10px 0;font-size:12px;font-weight:750}
    /* Polished keyboard accessibility */
    .eb-booking button:focus-visible,.eb-booking a:focus-visible {
        outline:3px solid rgba(36,119,75,.4);outline-offset:2px;
    }
    @media(max-width:650px) {
        .appointment-hero,.appointment-hero-content {min-height:225px}
        .appointment-hero-content {padding:24px 16px 45px}
        .eb-booking .eb-page-head h1 {font-size:28px}
    }
    @media(prefers-reduced-motion:reduce) {
        .eb-booking .eb-card,.eb-booking .eb-slot,.eb-booking .eb-book-button {transition:none!important;transform:none!important}
    }

</style>

<div class="appointment-hero" style="background-image:url('<%= ResolveUrl("~/Images/vitaly-gariev-NDOYHZ_98Rw-unsplash.jpg") %>');">
    <div class="appointment-hero-content">
        <span class="appointment-hero-label">PIETERMARITZBURG HEALTH SERVICES</span>
        <h1>Book an Appointment</h1>
        <p>Eastboom Clinic makes booking simple and convenient.</p>
    </div>
</div>

<div class="eb-booking" id="ebBookingRoot">
<div class="eb-wrap">
    <div class="eb-page-head">
        <div>
            <p class="eb-eyebrow">Appointments</p>
            <h1>Book an appointment</h1>
            <p>Book an appointment at Eastboom Clinic: pick a date, your care team and a time that suits you.</p>
        </div>
        <div class="eb-steps-top" aria-label="Booking steps">
            <span class="eb-step-pill"><b>1</b> Date &amp; time</span>
            <span class="eb-step-pill"><b>2</b> Care team</span>
            <span class="eb-step-pill"><b>3</b> Reason</span>
        </div>
    </div>

    <div id="ebProfileAlert" class="eb-alert" style="display:none">
        <div class="eb-alert-icon" aria-hidden="true">!</div>
        <div class="eb-alert-copy"><strong>Your profile isn’t complete yet</strong><span>You can browse available appointments now. A completed profile is required to confirm a booking.</span></div>
        <a class="eb-profile-link" href='<%= ResolveUrl("~/Private/CompletePatientProfile.aspx") %>'>Complete profile &#8594;</a>
    </div>

    <div class="eb-layout">
        <div class="eb-card">
            <h2>Appointment details</h2>
            <p class="eb-sub">Work through the three steps below. Your choices appear in the booking summary.</p>

            <section class="eb-step-section" aria-label="Choose date and time">
                <div class="eb-step-heading"><span class="eb-step-number">1</span><div><h3>Pick a date and time</h3><p>Weekdays only. Select a doctor and nurse below to see available times.</p></div></div>
                <div class="eb-datetime">
                    <div class="eb-calendar-frame">
                        <asp:Calendar ID="Calendar1BookDate" runat="server" CssClass="eb-calendar"
                            OnSelectionChanged="Calendar1BookDate_SelectionChanged"
                            OnDayRender="Calendar1BookDate_DayRender"
                            BackColor="White" BorderColor="White" BorderWidth="0"
                            ForeColor="#24364b" NextPrevFormat="ShortMonth" SelectionMode="Day">
                            <TitleStyle BackColor="White" ForeColor="#203044" Font-Bold="true" Font-Size="12px" />
                            <DayHeaderStyle ForeColor="#8692a0" Font-Size="10px" />
                            <TodayDayStyle BackColor="#eaf6f2" ForeColor="#0b806d" />
                            <SelectedDayStyle BackColor="#078977" ForeColor="White" CssClass="eb-cal-selected" />
                            <OtherMonthDayStyle ForeColor="#c4cbd5" />
                            <WeekendDayStyle ForeColor="#c4cbd5" />
                        </asp:Calendar>
                        <div class="eb-cal-legend"><span><i class="eb-legend-dot today"></i>Today</span><span><i class="eb-legend-dot selected"></i>Selected</span><span>Weekdays available</span></div>
                    </div>
                    <div>
                        <div class="eb-selected-date">&#128197; <%= Calendar1BookDate.SelectedDate == DateTime.MinValue ? "Choose a date" : Calendar1BookDate.SelectedDate.ToString("dddd, d MMMM yyyy", System.Globalization.CultureInfo.InvariantCulture) %></div>
                        <!-- The real ASP.NET DropDownList remains the source of truth for selected time values. -->
                        <label class="eb-label" for="<%= ddlTimeSlot.ClientID %>">Start time</label>
                        <asp:DropDownList ID="ddlTimeSlot" runat="server" CssClass="eb-time-fallback" aria-label="Start time" AutoPostBack="true" OnSelectedIndexChanged="StartTimeSelectionChanged">
                            <asp:ListItem Text="-- Select Start Time --" Value="" />
                        </asp:DropDownList>
                        <div id="ebTimeTiles" aria-live="polite"></div>
                        <label class="eb-label" for="<%= ddlEndTime.ClientID %>" style="margin-top:15px">End time</label>
                        <asp:DropDownList ID="ddlEndTime" runat="server" CssClass="eb-input" aria-label="End time">
                            <asp:ListItem Text="-- Select End Time --" Value="" />
                        </asp:DropDownList>
                        <p class="eb-time-help">Only times available to your selected doctor, nurse and patient will be shown. Lunch is 12:00–13:00.</p>
                    </div>
                </div>
            </section>

            <div class="eb-separator"></div>
            <section class="eb-step-section purple" aria-label="Choose your care team">
                <div class="eb-step-heading"><span class="eb-step-number">2</span><div><h3>Choose your care team</h3><p>Select the doctor and nurse for this visit. Available times refresh automatically.</p></div></div>
                <div class="eb-field-grid">
                    <div><label class="eb-label" for="<%= ddlDoctor.ClientID %>">Doctor</label>
                        <asp:DropDownList ID="ddlDoctor" runat="server" CssClass="eb-input" DataSourceID="SqlDataSourceDoctors" DataTextField="FullName" DataValueField="DoctorID" AppendDataBoundItems="true" AutoPostBack="true" OnSelectedIndexChanged="BookingSelectionChanged">
                            <asp:ListItem Text="-- Select Doctor --" Value="" />
                        </asp:DropDownList>
                    </div>
                    <div><label class="eb-label" for="<%= ddlNurse.ClientID %>">Nurse</label>
                        <asp:DropDownList ID="ddlNurse" runat="server" CssClass="eb-input" DataSourceID="SqlDataSourceNurses" DataTextField="FullName" DataValueField="NurseID" AppendDataBoundItems="true" AutoPostBack="true" OnSelectedIndexChanged="BookingSelectionChanged">
                            <asp:ListItem Text="-- Select Nurse --" Value="" />
                        </asp:DropDownList>
                    </div>
                </div>
            </section>

            <div class="eb-separator"></div>
            <section class="eb-step-section blue" aria-label="Appointment reason">
                <div class="eb-step-heading"><span class="eb-step-number">3</span><div><h3>Reason for appointment</h3><p>Tell us briefly what you would like to be seen for.</p></div></div>
                <label class="eb-label" for="<%= txtAppointmentReason.ClientID %>">Reason</label>
                <asp:TextBox ID="txtAppointmentReason" runat="server" CssClass="eb-input" TextMode="MultiLine" Rows="4" MaxLength="100" placeholder="e.g. Check-up, follow-up visit or new symptoms" />
                <div class="eb-reason-meta"><span id="ebReasonCount">0</span> / 100</div>
            </section>
        </div>

        <aside class="eb-sidebar">
            <div class="eb-card">
                <div class="eb-side-head"><h2>Patient information</h2><span id="ebProfileStatus" class="eb-status">Incomplete</span></div>
                <div class="eb-person-row"><span class="caption">Patient name</span><asp:TextBox ID="txtPatientName" runat="server" ReadOnly="true" CssClass="eb-input" style="font-weight:750" /></div>
                <div class="eb-person-row"><span class="caption">Email address</span><asp:TextBox ID="txtPatientEmail" runat="server" ReadOnly="true" CssClass="eb-input" /></div>
            </div>
            <div class="eb-card">
                <h2>Booking summary</h2>
                <div class="eb-summary-row"><span class="key">Date</span><span class="value"><%= Calendar1BookDate.SelectedDate == DateTime.MinValue ? "Not selected" : Calendar1BookDate.SelectedDate.ToString("ddd, d MMM yyyy", System.Globalization.CultureInfo.InvariantCulture) %></span></div>
                <div class="eb-summary-row"><span class="key">Start time</span><span id="ebSummaryTime" class="value placeholder">Not selected</span></div>
                <div class="eb-summary-row"><span class="key">End time</span><span id="ebSummaryEnd" class="value placeholder">Not selected</span></div>
                <div class="eb-summary-row"><span class="key">Doctor</span><span id="ebSummaryDoctor" class="value placeholder">Not selected</span></div>
                <div class="eb-summary-row"><span class="key">Nurse</span><span id="ebSummaryNurse" class="value placeholder">Not selected</span></div>
                <asp:Label ID="lblBookingMessage" runat="server" CssClass="eb-booking-message" EnableViewState="false" />
                <asp:Label ID="lblAppointmentStatus" runat="server" Text="" CssClass="eb-appointment-status" />
                <asp:Button ID="Button1BookAppointement" runat="server" Text="Book now  →" CssClass="eb-book-button" OnClick="Button1BookAppointement_Click" />
                <a class="eb-clear" href='<%= ResolveUrl("~/Private/Appointments/Appointments.aspx") %>'>Clear selections</a>
                <p id="ebProfileSummaryNote" class="eb-small-note">A completed profile is required to confirm a booking.</p>
            </div>
        </aside>
    </div>

    <div class="eb-card eb-history">
        <div class="eb-history-head"><h2>My appointments</h2><div class="eb-tabs" aria-label="Appointment history filter"><button type="button" data-eb-filter="all" class="active">All</button><button type="button" data-eb-filter="upcoming">Upcoming</button><button type="button" data-eb-filter="past">Past</button></div></div>
        <div class="eb-table-wrap">
            <asp:GridView ID="GridViewMyAppointments" runat="server" AutoGenerateColumns="False" DataSourceID="SqlDataSourceMyAppointments" CssClass="eb-table" GridLines="None" EmptyDataText="You have no appointments yet.">
                <Columns>
                    <asp:BoundField DataField="AppointmentID" HeaderText="Booking #" />
                    <asp:BoundField DataField="DoctorName" HeaderText="Doctor" />
                    <asp:BoundField DataField="NurseName" HeaderText="Nurse" />
                    <asp:BoundField DataField="AppointmentDate" HeaderText="Date" DataFormatString="{0:dd MMM yyyy}" />
                    <asp:BoundField DataField="TimeSlots" HeaderText="Time" />
                    <asp:BoundField DataField="AppointmentStatus" HeaderText="Status" />
                    <asp:BoundField DataField="AppointmentReason" HeaderText="Reason" />
                </Columns>
            </asp:GridView>
        </div>
        <p id="ebFilteredEmpty" class="eb-no-history" style="display:none">No appointments match this filter.</p>
    </div>
    <div class="eb-foot"><span>© 2026 Eastboom Clinic</span><span>Need help with a booking? Contact the clinic reception.</span></div>
</div>
</div>

<!-- Retained datasources and parameter names: these must stay aligned with Appointments.aspx.cs -->
<asp:SqlDataSource ID="SqlDataSourceDoctors" runat="server" ConnectionString="<%$ ConnectionStrings:GroupPmb6ConnectionString %>" SelectCommand="SELECT DoctorID, FullName FROM dbo.Doctor ORDER BY FullName" />
<asp:SqlDataSource ID="SqlDataSourceNurses" runat="server" ConnectionString="<%$ ConnectionStrings:GroupPmb6ConnectionString %>" SelectCommand="SELECT NurseID, FullName FROM dbo.Nurse ORDER BY FullName" />
<asp:SqlDataSource ID="SqlDataSourceMyAppointments" runat="server"
    ConnectionString="<%$ ConnectionStrings:GroupPmb6ConnectionString %>"
    SelectCommand="SELECT a.AppointmentID, d.FullName AS DoctorName, n.FullName AS NurseName,
                   a.AppointmentDate, a.TimeSlots, a.AppointmentStatus, a.AppointmentReason
                   FROM dbo.Pro_Appointment a
                   INNER JOIN dbo.Patient p ON a.PatientID = p.PatientID
                   LEFT JOIN dbo.Doctor d ON a.DoctorID = d.DoctorID
                   LEFT JOIN dbo.Nurse n ON a.NurseID = n.NurseID
                   WHERE p.UserId = @UserId
                   ORDER BY a.AppointmentDate DESC, a.AppointmentID DESC">
    <SelectParameters><asp:Parameter Name="UserId" Type="String" /></SelectParameters>
</asp:SqlDataSource>

<asp:SqlDataSource
    ID="SqlDataSourceInsertAppointment"
    runat="server"
    ConnectionString="<%$ ConnectionStrings:GroupPmb6ConnectionString %>"
    InsertCommand="INSERT INTO Pro_Appointment
(
    PatientID,
    DoctorID,
    NurseID,
    AppointmentReason,
    TimeSlots,
    AppointmentStatus,
    AppointmentDate
)
VALUES
(
    @patientID,
    @doctorID,
    @nurseID,
    @appointmentReason,
    @timeslots,
    'Scheduled',
    @appointmentDate
)"
    OnInserted="SqlDataSourceInsertAppointment_Inserted" SelectCommand="SELECT [AppointmentID], [PatientID], [DoctorID], [NurseID], [AppointmentReason], [TimeSlots] FROM [Pro_Appointment]">
    <InsertParameters>
        <asp:Parameter Name="patientID" />
        <asp:ControlParameter ControlID="ddlDoctor" Name="doctorID" PropertyName="SelectedValue" />
        <asp:ControlParameter ControlID="ddlNurse" Name="nurseID" PropertyName="SelectedValue" />
        <asp:Parameter Name="appointmentReason" />
        <asp:Parameter Name="timeslots" />
        <asp:ControlParameter ControlID="Calendar1BookDate" Name="appointmentDate" PropertyName="SelectedDate" />
    </InsertParameters>

</asp:SqlDataSource>


<script>
    (function () {
        function initializeEastboomUI() {
            var root = document.getElementById('ebBookingRoot');
            if (!root) return;
            root.classList.add('js-enabled');
            var timeSelect = document.getElementById('<%= ddlTimeSlot.ClientID %>');
        var endSelect = document.getElementById('<%= ddlEndTime.ClientID %>');
        var doctor = document.getElementById('<%= ddlDoctor.ClientID %>');
        var nurse = document.getElementById('<%= ddlNurse.ClientID %>');
        var reason = document.getElementById('<%= txtAppointmentReason.ClientID %>');
        var name = document.getElementById('<%= txtPatientName.ClientID %>');
        var timeTiles = document.getElementById('ebTimeTiles');
        var timeSummary = document.getElementById('ebSummaryTime');
        function setSummary(id, select, missing) {
            var element = document.getElementById(id);
            if (!element || !select) return;
            var value = select.value && select.selectedIndex >= 0 ? select.options[select.selectedIndex].text : '';
            element.textContent = value || missing;
            element.classList.toggle('placeholder', !value);
        }
        function updateSummary() {
            setSummary('ebSummaryDoctor', doctor, 'Not selected');
            setSummary('ebSummaryNurse', nurse, 'Not selected');

            var startText = (timeSelect && timeSelect.value && timeSelect.selectedIndex >= 0)
                ? timeSelect.options[timeSelect.selectedIndex].text : '';
            if (timeSummary) {
                timeSummary.textContent = startText || 'Not selected';
                timeSummary.classList.toggle('placeholder', !startText);
            }

            var endSummary = document.getElementById('ebSummaryEnd');
            var endText = (endSelect && endSelect.value && endSelect.selectedIndex >= 0)
                ? endSelect.options[endSelect.selectedIndex].text : '';
            if (endSummary) {
                endSummary.textContent = endText || 'Not selected';
                endSummary.classList.toggle('placeholder', !endText);
            }

            var reasonCount = document.getElementById('ebReasonCount');
            if (reason && reasonCount) reasonCount.textContent = String(reason.value.length);
        }
        function renderTimes() {
            if (!timeSelect || !timeTiles) return;
            timeTiles.innerHTML = '';
            var choices = Array.prototype.filter.call(timeSelect.options, function (o) { return !!o.value; });
            if (!choices.length) {
                var empty = document.createElement('p');
                empty.className = 'eb-empty-slots';
                empty.textContent = (!doctor.value || !nurse.value)
                    ? 'Choose a doctor and nurse below to see available times.'
                    : 'No available times for this selection. Try another date or care team.';
                timeTiles.appendChild(empty);
                return;
            }
            [['Morning', 'morning'], ['Afternoon', 'afternoon']].forEach(function (period) {
                var periodChoices = choices.filter(function (o) {
                    var start = (o.value.split('-')[0] || '').trim();
                    var isMorning = /AM$/i.test(start) || (!/PM$/i.test(start) && parseInt(start, 10) < 12);
                    return period[1] === 'morning' ? isMorning : !isMorning;
                });
                if (!periodChoices.length) return;
                var heading = document.createElement('div');
                heading.className = 'eb-period'; heading.textContent = period[0];
                timeTiles.appendChild(heading);
                var grid = document.createElement('div'); grid.className = 'eb-time-grid';
                periodChoices.forEach(function (o) {
                    var button = document.createElement('button');
                    button.type = 'button';
                    button.className = 'eb-slot' + (timeSelect.value === o.value ? ' active' : '');
                    button.textContent = (o.value.split('-')[0] || o.text).trim();
                    button.setAttribute('aria-label', o.text);
                    button.setAttribute('aria-pressed', timeSelect.value === o.value ? 'true' : 'false');
                    button.addEventListener('click', function () {
                        timeSelect.value = o.value;
                        // Server loads the end times valid for the new start time.
                        timeSelect.dispatchEvent(new Event('change', { bubbles: true }));
                        Array.prototype.forEach.call(grid.parentNode.querySelectorAll('.eb-slot'), function (b) {
                            b.classList.remove('active'); b.setAttribute('aria-pressed', 'false');
                        });
                        button.classList.add('active'); button.setAttribute('aria-pressed', 'true');
                        updateSummary();
                    });
                    grid.appendChild(button);
                });
                timeTiles.appendChild(grid);
            });
        }
        if (reason) {
            reason.addEventListener('input', function () {
                if (reason.value.length > 100) reason.value = reason.value.substring(0, 100);
                updateSummary();
            });
        }
        if (timeSelect) timeSelect.addEventListener('change', updateSummary);
        if (endSelect) endSelect.addEventListener('change', updateSummary);
        if (doctor) doctor.addEventListener('change', updateSummary);
        if (nurse) nurse.addEventListener('change', updateSummary);
        var incomplete = !name || !name.value.trim() || /profile not completed/i.test(name.value);
        var alert = document.getElementById('ebProfileAlert');
        var status = document.getElementById('ebProfileStatus');
        if (alert) alert.style.display = incomplete ? 'flex' : 'none';
        if (status) { status.textContent = incomplete ? 'Incomplete' : 'Profile linked'; status.classList.toggle('complete', !incomplete); }
        var note = document.getElementById('ebProfileSummaryNote');
        if (note && !incomplete) note.textContent = 'Your profile is linked. Booking will be validated when you confirm.';
        renderTimes(); updateSummary();

        // Client-side display filters only. Server-side UserId filter stays authoritative.
        var tabs = root.querySelectorAll('[data-eb-filter]');
        var table = document.getElementById('<%= GridViewMyAppointments.ClientID %>');
            var emptyNote = document.getElementById('ebFilteredEmpty');
            function filterHistory(filter) {
                if (!table || !table.rows || table.rows.length <= 1) return;
                var today = new Date(); today.setHours(0, 0, 0, 0);
                var shown = 0;
                Array.prototype.forEach.call(table.rows, function (tr, index) {
                    if (index === 0 || !tr.cells || tr.cells.length < 7) return;
                    var date = new Date(tr.cells[3].textContent.trim());
                    var statusText = tr.cells[5].textContent.trim().toLowerCase();
                    var past = !isNaN(date.getTime()) && (date < today || statusText === 'completed' || statusText === 'cancelled');
                    var visible = filter === 'all' || (filter === 'past' ? past : !past);
                    tr.style.display = visible ? '' : 'none';
                    if (visible) shown++;
                });
                if (emptyNote) emptyNote.style.display = shown ? 'none' : 'block';
            }
            Array.prototype.forEach.call(tabs, function (tab) {
                tab.addEventListener('click', function () {
                    Array.prototype.forEach.call(tabs, function (t) { t.classList.remove('active'); });
                    tab.classList.add('active'); filterHistory(tab.getAttribute('data-eb-filter'));
                });
            });
        }
        if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', initializeEastboomUI);
        else initializeEastboomUI();
    })();
</script>
</asp:Content>
