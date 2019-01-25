#' print scan results
#' @keywords internal
#' @param x output of `snif_secrets`
#' @return cat'ed output to console
cat_results <- function(res) {
  assert(res, "list")

  # top line    
  cli::cat_line(
    cli::rule(center = " * Scan Results * ", line = 2, line_col = "blue", width = 60), "\n"
  )

  # each secret, each one can have many files
  for (i in seq_along(res)) {
    if (length(res[[i]]) == 0) {
      cli::cat_line(
        cli::rule(center = paste0(" secret: ", names(res)[i]), line_col = "grey", width = 40), "\n",
        crayon::style(paste(cli::symbol$tick, " OK "), "green"), "\n"
      )
    } else {
      cli::cat_line(
        cli::rule(center = paste0(" secret: ", names(res)[i]), line_col = "grey", width = 40), "\n",
        crayon::style(paste(cli::symbol$cross, " SECRETS FOUND "), "red"), "\n"
      )
      for (j in seq_along(res[[i]])) {
        cli::cat_line(
          crayon::style(
            paste("   ", 
              cli::symbol$circle_filled,
              sprintf(" %s: %s", names(res[[i]])[j], paste0(res[[i]][[j]], collapse = ", "))
            ),
          "red")
        )
      }
    }
  }
}
