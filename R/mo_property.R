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

#' Property of a microorganism
#'
#' Use these functions to return a specific property of a microorganism. All input values will be evaluated internally with [as.mo()], which makes it possible to use microbial abbreviations, codes and names as input. Please see *Examples*.
#' @inheritSection lifecycle Stable lifecycle
#' @param x any (vector of) text that can be coerced to a valid microorganism code with [as.mo()]
#' @param property one of the column names of the [microorganisms] data set or `"shortname"`
#' @param language language of the returned text, defaults to system language (see [get_locale()]) and can also be set with `getOption("AMR_locale")`. Use `language = NULL` or `language = ""` to prevent translation.
#' @param ... other parameters passed on to [as.mo()]
#' @param open browse the URL using [utils::browseURL()]
#' @details All functions will return the most recently known taxonomic property according to the Catalogue of Life, except for [mo_ref()], [mo_authors()] and [mo_year()]. Please refer to this example, knowing that *Escherichia blattae* was renamed to *Shimwellia blattae* in 2010:
#' - `mo_name("Escherichia blattae")` will return `"Shimwellia blattae"` (with a message about the renaming)
#' - `mo_ref("Escherichia blattae")` will return `"Burgess et al., 1973"` (with a message about the renaming)
#' - `mo_ref("Shimwellia blattae")` will return `"Priest et al., 2010"` (without a message)
#'
#' The short name - [mo_shortname()] - almost always returns the first character of the genus and the full species, like `"E. coli"`. Exceptions are abbreviations of staphylococci (like *"CoNS"*, Coagulase-Negative Staphylococci) and beta-haemolytic streptococci (like *"GBS"*, Group B Streptococci). Please bear in mind that e.g. *E. coli* could mean *Escherichia coli* (kingdom of Bacteria) as well as *Entamoeba coli* (kingdom of Protozoa). Returning to the full name will be done using [as.mo()] internally, giving priority to bacteria and human pathogens, i.e. `"E. coli"` will be considered *Escherichia coli*. In other words, `mo_fullname(mo_shortname("Entamoeba coli"))` returns `"Escherichia coli"`.
#' 
#' Since the top-level of the taxonomy is sometimes referred to as 'kingdom' and sometimes as 'domain', the functions [mo_kingdom()] and [mo_domain()] return the exact same results.
#'
#' The Gram stain - [mo_gramstain()] - will be determined based on the taxonomic kingdom and phylum. According to Cavalier-Smith (2002, [PMID 11837318](https://pubmed.ncbi.nlm.nih.gov/11837318)), who defined subkingdoms Negibacteria and Posibacteria, only these phyla are Posibacteria: Actinobacteria, Chloroflexi, Firmicutes and Tenericutes. These bacteria are considered Gram-positive - all other bacteria are considered Gram-negative. Species outside the kingdom of Bacteria will return a value `NA`.
#'
#' All output will be [translate]d where possible.
#'
#' The function [mo_url()] will return the direct URL to the online database entry, which also shows the scientific reference of the concerned species.
#' @inheritSection catalogue_of_life Catalogue of Life
#' @inheritSection as.mo Source
#' @rdname mo_property
#' @name mo_property
#' @return
#' - An [`integer`] in case of [mo_year()]
#' - A [`list`] in case of [mo_taxonomy()] and [mo_info()]
#' - A named [`character`] in case of [mo_url()]
#' - A [`double`] in case of [mo_snomed()]
#' - A [`character`] in all other cases
#' @export
#' @seealso [microorganisms]
#' @inheritSection AMR Read more on our website!
#' @examples
#' # taxonomic tree -----------------------------------------------------------
#' mo_kingdom("E. coli")         # "Bacteria"
#' mo_phylum("E. coli")          # "Proteobacteria"
#' mo_class("E. coli")           # "Gammaproteobacteria"
#' mo_order("E. coli")           # "Enterobacterales"
#' mo_family("E. coli")          # "Enterobacteriaceae"
#' mo_genus("E. coli")           # "Escherichia"
#' mo_species("E. coli")         # "coli"
#' mo_subspecies("E. coli")      # ""
#'
#' # colloquial properties ----------------------------------------------------
#' mo_name("E. coli")            # "Escherichia coli"
#' mo_fullname("E. coli")        # "Escherichia coli" - same as mo_name()
#' mo_shortname("E. coli")       # "E. coli"
#'
#' # other properties ---------------------------------------------------------
#' mo_gramstain("E. coli")       # "Gram-negative"
#' mo_snomed("E. coli")          # 112283007, 116395006, ... (SNOMED codes)
#' mo_type("E. coli")            # "Bacteria" (equal to kingdom, but may be translated)
#' mo_rank("E. coli")            # "species"
#' mo_url("E. coli")             # get the direct url to the online database entry
#' mo_synonyms("E. coli")        # get previously accepted taxonomic names
#'
#' # scientific reference -----------------------------------------------------
#' mo_ref("E. coli")             # "Castellani et al., 1919"
#' mo_authors("E. coli")         # "Castellani et al."
#' mo_year("E. coli")            # 1919
#'
#' # abbreviations known in the field -----------------------------------------
#' mo_genus("MRSA")              # "Staphylococcus"
#' mo_species("MRSA")            # "aureus"
#' mo_shortname("VISA")          # "S. aureus"
#' mo_gramstain("VISA")          # "Gram-positive"
#'
#' mo_genus("EHEC")              # "Escherichia"
#' mo_species("EHEC")            # "coli"
#'
#' # known subspecies ---------------------------------------------------------
#' mo_name("doylei")             # "Campylobacter jejuni doylei"
#' mo_genus("doylei")            # "Campylobacter"
#' mo_species("doylei")          # "jejuni"
#' mo_subspecies("doylei")       # "doylei"
#'
#' mo_fullname("K. pneu rh")     # "Klebsiella pneumoniae rhinoscleromatis"
#' mo_shortname("K. pneu rh")    # "K. pneumoniae"
#'
#' \donttest{
#' # Becker classification, see ?as.mo ----------------------------------------
#' mo_fullname("S. epi")                     # "Staphylococcus epidermidis"
#' mo_fullname("S. epi", Becker = TRUE)      # "Coagulase-negative Staphylococcus (CoNS)"
#' mo_shortname("S. epi")                    # "S. epidermidis"
#' mo_shortname("S. epi", Becker = TRUE)     # "CoNS"
#'
#' # Lancefield classification, see ?as.mo ------------------------------------
#' mo_fullname("S. pyo")                     # "Streptococcus pyogenes"
#' mo_fullname("S. pyo", Lancefield = TRUE)  # "Streptococcus group A"
#' mo_shortname("S. pyo")                    # "S. pyogenes"
#' mo_shortname("S. pyo", Lancefield = TRUE) # "GAS" (='Group A Streptococci')
#'
#'
#' # language support for German, Dutch, Spanish, Portuguese, Italian and French
#' mo_gramstain("E. coli", language = "de")  # "Gramnegativ"
#' mo_gramstain("E. coli", language = "nl")  # "Gram-negatief"
#' mo_gramstain("E. coli", language = "es")  # "Gram negativo"
#'
#' # mo_type is equal to mo_kingdom, but mo_kingdom will remain official
#' mo_kingdom("E. coli")                     # "Bacteria" on a German system
#' mo_type("E. coli")                        # "Bakterien" on a German system
#' mo_type("E. coli")                        # "Bacteria" on an English system
#'
#' mo_fullname("S. pyogenes",
#'             Lancefield = TRUE,
#'             language = "de")              # "Streptococcus Gruppe A"
#' mo_fullname("S. pyogenes",
#'             Lancefield = TRUE,
#'             language = "nl")              # "Streptococcus groep A"
#'
#'
#' # get a list with the complete taxonomy (from kingdom to subspecies)
#' mo_taxonomy("E. coli")
#' # get a list with the taxonomy, the authors, Gram-stain and URL to the online database
#' mo_info("E. coli")
#' }
mo_name <- function(x, language = get_locale(), ...) {
  translate_AMR(mo_validate(x = x, property = "fullname", ...), language = language, only_unknown = FALSE)
}

#' @rdname mo_property
#' @export
mo_fullname <- mo_name

#' @rdname mo_property
#' @export
mo_shortname <- function(x, language = get_locale(), ...) {
  x.mo <- as.mo(x, ...)
  
  metadata <- get_mo_failures_uncertainties_renamed()
  
  replace_empty <- function(x) {
    x[x == ""] <- "spp."
    x
  }
  
  # get first char of genus and complete species in English
  shortnames <- paste0(substr(mo_genus(x.mo, language = NULL), 1, 1), ". ", replace_empty(mo_species(x.mo, language = NULL)))
  
  # exceptions for Staphylococci
  shortnames[shortnames == "S. coagulase-negative"] <- "CoNS"
  shortnames[shortnames == "S. coagulase-positive"] <- "CoPS"
  # exceptions for Streptococci: Streptococcus Group A -> GAS
  shortnames[shortnames %like% "S. group [ABCDFGHK]"] <- paste0("G", gsub("S. group ([ABCDFGHK])", "\\1", shortnames[shortnames %like% "S. group [ABCDFGHK]"]), "S")
  
  load_mo_failures_uncertainties_renamed(metadata)
  translate_AMR(shortnames, language = language, only_unknown = FALSE)
}

#' @rdname mo_property
#' @export
mo_subspecies <- function(x, language = get_locale(), ...) {
  translate_AMR(mo_validate(x = x, property = "subspecies", ...), language = language, only_unknown = TRUE)
}

#' @rdname mo_property
#' @export
mo_species <- function(x, language = get_locale(), ...) {
  translate_AMR(mo_validate(x = x, property = "species", ...), language = language, only_unknown = TRUE)
}

#' @rdname mo_property
#' @export
mo_genus <- function(x, language = get_locale(), ...) {
  translate_AMR(mo_validate(x = x, property = "genus", ...), language = language, only_unknown = TRUE)
}

#' @rdname mo_property
#' @export
mo_family <- function(x, language = get_locale(), ...) {
  translate_AMR(mo_validate(x = x, property = "family", ...), language = language, only_unknown = TRUE)
}

#' @rdname mo_property
#' @export
mo_order <- function(x, language = get_locale(), ...) {
  translate_AMR(mo_validate(x = x, property = "order", ...), language = language, only_unknown = TRUE)
}

#' @rdname mo_property
#' @export
mo_class <- function(x, language = get_locale(), ...) {
  translate_AMR(mo_validate(x = x, property = "class", ...), language = language, only_unknown = TRUE)
}

#' @rdname mo_property
#' @export
mo_phylum <- function(x, language = get_locale(), ...) {
  translate_AMR(mo_validate(x = x, property = "phylum", ...), language = language, only_unknown = TRUE)
}

#' @rdname mo_property
#' @export
mo_kingdom <- function(x, language = get_locale(), ...) {
  translate_AMR(mo_validate(x = x, property = "kingdom", ...), language = language, only_unknown = TRUE)
}

#' @rdname mo_property
#' @export
mo_domain <- mo_kingdom

#' @rdname mo_property
#' @export
mo_type <- function(x, language = get_locale(), ...) {
  translate_AMR(mo_validate(x = x, property = "kingdom", ...), language = language, only_unknown = FALSE)
}

#' @rdname mo_property
#' @export
mo_gramstain <- function(x, language = get_locale(), ...) {
  x.mo <- as.mo(x, ...)
  metadata <- get_mo_failures_uncertainties_renamed()
  
  x.phylum <- mo_phylum(x.mo)
  # DETERMINE GRAM STAIN FOR BACTERIA
  # Source: https://itis.gov/servlet/SingleRpt/SingleRpt?search_topic=TSN&search_value=956097
  # It says this:
  # Kingdom Bacteria (Cavalier-Smith, 2002)
  #    Subkingdom Posibacteria (Cavalier-Smith, 2002)
  #   Direct Children:
  #       Phylum  Actinobacteria (Cavalier-Smith, 2002)
  #       Phylum  Chloroflexi (Garrity and Holt, 2002)
  #       Phylum  Firmicutes (corrig. Gibbons and Murray, 1978)
  #       Phylum  Tenericutes (Murray, 1984)
  x <- NA_character_
  # make all bacteria Gram negative
  x[mo_kingdom(x.mo) == "Bacteria"] <- "Gram-negative"
  # overwrite these phyla with Gram positive
  x[x.phylum %in% c("Actinobacteria",
                    "Chloroflexi",
                    "Firmicutes",
                    "Tenericutes")
    | x.mo == "B_GRAMP"] <- "Gram-positive"
  
  load_mo_failures_uncertainties_renamed(metadata)
  translate_AMR(x, language = language, only_unknown = FALSE)
}

#' @rdname mo_property
#' @export
mo_snomed <- function(x, ...) {
  mo_validate(x = x, property = "snomed", ...)
}

#' @rdname mo_property
#' @export
mo_ref <- function(x, ...) {
  mo_validate(x = x, property = "ref", ...)
}

#' @rdname mo_property
#' @export
mo_authors <- function(x, ...) {
  x <- mo_validate(x = x, property = "ref", ...)
  # remove last 4 digits and presumably the comma and space that preceed them
  x[!is.na(x)] <- gsub(",? ?[0-9]{4}", "", x[!is.na(x)])
  suppressWarnings(x)
}

#' @rdname mo_property
#' @export
mo_year <- function(x, ...) {
  x <- mo_validate(x = x, property = "ref", ...)
  # get last 4 digits
  x[!is.na(x)] <- gsub(".*([0-9]{4})$", "\\1", x[!is.na(x)])
  suppressWarnings(as.integer(x))
}

#' @rdname mo_property
#' @export
mo_rank <- function(x, ...) {
  mo_validate(x = x, property = "rank", ...)
}

#' @rdname mo_property
#' @export
mo_taxonomy <- function(x, language = get_locale(),  ...) {
  x <- as.mo(x, ...)
  metadata <- get_mo_failures_uncertainties_renamed()
  
  result <- base::list(kingdom = mo_kingdom(x, language = language),
                       phylum = mo_phylum(x, language = language),
                       class = mo_class(x, language = language),
                       order = mo_order(x, language = language),
                       family = mo_family(x, language = language),
                       genus = mo_genus(x, language = language),
                       species = mo_species(x, language = language),
                       subspecies = mo_subspecies(x, language = language))
  
  load_mo_failures_uncertainties_renamed(metadata)
  result
}

#' @rdname mo_property
#' @export
mo_synonyms <- function(x, ...) {
  x <- as.mo(x, ...)
  metadata <- get_mo_failures_uncertainties_renamed()
  
  IDs <- mo_name(x = x, language = NULL)
  syns <- lapply(IDs, function(newname) {
    res <- sort(microorganisms.old[which(microorganisms.old$fullname_new == newname), "fullname"])
    if (length(res) == 0) {
      NULL
    } else {
      res
    }
  })
  if (length(syns) > 1) {
    names(syns) <- mo_name(x)
    result <- syns
  } else {
    result <- unlist(syns)
  }
  
  load_mo_failures_uncertainties_renamed(metadata)
  result
}

#' @rdname mo_property
#' @export
mo_info <- function(x, language = get_locale(),  ...) {
  x <- as.mo(x, ...)
  metadata <- get_mo_failures_uncertainties_renamed()
  
  info <- lapply(x, function(y)
    c(mo_taxonomy(y, language = language),
      list(synonyms = mo_synonyms(y),
           gramstain = mo_gramstain(y, language = language),
           url = unname(mo_url(y, open = FALSE)),
           ref = mo_ref(y))))
  if (length(info) > 1) {
    names(info) <- mo_name(x)
    result <- info
  } else {
    result <- info[[1L]]
  }
  
  load_mo_failures_uncertainties_renamed(metadata)
  result
}

#' @rdname mo_property
#' @export
mo_url <- function(x, open = FALSE, ...) {
  mo <- as.mo(x = x, ... = ...)
  mo_names <- mo_name(mo)
  metadata <- get_mo_failures_uncertainties_renamed()
  
  df <- data.frame(mo, stringsAsFactors = FALSE) %>%
    left_join(select(microorganisms, mo, source, species_id), by = "mo")
  df$url <- ifelse(df$source == "CoL",
                   paste0(catalogue_of_life$url_CoL, "details/species/id/", df$species_id, "/"),
                   ifelse(df$source == "DSMZ",
                          paste0(catalogue_of_life$url_DSMZ, "/advanced_search?adv[taxon-name]=", gsub(" ", "+", mo_names), "/"),
                          NA_character_))
  u <- df$url
  names(u) <- mo_names
  
  if (open == TRUE) {
    if (length(u) > 1) {
      warning("only the first URL will be opened, as `browseURL()` only suports one string.")
    }
    utils::browseURL(u[1L])
  }
  
  load_mo_failures_uncertainties_renamed(metadata)
  u
}


#' @rdname mo_property
#' @export
mo_property <- function(x, property = "fullname", language = get_locale(), ...) {
  stop_ifnot(length(property) == 1L, "'property' must be of length 1")
  stop_ifnot(property %in% colnames(microorganisms),
             "invalid property: '", property, "' - use a column name of the `microorganisms` data set")
  
  translate_AMR(mo_validate(x = x, property = property, ...), language = language, only_unknown = TRUE)
}

mo_validate <- function(x, property, ...) {
  
  check_dataset_integrity()
  
  dots <- list(...)
  Becker <- dots$Becker
  if (is.null(Becker)) {
    Becker <- FALSE
  }
  Lancefield <- dots$Lancefield
  if (is.null(Lancefield)) {
    Lancefield <- FALSE
  }
  
  # try to catch an error when inputting an invalid parameter
  # so the 'call.' can be set to FALSE
  tryCatch(x[1L] %in% MO_lookup[1, property, drop = TRUE],
           error = function(e) stop(e$message, call. = FALSE))
  
  if (is.mo(x) 
      & !Becker %in% c(TRUE, "all") 
      & !Lancefield %in% c(TRUE, "all")) {
    # this will not reset mo_uncertainties and mo_failures
    # because it's already a valid MO
    x <- exec_as.mo(x, property = property, initial_search = FALSE, ...)
  } else if (!all(x %in% MO_lookup[, property, drop = TRUE])
             | Becker %in% c(TRUE, "all")
             | Lancefield %in% c(TRUE, "all")) {
    x <- exec_as.mo(x, property = property, ...)
  }
  
  if (property == "mo") {
    return(to_class_mo(x))
  } else if (property == "snomed") {
    return(as.double(eval(parse(text = x))))
  } else {
    return(x)
  }
}
