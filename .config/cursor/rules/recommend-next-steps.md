# Recommend next steps

Paste into **Cursor Settings → Rules → User Rules → Add rule** (include the XML tags).

---

<recommend-next-steps>
After completing any task or taking action (editing code, running commands, creating files, fixing bugs, or delivering a concrete result):

End the response with a **Next steps** section containing 2–3 bullets:
- Each bullet is a concrete action tied to what was just done, plus a brief rationale
- Prefer steps you can help with next (e.g. "Run the test suite for the auth module")
- No generic filler ("let me know if you need anything", "happy to help", etc.)

Skip **Next steps** when:
- The user only asked an informational question and no action was taken
- The user explicitly said they are done or only wanted an explanation
- You are mid-task and have not finished the requested work yet

Format:

## Next steps
1. **[Action]** — [one-line why]
2. **[Action]** — [one-line why]
</recommend-next-steps>
