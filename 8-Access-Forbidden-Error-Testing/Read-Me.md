# 🔥 8 – Access Forbidden Error Testing

> 📂 Path: `Error-Handling-Attacks-Juice-Shop/8-Access-Forbidden-Error-Testing/`

---

## ⚔️ Description

This category of error testing involves **intentionally accessing protected endpoints without proper authorization**, or with manipulated/expired credentials, in order to provoke **403 Forbidden** and **401 Unauthorized** responses. This technique enables testers to:

- Reverse-engineer the **role-based access control (RBAC)** implementation
- Detect **missing access-level segregation**
- Study how the application communicates permission errors
- Uncover **misconfigured access policies** in APIs or UI routes

These scenarios are critical in:
- **Authorization bypass** attacks
- **Privilege escalation chains**
- **Broken access control** mapping (aligned with **OWASP Top 10 - A01:2021**)

---

## 🧠 Deep Technical PoC

### 🎯 Objective

Simulate unauthorized access attempts to endpoints that enforce role, group, or session-based restrictions. Observe how the app responds to:

- Missing or tampered JWTs
- Expired session tokens
- Accessing admin-only or restricted APIs as a guest/user

---

### 🛠️ Tools Used

| Tool            | Purpose                                            |
|------------------|----------------------------------------------------|
| 🧰 Burp Suite    | Intercept, strip/modify headers and session tokens |
| 🧪 curl          | Send raw requests with or without authorization    |
| 🧱 DevTools      | Discover hidden endpoints via network inspection   |
| 🧬 Postman       | Manage and test requests with expired tokens       |

---

### 🧪 Step-by-Step Walkthrough

#### 1️⃣ Start Juice Shop Instance

```bash
docker run --rm -p 3000:3000 bkimminich/juice-shop
