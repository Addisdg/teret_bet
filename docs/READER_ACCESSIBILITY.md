# Reader Responsiveness and Accessibility

## Responsive behavior

- Portrait and taller windows keep the illustration above the story text.
- Landscape and short-height windows place illustration and text side by side.
- The story text remains independently scrollable at large text scales.
- Short-height windows replace the tall slider/button panel with compact,
  reachable previous/next and text-size controls.
- Swipe navigation remains available, but visible buttons are always present.

## Semantics

- Reader illustrations expose a localized image label and page number.
- The tap-to-hide gesture exposes a localized semantic action; it is not the
  only way to navigate or resize text.
- Language and compact navigation controls have localized labels and minimum
  Material touch targets.
- Each story card exposes a localized “title, open story” button label while
  retaining a separate localized favourite-button action.

## Automated evidence

The reader widget test uses an 800 x 400 landscape viewport with 160 percent
system text scaling. It checks for overflow exceptions, reachable controls,
Android touch-target guidance, labeled tap targets, page navigation, and
same-page language switching.

The full Discover/Favourites/Settings shell is also tested at a Pixel-sized
411 x 914 logical viewport with 200 percent system text scaling. It must render
without overflow, meet Android touch-target and labeled-target guidance, open
Settings, and keep below-fold controls reachable by scrolling.

Automated checks supplement rather than replace Pixel 8a TalkBack, portrait,
landscape, and maximum-text manual verification before release.
