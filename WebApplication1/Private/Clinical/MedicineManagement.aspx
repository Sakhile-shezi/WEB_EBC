

<%@ Page Title="Medicine Management" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="MedicineManagement.aspx.cs" Inherits="WebApplication1.Private.Clinical.MedicineManagement" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

<style>
    .medicine-page {
        max-width: 1200px;
        margin: 25px auto;
        padding: 0 18px 35px;
        color: #26352e;
    }

    .medicine-header {
        background: linear-gradient(135deg, #234d2b, #367344);
        color: white;
        padding: 25px 30px;
        border-radius: 12px;
        margin-bottom: 22px;
    }

    .medicine-header h2 {
        margin: 0 0 6px;
    }

    .medicine-header p {
        margin: 0;
        color: #dce9dc;
    }

    .medicine-card {
        background: white;
        border: 1px solid #e1e8e2;
        border-radius: 10px;
        padding: 22px;
        margin-bottom: 22px;
        box-shadow: 0 3px 12px rgba(0,0,0,.045);
    }

    .medicine-card h4 {
        color: #234d2b;
        margin: 0 0 15px;
        padding-bottom: 12px;
        border-bottom: 2px solid #e5eee5;
    }

    .medicine-description {
        color: #6b786e;
        font-size: 13px;
        margin-bottom: 18px;
    }

    .medicine-label {
        display: block;
        font-weight: 600;
        margin-bottom: 6px;
        color: #34483a;
    }

    .medicine-input {
        width: 100%;
        height: 42px;
        padding: 9px 12px;
        border: 1px solid #ced8ce;
        border-radius: 6px;
        box-sizing: border-box;
        margin-bottom: 15px;
    }

    .medicine-input:focus {
        outline: none;
        border-color: #367344;
        box-shadow: 0 0 0 3px rgba(54,115,68,.12);
    }

    .medicine-btn {
        background: #24572d;
        color: white;
        border: none;
        border-radius: 6px;
        padding: 10px 20px;
        font-weight: 600;
        cursor: pointer;
    }

    .medicine-btn:hover {
        background: #193e20;
    }

    .medicine-grid-wrap {
        width: 100%;
        overflow-x: auto;
    }

    .medicine-grid {
        width: 100%;
        border-collapse: collapse;
        margin-top: 12px;
        font-size: 13px;
    }

    .medicine-grid th {
        background: #24572d !important;
        color: white !important;
        padding: 12px;
        text-align: left;
        white-space: nowrap;
    }

    .medicine-grid th a {
        color: white !important;
    }

    .medicine-grid td {
        padding: 11px;
        border-bottom: 1px solid #e5eae6;
    }

    .medicine-grid tr:nth-child(even) {
        background: #f3f7f3;
    }

    .medicine-grid a {
        color: #24572d;
        font-weight: 600;
    }

    .medicine-status {
        display: block;
        margin-top: 12px;
        color: #24572d;
        font-weight: 600;
    }

    .medicine-error {
        display: block;
        margin-top: 12px;
        color: #a12626;
        font-weight: 600;
    }

    @media (max-width: 600px) {
        .medicine-header {
            padding: 20px;
        }

        .medicine-card {
            padding: 15px;
        }

        .medicine-btn {
            width: 100%;
        }
    }
</style>

<div class="medicine-page">

    <div class="medicine-header">
        <h2>Medicine Management</h2>
        <p>Add new medicines or update existing catalogue information.</p>
    </div>

    <!-- Add medicine -->
    <div class="medicine-card">

        <h4>Add New Medicine</h4>

        <p class="medicine-description">
            Enter the medicine name and its dosage unit.
        </p>

        <asp:Label ID="lblMedicineName" runat="server"
            Text="Medicine name"
            AssociatedControlID="TBNewMed"
            CssClass="medicine-label" />

        <asp:TextBox ID="TBNewMed" runat="server"
            CssClass="medicine-input"
            MaxLength="100"
            placeholder="Enter medicine name..." />

        <asp:RequiredFieldValidator ID="rfvMedicineName"
            runat="server"
            ControlToValidate="TBNewMed"
            ErrorMessage="Please enter a medicine name."
            ForeColor="Red"
            Display="Dynamic"
            ValidationGroup="AddMedicine" />

        <asp:Label ID="lblDosageUnit" runat="server"
            Text="Dosage unit"
            AssociatedControlID="DDLDosageUnit"
            CssClass="medicine-label" />

        <asp:DropDownList ID="DDLDosageUnit" runat="server"
            CssClass="medicine-input">

            <asp:ListItem Value="Tablet">Tablet</asp:ListItem>
            <asp:ListItem Value="Capsule">Capsule</asp:ListItem>
            <asp:ListItem Value="mL">mL</asp:ListItem>
            <asp:ListItem Value="Puff">Puff</asp:ListItem>
            <asp:ListItem Value="Sachet">Sachet</asp:ListItem>
            <asp:ListItem Value="Injection">Injection</asp:ListItem>
            <asp:ListItem Value="Cream">Cream</asp:ListItem>
            <asp:ListItem Value="Other">Other</asp:ListItem>

        </asp:DropDownList>

        <asp:Button ID="BtnMedAdd" runat="server"
            Text="Add Medicine"
            CssClass="medicine-btn"
            OnClick="BtnMedAdd_Click"
            ValidationGroup="AddMedicine" />

        <asp:Label ID="lblStatus" runat="server"
            CssClass="medicine-status" />

        <asp:Label ID="lblError" runat="server"
            CssClass="medicine-error" />

    </div>

    <!-- Edit existing medicines -->
    <div class="medicine-card">

        <h4>Existing Medicines</h4>

        <p class="medicine-description">
            Select Edit to update a medicine's name or dosage unit.
            Historical prescriptions are retained.
        </p>

        <div class="medicine-grid-wrap">

            <asp:GridView ID="GVMedicine" runat="server"
                AutoGenerateColumns="False"
                DataKeyNames="MedicineID"
                DataSourceID="SqlDSmedicine"
                CssClass="medicine-grid"
                GridLines="None"
                AllowPaging="True"
                PageSize="10"
                AllowSorting="True"
                EmptyDataText="No medicines found.">

                <Columns>

                    <asp:BoundField DataField="MedicineID"
                        HeaderText="ID"
                        ReadOnly="True"
                        SortExpression="MedicineID" />

                    <asp:BoundField DataField="MedicineName"
                        HeaderText="Medicine name"
                        SortExpression="MedicineName" />

                    <asp:BoundField DataField="DosageUnit"
                        HeaderText="Dosage unit"
                        SortExpression="DosageUnit" />

                    <asp:CommandField ShowEditButton="True"
                        EditText="Edit"
                        UpdateText="Save"
                        CancelText="Cancel" />

                </Columns>

                <HeaderStyle BackColor="#24572d"
                    ForeColor="White" Font-Bold="True" />

                <AlternatingRowStyle BackColor="#f3f7f3" />

                <SelectedRowStyle BackColor="#e0eee1" />

                <PagerStyle BackColor="#24572d"
                    ForeColor="White"
                    HorizontalAlign="Center" />

            </asp:GridView>

        </div>

    </div>

    <asp:SqlDataSource ID="SqlDSmedicine" runat="server"
        ConnectionString="<%$ ConnectionStrings:GroupPmb6ConnectionString %>"
        SelectCommand="
            SELECT MedicineID, MedicineName, DosageUnit
            FROM Medicine
            ORDER BY MedicineName"

        InsertCommand="
            INSERT INTO Medicine (MedicineName, DosageUnit)
            VALUES (@MedicineName, @DosageUnit)"

        UpdateCommand="
            UPDATE Medicine
            SET MedicineName = @MedicineName,
                DosageUnit = @DosageUnit
            WHERE MedicineID = @MedicineID">

        <InsertParameters>
            <asp:ControlParameter ControlID="TBNewMed"
                Name="MedicineName"
                PropertyName="Text"
                Type="String" />

            <asp:ControlParameter ControlID="DDLDosageUnit"
                Name="DosageUnit"
                PropertyName="SelectedValue"
                Type="String" />
        </InsertParameters>

        <UpdateParameters>
            <asp:Parameter Name="MedicineName" Type="String" />
            <asp:Parameter Name="DosageUnit" Type="String" />
            <asp:Parameter Name="MedicineID" Type="Int32" />
        </UpdateParameters>

    </asp:SqlDataSource>

</div>

</asp:Content>
