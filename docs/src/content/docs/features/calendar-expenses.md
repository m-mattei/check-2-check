---
title: Calendar Expenses
---

## Overview

The Calendar screen now displays expenses alongside paychecks to provide a complete view of the user's financial schedule.

## Features

### Combined Event Stream

- Calendar subscribes to both `streamPaychecks()` and `streamExpenses()`
- Events are combined and keyed by date in the calendar event map

### Visual Differentiation

- **Paychecks**: Green circle markers
- **Expenses**: Red circle markers

### Day Detail Panel

When a user selects a day on the calendar:
- Shows all paychecks for that day with assigned people as chips
- Shows all expenses for that day with assigned people as chips

## Feature Flag

- **`enableCalendarExpenses`**: Toggles expense display on calendar (defaults to `false`)
- Accessible from Dev Mode screen
