#include "stbl.h"

/* chr -> * */
SEXP (*stbl_chr_to_lgl)(SEXP)                 = NULL;
SEXP (*stbl_chr_are_lglish)(SEXP)             = NULL;
SEXP (*stbl_chr_to_int)(SEXP)                 = NULL;
SEXP (*stbl_chr_are_intish)(SEXP)             = NULL;
SEXP (*stbl_chr_to_dbl)(SEXP)                 = NULL;
SEXP (*stbl_chr_are_dblish)(SEXP)             = NULL;
SEXP (*stbl_chr_are_fctish)(SEXP, SEXP, SEXP) = NULL;
SEXP (*stbl_chr_to_fct)(SEXP, SEXP, SEXP)     = NULL;

/* dbl -> * */
SEXP (*stbl_dbl_to_int)(SEXP)                 = NULL;
SEXP (*stbl_dbl_are_intish)(SEXP)             = NULL;
SEXP (*stbl_dbl_to_lgl)(SEXP)                 = NULL;
SEXP (*stbl_dbl_are_lglish)(SEXP)             = NULL;
SEXP (*stbl_dbl_to_chr)(SEXP)                 = NULL;
SEXP (*stbl_dbl_are_chrish)(SEXP)             = NULL;

/* int -> * */
SEXP (*stbl_int_to_dbl)(SEXP)                 = NULL;
SEXP (*stbl_int_are_dblish)(SEXP)             = NULL;
SEXP (*stbl_int_to_chr)(SEXP)                 = NULL;
SEXP (*stbl_int_are_chrish)(SEXP)             = NULL;
SEXP (*stbl_int_to_fct)(SEXP, SEXP, SEXP)     = NULL;

/* lgl -> * */
SEXP (*stbl_lgl_to_dbl)(SEXP)                 = NULL;
SEXP (*stbl_lgl_are_dblish)(SEXP)             = NULL;
SEXP (*stbl_lgl_to_int)(SEXP)                 = NULL;
SEXP (*stbl_lgl_are_intish)(SEXP)             = NULL;
SEXP (*stbl_lgl_to_chr)(SEXP)                 = NULL;
SEXP (*stbl_lgl_are_chrish)(SEXP)             = NULL;

/* cpx -> * */
SEXP (*stbl_cpx_to_dbl)(SEXP)                 = NULL;
SEXP (*stbl_cpx_are_dblish)(SEXP)             = NULL;
SEXP (*stbl_cpx_to_int)(SEXP)                 = NULL;
SEXP (*stbl_cpx_are_intish)(SEXP)             = NULL;

/* fct -> * */
SEXP (*stbl_fct_to_dbl)(SEXP)                 = NULL;
SEXP (*stbl_fct_are_dblish)(SEXP)             = NULL;
SEXP (*stbl_fct_to_int)(SEXP)                 = NULL;
SEXP (*stbl_fct_are_intish)(SEXP)             = NULL;
SEXP (*stbl_fct_to_lgl)(SEXP)                 = NULL;
SEXP (*stbl_fct_are_lglish)(SEXP)             = NULL;
SEXP (*stbl_fct_are_fctish)(SEXP, SEXP, SEXP) = NULL;
SEXP (*stbl_fct_to_chr)(SEXP)                 = NULL;
SEXP (*stbl_fct_are_chrish)(SEXP)             = NULL;

/* lst -> * */
SEXP (*stbl_lst_to_dbl)(SEXP)                 = NULL;
SEXP (*stbl_lst_to_int)(SEXP)                 = NULL;
SEXP (*stbl_lst_to_lgl)(SEXP)                 = NULL;
SEXP (*stbl_lst_to_chr)(SEXP)                 = NULL;
SEXP (*stbl_lst_to_fct)(SEXP)                 = NULL;

/* range checks */
SEXP (*stbl_check_min_dbl)(SEXP, SEXP)        = NULL;
SEXP (*stbl_check_max_dbl)(SEXP, SEXP)        = NULL;

void stbl_init_api(void) {
  /* chr -> * */
  stbl_chr_to_lgl     = (SEXP (*)(SEXP))             R_GetCCallable("stbl", "stbl_chr_to_lgl");
  stbl_chr_are_lglish = (SEXP (*)(SEXP))             R_GetCCallable("stbl", "stbl_chr_are_lglish");
  stbl_chr_to_int     = (SEXP (*)(SEXP))             R_GetCCallable("stbl", "stbl_chr_to_int");
  stbl_chr_are_intish = (SEXP (*)(SEXP))             R_GetCCallable("stbl", "stbl_chr_are_intish");
  stbl_chr_to_dbl     = (SEXP (*)(SEXP))             R_GetCCallable("stbl", "stbl_chr_to_dbl");
  stbl_chr_are_dblish = (SEXP (*)(SEXP))             R_GetCCallable("stbl", "stbl_chr_are_dblish");
  stbl_chr_are_fctish = (SEXP (*)(SEXP, SEXP, SEXP)) R_GetCCallable("stbl", "stbl_chr_are_fctish");
  stbl_chr_to_fct     = (SEXP (*)(SEXP, SEXP, SEXP)) R_GetCCallable("stbl", "stbl_chr_to_fct");
  /* dbl -> * */
  stbl_dbl_to_int     = (SEXP (*)(SEXP))             R_GetCCallable("stbl", "stbl_dbl_to_int");
  stbl_dbl_are_intish = (SEXP (*)(SEXP))             R_GetCCallable("stbl", "stbl_dbl_are_intish");
  stbl_dbl_to_lgl     = (SEXP (*)(SEXP))             R_GetCCallable("stbl", "stbl_dbl_to_lgl");
  stbl_dbl_are_lglish = (SEXP (*)(SEXP))             R_GetCCallable("stbl", "stbl_dbl_are_lglish");
  stbl_dbl_to_chr     = (SEXP (*)(SEXP))             R_GetCCallable("stbl", "stbl_dbl_to_chr");
  stbl_dbl_are_chrish = (SEXP (*)(SEXP))             R_GetCCallable("stbl", "stbl_dbl_are_chrish");
  /* int -> * */
  stbl_int_to_dbl     = (SEXP (*)(SEXP))             R_GetCCallable("stbl", "stbl_int_to_dbl");
  stbl_int_are_dblish = (SEXP (*)(SEXP))             R_GetCCallable("stbl", "stbl_int_are_dblish");
  stbl_int_to_chr     = (SEXP (*)(SEXP))             R_GetCCallable("stbl", "stbl_int_to_chr");
  stbl_int_are_chrish = (SEXP (*)(SEXP))             R_GetCCallable("stbl", "stbl_int_are_chrish");
  stbl_int_to_fct     = (SEXP (*)(SEXP, SEXP, SEXP)) R_GetCCallable("stbl", "stbl_int_to_fct");
  /* lgl -> * */
  stbl_lgl_to_dbl     = (SEXP (*)(SEXP))             R_GetCCallable("stbl", "stbl_lgl_to_dbl");
  stbl_lgl_are_dblish = (SEXP (*)(SEXP))             R_GetCCallable("stbl", "stbl_lgl_are_dblish");
  stbl_lgl_to_int     = (SEXP (*)(SEXP))             R_GetCCallable("stbl", "stbl_lgl_to_int");
  stbl_lgl_are_intish = (SEXP (*)(SEXP))             R_GetCCallable("stbl", "stbl_lgl_are_intish");
  stbl_lgl_to_chr     = (SEXP (*)(SEXP))             R_GetCCallable("stbl", "stbl_lgl_to_chr");
  stbl_lgl_are_chrish = (SEXP (*)(SEXP))             R_GetCCallable("stbl", "stbl_lgl_are_chrish");
  /* cpx -> * */
  stbl_cpx_to_dbl     = (SEXP (*)(SEXP))             R_GetCCallable("stbl", "stbl_cpx_to_dbl");
  stbl_cpx_are_dblish = (SEXP (*)(SEXP))             R_GetCCallable("stbl", "stbl_cpx_are_dblish");
  stbl_cpx_to_int     = (SEXP (*)(SEXP))             R_GetCCallable("stbl", "stbl_cpx_to_int");
  stbl_cpx_are_intish = (SEXP (*)(SEXP))             R_GetCCallable("stbl", "stbl_cpx_are_intish");
  /* fct -> * */
  stbl_fct_to_dbl     = (SEXP (*)(SEXP))             R_GetCCallable("stbl", "stbl_fct_to_dbl");
  stbl_fct_are_dblish = (SEXP (*)(SEXP))             R_GetCCallable("stbl", "stbl_fct_are_dblish");
  stbl_fct_to_int     = (SEXP (*)(SEXP))             R_GetCCallable("stbl", "stbl_fct_to_int");
  stbl_fct_are_intish = (SEXP (*)(SEXP))             R_GetCCallable("stbl", "stbl_fct_are_intish");
  stbl_fct_to_lgl     = (SEXP (*)(SEXP))             R_GetCCallable("stbl", "stbl_fct_to_lgl");
  stbl_fct_are_lglish = (SEXP (*)(SEXP))             R_GetCCallable("stbl", "stbl_fct_are_lglish");
  stbl_fct_are_fctish = (SEXP (*)(SEXP, SEXP, SEXP)) R_GetCCallable("stbl", "stbl_fct_are_fctish");
  stbl_fct_to_chr     = (SEXP (*)(SEXP))             R_GetCCallable("stbl", "stbl_fct_to_chr");
  stbl_fct_are_chrish = (SEXP (*)(SEXP))             R_GetCCallable("stbl", "stbl_fct_are_chrish");
  /* lst -> * */
  stbl_lst_to_dbl     = (SEXP (*)(SEXP))             R_GetCCallable("stbl", "stbl_lst_to_dbl");
  stbl_lst_to_int     = (SEXP (*)(SEXP))             R_GetCCallable("stbl", "stbl_lst_to_int");
  stbl_lst_to_lgl     = (SEXP (*)(SEXP))             R_GetCCallable("stbl", "stbl_lst_to_lgl");
  stbl_lst_to_chr     = (SEXP (*)(SEXP))             R_GetCCallable("stbl", "stbl_lst_to_chr");
  stbl_lst_to_fct     = (SEXP (*)(SEXP))             R_GetCCallable("stbl", "stbl_lst_to_fct");
  /* range checks */
  stbl_check_min_dbl  = (SEXP (*)(SEXP, SEXP))       R_GetCCallable("stbl", "stbl_check_min_dbl");
  stbl_check_max_dbl  = (SEXP (*)(SEXP, SEXP))       R_GetCCallable("stbl", "stbl_check_max_dbl");
}
