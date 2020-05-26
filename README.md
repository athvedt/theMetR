## Overview
theMetR is an R wrapper for the Metropolitan Museum's API. This package includes multiple functions that will help you explore the Met's Open Access Database. The Met API is simple, which means it is fairly straightforward to interact with but this also makes it difficult to gather larger amounts of data at once. The Met API allows a user to search for objects that match its search criteria, but returns no other information other than the number of objects and their objectIDs. Gathering data on the objects in the search requires another query and must be done for individually for each object. This package addresses these issues, making it simple for the user to download the data they want. Below, you will find a few examples of what this package  can do. For full documentation, please see the vignette.

## API Access
At this time, no authentication is required to access the Metropolitan Museum API. The user can simply download theMetR package and begin to access information from the API.

## Usage

## How many objects are available for search at this time?

```{r}
all_Met_objects()
```

## Let's get data on the first object in the Met Database. Use the `get_Met_object_info()` function to search for data on a single object by objectID.
```{r}
get_Met_object_info(objectID = 1)
```

### What does the 100th object look like? Set `download_image` to `TRUE` to download the primary image of the object into your current working directory.

```{r}
get_Met_object_info(objectID = 100, download_image = TRUE)
```


## Searching for multiple objects and their data
### How many objects in the Met have something to do with cats?

Running the function with `q` = `cat` searches for any objects in the entire database that have the search term anywhere in their data. In order to search for the number of objects, but not retrieve any data, set the `limit` parameter to `0`.

```{r}
search_Met_objects(q = "cat", limit = 0)
```

### What if we want to see how many of these are also paintings and currently on display at the Met?
```{r}
search_Met_objects(q = "cat", limit = 0, medium = "Paintings", isOnView = TRUE)
```

### Let's now see how many of these objects were made between 1000 and 1500 and retrieve data on the first 10 of them.

Because the Met API only allows users to request data on a single object at a time, running this function with a larger `limit` parameter may take some time to retrieve all the data.
```{r}
search_Met_objects(q = "cat", limit = 10, medium = "Paintings", isOnView = TRUE, dateBegin = 1000, dateEnd = 1500)
```

### What if we want to filter by department? Use the `get_department_IDs()` function to retrieve information on the current departments at the Met Museum.

```{r}
get_department_IDs()
```
