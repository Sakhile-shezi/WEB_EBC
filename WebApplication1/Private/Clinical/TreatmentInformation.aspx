
<%@ Page Title="Record Treatment" Language="C#" MasterPageFile="~/Site.Master"
    AutoEventWireup="true" CodeBehind="TreatmentInformation.aspx.cs"
    Inherits="WebApplication1.Private.Treatment" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

<style>
    .treatment-container {
        max-width: 1050px;
        margin: 25px auto;
        padding: 0 18px 35px;
        color: #26352e;
    }

    .treatment-header {
        background: linear-gradient(135deg, #234d2b, #367344);
        color: white;
        padding: 25px 30px;
        border-radius: 12px;
        margin-bottom: 22px;
    }

    .treatment-header h2 {
        margin: 0 0 6px;
        font-weight: 700;
    }

    .treatment-header p {
        margin: 0 0 14px;
        color: #dce9dc;
    }

    .treatment-card {
        background: white;
        border: 1px solid #e1e8e2;
        border-radius: 10px;
        padding: 22px;
        margin-bottom: 22px;
        box-shadow: 0 3px 12px rgba(0,0,0,.045);
    }

    .section-heading {
        color: #24572d;
        font-size: 18px;
        font-weight: 700;
        margin-bottom: 18px;
        padding-bottom: 10px;
        border-bottom: 1px solid #e5ece5;
    }

    .field-label {
        display: block;
        font-weight: 600;
        color: #344b38;
        margin-bottom: 6px;
    }

    .treatment-container .form-control {
        width: 100%;
        border: 1px solid #ced8ce;
        border-radius: 6px;
        min-height: 42px;
        padding: 9px 12px;
        box-sizing: border-box;
    }

    .treatment-container .form-control:focus {
        border-color: #367344;
        box-shadow: 0 0 0 3px rgba(54,115,68,.12);
        outline: none;
    }

    .treatment-container textarea.form-control {
        min-height: 95px;
        resize: vertical;
    }

    .staff-list {
        border: 1px solid #e1e8e1;
        border-radius: 8px;
        padding: 12px;
        max-height: 220px;
        overflow-y: auto;
        background: #fff;
    }

    .staff-list label {
        margin-left: 7px;
        margin-right: 12px;
        margin-bottom: 8px;
        font-weight: 400;
    }

    .save-button {
        background: #24572d;
        color: white;
        border: none;
        border-radius: 6px;
        padding: 11px 22px;
        font-weight: 600;
        cursor: pointer;
    }

    .save-button:hover {
        background: #367344;
        color: white;
    }

    .help-text {
        color: #718071;
        font-size: 13px;
        margin-top: 5px;
    }

    .treatment-info-panel {
        background: #f3f7f3;
        border: 1px solid #dce9dc;
        border-left: 4px solid #367344;
        border-radius: 7px;
        padding: 14px;
        margin-bottom: 18px;
        color: #344b38;
        line-height: 1.7;
    }

    .treatment-alert {
        border-radius: 8px;
        padding: 13px 16px;
        margin-bottom: 18px;
    }

    .treatment-success {
        background: #edf6ee;
        border: 1px solid #cce3ce;
        color: #24572d;
    }

    .treatment-error {
        background: #fff1f0;
        border: 1px solid #f0ceca;
        color: #8c3029;
    }

    @media(max-width: 600px) {
        .treatment-header {
            padding: 20px;
        }

        .treatment-card {
            padding: 15px;
        }

        .save-button {
            width: 100%;
        }
    }
</style>

<div class="treatment-container">

    <div class="treatment-header">
        <h2>Record Treatment Information</h2>
        <p>Record clinical treatment details and participating staff.</p>

        <a href="TreatmentHistory.aspx" class="btn btn-light btn-sm">
            View Treatment History
        </a>
    </div>

    <asp:Panel ID="pnlSuccess" runat="server" Visible="false"
        CssClass="treatment-alert treatment-success">
        <asp:Label ID="lblSuccess" runat="server" />
    </asp:Panel>

    <asp:Panel ID="pnlError" runat="server" Visible="false"
        CssClass="treatment-alert treatment-error">
        <asp:Label ID="lblError" runat="server" />
    </asp:Panel>

    <!-- APPOINTMENT AND TREATMENT -->
    <div class="treatment-card">

        <div class="section-heading">
            1. Appointment and Treatment
        </div>

        <div class="mb-3">
            <label class="field-label">Appointment</label>

            <asp:DropDownList ID="ddlAppointment" runat="server"
                CssClass="form-control" />

            <div class="help-text">
                Scheduled and completed appointments are available.
            </div>
        </div>

        <div class="mb-3">
            <label class="field-label">Treatment</label>

            <asp:DropDownList ID="ddlTreatment" runat="server"
                CssClass="form-control"
                AutoPostBack="true"
                OnSelectedIndexChanged="ddlTreatment_SelectedIndexChanged" />
        </div>

        <asp:Panel ID="pnlTreatmentInfo" runat="server"
            Visible="false" CssClass="treatment-info-panel">

            <strong>Instructions:</strong>
            <asp:Label ID="lblInstructions" runat="server" />

            <br />

            <strong>Doctor requirement:</strong>
            <asp:Label ID="lblRequiresDoctor" runat="server" />

        </asp:Panel>

        <div class="mb-3">
            <label class="field-label">Date and time performed</label>

            <asp:TextBox ID="txtPerformedAt" runat="server"
                TextMode="DateTimeLocal"
                CssClass="form-control" />
        </div>

    </div>

    <!-- CLINICAL INFORMATION -->
    <div class="treatment-card">

        <div class="section-heading">
            2. Clinical Information
        </div>

        <div class="mb-3">
            <label class="field-label">Diagnosis</label>

            <asp:TextBox ID="txtDiagnosis" runat="server"
                CssClass="form-control"
                MaxLength="255"
                placeholder="Enter diagnosis..." />
        </div>

        <div class="mb-3">
            <label class="field-label">Results</label>

            <asp:TextBox ID="txtResults" runat="server"
                CssClass="form-control"
                TextMode="MultiLine"
                MaxLength="255"
                placeholder="Enter treatment results..." />
        </div>

        <div class="mb-3">
            <label class="field-label">Additional Notes</label>

            <asp:TextBox ID="txtNotes" runat="server"
                CssClass="form-control"
                TextMode="MultiLine"
                MaxLength="255"
                placeholder="Additional clinical notes..." />
        </div>

    </div>

    <!-- PARTICIPATING STAFF -->
    <div class="treatment-card">

        <div class="section-heading">
            3. Participating Staff
        </div>

        <p class="help-text">
            Select all doctors and nurses who participated in this treatment.
            At least one staff member must be selected.
        </p>

        <div class="row">

            <div class="col-md-6 mb-3">
                <label class="field-label">Doctors</label>

                <div class="staff-list">
                    <asp:CheckBoxList ID="cblDoctors" runat="server"
                        RepeatLayout="Flow"
                        RepeatDirection="Vertical" />
                </div>
            </div>

            <div class="col-md-6 mb-3">
                <label class="field-label">Nurses</label>

                <div class="staff-list">
                    <asp:CheckBoxList ID="cblNurses" runat="server"
                        RepeatLayout="Flow"
                        RepeatDirection="Vertical" />
                </div>
            </div>

        </div>

    </div>

    <div class="d-flex flex-wrap justify-content-end gap-2 mb-5">

        <asp:Button ID="btnClear" runat="server"
            Text="Clear Form"
            CssClass="btn btn-outline-secondary"
            CausesValidation="false"
            OnClick="btnClear_Click" />

        <asp:Button ID="btnSave" runat="server"
            Text="Save Treatment Information"
            CssClass="save-button"
            OnClick="btnSave_Click" />

    </div>

</div>

</asp:Content>
