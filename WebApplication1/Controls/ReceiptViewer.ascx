<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ReceiptViewer.ascx.cs" Inherits="WebApplication1.Controls.ReceiptViewer" %>
<%-- Appointment receipt for one booking of the signed-in patient: view, print or email.
     Used by the Appointments page and the patient's My History page. --%>
<asp:Panel ID="pnlReceipt" runat="server" CssClass="eb-rc-overlay" Visible="false">
    <%-- Styles live inside the panel so they only apply while a receipt is open. --%>
    <style>
    .eb-rc-overlay {position:fixed;inset:0;z-index:2000;background:rgba(15,42,31,.55);display:flex;align-items:flex-start;justify-content:center;padding:30px 14px;overflow-y:auto;font-family:system-ui,-apple-system,"Segoe UI",Arial,sans-serif}
    .eb-rc-dialog {width:100%;max-width:560px;background:#fff;border-radius:16px;box-shadow:0 20px 50px rgba(12,35,23,.3);overflow:hidden}
    .eb-rc-sheet {padding:22px 22px 6px}
    .eb-rc-actions {padding:14px 22px 20px;border-top:1px solid #e0e9e4;background:#f6f9f7}
    .eb-rc-note {display:block;font-size:11px;color:#6f817b;margin-bottom:6px}
    .eb-rc-msg {display:block;font-size:12px;font-weight:700;margin-bottom:10px}
    .eb-rc-msg:empty {display:none}
    .eb-rc-buttons {display:flex;gap:8px;flex-wrap:wrap;justify-content:flex-end}
    .eb-rc-btn {border:1px solid #dce7de;background:#fff;color:#38624b;border-radius:9px;padding:10px 16px;font-size:12px;font-weight:750;cursor:pointer}
    .eb-rc-btn:hover {background:#f0f7f2;color:#154d37}
    .eb-rc-btn.primary {background:#1e704f;border-color:#1e704f;color:#fff}
    .eb-rc-btn.primary:hover {background:#145a3e;color:#fff}
    @media print {
        body * {visibility:hidden!important}
        .eb-rc-sheet,.eb-rc-sheet * {visibility:visible!important}
        .eb-rc-overlay {position:absolute!important;inset:0 auto auto 0!important;width:100%;padding:0!important;background:none!important;display:block!important}
        .eb-rc-dialog {max-width:none!important;box-shadow:none!important;border-radius:0!important}
        .eb-rc-actions {display:none!important}
    }
    </style>
    <div class="eb-rc-dialog" role="dialog" aria-modal="true" aria-label="Appointment receipt">
        <div class="eb-rc-sheet"><asp:Literal ID="litReceipt" runat="server" /></div>
        <div class="eb-rc-actions">
            <asp:Label ID="lblReceiptEmail" runat="server" CssClass="eb-rc-note" />
            <asp:Label ID="lblReceiptMessage" runat="server" CssClass="eb-rc-msg" EnableViewState="false" />
            <div class="eb-rc-buttons">
                <button type="button" class="eb-rc-btn" onclick="window.print()">Print</button>
                <asp:Button ID="btnEmailReceipt" runat="server" Text="Email it to me" CssClass="eb-rc-btn primary" CausesValidation="false" OnClick="btnEmailReceipt_Click" />
                <asp:Button ID="btnCloseReceipt" runat="server" Text="Close" CssClass="eb-rc-btn" CausesValidation="false" OnClick="btnCloseReceipt_Click" />
            </div>
        </div>
    </div>
</asp:Panel>
