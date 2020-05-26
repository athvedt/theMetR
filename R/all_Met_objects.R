#' Returns the number of available Open Access objects in the Met Collection and their objectIDs.
#' @param limit Limits the number of objectIDs returned by the function.
#' @param include_IDs If set to TRUE, the function will return objectIDs, observing the limit argument. Defaults to FALSE.
#'
#' @export



all_Met_objects <-
  function(limit = FALSE,
           include_IDs = FALSE) {
    request <-
      httr::GET(url = "https://collectionapi.metmuseum.org/public/collection/v1/objects")
    data <- httr::content(request)
    object_ID <- unlist(data$objectIDs)
    if (limit != FALSE) {
      object_ID <- object_ID[1:limit]
    }

    print(
      paste(
        length(unlist(data$objectIDs)),
        " objects avilable in the Metropolitan Mueseum's Open Access Database.",
        sep = ""
      )
    )

    if (include_IDs == TRUE) {
      print(paste(
        "Function included the first ",
        length(object_ID),
        " objectIDs in output.",
        sep = ""
      ))

      object_ID

    }
  }
