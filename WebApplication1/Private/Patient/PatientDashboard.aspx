<%@ Page Title="Patient Dashboard" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="PatientDashboard.aspx.cs" Inherits="WebApplication1.Private.Patient.PatientDashboard" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
<style>
.pd {font-family:"Segoe UI",Arial,sans-serif;background:#f7f9f9;color:#233747;padding:36px 22px 55px;min-height:80vh;}
.pd *, .pd *:before, .pd *:after {box-sizing:border-box}
.pd-wrap {max-width:1180px;margin:auto}
.pd-top {display:flex;align-items:end;justify-content:space-between;gap:18px;flex-wrap:wrap;margin-bottom:27px}
.pd-kicker {color:#1f7773;text-transform:uppercase;letter-spacing:.11em;font-size:11px;font-weight:700;margin:0 0 8px}
.pd h1 {font-size:30px;line-height:1.2;font-weight:650;margin:0 0 8px}
.pd-lead,.pd-muted {color:#6b7d88;font-size:13px;margin:0}
.pd-action {display:inline-block;background:#146b69;color:#fff!important;text-decoration:none!important;border-radius:6px;padding:12px 18px;font-size:13px;font-weight:600}
.pd-action:hover {background:#0d5452}
.pd-panel {background:white;border:1px solid #dce5e9;border-radius:10px;padding:23px;box-shadow:0 3px 9px rgba(25,55,65,.025)}
.pd-panel h2 {font-size:18px;margin:0 0 7px;font-weight:650}
.pd-overview {display:grid;grid-template-columns:minmax(0,1.5fr) minmax(260px,.85fr);gap:20px;margin-bottom:20px}
.pd-contact {display:grid;grid-template-columns:1fr 1fr;gap:16px 24px;margin-top:24px}
.pd-field {min-width:0}.pd-field-label {display:block;font-size:11px;color:#75848e;margin-bottom:6px}
.pd-value {font-size:14px;font-weight:600;overflow-wrap:anywhere}
.pd-profile-state {display:inline-block;margin-top:16px;background:#ebf5f2;color:#1b6e57;border-radius:5px;padding:7px 10px;font-size:12px}
.pd-pending {background:#fff5e4;color:#8a6523}
.pd-next {background:#f4f8f8;border-left:3px solid #146b69;padding:16px;margin-top:18px;border-radius:4px}
.pd-next strong {display:block;margin-bottom:6px;font-size:16px}
.pd-next small {font-size:12px;color:#627983}
.pd-stats {display:grid;grid-template-columns:repeat(4,minmax(0,1fr));gap:16px;margin-bottom:21px}
.pd-stat {padding:22px;background:#fff;border:1px solid #dce5e9;border-radius:9px}
.pd-stat-label {display:block;color:#677b84;font-size:12px;margin-bottom:12px}
.pd-stat-value {display:block;font-size:31px;font-weight:650;color:#1d464d}
.pd-stat-detail {display:block;color:#81919a;font-size:11px;margin-top:8px}
.pd-section-head {display:flex;align-items:end;justify-content:space-between;gap:15px;margin-bottom:18px;flex-wrap:wrap}
.pd-text-link {font-size:13px;color:#166e6a!important;text-decoration:none!important;font-weight:600}
.pd-table-wrap {overflow-x:auto}
.pd-table {border-collapse:collapse;width:100%;min-width:720px;font-size:13px}
.pd-table th {text-align:left;background:#f5f8f9;border-bottom:1px solid #dce5e9;color:#5b7280;font-size:12px;padding:13px}
.pd-table td {border-bottom:1px solid #e6ecee;padding:14px 13px;color:#314857;vertical-align:middle}
.pd-table tr:last-child td {border-bottom:0}
.pd-empty {padding:28px;text-align:center;color:#687984}
.pd-help {margin-top:20px;color:#6c7e87;font-size:12px}
@media(max-width:900px){.pd-overview{grid-template-columns:1fr}.pd-stats{grid-template-columns:repeat(2,1fr)}}
@media(max-width:590px){.pd{padding:24px 12px 36px}.pd h1{font-size:26px}.pd-panel{padding:18px}.pd-contact{grid-template-columns:1fr}.pd-stats{gap:10px}.pd-stat{padding:16px}.pd-stat-value{font-size:27px}}
</style>
<div class="pd"><div class="pd-wrap">
    <div class="pd-top">
        <div><p class="pd-kicker">Eastboom Clinic / Patient portal</p><h1>Patient dashboard</h1><p class="pd-lead">Your appointments and contact information in one place.</p></div>
        <a class="pd-action" href='<%= ResolveUrl("~/Private/Appointments/Appointments.aspx") %>'>Book an appointment</a>
    </div>
    <asp:Label ID="lblDashboardMessage" runat="server" ForeColor="#a33b2c" EnableViewState="false" />
    <div class="pd-overview">
        <section class="pd-panel" aria-label="Personal information">
            <h2>Personal information</h2><p class="pd-muted">Only the contact details relevant to your account are displayed.</p>
            <div class="pd-contact">
                <div class="pd-field"><span class="pd-field-label">Full name</span><asp:Label ID="lblPatientName" runat="server" CssClass="pd-value" /></div>
                <div class="pd-field"><span class="pd-field-label">Email address</span><asp:Label ID="lblPatientEmail" runat="server" CssClass="pd-value" /></div>
                <div class="pd-field"><span class="pd-field-label">Contact number</span><asp:Label ID="lblPatientContact" runat="server" CssClass="pd-value" /></div>
                <div class="pd-field"><span class="pd-field-label">Profile</span><asp:Label ID="lblProfileState" runat="server" CssClass="pd-value" /></div>
            </div>
            <asp:HyperLink ID="lnkCompleteProfile" runat="server" NavigateUrl="~/Private/CompletePatientProfile.aspx" CssClass="pd-text-link" Visible="false">Complete your profile</asp:HyperLink>
        </section>
        <section class="pd-panel" aria-label="Next appointment">
            <h2>Next appointment</h2><p class="pd-muted">Your nearest scheduled visit.</p>
            <div class="pd-next"><asp:Label ID="lblNextAppointment" runat="server" /></div>
            <div class="pd-help">If you need to change a booking, contact clinic reception.</div>
        </section>
    </div>
    <div class="pd-stats" aria-label="Appointment statistics">
        <div class="pd-stat"><span class="pd-stat-label">Total appointments</span><asp:Label ID="lblTotal" runat="server" Text="0" CssClass="pd-stat-value" /><span class="pd-stat-detail">All recorded bookings</span></div>
        <div class="pd-stat"><span class="pd-stat-label">Upcoming</span><asp:Label ID="lblUpcoming" runat="server" Text="0" CssClass="pd-stat-value" /><span class="pd-stat-detail">Scheduled future visits</span></div>
        <div class="pd-stat"><span class="pd-stat-label">Completed</span><asp:Label ID="lblCompleted" runat="server" Text="0" CssClass="pd-stat-value" /><span class="pd-stat-detail">Marked completed by clinic</span></div>
        <div class="pd-stat"><span class="pd-stat-label">Cancelled</span><asp:Label ID="lblCancelled" runat="server" Text="0" CssClass="pd-stat-value" /><span class="pd-stat-detail">Cancelled bookings</span></div>
    </div>
    <section class="pd-panel" aria-label="Upcoming appointments">
        <div class="pd-section-head"><div><h2>Upcoming appointments</h2><p class="pd-muted">Appointments associated with your signed-in patient account.</p></div><a class="pd-text-link" href='<%= ResolveUrl("~/Private/Appointments/Appointments.aspx") %>'>View all appointments</a></div>
        <div class="pd-table-wrap">
            <asp:GridView ID="gvUpcomingAppointments" runat="server" AutoGenerateColumns="false" GridLines="None" CssClass="pd-table" DataSourceID="dsUpcomingAppointments" EmptyDataText="You have no upcoming appointments.">
                <Columns>
                    <asp:BoundField DataField="Appointment_ID" HeaderText="Booking #" />
                    <asp:BoundField DataField="Appointment_Date" HeaderText="Date" DataFormatString="{0:dd MMM yyyy}" HtmlEncode="false" />
                    <asp:BoundField DataField="StartTime" HeaderText="Starts" />
                    <asp:BoundField DataField="EndTime" HeaderText="Ends" />
                    <asp:BoundField DataField="DoctorName" HeaderText="Doctor" />
                    <asp:BoundField DataField="NurseName" HeaderText="Nurse" />
                    <asp:BoundField DataField="Appointment_Status" HeaderText="Status" />
                </Columns>
            </asp:GridView>
        </div>
    </section>
</div></div>
<asp:SqlDataSource ID="dsUpcomingAppointments" runat="server"
    ConnectionString="<%$ ConnectionStrings:GroupPmb6ConnectionString %>"
    SelectCommand="SELECT TOP (10) a.Appointment_ID, a.Appointment_Date, a.StartTime, a.EndTime, a.Appointment_Status, d.FullName AS DoctorName, n.FullName AS NurseName FROM dbo.Appointment a INNER JOIN dbo.Patient p ON a.Patient_ID=p.PatientID LEFT JOIN dbo.Doctor d ON a.Doctor_ID=d.DoctorID LEFT JOIN dbo.Nurse n ON a.Nurse_ID=n.NurseID WHERE p.UserId=@UserId AND UPPER(LTRIM(RTRIM(ISNULL(a.Appointment_Status,'')))) NOT IN ('CANCELLED','COMPLETED') AND (a.Appointment_Date > CONVERT(date,GETDATE()) OR (a.Appointment_Date=CONVERT(date,GETDATE()) AND TRY_CONVERT(time,a.EndTime)>CONVERT(time,GETDATE()))) ORDER BY a.Appointment_Date, TRY_CONVERT(time,a.StartTime), a.Appointment_ID">
    <SelectParameters><asp:Parameter Name="UserId" Type="String" /></SelectParameters>
</asp:SqlDataSource>
</asp:Content>
