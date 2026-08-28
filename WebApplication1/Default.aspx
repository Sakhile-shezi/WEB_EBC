<%@ Page Title="East Boom CHC - Pietermaritzburg" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="WebApplication1._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <style>
        /* Design System for East Boom CHC */
        :root {
            --eb-deep-forest: #122820;
            --eb-primary-green: #1E3A2F;
            --eb-accent-mint: #2E8B57;
            --eb-teal: #2E8B57; /*#00A896;*/
            --eb-light-mint: #E8F5E9;
            --eb-warm-bg: #F4F7F5;
            --eb-card-border: #D1E7DD;
            --text-dark: #1A1A1A;
            --text-muted: #4A5568;
        }

        .portal-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 10px 15px 40px 15px;
            font-family: 'Segoe UI', System-UI, -apple-system, sans-serif;
        }

        /* Hero Banner with Medical Branding Grid */
        .hero-banner {
            background: linear-gradient(135deg, var(--eb-deep-forest) 0%, var(--eb-primary-green) 50%, var(--eb-accent-mint) 100%);
            color: #ffffff;
            padding: 48px 40px;
            border-radius: 12px;
            margin-bottom: 30px;
            box-shadow: 0 10px 25px rgba(18, 40, 32, 0.15);
            position: relative;
            overflow: hidden;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .hero-banner::after {
            content: "";
            position: absolute;
            right: -50px;
            bottom: -50px;
            width: 300px;
            height: 300px;
            background: rgba(255, 255, 255, 0.03);
            border-radius: 50%;
            pointer-events: none;
        }

        .hero-content {
            max-width: 680px;
            z-index: 2;
        }

        .hero-badge {
            background-color: rgba(255, 255, 255, 0.15);
            color: #ffffff;
            padding: 6px 14px;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 600;
            letter-spacing: 0.5px;
            display: inline-block;
            margin-bottom: 12px;
            text-transform: uppercase;
        }

        .hero-banner h1 {
            font-size: 2.4rem;
            line-height: 1.2;
            margin-bottom: 14px;
            color: #ffffff;
            font-weight: 700;
        }

        .hero-banner p {
            font-size: 1.1rem;
            color: var(--eb-light-mint);
            margin-bottom: 24px;
            line-height: 1.6;
        }

        .hero-actions {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
        }

        /* Stat Counter Bar */
        .clinic-stats-bar {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 15px;
            margin-bottom: 35px;
        }

        .stat-card {
            background: #ffffff;
            border: 1px solid var(--eb-card-border);
            border-left: 5px solid var(--eb-teal);
            padding: 16px 20px;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.03);
        }

        .stat-card strong {
            display: block;
            font-size: 1.3rem;
            color: var(--eb-primary-green);
        }

        .stat-card span {
            font-size: 0.85rem;
            color: var(--text-muted);
        }

        /* Visual Typography Titles */
        .section-header {
            margin: 35px 0 18px 0;
            border-bottom: 2px solid var(--eb-card-border);
            padding-bottom: 8px;
            display: flex;
            justify-content: space-between;
            align-items: flex-end;
        }

        .section-header h2 {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--eb-primary-green);
            margin: 0;
        }

        .section-header span {
            font-size: 0.9rem;
            color: var(--eb-teal);
            font-weight: 600;
        }

        /* Public Care Units Grid */
        .services-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
            gap: 20px;
            margin-bottom: 35px;
        }

        .service-card {
            background: #ffffff;
            border-radius: 10px;
            padding: 22px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.04);
            border: 1px solid var(--eb-warm-bg);
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }

        .service-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.08);
        }

        .service-card .badge-dept {
            font-size: 0.75rem;
            font-weight: 700;
            color: var(--eb-teal);
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .service-card h3 {
            font-size: 1.2rem;
            color: var(--eb-primary-green);
            margin: 8px 0 10px 0;
        }

        .service-card p {
            font-size: 0.9rem;
            color: var(--text-muted);
            line-height: 1.5;
            margin: 0;
        }

        /* Secured Patient Portal Section */
        .portal-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
            gap: 20px;
        }

        .portal-card {
            background: #ffffff;
            padding: 28px;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.06);
            border-top: 5px solid var(--eb-accent-mint);
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }

        .portal-card.highlight {
            border-top-color: var(--eb-teal);
            background: linear-gradient(180deg, #FFFFFF 0%, #FAFCFA 100%);
        }

        .portal-card h3 {
            margin-top: 0;
            color: var(--eb-primary-green);
            font-size: 1.3rem;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .portal-card p {
            color: var(--text-muted);
            font-size: 0.95rem;
            line-height: 1.6;
            margin-top: 10px;
        }

        /* Action Buttons */
        .btn-main {
            display: inline-block;
            padding: 12px 24px;
            background-color: var(--eb-teal);
            color: #ffffff !important;
            text-decoration: none;
            border-radius: 6px;
            font-weight: 600;
            font-size: 0.95rem;
            transition: background-color 0.2s ease, transform 0.1s ease;
            text-align: center;
        }

        .btn-main:hover {
            background-color: #00897B;
            text-decoration: none;
        }

        .btn-outline {
            display: inline-block;
            padding: 12px 24px;
            background-color: transparent;
            color: #ffffff !important;
            border: 2px solid #ffffff;
            text-decoration: none;
            border-radius: 6px;
            font-weight: 600;
            font-size: 0.95rem;
            transition: background-color 0.2s ease, color 0.2s ease;
        }

        .btn-outline:hover {
            background-color: #ffffff;
            color: var(--eb-primary-green) !important;
            text-decoration: none;
        }

        .btn-card {
            align-self: flex-start;
            margin-top: 20px;
            padding: 10px 22px;
            background-color: var(--eb-primary-green);
            color: #ffffff !important;
            text-decoration: none;
            border-radius: 6px;
            font-weight: 600;
            font-size: 0.9rem;
            transition: background-color 0.2s ease;
            width: 100%;
            text-align: center;
        }

        .btn-card:hover {
            background-color: var(--eb-accent-mint);
            text-decoration: none;
        }

        @media (max-width: 768px) {
            .hero-banner { padding: 30px 20px; }
            .hero-banner h1 { font-size: 1.8rem; }
            .hero-actions { flex-direction: column; }
            .btn-main, .btn-outline { width: 100%; text-align: center; }
        }
    </style>

    <div class="portal-container">
        
        <!-- HERO SECTION: Public Healthcare Facing -->
        <section class="hero-banner">
            <div class="hero-content">
                <span class="hero-badge">Pietermaritzburg Health Services</span>
                <h1>East Boom Community Health Centre</h1>
                <p>Providing essential frontline healthcare to the Msunduzi municipality. Streamlining patient registration, acute care routing, and integrated digital health records.</p>
                <div class="hero-actions">
                    <a href="Contact.aspx" class="btn-main">Contact & Clinic Hours</a>
                    <a href="About.aspx" class="btn-outline">About Our Facility</a>
                </div>
            </div>
        </section>

        <!-- LIVE CLINIC METRICS / SERVICES BAR -->
        <div class="clinic-stats-bar">
            <div class="stat-card">
                <strong>541 Boom Street</strong>
                <span>Central Pietermaritzburg Location</span>
            </div>
            <div class="stat-card">
                <strong>24/7 Support</strong>
                <span>Round-the-Clock Emergency Unit</span>
            </div>
            <div class="stat-card">
                <strong>Digital Intake</strong>
                <span>Integrated Patient Records System</span>
            </div>
            <div class="stat-card">
                <strong>Specialized Units</strong>
                <span>Chronic, Acute, Psychology & Male Care</span>
            </div>
        </div>

        <!-- PUBLIC SERVICES OVERVIEW -->
        <div class="section-header">
            <h2>Public Healthcare Services</h2>
            <span>Msunduzi Primary Health Network</span>
        </div>

        <section class="services-grid">
            <div class="service-card">
                <span class="badge-dept">Routine & Monitoring</span>
                <h3>Chronic Care Unit</h3>
                <p>Ongoing support, regular check-ups, and precise vital recording for ongoing conditions like hypertension and diabetes.</p>
            </div>

            <div class="service-card">
                <span class="badge-dept">Urgent Attention</span>
                <h3>Acute & Emergency</h3>
                <p>Immediate triage care and clinical treatment for urgent injury, illness, and continuous 24-hour emergency triage.</p>
            </div>

            <div class="service-card">
                <span class="badge-dept">On-Site Dispensary</span>
                <h3>EBCHC Pharmacy</h3>
                <p>Direct electronic script collection, clear dosage instructions, and efficient, error-free medicine distribution.</p>
            </div>

            <div class="service-card">
                <span class="badge-dept">Dedicated Consultations</span>
                <h3>Specialist Wellness Clinics</h3>
                <p>Confidential services for general family health, psychological support, and the specialized Male Health Clinic.</p>
            </div>
        </section>

        <!-- AUTHENTICATED PATIENT & CLINICAL PORTAL -->
        <div class="section-header">
            <h2>Patient & Clinical Portal Access</h2>
            <span>Authorized User System</span>
        </div>

        <section class="portal-grid">
            <div class="portal-card highlight">
                <div>
                    <h3>Patient Portal</h3>
                    <p>Log in to view upcoming medical visits, verify electronic prescriptions, or review your secure EBCHC health record file.</p>
                </div>
                <asp:HyperLink ID="lnkPatients" runat="server" NavigateUrl="#" CssClass="btn-card">Sign In / View Profile &rarr;</asp:HyperLink>
            </div>

            <div class="portal-card">
                <div>
                    <h3>Doctor & Staff Dashboard</h3>
                    <p>Clinical portal access for medical staff to manage upcoming patient queues, track daily consultations, and review charts.</p>
                </div>
                <asp:HyperLink ID="lnkDashboard" runat="server" NavigateUrl="~/Private/Private2.aspx" CssClass="btn-card">Access Doctor Portal &rarr;</asp:HyperLink>
            </div>

            <div class="portal-card">
                <div>
                    <h3>Prescription Engine</h3>
                    <p>Internal clinical system for authorized medical practitioners to generate digital scripts with safety tracking.</p>
                </div>
                <asp:HyperLink ID="lnkPrescription" runat="server" NavigateUrl="~/Private/Private1.aspx" CssClass="btn-card">Create Digital Script &rarr;</asp:HyperLink>
            </div>
        </section>

    </div>

</asp:Content>