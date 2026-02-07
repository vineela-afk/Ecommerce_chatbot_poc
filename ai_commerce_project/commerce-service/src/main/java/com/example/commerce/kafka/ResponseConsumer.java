
package com.example.commerce.kafka;

import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Service;

@Service
public class ResponseConsumer {

    @KafkaListener(topics = "ai-responses", groupId = "commerce")
    public void listen(String message) {
        System.out.println("Received AI Response: " + message);
    }
}
