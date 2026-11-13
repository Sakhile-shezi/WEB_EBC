

<%@ Page Title="Medication Administration" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="MedicationAdministration.aspx.cs" Inherits="WebApplication1.Private.Nurse.MedicationAdministration" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

<style>
    .med-page {
        max-width: 1400px;
        margin: 25px auto;
        padding: 0 18px 35px;
        color: #26352e;
    }

    .med-heading {
        background: #234d2b;
        color: white;
        padding: 25px 30px;
        border-radius: 10px;
        margin-bottom: 22px;
    }

    .med-heading h2 {
        margin: 0 0 6px;
        font-weight: 600;
    }

    .med-heading p {
        margin: 0;
        color: #dce9dc;
    }

    .med-card {
        background: white;
        border: 1px solid #e1e8e2;
        border-radius: 10px;
        padding: 22px;
        margin-bottom: 22px;
        box-shadow: 0 3px 12px rgba(0,0,0,.045);
    }

    .med-card h4 {
        color: #234d2b;
        font-size: 18px;
        font-weight: 600;
        margin: 0 0 18px;
        padding-bottom: 12px;
        border-bottom: 2px solid #e5eee5;
    }

    .med-label {
        display: block;
        font-weight: 600;
        margin-bottom: 6px;
        color: #34483a;
    }

    .med-input {
        width: 100%;
        padding: 9px 11px;
        border: 1px solid #ccd8ce;
        border-radius: 6px;
        box-sizing: border-box;
        margin-bottom: 14px;
    }

    .med-button {
        background: #24572d;
        color: white;
        border: none;
        border-radius: 6px;
        padding: 10px 19px;
        cursor: pointer;
        font-weight: 600;
        margin: 4px 4px 4px 0;
    }

    .med-button:hover {
        background: #367641;
    }

    .med-grid {
        width: 100%;
        border-collapse: collapse;
        margin-top: 12px;
        font-size: 13px;
    }

    .med-grid th {
        background: #24572d !important;
        color: white !important;
        padding: 12px 10px;
        text-align: left;
        white-space: nowrap;
    }

    .med-grid th a,
    .med-grid th a:visited,
    .med-grid th a:hover {
        color: white !important;
    }

    .med-grid td {
        padding: 11px 10px;
        border-bottom: 1px solid #e5eae6;
    }

    .med-grid tr:nth-child(even) {
        background: #f3f7f3;
    }

    .med-grid tr:hover {
        background: #e8f1e8;
    }

    .med-grid a {
        color: #246333;
        font-weight: 600;
    }

    .med-grid-wrap {
        width: 100%;
        overflow-x: auto;
    }

    .med-columns {
        display: grid;
        grid-template-columns: repeat(2, minmax(0, 1fr));
        gap: 22px;
    }

    .med-help {
        color: #6b786e;
        font-size: 13px;
        margin-top: -10px;
        margin-bottom: 14px;
    }

    .med-selected-row {
        background: #dcebdc !important;
        font-weight: 600;
    }

    @media (max-width: 800px) {
        .med-columns {
            grid-template-columns: 1fr;
        }

        .med-card {
            padding: 16px;
        }
    }
</style>

<div class="med-page">

    <div class="med-heading">
        <h2>Medication Administration</h2>
        <p>Review prescribed medication, administration progress and nursing records.</p>
    </div>
    <div class="medicationAdministration-hero" style="background-image:url('<%= ResolveUrl("~/Images/WhatsApp Image 2026-09-02 at 10.38.35.jpeg") %>');">
    <div class="medicationAdministration-hero">
       
       
    </div>
</div>

    <!-- Medication overview -->
    <div class="med-card">
        <h4>Medication Overview</h4>

        <p class="med-help">
            View prescribed medication and its administration progress.
            Select a medication to inspect its administration history.
        </p>

        <div class="med-columns">
            <div>
                <label class="med-label" for="<%= TBPatient.ClientID %>">
                    Patient name
                </label>
                <asp:TextBox ID="TBPatient" runat="server"
                    CssClass="med-input"
                    placeholder="Search by patient name" />
            </div>

            <div>
                <label class="med-label" for="<%= TBDate.ClientID %>">
                    Prescription date
                </label>
                <asp:TextBox ID="TBDate" runat="server"
                    CssClass="med-input"
                    TextMode="Date" />
            </div>
        </div>

        <asp:Button ID="BtnSearch" runat="server"
            Text="Search"
            CssClass="med-button"
            OnClick="BtnSearch_Click" />

        <asp:Button ID="BtnClear" runat="server"
            Text="Clear filters"
            CssClass="med-button"
            CausesValidation="false"
            OnClick="BtnClear_Click" />

        <div class="med-grid-wrap">
            <asp:GridView ID="GVMedicationAdmin" runat="server"
                AutoGenerateColumns="False"
                DataKeyNames="PrescriptionItemID"
                DataSourceID="SqlDSMedicationOverview"
                CssClass="med-grid"
                GridLines="None"
                AllowPaging="True"
                PageSize="10"
                AllowSorting="True"
                EmptyDataText="No prescribed medications found."
                OnSelectedIndexChanged="GVMedicationAdmin_SelectedIndexChanged"
                OnPageIndexChanging="GVMedicationAdmin_PageIndexChanging">

                <Columns>
                    <asp:CommandField ShowSelectButton="True" SelectText="View history" />

                    <asp:BoundField DataField="Patient" HeaderText="Patient" />
                    <asp:BoundField DataField="MedicineName" HeaderText="Medicine" />
                    <asp:BoundField DataField="Dosage" HeaderText="Prescribed dosage" />
                    <asp:BoundField DataField="DosageUnit" HeaderText="Unit" />
                    <asp:BoundField DataField="Frequency" HeaderText="Per day" />
                    <asp:BoundField DataField="Duration" HeaderText="Duration (days)" />
                    <asp:BoundField DataField="ExpectedAdministrations" HeaderText="Expected" />
                    <asp:BoundField DataField="AdministeredCount" HeaderText="Administered" />
                    <asp:BoundField DataField="PartiallyAdministeredCount" HeaderText="Partial" />
                    <asp:BoundField DataField="RemainingAdministrations" HeaderText="Remaining" />
                    <asp:BoundField DataField="NurseBreakdown" HeaderText="Nurse contributions" />
                    <asp:BoundField DataField="Doctor" HeaderText="Prescribed by" />
                    <asp:BoundField DataField="DateIssued" HeaderText="Date issued"
                        DataFormatString="{0:dd MMM yyyy}" />
                </Columns>

                <SelectedRowStyle CssClass="med-selected-row" />
            </asp:GridView>
        </div>
    </div>

    <!-- Selected prescription item -->
    <asp:Panel ID="pnlSelectedDetails" runat="server" Visible="false">

        <div class="med-card">
            <h4>Administration History</h4>

            <p class="med-help">
                Each row represents an individual administration record.
                Select a record to view the nurse's notes.
            </p>

            <div class="med-grid-wrap">
                <asp:GridView ID="GVAdministrationHistory" runat="server"
                    AutoGenerateColumns="False"
                    DataKeyNames="medication_AdministrationID"
                    DataSourceID="SqlDSAdministrationHistory"
                    CssClass="med-grid"
                    GridLines="None"
                    AllowPaging="True"
                    PageSize="10"
                    EmptyDataText="No administration records have been recorded for this medication."
                    OnSelectedIndexChanged="GVAdministrationHistory_SelectedIndexChanged">

                    <Columns>
                        <asp:CommandField ShowSelectButton="True" SelectText="View notes" />
                        <asp:BoundField DataField="FullName" HeaderText="Nurse" />
                        <asp:BoundField DataField="dosageGiven" HeaderText="Dosage given" />
                        <asp:BoundField DataField="status" HeaderText="Status" />
                        <asp:BoundField DataField="Admnistered_at"
                            HeaderText="Administration date"
                            DataFormatString="{0:dd MMM yyyy HH:mm}" />
                        <asp:BoundField DataField="Notes" HeaderText="Administration notes" />
                    </Columns>

                    <SelectedRowStyle CssClass="med-selected-row" />
                </asp:GridView>
            </div>
        </div>

        <div class="med-columns">

            <div class="med-card">
                <h4>Doctor's Instructions</h4>

                <p class="med-help">
                    Instructions attached to the selected prescription item.
                </p>

                <asp:DetailsView ID="DetailsView1" runat="server"
                    AutoGenerateRows="False"
                    DataSourceID="SqlDSDocNotes"
                    CssClass="med-grid"
                    GridLines="None"
                    EmptyDataText="No instructions available.">
                    <Fields>
                        <asp:BoundField DataField="Instruction"
                            HeaderText="Instructions" />
                        <asp:BoundField DataField="DateIssued"
                            HeaderText="Date prescribed"
                            DataFormatString="{0:dd MMM yyyy}" />
                    </Fields>
                </asp:DetailsView>
            </div>

            <div class="med-card">
                <h4>Nurse's Administration Notes</h4>

                <p class="med-help">
                    Notes associated with the selected administration record.
                </p>

                <asp:DetailsView ID="DetailsView2" runat="server"
                    AutoGenerateRows="False"
                    DataSourceID="SqlDSMedNotes"
                    CssClass="med-grid"
                    GridLines="None"
                    EmptyDataText="Select an administration record to view its notes.">
                    <Fields>
                        <asp:BoundField DataField="Notes"
                            HeaderText="Nurse's notes" />
                    </Fields>
                </asp:DetailsView>
            </div>

        </div>

    </asp:Panel>

    <!-- Main overview query -->
    <asp:SqlDataSource ID="SqlDSMedicationOverview" runat="server"
        ConnectionString="<%$ ConnectionStrings:GroupPmb6ConnectionString %>"
        CancelSelectOnNullParameter="False"
        SelectCommand="
        SELECT
            PI.PrescriptionItemID,
            P.PrescriptionID,
            PA.PatientID,
            PA.FullName AS Patient,
            D.FullName AS Doctor,
            P.DateIssued,
            M.MedicineName,
            M.DosageUnit,
            PI.Dosage,
            PI.Frequency,
            PI.Duration,

            (PI.Frequency * PI.Duration) AS ExpectedAdministrations,

            COUNT(CASE
                WHEN MA.status = 'Administered' THEN 1
            END) AS AdministeredCount,

            COUNT(CASE
                WHEN MA.status = 'Partially Administered' THEN 1
            END) AS PartiallyAdministeredCount,

            CASE
                WHEN (PI.Frequency * PI.Duration) -
                    COUNT(CASE WHEN MA.status = 'Administered' THEN 1 END) < 0
                THEN 0
                ELSE (PI.Frequency * PI.Duration) -
                    COUNT(CASE WHEN MA.status = 'Administered' THEN 1 END)
            END AS RemainingAdministrations,

            STUFF((
                SELECT
                    ', ' + N2.FullName + ' (' +
                    CAST(COUNT(*) AS VARCHAR(10)) + ')'
                FROM MedicationAdministration MA2
                INNER JOIN Nurse N2
                    ON MA2.NurseID = N2.NurseID
                WHERE MA2.PrescriptionItemID = PI.PrescriptionItemID
                GROUP BY N2.NurseID, N2.FullName
                FOR XML PATH(''), TYPE
            ).value('.', 'NVARCHAR(MAX)'), 1, 2, '') AS NurseBreakdown

        FROM PrescriptionItem PI
        INNER JOIN Prescriptions P
            ON PI.PrescriptionID = P.PrescriptionID
        INNER JOIN Patient PA
            ON P.PatientID = PA.PatientID
        INNER JOIN Doctor D
            ON P.DoctorID = D.DoctorID
        INNER JOIN Medicine M
            ON PI.MedicineID = M.MedicineID
        LEFT JOIN MedicationAdministration MA
            ON PI.PrescriptionItemID = MA.PrescriptionItemID

        WHERE
            (@name IS NULL OR @name = ''
                OR PA.FullName LIKE '%' + @name + '%')
            AND
            (@date IS NULL
                OR P.DateIssued >= @date
                AND P.DateIssued < DATEADD(DAY, 1, @date))

        GROUP BY
            PI.PrescriptionItemID,
            P.PrescriptionID,
            PA.PatientID,
            PA.FullName,
            D.FullName,
            P.DateIssued,
            M.MedicineName,
            M.DosageUnit,
            PI.Dosage,
            PI.Frequency,
            PI.Duration

        ORDER BY P.DateIssued DESC">

        <SelectParameters>
            <asp:ControlParameter ControlID="TBPatient"
                Name="name" PropertyName="Text"
                ConvertEmptyStringToNull="true" />

            <asp:ControlParameter ControlID="TBDate"
                Name="date" PropertyName="Text"
                Type="DateTime"
                ConvertEmptyStringToNull="true" />
        </SelectParameters>
    </asp:SqlDataSource>

    <!-- Individual administration records for selected prescription item -->
    <asp:SqlDataSource ID="SqlDSAdministrationHistory" runat="server"
        ConnectionString="<%$ ConnectionStrings:GroupPmb6ConnectionString %>"
        SelectCommand="
        SELECT
            MA.medication_AdministrationID,
            MA.dosageGiven,
            MA.status,
            MA.Admnistered_at,
            MA.Notes,
            N.FullName
        FROM MedicationAdministration MA
        INNER JOIN Nurse N
            ON MA.NurseID = N.NurseID
        WHERE MA.PrescriptionItemID = @itemID
        ORDER BY MA.Admnistered_at DESC">

        <SelectParameters>
            <asp:ControlParameter ControlID="GVMedicationAdmin"
                Name="itemID" PropertyName="SelectedValue"
                Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>

    <!-- Doctor's instructions for selected prescription item -->
    <asp:SqlDataSource ID="SqlDSDocNotes" runat="server"
        ConnectionString="<%$ ConnectionStrings:GroupPmb6ConnectionString %>"
        SelectCommand="
        SELECT
            PI.Instruction,
            P.DateIssued
        FROM PrescriptionItem PI
        INNER JOIN Prescriptions P
            ON PI.PrescriptionID = P.PrescriptionID
        WHERE PI.PrescriptionItemID = @itemID">

        <SelectParameters>
            <asp:ControlParameter ControlID="GVMedicationAdmin"
                Name="itemID" PropertyName="SelectedValue"
                Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>

    <!-- Nurse's notes for selected individual administration -->
    <asp:SqlDataSource ID="SqlDSMedNotes" runat="server"
        ConnectionString="<%$ ConnectionStrings:GroupPmb6ConnectionString %>"
        SelectCommand="
        SELECT Notes
        FROM MedicationAdministration
        WHERE medication_AdministrationID = @adminID">

        <SelectParameters>
            <asp:ControlParameter ControlID="GVAdministrationHistory"
                Name="adminID" PropertyName="SelectedValue"
                Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>

</div>

</asp:Content>
