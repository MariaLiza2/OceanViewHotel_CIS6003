package com.oceanview.service;

public class BillingService {

    public double calculateBill(String roomType) {
        switch (roomType) {
            case "Single": return 5000;
            case "Double": return 8000;
            case "Suite": return 15000;
            default: return 0;
        }
    }
}
