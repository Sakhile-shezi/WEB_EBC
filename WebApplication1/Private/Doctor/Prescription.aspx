
<%@ Page Title="Prescription History" Language="C#" MasterPageFile="~/Site.Master"
    AutoEventWireup="true" CodeBehind="Prescription.aspx.cs"
    Inherits="WebApplication1.Private.Doctor.Prescription" %>

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
        max-width: 100%;
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
        width: 100%;
    }

    .pres-button:hover {
        background: #367641;
    }

    .pres-help {
        color: #6b786e;
        font-size: 13px;
        margin-top: 14px;
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

    .pres-grid th {
        background: #24572d;
        color: white;
        padding: 13px 12px;
        text-align: left;
        white-space: nowrap;
        border: none;
    }

    .pres-grid td {
        padding: 12px;
        border-bottom: 1px solid #e5eae6;
        vertical-align: middle;
    }

    .pres-grid tr:nth-child(even) {
        background: #f3f7f3;
    }

    .pres-grid tr:hover {
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

    .pres-detail-message {
        display: block;
        color: #6b786e;
        background: #f3f7f3;
        border-left: 4px solid #43834c;
        padding: 12px 15px;
        border-radius: 4px;
        margin-bottom: 15px;
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

    <!-- Page heading -->
    <div class="pres-heading">
        <h2>Prescription History</h2>
        <p>Review and search prescriptions issued to your patients.</p>
    </div>

    <!-- Search section -->
    <div class="pres-card">

        <h4>Search Prescriptions</h4>

        <div class="row g-3 align-items-end">

            <!-- Patient name -->
            <div class="col-md-5">

                <asp:Label ID="lblPatient" runat="server"
                    AssociatedControlID="TBPatient"
                    CssClass="pres-label">
                    Patient Name
                </asp:Label>

                <asp:TextBox ID="TBPatient" runat="server"
                    CssClass="pres-input"
                    placeholder="Enter patient name..." />

            </div>

            <!-- Date -->
            <div class="col-md-4">

                <asp:Label ID="lblDate" runat="server"
                    AssociatedControlID="TBDate"
                    CssClass="pres-label">
                    Date Issued
                </asp:Label>

                <asp:TextBox ID="TBDate" runat="server"
                    TextMode="Date"
                    CssClass="pres-input" />

                <asp:RequiredFieldValidator
                    ID="RequiredDateValidator"
                    runat="server"
                    ControlToValidate="TBDate"
                    ErrorMessage="Please select a date."
                    CssClass="text-danger"
                    Display="Dynamic"
                    ValidationGroup="PrescriptionSearch" />

            </div>

            <!-- Search button -->
            <div class="col-md-3">

                <asp:Button ID="BtnSearch" runat="server"
                    Text="Search Prescriptions"
                    CssClass="pres-button"
                    ValidationGroup="PrescriptionSearch"
                    OnClick="BtnSearch_Click" />

            </div>

        </div>

        <p class="pres-help">
            Leave the patient name empty to view all prescriptions
            issued on the selected date.
        </p>

    </div>

    <!-- Prescription records -->
    <div class="pres-card">

        <h4>Prescription Records</h4>

        <p class="pres-help">
            Select a prescription to view its associated medicines and instructions.
        </p>

        <div class="pres-grid-wrap">

            <asp:GridView ID="GridView1" runat="server"
                AutoGenerateColumns="False"
                DataKeyNames="PrescriptionID"
                DataSourceID="SqlDSPrescription"
                AllowSorting="True"
                CssClass="pres-grid"
                GridLines="None"
                EmptyDataText="No prescriptions found for the selected search criteria."
                OnSelectedIndexChanged="GridView1_SelectedIndexChanged">

                <Columns>

                    <asp:CommandField
                        ShowSelectButton="True"
                        SelectText="View Details" />

                    <asp:BoundField
                        DataField="PrescriptionID"
                        HeaderText="Prescription No."
                        SortExpression="PrescriptionID" />

                    <asp:BoundField
                        DataField="Doctor"
                        HeaderText="Doctor"
                        SortExpression="Doctor" />

                    <asp:BoundField
                        DataField="Patient"
                        HeaderText="Patient"
                        SortExpression="Patient" />

                    <asp:BoundField
                        DataField="DateIssued"
                        HeaderText="Date Issued"
                        DataFormatString="{0:dd MMM yyyy, HH:mm}"
                        SortExpression="DateIssued" />

                </Columns>

            </asp:GridView>

        </div>

    </div>

    <!-- Prescription details -->
    <div class="pres-card">

        <h4>Prescription Details</h4>

        <asp:Label ID="lblDetails" runat="server"
            CssClass="pres-detail-message"
            Text="Select a prescription above to view its medicine details." />

        <div class="pres-grid-wrap">

            <asp:GridView ID="GridView2" runat="server"
                AutoGenerateColumns="False"
                DataKeyNames="PrescriptionItemID"
                DataSourceID="SqlDSPrescriptionItems"
                CssClass="pres-grid"
                GridLines="None"
                EmptyDataText="No prescription items found.">

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
                        HeaderText="Duration (Days)" />

                    <asp:BoundField
                        DataField="Instruction"
                        HeaderText="Instructions" />

                </Columns>

            </asp:GridView>

        </div>

    </div>

</div>


<!-- Prescription Search DataSource -->
<asp:SqlDataSource ID="SqlDSPrescription"
    runat="server"
    ConnectionString="<%$ ConnectionStrings:GroupPmb6ConnectionString %>"
    SelectCommand="
        SELECT
            Prescriptions.PrescriptionID,
            Doctor.FullName AS Doctor,
            Patient.FullName AS Patient,
            Prescriptions.DateIssued
        FROM Prescriptions
        INNER JOIN Doctor
            ON Prescriptions.DoctorID = Doctor.DoctorID
        INNER JOIN Patient
            ON Prescriptions.PatientID = Patient.PatientID
        WHERE
            Doctor.UserId = @id
            AND Prescriptions.DateIssued >= @date
            AND Prescriptions.DateIssued < DATEADD(DAY, 1, @date)
            AND (
                @name IS NULL
                OR @name = ''
                OR Patient.FullName LIKE '%' + @name + '%'
            )
        ORDER BY Prescriptions.DateIssued DESC">

    <SelectParameters>

        <asp:ControlParameter
            ControlID="TBPatient"
            Name="name"
            PropertyName="Text"
            Type="String"
            ConvertEmptyStringToNull="true" />

        <asp:Parameter
            Name="id"
            Type="String" />

        <asp:ControlParameter
            ControlID="TBDate"
            Name="date"
            PropertyName="Text"
            Type="DateTime" />

    </SelectParameters>

</asp:SqlDataSource>


<!-- Prescription Items DataSource -->
<asp:SqlDataSource ID="SqlDSPrescriptionItems"
    runat="server"
    ConnectionString="<%$ ConnectionStrings:GroupPmb6ConnectionString %>"
    SelectCommand="
        SELECT
            PrescriptionItem.PrescriptionItemID,
            PrescriptionItem.PrescriptionID,
            PrescriptionItem.MedicineID,
            PrescriptionItem.Dosage,
            PrescriptionItem.Frequency,
            PrescriptionItem.Duration,
            PrescriptionItem.Instruction,
            Medicine.MedicineName
        FROM PrescriptionItem
        INNER JOIN Medicine
            ON PrescriptionItem.MedicineID = Medicine.MedicineID
        WHERE PrescriptionItem.PrescriptionID = @id">

    <SelectParameters>

        <asp:ControlParameter
            ControlID="GridView1"
            Name="id"
            PropertyName="SelectedValue"
            Type="Int32"
            DefaultValue="0" />

    </SelectParameters>

</asp:SqlDataSource>

</asp:Content>
