
package com.example.commerce.kafka;

import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.stereotype.Service;

@Service
public class RequestProducer {
    private final KafkaTemplate<String, String> kafkaTemplate;

    public RequestProducer(KafkaTemplate<String, String> kafkaTemplate) {
        this.kafkaTemplate = kafkaTemplate;
    }

    public void send(String message) {
        kafkaTemplate.send("ai-requests", message);
    }
}
