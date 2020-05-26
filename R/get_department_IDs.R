#' Get department IDs
#'
#' This function returns information on the departments currently at the Metropolitan Museum. Running this function will output a data.frame of the names and DepartmentIDs of the current departments.
#'
#' @export


get_department_IDs <- function() {
  departments <- httr::content(
    httr::GET(url = "https://collectionapi.metmuseum.org/public/collection/v1/departments")
  )


  df <- data.frame()
  for (i in 1:length(departments$departments)) {
    df <-
      suppressWarnings(dplyr::bind_rows(df, data.frame(departments$departments[[i]])))
  }

  df <- df %>%
    dplyr::select(Department = displayName, DepartmentID = departmentId)

  df
}
