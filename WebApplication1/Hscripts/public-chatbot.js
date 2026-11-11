function toggleChat() {
    const chatContainer = document.getElementById('chatContainer');
    if (chatContainer.style.display === 'flex') {
        chatContainer.style.display = 'none';
    } else {
        chatContainer.style.display = 'flex';
        document.getElementById('userInput').focus();
    }
}
function handleKeyPress(event) { if (event.key === 'Enter') sendMessage(); }
function sendQuickReply(text) { appendMessage(text, 'user-message'); processBotResponse(text); }
function sendMessage() {
    const inputField = document.getElementById('userInput');
    const messageText = inputField.value.trim();
    if (messageText === '') return;
    appendMessage(messageText, 'user-message');
    inputField.value = '';
    processBotResponse(messageText);
}
function processBotResponse(userMessage) {
    let botReply = getPublicBotResponse(userMessage);
    if (!botReply) {
        botReply = "I'm sorry, I didn't quite catch that. Try clicking one of the quick-reply chips below or submit a direct query using the button below:<br><br>" +
            "<button type='button' onclick='openQueryFormFromChat()' style='background: #1E3A2F; color: #ffffff; border: none; padding: 10px 16px; border-radius: 20px; font-weight: 600; cursor: pointer; font-size: 0.85rem; box-shadow: 0 2px 5px rgba(0,0,0,0.1); display: inline-flex; align-items: center; gap: 6px;'>" +
            "✉ Submit a query</button>";
    }
    setTimeout(() => { appendMessage(botReply, 'bot-message'); }, 400);
}
function appendMessage(text, className) {
    const chatMessages = document.getElementById('chatMessages');
    const messageDiv = document.createElement('div');
    messageDiv.className = className;
    if (className === 'bot-message') { messageDiv.innerHTML = text; }
    else { messageDiv.textContent = text; }
    chatMessages.appendChild(messageDiv);
    chatMessages.scrollTop = chatMessages.scrollHeight;
}