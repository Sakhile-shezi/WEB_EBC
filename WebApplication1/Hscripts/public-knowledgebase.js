function getPublicBotResponse(userMessage) {
    let msg = userMessage.toLowerCase();
    if (msg.includes('book') || msg.includes('appointment')) return "To book an appointment, please log in to your patient portal and click on 'Appointments', or visit our front desk at 541 Boom Street.";
    if (msg.includes('password') || msg.includes('reset')) return "You can reset your password by clicking 'Forgot Password' on the login screen and entering your South African ID.";
    if (msg.includes('hours') || msg.includes('time') || msg.includes('open')) return "Our central Pietermaritzburg clinic is open Monday to Friday from 8:00 AM to 4:30 PM. Emergency services operate 24/7.";
    if (msg.includes('new patient') || msg.includes('register') || msg.includes('account')) return "New patients can register by clicking the 'Register' button at the top right of the page and entering a valid South African ID.";
    return null;
}