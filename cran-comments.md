## R CMD check results

0 errors | 0 warnings | 1 note

```
Check: compiled code
Result: NOTE 
  File ‘tibblify/libs/tibblify.so’:
    Found non-API calls to R: ‘PRENV’, ‘PRVALUE’, ‘R_PromiseExpr’,
      ‘Rf_allocSExp’, ‘Rf_findVarInFrame3’, ‘SETLENGTH’,
      ‘SET_GROWABLE_BIT’, ‘SET_PRCODE’, ‘SET_PRENV’, ‘SET_PRVALUE’,
      ‘SET_TRUELENGTH’
  
  Compiled code should not call non-API entry points in R.
  
  See ‘Writing portable packages’ in the ‘Writing R Extensions’ manual,
  and section ‘Moving into C API compliance’ for issues with the use of
  non-API entry points.
Flavors: r-oldrel-macos-arm64, r-oldrel-macos-x86_64
```

* This NOTE is inherited from rlang, and does not appear in any other currently tested flavors.
* This submission addresses LTO warnings:

```
init.c:42:6: warning: type of ‘tibblify_init_utils’ does not match original declaration [-Wlto-type-mismatch]
   42 | void tibblify_init_utils(SEXP ns, SEXP vctrs_ns);
      |      ^
utils.c:123:6: note: type mismatch in parameter 2
  123 | void tibblify_init_utils(SEXP ns) {
      |      ^
utils.c:123:6: note: type ‘void’ should match type ‘struct SEXPREC *’
utils.c:123:6: note: ‘tibblify_init_utils’ was previously declared here
```
