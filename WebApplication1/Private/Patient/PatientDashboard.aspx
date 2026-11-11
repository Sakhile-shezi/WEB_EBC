<%@ Page Title="Patient Dashboard" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="PatientDashboard.aspx.cs" Inherits="WebApplication1.Private.Patient.PatientDashboard" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
<style>
/* Eastboom Clinic - forest-green patient dashboard */
.pd{--forest:#17392b;--pine:#21513b;--leaf:#2c7652;--mint:#e8f4ed;--text:#1c342d;--muted:#708078;--line:#dfe8e2;--white:#fff;font-family:'Segoe UI',Arial,sans-serif;background:#f6f8f6;color:var(--text);padding:26px 20px 60px;min-height:80vh}
.pd *,.pd *:before,.pd *:after{box-sizing:border-box}
.pd-wrap{max-width:1190px;margin:0 auto}
.pd a:focus-visible,.pd button:focus-visible{outline:3px solid #70c5a1;outline-offset:4px}
.pd-hero{position:relative;isolation:isolate;overflow:hidden;display:flex;align-items:center;justify-content:space-between;gap:24px;flex-wrap:wrap;min-height:210px;margin-bottom:25px;padding:35px 38px;border:1px solid #2e694d;border-radius:16px;background:linear-gradient(112deg,#132b23 0%,#1d4934 57%,#2d7650 100%);box-shadow:0 7px 0 #d9e4dc,0 18px 35px rgba(22,58,39,.13)}
.pd-hero:before{content:'';position:absolute;width:350px;height:350px;right:-125px;top:-135px;border:1px solid rgba(255,255,255,.10);border-radius:50%;box-shadow:0 0 0 57px rgba(255,255,255,.025),0 0 0 115px rgba(255,255,255,.015);pointer-events:none;z-index:-1}
.pd-hero:after{content:'';position:absolute;width:250px;height:250px;right:24%;bottom:-225px;border:1px solid rgba(255,255,255,.05);border-radius:50%;pointer-events:none;z-index:-1}
.pd-eyebrow{display:inline-block;margin:0 0 18px;padding:8px 13px;border-radius:30px;background:rgba(255,255,255,.14);color:#effaf2;font-size:10px;font-weight:750;letter-spacing:.07em}
.pd-hero h1{color:#fff;font-size:clamp(27px,3vw,38px);line-height:1.17;letter-spacing:-.025em;font-weight:730;margin:0 0 10px}
.pd-hero-desc{color:#d6e9dc;font-size:13px;line-height:1.7;margin:0;max-width:510px}
.pd-action{display:inline-flex;align-items:center;gap:10px;justify-content:center;flex-shrink:0;background:#fff;color:#225139!important;text-decoration:none!important;border:1px solid #f0f7f1;border-radius:9px;padding:14px 19px;font-weight:700;font-size:13px;box-shadow:0 4px 0 rgba(11,41,24,.18),0 12px 22px rgba(0,0,0,.10);transition:transform .22s ease,box-shadow .22s ease,background .22s ease}
.pd-action:hover{background:#f0f8f1;transform:translateY(-2px);box-shadow:0 6px 0 rgba(11,41,24,.15),0 15px 25px rgba(0,0,0,.12)}
.pd-action-symbol{font-size:19px;font-weight:500;line-height:1}
.pd-notice{display:block;color:#b32626;font-size:13px;margin-bottom:14px}
.pd-notice:empty{display:none}
.pd-overview{display:grid;grid-template-columns:minmax(0,1.45fr) minmax(300px,.95fr);gap:20px;margin-bottom:20px}
.pd-panel{min-width:0;background:#fff;border:1px solid var(--line);border-radius:14px;padding:24px;box-shadow:0 3px 0 rgba(27,73,45,.045),0 10px 25px rgba(22,55,36,.035)}
.pd-panel h2{font-size:18px;font-weight:720;letter-spacing:-.01em;margin:0 0 6px}
.pd-muted{color:var(--muted);font-size:12px;line-height:1.6;margin:0}
.pd-panel-heading{display:flex;align-items:center;gap:12px}
.pd-symbol{flex:0 0 auto;display:grid;place-items:center;width:42px;height:42px;border:1px solid #d8e9dd;border-radius:11px;background:#edf6ef;color:#296a46}
.pd-symbol svg{width:21px;height:21px;stroke:currentColor;fill:none;stroke-width:1.8;stroke-linecap:round;stroke-linejoin:round}
.pd-contact{display:grid;grid-template-columns:1fr 1fr;gap:12px;margin-top:22px}
.pd-field{min-width:0;padding:14px 15px;border:1px solid #e7eeea;border-radius:10px;background:#fafcfb}
.pd-field-label{display:block;color:#829188;font-size:11px;margin-bottom:7px}
.pd-value{display:block;color:#243e30;font-size:13px;font-weight:690;overflow-wrap:anywhere}
.pd-text-link{color:#256947!important;font-size:12px;text-decoration:none!important;font-weight:700}
.pd-text-link:hover{text-decoration:underline!important}
.pd-profile-link{display:inline-block;margin-top:13px}
.pd-next{padding:20px;margin-top:21px;border:1px solid #d4e7d9;border-left:4px solid #327f52;border-radius:10px;background:linear-gradient(125deg,#eff7f0,#fbfdfb)}
.pd-next strong{display:block;color:#1d4931;font-size:18px;font-weight:750;margin-bottom:9px;line-height:1.4}
.pd-next small{display:block;color:#5b7464;font-size:12px;line-height:1.75}
.pd-next-status{margin-top:14px}
.pd-help{margin-top:15px;color:#718479;font-size:11px;line-height:1.7}
.pd-stats{display:grid;grid-template-columns:repeat(4,minmax(0,1fr));gap:16px;margin-bottom:20px;perspective:1100px}
.pd-stat{position:relative;min-width:0;padding:21px;border:1px solid var(--line);border-radius:13px;background:#fff;box-shadow:0 4px 0 #e0e9e1,0 9px 20px rgba(20,60,37,.04);transform-style:preserve-3d;transition:transform .22s ease,box-shadow .22s ease}
.pd-stat:before{content:'';height:3px;position:absolute;top:0;left:21px;right:21px;background:linear-gradient(90deg,#276e4c,#9dcdb0);border-radius:0 0 4px 4px}
.pd-stat:hover{box-shadow:0 7px 0 #d9e6dc,0 16px 26px rgba(20,60,37,.09)}
.pd-stat-head{display:flex;align-items:center;justify-content:space-between;gap:8px}
.pd-stat-label{font-size:12px;color:#627b6b}
.pd-stat-icon{display:grid;place-items:center;width:34px;height:34px;background:#eef7f0;color:#397c57;border-radius:9px}
.pd-stat-icon svg{height:18px;width:18px;fill:none;stroke:currentColor;stroke-width:1.9;stroke-linecap:round;stroke-linejoin:round}
.pd-stat-value{display:block;margin-top:16px;color:#1d4230;font-size:34px;font-weight:750;line-height:1.1;font-variant-numeric:tabular-nums;transform:translateZ(9px)}
.pd-stat-detail{display:block;margin-top:8px;font-size:11px;color:#829189;line-height:1.5}
.pd-section-head{display:flex;align-items:end;justify-content:space-between;flex-wrap:wrap;gap:14px;margin-bottom:20px}
.pd-table-wrap{overflow-x:auto;border:1px solid var(--line);border-radius:10px}
.pd-table{width:100%;min-width:690px;border-collapse:collapse;font-size:12px}
.pd-table th{background:#f1f7f2;color:#5d7667;font-size:11px;font-weight:700;text-align:left;padding:15px}
.pd-table td{border-top:1px solid #eaf0eb;color:#2c4838;padding:16px 15px;vertical-align:middle}
.pd-table tr:hover td{background:#fbfdfb}
.pd-status{display:inline-flex;align-items:center;gap:7px;padding:6px 11px;border-radius:30px;font-size:11px;font-weight:750;line-height:1.2;white-space:nowrap}
.pd-status:before{content:'';width:6px;height:6px;border-radius:50%;background:currentColor}
.pd-status-scheduled{background:#e5f3e9;border:1px solid #bfdfc9;color:#236b43}
.pd-status-completed{background:#e9f3f7;border:1px solid #c5dce8;color:#2b6c87}
.pd-status-cancelled{background:#f9eded;border:1px solid #e8cece;color:#a64f4f}
.pd-status-other{background:#f1f4f2;border:1px solid #dde6df;color:#5f7367}
.pd-reveal{opacity:1;transform:none}
.pd.js-motion .pd-reveal{animation:pdArrive .6s both}
@keyframes pdArrive{from{opacity:0;transform:translateY(13px)}to{opacity:1;transform:translateY(0)}}
@media(max-width:960px){.pd-overview{grid-template-columns:1fr}.pd-stats{grid-template-columns:repeat(2,minmax(0,1fr))}}
@media(max-width:600px){.pd{padding:13px 11px 40px}.pd-hero{padding:27px 23px;min-height:200px}.pd-action{width:100%}.pd-panel{padding:19px}.pd-contact{grid-template-columns:1fr}.pd-stats{gap:11px}.pd-stat{padding:15px}.pd-stat-value{font-size:29px}.pd-section-head{align-items:start}}
@media(prefers-reduced-motion:reduce){.pd *{animation:none!important;transition:none!important}.pd.js-motion .pd-reveal{animation:none!important}.pd-stat{transform:none!important}}
</style>

<div class="pd" id="patientDashboardRoot"><div class="pd-wrap">
    <header class="pd-hero pd-reveal">
      <div>
        <p class="pd-eyebrow">PIETERMARITZBURG HEALTH SERVICES</p>
        <h1>Patient dashboard</h1>
        <p class="pd-hero-desc">Your appointments, upcoming visits and personal details — all in one place.</p>
      </div>
      <a class="pd-action" href='<%= ResolveUrl("~/Private/Appointments/Appointments.aspx") %>'><span class="pd-action-symbol" aria-hidden="true">+</span> Book an appointment</a>
    </header>

    <asp:Label ID="lblDashboardMessage" runat="server" CssClass="pd-notice" EnableViewState="false" />

    <div class="pd-overview">
      <section class="pd-panel pd-reveal" aria-label="Personal information">
        <div class="pd-panel-heading">
          <span class="pd-symbol" aria-hidden="true"><svg viewBox="0 0 24 24"><circle cx="12" cy="8" r="4"/><path d="M4 21v-2a8 8 0 0 1 16 0v2"/></svg></span>
          <div><h2>Personal information</h2><p class="pd-muted">Details associated with your patient account.</p></div>
        </div>
        <div class="pd-contact">
          <div class="pd-field"><span class="pd-field-label">Full name</span><asp:Label ID="lblPatientName" runat="server" CssClass="pd-value" /></div>
          <div class="pd-field"><span class="pd-field-label">Email address</span><asp:Label ID="lblPatientEmail" runat="server" CssClass="pd-value" /></div>
          <div class="pd-field"><span class="pd-field-label">Contact number</span><asp:Label ID="lblPatientContact" runat="server" CssClass="pd-value" /></div>
          <div class="pd-field"><span class="pd-field-label">Profile status</span><asp:Label ID="lblProfileState" runat="server" CssClass="pd-value" /></div>
        </div>
        <asp:HyperLink ID="lnkCompleteProfile" runat="server" NavigateUrl="~/Private/CompletePatientProfile.aspx" CssClass="pd-text-link pd-profile-link" Visible="false">Complete your profile</asp:HyperLink>
      </section>

      <section class="pd-panel pd-reveal" aria-label="Next appointment">
        <div class="pd-panel-heading">
          <span class="pd-symbol" aria-hidden="true"><svg viewBox="0 0 24 24"><rect x="3" y="5" width="18" height="16" rx="2"/><path d="M7 3v4M17 3v4M3 10h18M8 15l2 2 5-5"/></svg></span>
          <div><h2>Next appointment</h2><p class="pd-muted">Your nearest scheduled clinic visit.</p></div>
        </div>
        <div class="pd-next"><asp:Label ID="lblNextAppointment" runat="server" /></div>
        <p class="pd-help">Need to reschedule or cancel? Please contact clinic reception.</p>
      </section>
    </div>

    <div class="pd-stats" aria-label="Appointment statistics">
      <div class="pd-stat pd-reveal" data-tilt>
        <div class="pd-stat-head"><span class="pd-stat-label">Total appointments</span><span class="pd-stat-icon" aria-hidden="true"><svg viewBox="0 0 24 24"><rect x="3" y="5" width="18" height="16" rx="2"/><path d="M7 3v4M17 3v4M3 10h18"/></svg></span></div>
        <asp:Label ID="lblTotal" runat="server" Text="0" CssClass="pd-stat-value" /><span class="pd-stat-detail">All recorded bookings</span>
      </div>
      <div class="pd-stat pd-reveal" data-tilt>
        <div class="pd-stat-head"><span class="pd-stat-label">Upcoming</span><span class="pd-stat-icon" aria-hidden="true"><svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="9"/><path d="M12 7v5l3 2"/></svg></span></div>
        <asp:Label ID="lblUpcoming" runat="server" Text="0" CssClass="pd-stat-value" /><span class="pd-stat-detail">Scheduled visits ahead</span>
      </div>
      <div class="pd-stat pd-reveal" data-tilt>
        <div class="pd-stat-head"><span class="pd-stat-label">Completed</span><span class="pd-stat-icon" aria-hidden="true"><svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="9"/><path d="m8 12 3 3 5-6"/></svg></span></div>
        <asp:Label ID="lblCompleted" runat="server" Text="0" CssClass="pd-stat-value" /><span class="pd-stat-detail">Marked completed by clinic</span>
      </div>
      <div class="pd-stat pd-reveal" data-tilt>
        <div class="pd-stat-head"><span class="pd-stat-label">Cancelled</span><span class="pd-stat-icon" aria-hidden="true"><svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="9"/><path d="m9 9 6 6m0-6-6 6"/></svg></span></div>
        <asp:Label ID="lblCancelled" runat="server" Text="0" CssClass="pd-stat-value" /><span class="pd-stat-detail">Cancelled bookings</span>
      </div>
    </div>

    <section class="pd-panel pd-reveal" aria-label="Upcoming appointments">
      <div class="pd-section-head">
        <div><h2>Upcoming appointments</h2><p class="pd-muted">Scheduled consultations associated with your signed-in account.</p></div>
        <a class="pd-text-link" href='<%= ResolveUrl("~/Private/Appointments/Appointments.aspx") %>'>View all appointments</a>
      </div>
      <div class="pd-table-wrap">
        <asp:GridView ID="gvUpcomingAppointments" runat="server" AutoGenerateColumns="false" GridLines="None" CssClass="pd-table" DataSourceID="dsUpcomingAppointments" EmptyDataText="You have no upcoming appointments.">
          <Columns>
            <asp:BoundField DataField="AppointmentDate" HeaderText="Date" DataFormatString="{0:dd MMM yyyy}" />
            <asp:BoundField DataField="StartTime" HeaderText="Starts" />
            <asp:BoundField DataField="EndTime" HeaderText="Ends" />
            <asp:BoundField DataField="DoctorName" HeaderText="Doctor" />
            <asp:BoundField DataField="NurseName" HeaderText="Nurse" />
            <asp:BoundField DataField="AppointmentStatus" HeaderText="Status" />
          </Columns>
        </asp:GridView>
      </div>
    </section>
</div></div>

<asp:SqlDataSource
    ID="dsUpcomingAppointments"
    runat="server"
    ConnectionString="<%$ ConnectionStrings:GroupPmb6ConnectionString %>"

    SelectCommand="
    SELECT TOP (10)
        a.AppointmentDate,
        a.TimeSlots,
        a.AppointmentStatus,
        d.FullName AS DoctorName,
        n.FullName AS NurseName,

        LTRIM(RTRIM(LEFT(a.TimeSlots,
            CHARINDEX('-', a.TimeSlots) - 1))) AS StartTime,

        LTRIM(RTRIM(SUBSTRING(a.TimeSlots,
            CHARINDEX('-', a.TimeSlots) + 1,
            LEN(a.TimeSlots)))) AS EndTime

    FROM dbo.Pro_Appointment a

    INNER JOIN dbo.Patient p
        ON a.PatientID = p.PatientID

    LEFT JOIN dbo.Doctor d
        ON a.DoctorID = d.DoctorID

    LEFT JOIN dbo.Nurse n
        ON a.NurseID = n.NurseID

    WHERE p.UserId = @UserId

    AND UPPER(LTRIM(RTRIM(a.AppointmentStatus)))
        = 'SCHEDULED'

    AND CHARINDEX('-', a.TimeSlots) > 0

    AND (
        a.AppointmentDate > CONVERT(date, GETDATE())
        OR (
            a.AppointmentDate = CONVERT(date, GETDATE())
            AND TRY_CONVERT(time,
                LTRIM(RTRIM(SUBSTRING(a.TimeSlots,
                    CHARINDEX('-', a.TimeSlots) + 1,
                    LEN(a.TimeSlots)))))
                > CONVERT(time, GETDATE())
        )
    )

    ORDER BY a.AppointmentDate,
        TRY_CONVERT(time,
            LEFT(a.TimeSlots,
                CHARINDEX('-', a.TimeSlots) - 1))
    ">

    <SelectParameters>
        <asp:Parameter Name="UserId" Type="String" />
    </SelectParameters>

</asp:SqlDataSource>

<script type="text/javascript">
    (function () {
        "use strict";
        function initPatientDashboard() {
            var root = document.getElementById("patientDashboardRoot");
            if (!root) return;
            var reduced = window.matchMedia && window.matchMedia("(prefers-reduced-motion: reduce)").matches;
            if (!reduced && !root.dataset.motionReady) {
                root.dataset.motionReady = "1";
                root.classList.add("js-motion");
                var revealed = root.querySelectorAll(".pd-reveal");
                Array.prototype.forEach.call(revealed, function (el, i) {
                    el.style.animationDelay = Math.min(i * 70, 350) + "ms";
                });
            }
            var table = root.querySelector(".pd-table");
            if (table) {
                var headings = table.querySelectorAll("th"), statusIndex = -1;
                Array.prototype.forEach.call(headings, function (h, i) {
                    if (h.textContent.trim().toLowerCase() === "status") statusIndex = i;
                });
                if (statusIndex >= 0) {
                    Array.prototype.forEach.call(table.querySelectorAll("tr"), function (tr) {
                        var cells = tr.querySelectorAll("td");
                        if (cells.length <= statusIndex) return;
                        var cell = cells[statusIndex];
                        if (cell.querySelector(".pd-status")) return;
                        var status = cell.textContent.trim(), value = status.toLowerCase();
                        if (!status) return;
                        var badge = document.createElement("span");
                        badge.className = "pd-status " +
                            (value === "scheduled" ? "pd-status-scheduled" :
                                value === "completed" ? "pd-status-completed" :
                                    value === "cancelled" ? "pd-status-cancelled" : "pd-status-other");
                        badge.textContent = status;
                        cell.textContent = "";
                        cell.appendChild(badge);
                    });
                }
            }
            // Gentle perspective effect on large-screen pointer devices only.
            var finePointer = window.matchMedia && window.matchMedia("(hover: hover) and (pointer: fine)").matches;
            if (reduced || !finePointer) return;
            Array.prototype.forEach.call(root.querySelectorAll("[data-tilt]"), function (card) {
                if (card.dataset.tiltReady) return;
                card.dataset.tiltReady = "1";
                card.addEventListener("pointermove", function (e) {
                    var b = card.getBoundingClientRect();
                    var dx = ((e.clientX - b.left) / b.width - .5) * 2;
                    var dy = ((e.clientY - b.top) / b.height - .5) * 2;
                    card.style.transform = "perspective(900px) rotateX(" + (-dy * 2.5) + "deg) rotateY(" + (dx * 2.5) + "deg) translateY(-2px)";
                });
                card.addEventListener("pointerleave", function () {
                    card.style.transform = "";
                });
            });
        }
        if (document.readyState === "loading") {
            document.addEventListener("DOMContentLoaded", initPatientDashboard);
        } else {
            initPatientDashboard();
        }
        if (window.Sys && window.Sys.Application) {
            window.Sys.Application.add_load(initPatientDashboard);
        }
    })();
</script>
</asp:Content>
