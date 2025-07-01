📁 Error-Handling-Attacks-Juice-Shop/6-Improper-JSON-Error-Responses/Read-Me.md

markdown
Copy
Edit
# 🔥 6 – Improper JSON Error Responses

> 📂 Path: `Error-Handling-Attacks-Juice-Shop/6-Improper-JSON-Error-Responses/`

---

## ⚔️ Description

Improper JSON error responses occur when the server fails to validate or sanitize malformed JSON requests and responds with **verbose, inconsistent, or unintended output**. These behaviors commonly result from:

- Uncaught exceptions in the JSON parser
- Unvalidated `Content-Type` headers
- Logic that assumes perfect JSON formatting
- Deserialization errors with stack leaks

Attackers exploit these issues to:
- Identify parsing mechanisms (e.g., `body-parser`, `express.json`)
- Leak file paths, handler names, or stack data
- Trigger Denial-of-Service (DoS) via JSON bombs
- Detect inconsistencies in API consumption logic

This type of vulnerability aligns with **OWASP API Top 10** issues:
- **API6: Unrestricted Access to Sensitive Error Messages**
- **API10: Unsafe Consumption of APIs**

---

## 🧠 Deep Technical PoC

### 🎯 Objective

Craft and submit malformed JSON payloads to observe how the server reacts. Capture parsing errors, stack traces, internal validations, or non-standard fallback responses.

---

### 🛠️ Tools Used

| Tool           | Use Case                                          |
|----------------|---------------------------------------------------|
| 🧰 Burp Suite  | Modify request bodies, tamper with JSON formatting|
| 🧪 curl/Postman| Direct malformed API requests                     |
| 🧱 DevTools    | Observe frontend-to-API request mappings          |
| 🧬 JSON Fuzzer | Optional for mass malformed input generation      |

---

### 🧪 Step-by-Step Walkthrough

#### 1️⃣ Start the Juice Shop

```bash
docker run --rm -p 3000:3000 bkimminich/juice-shop
Visit:

arduino
Copy
Edit
http://localhost:3000
2️⃣ Pick a Target Endpoint
Choose endpoints expecting well-formed JSON payloads:

POST /rest/user/login

POST /rest/feedback

POST /rest/products/search

3️⃣ Send Malformed or Invalid JSON
🔸 Example A – Broken Format
bash
Copy
Edit
curl -X POST http://localhost:3000/rest/user/login \
-H "Content-Type: application/json" \
-d '{"email": "admin@juice-sh.op", "password": "admin123"'
🧪 Expected:

HTTP 400 or 500

JSON parsing error

Possible SyntaxError, Unexpected end of JSON input

🔸 Example B – Wrong Data Types
bash
Copy
Edit
curl -X POST http://localhost:3000/rest/feedback \
-H "Content-Type: application/json" \
-d '{"comment": 404, "rating": "Excellent"}'
🧪 Expected:

Type mismatch errors

Stack traces exposing validator or ORM methods

🔸 Example C – Empty Payload with JSON Header
bash
Copy
Edit
curl -X POST http://localhost:3000/rest/feedback \
-H "Content-Type: application/json" \
-d ''
🧪 Expected:

400 Bad Request

JSON parser error: Unexpected end of input

🧠 Internal Analysis
What Might Be Exposed?
Element Leaked	Offensive Value
Stack trace in response body	File names, handler functions, line numbers
JSON deserialization error	Parsing engine or library in use
Misconfigured Content-Type	Reveal fallback behaviors (text/html)
Error handler inconsistency	Improperly handled logic for invalid input

🚩 Hacker Insight
Recon Enabled by This
Detect backend parsing libraries (e.g., body-parser, fastify, koa)

Infer backend language (Node.js vs Python vs Java)

Map critical deserialization chains

Bypass input validation if JSON schema is inconsistent

🧨 Real-World CVEs & Examples
CVE-2017-16137 – body-parser DoS via malformed payload

CVE-2022-23529 – Prototype pollution in JSON parsers

AWS API Gateway – Used to disclose schema when JSON decoding fails

💣 Exploit Demo Video
🎥 (Add link here) – Show malformed JSON causing stack trace in /rest/feedback using Burp or curl.

🛡️ Mitigation Strategies
Strategy	Description
🧱 Strict JSON schema validation	Enforce expected types and required fields
🔐 Centralized error handling	Remove stack trace and log internally only
🛑 JSON parser hardening	Set body size limit, catch all malformed JSON
🚫 Disable stack traces in prod	Avoid leaking internal function references

Express middleware example:

js
Copy
Edit
app.use(express.json({
  strict: true,
  limit: '1kb' // prevent JSON bombs
}));

app.use((err, req, res, next) => {
  res.status(400).json({ message: 'Bad JSON input.' });
});
🧭 OffSec Classification
Domain	Benefit
Red Teaming	Input surface discovery and DoS probe
Web Pentesting	Input validation weakness detection
Exploit Dev	Potential chain into parser RCE
API Security Review	Improper error exposure + weak parsing

📂 Suggested Artifacts
File	Description
malformed_json_payloads.json	JSON inputs used to break parser
curl_responses_feedback.log	Raw HTTP output from target endpoint
stacktrace_feedback.txt	Captured stack traces from error
headers_comparison.md	Notes on content-type and error behavior

👨‍💻 Author
Shajohn16
API Fuzzer | OffSec Researcher | JSON Parser Breaker
GitHub: @Shajohn16

