# ✅ TO-DO for 1-Verbose-Error-Message-Disclosure

- [ ] Start Juice Shop locally
- [ ] Navigate to correct endpoint
- [ ] Inject payload: **<insert-payload>**
- [ ] Observe logs/errors
- [ ] Document headers, stack trace, DB error

## Terminal Examples:

```bash
curl -X GET http://localhost:3000/invalid_route -v
```

## Expected Output:

- HTTP/1.1 500 Internal Server Error
- X-Powered-By: Express
- Stack Trace/DB Error in response body or logs

---


# ✅ TO-DO – 1: Verbose Error Message Disclosure

This task list outlines the offensive methodology to trigger and capture verbose error messages in OWASP Juice Shop to reveal backend internals such as stack traces, DB errors, or platform-specific exception messages.

---

## 📌 Task Checklist

| Task                                      | Status |
|-------------------------------------------|--------|
| 🚀 Start Juice Shop locally via Docker     | ☐      |
| 🌐 Access Juice Shop UI (`localhost:3000`) | ☐      |
| 🧪 Navigate to login or any input form     | ☐      |
| 💉 Inject crafted payload into `email`     | ☐      |
| 🔍 Intercept with Burp or DevTools         | ☐      |
| 🧾 Log headers and verbose error message   | ☐      |
| 📸 Capture screenshots for documentation   | ☐      |
| 📁 Save curl output as PoC evidence        | ☐      |
| 🛠️ Add response to documentation           | ☐      |

---

## 🔐 Payloads to Try

- `' OR 1=1--`
- `admin' --`
- `")})]; --`
- `"<script>alert(1)</script>`

---

## 💻 Terminal PoC Examples

### 🔍 Invalid Route Discovery
```bash
curl -X GET http://localhost:3000/invalid_route -v
