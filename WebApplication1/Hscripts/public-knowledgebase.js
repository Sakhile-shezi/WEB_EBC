// ==========================================
// East Boom CHC - Public Knowledge Base
// ==========================================

window.publicChatbotData = [
    // --- 1. CLINIC HOURS & LOCATION ---
    {
        keywords: ["hours", "open", "opening", "closing", "close", "time", "times"],
        answer: "Our central Pietermaritzburg clinic is open Monday to Friday from 8:00 AM to 4:30 PM, and our Acute & Emergency unit operates 24/7.",
        detailedAnswer: "East Boom Community Health Centre is open for general consultations and routine visits Monday to Friday from 8:00 AM to 4:30 PM. Our Acute & Emergency unit remains open 24 hours a day, 7 days a week."
    },
    {
        keywords: ["where", "location", "address", "directions", "situated", "find clinic", "boom street"],
        answer: "East Boom Community Health Centre is located at 541 Boom Street, Pietermaritzburg.",
        detailedAnswer: "East Boom Community Health Centre is located at 541 Boom Street, Pietermaritzburg. If you have a scheduled appointment, please arrive 15 minutes early for initial vitals screening."
    },

    // --- 2. EMERGENCY & URGENT CARE ---
    {
        keywords: ["emergency", "urgent", "casualty", "acute", "trauma", "ambulance", "bleeding"],
        answer: "⚠️ For medical emergencies, proceed immediately to our 24/7 Acute & Emergency unit at 541 Boom Street.",
        detailedAnswer: "⚠️ If you are experiencing a medical emergency, please proceed immediately to our 24/7 Acute & Emergency unit at 541 Boom Street or call emergency services. No prior appointment is required for urgent care."
    },

    // --- 3. PATIENT PORTAL REGISTRATION ---
    {
        keywords: ["register", "registration", "new patient", "sign up", "create account", "create an account"],
        answer: "Click 'Register' at the top right of the page and enter your South African ID and contact details.",
        detailedAnswer: "New patients can create an online account by clicking the 'Register' button in the top navigation bar. You will need a valid South African ID number and your current contact details to complete registration."
    },

    // --- 4. LOGIN & PASSWORD RESET ---
    {
        keywords: ["password", "reset", "forgot", "login", "log in", "locked", "access account"],
        answer: "Click 'Forgot Password' on the login screen and enter your South African ID to reset your password.",
        detailedAnswer: "If you cannot log in or forgot your password, click 'Forgot Password' on the login screen and enter your South African ID number. Follow the instructions sent to your registered contact details to regain access."
    },

    // --- 5. APPOINTMENTS & BOOKING ---
    {
        keywords: ["book", "booking", "appointment", "appointments", "schedule", "visit", "consultation", "reschedule", "cancel"],
        answer: "Log in to your patient portal and select 'Appointments', or visit reception at 541 Boom Street with your ID.",
        detailedAnswer: "To book, reschedule, or check an appointment, log in to your patient dashboard and open the 'Appointments' section. You can also book in person at our reception desk at 541 Boom Street—just bring your official South African ID and arrive 15 minutes early."
    },

    // --- 6. PHARMACY & PRESCRIPTIONS ---
    {
        keywords: ["pharmacy", "medication", "medications", "meds", "prescription", "prescriptions", "script", "scripts", "dispensary"],
        answer: "Our on-site EBCHC Pharmacy fulfills electronic prescriptions—check your active meds on your dashboard.",
        detailedAnswer: "Our on-site dispensary fulfills electronic prescriptions issued by East Boom CHC practitioners. You can review your active medications and digital prescriptions on your patient dashboard before collecting them at the pharmacy."
    },

    // --- 7. VITALS & MEDICAL RECORDS ---
    {
        keywords: ["vitals", "records", "medical history", "history", "notes", "results", "folder"],
        answer: "Log in to your personal dashboard to view your recorded vitals, visit history, and prescriptions.",
        detailedAnswer: "Once logged in, your patient dashboard gives you secure access to your recorded vitals, past clinic visits, and active electronic prescriptions."
    }
];

// Separate polite/greeting entries so real questions always take priority in long sentences
window.publicGreetingsData = [
    {
        keywords: ["hi", "hello", "hey", "greetings", "morning", "afternoon", "evening", "sawubona"],
        answer: "Hello! Welcome to the East Boom CHC Help Desk. How can I assist you today?",
        detailedAnswer: "Hello! Welcome to the East Boom Community Health Centre virtual assistant. Feel free to ask me about booking appointments, clinic hours, portal registration, password resets, or pharmacy services."
    },
    {
        keywords: ["how are you", "how are you doing", "what's up"],
        answer: "I'm doing great, thank you! How can I help you with the East Boom CHC portal today?",
        detailedAnswer: "I am doing great, thank you for asking! I'm ready to help you navigate the East Boom CHC patient portal, check clinic hours, or guide you through booking an appointment."
    },
    {
        keywords: ["who are you", "what are you", "your name"],
        answer: "I am the East Boom CHC virtual assistant, here to help patients navigate our online portal and clinic services.",
        detailedAnswer: "I am the East Boom Community Health Centre virtual assistant. I can guide you through patient registration, password resets, appointment booking, pharmacy prescriptions, and clinic operating hours."
    },
    {
        keywords: ["thank", "thanks", "thank you", "ngiyabonga"],
        answer: "You're very welcome! Let me know if you need anything else.",
        detailedAnswer: "You're very welcome! If you have any other questions about East Boom CHC or your patient portal, feel free to ask anytime."
    }
];

const fallbackResponse = "I'm sorry, I didn't quite catch that. Try asking about appointments, clinic hours, registration, password resets, or pharmacy services—or visit our front desk at 541 Boom Street.";
window.fallbackResponse = fallbackResponse;

// Helper to match whole words/phrases cleanly inside long sentences
function matchesKeyword(text, keyword) {
    const escaped = keyword.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
    const regex = new RegExp(`\\b${escaped}\\b`, 'i');
    return regex.test(text);
}

// Main bot response handler (called by public-chatbot.js)
function getPublicBotResponse(userMessage) {
    const userText = userMessage.toLowerCase().trim();
    const isLongSentence = userText.split(/\s+/).length >= 5;
    let matchedReplies = [];

    // 1. Scan all main portal topics first
    for (let item of window.publicChatbotData) {
        for (let keyword of item.keywords) {
            if (matchesKeyword(userText, keyword)) {
                const reply = (isLongSentence && item.detailedAnswer) ? item.detailedAnswer : item.answer;
                if (!matchedReplies.includes(reply)) {
                    matchedReplies.push(reply);
                }
                break; // Move to next topic once this topic matches
            }
        }
    }

    if (matchedReplies.length > 0) {
        return matchedReplies.join("<br><br>");
    }

    // 2. Check greetings/polite phrases if no specific topic was asked
    for (let item of window.publicGreetingsData) {
        for (let keyword of item.keywords) {
            if (matchesKeyword(userText, keyword)) {
                return (isLongSentence && item.detailedAnswer) ? item.detailedAnswer : item.answer;
            }
        }
    }

    // 3. Default fallback
    return window.fallbackResponse;
}