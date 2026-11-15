<%@ Page Title="Help & Support - East Boom CHC" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Help.aspx.cs" Inherits="WebApplication1.Help" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <style>
        :root {
            --ob-deep-forest: #122818;
            --ob-primary-green: #1E3A2F;
            --ob-accent-mint: #2E8B57;
            --ob-light-mint: #E8F5E9;
            --ob-soft-bg: #F8FBF9;
            --ob-card-border: #D1E7DD;
            --text-dark: #1A202C;
            --text-muted: #4A5568;
        }

        .portal-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 24px 15px 80px 15px;
            font-family: 'Segoe UI', System-UI, -apple-system, sans-serif;
            color: var(--text-dark);
        }

        /* --- HERO BANNER --- */
        .hero-banner {
            background: linear-gradient(135deg, var(--ob-deep-forest) 0%, var(--ob-primary-green) 55%, var(--ob-accent-mint) 100%);
            color: #ffffff;
            padding: 44px 48px;
            border-radius: 16px;
            margin-bottom: 32px;
            box-shadow: 0 12px 30px rgba(18, 40, 24, 0.14);
            position: relative;
            overflow: hidden;
        }
        .eb-hero-pill {
            display: inline-block;
            background: rgba(255, 255, 255, 0.14);
            border: 1px solid rgba(255, 255, 255, 0.25);
            color: #E8F5E9;
            font-size: 0.75rem;
            font-weight: 700;
            letter-spacing: 0.08em;
            text-transform: uppercase;
            padding: 6px 14px;
            border-radius: 20px;
            margin-bottom: 16px;
        }
        .hero-banner h1 {
            font-size: 2.25rem;
            margin: 0 0 12px 0;
            font-weight: 700;
            letter-spacing: -0.02em;
            color: #ffffff;
        }
        .hero-banner p {
            font-size: 1.05rem;
            opacity: 0.92;
            line-height: 1.6;
            max-width: 720px;
            margin: 0 0 24px 0;
        }
        .eb-quick-meta {
            display: flex;
            flex-wrap: wrap;
            gap: 12px;
        }
        .eb-meta-pill {
            background: rgba(18, 40, 24, 0.45);
            border: 1px solid rgba(255, 255, 255, 0.18);
            padding: 8px 16px;
            border-radius: 8px;
            font-size: 0.88rem;
            color: #ffffff;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        /* --- TOP 3 HELP CARDS --- */
        .help-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(310px, 1fr));
            gap: 24px;
            margin-bottom: 36px;
        }
        .help-card {
            background: #ffffff;
            border: 1px solid var(--ob-card-border);
            border-radius: 14px;
            padding: 28px;
            transition: transform 0.22s ease, box-shadow 0.22s ease, border-color 0.22s ease;
            display: flex;
            flex-direction: column;
        }
        .help-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 12px 24px rgba(30, 58, 47, 0.09);
            border-color: var(--ob-accent-mint);
        }
        .eb-card-icon {
            width: 48px;
            height: 48px;
            background: var(--ob-light-mint);
            color: var(--ob-primary-green);
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.4rem;
            margin-bottom: 18px;
        }
        .help-card h3 {
            color: var(--ob-primary-green);
            font-size: 1.22rem;
            margin: 0 0 10px 0;
            font-weight: 700;
        }
        .help-card p {
            color: var(--text-muted);
            font-size: 0.95rem;
            line-height: 1.6;
            margin: 0 0 16px 0;
        }
        .eb-check-list {
            list-style: none;
            padding: 0;
            margin: auto 0 0 0;
            border-top: 1px solid #EDF2F7;
            padding-top: 14px;
        }
        .eb-check-list li {
            position: relative;
            padding-left: 22px;
            color: var(--text-dark);
            font-size: 0.9rem;
            margin-bottom: 8px;
            line-height: 1.45;
        }
        .eb-check-list li:last-child {
            margin-bottom: 0;
        }
        .eb-check-list li::before {
            content: "✓";
            position: absolute;
            left: 0;
            top: 0;
            color: var(--ob-accent-mint);
            font-weight: 700;
        }

        /* --- STEP-BY-STEP ONBOARDING SECTION --- */
        .onboarding-section {
            background: #ffffff;
            border: 1px solid var(--ob-card-border);
            border-radius: 14px;
            padding: 36px;
            margin-bottom: 36px;
            box-shadow: 0 4px 14px rgba(0, 0, 0, 0.02);
        }
        .eb-section-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-end;
            flex-wrap: wrap;
            gap: 10px;
            margin-bottom: 28px;
        }
        .eb-section-header h2 {
            color: var(--ob-deep-forest);
            font-size: 1.45rem;
            font-weight: 700;
            margin: 0 0 6px 0;
        }
        .eb-section-header p {
            color: var(--text-muted);
            font-size: 0.95rem;
            margin: 0;
        }
        .steps-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 20px;
        }
        .step-card {
            background: var(--ob-soft-bg);
            border: 1px solid var(--ob-card-border);
            border-bottom: 4px solid var(--ob-accent-mint);
            padding: 28px 20px;
            border-radius: 12px;
            text-align: center;
            position: relative;
            transition: transform 0.2s ease, background-color 0.2s ease, box-shadow 0.2s ease;
        }
        .step-card:hover {
            transform: translateY(-4px);
            background: var(--ob-light-mint);
            box-shadow: 0 10px 20px rgba(30, 58, 47, 0.08);
        }
        .step-number {
            display: flex;
            align-items: center;
            justify-content: center;
            background: var(--ob-primary-green);
            color: #ffffff;
            width: 38px;
            height: 38px;
            border-radius: 50%;
            font-weight: 700;
            font-size: 1.05rem;
            margin: 0 auto 16px auto;
            box-shadow: 0 4px 10px rgba(30, 58, 47, 0.2);
        }
        .step-card h4 {
            color: var(--ob-primary-green);
            font-size: 1.08rem;
            margin: 0 0 8px 0;
            font-weight: 700;
        }
        .step-card p {
            color: var(--text-muted);
            font-size: 0.9rem;
            line-height: 1.5;
            margin: 0;
        }

        /* --- COLLAPSIBLE FAQ SECTION --- */
        .eb-faq-section {
            background: #ffffff;
            border: 1px solid var(--ob-card-border);
            border-radius: 14px;
            padding: 36px;
        }
        .eb-faq-list {
            display: flex;
            flex-direction: column;
            gap: 12px;
        }
        .eb-faq-item {
            border: 1px solid var(--ob-card-border);
            border-radius: 10px;
            overflow: hidden;
            background: #ffffff;
        }
        .eb-faq-question {
            width: 100%;
            background: var(--ob-soft-bg);
            border: none;
            padding: 16px 20px;
            text-align: left;
            font-size: 0.98rem;
            font-weight: 600;
            color: var(--ob-primary-green);
            cursor: pointer;
            display: flex;
            justify-content: space-between;
            align-items: center;
            transition: background 0.2s ease;
        }
        .eb-faq-question:hover {
            background: var(--ob-light-mint);
        }
        .eb-faq-chevron {
            font-size: 0.85rem;
            transition: transform 0.25s ease;
            color: var(--ob-accent-mint);
        }
        .eb-faq-item.open .eb-faq-chevron {
            transform: rotate(180deg);
        }
        .eb-faq-answer {
            display: none;
            padding: 16px 20px;
            color: var(--text-muted);
            font-size: 0.94rem;
            line-height: 1.6;
            border-top: 1px solid #EDF2F7;
            background: #ffffff;
        }
        .eb-faq-item.open .eb-faq-answer {
            display: block;
        }

        /* --- FLOATING CHATBOT WIDGET --- */
        .support-dock {
            position: fixed;
            bottom: 28px;
            right: 28px;
            z-index: 1000;
            display: flex;
            align-items: center;
            gap: 12px;
        }
        .eb-chat-label {
            background: #ffffff;
            color: var(--ob-primary-green);
            border: 1px solid var(--ob-card-border);
            padding: 8px 16px;
            border-radius: 24px;
            font-size: 0.88rem;
            font-weight: 600;
            box-shadow: 0 6px 18px rgba(18, 40, 24, 0.12);
            cursor: pointer;
            transition: transform 0.2s ease, background 0.2s ease;
        }
        .eb-chat-label:hover {
            background: var(--ob-light-mint);
            transform: translateY(-2px);
        }
        .chat-toggle {
            width: 58px;
            height: 58px;
            background: linear-gradient(135deg, var(--ob-primary-green), var(--ob-accent-mint));
            color: #ffffff;
            border: none;
            border-radius: 50%;
            font-size: 1.5rem;
            cursor: pointer;
            transition: transform 0.25s ease, box-shadow 0.25s ease;
            box-shadow: 0 8px 22px rgba(30, 58, 47, 0.32);
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .chat-toggle:hover {
            transform: scale(1.07);
            box-shadow: 0 10px 26px rgba(46, 139, 87, 0.4);
        }

        .chat-container {
            position: fixed;
            bottom: 98px;
            right: 28px;
            width: 380px;
            height: 520px;
            background: #ffffff;
            border-radius: 16px;
            box-shadow: 0 18px 45px rgba(18, 40, 24, 0.2);
            display: none;
            flex-direction: column;
            overflow: hidden;
            z-index: 1000;
            border: 1px solid var(--ob-card-border);
        }
        .chat-header {
            background: linear-gradient(135deg, var(--ob-deep-forest), var(--ob-primary-green));
            color: #ffffff;
            padding: 16px 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .chat-avatar {
            font-size: 1.4rem;
            background: rgba(255, 255, 255, 0.16);
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 12px;
        }
        .status {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            font-size: 0.8rem;
            color: #D1E7DD;
        }
        .status-dot {
            width: 8px;
            height: 8px;
            background-color: #4ADE80;
            border-radius: 50%;
            display: inline-block;
            box-shadow: 0 0 6px #4ADE80;
        }
        .close-btn {
            background: rgba(255, 255, 255, 0.12);
            border: none;
            color: #ffffff;
            width: 30px;
            height: 30px;
            border-radius: 50%;
            font-size: 0.95rem;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .close-btn:hover {
            background: rgba(255, 255, 255, 0.25);
        }
        .chat-messages {
            flex: 1;
            padding: 18px;
            overflow-y: auto;
            background: #F9FBFB;
            display: flex;
            flex-direction: column;
            gap: 12px;
        }
        .bot-message, .user-message {
            max-width: 85%;
            padding: 12px 16px;
            border-radius: 14px;
            font-size: 0.92rem;
            line-height: 1.45;
            overflow-wrap: break-word;
            word-wrap: break-word;
        }
        .bot-message {
            background: #ffffff;
            border: 1px solid #E2E8F0;
            color: var(--text-dark);
            align-self: flex-start;
            border-bottom-left-radius: 4px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.03);
        }
        .user-message {
            background: var(--ob-primary-green);
            color: #ffffff;
            align-self: flex-end;
            border-bottom-right-radius: 4px;
        }
        .chat-chips {
            padding: 10px 14px;
            background: #ffffff;
            display: flex;
            gap: 8px;
            overflow-x: auto;
            border-top: 1px solid #EDF2F7;
        }
        .chip {
            background: #F0FDF4;
            color: var(--ob-primary-green);
            border: 1px solid #BBF7D0;
            padding: 6px 13px;
            border-radius: 20px;
            font-size: 0.8rem;
            cursor: pointer;
            white-space: nowrap;
            font-weight: 600;
            transition: background 0.15s ease;
        }
        .chip:hover {
            background: #DCFCE7;
        }
        .chat-input-area {
            padding: 12px 14px;
            background: #ffffff;
            display: flex;
            align-items: flex-end;
            gap: 10px;
            border-top: 1px solid #EDF2F7;
        }
        .chat-input-area textarea {
            flex: 1;
            padding: 10px 14px;
            border: 1px solid var(--ob-card-border);
            border-radius: 20px;
            outline: none;
            resize: none;
            font-family: inherit;
            font-size: 0.92rem;
            line-height: 1.4;
            max-height: 100px;
            overflow-y: auto;
        }
        .chat-input-area textarea:focus {
            border-color: var(--ob-accent-mint);
        }
        .chat-input-area button {
            background: var(--ob-primary-green);
            color: #ffffff;
            border: none;
            width: 40px;
            height: 40px;
            border-radius: 50%;
            cursor: pointer;
            flex-shrink: 0;
            transition: background 0.2s ease;
        }
        .chat-input-area button:hover {
            background: var(--ob-accent-mint);
        }

        /* --- RESPONSIVE ADJUSTMENTS --- */
        @media (max-width: 992px) {
            .steps-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }
        @media (max-width: 600px) {
            .hero-banner {
                padding: 32px 24px;
            }
            .hero-banner h1 {
                font-size: 1.75rem;
            }
            .steps-grid {
                grid-template-columns: 1fr;
            }
            .chat-container {
                width: calc(100vw - 32px);
                right: 16px;
                bottom: 92px;
                height: 460px;
            }
            .eb-chat-label {
                display: none;
            }
        }
    </style>

    <div class="portal-container">
        <!-- HERO BANNER -->
        <div class="hero-banner">
            <span class="eb-hero-pill">Pietermaritzburg Patient Support</span>
            <h1>Public Help &amp; Support Center</h1>
            <p>Everything you need to register on the East Boom Community Health Centre portal, manage appointments, and prepare for your clinic visit.</p>
            <div class="eb-quick-meta">
                <span class="eb-meta-pill">📍 541 Boom Street, Pietermaritzburg</span>
                <span class="eb-meta-pill">🕒 Routine Care: Mon–Fri, 08:00–16:30</span>
                <span class="eb-meta-pill">🚨 Acute &amp; Emergency: Open 24/7</span>
            </div>
        </div>

        <!-- CORE SERVICE CARDS -->
        <div class="help-grid">
            <div class="help-card">
                <div class="eb-card-icon">🏥</div>
                <h3>Patient Portal Registration</h3>
                <p>Create a secure digital profile to access your personal medical records, vitals, and upcoming bookings.</p>
                <ul class="eb-check-list">
                    <li>Click <strong>Register</strong> in the top navigation bar</li>
                    <li>Enter your valid South African ID number</li>
                    <li>Verify your current mobile or email contact</li>
                </ul>
            </div>

            <div class="help-card">
                <div class="eb-card-icon">📅</div>
                <h3>Appointments &amp; Visits</h3>
                <p>Schedule routine consultations online or check in directly at our main reception desk on Boom Street.</p>
                <ul class="eb-check-list">
                    <li>Bring your official South African ID or passport</li>
                    <li>Arrive 15 minutes early for vitals screening</li>
                    <li>No appointment needed for 24/7 emergencies</li>
                </ul>
            </div>

            <div class="help-card">
                <div class="eb-card-icon">💊</div>
                <h3>Pharmacy &amp; Prescriptions</h3>
                <p>Our on-site EBCHC dispensary fulfills electronic scripts issued during your clinical consultation.</p>
                <ul class="eb-check-list">
                    <li>View active prescriptions on your dashboard</li>
                    <li>Present your ID at the dispensary window</li>
                    <li>Check dosage instructions anytime online</li>
                </ul>
            </div>
        </div>

        <!-- STEP-BY-STEP GUIDE -->
        <div class="onboarding-section">
            <div class="eb-section-header">
                <div>
                    <h2>New Patient Step-by-Step Guide</h2>
                    <p>Follow these four simple steps to set up your account and manage your care online.</p>
                </div>
            </div>
            <div class="steps-grid">
                <div class="step-card">
                    <span class="step-number">1</span>
                    <h4>Register</h4>
                    <p>Create your secure patient account using your South African ID.</p>
                </div>
                <div class="step-card">
                    <span class="step-number">2</span>
                    <h4>Log In</h4>
                    <p>Sign in to access your personal patient portal dashboard.</p>
                </div>
                <div class="step-card">
                    <span class="step-number">3</span>
                    <h4>View Vitals</h4>
                    <p>Review your visit history, recorded vitals, and active scripts.</p>
                </div>
                <div class="step-card">
                    <span class="step-number">4</span>
                    <h4>Visit Clinic</h4>
                    <p>Arrive at 541 Boom Street 15 minutes before your slot.</p>
                </div>
            </div>
        </div>

        <!-- QUICK FAQ ACCORDION -->
        <div class="eb-faq-section">
            <div class="eb-section-header">
                <div>
                    <h2>Frequently Asked Questions</h2>
                    <p>Click a question below for quick answers, or ask our virtual assistant in the bottom right.</p>
                </div>
            </div>
            <div class="eb-faq-list">
                <div class="eb-faq-item">
                    <button type="button" class="eb-faq-question" onclick="toggleFaq(this)">
                        <span>What documents do I need to bring to my clinic appointment?</span>
                        <span class="eb-faq-chevron">▼</span>
                    </button>
                    <div class="eb-faq-answer">
                        Please bring your official South African ID book, Smart ID card, or valid passport, along with any referral letters or current chronic medication containers if you are visiting for a follow-up.
                    </div>
                </div>
                <div class="eb-faq-item">
                    <button type="button" class="eb-faq-question" onclick="toggleFaq(this)">
                        <span>I forgot my patient portal password. How do I reset it?</span>
                        <span class="eb-faq-chevron">▼</span>
                    </button>
                    <div class="eb-faq-answer">
                        Click <strong>Log in</strong> at the top right of the page, select <strong>Forgot Password</strong>, and enter your South African ID number to receive password recovery instructions.
                    </div>
                </div>
                <div class="eb-faq-item">
                    <button type="button" class="eb-faq-question" onclick="toggleFaq(this)">
                        <span>Do I need an appointment for urgent medical care?</span>
                        <span class="eb-faq-chevron">▼</span>
                    </button>
                    <div class="eb-faq-answer">
                        No. Our Acute &amp; Emergency unit at 541 Boom Street operates 24 hours a day, 7 days a week. Proceed directly to emergency triage upon arrival.
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- FLOATING CHAT DOCK -->
    <div class="support-dock">
        <span class="eb-chat-label" onclick="toggleChat()">Need help? Ask our assistant</span>
        <button type="button" class="chat-toggle" onclick="toggleChat()" title="Open Help Desk">💬</button>
    </div>

    <!-- CHATBOT WINDOW -->
    <div class="chat-container" id="chatContainer">
        <div class="chat-header">
            <div style="display: flex; align-items: center;">
                <div class="chat-avatar">🤖</div>
                <div>
                    <h4 style="margin:0; font-size: 1.05rem; font-weight: 600; color: #ffffff;">EBCHC Help Desk</h4>
                    <span class="status"><span class="status-dot"></span> Online</span>
                </div>
            </div>
            <button type="button" class="close-btn" onclick="toggleChat()" title="Close Chat">✖</button>
        </div>
        <div class="chat-messages" id="chatMessages">
            <div class="bot-message">Hello! Welcome to the East Boom CHC Help Desk. Ask me a question or pick a quick topic below.</div>
        </div>
        <div class="chat-chips">
            <button type="button" class="chip" onclick="sendQuickReply('Book appointment')">Book</button>
            <button type="button" class="chip" onclick="sendQuickReply('Clinic hours')">Hours</button>
            <button type="button" class="chip" onclick="sendQuickReply('Pharmacy prescriptions')">Pharmacy</button>
            <button type="button" class="chip" onclick="sendQuickReply('Reset password')">Password</button>
        </div>
        <div class="chat-input-area">
            <textarea id="userInput" rows="1" placeholder="Type your question or sentence..." oninput="autoResizeInput(this)" onkeydown="handleKeyDown(event)"></textarea>
            <button type="button" onclick="sendMessage()" title="Send Message">➤</button>
        </div>
    </div>

    <script>
        function toggleFaq(button) {
            const item = button.parentElement;
            item.classList.toggle('open');
        }
    </script>
    <script src="<%= ResolveUrl("~/Hscripts/public-knowledgebase.js?v=6") %>"></script>
    <script src="<%= ResolveUrl("~/Hscripts/public-chatbot.js?v=6") %>"></script>

</asp:Content>