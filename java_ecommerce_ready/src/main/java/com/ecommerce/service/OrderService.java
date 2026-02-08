package com.ecommerce.service;

import com.ecommerce.model.Order;
import org.springframework.stereotype.Service;
import com.ecommerce.kafka.KafkaProducer;
import com.fasterxml.jackson.databind.ObjectMapper;

@Service
public class OrderService {

    private final KafkaProducer kafkaProducer;
    private final ObjectMapper objectMapper;

    public OrderService(KafkaProducer kafkaProducer, ObjectMapper objectMapper) {
        this.kafkaProducer = kafkaProducer;
        this.objectMapper = objectMapper;
    }

    public Order createOrder(Order order) {
        order.setId("ORD-" + System.currentTimeMillis());
        try {
            String payload = objectMapper.writeValueAsString(order);
            kafkaProducer.send(payload);
        } catch (Exception e) {
            // swallow for now; in real app log properly
        }
        return order;
    }
}
