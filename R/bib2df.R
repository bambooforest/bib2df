#' @title Parse a BibTeX file to a \code{tibble}
#' @description The BibTeX file is read, parsed, tidied and written to a \code{tibble}
#' @details For simplicity \code{bib2df()} unifies the reading, parsing and tidying of a BibTeX file while being aware of a standardized output format, different BibTeX styles and missing values in the BibTeX file.
#' @details When \code{separate_names = TRUE}, the respective columns contain a \code{data.frame} for each row. When \code{FALSE}, the respective columns contain character strings.
#' @param file character, path or URL to a .bib file.
#' @param separate_names logical, should authors' and editors' names be separated into first and given name?
#' @return A \code{tibble}.
#' @importFrom httr http_error
#' @author Philipp Ottolinger
#' @examples
#' # Read from .bib file:
#' path <- system.file("extdata", "biblio.bib", package = "bib2df")
#' bib <- bib2df(path)
#' str(bib)
#'
#' # Read from .bib file and separate authors' and editors' names:
#' bib <- bib2df(path, separate_names = TRUE)
#' str(bib)
#' @seealso \code{\link{df2bib}}
#' @export
bib2df <- function(file, separate_names = FALSE) {

  if (!is.character(file)) {
    stop("Invalid file path: Non-character supplied.", call. = FALSE)
  }
  if (grepl("http://|https://|www.", file)) {
    if (http_error(file)) {
      stop("Invalid URL: File is not readable.", call. = FALSE)
    }
  } else {
    if (as.numeric(file.access(file, mode = 4)) != 0) {
      stop("Invalid file path: File is not readable.", call. = FALSE)
    }
  }


  bib <- bib2df_read(file)
  bib <- bib2df_gather(bib)
  bib <- bib2df_tidy(bib, separate_names)
  return(bib)
}
