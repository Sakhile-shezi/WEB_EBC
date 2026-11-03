

<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Private2.aspx.cs" Inherits="WebApplication1.Private.Private2" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <style>
        .dashboard-header {
            display: flex;
            flex-direction: column;
            align-items: center;
            text-align: center;
            border-bottom: 2px solid #eaeaea;
            padding-bottom: 12px;
            margin-bottom: 20px;
        }

        .header-image {
            width: 100%;
            max-height: 350px;
            height: 350px;
            object-fit: cover;
            border-radius: 8px;
            margin-bottom: 15px;
        }

.user-profile {
    margin-top: 10px;
}

        .quick-stats {
            display: flex;
            gap: 16px;
            margin-bottom: 24px;
        }

        .stat-card {
            flex: 1;
            background: #eef5ff;
            padding: 16px;
            border-radius: 6px;
            border-left: 4px solid #0056b3;
        }

        .stat-number {
            font-size: 1.8rem;
            font-weight: bold;
            color: #0056b3;
            margin: 8px 0 0 0;
        }

        .data-table {
            width: 100%;
            border-collapse: collapse;
        }

        .data-table th, .data-table td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }

        .badge {
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 0.85rem;
        }

        .badge.confirmed { background: #d4edda; color: #155724; }
        .badge.pending { background: #fff3cd; color: #856404; }

        .btn-action {
            padding: 8px 16px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            background: #e2e8f0;
            color: #333;
        }

        .btn-action:hover {
            background: #cbd5e1;
        }
    </style>

    <div class="dashboard-container">
        <header class="dashboard-header">
            <img class="header-image" src="/Images/Smile.jpeg"/>
            <h1>Doctor Dashboard</h1>
            <div class="user-profile">
                <span>Welcome, <asp:Label ID="lblDoctorName" runat="server" Text="Dr. Smith" /></span>
            </div>
        </header>

        <section class="quick-stats">
            <div class="stat-card">
                <h3>Today's Appointments</h3>
                <p class="stat-number"><asp:Label ID="lblTodayAppointments" runat="server" Text="12" /></p>
            </div>
            <div class="stat-card">
                <h3>Pending Prescriptions</h3>
                <p class="stat-number"><asp:Label ID="lblPendingPrescriptions" runat="server" Text="5" /></p>
            </div>
            <div class="stat-card">
                <h3>Total Patients</h3>
                <p class="stat-number"><asp:Label ID="lblTotalPatients" runat="server" Text="148" /></p>
            </div>
        </section>

        <section class="dashboard-content">
            <h2>Upcoming Patient Appointments</h2>
            
            <asp:GridView ID="gvAppointments" runat="server" AutoGenerateColumns="False" 
                CssClass="data-table" GridLines="None" OnRowCommand="gvAppointments_RowCommand">
                <Columns>
                    <asp:BoundField DataField="Time" HeaderText="Time" />
                    <asp:BoundField DataField="PatientName" HeaderText="Patient Name" />
                    <asp:BoundField DataField="Reason" HeaderText="Reason" />
                    <asp:TemplateField HeaderText="Status">
                        <ItemTemplate>
                            <span class='badge <%# Eval("StatusClass") %>'><%# Eval("Status") %></span>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Action">
                        <ItemTemplate>
                            <asp:Button ID="btnViewChart" runat="server" Text="View Chart" 
                                CssClass="btn-action" CommandName="ViewChart" 
                                CommandArgument='<%# Eval("PatientID") %>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </section>
    </div>

</asp:Content>
