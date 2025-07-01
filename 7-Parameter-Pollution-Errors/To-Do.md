📁 Error-Handling-Attacks-Juice-Shop/7-Parameter-Pollution-Errors/TO-DO.md

markdown
Copy
Edit
# ✅ TO-DO – 7: Parameter Pollution Errors

This checklist outlines a hands-on exploitation path to trigger and analyze **parameter pollution vulnerabilities** in OWASP Juice Shop. By injecting **duplicate parameters** into GET or POST requests, we aim to confuse backend logic and provoke internal errors, inconsistencies, or even handler-level exceptions. This helps in mapping internal behavior and discovering undocumented flaws.

---

## 🎯 Objective

Exploit backend input parsers and route handlers by introducing **multiple identical keys** in query strings, form data, or JSON bodies. The goal is to observe:

- Input precedence resolution (first/last/all)
- Stack trace leaks
- Handler misbehavior
- Type confusion or logic divergence

---

## 📋 Task Breakdown

| Step Description                                                                 | Status |
|----------------------------------------------------------------------------------|--------|
| 🚀 Launch Juice Shop instance using Docker                                       | ☐      |
| 🔍 Identify endpoints with parameterized logic (`/search`, `/login`, etc.)       | ☐      |
| 🧬 Craft GET/POST requests with repeated keys                                    | ☐      |
| 🔁 Send polluted payloads using curl, Burp, or Postman                           | ☐      |
| 📡 Monitor for unexpected behavior, 500 errors, or broken UI flows               | ☐      |
| 🧠 Capture raw stack traces, error bodies, and HTTP headers                      | ☐      |
| 📁 Save logs and screenshots for each successful error-inducing payload          | ☐      |

---

## 🧪 Sample Payloads & Techniques

### 🔸 Query String Parameter Pollution

```bash
curl -X GET "http://localhost:3000/rest/products/search?q=apple&q=admin" -v
🧠 This simulates a polluted search input — backend may parse q as:

An array: ['apple', 'admin']

A string: "admin" (last occurrence)

Or crash: TypeError: q.toLowerCase is not a function

🔸 POST Body – URL Encoded Form
bash
Copy
Edit
curl -X POST http://localhost:3000/rest/user/login \
-H "Content-Type: application/x-www-form-urlencoded" \
-d "email=admin@juice-sh.op&email=hacker@juice-sh.op&password=admin123"
🧠 Observe whether first or last email is used, or if undefined is passed, triggering a handler exception or login bypass.

🔸 JSON Body Pollution (manually via Burp/Postman)
json
Copy
Edit
{
  "comment": "original",
  "comment": "polluted",
  "rating": 3
}
🧠 Behavior depends on the parser:

Some accept the last key, others throw syntax or key-duplication errors.

🧾 Expected Output
Output Field	Description
HTTP/1.1 400 or 500	Indicates exception or ambiguous input
"stack"	Stack trace including route or controller details
TypeError, SyntaxError	Common parser exceptions for polluted inputs
X-Powered-By: Express	Backend fingerprinting confirmation
Content-Type: application/json	Confirms structured error output

🗂️ Artifacts to Save
Filename	Description
polluted_query_requests.txt	All polluted query strings sent
form_pollution_stacktrace.log	Login endpoint stack trace from POST body
devtools_search_pollution.png	Screenshot of browser-side failure
response_headers.json	Captured headers from each test

🧠 Post-Analysis Recommendations
Determine how parameter priority is resolved (first, last, array)

Check whether stack traces differ with each payload

Evaluate if pollution could result in logic bypass or DoS

Use insights for chaining into deeper authorization or injection flaws

🧭 Related Domains
Domain	Exploitation Vector
API Security Testing	Input normalization and parser confusion
Web App Pentesting	Business logic flaw through input misuse
Red Team Recon	Framework enumeration via error response
AppSec Research	Studying edge-case backend parsing bugs
