# Agent Guidance

## Investigation Scope

- When a task identifies files, symbols, or a subsystem, treat those as the initial investigation scope.
- Start from the named file or symbol, then inspect its nearest caller, implementation, or test; do not begin with a repository-wide keyword search merely to orient yourself.
- When a text search is necessary, prefer exact symbols and scope it to the owning addon path. Exclude `totalRP3/Libs`, generated files, and locale files unless directly relevant.
- Before expanding beyond that local area, form a concrete hypothesis about the controlling code path and identify the smallest check that could disprove it.
- Expand only when local evidence identifies an unresolved dependency or behavior boundary.
- Once the controlling code path and a focused validation check are identified, stop exploring and act.
- Defer validation configuration inspection until implementation unless validation behavior is itself part of the question.

## Validation

- Run the narrowest relevant automated check for changed files before repository-wide validation. Manual review and runtime checks supplement automated checks; they do not replace an applicable automated check.
- Use `pre-commit run --files <changed paths>` for focused repository checks when `pre-commit` is available.
- If `pre-commit` is unavailable, report that limitation to the user without treating it as a blocker. Run a known direct equivalent when available:
  - For Lua, run `luacheck -q <Lua files>`.
  - For XML, run `python .github/scripts/validate_xml.py <XML files>` when its Python dependency is installed.
- If neither `pre-commit` nor an applicable direct check can run, report which focused validation was unavailable.
- Use `just check` when a full repository gate is needed.
- Do not run other `just` recipes unless explicitly requested; they may modify vendored files, regenerate schemas or locales, build artifacts, or access the network.
- LuaLS diagnostics are not a normal validation gate. See Type Metadata for rules governing hand-maintained definitions.

## Validation Escalation

When `luacheck` reports an undefined global, field, or runtime-provided symbol that is valid for a supported client but absent from repository lint metadata:

- If the symbol is a supported runtime-provided API, enum, field, mixin, or global, prefer updating the appropriate lint metadata over changing production code.
- For a narrowly scoped metadata addition, the agent may update the metadata directly when the correct location and symbol are unambiguous.
- Preserve the structural shape of nested metadata declarations; when declaring a namespaced member, add the namespace with its `fields` entry rather than declaring only the namespace name.
- If the symbol's client support, ownership, or metadata shape is uncertain, report it and ask before editing.
- Do not use indirect access such as `_G` or `rawget` to silence lint warnings.

## Structure

- Place code with its owning domain: shared addon infrastructure in `totalRP3/Core`, feature-specific behavior in `totalRP3/Modules`, reusable UI components in `totalRP3/UI`, and module-specific UI in its `totalRP3/Modules/<Name>/` directory.
- Keep new files focused around a cohesive responsibility. Prefer smaller, discoverable files over adding unrelated behavior to large modules, but do not split code solely to reduce file size.

## Protected Files

- Do not edit generated schemas such as `Types/UI.xsd` directly.
- Do not edit vendored libraries under `totalRP3/Libs`, except the private `totalRP3/Libs/Ellyb` copy.
- Do not edit `CHANGELOG.md` unless explicitly requested.

## Load Order

- Load-order errors often surface only at runtime, so ensure dependencies are loaded before their consumers.
- By default, loading is controlled by `totalRP3/totalRP3.toc`.
- For a subdirectory of `totalRP3/Modules`, list the module's files in an XML file named after that directory, and load that XML file from the TOC rather than listing the module files individually.
- When adding a Lua/XML file pair to either the TOC or a module XML load list, list the Lua file first, followed by the XML file.
- Do not reorder existing TOC or module XML load lists solely to normalize them.

## Localization

- Treat `totalRP3/Locales/enUS.lua` as the source of truth for localization keys.
- Do not introduce hardcoded user-facing strings; add or reuse an enUS key and access it through `L`.
- Do not edit generated locale files directly.
- Write for the player: make the benefit or outcome clear, especially in setting labels, rather than naming only the mechanism. Keep labels concise and accurate; a direct description is better when a benefit-led label would be unclear.
- Use tooltips to explain what the player will see or what will change. Put surprising exceptions, limitations, or scope notes last, separated from the main explanation by a blank line.
- In new localized strings, prefer `|n` for a line break and `|n|n` for a blank line rather than `\n`; do not rewrite existing strings solely to standardize their line breaks.
- Prefer plain language and established in-addon terms over technical jargon. Use technical terms only when players need them to understand or operate the feature.
- Use highlights sparingly in tooltips: choose at most two short, scan-worthy phrases, and omit highlights when they add nothing. Use `|cnGREEN_FONT_COLOR:text|r` for a positive outcome or reassurance and `|cnWARNING_FONT_COLOR:text|r` for a negative consequence or warning; keep the surrounding explanation readable without relying on color alone.
- Check the relevant behavior before writing. If it is still unclear what players will see or whether an exception needs calling out, ask rather than guess. If only the choice of highlight is unclear, leave the text unhighlighted instead of asking about a stylistic preference.

## Persisted Data

- When changing the persisted shape or meaning of SavedVariables data, inspect `Core/Flyway.lua` and `Core/FlywayPatches.lua`. Add a migration patch and increment `SCHEMA_VERSION` when existing saved data requires conversion.

## Type Metadata

- `Types/*.d.lua` files are hand-maintained type metadata. Change them only when a production-code contract requires it.
- Keep annotations accurate when changing those contracts, but do not change production code solely to satisfy an editor-only LuaLS diagnostic.

## Client-Specific Behavior

- Code targets WoW's Lua 5.1-compatible runtime and repository-provided APIs.
- Supported client flavors are Classic Era (Vanilla), Classic Anniversary (TBC), Classic Progression (Mists of Pandaria), Standard, and Forever.
- For client-specific functionality, prefer TOC load directives or file overlays. State the relevant `AllowLoadGameType` boundary when one controls the behavior.
- When load-time separation is not suitable, check for the specific API or function at runtime rather than branching on `WOW_PROJECT_ID`.
- Use `WOW_PROJECT_ID` branching only when neither approach is suitable.
- For client-sensitive changes, report which supported client flavors and API or TOC boundaries were reasoned about. Do not claim coverage for flavors not considered.

## Code Style

- Follow `.editorconfig` for generalized file formatting.
- Use PascalCase for functions, tables of constants, and identifier-like members where practical. In UI code, this includes fields that identify or reference child UI objects and XML `parentKey` values.
- Existing enum tables and members may use SHOUT_CASE; preserve that convention when modifying them. New enum tables and members should use PascalCase unless they must match an established public API or external contract.
- Use camelCase for local variables, parameters, and ordinary data fields, including data fields on UI objects. For example: `local otherFrame = frame`, `self.OtherFrame = otherFrame`, `frame.localState = 1`, and `<Frame parentKey="OtherFrame"/>`.
- Use PascalCase for locally scoped scalar constants by default; SHOUT_CASE is also acceptable when visibility is useful.
- Start new Lua and XML files with the repository's standard copyright and SPDX license header, matching nearby files.
- Follow the `TRP3_` prefix convention for new global frame names and mixins.
- Avoid reformatting unrelated code.
- Preserve surrounding function and lifecycle-handler ordering when practical.

## Imports

- Library and namespace aliases are acceptable when they improve readability.
- Avoid large blocks of module-wide local aliases for functions.
- Prefer qualified calls such as `TRP3_API.utils.str.sanitize(...)` so a function's origin remains visible.
- When a local function alias is useful, keep it narrow in scope and use a name that matches the referenced function.
- For new code, prefer a module-wide `local L = TRP3_API.loc` when accessing translated strings.

## Objects and Composition

See the leading comment and implementation in [totalRP3/Core/Prototype.lua](totalRP3/Core/Prototype.lua) for the repository's prototype-based object model, inheritance, and lifecycle conventions.

- Use `TRP3_API.AllocateObject(prototype)` to create a new object through its prototype.
- Use `TRP3_API.SetObjectPrototype(object, prototype)` to associate a prototype with an existing or preallocated table.
- When an initialization step is needed, invoke `object:__init(...)` explicitly. Keeping initialization signatures explicit also supports accurate type metadata.
- Do not migrate existing `CreateObject` usage solely to follow this preference.
- Use mixins for shared behavior and state, including on objects created through the prototype APIs. Keep initialization dependencies explicit by calling the relevant `__init` methods.

## UI Components

- UI frames and regions cannot use the prototype object model. Use mixins for UI composition and lifecycle behavior.
- Keep XML declarative. Do not add or expand inline Lua logic in XML script blocks; put behavior in a mixin instead.
- When changing existing inline Lua logic, suggest moving it to a mixin and ask whether that refactor should be included.
- In UI mixins, define `OnLoad` first, followed by other script handlers such as `OnShow` and `OnHide`, then the remaining methods.

## Reporting and Responsibility

- An agent cannot run the game or load the addon. Passing validation does not necessarily mean that the change works in-game. Do not describe a change as tested or verified on that basis.
- Treat any change touching UI frames, script handlers, event registration, or runtime API access as unverified regardless of what static checks report.
- Conclude every change with a short report covering:
  - what changed and why;
  - which checks were run, and their results;
  - what requires in-client testing;
  - any assumption not confirmed by reading the relevant code, including which clients the change was and was not reasoned about.
- State uncertainty plainly rather than silently resolving it. If a requirement is ambiguous, ask, or implement one reading and say which.
- The contributor, not the agent, is responsible for understanding, validating, and explaining the change. The report is material for that review, not a sign-off that replaces it.
