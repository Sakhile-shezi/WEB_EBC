// ==========================================
// East Boom CHC - Public Knowledge Base (2026 Updated)
// ==========================================

function getPublicBotResponse(userMessage) {
    let msg = userMessage.toLowerCase();

    // 1. Greetings & Etiquette
    if (msg === 'hi' || msg === 'hello' || msg.includes('good morning') || msg.includes('good afternoon')) {
        return "Hello! Welcome to the East Boom Community Health Centre virtual assistant. How can I assist you today?";
    }
    if (msg.includes('thank') || msg.includes('thanks')) {
        return "You're very welcome! Feel free to reach out if you have any other questions.";
    }

    // 2. Appointments & Booking
    if (msg.includes('book') || msg.includes('appointment') || msg.includes('schedule')) {
        return "To book an appointment, please log in to your patient portal and click on 'Appointments', or visit our reception desk at 541 Boom Street. Please bring your official South African ID.";
    }

    // 3. Account & Passwords
    if (msg.includes('password') || msg.includes('reset') || msg.includes('forgot')) {
        return "You can reset your password by clicking 'Forgot Password' on the login screen and entering your South African ID number.";
    }
    if (msg.includes('new patient') || msg.includes('register') || msg.includes('account') || msg.includes('sign up')) {
        return "New patients can register by clicking the 'Register' button at the top right of the page and entering a valid South African ID along with your contact details.";
    }

    // 4. Clinic Hours & Location
    if (msg.includes('hours') || msg.includes('time') || msg.includes('open') || msg.includes('close')) {
        return "Our central Pietermaritzburg clinic is open for general and routine visits Monday to Friday from 8:00 AM to 4:30 PM. Our Acute & Emergency unit is open 24/7.";
    }
    if (msg.includes('where') || msg.includes('location') || msg.includes('address') || msg.includes('directions')) {
        return "East Boom Community Health Centre is located at 541 Boom Street, Pietermaritzburg. Please arrive 15 minutes before any scheduled appointment for initial vitals screening.";
    }

    // 5. Pharmacy & Prescriptions
    if (msg.includes('pharmacy') || msg.includes('medication') || msg.includes('prescription') || msg.includes('script') || msg.includes('dispensary')) {
        return "Our on-site dispensary fulfills electronic prescriptions issued by our practitioners. You can view your active medications and digital script summaries directly through your secure patient portal dashboard.";
    }

    // 6. Emergency & Urgent Care
    if (msg.includes('emergency') || msg.includes('urgent') || msg.includes('casualty') || msg.includes('acute')) {
        return "If you are experiencing a medical emergency, please proceed immediately to our 24/7 Acute & Emergency unit at 541 Boom Street. No booking is required for trauma or urgent medical care.";
    }

    // 7. Medical Records & Vitals
    if (msg.includes('vitals') || msg.includes('records') || msg.includes('history') || msg.includes('notes')) {
        return "You can view your medical history, recent vitals, and scheduled visit notes by logging into your account and opening your personal patient dashboard.";
    }

    // Fallback response if no keywords match
    return null;
}