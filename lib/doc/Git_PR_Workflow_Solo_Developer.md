# Git Pull Request Workflow (Solo Developer)

## Goal

Never push directly to `main`. Every change goes through a feature
branch and Pull Request (PR).

## One-time Repository Setup

-   Protect `main`
-   Require Pull Request before merging
-   Use **Squash and Merge**
-   Keep **Conversation Resolution** enabled
-   Required approvals: **0** (solo developer)

------------------------------------------------------------------------

## Workflow for Every Feature

### 1. Update main

``` bash
git checkout main
git pull origin main
```

### 2. Create a feature branch

``` bash
git checkout -b feature/<feature-name>
```

Example:

``` bash
git checkout -b feature/student-module
```

### 3. Make changes

Edit code, test locally.

### 4. Commit

``` bash
git add .
git commit -m "feat: add student module"
```

Commit style:

-   feat:
-   fix:
-   refactor:
-   docs:
-   test:
-   chore:

### 5. Push feature branch

``` bash
git push -u origin feature/student-module
```

### 6. Create Pull Request

On GitHub:

-   Base: `main`
-   Compare: `feature/student-module`

Title:

    feat: Add Student Module

Description:

``` md
## Summary
- Added Student CRUD
- Added Validation
- Added API Integration

## Testing
- Student Add
- Student Update
- Student Delete

## Checklist
- [x] Code tested
- [x] No analyzer errors
- [x] Ready to merge
```

### 7. Self Review

Open **Files changed** in the PR.

Check: - Naming - Formatting - No debug prints - No commented code -
Logic is correct

If changes are needed:

``` bash
git add .
git commit -m "fix: address review comments"
git push
```

The PR updates automatically.

### 8. Merge

Choose:

**Squash and Merge**

Delete the feature branch after merge.

### 9. Start Next Feature

``` bash
git checkout main
git pull origin main
git checkout -b feature/attendance
```

------------------------------------------------------------------------

# Branch Naming

    feature/auth
    feature/student
    feature/teacher
    feature/attendance
    feature/exam
    feature/payment

    bugfix/login
    hotfix/payment-crash

# Important Rules

-   Never commit directly to `main`
-   One feature = One branch
-   One feature = One PR
-   Review before merge
-   Always Squash and Merge
-   Delete feature branch after merge

# Quick Cheat Sheet

``` bash
git checkout main
git pull origin main
git checkout -b feature/my-feature

git add .
git commit -m "feat: my feature"

git push -u origin feature/my-feature

# Create PR on GitHub
# Review
# Squash & Merge

git checkout main
git pull origin main
```
