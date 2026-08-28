<%@ Page Title="About Us - East Boom CHC" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="About.aspx.cs" Inherits="WebApplication1.About" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <style>
        .about-wrapper {
            width: 100%;
            max-width: 100%;
            font-family: 'Segoe UI', System-UI, -apple-system, sans-serif;
            color: #222222;
        }

        /* Hero Banner */
        .about-hero {
            background: linear-gradient(135deg, #122820 0%, #1E3A2F 50%, #2E8B57 100%);
            color: #ffffff;
            padding: 48px 40px;
            border-radius: 12px;
            margin-bottom: 30px;
            box-shadow: 0 8px 20px rgba(0,0,0,0.08);
        }

        .about-hero h1 {
            font-size: 2.3rem;
            font-weight: 700;
            margin-bottom: 10px;
            color: #ffffff;
        }

        .about-hero p {
            font-size: 1.15rem;
            color: #E8F5E9;
            margin: 0;
            max-width: 800px;
        }

        /* Layout Grid: Image & Who We Are */
        .about-grid-top {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 30px;
            align-items: center;
            margin-bottom: 35px;
        }

        .about-img-container {
            width: 100%;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            background-color: #F4F7F5;
        }

        .about-img-container img {
            width: 100%;
            height: 100%;
            max-height: 420px;
            object-fit: cover;
            display: block;
        }

        .about-card-primary {
            background: #ffffff;
            padding: 32px;
            border-radius: 12px;
            border: 1px solid #D1E7DD;
            border-left: 6px solid #1E3A2F;
            box-shadow: 0 4px 12px rgba(0,0,0,0.03);
        }

        .about-card-primary h2 {
            color: #1E3A2F;
            font-size: 1.6rem;
            margin-top: 0;
            margin-bottom: 14px;
            font-weight: 700;
        }

        .about-card-primary p {
            color: #4A5568;
            font-size: 1rem;
            line-height: 1.7;
            margin: 0;
        }

        /* Middle Section: Mission & System Grid */
        .about-grid-cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
            gap: 25px;
            margin-bottom: 35px;
        }

        .info-card {
            background: #ffffff;
            padding: 28px;
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.04);
            border: 1px solid #E8F5E9;
            border-top: 4px solid #2E8B57;/*#00A896;*/
        }

        .info-card h3 {
            color: #1E3A2F;
            font-size: 1.3rem;
            margin-top: 0;
            margin-bottom: 12px;
            font-weight: 700;
        }

        .info-card p {
            color: #555555;
            font-size: 0.95rem;
            line-height: 1.65;
            margin: 0;
        }

        /* Services Grid Section */
        .services-section {
            background: #ffffff;
            padding: 32px;
            border-radius: 12px;
            border: 1px solid #D1E7DD;
            box-shadow: 0 4px 12px rgba(0,0,0,0.03);
            margin-bottom: 20px;
        }

        .services-section h3 {
            color: #1E3A2F;
            font-size: 1.4rem;
            margin-top: 0;
            margin-bottom: 18px;
            font-weight: 700;
            border-bottom: 2px solid #E8F5E9;
            padding-bottom: 8px;
        }

        .services-list-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 15px;
            list-style: none;
            padding: 0;
            margin: 0;
        }

        .service-pill {
            background-color: #F4F7F5;
            border-left: 4px solid #2E8B57;
            padding: 14px 18px;
            border-radius: 6px;
            font-weight: 600;
            color: #1E3A2F;
            display: flex;
            align-items: center;
        }

        .service-pill::before {
            content: "✓";
            color: #2E8B57;/*#00A896;*/
            font-weight: bold;
            margin-right: 10px;
            font-size: 1.1rem;
        }

        @media (max-width: 900px) {
            .about-grid-top {
                grid-template-columns: 1fr;
            }
            .about-hero {
                padding: 30px 20px;
            }
        }
    </style>

    <main class="about-wrapper" aria-labelledby="title">
        
        <!-- Hero Header -->
        <div class="about-hero">
            <h1 id="title">East Boom Community Health Centre</h1>
            <p>Providing quality primary healthcare services to the Pietermaritzburg community and surrounding Msunduzi areas.</p>
        </div>

        <!-- Top Section: Photo + Who We Are -->
        <div class="about-grid-top">
            <div class="about-img-container">
                <img src="Images/eastboom.jpg" alt="East Boom Community Health Centre Facility" />
            </div>

            <div class="about-card-primary">
                <h2>Who We Are</h2>
                <p>
                    East Boom Community Health Centre (CHC) is a vital primary healthcare facility located in the heart of Pietermaritzburg, KwaZulu-Natal. The centre provides accessible, routine, and urgent healthcare services to members of the local community, serving an essential role in promoting regional public health and proactive community wellness.
                </p>
            </div>
        </div>

        <!-- Middle Section: Mission & Digital System Info -->
        <div class="about-grid-cards">
            <div class="info-card">
                <h3>Our Mission</h3>
                <p>
                    To deliver efficient, professional, and patient-centred healthcare services while ensuring that every patient receives quality care in a safe, dignified, and supportive environment.
                </p>
            </div>

            <div class="info-card">
                <h3>About This Website</h3>
                <p>
                    This web-based Clinical Management System has been custom-developed for East Boom Community Health Centre to streamline patient registration, appointment management, and electronic record administration—drastically reducing clinic waiting times and boosting service delivery for both patients and clinical staff.
                </p>
            </div>
        </div>

        <!-- Bottom Section: Key Facility Services -->
        <div class="services-section">
            <h3>Key Facility Services</h3>
            <ul class="services-list-grid">
                <li class="service-pill">Patient Registration</li>
                <li class="service-pill">Appointment Scheduling</li>
                <li class="service-pill">Medical Consultations</li>
                <li class="service-pill">Vitals Monitoring</li>
            </ul>
        </div>

    </main>

</asp:Content>