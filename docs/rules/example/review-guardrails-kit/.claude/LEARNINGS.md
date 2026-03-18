# Learnings

- Payments code should be treated as high-risk and reviewed for regressions before merge.
- Changes that touch environment loading need explicit validation in CI and local development.
- Database-related changes should call out query shape and migration impact.
