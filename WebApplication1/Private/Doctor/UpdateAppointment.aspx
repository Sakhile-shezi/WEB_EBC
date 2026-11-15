<%@ Page Title="View All Appointments - East Boom CHC" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="UpdateAppointment.aspx.cs" Inherits="WebApplication1.Private.Doctor.UpdateAppointment" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <style>
        :root {
            --eb-deep-forest: #122818;
            --eb-primary-green: #1E3A2F;
            --eb-accent-mint: #2E8B57;
            --eb-light-mint: #E8F5E9;
            --eb-soft-bg: #F8FBF9;
            --eb-card-border: #D1E7DD;
            --text-dark: #1A202C;
            --text-muted: #64748B;
        }

        html {
            scroll-behavior: smooth;
        }

        .update-appt-wrapper {
            max-width: 1200px;
            margin: 0 auto;
            padding: 24px 15px 70px 15px;
            font-family: 'Segoe UI', System-UI, -apple-system, sans-serif;
            color: var(--text-dark);
        }

        /* --- HERO BANNER --- */
        .dash-hero {
            background: linear-gradient(135deg, var(--eb-deep-forest) 0%, var(--eb-primary-green) 60%, var(--eb-accent-mint) 100%);
            color: #ffffff;
            padding: 32px 36px;
            border-radius: 14px;
            margin-bottom: 22px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 20px;
            box-shadow: 0 10px 25px rgba(18, 40, 24, 0.14);
        }
        .dash-facility-pill {
            display: inline-block;
            background: rgba(255, 255, 255, 0.14);
            border: 1px solid rgba(255, 255, 255, 0.22);
            color: #E8F5E9;
            font-size: 0.72rem;
            font-weight: 700;
            letter-spacing: 0.08em;
            text-transform: uppercase;
            padding: 5px 12px;
            border-radius: 20px;
            margin-bottom: 10px;
        }
        .dash-hero h1 {
            margin: 0 0 6px 0;
            font-size: 1.9rem;
            font-weight: 700;
            color: #ffffff;
        }
        .dash-hero p {
            margin: 0;
            font-size: 0.95rem;
            color: #D1E7DD;
            max-width: 640px;
        }
        .clinician-panel-group {
            display: flex;
            align-items: center;
            gap: 12px;
            flex-wrap: wrap;
        }
        .clinician-badge {
            background: rgba(255, 255, 255, 0.12);
            border: 1px solid rgba(255, 255, 255, 0.22);
            padding: 10px 18px;
            border-radius: 10px;
            text-align: right;
        }
        .clinician-badge span {
            display: block;
            font-size: 0.75rem;
            color: #D1E7DD;
        }
        .clinician-badge strong {
            font-size: 0.96rem;
            color: #ffffff;
        }
        .btn-back-dash {
            background: #E8F5E9;
            color: #122818 !important;
            border: 1px solid rgba(255, 255, 255, 0.45);
            padding: 10px 18px;
            border-radius: 10px;
            font-size: 0.86rem;
            font-weight: 700;
            text-decoration: none !important;
            transition: background 0.15s ease;
        }
        .btn-back-dash:hover {
            background: #ffffff;
        }

        /* --- SURFACE CARDS --- */
        .eb-surface-card {
            background: #ffffff;
            border: 1px solid var(--eb-card-border);
            border-radius: 12px;
            padding: 24px 26px;
            margin-bottom: 22px;
            box-shadow: 0 3px 12px rgba(15, 23, 42, 0.03);
        }
        .section-header-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 12px;
            margin-bottom: 16px;
        }
        .section-title {
            margin: 0 0 4px 0;
            font-size: 1.18rem;
            font-weight: 700;
            color: var(--text-dark);
        }
        .section-subtitle {
            margin: 0;
            font-size: 0.88rem;
            color: var(--text-muted);
        }

        /* --- FILTER BAR --- */
        .filter-controls {
            display: flex;
            align-items: center;
            gap: 10px;
            flex-wrap: wrap;
        }
        .eb-input, .eb-select {
            padding: 9px 14px;
            border: 1px solid #CBD5E1;
            border-radius: 8px;
            font-size: 0.92rem;
            color: var(--text-dark);
            background: #ffffff;
        }
        .eb-input:focus, .eb-select:focus {
            outline: none;
            border-color: var(--eb-accent-mint);
        }
        .eb-input[readonly] {
            background: #F8FAFC;
            color: #475569;
            border-color: #E2E8F0;
            cursor: not-allowed;
        }
        .btn-filter {
            background: var(--eb-primary-green);
            color: #ffffff;
            border: none;
            padding: 9px 16px;
            border-radius: 8px;
            font-size: 0.85rem;
            font-weight: 600;
            cursor: pointer;
        }
        .btn-filter:hover {
            background: var(--eb-accent-mint);
        }
        .btn-show-all {
            background: #F1F5F9;
            color: #334155;
            border: 1px solid #CBD5E1;
            padding: 9px 16px;
            border-radius: 8px;
            font-size: 0.85rem;
            font-weight: 600;
            cursor: pointer;
        }
        .btn-show-all:hover {
            background: #E2E8F0;
        }

        /* --- SQL GRIDVIEW & 7-ROW PAGINATION --- */
        .eb-table-responsive {
            width: 100%;
            overflow-x: auto;
        }
        .eb-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 0.91rem;
        }
        .eb-table th {
            background: var(--eb-soft-bg);
            color: var(--eb-primary-green);
            font-weight: 700;
            font-size: 0.79rem;
            text-transform: uppercase;
            letter-spacing: 0.04em;
            padding: 12px 14px;
            text-align: left;
            border-bottom: 2px solid #D1E7DD;
            white-space: nowrap;
        }
        .eb-table td {
            padding: 13px 14px;
            border-bottom: 1px solid #F1F5F9;
            vertical-align: middle;
        }
        .eb-table tr:hover td {
            background: #F8FAFC;
        }
        .selected-grid-row td {
            background: var(--eb-light-mint) !important;
            border-top: 1px solid #A7F3D0;
            border-bottom: 1px solid #A7F3D0;
            font-weight: 600;
        }

        /* --- GRIDVIEW PAGER BAR --- */
        .eb-pager-row td {
            background: #ffffff !important;
            border-bottom: none !important;
            padding-top: 16px;
            padding-bottom: 4px;
        }
        .eb-pager-row table {
            margin: 0 auto;
        }
        .eb-pager-row td table td {
            padding: 0 3px !important;
            border: none !important;
        }
        .eb-pager-row a,
        .eb-pager-row span {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            min-width: 34px;
            height: 34px;
            padding: 0 10px;
            border-radius: 8px;
            font-size: 0.85rem;
            font-weight: 700;
            text-decoration: none !important;
        }
        .eb-pager-row a {
            background: var(--eb-soft-bg);
            color: var(--eb-primary-green) !important;
            border: 1px solid var(--eb-card-border);
        }
        .eb-pager-row a:hover {
            background: var(--eb-light-mint);
            border-color: var(--eb-accent-mint);
        }
        .eb-pager-row span {
            background: var(--eb-primary-green);
            color: #ffffff;
            border: 1px solid var(--eb-primary-green);
        }

        .btn-select-row {
            display: inline-block;
            background: var(--eb-primary-green);
            color: #ffffff !important;
            padding: 6px 15px;
            border-radius: 6px;
            font-size: 0.82rem;
            font-weight: 700;
            text-decoration: none !important;
            transition: background 0.15s ease;
        }
        .btn-select-row:hover {
            background: var(--eb-accent-mint);
        }

        /* --- STATUS BADGES --- */
        .status-badge {
            display: inline-block;
            padding: 4px 11px;
            border-radius: 20px;
            font-size: 0.78rem;
            font-weight: 700;
            white-space: nowrap;
        }
        .badge-completed { background: #E8F5E9; color: #1E3A2F; }
        .badge-progress { background: #FFF7ED; color: #C2410C; }
        .badge-pending { background: #E0F2FE; color: #0369A1; }
        .badge-cancelled { background: #FEE2E2; color: #B91C1C; }

        /* --- UPDATE FORM PANEL --- */
        .selection-prompt-box {
            background: var(--eb-soft-bg);
            border: 1px dashed #A7F3D0;
            border-radius: 10px;
            padding: 22px;
            text-align: center;
            color: var(--eb-primary-green);
            font-weight: 600;
            font-size: 0.94rem;
        }
        .selected-summary-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 14px;
            background: var(--eb-soft-bg);
            border: 1px solid var(--eb-card-border);
            border-radius: 10px;
            padding: 16px 18px;
            margin-bottom: 20px;
        }
        .summary-item span {
            display: block;
            font-size: 0.74rem;
            font-weight: 700;
            text-transform: uppercase;
            color: var(--text-muted);
            margin-bottom: 4px;
        }
        .summary-item strong {
            font-size: 0.95rem;
            color: var(--text-dark);
        }

        .edit-fields-grid {
            display: grid;
            grid-template-columns: 320px 1fr;
            gap: 20px;
            margin-bottom: 20px;
        }
        .form-group label {
            display: block;
            font-size: 0.84rem;
            font-weight: 700;
            color: #334155;
            margin-bottom: 7px;
        }
        .form-group .eb-select,
        .form-group .eb-input {
            width: 100%;
            box-sizing: border-box;
        }

        .form-actions-bar {
            display: flex;
            align-items: center;
            gap: 12px;
            flex-wrap: wrap;
        }
        .btn-save-status {
            background: var(--eb-primary-green);
            color: #ffffff;
            border: none;
            padding: 11px 24px;
            border-radius: 8px;
            font-size: 0.92rem;
            font-weight: 700;
            cursor: pointer;
            transition: background 0.15s ease;
        }
        .btn-save-status:hover {
            background: var(--eb-accent-mint);
        }

        .alert-error {
            background: #FEE2E2;
            color: #991B1B;
            border: 1px solid #FECACA;
            padding: 11px 16px;
            border-radius: 8px;
            font-size: 0.88rem;
            font-weight: 600;
            margin-bottom: 16px;
        }
        .empty-state-box {
            background: #F8FAFC;
            border: 1px dashed #CBD5E1;
            border-radius: 10px;
            padding: 28px 20px;
            text-align: center;
            color: var(--text-muted);
        }

        /* --- MODAL POPUP FOR STATUS CHANGED --- */
        .eb-modal-backdrop {
            position: fixed;
            inset: 0;
            background: rgba(15, 23, 42, 0.58);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 9999;
            padding: 16px;
        }
        .eb-modal-card {
            background: #ffffff;
            border: 1px solid var(--eb-card-border);
            border-radius: 16px;
            max-width: 460px;
            width: 100%;
            padding: 30px 32px;
            text-align: center;
            box-shadow: 0 20px 45px rgba(18, 40, 24, 0.28);
            animation: popIn 0.18s ease-out;
        }
        @keyframes popIn {
            from { transform: scale(0.94); opacity: 0; }
            to { transform: scale(1); opacity: 1; }
        }
        .popup-check-badge {
            width: 58px;
            height: 58px;
            border-radius: 50%;
            background: var(--eb-light-mint);
            color: var(--eb-accent-mint);
            border: 2px solid #A7F3D0;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.7rem;
            font-weight: 700;
            margin: 0 auto 16px auto;
        }
        .eb-modal-card h3 {
            margin: 0 0 8px 0;
            font-size: 1.35rem;
            font-weight: 700;
            color: var(--eb-deep-forest);
        }
        .eb-modal-card p {
            margin: 0 0 18px 0;
            font-size: 0.93rem;
            color: var(--text-muted);
        }
        .status-transition-box {
            background: var(--eb-soft-bg);
            border: 1px solid var(--eb-card-border);
            border-radius: 10px;
            padding: 14px 16px;
            margin-bottom: 22px;
            font-size: 0.92rem;
        }
        .status-transition-patient {
            font-weight: 700;
            color: var(--text-dark);
            margin-bottom: 8px;
            display: block;
        }
        .status-arrow-row {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            flex-wrap: wrap;
        }
        .pill-old {
            background: #F1F5F9;
            color: #475569;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.82rem;
            font-weight: 700;
        }
        .pill-new {
            background: var(--eb-primary-green);
            color: #ffffff;
            padding: 4px 14px;
            border-radius: 20px;
            font-size: 0.84rem;
            font-weight: 700;
        }
        .popup-btn-row {
            display: flex;
            justify-content: center;
            gap: 12px;
            flex-wrap: wrap;
        }
        .btn-popup-ok {
            background: var(--eb-primary-green);
            color: #ffffff;
            border: none;
            padding: 10px 24px;
            border-radius: 8px;
            font-size: 0.9rem;
            font-weight: 700;
            cursor: pointer;
        }
        .btn-popup-ok:hover {
            background: var(--eb-accent-mint);
        }
        .btn-popup-dash {
            background: var(--eb-light-mint);
            color: var(--eb-primary-green) !important;
            border: 1px solid #A7F3D0;
            padding: 10px 20px;
            border-radius: 8px;
            font-size: 0.9rem;
            font-weight: 700;
            text-decoration: none !important;
        }
        .btn-popup-dash:hover {
            background: #D1E7DD;
            color: var(--eb-deep-forest) !important;
        }

        @media (max-width: 860px) {
            .selected-summary-grid {
                grid-template-columns: repeat(2, 1fr);
            }
            .edit-fields-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>

    <div class="update-appt-wrapper">
        <!-- HERO BANNER -->
        <div class="dash-hero">
            <div>
                <span class="dash-facility-pill">East Boom Community Health Centre</span>
                <h1>View All Appointments</h1>
                <p>Browse all scheduled consultations in the SQL table below, select any appointment to update its status, and save changes to the database.</p>
            </div>

            <div class="clinician-panel-group">
                <div class="clinician-badge">
                    <span>Active Clinician</span>
                    <strong><asp:Literal ID="litDoctorName" runat="server" /></strong>
                </div>
                <asp:HyperLink ID="lnkBackToDashTop" runat="server"
                    NavigateUrl="~/Private/Doctor/DoctorDashboard.aspx"
                    CssClass="btn-back-dash">← Back to Dashboard</asp:HyperLink>
            </div>
        </div>

        <!-- SQL GRIDVIEW CARD (7 ROWS PER PAGE) -->
        <div class="eb-surface-card">
            <div class="section-header-row">
                <div>
                    <h2 class="section-title">All Scheduled Appointments (Select to Update)</h2>
                    <p class="section-subtitle">
                        Showing 7 consultations per page (<asp:Literal ID="litTotalCountInfo" runat="server" Text="0 total" />). Past unupdated appointments are automatically marked <strong>Cancelled</strong>.
                    </p>
                </div>

                <div class="filter-controls">
                    <asp:TextBox ID="txtFilterDate" runat="server" TextMode="Date" CssClass="eb-input" />
                    <asp:Button ID="btnFilterByDate" runat="server" Text="Filter Date" OnClick="btnFilterByDate_Click" CssClass="btn-filter" />
                    <asp:Button ID="btnShowAllAppointments" runat="server" Text="Show All" OnClick="btnShowAllAppointments_Click" CssClass="btn-show-all" />
                </div>
            </div>

            <div class="eb-table-responsive">
                <asp:GridView ID="gvAppointments" runat="server" AutoGenerateColumns="False"
                    DataKeyNames="AppointmentID"
                    AllowPaging="True" PageSize="5"
                    OnPageIndexChanging="gvAppointments_PageIndexChanging"
                    OnSelectedIndexChanged="gvAppointments_SelectedIndexChanged"
                    CssClass="eb-table" GridLines="None">
                    <PagerSettings Mode="NumericFirstLast" FirstPageText="« First" LastPageText="Last »" PageButtonCount="5" />
                    <PagerStyle CssClass="eb-pager-row" HorizontalAlign="Center" />
                    <SelectedRowStyle CssClass="selected-grid-row" />
                    <Columns>
                        <asp:BoundField DataField="AppointmentID" HeaderText="Appt #" />
                        <asp:BoundField DataField="AppointmentDate" HeaderText="Date" />
                        <asp:BoundField DataField="TimeSlot" HeaderText="Time" />
                        <asp:BoundField DataField="PatientName" HeaderText="Patient Name" />
                        <asp:BoundField DataField="PatientIdentifier" HeaderText="ID / File No." />
                        <asp:BoundField DataField="Reason" HeaderText="Consultation Reason" />
                        <asp:BoundField DataField="AssignedNurse" HeaderText="Assigned Nurse" />
                        <asp:TemplateField HeaderText="Status">
                            <ItemTemplate>
                                <span class='status-badge <%# GetStatusBadgeClass(Eval("Status").ToString()) %>'>
                                    <%# Eval("Status") %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:CommandField ShowSelectButton="True" SelectText="Select" HeaderText="Action"
                            ControlStyle-CssClass="btn-select-row" />
                    </Columns>
                </asp:GridView>
            </div>

            <asp:Panel ID="pnlNoAppointments" runat="server" Visible="false" CssClass="empty-state-box">
                No appointments found for the current filter. Click <strong>Show All</strong> to view all scheduled consultations.
            </asp:Panel>
        </div>

        <!-- APPOINTMENT UPDATE FORM (SCROLL TARGET) -->
        <div id="appointment-edit-section" class="eb-surface-card">
            <div class="section-header-row">
                <div>
                    <h2 class="section-title">Appointment Status & Details</h2>
                    <p class="section-subtitle">Modify the consultation status and save directly to the database.</p>
                </div>
            </div>

            <asp:Panel ID="pnlError" runat="server" Visible="false" CssClass="alert-error">
                <asp:Literal ID="litError" runat="server" />
            </asp:Panel>

            <asp:Panel ID="pnlSelectPrompt" runat="server" Visible="true" CssClass="selection-prompt-box">
                Click <strong>Select</strong> on any appointment in the table above to navigate here and update its status.
            </asp:Panel>

            <asp:Panel ID="pnlEditForm" runat="server" Visible="false">
                <div class="selected-summary-grid">
                    <div class="summary-item">
                        <span>Patient Name</span>
                        <strong><asp:Literal ID="litSelPatientName" runat="server" /></strong>
                    </div>
                    <div class="summary-item">
                        <span>ID / File No.</span>
                        <strong><asp:Literal ID="litSelPatientIdNo" runat="server" /></strong>
                    </div>
                    <div class="summary-item">
                        <span>Date & Time</span>
                        <strong><asp:Literal ID="litSelDateTime" runat="server" /></strong>
                    </div>
                    <div class="summary-item">
                        <span>Assigned Nurse</span>
                        <strong><asp:Literal ID="litSelNurse" runat="server" /></strong>
                    </div>
                </div>

                <div class="edit-fields-grid">
                    <div class="form-group">
                        <label for="<%= ddlAppointmentStatus.ClientID %>">Consultation Status *</label>
                        <asp:DropDownList ID="ddlAppointmentStatus" runat="server" CssClass="eb-select">
                            <asp:ListItem Text="Scheduled" Value="Scheduled" />
                            <asp:ListItem Text="In Progress" Value="In Progress" />
                            <asp:ListItem Text="Completed" Value="Completed" />
                            <asp:ListItem Text="Cancelled" Value="Cancelled" />
                            <asp:ListItem Text="No Show" Value="No Show" />
                        </asp:DropDownList>
                    </div>

                    <div class="form-group">
                        <label for="<%= txtConsultationReason.ClientID %>">Consultation Reason (Read-Only)</label>
                        <asp:TextBox ID="txtConsultationReason" runat="server" CssClass="eb-input" ReadOnly="true" />
                    </div>
                </div>

                <div class="form-actions-bar">
                    <asp:Button ID="btnSaveAppointment" runat="server" Text="Save Status to Database"
                        OnClick="btnSaveAppointment_Click" CssClass="btn-save-status" />
                    <asp:Button ID="btnClearSelection" runat="server" Text="Cancel"
                        OnClick="btnClearSelection_Click" CssClass="btn-show-all" />
                </div>
            </asp:Panel>
        </div>
    </div>

    <!-- POPUP MODAL: STATUS CHANGED CONFIRMATION -->
    <asp:Panel ID="pnlStatusPopup" runat="server" Visible="false" CssClass="eb-modal-backdrop">
        <div class="eb-modal-card">
            <div class="popup-check-badge">✓</div>
            <h3>Appointment Status Changed</h3>
            <p>The consultation status has been updated and saved in the database.</p>

            <div class="status-transition-box">
                <span class="status-transition-patient">
                    <asp:Literal ID="litPopupPatient" runat="server" /> • <asp:Literal ID="litPopupDateTime" runat="server" />
                </span>
                <div class="status-arrow-row">
                    <span class="pill-old"><asp:Literal ID="litPopupOldStatus" runat="server" /></span>
                    <span>→</span>
                    <span class="pill-new"><asp:Literal ID="litPopupNewStatus" runat="server" /></span>
                </div>
            </div>

            <div class="popup-btn-row">
                <asp:Button ID="btnClosePopup" runat="server" Text="OK"
                    OnClick="btnClosePopup_Click" CssClass="btn-popup-ok" />
                <asp:HyperLink ID="lnkBackToDashPopup" runat="server"
                    NavigateUrl="~/Private/Doctor/DoctorDashboard.aspx"
                    CssClass="btn-popup-dash">Back to Dashboard</asp:HyperLink>
            </div>
        </div>
    </asp:Panel>

</asp:Content>