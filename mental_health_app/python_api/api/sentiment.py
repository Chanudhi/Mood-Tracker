from flask import Flask, request, jsonify
from transformers import pipeline

app = Flask(__name__)
model = pipeline("sentiment-analysis", model="distilbert-base-uncased-finetuned-sst-2-english")

@app.route('/analyze', methods=['POST'])
def analyze():
    try:
        data = request.get_json()
        text = data.get('text', '')
        if not text:
            return jsonify({"error": "No text provided"}), 400
        
        result = model(text)[0]
        return jsonify({
            "sentiment": result['label'],
            "confidence": result['score']
        })
    except Exception as e:
        return jsonify({"error": str(e)}), 500