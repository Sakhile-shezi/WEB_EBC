<%@ Page Title="About" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="About.aspx.cs" Inherits="WebApplication1.About" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <main aria-labelledby="title">
 <div style="background-color:#1B6035;
             color:white;
             padding:20px;
             border-radius:10px;
             margin-bottom:20px;">

     <h2 id="title">East Boom Community Health Centre</h2>

     <p>
         Providing quality healthcare services to the Pietermaritzburg community.
     </p>

 </div>

 <img src="Images/eastboom.jpg"
  alt="East Boom Community Health Centre"
  style="width:100%;
         max-width:750px;
         border-radius:10px;
         margin-bottom:20px;" />

 <h3>Who We Are</h3>

 <p>
     East Boom Community Health Centre (CHC) is a primary healthcare
     facility located in Pietermaritzburg, KwaZulu-Natal. The centre
     provides accessible healthcare services to members of the local
     community and plays an important role in promoting public health.
 </p>

 <h3>Our Mission</h3>

 <p>
     Our mission is to deliver efficient, professional and patient-centred
     healthcare services while ensuring that every patient receives quality
     care in a safe and supportive environment.
 </p>

 <h3>Our Services</h3>

 <ul>
     <li>Patient Registration</li>
     <li>Appointment Scheduling</li>
     <li>Medical Consultations</li>
     <li>Vitals Monitoring</li>
 </ul>

 <h3>About This Website</h3>

 <p>
     This web-based Clinical Management System has been developed for
     East Boom Community Health Centre to improve patient registration,
     appointment management and healthcare record administration.
     The system aims to reduce waiting times and improve service delivery
     for both patients and healthcare professionals.
 </p>
    </main>
</asp:Content>
