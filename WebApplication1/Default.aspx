<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master"
    AutoEventWireup="true" CodeBehind="Default.aspx.cs"
    Inherits="WebApplication1._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <main>

        <div style="background-color:#1B6035;
                    color:white;
                    padding:35px;
                    border-radius:10px;
                    margin-top:50px;
                    margin-bottom:275px;
                    text-align:center;">

            <h1>East Boom Community Health Centre</h1>

            <h3>Clinic Management Portal</h3>

            <p>
                Improving healthcare delivery through secure patient
                registration, appointment scheduling and clinical
                management services.
            </p>
            <!--
            <p>
                <a href="/Account/Login.aspx" class="btn btn-light btn-lg">

                    Access Portal
                </a>
                
            </p> -->
        </div>

        <div class="row">

            <div class="col-md-4">

                <h3>Patients</h3>

                <p>
                    Access healthcare services more efficiently through
                    appointment scheduling and patient management features.
                </p>

            </div>

            <div class="col-md-4">

                <h3>Healthcare Staff</h3>

                <p>
                    Doctors, nurses and administrators can securely
                    manage appointments, patient records and clinical
                    information.
                </p>

            </div>

            <div class="col-md-4">

                <h3>Secure & Reliable</h3>

                <p>
                    Built to support accurate record keeping, improved
                    service delivery and secure access to patient
                    information.
                </p>

            </div>

        </div>

        <hr />

        <div class="row">

            <div class="col-md-6">

                <h3>Learn More About Us</h3>

                <p>
                    Discover our mission, healthcare services and how
                    East Boom Community Health Centre supports the local
                    community.
                </p>

                <p>
                    <a href="About.aspx">
                        About the Clinic
                    </a>
                </p>

            </div>

            <div class="col-md-6">

                <h3>Need Assistance?</h3>

                <p>
                    View our location, contact details and operating
                    hours for additional support.
                </p>

            </div>

        </div>
<div style="
    width:100%;
    background-color:#1B6035;
    color:white;
    padding:80px 20px;
    margin-top:50px;
    margin-bottom:175px;
    text-align:center;">
    
    <h2>Book Your Healthcare Journey With Us</h2>

    <p style="font-size:18px; max-width:700px; margin:20px auto;">
        East Boom Community Health Centre is committed to providing
        accessible, professional and patient-centred healthcare services
        to the Pietermaritzburg community.
    </p>

    <a href="/Account/Login.aspx"> <!--class="btn btn-light btn-lg"-->
        Access Portal
    </a>

</div>
    </main>

</asp:Content>
