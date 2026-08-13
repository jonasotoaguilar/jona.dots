# API Documentation: {API Name}

{One paragraph: what this API does, who should use it, and why it exists.}

## Quick Path

1. Read the base URL and auth requirements.
2. Try the primary endpoint example.
3. Verify the expected success response.
4. Use the error table when requests fail.

## Overview

{1-2 sentences on what this API does and who it's for}

## Details

| Topic | Decision |
|------|----------|
| Base URL | `{https://api.example.com/v1}` |
| Auth | {Bearer token / API key / OAuth} |
| Rate limit | {Requests per window} |
| Pagination | {Cursor / offset / none} |

## Getting Started

### Base URL
```
{https://api.example.com/v1}
```

### Authentication
{Describe auth method: Bearer token, API key, OAuth, etc.}

```
Authorization: Bearer YOUR_TOKEN
```

### Rate Limiting
{Requests per window, headers returned, retry strategy}

## Endpoints

### {HTTP Method} {/path}

{Description of what this endpoint does}

**Authentication:** {Required/Optional}

#### Request

**Path Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `id` | string | Yes | The resource ID |

**Query Parameters:**

| Name | Type | Required | Default | Description |
|------|------|----------|---------|-------------|
| `limit` | integer | No | 20 | Max results per page |
| `page` | integer | No | 1 | Page number |

**Request Headers:**

| Name | Required | Description |
|------|----------|-------------|
| `Authorization` | Yes | Bearer token |
| `Content-Type` | Yes | `application/json` |

**Request Body:**

```json
{
  "field": "value",
  "nested": {
    "subfield": "value"
  }
}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `field` | string | Yes | {description} |
| `nested.subfield` | string | No | {description} |

#### Response

**Success Response:**

`200 OK`

```json
{
  "id": "res_123",
  "field": "value",
  "createdAt": "2026-01-20T10:30:00Z"
}
```

**Error Responses:**

| Status | Code | Message | Solution |
|--------|------|---------|----------|
| `400` | `VALIDATION_ERROR` | Invalid input | Check request body format |
| `401` | `UNAUTHORIZED` | Missing token | Include `Authorization` header |
| `404` | `NOT_FOUND` | Resource missing | Verify the resource ID |
| `429` | `RATE_LIMITED` | Too many requests | Wait and retry with backoff |
| `500` | `INTERNAL_ERROR` | Server error | Retry or contact support |

#### Code Examples

**cURL:**
```bash
curl -X POST https://api.example.com/v1/resource \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"field": "value"}'
```

**JavaScript (fetch):**
```javascript
const response = await fetch('https://api.example.com/v1/resource', {
  method: 'POST',
  headers: {
    'Authorization': `Bearer ${token}`,
    'Content-Type': 'application/json'
  },
  body: JSON.stringify({ field: 'value' })
});
const data = await response.json();
```

**Python (requests):**
```python
import requests

response = requests.post(
    'https://api.example.com/v1/resource',
    headers={
        'Authorization': f'Bearer {token}',
        'Content-Type': 'application/json'
    },
    json={'field': 'value'}
)
data = response.json()
```

## Common Use Cases

### {Use Case Name}
{Step-by-step walkthrough with code}

## Pagination

{How pagination works: cursor-based vs offset, response format}

## Error Handling

All errors follow this format:

```json
{
  "error": {
    "code": "ERROR_CODE",
    "message": "Human-readable message",
    "details": {}
  }
}
```

## Changelog

| Date | Version | Changes |
|------|---------|---------|
| YYYY-MM-DD | v1.0 | Initial release |

## Checklist

- [ ] Happy path is documented.
- [ ] Error responses are documented.
- [ ] Auth requirements are explicit.
- [ ] Code examples match the documented endpoint.

## Next Step

Link to the OpenAPI spec or related integration guide.
