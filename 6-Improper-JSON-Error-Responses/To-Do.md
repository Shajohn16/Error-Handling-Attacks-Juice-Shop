📁 Error-Handling-Attacks-Juice-Shop/6-Improper-JSON-Error-Responses/TO-DO.md

markdown
Copy
Edit
# ✅ TO-DO – 6: Improper JSON Error Responses

This document outlines the methodology for exploiting server-side JSON parsing vulnerabilities through **malformed**, **incomplete**, or **inconsistent JSON inputs**, and analyzing how the application responds when strict validation is missing. These tests help identify parsing libraries, backend technology, and potential stack traces that are valuable for further exploitation and recon.

---

## 🎯 Objective

To trigger and analyze improper JSON error responses by submitting payloads that violate JSON format, field types, and structure expectations, allowing attackers to observe:

- Error leakage
- Stack trace exposure
- Response inconsistency
- Underlying framework behavior

---

## 📋 Step-by-Step Attack Workflow

| Task                                                                 | Status |
|----------------------------------------------------------------------|--------|
| 🚀 Launch Juice Shop via Docker                                     | ☐      |
| 🔎 Identify API endpoints that require JSON payloads                | ☐      |
| 💉 Craft malformed JSON payloads with incorrect structure or types  | ☐      |
| 📡 Send crafted payloads using `curl`, Postman, or Burp Suite       | ☐      |
| 🧾 Document all response data, including headers and body           | ☐      |
| 🔍 Analyze stack traces, error codes, and validation logic          | ☐      |
| 🧠 Classify output by framework inference, exposed files/functions  | ☐      |
| 📁 Store logs, headers, and screenshots for report                  | ☐      |

---

## 💣 Suggested Payloads for Exploitation

### 🔸 Malformed JSON (Missing Closing Brace)

```bash
curl -X POST http://localhost:3000/rest/user/login \
-H "Content-Type: application/json" \
-d '{"email": "admin@juice-sh.op", "password": "admin123"'
🧪 Expected:

HTTP/1.1 400 or 500

SyntaxError: Unexpected end of JSON input

Stack trace pointing to internal JSON parsing library

🔸 Wrong Data Type (Type Mismatch)
bash
Copy
Edit
curl -X POST http://localhost:3000/rest/feedback \
-H "Content-Type: application/json" \
-d '{"comment": 404, "rating": "Excellent"}'
🧪 Expected:

JSON parsing error due to type mismatch

Exposure of ORM or schema validation logic in stack trace

🔸 Invalid JSON Syntax (Comma Error)
bash
Copy
Edit
curl -X POST http://localhost:3000/rest/user/login \
-H "Content-Type: application/json" \
-d '{"email": "foo@bar.com",, "password": "123"}'
🧪 Expected:

HTTP/1.1 400 Bad Request

JavaScript SyntaxError, possibly revealing line/column info

🔸 Empty Body with JSON Header
bash
Copy
Edit
curl -X POST http://localhost:3000/rest/user/login \
-H "Content-Type: application/json" \
-d ''
🧪 Expected:

Parser may throw: Unexpected end of input

Improper exception handling may return full stack trace

📄 Expected Output
Header / Field	Observed Outcome
HTTP/1.1 400/500	Error due to malformed input
X-Powered-By: Express	Reveals underlying tech stack (Node.js, Express)
Content-Type: application/json	JSON response with stack/error dump
stack	Leaked stack trace with handler references
message	May leak developer debug strings

📂 Artifacts to Save
File	Description
malformed_payloads.json	All test payloads with labels
curl_malformed_response.log	Terminal output showing stack traces
headers_output.txt	Captured HTTP response headers
screenshots/devtools_stacktrace.png	Screenshot of response in DevTools
parser_behavior_notes.md	Summary of parsing and error response

🧠 Post-Execution Analysis
Does the app differentiate between 400 Bad Request vs. 500 Internal Server Error?

Are stack traces shown to end users?

Can input fuzzing generate parser DoS?

Do different endpoints behave inconsistently?

🧭 OffSec and Pentest Application
Domain	Gained Insight
Web App Pentesting	Input handling flaws and parser behavior
API Security Testing	JSON contract inconsistency detection
Reconnaissance	Framework and version fingerprinting
Exploit Development	Fuzzing chains for crash or RCE discovery

🧬 Bonus Tips
Use -v with curl to capture raw headers.

Fuzz with tools like JSON-Fuzzer or blab for high-volume testing.

Try non-JSON content with application/json header to observe fallback behavior.
