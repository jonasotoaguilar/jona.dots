# Retrieval Workflow

1. **Read local evidence first**
   - inspect UI code, CSS, Tailwind config, tokens, screenshots, or existing design docs

2. **Fetch official/reference docs when needed**
   - use `web_fetch` for official docs or user-provided references

3. **Extract real tokens**
   - colors
   - typography
   - rounded scale
   - spacing scale
   - component token mappings

4. **Infer prose from evidence**
   - explain atmosphere, hierarchy, layout behavior, depth, shape language, and component intent

5. **Do not invent unsupported precision**
   - if something is inferred, keep it clearly framed as inference
   - if exact values are unavailable, prefer omission over fabrication
