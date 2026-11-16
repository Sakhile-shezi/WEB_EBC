<%@ Page Title="Nurse Dashboard - East Boom CHC" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="NurseDashboard.aspx.cs" Inherits="WebApplication1.Private.Nurse.NurseDashboard" %>
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

        .dashboard-wrapper {
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
            padding: 34px 38px;
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
            margin-bottom: 12px;
        }
        .dash-hero h1 {
            margin: 0 0 8px 0;
            font-size: 2rem;
            font-weight: 700;
            color: #ffffff;
            letter-spacing: -0.02em;
        }
        .dash-hero p {
            margin: 0;
            font-size: 0.96rem;
            color: #D1E7DD;
            max-width: 650px;
        }

        /* --- CLINICIAN BADGE + VIEW PROFILE BUTTON --- */
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
            font-size: 0.76rem;
            color: #D1E7DD;
            margin-bottom: 2px;
        }
        .clinician-badge strong {
            font-size: 0.98rem;
            color: #ffffff;
            font-weight: 700;
        }
        .btn-view-profile {
            background: #E8F5E9;
            color: #122818 !important;
            border: 1px solid rgba(255, 255, 255, 0.45);
            padding: 11px 18px;
            border-radius: 10px;
            font-size: 0.88rem;
            font-weight: 700;
            text-decoration: none !important;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            transition: background 0.2s ease, transform 0.15s ease;
            white-space: nowrap;
        }
        .btn-view-profile:hover {
            background: #ffffff;
            color: #122818 !important;
            transform: translateY(-2px);
        }

        /* --- SURFACE CARDS --- */
        .eb-surface-card {
            background: #ffffff;
            border: 1px solid var(--eb-card-border);
            border-radius: 12px;
            padding: 22px 26px;
            margin-bottom: 22px;
            box-shadow: 0 3px 12px rgba(15, 23, 42, 0.03);
        }

        /* --- DATE FILTER CARD & WEEKDAY PILLS --- */
        .date-filter-label {
            display: block;
            font-size: 0.78rem;
            font-weight: 700;
            letter-spacing: 0.05em;
            text-transform: uppercase;
            color: #334155;
            margin-bottom: 10px;
        }
        .date-controls-bar {
            display: flex;
            align-items: center;
            flex-wrap: wrap;
            gap: 10px;
            margin-bottom: 12px;
        }
        .date-input-control {
            width: 210px;
            max-width: 100%;
            padding: 9px 14px;
            border: 1px solid #CBD5E1;
            border-radius: 8px;
            font-size: 0.95rem;
            color: var(--text-dark);
            background: #ffffff;
        }
        .date-input-control:focus {
            outline: none;
            border-color: var(--eb-accent-mint);
        }
        .quick-days-group {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
        }
        .day-pill {
            background: var(--eb-soft-bg);
            color: var(--eb-primary-green);
            border: 1px solid var(--eb-card-border);
            padding: 8px 14px;
            border-radius: 8px;
            font-size: 0.83rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.15s ease;
        }
        .day-pill:hover {
            background: var(--eb-light-mint);
            border-color: var(--eb-accent-mint);
        }
        .day-pill.active {
            background: var(--eb-primary-green);
            color: #ffffff;
            border-color: var(--eb-primary-green);
        }
        .date-filter-caption {
            margin: 0;
            font-size: 0.88rem;
            color: var(--text-muted);
        }
        .date-filter-caption strong {
            color: var(--text-dark);
        }
        .weekend-notice {
            margin-top: 10px;
            padding: 8px 14px;
            background: #FFFBEB;
            border: 1px solid #FDE68A;
            color: #92400E;
            border-radius: 8px;
            font-size: 0.85rem;
            font-weight: 600;
        }

        /* --- 5 KPI STAT CARDS --- */
        .kpi-grid {
            display: grid;
            grid-template-columns: repeat(5, 1fr);
            gap: 16px;
            margin-bottom: 22px;
        }
        .kpi-card {
            background: #ffffff;
            border: 1px solid var(--eb-card-border);
            border-radius: 12px;
            padding: 20px 22px;
            box-shadow: 0 3px 10px rgba(15, 23, 42, 0.03);
        }
        .kpi-card.accent-scripts {
            border-left: 4px solid var(--eb-primary-green);
        }
        .kpi-title {
            display: block;
            font-size: 0.74rem;
            font-weight: 700;
            letter-spacing: 0.05em;
            text-transform: uppercase;
            color: #475569;
            margin-bottom: 10px;
        }
        .kpi-value {
            font-size: 2rem;
            font-weight: 700;
            line-height: 1.1;
            display: block;
        }
        .kpi-subtext {
            display: block;
            font-size: 0.76rem;
            color: var(--text-muted);
            margin-top: 6px;
            font-weight: 600;
        }
        .kpi-total { color: #1E293B; }
        .kpi-completed { color: #2E8B57; }
        .kpi-progress { color: #EA580C; }
        .kpi-pending { color: #0284C7; }
        .kpi-scripts { color: #1E293B; }

        /* --- SECTION HEADERS & TABLES --- */
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
        .btn-view-all-appts {
            background: var(--eb-primary-green);
            color: #ffffff !important;
            padding: 9px 18px;
            border-radius: 8px;
            font-size: 0.86rem;
            font-weight: 700;
            text-decoration: none !important;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            transition: background 0.15s ease;
            white-space: nowrap;
        }
        .btn-view-all-appts:hover {
            background: var(--eb-accent-mint);
        }

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
            padding: 12px 12px;
            text-align: left;
            border-bottom: 2px solid #D1E7DD;
            white-space: nowrap;
        }
        .eb-table td {
            padding: 13px 12px;
            border-bottom: 1px solid #F1F5F9;
            vertical-align: middle;
        }
        .eb-table tr:hover td {
            background: #F8FAFC;
        }

        /* --- NURSE CELL & STATUS BADGES --- */
        .nurse-assigned {
            font-weight: 600;
            color: var(--eb-primary-green);
            white-space: nowrap;
        }
        .nurse-unassigned {
            color: var(--text-muted);
            font-style: italic;
            font-size: 0.86rem;
            white-space: nowrap;
        }
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

        /* --- ALIGNED SINGLE-ROW ACTION BUTTONS --- */
        .actions-col-cell {
            white-space: nowrap;
            width: 1%;
        }
        .actions-cell-group {
            display: inline-flex;
            align-items: center;
            justify-content: flex-start;
            flex-wrap: nowrap;
            gap: 6px;
        }
        .action-pill-btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            height: 31px;
            padding: 0 11px;
            border-radius: 6px;
            font-size: 0.80rem;
            font-weight: 700;
            line-height: 1;
            text-decoration: none !important;
            white-space: nowrap;
            box-sizing: border-box;
            cursor: pointer;
            transition: background 0.15s ease, color 0.15s ease;
        }
        .btn-rx-history {
            background: var(--eb-light-mint);
            color: var(--eb-primary-green);
            border: 1px solid #A7F3D0;
        }
        .btn-rx-history:hover {
            background: var(--eb-primary-green);
            color: #ffffff;
        }
        .btn-update-row {
            background: #F0FDF4;
            color: #166534 !important;
            border: 1px solid #86EFAC;
        }
        .btn-update-row:hover {
            background: #166534;
            color: #ffffff !important;
        }
        .btn-prescribe-link {
            background: var(--eb-primary-green);
            color: #ffffff !important;
            border: 1px solid var(--eb-primary-green);
        }
        .btn-prescribe-link:hover {
            background: var(--eb-accent-mint);
            border-color: var(--eb-accent-mint);
        }

        .btn-reset-filter {
            background: #F1F5F9;
            color: #334155;
            border: 1px solid #CBD5E1;
            padding: 6px 14px;
            border-radius: 6px;
            font-size: 0.82rem;
            font-weight: 600;
            cursor: pointer;
        }
        .btn-reset-filter:hover {
            background: #E2E8F0;
        }

        /* --- EMPTY STATE --- */
        .empty-state-box {
            background: #F8FAFC;
            border: 1px dashed #CBD5E1;
            border-radius: 10px;
            padding: 30px 20px;
            text-align: center;
            color: var(--text-muted);
            font-size: 0.94rem;
        }

        @media (max-width: 992px) {
            .kpi-grid {
                grid-template-columns: repeat(3, 1fr);
            }
        }
        @media (max-width: 640px) {
            .kpi-grid {
                grid-template-columns: repeat(2, 1fr);
            }
            .clinician-badge {
                text-align: left;
            }
        }

        /* --- NURSE DASHBOARD ADDITIONS --- */
        .kpi-card.accent-doses {
            border-left: 4px solid var(--eb-primary-green);
        }
        .doctor-assigned {
            font-weight: 600;
            color: var(--eb-primary-green);
            white-space: nowrap;
        }
        .doctor-unassigned {
            color: var(--text-muted);
            font-style: italic;
            font-size: 0.86rem;
            white-space: nowrap;
        }
        .badge-neutral { background: #F1F5F9; color: #475569; }
        .dash-alert {
            padding: 12px 16px;
            border-radius: 10px;
            font-size: 0.9rem;
            font-weight: 600;
            margin-bottom: 22px;
        }
        .dash-alert-warning {
            background: #FFFBEB;
            border: 1px solid #FDE68A;
            color: #92400E;
        }
        .dash-alert-error {
            background: #FEF2F2;
            border: 1px solid #FECACA;
            color: #B91C1C;
        }
    </style>

    <div class="dashboard-wrapper">
        <!-- HERO BANNER -->
        <div class="dash-hero">
            <div>
                <span class="dash-facility-pill">East Boom Community Health Centre</span>
                <h1>Nurse's Clinical Dashboard</h1>
                <p>Review your assigned weekday appointments, track daily progress, and check the medication prescribed and administered to your patients.</p>
            </div>

            <div class="clinician-panel-group">
                <div class="clinician-badge">
                    <span>Active Nurse</span>
                    <strong><asp:Literal ID="litNurseName" runat="server" /></strong>
                </div>
                <asp:HyperLink ID="lnkViewProfile" runat="server"
                    NavigateUrl="~/Private/Nurse/Profile.aspx"
                    CssClass="btn-view-profile">View Profile</asp:HyperLink>
            </div>
        </div>

        <!-- ACCOUNT / DATA NOTICES -->
        <asp:Panel ID="pnlNotLinked" runat="server" Visible="false" CssClass="dash-alert dash-alert-warning">
            Your login is not linked to a nurse record yet, so no appointments or medication records can be shown.
            Please ask the administrator to link your account under Manage Staff.
        </asp:Panel>
        <asp:Panel ID="pnlLoadError" runat="server" Visible="false" CssClass="dash-alert dash-alert-error">
            <asp:Literal ID="litLoadError" runat="server" />
        </asp:Panel>

        <!-- SHIFT DATE SELECTOR (MONDAY–FRIDAY WORKING DAYS) -->
        <div class="eb-surface-card">
            <label for="<%= txtShiftDate.ClientID %>" class="date-filter-label">
                Select Shift Date (Monday – Friday Working Days)
            </label>
            <div class="date-controls-bar">
                <asp:TextBox ID="txtShiftDate" runat="server" TextMode="Date" AutoPostBack="true"
                    OnTextChanged="txtShiftDate_TextChanged" CssClass="date-input-control" />

                <div class="quick-days-group">
                    <asp:Repeater ID="rptQuickDates" runat="server" OnItemCommand="rptQuickDates_ItemCommand">
                        <ItemTemplate>
                            <asp:Button ID="btnQuickDate" runat="server"
                                Text='<%# Eval("Label") %>'
                                CommandName="SelectDate"
                                CommandArgument='<%# Eval("IsoDate") %>'
                                CssClass='<%# (bool)Eval("IsActive") ? "day-pill active" : "day-pill" %>' />
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
            </div>
            <p class="date-filter-caption">
                Showing weekday schedule for <strong><asp:Literal ID="litSelectedDateDisplay" runat="server" /></strong>
            </p>
            <asp:Panel ID="pnlWeekendNotice" runat="server" Visible="false" CssClass="weekend-notice">
                <asp:Literal ID="litWeekendNotice" runat="server" />
            </asp:Panel>
        </div>

        <!-- 5 KPI STATS CARDS -->
        <div class="kpi-grid">
            <div class="kpi-card">
                <span class="kpi-title">Appointments</span>
                <asp:Label ID="lblTotalAppointments" runat="server" Text="0" CssClass="kpi-value kpi-total" />
                <span class="kpi-subtext"><asp:Literal ID="litCancelledNote" runat="server" /></span>
            </div>
            <div class="kpi-card">
                <span class="kpi-title">Completed</span>
                <asp:Label ID="lblCompletedCount" runat="server" Text="0" CssClass="kpi-value kpi-completed" />
            </div>
            <div class="kpi-card">
                <span class="kpi-title">In Progress</span>
                <asp:Label ID="lblInProgressCount" runat="server" Text="0" CssClass="kpi-value kpi-progress" />
            </div>
            <div class="kpi-card">
                <span class="kpi-title">Pending</span>
                <asp:Label ID="lblPendingCount" runat="server" Text="0" CssClass="kpi-value kpi-pending" />
            </div>
            <div class="kpi-card accent-doses">
                <span class="kpi-title">Doses Given (5-Day Week)</span>
                <asp:Label ID="lblDosesGivenCount" runat="server" Text="0" CssClass="kpi-value kpi-scripts" />
                <span class="kpi-subtext"><asp:Literal ID="litDosesWeekRange" runat="server" /></span>
            </div>
        </div>

        <!-- ASSIGNED PATIENT APPOINTMENTS -->
        <div class="eb-surface-card">
            <div class="section-header-row">
                <div>
                    <h2 class="section-title">Assigned Patient Appointments</h2>
                    <p class="section-subtitle">Select "Medication" to see what a patient has been prescribed, "Treatment" to record treatment, or "Administer" to record a dose.</p>
                </div>
                <asp:HyperLink ID="lnkMedicationAdministration" runat="server"
                    NavigateUrl="~/Private/Nurse/MedicationAdministration.aspx"
                    CssClass="btn-view-all-appts">Medication Administration</asp:HyperLink>
            </div>

            <div class="eb-table-responsive">
                <asp:GridView ID="gvAppointments" runat="server" AutoGenerateColumns="False"
                    DataKeyNames="AppointmentID,PatientID,PatientName" OnRowCommand="gvAppointments_RowCommand"
                    CssClass="eb-table" GridLines="None">
                    <Columns>
                        <asp:BoundField DataField="TimeSlot" HeaderText="Time" />
                        <asp:BoundField DataField="PatientName" HeaderText="Patient Name" />
                        <asp:BoundField DataField="PatientIdentifier" HeaderText="Patient No." />
                        <asp:BoundField DataField="Reason" HeaderText="Consultation Reason" />
                        <asp:TemplateField HeaderText="Attending Doctor">
                            <ItemTemplate>
                                <span class='<%# Eval("AttendingDoctor").ToString() == "Unassigned" ? "doctor-unassigned" : "doctor-assigned" %>'>
                                    <%# Server.HtmlEncode(Eval("AttendingDoctor").ToString()) %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Status">
                            <ItemTemplate>
                                <span class='status-badge <%# GetStatusBadgeClass(Eval("Status").ToString()) %>'>
                                    <%# Server.HtmlEncode(Eval("Status").ToString()) %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Actions" ItemStyle-CssClass="actions-col-cell" HeaderStyle-CssClass="actions-col-cell">
                            <ItemTemplate>
                                <div class="actions-cell-group">
                                    <asp:Button ID="btnViewMeds" runat="server" Text="Medication"
                                        CommandName="ViewMeds" CommandArgument='<%# Container.DataItemIndex %>'
                                        CssClass="action-pill-btn btn-rx-history" />
                                    <asp:HyperLink ID="lnkTreatmentRow" runat="server"
                                        NavigateUrl="~/Private/Clinical/TreatmentInformation.aspx"
                                        CssClass="action-pill-btn btn-update-row">Treatment</asp:HyperLink>
                                    <asp:HyperLink ID="lnkAdministerRow" runat="server"
                                        NavigateUrl="~/Private/Nurse/MedicationAdministrationManagement.aspx"
                                        CssClass="action-pill-btn btn-prescribe-link">Administer</asp:HyperLink>
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>

            <asp:Panel ID="pnlNoAppointments" runat="server" Visible="true" CssClass="empty-state-box">
                No appointments are assigned to you for the selected working day.
            </asp:Panel>
        </div>

        <!-- RECENT MEDICATION ADMINISTERED / PATIENT PRESCRIBED MEDICATION -->
        <div class="eb-surface-card">
            <div class="section-header-row">
                <div>
                    <h2 class="section-title">
                        <asp:Literal ID="litMedSectionTitle" runat="server" Text="Recent Medication Administered" />
                    </h2>
                    <p class="section-subtitle">
                        <asp:Literal ID="litMedSectionSubtitle" runat="server" Text="Showing the 5 most recent administration records you captured." />
                    </p>
                </div>
                <asp:Button ID="btnResetMedFilter" runat="server" Text="Back to Recent Administrations (Top 5)"
                    Visible="false" OnClick="btnResetMedFilter_Click" CssClass="btn-reset-filter" />
            </div>

            <div class="eb-table-responsive">
                <asp:GridView ID="gvRecentAdministrations" runat="server" AutoGenerateColumns="False"
                    CssClass="eb-table" GridLines="None">
                    <Columns>
                        <asp:BoundField DataField="AdministeredAt" HeaderText="Administered At" />
                        <asp:BoundField DataField="PatientName" HeaderText="Patient" />
                        <asp:BoundField DataField="Medication" HeaderText="Medication" />
                        <asp:BoundField DataField="DoseGiven" HeaderText="Dose Given" />
                        <asp:TemplateField HeaderText="Status">
                            <ItemTemplate>
                                <span class='status-badge <%# GetAdministrationBadgeClass(Eval("Status").ToString()) %>'>
                                    <%# Server.HtmlEncode(Eval("Status").ToString()) %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="Notes" HeaderText="Notes" />
                    </Columns>
                </asp:GridView>

                <asp:GridView ID="gvPatientMedication" runat="server" AutoGenerateColumns="False"
                    CssClass="eb-table" GridLines="None" Visible="false">
                    <Columns>
                        <asp:BoundField DataField="DateIssued" HeaderText="Date Issued" />
                        <asp:BoundField DataField="Medication" HeaderText="Medication" />
                        <asp:BoundField DataField="DosageInstructions" HeaderText="Dosage & Frequency" />
                        <asp:BoundField DataField="Duration" HeaderText="Duration" />
                        <asp:BoundField DataField="PrescribedBy" HeaderText="Prescribed By" />
                        <asp:BoundField DataField="DosesGiven" HeaderText="Doses Given" />
                        <asp:BoundField DataField="LastGiven" HeaderText="Last Given" />
                    </Columns>
                </asp:GridView>
            </div>

            <asp:Panel ID="pnlNoMedication" runat="server" Visible="true" CssClass="empty-state-box">
                <asp:Literal ID="litNoMedication" runat="server" Text="You have not captured any medication administration records yet." />
            </asp:Panel>
        </div>
    </div>

</asp:Content>
