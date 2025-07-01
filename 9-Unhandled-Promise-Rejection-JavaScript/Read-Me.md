📁 Error-Handling-Attacks-Juice-Shop/9-Unhandled-Promise-Rejection-JavaScript/Read-Me.md

markdown
Copy
Edit
# 🔥 9 – Unhandled Promise Rejection (JavaScript)

> 📂 Path: `Error-Handling-Attacks-Juice-Shop/9-Unhandled-Promise-Rejection-JavaScript/`

---

## ⚔️ Description

In modern JavaScript-based applications (like OWASP Juice Shop, built with Angular/Node.js), asynchronous behavior is handled via **Promises**. When these Promises fail and are **not explicitly caught**, they result in **Unhandled Promise Rejection** errors.

Triggering these errors allows attackers to:
- Observe application crash behavior or inconsistencies
- Dump internal JS object states in browser console
- Expose endpoint failure logic, token mismanagement, or broken UI handlers
- Infer how client-side and backend logic interact

These issues may **not always be exploitable**, but they are valuable in:
- Reverse-engineering app logic
- Building client-side exploits (XSS/DOM-based issues)
- Elevating to privilege logic tampering in real-time JS

---

## 🧠 Deep Technical PoC

### 🎯 Objective

Force application code (primarily in the frontend) to **fail during Promise resolution** or response parsing. The goal is to see if the frontend properly catches these failures and handles them gracefully—or leaks internal information to the console or browser alerts.

---

### 🛠️ Tools Used

| Tool            | Purpose                                                   |
|------------------|-----------------------------------------------------------|
| 🧱 DevTools      | Inspect JS errors, network failures, and uncaught exceptions |
| 🧰 Burp Suite    | Modify response to break client-side expectations         |
| 🐍 curl          | Test backend behavior on endpoint inputs                  |
| 🧪 Postman       | Trigger malformed or unexpected server responses          |

---

### 🧪 Step-by-Step Exploit Procedure

#### 1️⃣ Start Juice Shop

```bash
docker run --rm -p 3000:3000 bkimminich/juice-shop
Access app at:
http://localhost:3000

2️⃣ Open Developer Tools in Browser
Use F12 or right-click > Inspect

Go to Console tab

Clear console to observe only new unhandled exceptions

3️⃣ Trigger UI Logic That Returns a Promise
Examples:

Try submitting the login form without a server token

Submit feedback with an invalid content-type

Refresh page after force-deleting the token from localStorage

4️⃣ Observe Console Logs
Sample output:

js
Copy
Edit
Uncaught (in promise) TypeError: Cannot read properties of undefined (reading 'xyz')
    at Object.successHandler (main.js:1467)
    at ...
Other example:

js
Copy
Edit
UnhandledPromiseRejectionWarning: SyntaxError: Unexpected token < in JSON at position 0
📌 Meaning: Response was HTML (error page) but parsed as JSON → internal assumption failed

💡 Payload Ideas
Delete token from localStorage and reload user settings

Intercept /rest/user/whoami and return malformed JSON using Burp

Replace response with non-JSON to break client-side .json() parsing

Break UI-bound APIs like /rest/feedback to return 500

📄 Expected Output
Output	Interpretation
UnhandledPromiseRejection	Promise failed without a .catch() handler
TypeError: Cannot read property	Reference error due to undefined/null
SyntaxError in JSON.parse	Backend returned malformed JSON
Stack trace in browser console	Shows exact file and line of error

🚩 Hacker Insight
🔍 What’s Exposed Internally?
JS handler names, functions, and client-side logic flow

Weaknesses in frontend exception control

REST endpoint assumptions (return types, data schema)

Angular component structure (via stack trace)

🧭 What Recon Does This Enable?
Map frontend logic and dependency tree

Infer what backend endpoints return (JSON, HTML, error string)

Identify areas of frontend trust in backend data

Learn object model via console leakage

🧨 Real-World CVEs
CVE-2020-7746 – Uncaught promise rejections in Node.js dependency caused DoS

Angular CVE-2021-22960 – Unhandled promises from backend XHR led to security logic failure

Slack Electron RCE – Partially triggered by JS Promise chain mismanagement

💣 Exploit Demo Video (Add link if needed)
🎥 Suggested Demo:

Use Burp to intercept /rest/user/whoami

Replace body with Not JSON

Reload app

Watch client crash or log stack trace in DevTools

🛡️ Mitigation Techniques
Strategy	Description
.catch() after every .then()	Ensure all Promises are handled
try...catch around async/await	Gracefully capture failures in async blocks
Custom global error handler	Register window.onunhandledrejection in browser
Return JSON always	Maintain strict contract for frontend expectations

🧭 OffSec Utility
Domain	Use Case
Web Application Pentesting	Map internal JS logic and error exposure
Red Team Recon	Fingerprint frontend libraries, logic, and flow
Exploit Development	Build client-side or DOM-based logic injections
Bug Bounty Hunting	Discover hidden components via stack traces

👨‍💻 Author
Shajohn16
Frontend+Backend Recon Specialist | JavaScript Abuse Researcher
GitHub: @Shajohn16
