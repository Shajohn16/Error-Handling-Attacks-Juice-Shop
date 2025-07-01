
#!/bin/bash

declare -A descriptions=(
  ["1-Verbose-Error-Message-Disclosure"]="Trigger errors (e.g., malformed input) to reveal stack traces, DB errors, or file paths."
  ["2-SQL-Injection-Error-based"]="Inject faulty SQL payloads to provoke DBMS error messages for recon."
  ["3-Missing-Custom-Error-Pages"]="Force invalid paths to display default server error pages."
  ["4-Forced-Application-Crash"]="Use logic bombs or malformed input to force unhandled app-level exceptions."
  ["5-API-Error-Leakage"]="Break RESTful calls to view schema leakage, error headers, and stack data."
  ["6-Improper-JSON-Error-Responses"]="Send bad JSON payloads to provoke server response behaviors."
  ["7-Parameter-Pollution-Errors"]="Inject duplicate or invalid parameters to cause handler confusion or internal tracebacks."
  ["8-Access-Forbidden-Error-Testing"]="Force 403/401 by accessing protected routes to study role logic."
  ["9-Unhandled-Promise-Rejection-JavaScript"]="Trigger client-side JS promise errors and watch console logs."
  ["10-Invalid-JWT-or-Session-Token"]="Submit tampered JWTs to view decoding, timing, and validation errors."
)

for folder in "${!descriptions[@]}"; do
  mkdir -p "$folder"
  echo -e "# 🔥 ${folder}\n\n## ⚔️ Description\n${descriptions[$folder]}\n\n---\n\n## 🧠 Deep Technical PoC\n\n1. Step-by-step walkthrough on Juice Shop.\n2. Tools: Burp Suite, curl, DevTools.\n3. Expected output.\n4. Internal trace analysis.\n\n---\n\n## 🚩 Hacker Insight\n\n- What’s exposed internally?\n- What recon does this enable?\n- Real-world CVEs similar to this.\n\n## 💣 Exploit Demo Video (Add link if needed)\n\n---" > "$folder/Read-Me.md"

  echo -e "# ✅ TO-DO for ${folder}\n\n- [ ] Start Juice Shop locally\n- [ ] Navigate to correct endpoint\n- [ ] Inject payload: **<insert-payload>**\n- [ ] Observe logs/errors\n- [ ] Document headers, stack trace, DB error\n\n## Terminal Examples:\n\n\`\`\`bash\ncurl -X GET http://localhost:3000/invalid_route -v\n\`\`\`\n\n## Expected Output:\n\n- HTTP/1.1 500 Internal Server Error\n- X-Powered-By: Express\n- Stack Trace/DB Error in response body or logs\n\n---" > "$folder/To-Do.md"
done

