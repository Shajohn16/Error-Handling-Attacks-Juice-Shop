📁 Error-Handling-Attacks-Juice-Shop/9-Unhandled-Promise-Rejection-JavaScript/TO-DO.md

markdown
Copy
Edit
# ✅ TO-DO – 9: Unhandled Promise Rejection (JavaScript)

This checklist guides the simulation of **unhandled client-side Promise rejections** within the OWASP Juice Shop frontend. These issues typically surface when JavaScript Promises fail and lack `.catch()` or `try...catch` blocks, resulting in browser console errors or functional UI crashes.

The objective is to provoke such failures by breaking expected data formats, invalidating tokens, or interrupting async flows—yielding valuable insights into frontend logic, exposed stack traces, and application behavior during failure states.

---

## 🎯 Objective

Trigger unhandled asynchronous errors by:
- Causing backend-to-frontend data mismatches (malformed JSON, null values)
- Forcing token validation failures
- Interrupting expected UI behavior with missing/invalid inputs

Observe resulting errors using browser DevTools and analyze stack traces for file names, methods, and potential misuse of Promises in the client.

---

## 🧪 Execution Plan

| Task                                                                                  | Status |
|---------------------------------------------------------------------------------------|--------|
| 🚀 Launch Juice Shop instance locally (via Docker or Node)                            | ☐      |
| 🧭 Open browser → Navigate to `http://localhost:3000`                                  | ☐      |
| 🧼 Clear console logs and browser cache                                                | ☐      |
| 🔍 Identify async-based UI flows (login, reviews, user profile, feedback, etc.)       | ☐      |
| 🛑 Remove or tamper session `token` in `localStorage`                                  | ☐      |
| ⚔️ Submit form or load a protected endpoint from UI                                    | ☐      |
| 🧨 Intercept and manipulate `/rest/...` API using Burp to return invalid response body| ☐      |
| 🧠 Observe JS errors, stack traces, and unhandled promise rejections in DevTools      | ☐      |
| 📁 Save screenshots, logs, and curl/Burp requests/responses                           | ☐      |

---

## 🧬 Sample Browser-Side Payload Triggers

### 🔸 Manual Token Deletion

```js
// Run this in browser DevTools (F12 → Console)
localStorage.removeItem('token');
Then try accessing My Account, Basket, or other protected flows.

🔸 Modify Token to Expired/Invalid
js
Copy
Edit
localStorage.setItem('token', 'eyJhbGciOiJIUzI1...tamperedPayload...');
location.reload();
Observe whether frontend fails silently, throws an error, or prints stack trace.

💥 Sample Burp Interception Example
Intercept /rest/user/whoami and respond with:

http
Copy
Edit
HTTP/1.1 200 OK
Content-Type: application/json

<html><body>Internal Error</body></html>
Expected Console Output:

bash
Copy
Edit
Uncaught (in promise) SyntaxError: Unexpected token < in JSON at position 0
🧾 Expected Artifacts
Artifact Filename	Content
unhandled_promises.log	JS stack traces and browser console logs
whoami_response_burp.txt	Modified response body that broke frontend
devtools_errors.png	Screenshot of browser DevTools error display
tampered_token_curl.txt	Curl examples of broken/invalid session use

📌 Key Observations
Look for uncaught TypeError, ReferenceError, or SyntaxError

Identify lines like UnhandledPromiseRejectionWarning in DevTools

Focus on endpoints that expect structured JSON and fail when not received

Use console trace to identify JS file and line number (e.g., main.js:1452)

🧭 Related Domains
Field	Relevance
Frontend Security Testing	Evaluating async resilience and proper exception handling
Web App Pentesting	Discovering client-side failure leakage
Red Team Recon	Mapping internal logic flow via stack traces
Exploit Development	Crafting frontend-based manipulation vectors
