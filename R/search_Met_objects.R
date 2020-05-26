#' Return object data based on search paramaters
#'
#' This function searches for all objects in the Met's Open Access database that match the search parameters. The user can also use this function to download data on a number of these objects (5 by default) and download the images (off by default). Some of these arguments come directly from the parameters in the Met's API. In these cases, the same descriptions are used.
#'
#'
#' @param q Search query. Returns a listing of all Object IDs for objects that contain the search query anywhere within the object’s data.
#' @param departmentID Returns objects that are a part of a specific department. Use `get_department_IDs()` function to explore available departments and their associated IDs.
#' @param isHighlight If TRUE, filters for objects that match the query and are designated as highlights. Highlights are selected works of art from The Met Museum’s permanent collection representing different cultures and time periods.
#' @param isOnView If TRUE, filters for objects that match the query and are on view in the museum.
#' @param artistOrCulture If TRUE, filters for objects that match the query, specifically searching against the artist name or culture field for objects.
#' @param medium Returns objects that match the query and are of the specified medium or object type. Examples include: Ceramics, Furniture, Paintings, Sculpture, Textiles, etc.
#' @param hasImages If TRUE, filters for objects that match the query and have images.
#' @param geoLocation Returns objects that match the query and the specified geographic location. Examples include: Europe, France, Paris, China, New York, etc.
#' @param dateBegin Returns objects that match the query and fall between the dateBegin and dateEnd parameters. Must also be used with dateEnd argument.
#' @param dateEnd Returns objects that match the query and fall between the dateBegin and dateEnd parameters. Must also be used with dateBegin argument.
#' @param limit Limits the number of objects that have data included in the output. Defaults to 5.
#' @param download_images If TRUE, downloads primary image files of each object in the query. Observes limit paramater.  Defaults to FALSE.
#'
#' @export
#' @importFrom utils download.file


search_Met_objects <-
  function(q = "",
           departmentID = "",
           isHighlight = FALSE,
           isOnView = FALSE,
           artistOrCulture = FALSE,
           medium = "",
           hasImages = FALSE,
           geoLocation = "",
           dateBegin = "",
           dateEnd = "",
           limit = 5,
           download_images = FALSE) {
    if (is.logical(isHighlight) == FALSE) {
      stop("isHighlight must be logical. Please enter TRUE or FALSE")
    }
    if (is.logical(isOnView) == FALSE) {
      stop("isOnView must be logical. Please enter TRUE or FALSE")
    }
    if (is.logical(artistOrCulture) == FALSE) {
      stop("artistOrCulture must be logical. Please enter TRUE or FALSE")
    }
    if (is.logical(hasImages) == FALSE) {
      stop("hasImages must be logical. Please enter TRUE or FALSE")
    }
    if (is.logical(download_images) == FALSE) {
      stop("download_images must be logical. Please enter TRUE or FALSE")
    }
    if (is.numeric(limit) == FALSE) {
      stop("limit must be a numeric value.")
    }
    if (is.numeric(departmentID) == FALSE &
        departmentID != "") {
      stop(
        "departmentID must be a numeric value. Please use GET_DEPARTMENT_IDs function for more information."
      )
    }

    if (dateBegin != "" &
        dateEnd == "" | dateBegin == "" & dateEnd != "") {
      stop("In order to search by date, paramaters must include dateBegin and dateEnd.")
    }

    endpoint <-
      "https://collectionapi.metmuseum.org/public/collection/v1/search?"

    query_params <- list(
      "departmentId" = departmentID,
      "isHighlight" = ifelse(isHighlight == TRUE, "true", ""),
      "isOnView" = ifelse(isOnView == TRUE, "true", ""),
      "artistOrCulture" = ifelse(artistOrCulture == TRUE, "true", ""),
      "medium" = medium,
      "hasImages" = ifelse(hasImages == TRUE, "true", ""),
      "geoLocation" = geoLocation,
      "dateBegin" = dateBegin,
      "dateEnd" = dateEnd,
      "q" = q
    )

    request <- httr::GET(url = endpoint, query = query_params)

    data <- httr::content(request)
    object_ID <- unlist(data$objectIDs)

    object_ID <-
      object_ID[1:if (length(unlist(data$objectIDs)) > limit) {
        limit
      }  else {
        length(unlist(data$objectIDs))
      }]
    df <- data.frame()


    if (limit > 0) {
      for (ID in object_ID) {
        object_content <-
          httr::content(httr::GET(
            url = paste(
              'https://collectionapi.metmuseum.org/public/collection/v1/objects/',
              ID,
              sep = ""
            )
          ))

        object_data <- object_content %>%
          unlist() %>%
          as.data.frame(stringsAsFactors = FALSE) %>%
          tibble::rownames_to_column("key") %>%
          tidyr::spread(key = "key", value = ".")

        df <- suppressWarnings(dplyr::bind_rows(df, object_data))


      }

      df <-
        suppressWarnings(dplyr::select(df, dplyr::one_of(
          c(
            "accessionNumber",
            "artistAlphaSort",
            "artistBeginDate",
            "artistDisplayBio",
            "artistDisplayName",
            "artistEndDate",
            "artistNationality",
            "artistPrefix",
            "artistRole",
            "artistSuffix",
            "city",
            "classification",
            "constituents.name",
            "constituents.role",
            "country",
            "creditLine",
            "culture",
            "department",
            "dimensions",
            "dynasty",
            "excavation",
            "geographyType",
            "isHighlight",
            "isPublicDomain",
            "linkResource",
            "locale",
            "locus",
            "medium",
            "metadataDate",
            "objectBeginDate",
            "objectDate",
            "objectEndDate",
            "objectID",
            "objectName",
            "objectURL",
            "primaryImage",
            "primaryImageSmall",
            "region",
            "reign",
            "repository",
            "rightsAndReproduction",
            "river",
            "state",
            "subregion",
            "tags",
            "title"
          )
        ))) %>%
        dplyr::na_if("") %>%
        dplyr::select_if(~ !all(is.na(.)))



      if (download_images == TRUE) {
        download.file(
          url = df$primaryImage,
          destfile = paste(df$objectID, ".jpg", sep = "")
        )
      }

      print(paste(length(unlist(data$objectIDs)),
                  " objects matched search paramaters.",
                  sep = ""))

      if (length(unlist(data$objectIDs) > 0)) {
        print(paste(
          "Data on ",
          length(object_ID),
          " objects included in output.",
          sep = ""
        ))
        df
      }

    } else {
      print(paste(length(unlist(data$objectIDs)),
                  " objects matched search paramaters.",
                  sep = ""))


    }
  }
