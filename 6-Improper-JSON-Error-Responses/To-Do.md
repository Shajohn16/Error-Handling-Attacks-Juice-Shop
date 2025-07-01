# ✅ TO-DO for 6-Improper-JSON-Error-Responses

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
