📁 Error-Handling-Attacks-Juice-Shop/4-Forced-Application-Crash/

markdown
Copy
Edit
# ✅ TO-DO – 4: Forced Application Crash

This task list is tailored for testing how the OWASP Juice Shop reacts to malformed, logically invalid, or system-stressing inputs that lead to **unhandled exceptions**, forced crashes, or runtime errors. This technique is crucial in red teaming, exploit development, and application hardening assessments.

---

## 🎯 Objective

Trigger a **forced crash** or **runtime panic** by submitting malformed inputs, logic bombs, or invalid data types that break backend logic or overrun memory. Evaluate how the app handles such events and what information is leaked in return.

---

## 📋 Attack Workflow Checklist

| Task                                                                | Status |
|---------------------------------------------------------------------|--------|
| 🚀 Start Juice Shop locally via Docker                              | ☐      |
| 🧪 Identify an input vector tied to backend logic (e.g., login, search, feedback) | ☐      |
| 💉 Inject payload that forces crash or exception                    | ☐      |
| 🔍 Observe HTTP status (expect `500 Internal Server Error`)         | ☐      |
| 🧾 Capture server response (headers, stack trace, crash output)     | ☐      |
| 📸 Screenshot full error messages or terminal Docker logs           | ☐      |
| 📁 Store raw request/response bodies                                | ☐      |
| 🧠 Analyze crash pattern and application resilience                 | ☐      |

---

## 💣 Suggested Payloads

### 🔸 Deeply Nested JSON (crash JSON parser)
```bash
curl -X POST http://localhost:3000/api \
-H "Content-Type: application/json" \
-d '{"x":{"x":{"x":{"x":{"x":{"x":{}}}}}}}'
🔸 Null Field Exploit
bash
Copy
Edit
curl -X POST http://localhost:3000/rest/user/login \
-H "Content-Type: application/json" \
-d '{"email": null, "password": null}'
🔸 Type Mismatch Logic Disruption
bash
Copy
Edit
curl -X POST http://localhost:3000/rest/feedback \
-H "Content-Type: application/json" \
-d '{"comment": [1,2,3], "rating": "NaN"}'
📄 Expected Output
Status: HTTP/1.1 500 Internal Server Error

Headers: X-Powered-By: Express

Body: Uncaught exception, e.g.:

json
Copy
Edit
{
  "status": 500,
  "error": "Cannot read property 'length' of undefined",
  "stack": "at Object.exports.create (/app/routes/feedback.js:74:13)"
}
🔬 What to Capture
Artifact	Use
curl_crash_output.log	Terminal output of crafted crash request
docker_crash.log	Console log from crashing container
burp_crash_request.txt	Intercepted request with injected logic bomb
screenshots/stacktrace.png	Evidence of raw crash or file path leakage
notes/error_pattern_analysis.md	Root cause breakdown and observed resilience

🧠 Post-Crash Recon
 Stack trace length + file references

 Memory overload symptoms (loop, high CPU)

 Service downtime or restart (crash loop detection)

 Leakage of unsanitized internal server logic

 DoS potential due to logic bomb vectors

🧭 OffSec Application
Area	Impact
Exploit Dev	Test for logic bombs, input validation bypass
Red Teaming	Precursor to DoS or deeper application fuzzing
Web App Pentesting	Trigger fail points and analyze exception handling flaws
Secure Coding Audit	Find gaps in error control and fault isolation

🧠 Pro Tip: Correlate crash responses with stack frame references to build a map of backend function calls.
