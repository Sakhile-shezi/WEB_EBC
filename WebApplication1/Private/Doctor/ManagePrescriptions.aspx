
<%@ Page Title="Manage Prescriptions" Language="C#" MasterPageFile="~/Site.Master"
    AutoEventWireup="true" CodeBehind="ManagePrescriptions.aspx.cs"
    Inherits="WebApplication1.Private.Doctor.ManagePrescriptions" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

<style>
    .pm-page { max-width:1400px; margin:25px auto; padding:0 18px 35px; color:#26352e; }
    .pm-heading { background:#234d2b; color:white; padding:25px 30px; border-radius:10px; margin-bottom:22px; }
    .pm-heading h2 { margin:0 0 6px; font-weight:600; }
    .pm-heading p { margin:0; color:#dce9dc; }
    .pm-card { background:white; border:1px solid #e1e8e2; border-radius:10px; padding:22px; margin-bottom:22px; box-shadow:0 3px 12px rgba(0,0,0,.045); }
    .pm-card h4 { color:#234d2b; font-size:18px; font-weight:600; margin:0 0 18px; padding-bottom:12px; border-bottom:2px solid #e5eee5; }
    .pm-label { display:block; font-weight:600; margin-bottom:6px; color:#34483a; }
    .pm-input { width:100%; padding:10px 11px; border:1px solid #ccd8ce; border-radius:6px; box-sizing:border-box; }
    .pm-input:focus { outline:none; border-color:#43834c; box-shadow:0 0 0 3px rgba(67,131,76,.12); }
    .pm-button { background:#24572d; color:white; border:none; border-radius:6px; padding:10px 17px; cursor:pointer; font-weight:600; }
    .pm-button:hover { background:#367641; color:white; }
    .pm-secondary { background:#edf3ee; color:#234d2b; border:1px solid #cbdccc; border-radius:6px; padding:10px 17px; cursor:pointer; font-weight:600; }
    .pm-danger { background:#a52b25; color:white; border:none; border-radius:5px; padding:7px 11px; cursor:pointer; }
    .pm-help { color:#6b786e; font-size:13px; margin-top:7px; }
    .pm-grid-wrap { width:100%; overflow-x:auto; }
    .pm-grid { width:100%; border-collapse:collapse; margin-top:12px; font-size:14px; }
    .pm-grid th { background:#24572d !important; color:white !important; padding:12px; text-align:left; white-space:nowrap; font-weight:700; }
    .pm-grid td { padding:11px; border-bottom:1px solid #e5eae6; vertical-align:middle; }
    .pm-grid tr:nth-child(even) td { background:#f3f7f3; }
    .pm-grid tr:hover td { background:#e8f1e8; }
    .pm-grid a { color:#246333; font-weight:600; text-decoration:none; margin-right:9px; }
    .pm-pager { background:#f3f7f3; padding:13px; text-align:center; }
    .pm-pager a { display:inline-block; padding:7px 13px; background:#24572d; color:white !important; border-radius:5px; }
    .pm-pager span { display:inline-block; padding:7px 13px; background:#dce9dc; color:#234d2b; border-radius:5px; }
    .pm-message { display:block; padding:13px 16px; border-radius:5px; margin-bottom:18px; border-left:4px solid; }
    .pm-success { color:#24572d; background:#f3f7f3; border-left-color:#43834c; }
    .pm-error { color:#a52b25; background:#fff1f0; border-left-color:#c84b43; }
    .pm-info { background:#f3f7f3; border-left:4px solid #43834c; padding:13px 15px; border-radius:4px; margin-bottom:16px; }
    @media(max-width:768px) { .pm-heading { padding:20px; } .pm-card { padding:16px; } }
</style>

<div class="pm-page">

    <div class="pm-heading">
        <h2>Manage Prescriptions</h2>
        <p>Review prescriptions and manage their prescribed medicines.</p>
    </div>

    <asp:Panel ID="pnlSuccess" runat="server" Visible="false"
        CssClass="pm-message pm-success">
        <asp:Label ID="lblSuccess" runat="server" />
    </asp:Panel>

    <asp:Panel ID="pnlError" runat="server" Visible="false"
        CssClass="pm-message pm-error">
        <asp:Label ID="lblError" runat="server" />
    </asp:Panel>

    <!-- PRESCRIPTION SEARCH -->
    <div class="pm-card">
        <h4>1. Find a Prescription</h4>

        <div class="row g-3 align-items-end">
            <div class="col-md-7">
                <asp:Label ID="lblSearchPatient" runat="server"
                    AssociatedControlID="txtSearchPatient" CssClass="pm-label">
                    Patient Name
                </asp:Label>
                <asp:TextBox ID="txtSearchPatient" runat="server"
                    CssClass="pm-input" placeholder="Search by patient name..." />
            </div>

            <div class="col-md-3">
                <asp:Label ID="lblSearchDate" runat="server"
                    AssociatedControlID="txtSearchDate" CssClass="pm-label">
                    Prescription Date
                </asp:Label>
                <asp:TextBox ID="txtSearchDate" runat="server"
                    TextMode="Date" CssClass="pm-input" />
            </div>

            <div class="col-md-2">
                <asp:Button ID="btnSearch" runat="server" Text="Search"
                    CssClass="pm-button w-100" CausesValidation="false"
                    OnClick="btnSearch_Click" />
            </div>
        </div>

        <p class="pm-help">Only prescriptions issued by your doctor account are displayed.</p>

        <div class="pm-grid-wrap">
            <asp:GridView ID="gvPrescriptions" runat="server"
                AutoGenerateColumns="False"
                DataKeyNames="PrescriptionID"
                CssClass="pm-grid" GridLines="None"
                AllowPaging="True" PageSize="5"
                PagerSettings-Mode="NextPrevious"
                PagerSettings-NextPageText="Next →"
                PagerSettings-PreviousPageText="← Previous"
                PagerStyle-CssClass="pm-pager"
                EmptyDataText="No prescriptions found."
                OnPageIndexChanging="gvPrescriptions_PageIndexChanging"
                OnSelectedIndexChanged="gvPrescriptions_SelectedIndexChanged">

                <Columns>
                    <asp:CommandField ShowSelectButton="True" SelectText="View Medicines" />
                    <asp:BoundField DataField="PrescriptionID" HeaderText="Prescription No." />
                    <asp:BoundField DataField="Patient" HeaderText="Patient" />
                    <asp:BoundField DataField="DateIssued" HeaderText="Date Issued"
                        DataFormatString="{0:dd MMM yyyy}" />
                    <asp:BoundField DataField="MedicineCount" HeaderText="Medicines" />
                </Columns>
            </asp:GridView>
        </div>
    </div>

    <!-- SELECTED PRESCRIPTION ITEMS -->
    <asp:Panel ID="pnlPrescriptionDetails" runat="server" Visible="false">

        <div class="pm-card">
            <h4>2. Prescription Details</h4>

            <div class="pm-info">
                <asp:Label ID="lblPrescriptionInfo" runat="server"
                    CssClass="fw-bold" />
            </div>

            <div class="mb-3">
                <asp:Button ID="btnDeletePrescription" runat="server"
                    Text="Delete Entire Prescription"
                    CssClass="pm-danger"
                    CausesValidation="false"
                    OnClick="btnDeletePrescription_Click"
                    OnClientClick="return confirm('Delete this entire prescription and all its medicine items? This cannot be undone.');" />
            </div>

            <div class="pm-grid-wrap">
                <asp:GridView ID="gvPrescriptionItems" runat="server"
                    AutoGenerateColumns="False"
                    DataKeyNames="PrescriptionItemID"
                    CssClass="pm-grid" GridLines="None"
                    EmptyDataText="This prescription has no medicine items."
                    OnRowCommand="gvPrescriptionItems_RowCommand">

                    <Columns>
                        <asp:BoundField DataField="PrescriptionItemID" HeaderText="Item ID" />
                        <asp:BoundField DataField="MedicineName" HeaderText="Medicine" />
                        <asp:BoundField DataField="Dosage" HeaderText="Dosage" />
                        <asp:BoundField DataField="Frequency" HeaderText="Frequency" />
                        <asp:BoundField DataField="Duration" HeaderText="Duration (days)" />
                        <asp:BoundField DataField="Instruction" HeaderText="Instructions" />

                        <asp:TemplateField HeaderText="Actions">
                            <ItemTemplate>
                                <asp:LinkButton ID="btnEditItem" runat="server"
                                    Text="Edit"
                                    CommandName="EditMedicine"
                                    CommandArgument='<%# Eval("PrescriptionItemID") %>'
                                    CausesValidation="false" />

                                <asp:LinkButton ID="btnDeleteItem" runat="server"
                                    Text="Delete"
                                    CssClass="text-danger"
                                    CommandName="DeleteMedicine"
                                    CommandArgument='<%# Eval("PrescriptionItemID") %>'
                                    CausesValidation="false"
                                    OnClientClick="return confirm('Delete this medicine from the prescription?');" />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>

    </asp:Panel>

    <!-- EDIT MEDICINE -->
    <asp:Panel ID="pnlEditItem" runat="server" Visible="false">
        <div class="pm-card">
            <h4>3. Edit Prescribed Medicine</h4>

            <asp:HiddenField ID="hfPrescriptionItemID" runat="server" />

            <div class="row">
                <div class="col-md-6 mb-3">
                    <asp:Label ID="lblEditMedicine" runat="server"
                        AssociatedControlID="txtEditMedicine"
                        CssClass="pm-label">Medicine</asp:Label>
                    <asp:TextBox ID="txtEditMedicine" runat="server"
                        CssClass="pm-input" ReadOnly="true" />
                </div>

                <div class="col-md-6 mb-3">
                    <asp:Label ID="lblEditDosage" runat="server"
                        AssociatedControlID="txtEditDosage"
                        CssClass="pm-label">Dosage</asp:Label>
                    <asp:TextBox ID="txtEditDosage" runat="server"
                        CssClass="pm-input" MaxLength="50" />
                </div>

                <div class="col-md-6 mb-3">
                    <asp:Label ID="lblEditFrequency" runat="server"
                        AssociatedControlID="txtEditFrequency"
                        CssClass="pm-label">Frequency</asp:Label>
                    <asp:TextBox ID="txtEditFrequency" runat="server"
                        CssClass="pm-input" MaxLength="50" />
                </div>

                <div class="col-md-6 mb-3">
                    <asp:Label ID="lblEditDuration" runat="server"
                        AssociatedControlID="txtEditDuration"
                        CssClass="pm-label">Duration (days)</asp:Label>
                    <asp:TextBox ID="txtEditDuration" runat="server"
                        CssClass="pm-input" TextMode="Number" />
                </div>

                <div class="col-12 mb-3">
                    <asp:Label ID="lblEditInstruction" runat="server"
                        AssociatedControlID="txtEditInstruction"
                        CssClass="pm-label">Instructions</asp:Label>
                    <asp:TextBox ID="txtEditInstruction" runat="server"
                        CssClass="pm-input" MaxLength="200" />
                </div>
            </div>

            <asp:Button ID="btnUpdateItem" runat="server"
                Text="Save Changes" CssClass="pm-button"
                OnClick="btnUpdateItem_Click" />

            <asp:Button ID="btnCancelEdit" runat="server"
                Text="Cancel" CssClass="pm-secondary ms-2"
                CausesValidation="false"
                OnClick="btnCancelEdit_Click" />
        </div>
    </asp:Panel>

</div>

</asp:Content>
