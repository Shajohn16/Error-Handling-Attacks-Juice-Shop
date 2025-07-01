Absolutely. Here's a **highly detailed**, **offensive-security-focused**, and **technically rich** expansion of the `README.md` under:

📁 `Error-Handling-Attacks-Juice-Shop/10-Invalid-JWT-or-Session-Token/`

This is crafted to demonstrate **deep technical competence**, **manual exploration**, and a **methodical red team approach**.

---

````markdown
# 🔥 10 – Invalid JWT or Session Token

> 📂 Path: `Error-Handling-Attacks-Juice-Shop/10-Invalid-JWT-or-Session-Token/`

---

## ⚔️ Description

JSON Web Tokens (JWT) are widely used for stateless authentication in modern web applications. When a user logs in, the backend issues a JWT, which is stored client-side (often in localStorage or cookies) and attached in the Authorization header of future requests.

This attack explores what happens when that token is:
- **Corrupted**
- **Tampered**
- **Unsigned**
- **Re-signed with a different algorithm (`alg` manipulation)**

By observing the server's behavior in response to malformed or altered tokens, we can assess:
- Whether token validation errors are **leaking internal logic**
- If the server is **vulnerable to algorithm downgrade (e.g., `none`)**
- Whether weak **HMAC keys** allow brute-forcing the signature
- If it is possible to **escalate privilege** by modifying the payload (e.g., `role: admin`)

---

## 🧠 Deep Technical PoC

### 🎯 Objective

To test the robustness of JWT validation by modifying its structure, signature, and claims. Evaluate server responses to gain recon and potentially escalate access using forged JWTs.

---

### 🛠️ Tools Used

| Tool          | Purpose |
|---------------|---------|
| 🔍 **Burp Suite** | Intercept valid requests, modify tokens |
| 🔓 **JWT.io** | Decode/encode JWT payloads and headers |
| 🔧 **DevTools (F12)** | Access browser localStorage and manipulate JWT |
| 🐍 **PyJWT / jwt-cli** | Generate custom tokens programmatically |
| 🛰️ **curl / Postman** | Send raw HTTP requests with tampered tokens |

---

### 🧪 Step-by-Step Attack Procedure

#### 1️⃣ Start OWASP Juice Shop (Docker Method)

```bash
docker run --rm -p 3000:3000 bkimminich/juice-shop
````

Wait until the server is accessible at:

```
http://localhost:3000
```

#### 2️⃣ Register & Login

Use the app’s UI to register a new user:

* Email: `attacker@juice.sh`
* Password: `123456`

Once logged in, open Chrome Developer Tools:

```sh
Shortcut: F12 → Application Tab → Local Storage → http://localhost:3000
```

Look for the key named `token` – this is your **valid JWT**.

---

#### 3️⃣ Decode & Modify the JWT (Manual Method)

Copy the token and paste it on [https://jwt.io](https://jwt.io)

It will auto-decode to show three parts:

* **Header**: contains metadata like algorithm
* **Payload**: user data (e.g., `email`, `role`)
* **Signature**: HMAC/RSASSA signature

Edit the payload:

```json
{
  "email": "admin@juice-sh.op",
  "role": "admin"
}
```

Manipulation Types:

* **Type A** – Modify payload only without changing signature (results in invalid signature error)
* **Type B** – Change `alg` to `none`, remove signature
* **Type C** – Sign with your own secret using `HS256` if server allows weak keys

---

#### 4️⃣ Injection Method A: Browser Replacement

* Back in DevTools → `localStorage`
* Replace the original `token` with the modified version
* Refresh the application

✅ Watch for:

* UI anomalies (admin features)
* Backend 401 errors
* Console logs leaking token parsing issues

---

#### 5️⃣ Injection Method B: curl-Based PoC

```bash
curl -X GET http://localhost:3000/rest/user/whoami \
-H "Authorization: Bearer <tampered_JWT>"
```

Expected server behavior:

```json
{
  "error": "invalid token",
  "message": "jwt malformed"
}
```

or

```json
{
  "message": "jwt signature verification failed"
}
```

These verbose errors expose internal backend mechanisms such as:

* Parsing method (`jsonwebtoken` in Node.js)
* Validation logic (signature check failure)
* Token integrity enforcement

---

## 🚩 Hacker Insight

### 🧩 What's Exposed?

| Observation                  | Implication                          |
| ---------------------------- | ------------------------------------ |
| `jwt malformed`              | Weak input validation                |
| `invalid signature`          | Signature validation logic confirmed |
| `jwt expired`                | TTL validation leak                  |
| `alg=none` accepted          | 🚨 High-risk – critical flaw         |
| 500 error on malformed token | Crash, potential DoS                 |

---

### 🧠 Recon Value

* 📍 Identify **JWT handling libraries** (e.g., `jsonwebtoken`, `jose`, etc.)
* 🔍 Confirm if `alg` is forced server-side or client-controlled
* 🧪 Analyze **token expiration behavior**
* 🚨 Check if backend is **vulnerable to signature forgery**

---

### 🧨 Real-World CVEs

* **[CVE-2015-9235](https://nvd.nist.gov/vuln/detail/CVE-2015-9235)**
  `jsonwebtoken` package allowed `alg: none` header, bypassing signature verification.

* **Auth0 Critical Disclosure**
  Auth0 JWT libraries were vulnerable to algorithm substitution and key confusion attacks.

* **Node.js Timing Attacks**
  Poor signature comparison logic (non-constant time) leaked info via timing side channels.

---

## 💡 Mitigation

| Control Area     | Recommendation                                           |
| ---------------- | -------------------------------------------------------- |
| 🔐 Algorithm     | Always enforce `RS256` or `ES256` server-side            |
| 🚫 Signature     | Never accept unsigned (`alg: none`) tokens               |
| 🧰 Error Logging | Do not leak internal messages like `JsonWebTokenError`   |
| ⏳ Expiration     | Enforce short TTLs and server-side revocation if needed  |
| 🔒 Secret Mgmt   | Use secure, high-entropy secrets and rotate periodically |

Use Express middleware like:

```js
app.use(jwt({ secret: 'supersecret', algorithms: ['HS256'] }))
```

---

## 🧭 OffSec Discipline Mapping

| Domain          | Application                             |
| --------------- | --------------------------------------- |
| Web App Pentest | Auth Token Tampering                    |
| Red Teaming     | Privilege Escalation, Session Hijacking |
| Exploit Dev     | JWT Algorithm Downgrade, Key Guessing   |
| Research        | Token Parsing Bugs, JWT Lib Analysis    |
| API Security    | Authorization Header Manipulation       |

---

## 📂 Suggested Repo Files

* `valid_token.txt` – Captured original JWT
* `tampered_payload.json` – Modified payloads (admin role)
* `alg_none_token.jwt` – Crafted token with alg=none
* `curl_logs.txt` – Server response to forged tokens
* `error_analysis.md` – Notes on token validation behavior

---

## 🎥 Exploit Demo Video

*Add link or GIF if available to demonstrate:*

* LocalStorage manipulation
* Burp token injection
* curl-based testing

---

## 🧠 Author

**👨‍💻 Shajohn16**
Offensive Security Researcher | AppSec | JWT Exploitation | Red Team Apprentice
*GitHub: [@Shajohn16](https://github.com/Shajohn16)*

---

```

---

✅Done.
```
