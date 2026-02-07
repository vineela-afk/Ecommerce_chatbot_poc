
package com.example.commerce;

import com.example.commerce.kafka.RequestProducer;
import io.github.resilience4j.circuitbreaker.annotation.CircuitBreaker;
import io.github.resilience4j.retry.annotation.Retry;
import org.springframework.web.bind.annotation.*;
import java.util.*;

@RestController
@RequestMapping("/api/products")
public class ProductController {

    private final RequestProducer producer;

    public ProductController(RequestProducer producer) {
        this.producer = producer;
    }

    @PostMapping("/recommend")
    @Retry(name="aiService")
    @CircuitBreaker(name="aiService", fallbackMethod="fallback")
    public Map<String,String> recommend(@RequestBody Map<String,String> body) {

        String query = body.get("query");
        producer.send(query);

        Map<String,String> res = new HashMap<>();
        res.put("status", "sent to AI service via Kafka");
        return res;
    }

    public Map<String,String> fallback(Map<String,String> body, Throwable t) {
        Map<String,String> res = new HashMap<>();
        res.put("status", "fallback response due to AI failure");
        return res;
    }
}
