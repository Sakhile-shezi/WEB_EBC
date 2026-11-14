
<%@ Page Title="Medicine Catalogue" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Medicine.aspx.cs" Inherits="WebApplication1.Private.Medicine" %>

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
        box-shadow: 0 3px 12px rgba(0,0,0,.045);
    }

    .medicine-search {
        display: flex;
        gap: 12px;
        align-items: end;
        flex-wrap: wrap;
        margin-bottom: 15px;
    }

    .medicine-search-field {
        flex: 1;
        min-width: 220px;
    }

    .medicine-label {
        display: block;
        font-weight: 600;
        margin-bottom: 6px;
    }

    .medicine-input {
        width: 100%;
        padding: 10px 12px;
        border: 1px solid #ced8ce;
        border-radius: 6px;
        box-sizing: border-box;
    }

    .medicine-btn {
        background: #24572d;
        color: white;
        border: none;
        border-radius: 6px;
        padding: 10px 19px;
        font-weight: 600;
        cursor: pointer;
    }

    .medicine-grid-wrap {
        width: 100%;
        overflow-x: auto;
    }

    .medicine-grid {
        width: 100%;
        border-collapse: collapse;
        margin-top: 12px;
        font-size: 14px;
    }

    .medicine-grid th {
        background: #24572d;
        color: white;
        padding: 13px;
        text-align: left;
        white-space: nowrap;
    }

    .medicine-grid td {
        padding: 12px;
        border-bottom: 1px solid #e5eae6;
    }

    .medicine-grid tr:nth-child(even) {
        background: #f3f7f3;
    }

    .medicine-grid tr:hover {
        background: #e8f1e8;
    }

    .medicine-grid a {
        color: #24572d;
        font-weight: 600;
    }

    .medicine-pager {
        background: #24572d;
        color: white;
        padding: 10px;
    }

    @media (max-width: 600px) {
        .medicine-header {
            padding: 20px;
        }

        .medicine-card {
            padding: 15px;
        }

        .medicine-search {
            display: block;
        }

        .medicine-search-field {
            margin-bottom: 12px;
        }

        .medicine-btn {
            width: 100%;
        }

        .medicine-grid {
            font-size: 12px;
        }

        .medicine-grid th,
        .medicine-grid td {
            padding: 9px;
        }
    }
</style>

<div class="medicine-page">

    <div class="medicine-header">
        <h2>Medicine Catalogue</h2>
        <p>Search and view medicines available in the clinic.</p>
    </div>

    <div class="medicine-card">

        <div class="medicine-search">

            <div class="medicine-search-field">
                <asp:Label ID="lblMedicineSearch" runat="server"
                    AssociatedControlID="TBMedicine"
                    Text="Search medicine"
                    CssClass="medicine-label" />

                <asp:TextBox ID="TBMedicine" runat="server"
                    CssClass="medicine-input"
                    placeholder="Enter a medicine name..." />
            </div>

            <asp:Button ID="BtnSearch" runat="server"
                Text="Search"
                CssClass="medicine-btn"
                OnClick="BtnSearch_Click"
                CausesValidation="false" />

            <asp:Button ID="BtnClear" runat="server"
                Text="Clear"
                CssClass="medicine-btn"
                OnClick="BtnClear_Click"
                CausesValidation="false" />

        </div>

        <div class="medicine-grid-wrap">

            <asp:GridView ID="GVMedicine" runat="server"
                AutoGenerateColumns="False"
                DataKeyNames="MedicineID"
                DataSourceID="SqlDSMedicine"
                CssClass="medicine-grid"
                GridLines="None"
                AllowPaging="True"
                PageSize="10"
                AllowSorting="True"
                EmptyDataText="No medicines found.">

                <Columns>
                    <asp:BoundField DataField="MedicineName"
                        HeaderText="Medicine"
                        SortExpression="MedicineName" />

                    <asp:BoundField DataField="DosageUnit"
                        HeaderText="Dosage unit"
                        SortExpression="DosageUnit" />
                </Columns>

                <HeaderStyle BackColor="#24572d"
                    ForeColor="White" Font-Bold="True" />

                <AlternatingRowStyle BackColor="#f3f7f3" />

                <PagerStyle CssClass="medicine-pager" />

            </asp:GridView>

        </div>

    </div>

    <asp:SqlDataSource ID="SqlDSMedicine" runat="server"
        ConnectionString="<%$ ConnectionStrings:GroupPmb6ConnectionString %>"
        CancelSelectOnNullParameter="False"
        SelectCommand="
            SELECT MedicineID, MedicineName, DosageUnit
            FROM Medicine
            WHERE (@name IS NULL OR @name = ''
                OR MedicineName LIKE '%' + @name + '%')
            ORDER BY MedicineName">

        <SelectParameters>
            <asp:ControlParameter ControlID="TBMedicine"
                Name="name"
                PropertyName="Text"
                Type="String"
                ConvertEmptyStringToNull="true" />
        </SelectParameters>

    </asp:SqlDataSource>

</div>

</asp:Content>

