# 🔥 1-Verbose-Error-Message-Disclosure

## ⚔️ Description
Trigger errors (e.g., malformed input) to reveal stack traces, DB errors, or file paths.

---

## 🧠 Deep Technical PoC

1. Step-by-step walkthrough on Juice Shop.
2. Tools: Burp Suite, curl, DevTools.
3. Expected output.
4. Internal trace analysis.

---

## 🚩 Hacker Insight

- What’s exposed internally?
- What recon does this enable?
- Real-world CVEs similar to this.

## 💣 Exploit Demo Video (Add link if needed)

---


Error-Handling-Attacks-Juice-Shop/1-Verbose-Error-Message-Disclosure/Read-Me.md

markdown
Copy
Edit
# 🔥 1 – Verbose Error Message Disclosure

> 📂 Path: `Error-Handling-Attacks-Juice-Shop/1-Verbose-Error-Message-Disclosure/`

---

## ⚔️ Description

This vulnerability leverages improper error handling in OWASP Juice Shop to **reveal internal application errors** like stack traces, database parsing issues, or misconfigured exception blocks. These verbose messages assist attackers in fingerprinting technologies, identifying backend logic flaws, and shaping follow-up injection payloads.

---

## 🧠 Deep Technical PoC

### 🎯 Objective
Trigger a verbose error by submitting **malformed input** to a backend API, bypassing frontend filters using tools such as Burp Suite or DevTools.

---

### 🛠️ Tools Used
- 🧰 **Burp Suite (Community/Pro)** – for intercepting/modifying HTTP payloads.
- 💻 **Browser Developer Tools** – Network tab to inspect request/response.
- 🔁 **cURL** – command-line HTTP client for raw request testing.

---

### 🧪 Step-by-Step

#### 1. Launch Juice Shop
```bash
docker run --rm -p 3000:3000 bkimminich/juice-shop
→ Access: http://localhost:3000

2. Intercept Login Request in Burp
Email: ' OR 1=1--

Password: anything

Send request and observe response body.

3. Use DevTools (Alt+Cmd+I or F12)
Go to Network tab.

Submit the same payload.

Look under login → Response.

json
Copy
Edit
{
  "error": "Unexpected token 'OR' at position 1"
}
4. Trigger via cURL (Optional)
bash
Copy
Edit
curl -X POST http://localhost:3000/rest/user/login \
-H "Content-Type: application/json" \
-d '{"email":"\' OR 1=1--", "password":"test"}'
📤 Expected Output:

json
Copy
Edit
{
  "error": "Unexpected token ''' at position 0"
}
🚩 Hacker Insight
🧩 What's Exposed?
📍 Parser behavior (tokenization, error depth).

🧠 Backend tech hints: JSON parsers, exception formats.

📚 Reveals internal logic paths like "rest/user/login".

🔎 Recon Value
📌 Helps attackers identify:

Backend logic gaps

Improper sanitization/escaping

Hidden endpoints

Can chain this with SQLi, XSS, or IDOR for multi-stage exploitation.

💡 Real-World CVEs
CVE-2020-9484 – Apache Tomcat deserialization errors exposed via stack trace.

CVE-2023-0669 – GoAnywhere MFT pre-auth RCE with error-based endpoint leakage.

🎥 Exploit Demo Video
Add link here if recorded

🔐 Mitigation Tips
❌ Never expose raw exception output in production.

✅ Use global error handlers (e.g., Express error middleware).

🔒 Implement consistent error codes + generic responses:

json
Copy
Edit
{ "error": "Invalid login attempt." }
🧭 Category Mapping
Discipline	Role
Red Teaming	Recon / Enumeration
VAPT	Input Validation, Info Disclosure
Exploit Dev	Entry point for crafted payloads
Web Security	Secure Coding Practices

🧠 Author
👨‍💻 Shajohn16
OffSec Researcher | AppSec | VAPT | Red Team Apprentice
GitHub: @Shajohn16
