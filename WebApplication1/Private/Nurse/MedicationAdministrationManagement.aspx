
<%@ Page Title="Medication Administration Management" Language="C#" MasterPageFile="~/Site.Master"
    AutoEventWireup="true" CodeBehind="MedicationAdministrationManagement.aspx.cs"
    Inherits="WebApplication1.Private.Nurse.MedicationAdministrationManagement" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

<style>
    .med-page { max-width:1400px; margin:25px auto; padding:0 18px 35px; color:#26352e; }
    .med-heading { background:#234d2b; color:white; padding:25px 30px; border-radius:10px; margin-bottom:22px; }
    .med-heading h2 { margin:0 0 6px; font-weight:600; }
    .med-heading p { margin:0; color:#dce9dc; }
    .med-card { background:white; border:1px solid #e1e8e2; border-radius:10px; padding:22px; margin-bottom:22px; box-shadow:0 3px 12px rgba(0,0,0,.045); }
    .med-card h4 { color:#234d2b; font-size:18px; font-weight:600; margin:0 0 18px; padding-bottom:12px; border-bottom:2px solid #e5eee5; }
    .med-label { display:block; font-weight:600; margin-bottom:6px; color:#34483a; }
    .med-input { width:100%; padding:10px 11px; border:1px solid #ccd8ce; border-radius:6px; box-sizing:border-box; }
    .med-input:focus { outline:none; border-color:#43834c; box-shadow:0 0 0 3px rgba(67,131,76,.12); }
    .med-button { background:#24572d; color:white; border:none; border-radius:6px; padding:11px 19px; cursor:pointer; font-weight:600; }
    .med-button:hover { background:#367641; color:white; }
    .med-secondary { background:#edf3ee; color:#234d2b; border:1px solid #cbdccc; border-radius:6px; padding:11px 19px; cursor:pointer; font-weight:600; }
    .med-danger { background:#a52b25; color:white; border:none; border-radius:5px; padding:7px 12px; cursor:pointer; }
    .med-help { color:#6b786e; font-size:13px; margin-top:7px; }
    .med-grid-wrap { width:100%; overflow-x:auto; }
    .med-grid { width:100%; border-collapse:collapse; margin-top:12px; font-size:14px; }
    .med-grid th, .med-grid th a { background:#24572d !important; color:white !important; padding:12px; text-align:left; white-space:nowrap; font-weight:700; text-decoration:none; }
    .med-grid td { padding:12px; border-bottom:1px solid #e5eae6; vertical-align:middle; }
    .med-grid tr:nth-child(even) td { background:#f3f7f3; }
    .med-grid tr:hover td { background:#e8f1e8; }
    .med-grid a { color:#246333; font-weight:600; text-decoration:none; }
    .med-grid-pager { background:#f3f7f3; padding:14px; text-align:center; }
    .med-grid-pager a { display:inline-block; padding:8px 14px; background:#24572d; color:white !important; border-radius:5px; }
    .med-message { display:block; padding:13px 16px; border-radius:5px; margin-bottom:18px; border-left:4px solid; }
    .med-success { color:#24572d; background:#f3f7f3; border-left-color:#43834c; }
    .med-error { color:#a52b25; background:#fff1f0; border-left-color:#c84b43; }
    .med-selected-info { background:#f3f7f3; border-left:4px solid #43834c; border-radius:4px; padding:13px 15px; margin-bottom:18px; }
    .med-action-edit { color:#246333 !important; margin-right:12px; }
    @media(max-width:768px) {
        .med-heading { padding:20px; }
        .med-card { padding:16px; }
    }
</style>

<div class="med-page">

    <div class="med-heading">
        <h2>Medication Administration Management</h2>
        <p>Record and manage the administration of prescribed medication.</p>
    </div>

    <asp:Panel ID="pnlSuccess" runat="server" Visible="false"
        CssClass="med-message med-success">
        <asp:Label ID="lblSuccess" runat="server" />
    </asp:Panel>

    <asp:Panel ID="pnlError" runat="server" Visible="false"
        CssClass="med-message med-error">
        <asp:Label ID="lblError" runat="server" />
    </asp:Panel>

    <!-- SEARCH PRESCRIBED MEDICATION -->
    <div class="med-card">
        <h4>1. Find Prescribed Medication</h4>

        <div class="row g-3 align-items-end">
            <div class="col-md-7">
                <asp:Label ID="lblPatientSearch" runat="server"
                    AssociatedControlID="TBPatient" CssClass="med-label">
                    Patient Name
                </asp:Label>

                <asp:TextBox ID="TBPatient" runat="server"
                    CssClass="med-input"
                    placeholder="Search by patient name..." />
            </div>

            <div class="col-md-3">
                <asp:Label ID="lblDateSearch" runat="server"
                    AssociatedControlID="TBDate" CssClass="med-label">
                    Prescription Date
                </asp:Label>

                <asp:TextBox ID="TBDate" runat="server"
                    TextMode="Date" CssClass="med-input" />
            </div>

            <div class="col-md-2">
                <asp:Button ID="BtnSearch" runat="server"
                    Text="Search" CssClass="med-button w-100"
                    CausesValidation="false"
                    OnClick="BtnSearch_Click" />
            </div>
        </div>

        <p class="med-help">
            Both filters are optional. Select a prescribed medicine to record its administration.
        </p>

        <div class="med-grid-wrap">
            <asp:GridView ID="GVMedicationAdmin" runat="server"
                AutoGenerateColumns="False"
                DataKeyNames="PrescriptionItemID,Patient,Doctor,MedicineName,Dosage,Frequency,Duration,Instruction,DateIssued"
                CssClass="med-grid" GridLines="None"
                AllowPaging="True" PageSize="5"
                PagerSettings-Mode="NextPrevious"
                PagerSettings-NextPageText="Next →"
                PagerSettings-PreviousPageText="← Previous"
                PagerStyle-CssClass="med-grid-pager"
                EmptyDataText="No prescribed medications found."
                OnPageIndexChanging="GVMedicationAdmin_PageIndexChanging"
                OnSelectedIndexChanged="GVMedicationAdmin_SelectedIndexChanged">

                <Columns>
                    <asp:CommandField ShowSelectButton="True" SelectText="Select" />
                    <asp:BoundField DataField="Patient" HeaderText="Patient" />
                    <asp:BoundField DataField="Doctor" HeaderText="Prescribing Doctor" />
                    <asp:BoundField DataField="MedicineName" HeaderText="Medicine" />
                    <asp:BoundField DataField="Dosage" HeaderText="Prescribed Dosage" />
                    <asp:BoundField DataField="Frequency" HeaderText="Frequency" />
                    <asp:BoundField DataField="Duration" HeaderText="Duration (days)" />
                    <asp:BoundField DataField="DateIssued" HeaderText="Date Issued"
                        DataFormatString="{0:dd MMM yyyy}" />
                </Columns>

                <SelectedRowStyle BackColor="#c8e6c9" Font-Bold="True" />
            </asp:GridView>
        </div>
    </div>

    <!-- ADD / EDIT FORM -->
    <asp:Panel ID="pnlAdministration" runat="server" Visible="false">
        <div class="med-card">

            <h4>
                <asp:Label ID="lblFormHeading" runat="server"
                    Text="2. Record Medication Administration" />
            </h4>

            <asp:HiddenField ID="hfPrescriptionItemID" runat="server" />
            <asp:HiddenField ID="hfAdministrationID" runat="server" />

            <div class="med-selected-info">
                <asp:Label ID="lblSelectedMedication" runat="server"
                    CssClass="fw-bold" />
            </div>

            <div class="row">

                <div class="col-md-6 mb-3">
                    <label class="med-label" for="<%= txtDosageGiven.ClientID %>">
                        Dosage Given (numeric)
                    </label>

                    <asp:TextBox ID="txtDosageGiven" runat="server"
                        CssClass="med-input" TextMode="Number"
                        placeholder="e.g. 2" />
                    <p class="med-help">
                        Enter the numeric amount administered, using the prescribed medicine's unit.
                    </p>
                </div>

                <div class="col-md-6 mb-3">
                    <label class="med-label" for="<%= txtFrequencyInstance.ClientID %>">
                        Frequency Instance
                    </label>

                    <asp:TextBox ID="txtFrequencyInstance" runat="server"
                        CssClass="med-input" TextMode="Number"
                        placeholder="e.g. 1" />
                    <p class="med-help">
                        Enter the administration instance number.
                    </p>
                </div>

                <div class="col-md-6 mb-3">
                    <label class="med-label" for="<%= ddlStatus.ClientID %>">
                        Administration Status
                    </label>

                    <asp:DropDownList ID="ddlStatus" runat="server"
                        CssClass="med-input">
                        <asp:ListItem Text="-- Select Status --" Value="" />
                        <asp:ListItem Text="Administered" Value="Administered" />
                        <asp:ListItem Text="Partially Administered" Value="Partially Administered" />
                        <asp:ListItem Text="Not Administered" Value="Not Administered" />
                    </asp:DropDownList>
                </div>

                <div class="col-12 mb-3">
                    <label class="med-label" for="<%= txtNotes.ClientID %>">
                        Nursing Notes
                    </label>

                    <asp:TextBox ID="txtNotes" runat="server"
                        CssClass="med-input" TextMode="MultiLine"
                        Rows="3" MaxLength="50"
                        placeholder="Enter notes (maximum 50 characters)..." />
                </div>

            </div>

            <asp:Button ID="btnSaveAdministration" runat="server"
                Text="Save Administration Record"
                CssClass="med-button"
                OnClick="btnSaveAdministration_Click" />

            <asp:Button ID="btnCancel" runat="server"
                Text="Cancel" CssClass="med-secondary ms-2"
                CausesValidation="false"
                OnClick="btnCancel_Click" />

        </div>
    </asp:Panel>

    <!-- EXISTING ADMINISTRATION RECORDS -->
    <div class="med-card">
        <h4>2. Existing Medication Administration Records</h4>

        <p class="med-help">
            Review records and use Edit or Delete to manage an administration entry.
        </p>

        <div class="med-grid-wrap">
            <asp:GridView ID="gvAdministrationRecords" runat="server"
                AutoGenerateColumns="False"
                DataKeyNames="AdministrationID"
                CssClass="med-grid" GridLines="None"
                AllowPaging="True" PageSize="8"
                PagerSettings-Mode="NextPrevious"
                PagerSettings-NextPageText="Next →"
                PagerSettings-PreviousPageText="← Previous"
                PagerStyle-CssClass="med-grid-pager"
                EmptyDataText="No medication administration records found."
                OnPageIndexChanging="gvAdministrationRecords_PageIndexChanging"
                OnRowCommand="gvAdministrationRecords_RowCommand">

                <Columns>
                    <asp:BoundField DataField="AdministrationID" HeaderText="Record ID" />
                    <asp:BoundField DataField="Patient" HeaderText="Patient" />
                    <asp:BoundField DataField="Doctor" HeaderText="Prescribing Doctor" />
                    <asp:BoundField DataField="Nurse" HeaderText="Administering Nurse" />
                    <asp:BoundField DataField="MedicineName" HeaderText="Medicine" />
                    <asp:BoundField DataField="dosageGiven" HeaderText="Dosage Given" />
                    <asp:BoundField DataField="frequency_Instance" HeaderText="Frequency Instance" />
                    <asp:BoundField DataField="status" HeaderText="Status" />
                    <asp:BoundField DataField="Admnistered_at" HeaderText="Administered At"
                        DataFormatString="{0:dd MMM yyyy, HH:mm}" />

                    <asp:TemplateField HeaderText="Actions">
                        <ItemTemplate>
                            <asp:LinkButton ID="btnEdit" runat="server"
                                Text="Edit"
                                CommandName="EditRecord"
                                CommandArgument='<%# Eval("AdministrationID") %>'
                                CssClass="med-action-edit"
                                CausesValidation="false" />

                            <asp:LinkButton ID="btnDelete" runat="server"
                                Text="Delete"
                                CommandName="DeleteRecord"
                                CommandArgument='<%# Eval("AdministrationID") %>'
                                CssClass="text-danger fw-bold"
                                CausesValidation="false"
                                OnClientClick="return confirm('Are you sure you want to delete this medication administration record?');" />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
    </div>

</div>

</asp:Content>

