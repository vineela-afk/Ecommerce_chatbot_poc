
from kafka import KafkaConsumer, KafkaProducer
import json

consumer = KafkaConsumer(
    'chat_requests',
    bootstrap_servers='localhost:9092',
    value_deserializer=lambda x: json.loads(x.decode('utf-8'))
)

producer = KafkaProducer(
    bootstrap_servers='localhost:9092',
    value_serializer=lambda x: json.dumps(x).encode('utf-8')
)

for message in consumer:
    data = message.value
    session_id = data["sessionId"]
    question = data["input"]

    answer = f"AI Response for: {question}"

    result = {
        "sessionId": session_id,
        "answer": answer
    }

    producer.send("chat_responses", result)
    print("Processed:", session_id)
# This code sets up a Kafka consumer that listens to the 'chat_requests' topic for incoming chat messages. When a message is received, it processes the input and generates a response. The response is then sent back to the 'chat_responses' topic.