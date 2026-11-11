// ==========================================
// East Boom CHC - Public Chatbot UI Logic
// ==========================================

function toggleChat() {
    const chatContainer = document.getElementById('chatContainer');
    if (!chatContainer) return;

    if (chatContainer.style.display === 'flex') {
        chatContainer.style.display = 'none';
    } else {
        chatContainer.style.display = 'flex';
        const inputField = document.getElementById('userInput');
        if (inputField) inputField.focus();
    }
}

function handleKeyPress(event) {
    if (event.key === 'Enter') {
        sendMessage();
    }
}

function sendQuickReply(text) {
    appendMessage(text, 'user-message');
    processBotResponse(text);
}

function sendMessage() {
    const inputField = document.getElementById('userInput');
    if (!inputField) return;

    const messageText = inputField.value.trim();
    if (messageText === '') return;

    appendMessage(messageText, 'user-message');
    inputField.value = '';

    processBotResponse(messageText);
}

function processBotResponse(userMessage) {
    // Calls getPublicBotResponse from public-knowledgebase.js
    let botReply = typeof getPublicBotResponse === 'function' ? getPublicBotResponse(userMessage) : null;

    if (!botReply) {
        botReply = "I'm sorry, I didn't quite catch that. Try clicking one of the quick-reply chips above, or visit our front desk at 541 Boom Street for direct assistance.";
    }

    setTimeout(() => {
        appendMessage(botReply, 'bot-message');
    }, 400);
}

function appendMessage(text, className) {
    const chatMessages = document.getElementById('chatMessages');
    if (!chatMessages) return;

    const messageDiv = document.createElement('div');
    messageDiv.className = className;

    if (className === 'bot-message') {
        messageDiv.innerHTML = text;
    } else {
        messageDiv.textContent = text;
    }

    chatMessages.appendChild(messageDiv);
    chatMessages.scrollTop = chatMessages.scrollHeight;
}