📁 Error-Handling-Attacks-Juice-Shop/4-Forced-Application-Crash/Read-Me.md

markdown
Copy
Edit
# 🔥 4 – Forced Application Crash

> 📂 Path: `Error-Handling-Attacks-Juice-Shop/4-Forced-Application-Crash/`

---

## ⚔️ Description

In this attack, the goal is to **intentionally crash the application** by sending **malformed, logically invalid, or highly recursive payloads** to trigger unhandled exceptions. These forced crashes can expose:

- Stack traces
- File paths
- Internal API calls
- Server runtime behavior
- Debugging hooks or memory-related flaws

Crashing the app allows attackers to fingerprint **framework internals**, observe failover behavior, or, in production environments, even lead to **denial-of-service (DoS)** or **remote code execution (RCE)** under specific misconfigurations.

---

## 🧠 Deep Technical PoC

### 🎯 Objective

Send payloads designed to break internal logic, force recursion errors, or bypass validation to cause the app to crash. Analyze crash output, stack dumps, or server restarts for recon and privilege escalation vectors.

---

### 🛠️ Tools Used

| Tool           | Purpose                                                   |
|----------------|-----------------------------------------------------------|
| 🔧 **Burp Suite**     | Intercept requests and inject crash vectors             |
| 🧪 **curl / Postman** | Send malformed or nested JSON payloads                  |
| 🧰 **DevTools (F12)** | Access frontend input points that map to backend logic |
| 🧱 **Node.js Crash Simulators** (optional) | Local testing with payloads in mock apps     |

---

### 🧪 Step-by-Step Crash Walkthrough

#### 1️⃣ Start Juice Shop

```bash
docker run --rm -p 3000:3000 bkimminich/juice-shop
Navigate to:

arduino
Copy
Edit
http://localhost:3000
2️⃣ Identify Sensitive Logic
Common targets:

🔐 POST /rest/user/login

🛒 POST /rest/basket/

📝 POST /rest/feedback

🧾 POST /rest/products/search

3️⃣ Inject Logic Bomb or Malformed Payload
Example A – Recursive Payload (JSON Parser Stress)
bash
Copy
Edit
curl -X POST http://localhost:3000/api \
-H "Content-Type: application/json" \
-d '{"data": {"data": {"data": {"data": {"data": {}}}}}}'
📍 Expect memory exhaustion or JSON parsing crash.

Example B – Null Object Injection
bash
Copy
Edit
curl -X POST http://localhost:3000/rest/user/login \
-H "Content-Type: application/json" \
-d '{"email": null, "password": null}'
📍 Some frameworks crash on null.toString() when logging or validating.

Example C – Type Confusion / Array Injection
bash
Copy
Edit
curl -X POST http://localhost:3000/rest/feedback \
-H "Content-Type: application/json" \
-d '{"comment": [1,2,3], "rating": "Infinity"}'
📍 If backend tries comment.length, may throw undefined is not a function.

4️⃣ Observe Server Behavior
Look for:

500 Internal Server Error

Full Express stack trace

Memory dump traces

Termination logs

Docker container crash loop

🚩 Hacker Insight
🔍 What’s Exposed Internally?
Leak Point	Exploit Opportunity
Stack Trace	Full file paths, function names, code structure
JSON Parser Crash	Backend logic flaws → RCE (in rare cases)
Crashed Container	Trigger DoS → App unavailable
Logging Failures	Leak environment variables or tokens

🔬 Recon Advantage
Pinpoint backend entry points

Locate unvalidated input sinks

Fingerprint error-handling routines

Surface routes vulnerable to DoS

🧨 Real-World CVEs / Incidents
CVE-2019-5413 – Express stack trace leak

Node.js JSON Parser Bugs – Deep object nesting → crash

Custom Middleware Failure – res.send(null) crash on response rendering

CVE-2018-12116 – Uncaught exception in Node http module

💣 Exploit Demo Video
Demonstrate forced crash using Burp or curl + show Docker container log restart.

🛡️ Mitigation Recommendations
Fix Type	Description
🧱 Input Validation	Enforce schema types and value limits
🚫 Limit recursion	Set max depth for JSON parsing
🧰 Catch-All Error Handler	Prevent uncaught exceptions from crashing app
📉 Rate Limit / WAF	Throttle logic bombs / malformed requests

Sample Express error handler:

js
Copy
Edit
app.use((err, req, res, next) => {
  logger.error(err.stack);
  res.status(500).send('Internal server error.');
});
🧭 Classification in OffSec
Domain	Attack Objective
Red Teaming	App stability probing / DoS
Exploit Dev	Crash-based RCE discovery
Web Pentesting	Input validation failures
Secure Coding Audit	Absence of fault tolerance

📂 Suggested Artifacts
crash_payloads.json – Full list of bomb vectors

docker_logs_crash.txt – Post-crash server logs

burp_crash_interactions.txt – Raw POST requests

screenshots/ – App behavior on crash

error_analysis.md – Mapping of crash type → response

👨‍💻 Author
Shajohn16
Offensive Security Enthusiast | AppSec Researcher | Node.js Exploiter
GitHub: @Shajohn16
