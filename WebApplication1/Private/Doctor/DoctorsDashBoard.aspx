<%@ Page Title="Doctor Dashboard" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="DoctorsDashBoard.aspx.cs" Inherits="WebApplication1.Private.Doctor.DoctorsDashBoard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container mt-4">
        
        <!-- Dashboard Header Banner -->
        <div class="card text-white mb-4" style="background-color: #2b5d34; border-radius: 8px;">
            <div class="card-body py-4">
                <h2 class="card-title fw-bold mb-1">Doctor Dashboard</h2>
                <p class="card-text text-light mb-0">View and manage your scheduled appointments for today.</p>
            </div>
        </div>

        <!-- Today's Schedule Card -->
        <div class="card shadow-sm border-0">
            <div class="card-header bg-white border-bottom py-3">
                <h4 class="mb-0 text-dark">
                    Schedule for <asp:Label ID="lblTodayDate" runat="server" Font-Bold="true"></asp:Label>
                </h4>
            </div>
            
            <div class="card-body">
                <asp:Label ID="lblErrorMessage" runat="server" CssClass="text-danger mb-3 d-block"></asp:Label>
                
                <div class="table-responsive">
                    <asp:GridView ID="gvAppointments" runat="server" AutoGenerateColumns="False" 
                        CssClass="table table-hover table-bordered align-middle" 
                        GridLines="None" EmptyDataText="You have no appointments scheduled for today.">
                        <Columns>
                            <asp:BoundField DataField="TimeSlots" HeaderText="Time" ItemStyle-Width="15%" />
                            <asp:BoundField DataField="PatientName" HeaderText="Patient Name" ItemStyle-Width="25%" />
                            <asp:BoundField DataField="AppointmentReason" HeaderText="Reason for Visit" ItemStyle-Width="30%" />
                            <asp:BoundField DataField="AppointmentStatus" HeaderText="Status" ItemStyle-Width="15%" />
                            <asp:TemplateField HeaderText="Action" ItemStyle-Width="15%">
                                <ItemTemplate>
                                    <asp:LinkButton ID="btnViewConsultation" runat="server" 
                                        CssClass="btn btn-sm text-white w-100" 
                                        style="background-color: #2b5d34;"
                                        CommandArgument='<%# Eval("AppointmentID") %>' 
                                        OnClick="btnViewConsultation_Click">
                                        View Patient
                                    </asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <HeaderStyle BackColor="#2b5d34" ForeColor="White" />
                        <RowStyle BackColor="#f8f9fa" />
                        <AlternatingRowStyle BackColor="White" />
                    </asp:GridView>
                </div>
            </div>
        </div>
        
    </div>
</asp:Content>