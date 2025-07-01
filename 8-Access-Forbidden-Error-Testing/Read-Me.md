📁 Error-Handling-Attacks-Juice-Shop/8-Access-Forbidden-Error-Testing/TO-DO.md

markdown
Copy
Edit
# ✅ TO-DO – 8: Access Forbidden Error Testing

This checklist guides the process of **intentionally triggering authorization errors** by accessing protected resources without proper credentials or roles in Juice Shop. These forced 403/401 scenarios help uncover role-based access control weaknesses, session validation logic, and overexposed APIs.

---

## 🎯 Objective

Test how Juice Shop handles unauthorized access attempts by:

- Removing or manipulating session tokens
- Accessing admin-only or internal APIs as unauthenticated users
- Observing HTTP responses, error messages, and internal handler behavior

---

## 📋 Action Plan

| Task                                                                                   | Status |
|----------------------------------------------------------------------------------------|--------|
| 🚀 Start Juice Shop locally using Docker                                               | ☐      |
| 🔍 Identify RBAC-restricted endpoints using DevTools and Burp                          | ☐      |
| 🔐 Access those endpoints without a token or with a tampered token                     | ☐      |
| 📡 Send raw HTTP requests and observe 401/403 responses                                | ☐      |
| 🧾 Capture headers, response body, and any leaked trace information                    | ☐      |
| 💾 Save curl/Burp examples and any stack traces shown in responses                     | ☐      |

---

## 🔧 Terminal Examples

### 🔸 Access Protected API Without Token

```bash
curl -X GET http://localhost:3000/rest/user/whoami -v
🧠 Expected Result:

HTTP/1.1 401 Unauthorized

Body: Authorization header missing!

Response Header: WWW-Authenticate

🔸 Access Admin Endpoint as a Logged-Out User
bash
Copy
Edit
curl -X GET http://localhost:3000/administration -v
🧠 Expected Result:

HTTP/1.1 403 Forbidden

Message: "Access denied" or redirected to login

🔸 Use Invalid/Expired JWT Token
bash
Copy
Edit
curl -X GET http://localhost:3000/rest/user/whoami \
-H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI..." -v
🧠 Expected Result:

HTTP/1.1 401 Unauthorized

Message: jwt malformed, jwt expired, or invalid signature

May leak stack traces if improperly handled

📄 What to Document
Artifact	Description
unauthorized_responses.log	Raw HTTP responses showing status codes & messages
burp_intercepts.burp	Saved Burp Suite requests without tokens
admin_endpoint_headers.txt	Headers returned on restricted resource access attempts
devtools_screenshot.png	Screenshots of browser network logs or JS console errors

📌 Additional Tips
Use DevTools > Application > LocalStorage to delete token manually

Use Burp’s Repeater to strip Authorization headers and replay

Try switching to non-admin users and replaying admin requests

Tamper JWT payload to change "role": "admin" and test access logic

🧭 Domain Relevance
Field	How This Test Helps
Web App Pentesting	Tests access control enforcement
API Security Assessment	Finds protected but unauthenticated API endpoints
Red Teaming (Stealth)	Maps access denial logic, useful for privilege chaining
Access Control Enumeration	Helps determine granularity of RBAC or ABAC policies
