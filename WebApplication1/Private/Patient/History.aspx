<%@ Page Title="My History" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" MaintainScrollPositionOnPostback="true" CodeBehind="History.aspx.cs" Inherits="WebApplication1.Private.Patient.History" %>
<%@ Register Src="~/Controls/ReceiptViewer.ascx" TagPrefix="eb" TagName="ReceiptViewer" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
<style>
    /* Eastboom Clinic - patient history, same forest-green look as the dashboard and booking page */
    .ph {font-family:system-ui,-apple-system,"Segoe UI",Arial,sans-serif;background:#f6f9f7;color:#203b35;padding:26px 20px 60px;min-height:80vh}
    .ph *,.ph *:before,.ph *:after {box-sizing:border-box}
    .ph-wrap {max-width:1200px;margin:0 auto}
    .ph-hero {display:flex;align-items:center;justify-content:space-between;gap:24px;flex-wrap:wrap;margin-bottom:22px;padding:30px 34px;border:1px solid #2e694d;border-radius:16px;background:linear-gradient(112deg,#132b23 0%,#1d4934 57%,#2d7650 100%);box-shadow:0 18px 35px rgba(22,58,39,.13);color:#fff}
    .ph-eyebrow {display:inline-block;margin:0 0 12px;padding:7px 13px;border-radius:30px;background:rgba(255,255,255,.14);font-size:10px;font-weight:750;letter-spacing:.07em}
    .ph-hero h1 {margin:0 0 6px;font-size:30px;font-weight:750;letter-spacing:-.025em;color:#fff}
    .ph-hero p {margin:0;color:#e0efe6;font-size:14px}
    .ph-book {display:inline-block;padding:11px 18px;border-radius:10px;background:#fff;color:#17392b!important;font-size:13px;font-weight:750;text-decoration:none!important}
    .ph-book:hover {background:#e8f4ed}
    .ph-card {background:#fff;border:1px solid #e0e9e4;border-radius:16px;padding:24px;box-shadow:0 6px 18px rgba(20,51,36,.045),0 1px 2px rgba(20,51,36,.025)}
    .ph-card h2 {font-size:18px;margin:0 0 4px;font-weight:780;letter-spacing:-.02em}
    .ph-sub {font-size:12px;color:#75887e;margin:0 0 16px}
    .ph-table-wrap {overflow-x:auto}
    .ph-table {border-collapse:collapse;width:100%;min-width:720px;font-size:12px}
    .ph-table th {background:#f2f7f3;color:#587667;text-align:left;padding:13px 10px;font-size:11px;border-bottom:1px solid #e0e9e4}
    .ph-table td {padding:13px 10px;border-bottom:1px solid #e0e9e4;vertical-align:middle}
    .ph-table tr:nth-child(even) td {background:#fafcfb}
    .ph-table tr:hover td {background:#f0f7f2}
    .ph-status {display:inline-block;padding:4px 10px;border-radius:50px;font-size:11px;font-weight:750;white-space:nowrap;background:#eef1f0;color:#55675f}
    .ph-status.scheduled {background:#e4f3ea;color:#176842}
    .ph-status.cancelled {background:#fbe9e5;color:#a23a27}
    .ph-view {display:inline-block;padding:6px 13px;border:1px solid #1b7653;border-radius:8px;color:#13583d;background:#fff;font-size:11px;font-weight:750;text-decoration:none!important;white-space:nowrap}
    .ph-view:hover {background:#1e704f;color:#fff}
    .ph-empty td {text-align:center;padding:26px!important;color:#708679;background:#fff!important}
    .ph-message {display:block;font-size:12px;font-weight:700;margin-bottom:12px}
    .ph-message:empty {display:none}
    @media(max-width:650px){.ph{padding:18px 12px 40px}.ph-hero{padding:22px}.ph-hero h1{font-size:25px}.ph-card{padding:18px}}
</style>

<div class="ph">
<div class="ph-wrap">
    <div class="ph-hero">
        <div>
            <span class="ph-eyebrow">MY HISTORY</span>
            <h1>Appointments and receipts</h1>
            <p>Every appointment you have booked, newest first. Each one has a receipt you can view, print or email.</p>
        </div>
        <a class="ph-book" href='<%= ResolveUrl("~/Private/Appointments/Appointments.aspx") %>'>Book an appointment &#8594;</a>
    </div>

    <div class="ph-card">
        <h2>My appointments</h2>
        <p class="ph-sub">Ordered by appointment date. Press View to open the receipt for a booking.</p>
        <asp:Label ID="lblHistoryMessage" runat="server" CssClass="ph-message" EnableViewState="false" />
        <div class="ph-table-wrap">
            <asp:GridView ID="GridViewHistory" runat="server" AutoGenerateColumns="False" DataSourceID="SqlDataSourceHistory"
                CssClass="ph-table" GridLines="None" OnRowCommand="GridViewHistory_RowCommand"
                EmptyDataText="You have no appointments yet.">
                <EmptyDataRowStyle CssClass="ph-empty" />
                <Columns>
                    <asp:BoundField DataField="AppointmentDate" HeaderText="Date" DataFormatString="{0:ddd, dd MMM yyyy}" />
                    <asp:BoundField DataField="TimeSlots" HeaderText="Time" />
                    <asp:BoundField DataField="AppointmentID" HeaderText="Booking #" />
                    <asp:BoundField DataField="DoctorName" HeaderText="Doctor" />
                    <asp:BoundField DataField="NurseName" HeaderText="Nurse" />
                    <asp:BoundField DataField="AppointmentReason" HeaderText="Reason" />
                    <asp:TemplateField HeaderText="Status">
                        <ItemTemplate><span class='<%# StatusCss(Eval("AppointmentStatus")) %>'><%#: Eval("AppointmentStatus") %></span></ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Receipt">
                        <ItemTemplate>
                            <asp:LinkButton ID="btnViewReceipt" runat="server" CommandName="Receipt" CommandArgument='<%# Eval("AppointmentID") %>' CausesValidation="false" CssClass="ph-view" Text="View" />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
    </div>
</div>
</div>

<eb:ReceiptViewer ID="ReceiptViewer1" runat="server" />

<%-- Only the signed-in patient's appointments (UserId is set in code-behind), newest date first. --%>
<asp:SqlDataSource ID="SqlDataSourceHistory" runat="server"
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
</asp:Content>
