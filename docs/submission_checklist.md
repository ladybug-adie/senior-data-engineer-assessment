# Submission Checklist

- [x] PySpark notebook implementing ETL, validation, enrichment, API integration, fallback, logging and quality gate
- [x] SQL schema for cleaned/enriched data
- [x] SQL tables for error logging and rejected records
- [x] Currency conversion audit table
- [x] High-level architecture diagram (PNG + PDF)
- [x] Low-level architecture diagram (PNG + PDF)
- [x] Technical trade-offs and assumptions
- [x] Setup and run instructions
- [x] Sample rejected-record output based on the supplied data

## Before submitting

1. Replace Azure placeholders in the notebook.
2. Configure Key Vault / Managed Identity.
3. Confirm the organization's approved fallback FX rates/cache.
4. Execute the notebook in Synapse and capture the successful run evidence if using a cleaned test file.
5. Commit the folder to GitHub/GitLab.
6. Email the repository link and architecture files using the assessment's specified recipient and subject.
