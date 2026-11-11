
<%@ Page Title="Medicine Management" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="MedicineManagement.aspx.cs" Inherits="WebApplication1.Private.Administrator.MedicineManagement" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <style>
        .medicine-page {
            padding: 20px 0 40px;
        }

        .medicine-header {
            background: linear-gradient(135deg, #234d2b, #367344);
            color: white;
            padding: 28px 30px;
            border-radius: 12px;
            margin-bottom: 25px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.10);
        }

        .medicine-header h2 {
            margin: 0 0 7px;
            font-weight: 600;
        }

        .medicine-header p {
            margin: 0;
            opacity: 0.85;
        }

        .medicine-card {
            background: #ffffff;
            border: 1px solid #e5e9e5;
            border-radius: 12px;
            padding: 24px;
            margin-bottom: 25px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.045);
        }

        .medicine-card h4 {
            color: #234d2b;
            font-weight: 600;
            margin: 0 0 18px;
        }

        .medicine-description {
            color: #777;
            font-size: 13px;
            margin-top: -10px;
            margin-bottom: 18px;
        }

        .medicine-label {
            display: block;
            font-weight: 600;
            color: #444;
            margin-bottom: 7px;
        }

        .medicine-input {
            width: 100%;
            height: 40px;
            padding: 8px 12px;
            border: 1px solid #ced8ce;
            border-radius: 6px;
            box-sizing: border-box;
            margin-bottom: 15px;
        }

        .medicine-input:focus {
            outline: none;
            border-color: #367344;
            box-shadow: 0 0 0 3px rgba(54,115,68,0.12);
        }

        .medicine-btn {
            background: #24572d;
            color: white;
            border: none;
            border-radius: 6px;
            padding: 10px 20px;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.2s;
        }

        .medicine-btn:hover {
            background: #193e20;
            color: white;
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
            padding: 13px 12px;
            text-align: left;
            font-weight: 600;
            border: none;
        }

        .medicine-grid td {
            padding: 12px;
            border-bottom: 1px solid #e9eee9;
            vertical-align: middle;
        }

        .medicine-grid tr:nth-child(even) {
            background: #f5f8f5;
        }

        .medicine-grid tr:hover {
            background: #edf4ed;
        }

        .medicine-grid a {
            color: #24572d;
            font-weight: 600;
            text-decoration: none;
            margin-right: 8px;
        }

        .medicine-grid a:hover {
            text-decoration: underline;
        }

        .medicine-grid input[type="text"],
        .medicine-grid select {
            padding: 6px;
            border: 1px solid #ced8ce;
            border-radius: 5px;
            max-width: 100%;
        }

        .medicine-search-row {
            display: flex;
            gap: 12px;
            align-items: end;
            flex-wrap: wrap;
        }

        .medicine-search-field {
            flex: 1;
            min-width: 220px;
        }

        .medicine-search-field .medicine-input {
            margin-bottom: 0;
        }

        .medicine-search-row .medicine-btn {
            height: 40px;
        }

        .medicine-stat-heading {
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 10px;
        }

        .medicine-stat-label {
            display: inline-block;
            background: #eaf3eb;
            color: #24572d;
            border-radius: 20px;
            padding: 5px 12px;
            font-size: 12px;
            font-weight: 600;
        }

        .medicine-empty {
            color: #777;
            padding: 18px;
            text-align: center;
        }

        @media (max-width: 600px) {
            .medicine-header {
                padding: 22px;
            }

            .medicine-card {
                padding: 16px;
            }

            .medicine-search-row {
                display: block;
            }

            .medicine-search-row .medicine-btn {
                margin-top: 12px;
                width: 100%;
            }

            .medicine-grid {
                font-size: 12px;
            }

            .medicine-grid th,
            .medicine-grid td {
                padding: 9px 7px;
            }
        }
    </style>

    <div class="medicine-page">

        <!-- PAGE HEADER -->
        <div class="medicine-header">
            <h2>Medicine Management</h2>
            <p>Manage the clinic's medicine inventory and monitor medicine usage.</p>
        </div>

        <!-- MEDICINE INVENTORY -->
        <div class="medicine-card">

            <h4>Medicine Inventory</h4>

            <p class="medicine-description">
                Search, edit or remove medicines from the clinic inventory.
            </p>

            <div class="medicine-search-row">

                <div class="medicine-search-field">
                    <asp:Label
                        ID="Label1"
                        runat="server"
                        Text="Search by medicine name"
                        CssClass="medicine-label">
                    </asp:Label>

                    <asp:TextBox
                        ID="TBMedicine"
                        runat="server"
                        CssClass="medicine-input"
                        placeholder="Enter medicine name...">
                    </asp:TextBox>
                </div>

                <asp:Button
                    ID="BtnSearch"
                    runat="server"
                    Text="Search Medicines"
                    CssClass="medicine-btn"
                    CausesValidation="false" />

            </div>

            <asp:GridView
                ID="GridView1"
                runat="server"
                CellPadding="4"
                DataSourceID="SqlDSmedicine"
                ForeColor="#333333"
                GridLines="None"
                CssClass="medicine-grid"
                EmptyDataText="No medicines found."
                EmptyDataRowStyle-CssClass="medicine-empty">

                <AlternatingRowStyle BackColor="#f5f8f5" />

                <Columns>
                    <asp:CommandField
                        ShowDeleteButton="True"
                        ShowEditButton="True"
                        ShowSelectButton="True" />
                </Columns>

                <EditRowStyle BackColor="#edf4ed" />

                <HeaderStyle
                    BackColor="#24572d"
                    ForeColor="White"
                    Font-Bold="True" />

                <RowStyle BackColor="White" />

                <SelectedRowStyle
                    BackColor="#e0eee1"
                    Font-Bold="True"
                    ForeColor="#234d2b" />

                <PagerStyle
                    BackColor="#24572d"
                    ForeColor="White"
                    HorizontalAlign="Center" />

            </asp:GridView>

        </div>


        <!-- ADD MEDICINE -->
        <div class="medicine-card">

            <h4>Add New Medicine</h4>

            <p class="medicine-description">
                Register a new medicine in the clinic's inventory.
            </p>

            <div class="row">

                <div class="col-md-7">

                    <asp:Label
                        ID="Label3"
                        runat="server"
                        Text="Medicine Name"
                        CssClass="medicine-label">
                    </asp:Label>

                    <asp:TextBox
                        ID="TBNewMed"
                        runat="server"
                        CssClass="medicine-input"
                        placeholder="Enter new medicine name...">
                    </asp:TextBox>

                </div>

                <div class="col-md-5">

                    <asp:Label
                        ID="LabelDosage"
                        runat="server"
                        Text="Dosage Unit"
                        CssClass="medicine-label">
                    </asp:Label>

                    <asp:DropDownList
                        ID="DDLDosageUnit"
                        runat="server"
                        CssClass="medicine-input">

                        <asp:ListItem>Tablet</asp:ListItem>
                        <asp:ListItem>Capsule</asp:ListItem>
                        <asp:ListItem>mL</asp:ListItem>
                        <asp:ListItem>Puff</asp:ListItem>
                        <asp:ListItem>Sachet</asp:ListItem>
                        <asp:ListItem>Injection</asp:ListItem>
                        <asp:ListItem>Cream</asp:ListItem>
                        <asp:ListItem>Other</asp:ListItem>

                    </asp:DropDownList>

                </div>

            </div>

            <asp:Button
                ID="BtnMedAdd"
                runat="server"
                OnClick="BtnMedAdd_Click"
                Text="Add Medicine"
                CssClass="medicine-btn" />

        </div>


        <!-- MEDICINE USAGE STATISTICS -->
        <div class="medicine-card">

            <div class="medicine-stat-heading">

                <h4>Medicine Usage Statistics</h4>

                <span class="medicine-stat-label">
                    Past 6 Months
                </span>

            </div>

            <p class="medicine-description">
                View how frequently medicines appear in prescription records.
            </p>

            <asp:GridView
                ID="GridView2"
                runat="server"
                AutoGenerateColumns="False"
                CellPadding="4"
                DataKeyNames="MedicineID"
                DataSourceID="SqlDSMedUsed"
                ForeColor="#333333"
                GridLines="None"
                CssClass="medicine-grid"
                EmptyDataText="No medicine usage records found."
                EmptyDataRowStyle-CssClass="medicine-empty">

                <Columns>

                    <asp:BoundField
                        DataField="MedicineName"
                        HeaderText="Medicine"
                        SortExpression="MedicineName" />

                    <asp:BoundField
                        DataField="TimesPrescribed"
                        HeaderText="Times Prescribed"
                        ReadOnly="True"
                        SortExpression="TimesPrescribed" />

                </Columns>

                <AlternatingRowStyle BackColor="#f5f8f5" />

                <HeaderStyle
                    BackColor="#24572d"
                    ForeColor="White"
                    Font-Bold="True" />

                <RowStyle BackColor="White" />

                <PagerStyle
                    BackColor="#24572d"
                    ForeColor="White"
                    HorizontalAlign="Center" />

            </asp:GridView>

        </div>

    </div>


    <!-- MEDICINE INVENTORY DATA SOURCE -->
    <asp:SqlDataSource
        ID="SqlDSmedicine"
        runat="server"
        ConflictDetection="CompareAllValues"
        ConnectionString="<%$ ConnectionStrings:GroupPmb6ConnectionString %>"
        DeleteCommand="DELETE FROM [Medicine] WHERE [MedicineID] = @original_MedicineID AND (([MedicineName] = @original_MedicineName) OR ([MedicineName] IS NULL AND @original_MedicineName IS NULL)) AND (([DosageUnit] = @original_DosageUnit) OR ([DosageUnit] IS NULL AND @original_DosageUnit IS NULL))"
        InsertCommand="INSERT INTO [Medicine] ([MedicineName], [DosageUnit]) VALUES (@MedicineName, @DosageUnit)"
        OldValuesParameterFormatString="original_{0}"
        SelectCommand="SELECT MedicineID, MedicineName, DosageUnit FROM Medicine WHERE (MedicineName LIKE '%' + @name + '%')"
        UpdateCommand="UPDATE [Medicine] SET [MedicineName] = @MedicineName, [DosageUnit] = @DosageUnit WHERE [MedicineID] = @original_MedicineID AND (([MedicineName] = @original_MedicineName) OR ([MedicineName] IS NULL AND @original_MedicineName IS NULL)) AND (([DosageUnit] = @original_DosageUnit) OR ([DosageUnit] IS NULL AND @original_DosageUnit IS NULL))">

        <DeleteParameters>
            <asp:Parameter Name="original_MedicineID" Type="Int32" />
            <asp:Parameter Name="original_MedicineName" Type="String" />
            <asp:Parameter Name="original_DosageUnit" Type="String" />
        </DeleteParameters>

        <InsertParameters>
            <asp:ControlParameter
                ControlID="TBNewMed"
                Name="MedicineName"
                PropertyName="Text"
                Type="String" />

            <asp:ControlParameter
                ControlID="DDLDosageUnit"
                Name="DosageUnit"
                PropertyName="SelectedValue"
                Type="String" />
        </InsertParameters>

        <SelectParameters>
            <asp:ControlParameter
                ControlID="TBMedicine"
                Name="name"
                PropertyName="Text" />
        </SelectParameters>

        <UpdateParameters>
            <asp:Parameter Name="MedicineName" Type="String" />
            <asp:Parameter Name="DosageUnit" Type="String" />
            <asp:Parameter Name="original_MedicineID" Type="Int32" />
            <asp:Parameter Name="original_MedicineName" Type="String" />
            <asp:Parameter Name="original_DosageUnit" Type="String" />
        </UpdateParameters>

    </asp:SqlDataSource>


    <!-- MEDICINE STATISTICS DATA SOURCE -->
    <asp:SqlDataSource
        ID="SqlDSMedUsed"
        runat="server"
        ConnectionString="<%$ ConnectionStrings:GroupPmb6ConnectionString %>"
        SelectCommand="SELECT Medicine.MedicineID, Medicine.MedicineName, COUNT(PrescriptionItem.MedicineID) AS TimesPrescribed FROM Medicine LEFT OUTER JOIN PrescriptionItem ON Medicine.MedicineID = PrescriptionItem.MedicineID LEFT OUTER JOIN Prescriptions ON PrescriptionItem.PrescriptionID = Prescriptions.PrescriptionID AND Prescriptions.DateIssued &gt;= DATEADD(MONTH, - 6, GETDATE()) AND Prescriptions.DateIssued &lt;= GETDATE() GROUP BY Medicine.MedicineID, Medicine.MedicineName ORDER BY TimesPrescribed DESC">
    </asp:SqlDataSource>

</asp:Content>
