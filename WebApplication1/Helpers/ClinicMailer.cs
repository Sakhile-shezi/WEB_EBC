using System;
using System.Configuration;
using System.Net.Configuration;
using System.Net.Mail;

namespace WebApplication1.Helpers
{
    // One place for every email the site sends (verification links, receipts).
    // The mail server details live in Web.config under system.net/mailSettings.
    public static class ClinicMailer
    {
        // True once the placeholder values in Web.config have been replaced.
        public static bool IsConfigured
        {
            get
            {
                var smtp = ConfigurationManager.GetSection("system.net/mailSettings/smtp") as SmtpSection;
                if (smtp == null || smtp.Network == null)
                    return false;

                string host = smtp.Network.Host;
                string from = smtp.From;
                string password = smtp.Network.Password;

                if (string.IsNullOrWhiteSpace(host) || string.IsNullOrWhiteSpace(from))
                    return false;

                return !IsPlaceholder(from) && !IsPlaceholder(host) && !IsPlaceholder(password);
            }
        }

        private static bool IsPlaceholder(string value)
        {
            return value != null &&
                   value.IndexOf("YOUR-", StringComparison.OrdinalIgnoreCase) >= 0;
        }

        // Format check only: one well-formed address, nothing else on the line.
        public static bool IsValidAddress(string email)
        {
            if (string.IsNullOrWhiteSpace(email))
                return false;

            email = email.Trim();
            if (email.IndexOfAny(new[] { ' ', ',', ';', '\r', '\n' }) >= 0)
                return false;

            try
            {
                var address = new MailAddress(email);
                return string.Equals(address.Address, email, StringComparison.OrdinalIgnoreCase) &&
                       address.Host.IndexOf('.') > 0;
            }
            catch (FormatException)
            {
                return false;
            }
        }

        // Sends one HTML email. Throws if the server rejects it, so callers can report failure.
        public static void Send(string to, string subject, string htmlBody)
        {
            if (!IsConfigured)
                throw new InvalidOperationException("Mail settings are not configured in Web.config.");
            if (!IsValidAddress(to))
                throw new FormatException("The recipient email address is not valid.");

            using (var message = new MailMessage())
            using (var client = new SmtpClient())   // host, port, login and From come from Web.config
            {
                message.To.Add(new MailAddress(to.Trim()));
                message.Subject = subject ?? "";
                message.Body = htmlBody ?? "";
                message.IsBodyHtml = true;
                client.Send(message);
            }
        }
    }
}
