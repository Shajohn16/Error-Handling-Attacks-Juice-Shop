Juice Shop - Error Handling Vulnerability
📌 Challenge Overview
Challenge: Provoke an error that is neither very gracefully nor consistently handled.

This project demonstrates the identification and exploitation of poor error handling in OWASP Juice Shop.

⚙️ Steps to Reproduce
Start OWASP Juice Shop

Run via Docker:
docker run -d -p 3000:3000 bkimminich/juice-shop
Open the application

Navigate to: http://localhost:3000
Provoke an error

Example: Append a non-existent path like /thiswillfail to the URL.
Or submit malformed data in form fields.
Observe

Uncaught errors, stack traces, or verbose responses that could reveal implementation details.
🧠 Key Learnings
Improper error handling exposes server internals.
Helps attackers understand app structure.
🛡️ Mitigation
Implement proper error handling middleware.
Avoid exposing stack traces or debug messages in production.
📷 Proof
Error Message Screenshot
