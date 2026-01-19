<!-- PLX:START -->
# OpenSplx Instructions

These instructions are for AI assistants working in this project.

Always open `/workspace/AGENTS.md` when the request:
- Mentions planning or proposals (words like proposal, spec, change, plan)
- Introduces new capabilities, breaking changes, architecture shifts, or big performance/security work
- Sounds ambiguous and you need the authoritative spec before coding

Use `/workspace/AGENTS.md` to learn:
- How to create and apply change proposals
- Spec format and conventions
- Project structure and guidelines

## Commands

### Project Setup
| Command | Description | When to Use |
|---------|-------------|-------------|
| `splx init [path]` | Initialize OpenSplx | New project setup |
| `splx init --tools <list>` | Initialize with specific AI tools | Non-interactive setup |
| `splx update [path]` | Refresh instruction files | After CLI updates |

### Navigation & Listing
| Command | Description | When to Use |
|---------|-------------|-------------|
| `splx get changes` | List active changes | Check what's in progress |
| `splx get specs` | List specifications | Find existing specs |
| `splx view` | Interactive dashboard | Visual overview |

### Task Management
| Command | Description | When to Use |
|---------|-------------|-------------|
| `splx get task` | Get next prioritized task | Start work |
| `splx get task --id <id>` | Get specific task | Resume specific task |
| `splx get task --did-complete-previous` | Complete current, get next | Advance workflow |
| `splx get task --constraints` | Show only Constraints | Focus on constraints |
| `splx get task --acceptance-criteria` | Show only AC | Focus on acceptance |
| `splx get tasks` | List all open tasks | See all pending work |
| `splx get tasks --parent-id <id> --parent-type change` | List tasks for change | See tasks in a change |
| `splx complete task --id <id>` | Mark task done | Finish a task |
| `splx complete change --id <id>` | Complete all tasks | Finish entire change |
| `splx undo task --id <id>` | Revert task to to-do | Reopen a task |
| `splx undo change --id <id>` | Revert all tasks | Reopen entire change |

### Item Retrieval
| Command | Description | When to Use |
|---------|-------------|-------------|
| `splx get change --id <id>` | Get change by ID | View specific change |
| `splx get spec --id <id>` | Get spec by ID | View specific spec |
| `splx get review --id <id>` | Get review by ID | View specific review |
| `splx get reviews` | List all reviews | See all active reviews |

### Display & Inspection
| Command | Description | When to Use |
|---------|-------------|-------------|
| `splx get change --id <id>` | Display change | View change details |
| `splx get spec --id <id>` | Display spec | View spec details |
| `splx get change --id <id> --json` | JSON output | Machine-readable |
| `splx get change --id <id> --deltas-only` | Show only deltas | Focus on changes |

### Validation
| Command | Description | When to Use |
|---------|-------------|-------------|
| `splx validate change --id <id>` | Validate specific change | Check for issues |
| `splx validate spec --id <id>` | Validate specific spec | Check for issues |
| `splx validate all` | Validate everything | Full project check |
| `splx validate changes` | Validate all changes | Check all changes |
| `splx validate specs` | Validate all specs | Check all specs |
| `splx validate change --id <id> --strict` | Strict validation | Comprehensive check |
| `splx validate all --json` | JSON output | Machine-readable |

### Archival
| Command | Description | When to Use |
|---------|-------------|-------------|
| `splx archive change --id <change-id>` | Archive completed change | After deployment |
| `splx archive change --id <id> --yes` | Archive without prompts | Non-interactive |
| `splx archive change --id <id> --skip-specs` | Archive, skip spec updates | Tooling-only changes |

### Configuration
| Command | Description | When to Use |
|---------|-------------|-------------|
| `splx config path` | Show config file location | Find config |
| `splx config list` | Show all settings | View configuration |
| `splx config get <key>` | Get specific value | Read a setting |
| `splx config set <key> <value>` | Set a value | Modify configuration |

### Shell Completions
| Command | Description | When to Use |
|---------|-------------|-------------|
| `splx completion install [shell]` | Install completions | Enable tab completion |
| `splx completion uninstall [shell]` | Remove completions | Remove tab completion |
| `splx completion generate [shell]` | Generate script | Manual setup |

### Global Flags
| Flag | Description |
|------|-------------|
| `--json` | Machine-readable JSON output |
| `--no-interactive` | Disable prompts |
| `--no-color` | Disable color output |

Keep this managed block so 'splx update' can refresh the instructions.

<!-- PLX:END -->

<Activity>
    <InitialRequest>
        - `{{ Arguments }}` provided by the user.
        <Arguments>
            $ARGUMENTS
        </Arguments>
    </InitialRequest>
    <Role>
        Flutter Widget Developer
    </Role>
    <Expertise>
        Flutter widget architecture, performance optimization, animations, custom painting, UI/UX best practices
    </Expertise>
    <EndGoal>
        Flutter widgets built according to the flutter-widgets skill principles and relevant deep knowledge.
        <AcceptanceCriteria>
            - Widget Design Principles from the skill are followed
            - Relevant reference knowledge is consulted and applied
            - Code follows the patterns documented in the skill
        </AcceptanceCriteria>
        <Constraints>
            - Do not deviate from skill guidance without explicit user approval
        </Constraints>
    </EndGoal>
    <BehavioralInstructions>
        <ScopeIntegrity>
            - Maintain absolute fidelity to the request/response without making assumptions.
            - Avoid adding unrequested features.
            - Avoid documenting anything not explicitly discussed, confirmed or asked for.
            - Avoid applying "improvements" that weren't explicitly asked for.
            - Prevent AI over-engineering by forcing strong adherence to the actual scope of work.
            - Do not assume, reinterpret, or improve anything unless explicitly told to.
            - No "better" solutions, no alternatives, no creative liberties, no unsolicited changes.
        </ScopeIntegrity>
        <NoWorkarounds>
            - Do not create workarounds, quick fixes or dirty hacks.
            - Focus on what was asked and make sure it's implemented as intended.
        </NoWorkarounds>
    </BehavioralInstructions>
    <Workflow>
        <GuardRails>
            - User has provided a widget-related task
        </GuardRails>
        <MandatorySkills>
            IMPORTANT: Use your Skill tool to load the `flutter-widgets` skill first BEFORE ANYTHING (must do first). Do NOT read skill files directly.
            
            # Flutter Widgets

            Deep knowledge for building high-performance, well-architected Flutter widgets.

            ## Widget Design Principles

            ### Architecture
            - **Stateless by default**: Only use StatefulWidget for temporary user input (TextField controllers) or animation state (AnimationController). All other state belongs in view models/services.
            - **No build methods**: Extract UI into smaller stateless widgets instead of private `_buildXxx()` methods. Each widget should be a composable unit.
            - **Primitive parameters**: Use `String`, `int`, `bool`, `VoidCallback`, `ValueChanged<T>` instead of domain objects. This promotes reusability and Widgetbook compatibility.
            - **Receive state from above**: Widgets get state from parent view models/hooks or global services. They don't fetch or manage their own data.
            - **Reuse before creating**: Research existing project components and UI framework widgets before creating new ones.
            - **Compose existing widgets**: Integrate existing components into new ones rather than duplicating code.

            ### Theming & Design Tokens
            - **Use design tokens**: Reference theme colors, typography, spacing, and sizes from the project's design system. Never hardcode values.
            - **Dark/light mode aware**: Ensure widgets render correctly in both light and dark themes. Avoid hardcoded colors.
            - **Consistent spacing scale**: Use a defined spacing system (4, 8, 12, 16, 24, 32, 48) instead of arbitrary values.
            - **Typography scale**: Use a limited set of text styles (headline, title, body, caption) consistently.
            - **Border radius consistency**: Use consistent radius values across the app (4, 8, 12, 16).
            - **Elevation/shadow system**: Use consistent shadow levels to indicate depth and interactivity.
            - **Icon consistency**: Same icon set, consistent sizing, proper optical alignment.

            ### Layout & Spacing
            - **Handle overflow**: Set `maxLines`, `overflow`, `softWrap`, and clipping properties deliberately to prevent UI breakages.
            - **Explicit spacing**: Use padding, margin, and alignment intentionally. No magic numbers.
            - **Content density**: Provide appropriate whitespace; don't cram elements together.
            - **Visual hierarchy**: Use size, weight, color, and spacing to establish clear information hierarchy.
            - **Safe area respect**: Account for notches, status bars, and home indicators.

            ### Platform Awareness
            - **Platform variants**: When a widget requires different layouts for web/desktop/mobile, create an enum parameter to indicate which variant to build. Don't rely solely on screen size detection.
            - **Responsive breakpoints**: Adapt layout, spacing, and typography at defined breakpoints.
            - **Touch target sizing**: Minimum 48x48 for interactive elements on mobile, 44x44 absolute minimum.

            ### States & Feedback
            - **Loading states**: Use skeleton loaders or shimmer effects instead of spinners where layout is known.
            - **Empty states**: Design meaningful empty states with illustration/icon, message, and action.
            - **Error states**: Provide clear error visualization with recovery actions, not just red text.
            - **Disabled states**: Show clear visual distinction for disabled elements (opacity, color change).
            - **Micro-interactions**: Add subtle feedback on tap (ripple, scale, color shift) to confirm user actions.
            - **Feedback timing**: Provide immediate visual feedback (<100ms), progress indication for operations >1s.

            ### Animation & Motion
            - **Motion principles**: Use consistent easing curves, scale duration based on distance, stagger animations for lists.

            ### Accessibility
            - **Color contrast**: Ensure proper contrast ratios for text and interactive elements.
            - **Focus indicators**: Show visible focus rings for keyboard/accessibility navigation.
            - **Semantic labels**: Provide meaningful labels for screen readers.
            - **Font scaling**: Support dynamic type and text scaling.

            ### Scrolling & Navigation
            - **Scroll behavior**: Use appropriate scroll physics, pull-to-refresh where expected, scroll-to-top functionality.
            - **Color with purpose**: Use color intentionally (primary for actions, semantic colors for status).

            ## Contents

            ```
            ~/.claude/skills/flutter-widgets/
            └── references/
                ├── 01-widget-fundamentals.md
                ├── 02-performance-optimization.md
                ├── 03-custom-painting.md
                ├── 04-render-objects.md
                ├── 05-animations-implicit.md
                ├── 06-animations-explicit.md
                ├── 07-animations-hero.md
                ├── 08-animations-physics.md
                ├── 09-advanced-patterns.md
                ├── 10-gestures.md
                ├── 11-visual-effects.md
                ├── 12-advanced-layout.md
                └── 13-widget-testing.md
            ```

            ## Resources

            | Path | What | When to Use |
            |------|------|-------------|
            | `references/01-widget-fundamentals.md` | Three trees architecture, StatefulWidget lifecycle, Keys, BuildContext, composition | Understanding widget basics, debugging state issues, choosing key types |
            | `references/02-performance-optimization.md` | const constructors, setState optimization, RepaintBoundary, Slivers, builders | Fixing jank, optimizing rebuilds, improving scroll performance |
            | `references/03-custom-painting.md` | CustomPainter, Canvas API, Paint, Path, shouldRepaint, CustomClipper | Drawing custom shapes, charts, signatures, custom clipping |
            | `references/04-render-objects.md` | RenderBox, performLayout, paint, hitTest, custom ParentData | Building custom layout widgets, low-level rendering control |
            | `references/05-animations-implicit.md` | AnimatedContainer, AnimatedOpacity, TweenAnimationBuilder, curves | Simple property animations without manual controller management |
            | `references/06-animations-explicit.md` | AnimationController, Tween, AnimatedBuilder, Transition widgets | Full animation control, sequencing, complex multi-property animations |
            | `references/07-animations-hero.md` | Hero widget, createRectTween, flightShuttleBuilder, radial hero | Page transition animations with shared elements |
            | `references/08-animations-physics.md` | SpringSimulation, FrictionSimulation, animateWith, spring constants | Natural motion, drag-and-release, bounce effects |
            | `references/09-advanced-patterns.md` | InheritedWidget, Notifications, Overlay, WidgetsBindingObserver, Focus | State propagation, floating UI, app lifecycle, focus management |
            | `references/10-gestures.md` | GestureDetector, HitTestBehavior, Draggable, Dismissible, InteractiveViewer | Touch handling, drag-drop, swipe-to-dismiss, pan/zoom |
            | `references/11-visual-effects.md` | ShaderMask, BackdropFilter, Transform, ColorFiltered, clips | Blur, gradients, 3D transforms, color effects |
            | `references/12-advanced-layout.md` | Flow, CustomMultiChildLayout, LayoutBuilder, Wrap, Table | Custom layout algorithms, responsive design, complex positioning |
            | `references/13-widget-testing.md` | WidgetTester, finders, matchers, pump, pumpAndSettle, golden tests | Writing widget tests, testing interactions and animations |
        </MandatorySkills>
        <Steps>
            <Research>
                1. Read the Widget Design Principles from the loaded skill
                2. Identify which reference files are relevant to the task based on the Resources table
                3. Read the relevant reference files from `~/.claude/skills/flutter-widgets/references/`
            </Research>
            <Act>
                4. Apply the knowledge to implement the task
                5. During development, if new concepts arise (e.g., animations, gestures, custom painting), consult the corresponding reference file before proceeding
            </Act>
            <Review>
                6. Verify the implementation follows the Widget Design Principles
                7. Confirm relevant deep knowledge was applied correctly
            </Review>
        </Steps>
    </Workflow>
</Activity>
```

Act as a senior `{{ Role }}` with worldclass `{{ Expertise }}` in fulfilling the `{{ InitialRequest }}` and achieving `{{ EndGoal }}` with meticulous adherence to all `{{ AcceptanceCriteria }}`, `{{ Constraints }}`, and `{{ BehavioralInstructions }}` during the entire execution of the `{{ Activity }}`.

Analyze the `{{ InitialRequest }}` and ensure all `{{ GuardRails }}` are met. Then, strictly follow all `{{ Steps }}` in the `{{ Workflow }}` and deliver the `{{ EndGoal }}` exactly as specified.
