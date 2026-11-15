<%@ Page Title="Doctor Profile - East Boom CHC" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Profile.aspx.cs" Inherits="WebApplication1.Private.Doctor.Profile" %>
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

        .profile-wrapper {
            max-width: 1140px;
            margin: 0 auto;
            padding: 24px 15px 70px 15px;
            font-family: 'Segoe UI', System-UI, -apple-system, sans-serif;
            color: var(--text-dark);
        }

        /* --- HERO BANNER --- */
        .profile-hero {
            background: linear-gradient(135deg, var(--eb-deep-forest) 0%, var(--eb-primary-green) 60%, var(--eb-accent-mint) 100%);
            color: #ffffff;
            padding: 32px 36px;
            border-radius: 14px;
            margin-bottom: 24px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 20px;
            box-shadow: 0 10px 25px rgba(18, 40, 24, 0.14);
        }
        .hero-identity {
            display: flex;
            align-items: center;
            gap: 20px;
            flex-wrap: wrap;
        }
        .avatar-circle {
            width: 72px;
            height: 72px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.14);
            border: 2px solid rgba(255, 255, 255, 0.35);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.65rem;
            font-weight: 700;
            color: #ffffff;
            letter-spacing: 0.03em;
            flex-shrink: 0;
        }
        .hero-details h1 {
            margin: 0 0 4px 0;
            font-size: 1.75rem;
            font-weight: 700;
            color: #ffffff;
        }
        .hero-details p {
            margin: 0 0 10px 0;
            font-size: 0.94rem;
            color: #D1E7DD;
        }
        .hero-meta-pills {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
        }
        .hero-pill {
            background: rgba(255, 255, 255, 0.12);
            border: 1px solid rgba(255, 255, 255, 0.22);
            color: #E8F5E9;
            font-size: 0.78rem;
            font-weight: 600;
            padding: 4px 12px;
            border-radius: 20px;
        }

        .hero-actions {
            display: flex;
            align-items: center;
            gap: 12px;
            flex-wrap: wrap;
        }
        .status-pill-live {
            background: #ffffff;
            color: var(--eb-deep-forest);
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 700;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        .status-dot {
            width: 9px;
            height: 9px;
            border-radius: 50%;
            display: inline-block;
        }
        .dot-available { background: #16A34A; }
        .dot-busy { background: #EA580C; }
        .dot-away { background: #64748B; }

        .btn-back-dash {
            background: rgba(255, 255, 255, 0.14);
            color: #ffffff;
            border: 1px solid rgba(255, 255, 255, 0.3);
            padding: 9px 18px;
            border-radius: 20px;
            font-size: 0.86rem;
            font-weight: 600;
            text-decoration: none;
            transition: background 0.15s ease;
        }
        .btn-back-dash:hover {
            background: rgba(255, 255, 255, 0.24);
            color: #ffffff;
            text-decoration: none;
        }

        /* --- TWO-COLUMN LAYOUT --- */
        .profile-grid {
            display: grid;
            grid-template-columns: 340px 1fr;
            gap: 24px;
            align-items: start;
        }
        .right-column-stack {
            display: flex;
            flex-direction: column;
            gap: 24px;
        }

        /* --- SURFACE CARDS --- */
        .eb-card {
            background: #ffffff;
            border: 1px solid var(--eb-card-border);
            border-radius: 12px;
            padding: 26px 28px;
            box-shadow: 0 3px 12px rgba(15, 23, 42, 0.03);
        }
        .eb-card h2 {
            margin: 0 0 6px 0;
            font-size: 1.15rem;
            font-weight: 700;
            color: var(--text-dark);
        }
        .eb-card-subtitle {
            margin: 0 0 20px 0;
            font-size: 0.88rem;
            color: var(--text-muted);
            padding-bottom: 16px;
            border-bottom: 1px solid #F1F5F9;
        }

        /* --- LEFT CARD SPEC LIST --- */
        .spec-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 13px 0;
            border-bottom: 1px solid #F1F5F9;
            font-size: 0.9rem;
            gap: 12px;
        }
        .spec-row:last-child {
            border-bottom: none;
            padding-bottom: 0;
        }
        .spec-label {
            color: var(--text-muted);
            font-weight: 500;
        }
        .spec-value {
            color: var(--text-dark);
            font-weight: 700;
            text-align: right;
        }

        /* --- FORM GRID --- */
        .form-grid-2 {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 18px;
            margin-bottom: 20px;
        }
        .form-group label {
            display: block;
            font-size: 0.84rem;
            font-weight: 700;
            color: #334155;
            margin-bottom: 7px;
        }
        .eb-input, .eb-select {
            width: 100%;
            padding: 10px 14px;
            border: 1px solid #CBD5E1;
            border-radius: 8px;
            font-size: 0.93rem;
            color: var(--text-dark);
            background: #ffffff;
            box-sizing: border-box;
        }
        .eb-input:focus, .eb-select:focus {
            outline: none;
            border-color: var(--eb-accent-mint);
        }
        .eb-input[readonly] {
            background: #F8FAFC;
            color: #475569;
            cursor: not-allowed;
        }

        .btn-eb-primary {
            background: var(--eb-primary-green);
            color: #ffffff;
            border: none;
            padding: 11px 22px;
            border-radius: 8px;
            font-size: 0.9rem;
            font-weight: 700;
            cursor: pointer;
            transition: background 0.15s ease;
        }
        .btn-eb-primary:hover {
            background: var(--eb-accent-mint);
        }

        /* --- FEEDBACK ALERTS --- */
        .alert-banner {
            padding: 11px 16px;
            border-radius: 8px;
            font-size: 0.88rem;
            font-weight: 600;
            margin-bottom: 18px;
        }
        .alert-success {
            background: #E8F5E9;
            color: #1E3A2F;
            border: 1px solid #A7F3D0;
        }
        .alert-error {
            background: #FEE2E2;
            color: #991B1B;
            border: 1px solid #FECACA;
        }

        @media (max-width: 860px) {
            .profile-grid {
                grid-template-columns: 1fr;
            }
        }
        @media (max-width: 600px) {
            .form-grid-2 {
                grid-template-columns: 1fr;
            }
        }
    </style>

    <div class="profile-wrapper">
        <!-- HERO BANNER -->
        <div class="profile-hero">
            <div class="hero-identity">
                <div class="avatar-circle">
                    <asp:Literal ID="litInitials" runat="server" Text="DR" />
                </div>
                <div class="hero-details">
                    <h1><asp:Literal ID="litDoctorFullName" runat="server" /></h1>
                    <p><asp:Literal ID="litRoleSubtitle" runat="server" Text="Medical Officer — East Boom CHC" /></p>
                    <div class="hero-meta-pills">
                        <span class="hero-pill">Doctor ID: <asp:Literal ID="litHeroDoctorId" runat="server" /></span>
                        <span class="hero-pill"><asp:Literal ID="litHeroRoom" runat="server" /></span>
                    </div>
                </div>
            </div>

            <div class="hero-actions">
                <span class="status-pill-live">
                    <span id="spanStatusDot" runat="server" class="status-dot dot-available"></span>
                    <asp:Literal ID="litHeroQueueStatus" runat="server" Text="Available" />
                </span>
                <a runat="server" href="~/Private/Doctor/DoctorDashboard.aspx" class="btn-back-dash">
                    ← Back to Dashboard
                </a>
            </div>
        </div>

        <div class="profile-grid">
            <!-- LEFT CARD: DATABASE-BACKED CLINICAL RECORD -->
            <div class="eb-card">
                <h2>Clinical Record</h2>
                <p class="eb-card-subtitle">Active clinician assignment synced with East Boom CHC records.</p>

                <div class="spec-row">
                    <span class="spec-label">Doctor ID</span>
                    <span class="spec-value"><asp:Literal ID="litSpecDoctorId" runat="server" /></span>
                </div>
                <div class="spec-row">
                    <span class="spec-label">System Role</span>
                    <span class="spec-value">Doctor / Clinician</span>
                </div>
                <div class="spec-row">
                    <span class="spec-label">Department</span>
                    <span class="spec-value"><asp:Literal ID="litDepartment" runat="server" Text="Outpatients & Clinical Care" /></span>
                </div>
                <div class="spec-row">
                    <span class="spec-label">Assigned Room</span>
                    <span class="spec-value"><asp:Literal ID="litSpecRoom" runat="server" /></span>
                </div>
                <div class="spec-row">
                    <span class="spec-label">Facility</span>
                    <span class="spec-value">East Boom CHC (541 Boom St)</span>
                </div>
            </div>

            <!-- RIGHT COLUMN: CONTACT, ROOM, QUEUE STATUS & PASSWORD -->
            <div class="right-column-stack">
                <div class="eb-card">
                    <h2>Contact & Consultation Settings</h2>
                    <p class="eb-card-subtitle">Update your contact number, assigned consultation room, and live queue availability.</p>

                    <asp:Panel ID="pnlProfileAlert" runat="server" Visible="false" CssClass="alert-banner">
                        <asp:Literal ID="litProfileAlert" runat="server" />
                    </asp:Panel>

                    <div class="form-grid-2">
                        <div class="form-group">
                            <label for="<%= txtContactNumber.ClientID %>">Contact Number *</label>
                            <asp:TextBox ID="txtContactNumber" runat="server" CssClass="eb-input" placeholder="e.g. 033 342 1100" MaxLength="20" />
                        </div>

                        <div class="form-group">
                            <label for="<%= txtOfficialEmail.ClientID %>">Official Email (Account Login)</label>
                            <asp:TextBox ID="txtOfficialEmail" runat="server" CssClass="eb-input" ReadOnly="true" />
                        </div>

                        <div class="form-group">
                            <label for="<%= ddlConsultationRoom.ClientID %>">Consultation Room</label>
                            <asp:DropDownList ID="ddlConsultationRoom" runat="server" CssClass="eb-select">
                                <asp:ListItem Text="Room 1 — Chronic Care Unit" Value="Room 1 — Chronic Care Unit" />
                                <asp:ListItem Text="Room 2 — Acute & General OPD" Value="Room 2 — Acute & General OPD" />
                                <asp:ListItem Text="Room 3 — Triage & Vitals" Value="Room 3 — Triage & Vitals" />
                                <asp:ListItem Text="Room 4 — Maternal & Child Health" Value="Room 4 — Maternal & Child Health" />
                                <asp:ListItem Text="Room 5 — Consultation Suite" Value="Room 5 — Consultation Suite" />
                            </asp:DropDownList>
                        </div>

                        <div class="form-group">
                            <label for="<%= ddlQueueStatus.ClientID %>">Live Queue Status</label>
                            <asp:DropDownList ID="ddlQueueStatus" runat="server" CssClass="eb-select">
                                <asp:ListItem Text="Available" Value="Available" />
                                <asp:ListItem Text="In Consultation" Value="In Consultation" />
                                <asp:ListItem Text="On Break" Value="On Break" />
                                <asp:ListItem Text="Off Duty" Value="Off Duty" />
                            </asp:DropDownList>
                        </div>
                    </div>

                    <asp:Button ID="btnSaveProfile" runat="server" Text="Save Profile Changes"
                        OnClick="btnSaveProfile_Click" CssClass="btn-eb-primary" />
                </div>

                <!-- ACCOUNT SECURITY -->
                <div class="eb-card">
                    <h2>Account Security</h2>
                    <p class="eb-card-subtitle">Update your portal login password. Passwords are case-sensitive.</p>

                    <asp:Panel ID="pnlPasswordAlert" runat="server" Visible="false" CssClass="alert-banner">
                        <asp:Literal ID="litPasswordAlert" runat="server" />
                    </asp:Panel>

                    <div class="form-grid-2">
                        <div class="form-group">
                            <label for="<%= txtCurrentPassword.ClientID %>">Current Password *</label>
                            <asp:TextBox ID="txtCurrentPassword" runat="server" TextMode="Password" CssClass="eb-input" />
                        </div>
                        <div class="form-group"></div>

                        <div class="form-group">
                            <label for="<%= txtNewPassword.ClientID %>">New Password *</label>
                            <asp:TextBox ID="txtNewPassword" runat="server" TextMode="Password" CssClass="eb-input" />
                        </div>

                        <div class="form-group">
                            <label for="<%= txtConfirmPassword.ClientID %>">Confirm New Password *</label>
                            <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password" CssClass="eb-input" />
                        </div>
                    </div>

                    <asp:Button ID="btnChangePassword" runat="server" Text="Update Password"
                        OnClick="btnChangePassword_Click" CssClass="btn-eb-primary" />
                </div>
            </div>
        </div>
    </div>

</asp:Content>