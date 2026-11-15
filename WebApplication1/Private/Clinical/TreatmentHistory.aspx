
<%@ Page Title="Treatment History" Language="C#" MasterPageFile="~/Site.Master"
    AutoEventWireup="true" CodeBehind="TreatmentHistory.aspx.cs"
    Inherits="WebApplication1.Private.Clinical.TreatmentHistory" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

<style>
    .history-container {
        max-width: 1200px;
        margin: 25px auto;
        padding: 0 18px 35px;
        color: #26352e;
    }

    .history-header {
        background: linear-gradient(135deg, #234d2b, #367344);
        color: white;
        padding: 25px 30px;
        border-radius: 12px;
        margin-bottom: 22px;
    }

    .history-header h2 {
        margin: 0 0 6px;
        font-weight: 700;
    }

    .history-header p {
        margin: 0 0 14px;
        color: #dce9dc;
    }

    .history-card {
        background: white;
        border: 1px solid #e1e8e2;
        border-radius: 10px;
        padding: 22px;
        margin-bottom: 22px;
        box-shadow: 0 3px 12px rgba(0,0,0,.045);
    }

    .history-heading {
        color: #24572d;
        font-size: 18px;
        font-weight: 700;
        margin-bottom: 18px;
    }

    .filter-label {
        display: block;
        font-weight: 600;
        color: #344b38;
        margin-bottom: 6px;
    }

    .history-input {
        width: 100%;
        min-height: 42px;
        padding: 9px 12px;
        border: 1px solid #ced8ce;
        border-radius: 6px;
        box-sizing: border-box;
    }

    .history-input:focus {
        outline: none;
        border-color: #367344;
        box-shadow: 0 0 0 3px rgba(54,115,68,.12);
    }

    .history-btn {
        background: #24572d;
        color: white;
        border: none;
        border-radius: 6px;
        padding: 10px 19px;
        font-weight: 600;
        cursor: pointer;
    }

    .history-btn:hover {
        background: #367344;
        color: white;
    }

    .history-grid-wrap {
        width: 100%;
        overflow-x: auto;
    }

    .history-grid {
        width: 100%;
        min-width: 700px;
        border-collapse: collapse;
        font-size: 14px;
        margin-top: 8px;
    }

    .history-grid th {
        background: #24572d;
        color: white;
        padding: 13px;
        text-align: left;
        white-space: nowrap;
    }

    .history-grid td {
        padding: 12px;
        border-bottom: 1px solid #e5eae6;
        vertical-align: middle;
        overflow-wrap: anywhere;
    }

    .history-grid tr:nth-child(even) {
        background: #f3f7f3;
    }

    .history-grid tr:hover {
        background: #e8f1e8;
    }

    .history-grid a {
        color: #24572d;
        font-weight: 600;
    }

    .history-grid-pager {
        background: #f3f7f3;
        padding: 12px;
        text-align: center;
    }

    .history-grid-pager table {
        margin: 0 auto;
    }

    .history-grid-pager td {
        border: none;
        padding: 4px 6px;
    }

    .history-grid-pager a {
        display: inline-block;
        background: #24572d;
        color: white;
        padding: 7px 12px;
        border-radius: 5px;
        text-decoration: none;
    }

    .history-grid-pager span {
        display: inline-block;
        background: #dce9dc;
        color: #234d2b;
        padding: 7px 12px;
        border-radius: 5px;
        font-weight: 700;
    }

    .details-section {
        border-top: 1px solid #e5eae6;
        padding-top: 18px;
        margin-top: 18px;
    }

    .details-label {
        display: block;
        color: #24572d;
        font-weight: 700;
        margin-bottom: 5px;
    }

    .details-value {
        display: block;
        background: #f3f7f3;
        border: 1px solid #e1e8e2;
        border-radius: 7px;
        padding: 12px;
        min-height: 42px;
        white-space: pre-wrap;
        overflow-wrap: anywhere;
        line-height: 1.5;
    }

    .details-field {
        margin-bottom: 17px;
    }

    .details-staff {
        background: #f3f7f3;
        border: 1px solid #e1e8e2;
        border-radius: 7px;
        padding: 12px;
        line-height: 1.7;
        overflow-wrap: anywhere;
    }

    @media(max-width: 600px) {
        .history-header {
            padding: 20px;
        }

        .history-card {
            padding: 15px;
        }
    }
</style>

<div class="history-container">

    <div class="history-header">
        <h2>Treatment History</h2>
        <p>Review previously recorded patient treatments and participating staff.</p>

        <a href="TreatmentInformation.aspx"
           class="btn btn-light btn-sm">
            Record New Treatment
        </a>
    </div>

    <!-- SEARCH AND FILTER -->
    <div class="history-card">

        <div class="history-heading">Search and Filter</div>

        <div class="row">

            <div class="col-md-4 mb-3">
                <label class="filter-label">Patient Name</label>
                <asp:TextBox ID="txtPatientSearch" runat="server"
                    CssClass="history-input"
                    placeholder="Enter patient name..." />
            </div>

            <div class="col-md-4 mb-3">
                <label class="filter-label">Treatment</label>
                <asp:DropDownList ID="ddlTreatmentFilter" runat="server"
                    CssClass="history-input" />
            </div>

            <div class="col-md-2 mb-3">
                <label class="filter-label">From Date</label>
                <asp:TextBox ID="txtDateFrom" runat="server"
                    TextMode="Date" CssClass="history-input" />
            </div>

            <div class="col-md-2 mb-3">
                <label class="filter-label">To Date</label>
                <asp:TextBox ID="txtDateTo" runat="server"
                    TextMode="Date" CssClass="history-input" />
            </div>

        </div>

        <div class="d-flex flex-wrap gap-2">

            <asp:Button ID="btnSearch" runat="server"
                Text="Search"
                CssClass="history-btn"
                OnClick="btnSearch_Click" />

            <asp:Button ID="btnReset" runat="server"
                Text="Clear Filters"
                CssClass="btn btn-outline-secondary"
                OnClick="btnReset_Click"
                CausesValidation="false" />

        </div>

    </div>

    <!-- COMPACT HISTORY TABLE -->
    <div class="history-card">

        <div class="history-heading">Recorded Treatments</div>

        <p class="text-muted">
            Select View to inspect the complete clinical record.
        </p>

        <div class="history-grid-wrap">

            <asp:GridView ID="gvTreatmentHistory" runat="server"
                AutoGenerateColumns="False"
                DataKeyNames="treatmentInformationID"
                CssClass="history-grid"
                GridLines="None"
                AllowPaging="True"
                PageSize="8"
                OnPageIndexChanging="gvTreatmentHistory_PageIndexChanging"
                OnSelectedIndexChanged="gvTreatmentHistory_SelectedIndexChanged"
                EmptyDataText="No treatment records were found.">

                <Columns>

                    <asp:BoundField DataField="treatmentInformationID"
                        HeaderText="Record ID" />

                    <asp:BoundField DataField="PatientName"
                        HeaderText="Patient" />

                    <asp:BoundField DataField="TreatmentName"
                        HeaderText="Treatment" />

                    <asp:BoundField DataField="perfomed_at"
                        HeaderText="Date Performed"
                        DataFormatString="{0:dd MMM yyyy HH:mm}" />

                    <asp:BoundField DataField="StaffNames"
                        HeaderText="Participating Staff" />

                    <asp:CommandField
                        ShowSelectButton="True"
                        SelectText="View" />

                </Columns>

                <HeaderStyle BackColor="#24572d"
                    ForeColor="White" Font-Bold="True" />

                <AlternatingRowStyle BackColor="#f3f7f3" />

                <SelectedRowStyle BackColor="#e8f1e8" />

                <PagerStyle CssClass="history-grid-pager" />

            </asp:GridView>

        </div>

    </div>

    <!-- SELECTED TREATMENT DETAILS -->
    <asp:Panel ID="pnlTreatmentDetails" runat="server"
        Visible="false" CssClass="history-card">

        <div class="history-heading">
            Treatment Record Details
        </div>

        <div class="row">

            <div class="col-md-6 details-field">
                <span class="details-label">Record ID</span>
                <asp:Label ID="lblDetailRecordID" runat="server"
                    CssClass="details-value" />
            </div>

            <div class="col-md-6 details-field">
                <span class="details-label">Patient</span>
                <asp:Label ID="lblDetailPatient" runat="server"
                    CssClass="details-value" />
            </div>

            <div class="col-md-6 details-field">
                <span class="details-label">Treatment</span>
                <asp:Label ID="lblDetailTreatment" runat="server"
                    CssClass="details-value" />
            </div>

            <div class="col-md-6 details-field">
                <span class="details-label">Date and Time Performed</span>
                <asp:Label ID="lblDetailDate" runat="server"
                    CssClass="details-value" />
            </div>

            <div class="col-md-6 details-field">
                <span class="details-label">Appointment</span>
                <asp:Label ID="lblDetailAppointment" runat="server"
                    CssClass="details-value" />
            </div>

            <div class="col-md-6 details-field">
                <span class="details-label">Recorded By</span>
                <asp:Label ID="lblDetailRecordedBy" runat="server"
                    CssClass="details-value" />
            </div>

        </div>

        <div class="details-section">

            <div class="details-field">
                <span class="details-label">Diagnosis</span>
                <asp:Label ID="lblDetailDiagnosis" runat="server"
                    CssClass="details-value" />
            </div>

            <div class="details-field">
                <span class="details-label">Results</span>
                <asp:Label ID="lblDetailResults" runat="server"
                    CssClass="details-value" />
            </div>

            <div class="details-field">
                <span class="details-label">Additional Notes</span>
                <asp:Label ID="lblDetailNotes" runat="server"
                    CssClass="details-value" />
            </div>

        </div>

        <div class="details-section">

            <div class="history-heading">Participating Staff</div>

            <div class="row">

                <div class="col-md-6 details-field">
                    <span class="details-label">Doctors</span>
                    <asp:Label ID="lblDetailDoctors" runat="server"
                        CssClass="details-staff" />
                </div>

                <div class="col-md-6 details-field">
                    <span class="details-label">Nurses</span>
                    <asp:Label ID="lblDetailNurses" runat="server"
                        CssClass="details-staff" />
                </div>

            </div>

        </div>

    </asp:Panel>

</div>

</asp:Content>
