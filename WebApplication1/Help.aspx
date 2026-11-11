<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Help.aspx.cs" Inherits="WebApplication1.Help" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <style>
        :root {
            --ob-deep-forest: #122818; --ob-primary-green: #1E3A2F; --ob-accent-mint: #2E8B57;
            --ob-light-mint: #E8F5E9; --ob-card-border: #D1E7DD; --text-dark: #1A1A1A; --text-muted: #4A5568;
        }
        .portal-container { max-width: 1200px; margin: 0 auto; padding: 20px 15px 70px 15px; font-family: 'Segoe UI', System-UI, sans-serif; }
        .hero-banner { background: linear-gradient(135deg, var(--ob-deep-forest) 0%, var(--ob-primary-green) 50%, var(--ob-accent-mint) 100%); color: #ffffff; padding: 48px; border-radius: 12px; margin-bottom: 30px; }
        .hero-banner h1 { font-size: 2.2rem; margin-bottom: 12px; font-weight: 700; }
        .hero-banner p { font-size: 1.05rem; opacity: 0.9; line-height: 1.6; }
        .help-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(320px, 1fr)); gap: 24px; margin-bottom: 40px; }
        .help-card { background: #ffffff; border: 1px solid var(--ob-card-border); border-radius: 10px; padding: 25px; transition: transform 0.2s ease; }
        .help-card:hover { transform: translateY(-3px); box-shadow: 0 10px 20px rgba(30, 58, 47, 0.08); }
        .help-card h3 { color: var(--ob-primary-green); font-size: 1.25rem; margin-bottom: 12px; font-weight: 600; }
        .help-card p, .help-card ul { color: var(--text-muted); font-size: 0.95rem; line-height: 1.6; }
        .onboarding-section { background: #ffffff; border: 1px solid var(--ob-card-border); border-radius: 10px; padding: 35px; margin-bottom: 40px; }
        .onboarding-section h2 { color: var(--ob-deep-forest); font-size: 1.4rem; margin-bottom: 8px; }
        
        /* --- UPDATED STEP CARDS CSS --- */
        .steps-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 20px; margin-top: 25px; }
        .step-card { background: var(--ob-light-mint); padding: 30px 20px; border-radius: 8px; border-bottom: 4px solid var(--ob-accent-mint); text-align: center; transition: transform 0.2s ease, box-shadow 0.2s ease; }
        .step-card:hover { transform: translateY(-4px); box-shadow: 0 8px 15px rgba(30, 58, 47, 0.08); }
        .step-number { display: flex; align-items: center; justify-content: center; background: var(--ob-primary-green); color: white; width: 36px; height: 36px; border-radius: 50%; font-weight: bold; font-size: 1.1rem; margin: 0 auto 15px auto; }
        .step-card h4 { color: var(--ob-primary-green); font-size: 1.1rem; margin-bottom: 10px; font-weight: 600; }
        .step-card p { color: var(--text-muted); font-size: 0.92rem; line-height: 1.5; margin: 0; }
        /* ------------------------------ */

        .support-dock { position: fixed; bottom: 30px; right: 30px; display: flex; align-items: center; gap: 12px; z-index: 1000; }
        .corner-chip { background: #ffffff; color: var(--ob-primary-green); border: 1px solid var(--ob-card-border); padding: 10px 18px; border-radius: 30px; font-weight: 600; cursor: pointer; display: flex; align-items: center; gap: 8px; }
        .corner-chip:hover { background: var(--ob-light-mint); border-color: var(--ob-accent-mint); transform: translateY(-2px); }
        .chat-toggle { width: 56px; height: 56px; background: var(--ob-primary-green); color: #ffffff; border: none; border-radius: 50%; font-size: 1.5rem; cursor: pointer; transition: all 0.3s ease; }
        .chat-toggle:hover { transform: scale(1.08); background: var(--ob-accent-mint); }
        .chat-container { position: fixed; bottom: 100px; right: 30px; width: 380px; height: 520px; background: #ffffff; border-radius: 16px; box-shadow: 0 15px 40px rgba(0,0,0,0.15); display: none; flex-direction: column; overflow: hidden; z-index: 1000; border: 1px solid var(--ob-card-border); }
        .chat-header { background: var(--ob-primary-green); color: #ffffff; padding: 16px 20px; display: flex; justify-content: space-between; align-items: center; }
        .chat-avatar { font-size: 1.5rem; background: rgba(255,255,255,0.15); width: 38px; height: 38px; border-radius: 50%; display: flex; align-items: center; justify-content: center; margin-right: 12px; }
        .close-btn { background: transparent; border: none; color: #ffffff; font-size: 1.1rem; cursor: pointer; }
        .chat-messages { flex: 1; padding: 20px; overflow-y: auto; background: #fcfdfd; display: flex; flex-direction: column; gap: 12px; }
        .bot-message, .user-message { max-width: 85%; padding: 12px 16px; border-radius: 12px; font-size: 0.92rem; line-height: 1.4; }
        .bot-message { background: #edf2f7; color: var(--text-dark); align-self: flex-start; border-bottom-left-radius: 3px; word-break: break-word; }
        .user-message { background: var(--ob-primary-green); color: #ffffff; align-self: flex-end; border-bottom-right-radius: 3px; }
        .chat-chips { padding: 10px 15px; background: #ffffff; display: flex; gap: 8px; overflow-x: auto; border-top: 1px solid #edf2f7; }
        .chip { background: #f0fdf4; color: var(--ob-accent-mint); border: 1px solid #bbf7d0; padding: 6px 12px; border-radius: 20px; font-size: 0.78rem; cursor: pointer; white-space: nowrap; font-weight: 500; }
        .chat-input-area { padding: 15px; background: #ffffff; display: flex; gap: 10px; border-top: 1px solid #edf2f7; }
        .chat-input-area input { flex: 1; padding: 10px 15px; border: 1px solid var(--ob-card-border); border-radius: 25px; outline: none; }
        .chat-input-area button { background: var(--ob-primary-green); color: #ffffff; border: none; width: 40px; height: 40px; border-radius: 50%; cursor: pointer; }
    </style>

    <div class="portal-container">
        <div class="hero-banner">
            <h1>Public Help & Support Center</h1>
            <p>Welcome to the East Boom Community Health Centre support guide.</p>
        </div>
        <div class="help-grid">
            <div class="help-card">
                <h3>🏥 Patient Portal Registration</h3>
                <p>Registering an account grants you access to view personal medical history.</p>
                <ul><li>Click Register.</li><li>Provide your ID.</li></ul>
            </div>
            <div class="help-card">
                <h3>📅 Appointments</h3>
                <p>Our facility on 541 Boom Street coordinates appointments.</p>
                <ul><li>Bring official ID.</li><li>Arrive 15 mins early.</li></ul>
            </div>
            <div class="help-card">
                <h3>💊 Pharmacy & Prescriptions</h3>
                <p>The on-site dispensary fulfills electronic prescriptions.</p>
                <ul><li>Review active meds online.</li></ul>
            </div>
        </div>

        <!-- --- UPDATED STEP CARDS HTML --- -->
        <div class="onboarding-section">
            <h2>New Patient Step-by-Step Guide</h2>
            <p style="color: var(--text-muted); margin-bottom: 25px;">Follow these four simple steps to get started and manage your healthcare journey online.</p>
            <div class="steps-grid">
                <div class="step-card">
                    <span class="step-number">1</span>
                    <h4>Register</h4>
                    <p>Create your secure account using your South African ID.</p>
                </div>
                <div class="step-card">
                    <span class="step-number">2</span>
                    <h4>Log In</h4>
                    <p>Access your personal patient dashboard securely.</p>
                </div>
                <div class="step-card">
                    <span class="step-number">3</span>
                    <h4>View Vitals</h4>
                    <p>Check upcoming visits, history, and active prescriptions.</p>
                </div>
                <div class="step-card">
                    <span class="step-number">4</span>
                    <h4>Visit Clinic</h4>
                    <p>Arrive at 541 Boom Street 15 minutes before your slot.</p>
                </div>
            </div>
        </div>
        <!-- ------------------------------- -->

        <div id="feedbackContainer" style="display: none; background: #ffffff; border: 1px solid var(--ob-card-border); border-radius: 10px; padding: 30px; margin-bottom: 30px;">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px;">
                <h2 style="color: var(--ob-deep-forest); font-size: 1.4rem; margin: 0;">Submit a Personal Query</h2>
                <button type="button" onclick="toggleFeedbackForm()" style="background: none; border: none; font-size: 1.2rem; cursor: pointer;">✖</button>
            </div>
            <asp:Panel ID="PanelFeedbackForm" runat="server">
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px; margin-bottom: 15px;">
                    <div>
                        <label style="display: block; font-weight: 600; color: var(--ob-primary-green); margin-bottom: 5px; font-size: 0.9rem;">Full Name *</label>
                        <asp:TextBox ID="txtFullName" runat="server" CssClass="form-control" style="width: 100%; padding: 10px; border: 1px solid var(--ob-card-border); border-radius: 6px;"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvFullName" runat="server" ControlToValidate="txtFullName" ErrorMessage="Required." Display="Dynamic" style="color: #c62828; font-size: 0.8rem;" />
                    </div>
                    <div>
                        <label style="display: block; font-weight: 600; color: var(--ob-primary-green); margin-bottom: 5px; font-size: 0.9rem;">Contact *</label>
                        <asp:TextBox ID="txtContact" runat="server" CssClass="form-control" style="width: 100%; padding: 10px; border: 1px solid var(--ob-card-border); border-radius: 6px;"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvContact" runat="server" ControlToValidate="txtContact" ErrorMessage="Required." Display="Dynamic" style="color: #c62828; font-size: 0.8rem;" />
                    </div>
                </div>
                <div style="margin-bottom: 15px;">
                    <label style="display: block; font-weight: 600; color: var(--ob-primary-green); margin-bottom: 5px; font-size: 0.9rem;">Query Type</label>
                    <asp:DropDownList ID="ddlQueryType" runat="server" style="width: 100%; padding: 10px; border: 1px solid var(--ob-card-border); border-radius: 6px;">
                        <asp:ListItem Text="General Patient Inquiry" Value="General" />
                        <asp:ListItem Text="Technical Portal Issue" Value="Technical" />
                    </asp:DropDownList>
                </div>
                <div style="margin-bottom: 20px;">
                    <label style="display: block; font-weight: 600; color: var(--ob-primary-green); margin-bottom: 5px; font-size: 0.9rem;">Message *</label>
                    <asp:TextBox ID="txtMessage" runat="server" TextMode="MultiLine" Rows="4" style="width: 100%; padding: 10px; border: 1px solid var(--ob-card-border); border-radius: 6px;"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvMessage" runat="server" ControlToValidate="txtMessage" ErrorMessage="Required." Display="Dynamic" style="color: #c62828; font-size: 0.8rem;" />
                </div>
                <asp:Button ID="btnSubmitQuery" runat="server" Text="Submit Query" OnClick="btnSubmitQuery_Click" style="background: var(--ob-primary-green); color: white; border: none; padding: 12px 25px; border-radius: 6px; cursor: pointer;" />
            </asp:Panel>
            <asp:Label ID="lblSuccessMessage" runat="server" Visible="false" style="display: block; margin-top: 15px; padding: 12px; background: #e8f5e9; color: #2e8b57; border-radius: 6px;"></asp:Label>
        </div>
    </div>
    <div class="support-dock">
        <button type="button" class="corner-chip" onclick="toggleFeedbackForm()">✉ Submit a query</button>
        <button type="button" class="chat-toggle" onclick="toggleChat()">💬</button>
    </div>
    <div class="chat-container" id="chatContainer">
        <div class="chat-header">
            <div style="display: flex; align-items: center;"><div class="chat-avatar">🤖</div><div><h4 style="margin:0; color: white;">Help Desk</h4><span class="status"><span class="status-dot"></span> Online</span></div></div>
            <button type="button" class="close-btn" onclick="toggleChat()">✖</button>
        </div>
        <div class="chat-messages" id="chatMessages"><div class="bot-message">Hello! How can I assist you today?</div></div>
        <div class="chat-chips">
            <button type="button" class="chip" onclick="sendQuickReply('Book appointment')">Book</button>
            <button type="button" class="chip" onclick="sendQuickReply('Reset password')">Password</button>
        </div>
        <div class="chat-input-area">
            <input type="text" id="userInput" placeholder="Type a message..." onkeypress="handleKeyPress(event)" />
            <button type="button" onclick="sendMessage()">➤</button>
        </div>
    </div>
    <script>
        function openQueryFormFromChat() {
            const chatContainer = document.getElementById('chatContainer');
            if (chatContainer) chatContainer.style.display = 'none';
            const container = document.getElementById('feedbackContainer');
            if (container) { container.style.display = 'block'; container.scrollIntoView({ behavior: 'smooth' }); }
        }
        function toggleFeedbackForm() {
            const container = document.getElementById('feedbackContainer');
            container.style.display = (container.style.display === 'none' || container.style.display === '') ? 'block' : 'none';
            if (container.style.display === 'block') container.scrollIntoView({ behavior: 'smooth' });
        }
    </script>
    <script src="<%= ResolveUrl("~/Hscripts/public-knowledgebase.js") %>"></script>
    <script src="<%= ResolveUrl("~/Hscripts/public-chatbot.js") %>"></script>

</asp:Content>