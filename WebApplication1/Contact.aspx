<%@ Page Title="Contact" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Contact.aspx.cs" Inherits="WebApplication1.Contact" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <main aria-labelledby="title">
        <h2>Contact Us</h2>
        <p>
            We are committed to providing quality heaalthcare services to the Pietermaritzburg community
        </p>
        "<iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3469.509278690973!2d30.383773176291495!3d-29.588878175156182!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x1ef6bc86d3023c99%3A0x7ae9b4633cbba5bb!2sEast%20Boom%20Community%20Health%20Centre!5e0!3m2!1sen!2sza!4v1787252484055!5m2!1sen!2sza"
            width="600" 
            height="450" 
            style="border:0;" 
            allowfullscreen="" 
            loading="lazy" 
            referrerpolicy="strict-origin-when-cross-origin"></iframe>"
        <address>
            <strong>East Boom Community Health Centre</strong><br />
            541 Boom Street<br/>
            Pietermaritzburg<br />
            3201<br />
            KwaZulu-Natal<br /><br />
            <abbr title="Phone">Phone Number: </abbr> (033) 394 1234<br />
        </address>
        <address>
            <strong>Hours of Operation:</strong><br />
            Monday - Friday: 07:00 AM - 16:30 PM<br />
            Saturday: 08:00 AM - 14:00 PM<br />
            Sunday: Closed
        </address>
        <address>
            <strong>Email:</strong>   <a href="mailto:nosipho.dlamini@kznhealth.gov.za">nosipho.dlamini@kznhealth.gov.za</a><br />
        </address>
    </main>
</asp:Content>
