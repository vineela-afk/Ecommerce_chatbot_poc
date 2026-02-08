package com.ecommerce.controller;

import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/inventory")
public class InventoryController {

    @GetMapping("/{productId}")
    public String check(@PathVariable String productId) {
        return "Inventory available for " + productId;
    }
}
