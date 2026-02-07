
from flask import Flask, request, jsonify

app = Flask(__name__)

@app.route('/recommend', methods=['POST'])
def recommend():
    data = request.json
    query = data.get("query","")
    response = f"[AI Engine] Generated recommendation for: {query}"
    return jsonify({"ai_result": response})

if __name__ == "__main__":
    app.run(port=5000)
