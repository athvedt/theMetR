#' Searches by objectID and eturns all available data.
#'
#' @param objectID The Metropolitan Museum's given ID for an object.
#' @param download_image If TRUE, downloads primary image files the object in the query. Defaults to FALSE.
#'
#' @export



get_Met_object_info <- function(objectID = "",
                                download_image = FALSE) {
  request <-
    httr::GET(
      url = paste(
        "https://collectionapi.metmuseum.org/public/collection/v1/objects/",
        objectID,
        sep = ""
      )
    )
  df <- httr::content(request) %>%
    unlist() %>%
    as.data.frame(stringsAsFactors = FALSE) %>%
    tibble::rownames_to_column("key") %>%
    tidyr::spread(key = "key",
                  value = ".",
                  fill = NA)

  if (download_image == TRUE) {
    download.file(url = df$primaryImage,
                  destfile = paste(df$objectID, ".jpg", sep = ""))
  }

  df
}
