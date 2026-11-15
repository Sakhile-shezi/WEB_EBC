

<%@ Page Title="Create Prescription" Language="C#" MasterPageFile="~/Site.Master"
    AutoEventWireup="true" CodeBehind="PrescriptionManagement.aspx.cs"
    Inherits="WebApplication1.Private.Doctor.PrescriptionManagement" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

<style>
    .pres-page {
        max-width: 1400px;
        margin: 25px auto;
        padding: 0 18px 35px;
        color: #26352e;
    }

    .pres-heading {
        background: #234d2b;
        color: white;
        padding: 25px 30px;
        border-radius: 10px;
        margin-bottom: 22px;
    }

    .pres-heading h2 {
        margin: 0 0 6px;
        font-weight: 600;
    }

    .pres-heading p {
        margin: 0;
        color: #dce9dc;
    }

    .pres-card {
        background: white;
        border: 1px solid #e1e8e2;
        border-radius: 10px;
        padding: 22px;
        margin-bottom: 22px;
        box-shadow: 0 3px 12px rgba(0,0,0,.045);
    }

    .pres-card h4 {
        color: #234d2b;
        font-size: 18px;
        font-weight: 600;
        margin: 0 0 18px;
        padding-bottom: 12px;
        border-bottom: 2px solid #e5eee5;
    }

    .pres-label {
        display: block;
        font-weight: 600;
        margin-bottom: 6px;
        color: #34483a;
    }

    .pres-input {
        width: 100%;
        padding: 10px 11px;
        border: 1px solid #ccd8ce;
        border-radius: 6px;
        box-sizing: border-box;
    }

    .pres-input:focus {
        outline: none;
        border-color: #43834c;
        box-shadow: 0 0 0 3px rgba(67,131,76,.12);
    }

    .pres-button {
        background: #24572d;
        color: white;
        border: none;
        border-radius: 6px;
        padding: 11px 19px;
        cursor: pointer;
        font-weight: 600;
    }

    .pres-button:hover {
        background: #367641;
        color: white;
    }

    .pres-button-secondary {
        background: #edf3ee;
        color: #234d2b;
        border: 1px solid #cbdccc;
        border-radius: 6px;
        padding: 11px 19px;
        cursor: pointer;
        font-weight: 600;
    }

    .pres-button-secondary:hover {
        background: #dce9dc;
        color: #234d2b;
    }

    .pres-help {
        color: #6b786e;
        font-size: 13px;
        margin-top: 8px;
        margin-bottom: 0;
    }

    .pres-grid-wrap {
        width: 100%;
        overflow-x: auto;
    }

    .pres-grid {
        width: 100%;
        border-collapse: collapse;
        margin-top: 12px;
        font-size: 14px;
    }

    .pres-grid th,
    .pres-grid th a,
    .pres-grid th a:visited,
    .pres-grid th a:hover {
        background: #24572d !important;
        color: white !important;
        padding: 13px 12px;
        text-align: left;
        white-space: nowrap;
        border: none;
        font-weight: 700;
        text-decoration: none;
    }

    .pres-grid td {
        padding: 12px;
        border-bottom: 1px solid #e5eae6;
        vertical-align: middle;
        white-space: nowrap;
    }

    .pres-grid tr:nth-child(even) td {
        background: #f3f7f3;
    }

    .pres-grid tr:hover td {
        background: #e8f1e8;
    }

    .pres-grid a {
        color: #246333;
        font-weight: 600;
        text-decoration: none;
    }

    .pres-grid a:hover {
        text-decoration: underline;
    }

    .pres-grid-pager {
        background: #f3f7f3;
        padding: 14px;
        text-align: center;
        border-top: 1px solid #e1e8e2;
    }

    .pres-grid-pager table {
        margin: 0 auto;
    }

    .pres-grid-pager td {
        padding: 4px 7px !important;
        border: none !important;
    }

    .pres-grid-pager a {
        display: inline-block;
        padding: 8px 14px;
        background: #24572d;
        color: white !important;
        border-radius: 5px;
        text-decoration: none;
        font-weight: 600;
    }

    .pres-grid-pager a:hover {
        background: #367641;
    }

    .pres-grid-pager span {
        display: inline-block;
        padding: 8px 14px;
        background: #dce9dc;
        color: #234d2b;
        border-radius: 5px;
        font-weight: 700;
    }

    .pres-grid .pres-selected-row,
    .pres-grid .pres-selected-row td {
        background: #c8e6c9 !important;
        color: #1b4323 !important;
        font-weight: 600;
    }

    .pres-grid .pres-selected-row:hover td {
        background: #b7dabb !important;
    }

    .pres-message {
        display: block;
        padding: 13px 16px;
        border-radius: 5px;
        margin-bottom: 18px;
        border-left: 4px solid;
    }

    .pres-success {
        color: #24572d;
        background: #f3f7f3;
        border-left-color: #43834c;
    }

    .pres-error {
        color: #a52b25;
        background: #fff1f0;
        border-left-color: #c84b43;
    }

    .pres-detail-message {
        display: block;
        color: #6b786e;
        background: #f3f7f3;
        border-left: 4px solid #43834c;
        padding: 12px 15px;
        border-radius: 4px;
        margin-top: 15px;
    }

    .pres-selected-patient {
        background: #f3f7f3;
        border-left: 4px solid #43834c;
        border-radius: 4px;
        padding: 12px 15px;
        margin-top: 15px;
    }

    .pres-doctor {
        color: #6b786e;
        display: block;
        margin-top: 15px;
    }

    @media (max-width: 768px) {
        .pres-heading {
            padding: 20px;
        }

        .pres-card {
            padding: 16px;
        }
    }
</style>

<div class="pres-page">

    <!-- PAGE HEADER -->
    <div class="pres-heading">
        <h2>Create Prescription</h2>
        <p>Create a prescription and add one or more medicines.</p>
    </div>

    <!-- NOTIFICATIONS -->
    <asp:Panel ID="pnlSuccess" runat="server"
        Visible="false"
        CssClass="pres-message pres-success">
        <asp:Label ID="lblSuccess" runat="server" />
    </asp:Panel>

    <asp:Panel ID="pnlError" runat="server"
        Visible="false"
        CssClass="pres-message pres-error">
        <asp:Label ID="lblError" runat="server" />
    </asp:Panel>

    <!-- 1. PATIENT INFORMATION -->
    <div class="pres-card">

        <h4>1. Patient Information</h4>

        <div class="row g-3 align-items-end">

            <div class="col-md-9">
                <asp:Label ID="lblPatientSearch" runat="server"
                    AssociatedControlID="txtPatientSearch"
                    CssClass="pres-label">
                    Search Patient
                </asp:Label>

                <asp:TextBox ID="txtPatientSearch" runat="server"
                    CssClass="pres-input"
                    placeholder="Search by name, patient ID, national ID or file number..." />

                <p class="pres-help">
                    You can search using the patient's name, database ID,
                    national identification number or patient file number.
                </p>
            </div>

            <div class="col-md-3">
                <asp:Button ID="btnSearchPatient" runat="server"
                    Text="Search Patients"
                    CssClass="pres-button w-100"
                    CausesValidation="false"
                    OnClick="btnSearchPatient_Click" />
            </div>

        </div>

        <div class="pres-grid-wrap mt-3">

            <asp:GridView ID="gvPatients" runat="server"
                AutoGenerateColumns="False"
                DataKeyNames="PatientID,FullName,IdNumber,PatientFileNumber,DateOfBirth"
                CssClass="pres-grid"
                GridLines="None"
                AllowPaging="True"
                PageSize="5"
                PagerSettings-Mode="NextPrevious"
                PagerSettings-NextPageText="Next →"
                PagerSettings-PreviousPageText="← Previous"
                PagerSettings-Position="Bottom"
                PagerStyle-CssClass="pres-grid-pager"
                EmptyDataText="No patients found."
                OnPageIndexChanging="gvPatients_PageIndexChanging"
                OnSelectedIndexChanged="gvPatients_SelectedIndexChanged">

                <Columns>

                    <asp:BoundField
                        DataField="PatientID"
                        HeaderText="Patient ID" />

                    <asp:BoundField
                        DataField="FullName"
                        HeaderText="Patient Name" />

                    <asp:BoundField
                        DataField="IdNumber"
                        HeaderText="National ID Number" />

                    <asp:BoundField
                        DataField="PatientFileNumber"
                        HeaderText="Patient File No." />

                    <asp:BoundField
                        DataField="DateOfBirth"
                        HeaderText="Date of Birth"
                        DataFormatString="{0:dd MMM yyyy}"
                        HtmlEncode="false"
                        NullDisplayText="Not recorded" />

                    <asp:CommandField
                        ShowSelectButton="True"
                        SelectText="Select Patient" />

                </Columns>

                <SelectedRowStyle CssClass="pres-selected-row" />

            </asp:GridView>

        </div>

        <div class="pres-selected-patient">
            <asp:Label ID="lblSelectedPatient" runat="server"
                Text="No patient selected."
                CssClass="fw-bold" />
        </div>

        <asp:HiddenField ID="hfPatientID" runat="server" />

        <asp:Label ID="lblDoctor" runat="server"
            CssClass="pres-doctor" />

    </div>

    <!-- 2. ADD MEDICINE -->
    <div class="pres-card">

        <h4>2. Add Medicine</h4>

        <div class="mb-3">

            <asp:Label ID="lblMedicine" runat="server"
                AssociatedControlID="ddlMedicine"
                CssClass="pres-label">
                Medicine
            </asp:Label>

            <asp:DropDownList ID="ddlMedicine" runat="server"
                CssClass="pres-input" />

            <p class="pres-help">
                The medicine's dosage unit is displayed alongside its name.
            </p>

        </div>

        <div class="row">

            <div class="col-md-6 mb-3">
                <asp:Label ID="lblDosage" runat="server"
                    AssociatedControlID="txtDosage"
                    CssClass="pres-label">
                    Dosage (including unit)
                </asp:Label>

                <asp:TextBox ID="txtDosage" runat="server"
                    CssClass="pres-input"
                    MaxLength="50"
                    placeholder="e.g. 5 ml, 1 tablet, 200 mg" />

                <p class="pres-help">
                    Specify the amount and measurement unit.
                </p>
            </div>

            <div class="col-md-6 mb-3">
                <asp:Label ID="lblFrequency" runat="server"
                    AssociatedControlID="txtFrequency"
                    CssClass="pres-label">
                    Frequency
                </asp:Label>

                <asp:TextBox ID="txtFrequency" runat="server"
                    CssClass="pres-input"
                    MaxLength="50"
                    placeholder="e.g. Twice daily" />
            </div>

            <div class="col-md-6 mb-3">
                <asp:Label ID="lblDuration" runat="server"
                    AssociatedControlID="txtDuration"
                    CssClass="pres-label">
                    Duration (days)
                </asp:Label>

                <asp:TextBox ID="txtDuration" runat="server"
                    CssClass="pres-input"
                    TextMode="Number"
                    placeholder="e.g. 5" />
            </div>

            <div class="col-md-6 mb-3">
                <asp:Label ID="lblInstruction" runat="server"
                    AssociatedControlID="txtInstruction"
                    CssClass="pres-label">
                    Instructions
                </asp:Label>

                <asp:TextBox ID="txtInstruction" runat="server"
                    CssClass="pres-input"
                    MaxLength="200"
                    placeholder="e.g. Take after meals" />
            </div>

        </div>

        <asp:Button ID="btnAddMedicine" runat="server"
            Text="+ Add Medicine"
            CssClass="pres-button"
            CausesValidation="false"
            OnClick="btnAddMedicine_Click" />

    </div>

    <!-- 3. PRESCRIPTION MEDICINES -->
    <div class="pres-card">

        <h4>3. Prescription Medicines</h4>

        <asp:Label ID="lblEmptyList" runat="server"
            Text="No medicines have been added yet."
            CssClass="pres-help" />

        <div class="pres-grid-wrap">

            <asp:GridView ID="gvMedicines" runat="server"
                AutoGenerateColumns="False"
                CssClass="pres-grid"
                GridLines="None"
                EmptyDataText="No medicines added.">

                <Columns>

                    <asp:BoundField
                        DataField="MedicineName"
                        HeaderText="Medicine" />

                    <asp:BoundField
                        DataField="Dosage"
                        HeaderText="Dosage" />

                    <asp:BoundField
                        DataField="Frequency"
                        HeaderText="Frequency" />

                    <asp:BoundField
                        DataField="Duration"
                        HeaderText="Duration (days)" />

                    <asp:BoundField
                        DataField="Instruction"
                        HeaderText="Instructions" />

                </Columns>

            </asp:GridView>

        </div>

        <div class="mt-4">

            <asp:Button ID="btnSavePrescription" runat="server"
                Text="Save Prescription"
                CssClass="pres-button"
                OnClick="btnSavePrescription_Click" />

            <asp:Button ID="btnClear" runat="server"
                Text="Clear"
                CssClass="pres-button-secondary ms-2"
                CausesValidation="false"
                OnClick="btnClear_Click" />

        </div>

    </div>

</div>

</asp:Content>

