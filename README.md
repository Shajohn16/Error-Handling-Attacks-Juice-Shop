# Juice Shop - Error Handling Vulnerability

## 📌 Challenge Overview
**Challenge:** Provoke an error that is neither very gracefully nor consistently handled.

This project demonstrates the identification and exploitation of poor error handling in OWASP Juice Shop.

## ⚙️ Steps to Reproduce

1. **Start OWASP Juice Shop**
   - Run via Docker:
     ```bash
     docker run -d -p 3000:3000 bkimminich/juice-shop
     ```

2. **Open the application**
   - Navigate to: http://localhost:3000

3. **Provoke an error**
   - Example: Append a non-existent path like `/thiswillfail` to the URL.
   - Or submit malformed data in form fields.

4. **Observe**
   - Uncaught errors, stack traces, or verbose responses that could reveal implementation details.

## 🧠 Key Learnings
- Improper error handling exposes server internals.
- Helps attackers understand app structure.

## 🛡️ Mitigation
- Implement proper error handling middleware.
- Avoid exposing stack traces or debug messages in production.

## 📷 Proof
![Error Message Screenshot](./error-screenshot.png)

