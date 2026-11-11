<%@ Page Title="Doctor Dashboard" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="DoctorsDashBoard.aspx.cs" Inherits="WebApplication1.Private.Doctor.DoctorsDashBoard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    
    <style>
        .eb-grid { width: 100%; margin-bottom: 0; border-collapse: collapse; }
        .eb-grid thead th { 
            background-color: #1e5631 !important; 
            color: #ffffff !important; 
            padding: 16px 20px; 
            font-size: 0.85rem; 
            text-transform: uppercase; 
            letter-spacing: 0.5px; 
            border: none;
            font-weight: 600;
        }
        .eb-grid tbody td { 
            padding: 16px 20px; 
            vertical-align: middle; 
            border-bottom: 1px solid #edf2f0; 
            color: #495057;
        }
        .eb-grid tbody tr:hover { background-color: #f8f9fa; }
        .eb-card-header { background-color: #ffffff; border-bottom: 2px solid #edf2f0; padding: 20px; border-radius: 12px 12px 0 0; }
    </style>

    <div class="container mt-4" style="background-color: #f4f7f6; padding-bottom: 40px;">
        
        <!-- Header Banner -->
        <div class="card text-white mb-4 shadow-sm border-0" style="background-color: #1e5631; border-radius: 12px;">
            <div class="card-body py-4 d-flex justify-content-between align-items-center">
                <div>
                    <span class="badge mb-2" style="background-color: #2b7a43 !important;">EAST BOOM COMMUNITY HEALTH CENTRE</span>
                    <h2 class="card-title fw-bold mb-1">Doctor's Daily Appointments</h2>
                    <p class="card-text text-light mb-0">Manage and view scheduled patient consultations. Review clinical notes and vitals.</p>
                </div>
                <div class="text-end" style="background-color: rgba(255,255,255,0.1); padding: 10px 20px; border-radius: 8px;">
                    <small class="d-block text-light">Active Clinician</small>
                    <strong><asp:Label ID="lblDoctorName" runat="server" Text="Loading..."></asp:Label></strong>
                </div>
            </div>
        </div>

        <!-- Date Selector Card -->
        <div class="card shadow-sm border-0 mb-4" style="border-radius: 12px;">
            <div class="card-body p-4">
                <h6 class="text-muted fw-bold mb-3"><i class="fa fa-calendar"></i> SELECT CONSULTATION DATE</h6>
                <div class="d-flex gap-2 align-items-center">
                    <asp:TextBox ID="txtDateFilter" runat="server" TextMode="Date" CssClass="form-control w-25" AutoPostBack="true" OnTextChanged="txtDateFilter_TextChanged"></asp:TextBox>
                    <asp:Button ID="btnToday" runat="server" Text="Today" CssClass="btn text-white fw-bold px-4" style="background-color: #1e5631;" OnClick="btnToday_Click" />
                </div>
                <small class="text-muted mt-2 d-block">Showing appointments for <strong><asp:Label ID="lblDisplayDate" runat="server"></asp:Label></strong></small>
            </div>
        </div>

        <!-- 4 Summary Statistics Row (Back to original stats) -->
        <div class="row mb-4 row-cols-1 row-cols-md-4 g-3">
            <div class="col">
                <div class="card shadow-sm border-0 h-100" style="border-radius: 12px;">
                    <div class="card-body p-3">
                        <small class="text-muted fw-bold text-uppercase" style="font-size: 0.75rem;">Total Today</small>
                        <h2 class="fw-bold mt-2 text-dark"><asp:Label ID="lblTotalCount" runat="server" Text="0"></asp:Label></h2>
                    </div>
                </div>
            </div>
            <div class="col">
                <div class="card shadow-sm border-0 h-100" style="border-radius: 12px;">
                    <div class="card-body p-3">
                        <small class="text-muted fw-bold text-uppercase" style="font-size: 0.75rem;">Completed</small>
                        <h2 class="fw-bold mt-2" style="color: #28a745;"><asp:Label ID="lblCompletedCount" runat="server" Text="0"></asp:Label></h2>
                    </div>
                </div>
            </div>
            <div class="col">
                <div class="card shadow-sm border-0 h-100" style="border-radius: 12px;">
                    <div class="card-body p-3">
                        <small class="text-muted fw-bold text-uppercase" style="font-size: 0.75rem;">In Progress</small>
                        <h2 class="fw-bold mt-2" style="color: #fd7e14;"><asp:Label ID="lblInProgressCount" runat="server" Text="0"></asp:Label></h2>
                    </div>
                </div>
            </div>
            <div class="col">
                <div class="card shadow-sm border-0 h-100" style="border-radius: 12px;">
                    <div class="card-body p-3">
                        <small class="text-muted fw-bold text-uppercase" style="font-size: 0.75rem;">Pending</small>
                        <h2 class="fw-bold mt-2" style="color: #17a2b8;"><asp:Label ID="lblPendingCount" runat="server" Text="0"></asp:Label></h2>
                    </div>
                </div>
            </div>
        </div>

        <!-- GridView Card for Appointments -->
        <div class="card shadow-sm border-0 mb-4" style="border-radius: 12px; overflow: hidden;">
            <div class="eb-card-header d-flex justify-content-between align-items-center">
                <h5 class="fw-bold mb-0 text-dark">Patient Appointments</h5>
            </div>
            
            <asp:Label ID="lblErrorMessage" runat="server" CssClass="text-danger m-3 d-block"></asp:Label>
            
            <div class="table-responsive">
                <asp:GridView ID="gvAppointments" runat="server" AutoGenerateColumns="False" 
                    CssClass="table eb-grid" GridLines="None" 
                    EmptyDataText="<div class='p-4 text-center text-muted'>No appointments found for the selected date.</div>"
                    OnPreRender="gvAppointments_PreRender">
                    <Columns>
                        <asp:BoundField DataField="TimeSlots" HeaderText="TIME SLOT" ItemStyle-Width="15%" />
                        <asp:BoundField DataField="PatientName" HeaderText="PATIENT NAME" ItemStyle-Width="25%" ItemStyle-Font-Bold="true" ItemStyle-ForeColor="#212529" />
                        <asp:BoundField DataField="AgeGender" HeaderText="AGE / GENDER" ItemStyle-Width="15%" />
                        <asp:BoundField DataField="AppointmentReason" HeaderText="CHIEF COMPLAINT" ItemStyle-Width="25%" />
                        
                        <asp:TemplateField HeaderText="STATUS" ItemStyle-Width="10%">
                            <ItemTemplate>
                                <span class="badge rounded-pill px-3 py-2 text-white" 
                                    style='<%# Eval("AppointmentStatus").ToString() == "Completed" ? "background-color: #28a745;" : "background-color: #4da6ff;" %>'>
                                    <%# Eval("AppointmentStatus") %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="ACTIONS" ItemStyle-Width="10%">
                            <ItemTemplate>
                                <asp:LinkButton ID="btnViewConsultation" runat="server" 
                                    CssClass="btn btn-sm fw-bold px-3 py-2" 
                                    style="background-color: #e8f5e9; color: #1e5631; border-radius: 8px;"
                                    CommandArgument='<%# Eval("AppointmentID") %>' 
                                    OnClick="btnViewConsultation_Click">
                                    &#9876; Consultation
                                </asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>
        
    </div>
</asp:Content>