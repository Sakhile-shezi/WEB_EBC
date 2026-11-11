
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
        max-width: 100%;
        padding: 9px 11px;
        border: 1px solid #ccd8ce;
        border-radius: 6px;
        box-sizing: border-box;
        margin-bottom: 14px;
    }

    .med-input:focus {
        outline: none;
        border-color: #43834c;
        box-shadow: 0 0 0 3px rgba(67,131,76,.12);
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
        background: #24572d;
        color: white;
        padding: 12px 10px;
        text-align: left;
        white-space: nowrap;
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

    .med-status {
        display: block;
        margin-top: 14px;
        color: #246333;
        font-weight: 600;
    }

    .med-help {
        color: #6b786e;
        font-size: 13px;
        margin-top: -10px;
        margin-bottom: 14px;
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

    <!-- Page heading -->
    <div class="med-heading">
        <h2>Medication Administration</h2>
        <p>View prescriptions and record medication administered to patients.</p>
    </div>
    <div class="medicationAdministration-hero" style="background-image:url('<%= ResolveUrl("~/Images/WhatsApp Image 2026-09-02 at 10.38.35.jpeg") %>');">
    <div class="medicationAdministration-hero">
       
       
    </div>
</div>

    <!-- Existing medication administration records -->
    <div class="med-card">
        <h4>Medication Administration History</h4>
        
<!-- RECENT ADMINISTRATIONS -->
<div style="margin-bottom: 30px;">

    <div style="display: flex; justify-content: space-between;
                align-items: center; flex-wrap: wrap; gap: 10px;
                margin-bottom: 8px;">

        <h4 style="margin: 0; padding: 0; border: none;">
            Recent Administrations
        </h4>

        <span style="background: #eaf3eb; color: #24572d;
                     padding: 5px 12px; border-radius: 20px;
                     font-size: 12px; font-weight: 600;">
            Last 7 Days
        </span>

    </div>

    <p class="med-help">
        Your recent medication administration records from the past seven days.
    </p>

    <div class="med-grid-wrap">

        <asp:GridView
            ID="GridView4"
            runat="server"
            AutoGenerateColumns="False"
            DataKeyNames="medication_AdministrationID"
            DataSourceID="SqlDSRecMedAdmin"
            CssClass="med-grid"
            CellPadding="4"
            GridLines="None"
            EmptyDataText="No recent medication administration records found.">

            <Columns>

                <asp:BoundField
                    DataField="Patient"
                    HeaderText="Patient" />

                <asp:BoundField
                    DataField="MedicineName"
                    HeaderText="Medicine" />

                <asp:BoundField
                    DataField="dosageGiven"
                    HeaderText="Dosage Given" />

                <asp:BoundField
                    DataField="Dosage"
                    HeaderText="Prescribed Dosage" />

                <asp:BoundField
                    DataField="status"
                    HeaderText="Status" />

                <asp:BoundField
                    DataField="Admnistered_at"
                    HeaderText="Administration Date"
                    DataFormatString="{0:dd MMM yyyy HH:mm}" />

                <asp:BoundField
                    DataField="Doctor"
                    HeaderText="Prescribed By" />

                <asp:BoundField
                    DataField="Frequency"
                    HeaderText="Frequency" />

                <asp:BoundField
                    DataField="Duration"
                    HeaderText="Duration" />

                <asp:BoundField
                    DataField="DosageUnit"
                    HeaderText="Unit" />

            </Columns>

            <HeaderStyle
                BackColor="#24572d"
                ForeColor="White"
                Font-Bold="True" />

            <RowStyle BackColor="White" />

            <AlternatingRowStyle BackColor="#f3f7f3" />

        </asp:GridView>

    </div>

</div>


        <div class="med-columns">
            <div>
                <label class="med-label" for="<%= TBPatient.ClientID %>">
                    Patient name
                </label>
                <asp:TextBox ID="TBPatient" runat="server"
                    CssClass="med-input"
                    placeholder="Search by patient name"
                    OnTextChanged="TBPatient_TextChanged" />
            </div>

            <div>
                <label class="med-label" for="<%= TBDate.ClientID %>">
                    Administration date
                </label>
                <asp:TextBox ID="TBDate" runat="server"
                    CssClass="med-input"
                    TextMode="Date"
                    OnTextChanged="TBPatient_TextChanged" />
            </div>
        </div>

        <asp:Button ID="BtnSearch" runat="server"
            Text="Search records"
            CssClass="med-button" />

        <div class="med-grid-wrap">
            <asp:GridView ID="GVMedicationAdmin" runat="server"
                AutoGenerateColumns="False"
                DataKeyNames="medication_AdministrationID"
                DataSourceID="SqlDSMedAdmin"
                CssClass="med-grid"
                CellPadding="4"
                GridLines="None"
                EmptyDataText="No medication administration records found.">

                <Columns>
                    <asp:CommandField ShowSelectButton="True" SelectText="View" />
                    <asp:BoundField DataField="FullName" HeaderText="Nurse" />
                    <asp:BoundField DataField="Patient" HeaderText="Patient" />
                    <asp:BoundField DataField="MedicineName" HeaderText="Medicine" />
                    <asp:BoundField DataField="dosageGiven" HeaderText="Dosage given" />
                    <asp:BoundField DataField="status" HeaderText="Status" />
                    <asp:BoundField DataField="Admnistered_at" HeaderText="Administration date" />
                    <asp:BoundField DataField="Dosage" HeaderText="Prescribed dosage" />
                    <asp:BoundField DataField="Frequency" HeaderText="Frequency" />
                    <asp:BoundField DataField="Doctor" HeaderText="Prescribed by" />
                    <asp:BoundField DataField="DateIssued" HeaderText="Prescription date" />
                    <asp:BoundField DataField="Duration" HeaderText="Duration" />
                    <asp:BoundField DataField="DosageUnit" HeaderText="Unit" />
                </Columns>
            </asp:GridView>
        </div>
    </div>

    <!-- Selected administration details -->
    <div class="med-columns">

        <div class="med-card">
            <h4>Doctor's Instructions</h4>
            <p class="med-help">
                Instructions and prescription information for the selected record.
            </p>

            <asp:DetailsView ID="DetailsView1" runat="server"
                AutoGenerateRows="False"
                DataSourceID="SqlDSDocNotes"
                CssClass="med-grid"
                GridLines="None">
                <Fields>
                    <asp:BoundField DataField="Instruction" HeaderText="Instructions" />
                    <asp:BoundField DataField="DateIssued" HeaderText="Date prescribed" />
                </Fields>
            </asp:DetailsView>
        </div>

        <div class="med-card">
            <h4>Nurse's Administration Notes</h4>
            <p class="med-help">
                Notes entered when the selected medicine was administered.
            </p>

            <asp:DetailsView ID="DetailsView2" runat="server"
                AutoGenerateRows="False"
                DataSourceID="SqlDSMedNotes"
                CssClass="med-grid"
                GridLines="None">
                <Fields>
                    <asp:BoundField DataField="Notes" HeaderText="Nurse's notes" />
                </Fields>
            </asp:DetailsView>
        </div>

    </div>

    <!-- Record a new administration -->
    <div class="med-card">
        <h4>Record Medication Administration</h4>

        <p class="med-help">
            Find the patient's prescription, select the prescribed medicine,
            and record the administration.
        </p>

        <div class="med-columns">
            <div>
                <label class="med-label" for="<%= TBPatient2.ClientID %>">
                    Patient name
                </label>
                <asp:TextBox ID="TBPatient2" runat="server"
                    CssClass="med-input"
                    placeholder="Enter patient name" />

                <label class="med-label" for="<%= TBDate2.ClientID %>">
                    Prescription date
                </label>
                <asp:TextBox ID="TBDate2" runat="server"
                    CssClass="med-input"
                    TextMode="Date" />

                <asp:Button ID="BtnSearch2" runat="server"
                    Text="Find prescriptions"
                    CssClass="med-button" />
            </div>

            <div>
                <label class="med-label">Logged-in nurse</label>

                <asp:DetailsView ID="DVNurse" runat="server"
                    AutoGenerateRows="False"
                    DataKeyNames="NurseID"
                    DataSourceID="SqlDSGetNurseID"
                    CssClass="med-grid"
                    GridLines="None">
                    <Fields>
                        <asp:BoundField DataField="FullName" HeaderText="Nurse name" />
                    </Fields>
                </asp:DetailsView>
            </div>
        </div>

        <h4>Available Prescriptions</h4>

        <div class="med-grid-wrap">
            <asp:GridView ID="GridView1" runat="server"
                AutoGenerateColumns="False"
                CellPadding="4"
                DataKeyNames="PrescriptionID"
                DataSourceID="SqlDSPrescription"
                CssClass="med-grid"
                GridLines="None"
                EmptyDataText="No prescriptions found.">

                <Columns>
                    <asp:CommandField ShowSelectButton="True" SelectText="Select" />
                    <asp:BoundField DataField="PrescriptionID" HeaderText="Prescription ID" />
                    <asp:BoundField DataField="Doctor" HeaderText="Doctor" />
                    <asp:BoundField DataField="Patient" HeaderText="Patient" />
                    <asp:BoundField DataField="DateIssued" HeaderText="Date issued" />
                </Columns>
            </asp:GridView>
        </div>

        <h4 style="margin-top: 28px;">Prescribed Medicines</h4>

        <div class="med-grid-wrap">
            <asp:GridView ID="GridView2" runat="server"
                AutoGenerateColumns="False"
                CellPadding="4"
                DataKeyNames="PrescriptionItemID"
                DataSourceID="SqlDSPrescriptionItems"
                CssClass="med-grid"
                GridLines="None"
                EmptyDataText="Select a prescription to view its medicines.">

                <Columns>
                    <asp:CommandField ShowSelectButton="True" SelectText="Select medicine" />
                    <asp:BoundField DataField="MedicineName" HeaderText="Medicine" />
                    <asp:BoundField DataField="Dosage" HeaderText="Prescribed dosage" />
                    <asp:BoundField DataField="Frequency" HeaderText="Frequency" />
                    <asp:BoundField DataField="Duration" HeaderText="Duration (days)" />
                    <asp:BoundField DataField="Instruction" HeaderText="Instructions" />
                </Columns>
            </asp:GridView>
        </div>

        <h4 style="margin-top: 28px;">Administration Details</h4>

        <div class="med-columns">
            <div>
                <label class="med-label" for="<%= DDLStatus.ClientID %>">
                    Administration status
                </label>
                <asp:DropDownList ID="DDLStatus" runat="server"
                    CssClass="med-input">
                    <asp:ListItem>Administered</asp:ListItem>
                    <asp:ListItem>Partially Administered</asp:ListItem>
                    <asp:ListItem>Not Administered</asp:ListItem>
                </asp:DropDownList>

                <label class="med-label" for="<%= TBDosageGiven.ClientID %>">
                    Dosage given
                </label>
                <asp:TextBox ID="TBDosageGiven" runat="server"
                    CssClass="med-input"
                    TextMode="Number" />
            </div>

            <div>
                <label class="med-label" for="<%= TBNurseNotes.ClientID %>">
                    Administration notes
                </label>
                <asp:TextBox ID="TBNurseNotes" runat="server"
                    CssClass="med-input"
                    TextMode="MultiLine"
                    Rows="5"
                    placeholder="Enter relevant observations or reasons for partial/non-administration..." />
            </div>
        </div>

        <asp:Button ID="BtnMedAdminRecord" runat="server"
            OnClick="BtnMedAdminRecord_Click"
            Text="Record Administration"
            CssClass="med-button" />

        <asp:Label ID="lblStatus" runat="server"
            CssClass="med-status" />

    </div>

<!-- 1. Medication administration history -->
<asp:SqlDataSource ID="SqlDSMedAdmin" runat="server"
    ConnectionString="<%$ ConnectionStrings:GroupPmb6ConnectionString %>"
    SelectCommand="SELECT MedicationAdministration.medication_AdministrationID, MedicationAdministration.NurseID, MedicationAdministration.PrescriptionItemID, MedicationAdministration.Admnistered_at, MedicationAdministration.Notes, MedicationAdministration.dosageGiven, MedicationAdministration.status, Nurse.UserId, PrescriptionItem.MedicineID, PrescriptionItem.Dosage, PrescriptionItem.Frequency, Doctor.FullName AS Doctor, Patient.FullName AS Patient, Prescriptions.DoctorID, Prescriptions.PatientID, PrescriptionItem.Instruction, PrescriptionItem.Duration, Medicine.MedicineName, Medicine.DosageUnit, Prescriptions.DateIssued, Nurse.FullName FROM MedicationAdministration INNER JOIN Nurse ON MedicationAdministration.NurseID = Nurse.NurseID INNER JOIN PrescriptionItem ON MedicationAdministration.PrescriptionItemID = PrescriptionItem.PrescriptionItemID INNER JOIN Prescriptions ON PrescriptionItem.PrescriptionID = Prescriptions.PrescriptionID INNER JOIN Doctor ON Prescriptions.DoctorID = Doctor.DoctorID INNER JOIN Patient ON Prescriptions.PatientID = Patient.PatientID INNER JOIN Medicine ON PrescriptionItem.MedicineID = Medicine.MedicineID WHERE (@name IS NULL) OR (@name = '') OR (Patient.FullName LIKE '%' + @name + '%')">
    <SelectParameters>
        <asp:ControlParameter ControlID="TBPatient" Name="name" PropertyName="Text" />
    </SelectParameters>
</asp:SqlDataSource>


<!-- 2. Nurse notes for the selected administration record -->
<asp:SqlDataSource ID="SqlDSMedNotes" runat="server"
    ConnectionString="<%$ ConnectionStrings:GroupPmb6ConnectionString %>"
    SelectCommand="SELECT Notes FROM MedicationAdministration WHERE medication_AdministrationID = @id">
    <SelectParameters>
        <asp:ControlParameter ControlID="GVMedicationAdmin" Name="id" PropertyName="SelectedValue" />
    </SelectParameters>
</asp:SqlDataSource>


<!-- 3. Doctor's prescription instructions -->
<asp:SqlDataSource ID="SqlDSDocNotes" runat="server"
    ConnectionString="<%$ ConnectionStrings:GroupPmb6ConnectionString %>"
    SelectCommand="SELECT PrescriptionItem.Instruction, Prescriptions.DateIssued FROM MedicationAdministration INNER JOIN PrescriptionItem ON MedicationAdministration.PrescriptionItemID = PrescriptionItem.PrescriptionItemID INNER JOIN Prescriptions ON PrescriptionItem.PrescriptionID = Prescriptions.PrescriptionID WHERE MedicationAdministration.medication_AdministrationID = @id">
    <SelectParameters>
        <asp:ControlParameter ControlID="GVMedicationAdmin" Name="id" PropertyName="SelectedValue" />
    </SelectParameters>
</asp:SqlDataSource>


<!-- 4. Prescriptions available for administration -->
<asp:SqlDataSource ID="SqlDSPrescription" runat="server"
    ConnectionString="<%$ ConnectionStrings:GroupPmb6ConnectionString %>"
    SelectCommand="SELECT Prescriptions.PrescriptionID, Prescriptions.DoctorID, Doctor.FullName AS Doctor, Prescriptions.PatientID, Patient.FullName AS Patient, Prescriptions.DateIssued FROM Prescriptions INNER JOIN Doctor ON Prescriptions.DoctorID = Doctor.DoctorID INNER JOIN Patient ON Prescriptions.PatientID = Patient.PatientID WHERE (@name IS NULL OR @name = '') AND (Prescriptions.DateIssued >= @date) AND (Prescriptions.DateIssued < DATEADD(DAY, 1, @date)) OR (Prescriptions.DateIssued >= @date) AND (Prescriptions.DateIssued < DATEADD(DAY, 1, @date)) AND (Patient.FullName LIKE '%' + @name + '%')">

    <SelectParameters>
        <asp:ControlParameter ControlID="TBPatient2" Name="name" PropertyName="Text" Type="String" />
        <asp:ControlParameter ControlID="TBDate2" Name="date" PropertyName="Text" Type="DateTime" />
    </SelectParameters>
</asp:SqlDataSource>


<!-- 5. Medicines belonging to the selected prescription -->
<asp:SqlDataSource ID="SqlDSPrescriptionItems" runat="server"
    ConnectionString="<%$ ConnectionStrings:GroupPmb6ConnectionString %>"
    SelectCommand="SELECT PrescriptionItem.PrescriptionItemID, PrescriptionItem.PrescriptionID, PrescriptionItem.MedicineID, PrescriptionItem.Dosage, PrescriptionItem.Frequency, PrescriptionItem.Duration, PrescriptionItem.Instruction, Medicine.MedicineName FROM PrescriptionItem INNER JOIN Medicine ON PrescriptionItem.MedicineID = Medicine.MedicineID WHERE PrescriptionItem.PrescriptionID = @id">

    <SelectParameters>
        <asp:ControlParameter ControlID="GridView1" Name="id" PropertyName="SelectedValue" Type="Int32" DefaultValue="0" />
    </SelectParameters>
</asp:SqlDataSource>


<!-- 6. Retrieve the nurse -->
<asp:SqlDataSource ID="SqlDSGetNurseID" runat="server"
    ConnectionString="<%$ ConnectionStrings:GroupPmb6ConnectionString %>"
    SelectCommand="SELECT * FROM Nurse">
</asp:SqlDataSource>


<!-- 7. Insert a medication administration record -->
<asp:SqlDataSource ID="SqlDSRecordMedAdmin" runat="server"
    ConnectionString="<%$ ConnectionStrings:GroupPmb6ConnectionString %>"
    InsertCommand="INSERT INTO MedicationAdministration (NurseID, PrescriptionItemID, Admnistered_at, Notes, dosageGiven, status) VALUES (@NurseID, @PrescriptionItemID, @Admnistered_at, @Notes, @dosageGiven, @status)">

    <InsertParameters>
        <asp:ControlParameter ControlID="DVNurse" Name="NurseID" PropertyName="SelectedValue" Type="Int32" />
        <asp:ControlParameter ControlID="GridView2" Name="PrescriptionItemID" PropertyName="SelectedValue" Type="Int32" />
        <asp:Parameter Name="Admnistered_at" Type="DateTime" />
        <asp:ControlParameter ControlID="TBNurseNotes" Name="Notes" PropertyName="Text" Type="String" />
        <asp:ControlParameter ControlID="TBDosageGiven" Name="dosageGiven" PropertyName="Text" Type="Int32" />
        <asp:ControlParameter ControlID="DDLStatus" Name="status" PropertyName="SelectedValue" Type="String" />
    </InsertParameters>
</asp:SqlDataSource>


    <div>
        Recent Administrations<br />
        <asp:GridView ID="GridView3" runat="server" AutoGenerateColumns="False" DataKeyNames="medication_AdministrationID" DataSourceID="SqlDSRecMedAdmin" EmptyDataText="No recent administrations">
            <Columns>
                <asp:BoundField DataField="Patient" HeaderText="Patient" SortExpression="Patient" />
                <asp:BoundField DataField="MedicineName" HeaderText="MedicineName" SortExpression="MedicineName" />
                <asp:BoundField DataField="dosageGiven" HeaderText="dosageGiven" SortExpression="dosageGiven" />
                <asp:BoundField DataField="Dosage" HeaderText="Dosage" SortExpression="Dosage" />
                <asp:BoundField DataField="status" HeaderText="status" SortExpression="status" />
                <asp:BoundField DataField="Admnistered_at" HeaderText="Admnistered_at" SortExpression="Admnistered_at" />
                <asp:BoundField DataField="Doctor" HeaderText="Doctor" SortExpression="Doctor" />
                <asp:BoundField DataField="Frequency" HeaderText="Frequency" SortExpression="Frequency" />
                <asp:BoundField DataField="Duration" HeaderText="Duration" SortExpression="Duration" />
                <asp:BoundField DataField="DateIssued" HeaderText="DateIssued" SortExpression="DateIssued" />
                <asp:BoundField DataField="DosageUnit" HeaderText="DosageUnit" SortExpression="DosageUnit" />
            </Columns>
        </asp:GridView>
<asp:SqlDataSource ID="SqlDSRecMedAdmin" runat="server"
    ConnectionString="<%$ ConnectionStrings:GroupPmb6ConnectionString %>"
    SelectCommand="SELECT MedicationAdministration.medication_AdministrationID, MedicationAdministration.NurseID, MedicationAdministration.PrescriptionItemID, MedicationAdministration.Admnistered_at, MedicationAdministration.Notes, MedicationAdministration.dosageGiven, MedicationAdministration.status, Nurse.UserId, PrescriptionItem.MedicineID, PrescriptionItem.Dosage, PrescriptionItem.Frequency, Doctor.FullName AS Doctor, Patient.FullName AS Patient, Prescriptions.DoctorID, Prescriptions.PatientID, PrescriptionItem.Instruction, PrescriptionItem.Duration, Medicine.MedicineName, Medicine.DosageUnit, Prescriptions.DateIssued, Nurse.FullName FROM MedicationAdministration INNER JOIN Nurse ON MedicationAdministration.NurseID = Nurse.NurseID INNER JOIN PrescriptionItem ON MedicationAdministration.PrescriptionItemID = PrescriptionItem.PrescriptionItemID INNER JOIN Prescriptions ON PrescriptionItem.PrescriptionID = Prescriptions.PrescriptionID INNER JOIN Doctor ON Prescriptions.DoctorID = Doctor.DoctorID INNER JOIN Patient ON Prescriptions.PatientID = Patient.PatientID INNER JOIN Medicine ON PrescriptionItem.MedicineID = Medicine.MedicineID WHERE (Nurse.UserId = @id) AND (MedicationAdministration.Admnistered_at &gt;= DATEADD(DAY, - 7, GETDATE())) AND (MedicationAdministration.Admnistered_at &lt;= GETDATE()) ORDER BY MedicationAdministration.Admnistered_at DESC">
    <SelectParameters>
        <asp:Parameter Name="id" />
    </SelectParameters>
</asp:SqlDataSource>


        <asp:Label ID="lblID" runat="server" Text="Label"></asp:Label>


    </div>


</div>

</asp:Content>
