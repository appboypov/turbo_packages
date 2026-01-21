# Request: Refactor Navigation to Route-Based Contextual Button System

## Source Input

From Linear issue TURBO-22:

> Refactor navigation to use route-based contextual button system
>
> - Make the contextual button updates part of the router and view model - remove the app bar default
> - Update the navigation animations
>
> 1. Create model that translates to buttons
> 2. Button builder
> 3. Put all the routes into an enum
> 4. Place the routes code inside the enum (extension) methods
> 5. Place routes inside the navigation tabs - pass it through the navigation methods
> 6. Listen to the current route -> translate that to enum -> fetch the buttons config from the buttons service
> 7. Saving buttons config to service must be a callback which always returns nullable and has checks to confirm that viewmodel is mounted before showing the buttons
> 8. Update the TViewModel interface to force implementation of contextual buttons getter of list of models - automatically remove buttons upon dispose
> 9. Provide utility methods for hiding the buttons programmatically
> 10. Automatically switch between web/desktop and mobile variation

## Current Understanding

**Current State (from codebase exploration):**
- App bar actions are passed directly as `List<Widget>` to `TSliverAppBar`
- `ContextualButtonsService` exists but wraps `TContextualButtonsService` from turbo_widgets
- `TViewModel` base class already has protected access to `contextualButtonsService`
- Routes defined in `base_router_service.dart` using GoRouter with `StatefulShellRoute`
- `NavigationTab` enum exists with single `home` value
- No route enum currently exists - routes are hardcoded strings in routers

**Proposed Changes (interpreted):**
1. Create `ContextualButtonModel` - data model for button configuration
2. Create builder/factory to convert models to widgets
3. Create `AppRoute` enum containing all application routes
4. Move route path/builder logic into enum extension methods
5. Link navigation tabs to specific routes
6. Route change listener → triggers button config fetch from service
7. Safe callback pattern for setting buttons (null-safe, mounted-check)
8. `TViewModel` requires `contextualButtons` getter, auto-cleanup on dispose
9. Utility methods to show/hide buttons programmatically
10. Platform-aware button rendering (FAB on mobile, app bar on desktop/web)

## Identified Ambiguities

1. **Button model structure** - What properties? icon, label, onPressed, isDestructive, position?
2. **Platform variations** - Mobile uses FAB only? Or FAB + app bar? Desktop/web uses app bar only?
3. **Animation updates** - What navigation animations need changing? Page transitions? Button appearance?
4. **Route enum scope** - All routes including auth? Or just post-auth routes?
5. **Button positioning** - Leading vs trailing in app bar? Primary vs secondary actions?
6. **Existing turbo_widgets integration** - Replace TContextualButtonsService or extend it?
7. **NavigationTab relationship** - Each tab has default buttons? Or purely route-driven?
8. **Multiple button support** - Single FAB on mobile or expandable FAB menu?
9. **Button visibility conditions** - Beyond mounted check, any auth/permission conditions?
10. **Default buttons concept** - Remove entirely or make route-specific default optional?

## Decisions

1. **Button model structure**: icon, label, onPressed callback, optional tooltip. No position enum - position determined elsewhere (likely by list order or separate configuration).

## Final Intent

_(To be populated when user confirms 100% intent capture)_
