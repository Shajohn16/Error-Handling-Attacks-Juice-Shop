Here is the **enhanced, structured, and technical** version of the `TODO.md` file for:

📁 `Error-Handling-Attacks-Juice-Shop/10-Invalid-JWT-or-Session-Token/`

---

### 📋 `TODO.md`

````markdown
# ✅ TO-DO – 10: Invalid JWT or Session Token

This checklist outlines the tactical steps and payloads for exploiting JWT-based session validation logic. The objective is to identify parsing failures, signature verification issues, algorithm downgrade vulnerabilities, and information leaks via verbose error messages.

---

## 🧪 Step-by-Step Task List

| Task                                                  | Status |
|--------------------------------------------------------|--------|
| 🔃 Start Juice Shop using Docker                      | ☐      |
| 🔐 Register a user to retrieve a valid JWT            | ☐      |
| 🧰 Capture JWT from browser localStorage              | ☐      |
| 🧬 Decode token using [https://jwt.io](https://jwt.io) | ☐      |
| 🧠 Modify token claims (`role`, `email`, etc.)         | ☐      |
| 🚫 Break the signature or set `alg: none`              | ☐      |
| 💉 Inject modified token via browser or curl          | ☐      |
| 🔍 Observe HTTP responses for validation failures     | ☐      |
| 📝 Document headers, error messages, and status codes | ☐      |
| 📸 Capture screenshots and curl logs                  | ☐      |
| 🔒 Evaluate server-side behavior under tampered JWTs  | ☐      |

---

## 💣 Payload Strategies

### 🔧 Payload Type A – Invalid Signature

Modify token payload and reuse original signature without re-signing.

> Expect: `jwt signature verification failed`

---

### 🔧 Payload Type B – Algorithm Substitution (`alg: none`)

```json
{
  "alg": "none",
  "typ": "JWT"
}
````

* Remove signature
* Expect: token is either rejected or (critically) accepted

---

### 🔧 Payload Type C – Privilege Escalation

```json
{
  "email": "admin@juice-sh.op",
  "role": "admin"
}
```

→ If backend fails to verify signature, may elevate privilege.

---

## 🧪 curl Example for Token Injection

```bash
curl -X GET http://localhost:3000/rest/user/whoami \
-H "Authorization: Bearer <tampered_JWT>" -v
```

---

## 🔍 Expected Output

| Behavior Type     | Example Response                                            |
| ----------------- | ----------------------------------------------------------- |
| Invalid Signature | `{ "message": "jwt signature verification failed" }`        |
| Malformed Token   | `{ "error": "jwt malformed" }`                              |
| Alg: none         | Server accepts unsigned token (⚠️ CRITICAL VULNERABILITY)   |
| Expired Token     | `{ "message": "jwt expired" }`                              |
| Crash / 500 Error | Internal Server Error, Stack Trace in response body or logs |

---

## 📁 Output Artifacts to Save

* `valid_token.txt` – Extracted valid JWT
* `modified_tokens.json` – All crafted variants
* `server_responses.log` – curl/Burp response captures
* `devtools_screenshots/` – LocalStorage manipulation screenshots
* `token_decoding_notes.md` – Manual decode + analysis

---

## 📚 Follow-up Research (Optional)

* [ ] Try signing JWTs with custom `HS256` secrets using PyJWT
* [ ] Run timing attacks to identify weak signature comparisons
* [ ] Check for default keys like `secret`, `password`, etc.
* [ ] Test cookie-based JWT injection (if applicable)

---

## 🧠 OffSec Perspective

| Objective                     | Classification       |
| ----------------------------- | -------------------- |
| Authentication Bypass         | Red Teaming / VAPT   |
| Token Tampering & Forgery     | Web App Exploitation |
| Signature Forgery / Downgrade | Exploit Development  |
| Parser Crash / DoS            | Secure Coding Audit  |

---

```

✅Done.
```
