---
name: c-code
description: Guidance for editing C code in tibblify. Use when working in src/, adding C functions, or touching the C/R interface.
---

# C code in tibblify

## Directory layout

- `src/` — tibblify's C code. Edit freely.
- `src/rlang/` — vendored rlang C API. **Do not edit directly.**
- `src/rlang-rcc.cpp` and `src/rlang.c` — include points for vendored rlang. **Do not edit directly.**

## Key files

| File | Purpose |
|---|---|
| `collector.h` / `collector.c` | Collector structs — the core data structure |
| `add-value.h` / `add-value.c` | Adding values to collectors during parsing |
| `parse-spec.h` / `parse-spec.c` | Parsing `tib_*()` spec objects from R |
| `tibblify.c` | `.Call()` entry points |
| `init.c` | `R_registerRoutines` / `R_useDynamicSymbols` |
| `finalize.c` | Finalizing collectors into output |

## Building

`devtools::load_all()` compiles automatically. For a clean rebuild:

```r
pkgbuild::compile_dll(debug = TRUE)
```

## C APIs

- **rlang C API:** Headers live in `src/rlang/` (e.g. `rlang/rlang.h`).
  `PKG_CPPFLAGS = -I./rlang` is set in `Makevars`.
- **vctrs C API:** Available via `LinkingTo: vctrs`; use `vctrs/vctrs.h`.

## Registering a new C function

1. Write the C function; declare it in the corresponding `.h` file.
2. Add an entry to `R_CallMethodDef CallEntries[]` in `init.c`.
3. Add an R wrapper using `.Call()` in the appropriate `R/` file.
4. Document the R wrapper using the `document` skill.

## Visibility

`Makevars` sets `-fvisibility=hidden`. Only symbols listed in `CallEntries`
are public — all other symbols are hidden by default.

## Testing

All C code is tested through R wrappers in `tests/testthat/`. There are no
standalone C tests; write R-level tests for every new C function.

## Updating vendored rlang

Updating `src/rlang/` is handled by the `rlang-c.yaml` workflow. To update
manually, follow that workflow — do not hand-edit files in `src/rlang/`.
