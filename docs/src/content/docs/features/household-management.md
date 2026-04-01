---
title: Household Management
---

## Overview

Users can manage household members through a dedicated screen, enabling person assignment for paychecks and expenses.

## Features

### Household Screen

- Lists all household members with avatar, name, and role
- Add new members via FAB → dialog with first name, last name, nickname, role, and color picker
- Edit members via edit button on each card
- Delete members via swipe-to-dismiss with confirmation dialog

### Settings Integration

- "Household" tile in Settings screen navigates to Household Management

### Person Model

- `firstName`, `lastName`, `nickname` — identity fields
- `displayName` — computed (nickname > firstName > fullName)
- `role` — enum for household role
- `color` — hex color string for visual distinction
- `copyWith` — for immutable updates
