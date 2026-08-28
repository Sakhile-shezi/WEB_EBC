<%@ Page Title="Contact Us" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Contact.aspx.cs" Inherits="WebApplication1.Contact" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <style>
        .contact-wrapper {
            width: 100%;
            max-width: 100%;
            font-family: 'Segoe UI', System-UI, -apple-system, sans-serif;
            color: #222222;
        }

        /* Hero Header */
        .contact-hero {
            background: linear-gradient(135deg, #122820 0%, #1E3A2F 50%, #2E8B57 100%);
            color: #ffffff;
            padding: 40px;
            border-radius: 12px;
            margin-bottom: 30px;
            box-shadow: 0 8px 20px rgba(0,0,0,0.08);
        }

        .contact-hero h1 {
            font-size: 2.3rem;
            font-weight: 700;
            margin-bottom: 10px;
            color: #ffffff;
        }

        .contact-hero p {
            font-size: 1.1rem;
            color: #E8F5E9;
            margin: 0;
        }

        /* Side-by-Side Main Layout Grid */
        .contact-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 30px;
            align-items: start;
        }

        /* Responsive Google Map Wrapper */
        .map-container {
            width: 100%;
            height: 100%;
            min-height: 480px;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
            border: 1px solid #D1E7DD;
        }

        .map-container iframe {
            width: 100%;
            height: 100%;
            min-height: 480px;
            border: 0;
            display: block;
        }

        /* Contact Details Cards Column */
        .details-column {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

        .info-card {
            background: #ffffff;
            padding: 24px;
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.04);
            border: 1px solid #E8F5E9;
            border-left: 5px solid #2E8B57;/*#00A896;*/
        }

        .info-card h3 {
            color: #1E3A2F;
            font-size: 1.25rem;
            margin-top: 0;
            margin-bottom: 12px;
            font-weight: 700;
        }

        .info-card address {
            font-style: normal;
            line-height: 1.6;
            color: #4A5568;
            font-size: 0.95rem;
        }

        .info-card a {
            color: #00A896;
            text-decoration: none;
            font-weight: 600;
        }

        .info-card a:hover {
            text-decoration: underline;
        }

        @media (max-width: 900px) {
            .contact-grid {
                grid-template-columns: 1fr;
            }
            .map-container iframe {
                height: 350px;
                min-height: 350px;
            }
            .contact-hero {
                padding: 30px 20px;
            }
        }
    </style>

    <main class="contact-wrapper" aria-labelledby="title">
        
        <!-- Header -->
        <div class="contact-hero">
            <h1 id="title">Contact Us</h1>
            <p>We are committed to providing quality healthcare services to the Pietermaritzburg community.</p>
        </div>

        <!-- Main Content Grid: Map + Contact Info -->
        <div class="contact-grid">
            
            <!-- Embedded Google Map -->
            <div class="map-container">
                <iframe 
                    src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3469.509278690973!2d30.383773176291495!3d-29.588878175156182!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x1ef6bc86d3023c99%3A0x7ae9b4633cbba5bb!2sEast%20Boom%20Community%20Health%20Centre!5e0!3m2!1sen!2sza!4v1787252484055!5m2!1sen!2sza" 
                    allowfullscreen="" 
                    loading="lazy" 
                    referrerpolicy="strict-origin-when-cross-origin">
                </iframe>
            </div>

            <!-- Contact Details Cards -->
            <div class="details-column">
                
                <div class="info-card">
                    <h3>Facility Address</h3>
                    <address>
                        <strong>East Boom Community Health Centre</strong><br />
                        541 Boom Street<br />
                        Pietermaritzburg<br />
                        3201<br />
                        KwaZulu-Natal
                    </address>
                </div>

                <div class="info-card">
                    <h3>Hours of Operation</h3>
                    <address>
                        <strong>Monday - Friday:</strong> 07:00 AM - 16:30 PM<br />
                        <strong>Saturday:</strong> 08:00 AM - 14:00 PM<br />
                        <strong>Sunday:</strong> Closed
                    </address>
                </div>

                <div class="info-card">
                    <h3>Direct Inquiries</h3>
                    <address>
                        <strong>Phone:</strong> (033) 394 1234<br />
                        <strong>Email:</strong> <a href="mailto:nosipho.dlamini@kznhealth.gov.za">nosipho.dlamini@kznhealth.gov.za</a>
                    </address>
                </div>

            </div>

        </div>

    </main>

</asp:Content>
