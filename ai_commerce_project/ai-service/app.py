
from flask import Flask, request, jsonify
import os
from src.utils.chatbot_utils import BuildChatbot
from src.utils.logger import logging
from src.utils.exception import Custom_exception

from flask import Flask, request, render_template, jsonify


# initializing flask app
app = Flask(__name__)

# setting up the chatbot(retriever)
utils = BuildChatbot()
chatbot = utils.initialize_chatbot()



# route for home page
@app.route('/')
def home():
    return render_template('home_page.html')


@app.route('/recommend', methods=['POST'])
def recommend():
    data = request.json
    query = data.get("query","")
    response = f"[AI Engine] Generated recommendation for: {query}"
    return jsonify({"ai_result": response})

@app.route('/chat', methods=["GET", "POST"])
def chat():
    try:
        data = request.get_json() or {}
        question = data.get('input', '')
        logging.info(f"User Input: {question}")

        if chatbot is None:
            logging.error("Chatbot is not initialized.")
            return jsonify({"error": "chatbot not initialized"}), 500

        config = {"configurable": {"session_id": "chat_1"}}

        response = chatbot.invoke({"input": question}, config=config)
        answer = response.get('answer') if isinstance(response, dict) else str(response)

        logging.info(f"Chatbot Response: {answer}")
        return jsonify({"response": answer})
    except Exception as e:
        logging.exception("Error in /chat endpoint")
        return jsonify({"error": str(e)}), 500


@app.route('/health', methods=['GET'])
def health():
    return jsonify({"status": "ok"})



if __name__ == "__main__":
    # for local development 
    # app.run(debug=True, use_reloader=False)

    # for production, port should match with inbound rule of ec2 instance
    app.run(host='0.0.0.0', port=8000, debug=True)


