<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Private1.aspx.cs" Inherits="WebApplication1.Private.Private1" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
<style>
        /* Scoped to container to protect Master Page elements */
        .prescription-container {
            max-width: 1100px;
            margin: 20px auto;
            background: #ffffff;
            padding: 24px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            font-family: Arial, sans-serif;
        }

/*        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 2px solid #eaeaea;
            padding-bottom: 12px;
            margin-bottom: 20px;
        }*/
        .page-header {
    display: flex;
    flex-direction: column;
    align-items: center;
    text-align: center;
    border-bottom: 2px solid #eaeaea;
    padding-bottom: 12px;
    margin-bottom: 20px;
}

.header-image {
    width: 100%;
    max-height: 150px;
    height: 250px;
    object-fit: cover;
    border-radius: 8px;
    margin-bottom: 15px;
}

.page-header h1 {
    margin: 0;
    color: #333;
}

        .form-section {
            margin-bottom: 24px;
        }

        .form-section h3 {
            margin-bottom: 16px;
            color: #333;
        }

        .form-group-row {
            display: flex;
            gap: 16px;
        }

        .form-group {
            flex: 1;
            display: flex;
            flex-direction: column;
            margin-bottom: 16px;
        }

        .form-group label {
            font-weight: bold;
            margin-bottom: 6px;
            font-size: 0.9rem;
        }

        .form-control {
            padding: 8px 12px;
            border: 1px solid #ccc;
            border-radius: 4px;
            font-size: 0.95rem;
            box-sizing: border-box;
            width: 100%;
        }

        .form-actions {
            margin-top: 16px;
        }

        .btn-primary, .btn-secondary {
            padding: 8px 16px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 0.95rem;
        }

        .btn-primary { background: #0056b3; color: white; }
        .btn-primary:hover { background: #004494; }
        .btn-secondary { background: #6c757d; color: white; margin-left: 8px; }
        .btn-secondary:hover { background: #5a6268; }
    </style>

    <div class="prescription-container">
        <header class="page-header">
            <img class="header-image" src="/Images/WhatsApp Image 2026-09-02 at 10.38.35.jpeg"/>
            <h1>Create Patient Prescription</h1>
        </header>

        <%-- Removed nested <form> tag --%>
        <div class="prescription-form">
            <div class="form-section">
                <h3>Patient Information</h3>
                <div class="form-group-row">
                    <div class="form-group">
                        <asp:Label runat="server" AssociatedControlID="txtPatientName">Patient Name</asp:Label>
                        <asp:TextBox ID="txtPatientName" runat="server" CssClass="form-control" placeholder="Enter patient full name" />
                    </div>
                    <div class="form-group">
                        <asp:Label runat="server" AssociatedControlID="txtPatientDob">Date of Birth</asp:Label>
                        <asp:TextBox ID="txtPatientDob" runat="server" TextMode="Date" CssClass="form-control" />
                    </div>
                </div>
            </div>

            <div class="form-section">
                <h3>Medication Details</h3>
                <div class="form-group-row">
                    <div class="form-group">
                        <asp:Label runat="server" AssociatedControlID="txtMedication">Medication Name</asp:Label>
                        <asp:TextBox ID="txtMedication" runat="server" CssClass="form-control" placeholder="e.g., Amoxicillin" />
                    </div>
                    <div class="form-group">
                        <asp:Label runat="server" AssociatedControlID="txtDosage">Dosage</asp:Label>
                        <asp:TextBox ID="txtDosage" runat="server" CssClass="form-control" placeholder="e.g., 500mg" />
                    </div>
                    <div class="form-group">
                        <asp:Label runat="server" AssociatedControlID="txtFrequency">Frequency</asp:Label>
                        <asp:TextBox ID="txtFrequency" runat="server" CssClass="form-control" placeholder="e.g., Twice daily" />
                    </div>
                </div>
                <div class="form-group">
                    <asp:Label runat="server" AssociatedControlID="txtInstructions">Special Instructions</asp:Label>
                    <asp:TextBox ID="txtInstructions" runat="server" TextMode="MultiLine" Rows="3" CssClass="form-control" placeholder="Take with food..." />
                </div>
            </div>

            <div class="form-actions">
                <asp:Button ID="btnSubmit" runat="server" Text="Issue Prescription" CssClass="btn-primary" OnClick="btnSubmit_Click" />
                <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="btn-secondary" OnClick="btnCancel_Click" CauseValidation="false" />
            </div>
        </div>
    </div>

</asp:Content>
