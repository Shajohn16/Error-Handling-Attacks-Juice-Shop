📁 Error-Handling-Attacks-Juice-Shop/7-Parameter-Pollution-Errors/Read-Me.md

markdown
Copy
Edit
# 🔥 7 – Parameter Pollution Errors

> 📂 Path: `Error-Handling-Attacks-Juice-Shop/7-Parameter-Pollution-Errors/`

---

## ⚔️ Description

Parameter pollution occurs when **duplicate query or body parameters** are submitted to an endpoint, resulting in **confused handler logic**, **unexpected execution paths**, or **application-level exceptions**. If input validation or parsing is improperly implemented, the backend may:

- Process only the first, last, or all values unpredictably
- Trigger internal logic faults due to ambiguity
- Leak stack traces through improper error handling
- Expose backend object mappings and parameter parsing libraries

This class of vulnerability is often overlooked and is highly relevant to:
- **Business logic bypass**
- **Authorization bypass**
- **Verbose error enumeration**
- **Application misbehavior discovery**

---

## 🧠 Deep Technical PoC

### 🎯 Objective

Submit multiple values for the same parameter (`param=value1&param=value2`) across **query strings**, **form bodies**, or **JSON payloads**, and observe the backend's behavior. Identify traces of:

- Ambiguous logic resolution
- Exception handling failures
- Routing or parameter-parsing confusion

---

### 🛠️ Tools Used

| Tool           | Use Case                                               |
|----------------|--------------------------------------------------------|
| 🧰 Burp Suite  | Intercept, replay, and pollute parameters              |
| 🧪 curl        | Craft polluted query and body parameters manually      |
| 🧱 DevTools    | Identify default parameters and mutate them            |
| 🧬 Postman     | Used to test raw body duplicates or x-www-form-urlencode|

---

### 🧪 Step-by-Step Exploitation Walkthrough

#### 1️⃣ Start Juice Shop Locally

```bash
docker run --rm -p 3000:3000 bkimminich/juice-shop
Access:

arduino
Copy
Edit
http://localhost:3000
2️⃣ Identify Vulnerable Endpoints
Focus on parameterized or search-based endpoints:

GET /rest/products/search?q=

POST /rest/user/login

POST /rest/feedback

3️⃣ Launch Parameter Pollution Attacks
🔸 A. Query Parameter Pollution
bash
Copy
Edit
curl -X GET "http://localhost:3000/rest/products/search?q=apple&q=orange" -v
🧪 Expected:

Multiple values for q parsed

Ambiguity in search result

Internal logs may throw: TypeError: q.toLowerCase is not a function

🔸 B. POST Body Pollution (Form)
bash
Copy
Edit
curl -X POST http://localhost:3000/rest/user/login \
-H "Content-Type: application/x-www-form-urlencoded" \
-d "email=admin@juice-sh.op&email=hacker@juice-sh.op&password=admin123"
🧪 Expected:

Last/first email used arbitrarily

Possible validation failure

Stack trace if email is undefined

🔸 C. JSON Body Pollution
Send using Burp Suite or Postman:

json
Copy
Edit
{
  "comment": "test",
  "comment": "polluted",
  "rating": 5
}
🧪 Expected:

Behavior depends on JSON parser

Some parsers overwrite, others raise error

Could trigger deserialization exception

📡 What to Observe
Output Element	Description
HTTP/1.1 500/400	Application crash due to ambiguous input
"stack" in JSON	Stack trace, internal method/function names
Header: X-Powered-By	Backend fingerprint (Express, Node.js)
JSON parsing error	Identifies backend deserialization behavior

🚩 Hacker Insight
🎯 What’s Leaked?
Stack traces with file references

Input parsing libraries or middleware

Schema structure or field validation behavior

Custom route handler exceptions

🎯 What Recon Does This Enable?
Determine parameter precedence (first, last, or array)

Reverse-engineer request schemas and object expectations

Exploit parameter confusion for auth bypass or injection

Confirm which HTTP methods/encodings are supported

🧨 Real-World CVEs
CVE-2020-11022: jQuery Parameter Pollution in DOM manipulation

CVE-2021-23369: qs NPM module - Prototype Pollution

Uber Bounty: Polluted query param led to privilege escalation

💣 Exploit Demo Video
🎥 Add PoC:

Burp Repeater demonstrating q=abc&q=123 on product search

Observe inconsistent server behavior or crash trace

🛡️ Mitigation Strategies
Mitigation Technique	Description
🚫 Reject duplicate keys	Enforce unique parameter names
🔒 Use strict schema parsing	Tools like Joi, Ajv, or custom validators
🛡️ Input sanitation	Normalize or flatten parameters
🧱 Disable stack traces	Avoid exposing exceptions in prod environments

Express example:

js
Copy
Edit
app.use((req, res, next) => {
  const keys = Object.keys(req.query);
  const duplicates = keys.filter((k, i) => keys.indexOf(k) !== i);
  if (duplicates.length > 0) {
    return res.status(400).send({ error: "Parameter pollution detected" });
  }
  next();
});
🧭 OffSec Classification
Discipline	Utility
Web App Pentesting	Exploits input parsing flaws
API Security Testing	Reveals schema and backend behavior inconsistencies
Red Teaming	Aids in bypassing controls and fuzzing
Research & Recon	Framework detection, parameter resolution mapping

📁 Suggested Artifacts
File	Description
polluted_payloads.txt	Raw GET/POST requests with duplicates
stacktrace_logs_pollution.txt	Output showing internal errors
burp_repeater_examples.burp	Saved Burp Suite requests
parser_behavior_notes.md	Observed behavior of backend parsing engine

👨‍💻 Author
Shajohn16
AppSec Researcher | Input Manipulation Specialist | Recon Engineer
GitHub: @Shajohn16

