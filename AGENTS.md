# Agent Guidance

## Investigation Scope

- When a task identifies files, symbols, or a subsystem, treat those as the initial investigation scope.
- Read the named files and their nearest callers or implementations before searching elsewhere.
- Prefer exact symbol searches over broad keyword searches.
- Do not scan vendored libraries, generated files, locale files, or unrelated modules unless the task requires them.
- Expand the scope only when local evidence identifies an unresolved dependency or behavior boundary.
- Once the controlling code path and a focused validation check are identified, stop exploring and act.

## Validation

- Run the narrowest relevant validation available for changed files before repository-wide validation.
- Prefer focused checks such as pre-commit checks, linting, type checking, schema validation, or a targeted runtime/manual check.
- Use `just check` when full validation is needed. Do not run other `just` recipes unless explicitly requested.
- LuaLS diagnostics are out of scope for normal validation. Do not inspect, run, or fix annotation warnings as part of routine validation.
- Treat this section as implementation-stage guidance; do not scan validation configuration during initial architecture discovery unless validation behavior is itself part of the question.

## Validation Escalation

When `just check` reports an undefined global, field, or runtime-provided symbol that is valid for a supported client but absent from repository lint metadata:

- If the symbol is a supported runtime-provided API, enum, field, mixin, or global, prefer updating the appropriate lint metadata over changing production code.
- For a narrowly scoped metadata addition, the agent may update the metadata directly when the correct location and symbol are unambiguous.
- If the symbol's client support, ownership, or metadata shape is uncertain, report it and ask before editing.
- Do not use indirect access such as `_G` or `rawget` to silence lint warnings.

## Structure

- Place code with its owning domain: shared addon infrastructure in `totalRP3/Core`, feature-specific behavior in `totalRP3/Modules`, and reusable UI components in `totalRP3/UI`.
- Keep new files focused around a cohesive responsibility. Prefer smaller, discoverable files over adding unrelated behavior to large modules, but do not split code solely to reduce file size.
- Preserve required load order when adding files. Follow the established loading convention for the owning directory, whether that is the TOC or a directory-level XML file.
- Treat `totalRP3/Locales/enUS.lua` as the source of truth for localization keys; do not edit generated locale files or `Types/UI.xsd` directly.
- Do not edit vendored libraries under `totalRP3/Libs`, except the private `totalRP3/Libs/Ellyb` copy.

## Client-Specific Behavior

- Code targets WoW's Lua 5.1-compatible runtime and repository-provided APIs.
- For client-specific functionality, prefer TOC load directives or file overlays.
- When load-time separation is not suitable, check for the specific API or function at runtime rather than branching on `WOW_PROJECT_ID`.
- Use `WOW_PROJECT_ID` branching only when neither approach is suitable.

## Code Style

- Follow `.editorconfig` for generalized file formatting.
- Use PascalCase for functions and enum-like tables and members where practical.
- Match the surrounding module's convention for constants.
- Start new Lua and XML files with the repository's standard copyright and SPDX license header, matching nearby files.
- Follow the `TRP3_` prefix convention for new global frame names and mixins.
- Avoid reformatting unrelated code.

## Imports

- Library and namespace aliases are acceptable when they improve readability.
- Avoid large blocks of module-wide local aliases for functions.
- Prefer qualified calls such as `TRP3_API.utils.str.sanitize(...)` so a function's origin remains visible.
- When a local function alias is useful, keep it narrow in scope and use a name that matches the referenced function.
- For new code, prefer a module-wide `local L = TRP3_API.loc` when accessing translated strings.

## Objects and Composition

See the leading comment and implementation in [totalRP3/Core/Prototype.lua](totalRP3/Core/Prototype.lua) for the repository's prototype-based object model, inheritance, and lifecycle conventions.

- For new code, prefer explicit construction with `TRP3_API.AllocateObject` and/or `TRP3_API.SetObjectPrototype`, followed by an explicit `object:__init(...)` call. This keeps initialization signatures visible to LuaLS. Existing `CreateObject` usage does not need to be changed solely for this preference.
- Use mixins for shared behavior and state, including on objects created through the prototype APIs. Keep initialization dependencies explicit by calling the relevant `__init` methods.

## UI Components

- UI frames and regions cannot use the prototype object model. Use mixins for UI composition and lifecycle behavior.
- Keep XML declarative. Do not add or expand inline Lua logic in XML script blocks; put behavior in a mixin instead.
- When changing existing inline Lua logic, suggest moving it to a mixin and ask whether that refactor should be included.
- In UI mixins, define `OnLoad` first, followed by other script handlers such as `OnShow` and `OnHide`, then the remaining methods.
