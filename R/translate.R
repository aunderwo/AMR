# ==================================================================== #
# TITLE                                                                #
# Antimicrobial Resistance (AMR) Analysis                              #
#                                                                      #
# SOURCE                                                               #
# https://github.com/msberends/AMR                                     #
#                                                                      #
# LICENCE                                                              #
# (c) 2018-2020 Berends MS, Luz CF et al.                              #
#                                                                      #
# This R package is free software; you can freely use and distribute   #
# it for both personal and commercial purposes under the terms of the  #
# GNU General Public License version 2.0 (GNU GPL-2), as published by  #
# the Free Software Foundation.                                        #
#                                                                      #
# We created this package for both routine data analysis and academic  #
# research and it was publicly released in the hope that it will be    #
# useful, but it comes WITHOUT ANY WARRANTY OR LIABILITY.              #
# Visit our website for more info: https://msberends.github.io/AMR.    #
# ==================================================================== #

#' Translate strings from AMR package
#'
#' For language-dependent output of AMR functions, like [mo_name()], [mo_gramstain()], [mo_type()] and [ab_name()].
#' @inheritSection lifecycle Stable lifecycle
#' @details Strings will be translated to foreign languages if they are defined in a local translation file. Additions to this file can be suggested at our repository. The file can be found here: <https://github.com/msberends/AMR/blob/master/data-raw/translations.tsv>.
#'
#' Currently supported languages are (besides English): `r paste(sort(gsub(";.*", "", ISOcodes::ISO_639_2[which(ISOcodes::ISO_639_2$Alpha_2 %in% unique(AMR:::translations_file$lang)), "Name"])), collapse = ", ")`. Please note that currently not all these languages have translations available for all antimicrobial agents and colloquial microorganism names. 
#'
#' Please suggest your own translations [by creating a new issue on our repository](https://github.com/msberends/AMR/issues/new?title=Translations).
#'
#' This file will be read by all functions where a translated output can be desired, like all [mo_property()] functions ([mo_name()], [mo_gramstain()], [mo_type()], etc.).
#'
#' The system language will be used at default, if that language is supported. The system language can be overwritten with `Sys.setenv(AMR_locale = yourlanguage)`.
#' @inheritSection AMR Read more on our website!
#' @rdname translate
#' @name translate
#' @export
#' @examples
#' # The 'language' parameter of below functions
#' # will be set automatically to your system language
#' # with get_locale()
#'
#' # English
#' mo_name("CoNS", language = "en")
#' #> "Coagulase-negative Staphylococcus (CoNS)"
#'
#' # German
#' mo_name("CoNS", language = "de")
#' #> "Koagulase-negative Staphylococcus (KNS)"
#'
#' # Dutch
#' mo_name("CoNS", language = "nl")
#' #> "Coagulase-negatieve Staphylococcus (CNS)"
#'
#' # Spanish
#' mo_name("CoNS", language = "es")
#' #> "Staphylococcus coagulasa negativo (SCN)"
#'
#' # Italian
#' mo_name("CoNS", language = "it")
#' #> "Staphylococcus negativo coagulasi (CoNS)"
#'
#' # Portuguese
#' mo_name("CoNS", language = "pt")
#' #> "Staphylococcus coagulase negativo (CoNS)"
get_locale <- function() {
  if (!is.null(getOption("AMR_locale", default = NULL))) {
    return(getOption("AMR_locale"))
  }
  
  lang <- Sys.getlocale("LC_COLLATE")
  
  # Check the locale settings for a start with one of these languages:
  
  # grepl() with ignore.case = FALSE is faster than %like%
  
  if (grepl("^(English|en_|EN_)", lang, ignore.case = FALSE)) {
    # as first option to optimise speed
    "en"
  } else if (grepl("^(German|Deutsch|de_|DE_)", lang, ignore.case = FALSE)) {
    "de"
  } else if (grepl("^(Dutch|Nederlands|nl_|NL_)", lang, ignore.case = FALSE)) {
    "nl"
  } else if (grepl("^(Spanish|Espa.+ol|es_|ES_)", lang, ignore.case = FALSE)) {
    "es"
  } else if (grepl("^(Italian|Italiano|it_|IT_)", lang, ignore.case = FALSE)) {
    "it"
  } else if (grepl("^(French|Fran.+ais|fr_|FR_)", lang, ignore.case = FALSE)) {
    "fr"
  } else if (grepl("^(Portuguese|Portugu.+s|pt_|PT_)", lang, ignore.case = FALSE)) {
    "pt"
  } else {
    # other language -> set to English
    "en"
  }
}

# translate strings based on inst/translations.tsv
translate_AMR <- function(from, language = get_locale(), only_unknown = FALSE) {
  
  if (is.null(language)) {
    return(from)
  }
  if (language %in% c("en", "", NA)) {
    return(from)
  }
  
  df_trans <- translations_file # internal data file
  
  stop_ifnot(language %in% df_trans$lang,
             "unsupported language: '", language, "' - use one of: ",
             paste0("'", sort(unique(df_trans$lang)), "'", collapse = ", "),
             call = FALSE)
  
  df_trans <- subset(df_trans, lang == language)
  if (only_unknown == TRUE) {
    df_trans <- subset(df_trans, pattern %like% "unknown")
  }
  
  # default case sensitive if value if 'ignore.case' is missing:
  df_trans$ignore.case[is.na(df_trans$ignore.case)] <- FALSE
  # default not using regular expressions (fixed = TRUE) if 'fixed' is missing:
  df_trans$fixed[is.na(df_trans$fixed)] <- TRUE
  
  # check if text to look for is in one of the patterns
  any_form_in_patterns <- tryCatch(any(from %like% paste0("(", paste(df_trans$pattern, collapse = "|"), ")")),
                                   error = function(e) {
                                     warning("Translation not possible. Please open an issue on GitHub (https://github.com/msberends/AMR/issues).", call. = FALSE)
                                     return(FALSE)
                                   })
  if (NROW(df_trans) == 0 | !any_form_in_patterns) {
    return(from)
  }
  
  for (i in seq_len(nrow(df_trans))) {
    from <- gsub(x = from,
                 pattern = df_trans$pattern[i],
                 replacement = df_trans$replacement[i],
                 fixed = df_trans$fixed[i],
                 ignore.case = df_trans$ignore.case[i])
  }
  
  # force UTF-8 for diacritics
  base::enc2utf8(from)
  
}
