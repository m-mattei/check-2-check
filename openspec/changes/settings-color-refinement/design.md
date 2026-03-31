## Context

The Settings screen (formerly Profile) needed to support full color customization beyond presets. The secondary color, previously stored but unused in the theme, should now drive tab bar icons and body text for a cohesive two-tone system.

## Decisions

- **Custom Color Picker**: RGB sliders in a dialog accessed via "Custom Color..." option at the bottom of the preset grid
- **Secondary Color in Theme**: Applied via `textTheme` (bodyLarge, bodyMedium, bodySmall) and `bottomNavigationBarTheme` (selectedItemColor, unselectedItemColor)
- **Tab Rename**: "Profile" → "Settings" to better reflect the screen's expanded role

## Risks / Trade-offs

- **Risk: RGB sliders are less intuitive than a wheel picker** → Acceptable for now; can upgrade to a color wheel package later
- **Risk: Secondary color on text may reduce readability** → Mitigated by using alpha 0.8 for bodySmall and 0.5 for unselected tab items
