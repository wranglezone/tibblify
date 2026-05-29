#ifndef STBL_API_H
#define STBL_API_H

#include <Rinternals.h>
#include <R_ext/Rdynload.h>

/* chr -> * */
extern SEXP (*stbl_chr_to_lgl)(SEXP);
extern SEXP (*stbl_chr_are_lglish)(SEXP);
extern SEXP (*stbl_chr_to_int)(SEXP);
extern SEXP (*stbl_chr_are_intish)(SEXP);
extern SEXP (*stbl_chr_to_dbl)(SEXP);
extern SEXP (*stbl_chr_are_dblish)(SEXP);
extern SEXP (*stbl_chr_are_fctish)(SEXP, SEXP, SEXP);

/* dbl -> * */
extern SEXP (*stbl_dbl_to_int)(SEXP);
extern SEXP (*stbl_dbl_are_intish)(SEXP);
extern SEXP (*stbl_dbl_to_lgl)(SEXP);
extern SEXP (*stbl_dbl_are_lglish)(SEXP);

/* int -> * */
extern SEXP (*stbl_int_to_dbl)(SEXP);
extern SEXP (*stbl_int_are_dblish)(SEXP);

/* lgl -> * */
extern SEXP (*stbl_lgl_to_dbl)(SEXP);
extern SEXP (*stbl_lgl_are_dblish)(SEXP);
extern SEXP (*stbl_lgl_to_int)(SEXP);
extern SEXP (*stbl_lgl_are_intish)(SEXP);

/* cpx -> * */
extern SEXP (*stbl_cpx_to_dbl)(SEXP);
extern SEXP (*stbl_cpx_are_dblish)(SEXP);
extern SEXP (*stbl_cpx_to_int)(SEXP);
extern SEXP (*stbl_cpx_are_intish)(SEXP);

/* fct -> * */
extern SEXP (*stbl_fct_to_dbl)(SEXP);
extern SEXP (*stbl_fct_are_dblish)(SEXP);
extern SEXP (*stbl_fct_to_int)(SEXP);
extern SEXP (*stbl_fct_are_intish)(SEXP);
extern SEXP (*stbl_fct_to_lgl)(SEXP);
extern SEXP (*stbl_fct_are_lglish)(SEXP);
extern SEXP (*stbl_fct_are_fctish)(SEXP, SEXP, SEXP);

/* lst -> * */
extern SEXP (*stbl_lst_to_dbl)(SEXP);
extern SEXP (*stbl_lst_to_int)(SEXP);
extern SEXP (*stbl_lst_to_lgl)(SEXP);
extern SEXP (*stbl_lst_to_chr)(SEXP);
extern SEXP (*stbl_lst_to_fct)(SEXP);

/* range checks */
extern SEXP (*stbl_check_min_dbl)(SEXP, SEXP);
extern SEXP (*stbl_check_max_dbl)(SEXP, SEXP);

void stbl_init_api(void);

#endif /* STBL_API_H */
