✅ TO-DO.md:

📁 Error-Handling-Attacks-Juice-Shop/5-API-Error-Leakage/TO-DO.md

markdown
Copy
Edit
# ✅ TO-DO – 5: API Error Leakage

This to-do document outlines a structured exploitation methodology focused on triggering improperly handled API-level exceptions in OWASP Juice Shop. These errors can be highly valuable for recon, schema inference, and crafting future payloads for enumeration or injection attacks.

---

## 🎯 Objective

Induce malformed, incomplete, or logically inconsistent requests to REST API endpoints to provoke verbose server-side error responses. Capture and analyze these to understand internal validation logic, controller mapping, backend technologies, and schema contracts.

---

## 📋 Attack Workflow Checklist

| Task                                                                 | Status |
|----------------------------------------------------------------------|--------|
| 🚀 Start Juice Shop locally via Docker                               | ☐      |
| 🛠 Identify exposed API endpoints (via frontend or DevTools)         | ☐      |
| 💉 Craft malformed/missing/invalid JSON payloads                     | ☐      |
| 🔄 Send API requests using curl, Postman, or Burp                    | ☐      |
| 📡 Observe API response behavior                                     | ☐      |
| 📜 Capture server-provided error messages, stack traces, and headers| ☐      |
| 🧠 Identify and document schema leaks and file references            | ☐      |
| 🧾 Store malformed payloads and corresponding outputs                | ☐      |
| 🔁 Fuzz further variations on input structure and method types       | ☐      |

---

## 💣 Suggested Test Payloads

### 🔸 Missing Fields (Trigger Internal Null Exception)
```bash
curl -X POST http://localhost:3000/rest/user/login \
-H "Content-Type: application/json" \
-d '{"email": "admin@juice-sh.op"}'
Expected:

500 Internal Server Error

"Cannot read property 'match' of undefined"

Possibly stack trace revealing function, line number, or route handler

🔸 Invalid JSON Format
bash
Copy
Edit
curl -X POST http://localhost:3000/rest/feedback \
-H "Content-Type: application/json" \
-d '{"comment": "hello" "rating": 5}'
Expected:

HTTP parse failure

400 Bad Request or unhandled JSON parser exception

May result in malformed response with raw server error string

🔸 Invalid Data Type or Structure
bash
Copy
Edit
curl -X POST http://localhost:3000/rest/feedback \
-H "Content-Type: application/json" \
-d '{"comment": ["unexpected", "array"], "rating": true}'
Expected:

Type mismatch exception

Stack traces indicating validator or ORM handler breakdown

🔸 Wrong HTTP Method on API
bash
Copy
Edit
curl -X PUT http://localhost:3000/rest/products/search -v
Expected:

405 Method Not Allowed

Headers may disclose routing logic, e.g., Allow: POST

🧾 Expected Output Elements
Field / Header	Description
X-Powered-By: Express	Backend framework fingerprint
"stack":	Stack trace, function names, internal logic
"error":	Developer message, usually unfiltered
Content-Type	Response type (HTML/JSON) format indicator
Allow:	Leaked supported HTTP methods

🔍 Headers and Metadata to Capture
All response headers

Raw JSON body

HTTP status code

If applicable, cookies or session tokens returned on failed call

📁 Output Storage Suggestions
Artifact File	Purpose
api_error_responses.json	Captured API responses with verbose output
curl_outputs/api_login_fail.log	Terminal dump of login endpoint error leakage
headers_snapshot.txt	Full response headers for comparison
api_malformed_payloads.json	Payloads used to trigger schema exceptions
screenshots/	DevTools/Burp UI captures of raw API output

🧠 Post-Attack Analysis Points
Can field structure or DB schema be reverse-engineered?

Does stack trace expose internal method names or route files?

Are HTTP headers misconfigured to disclose Express or Node?

Is the error handling centralized and sanitized or inconsistent?

🧭 Related OffSec Domains
Discipline	Objective Gained
API Security Testing	Analyze schema, validation, error exposure
Web Application Pentesting	Understand how API handles malformed inputs
Reconnaissance	Map backend structure and control flow
AppSec Research	Identify API surface not covered by frontend

📌 Note: Always test multiple content types (application/json, text/plain) and edge-case HTTP verbs (TRACE, OPTIONS) for unexpected results or debug outputs.
