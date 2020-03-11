function create-repository($name, $visibility, $token) {
 #
 # Prepare query string with new lines:
 #
   $query_nl = '
      mutation {{
         createRepository (
            input: {{
               name      : \"{0}\",
               visibility:   {1}
            }}
         )
         {{
             clientMutationId
         }}
    }}' -f $name, $visibility

    write-verbose "query with newlines:`n$($query_nl)"

 #
 # Apparently, graphql and/or github does not allow new lines in the query string.
 # So, replace them
 #
   $query = $query_nl.replace("`n", '').replace("`r", '')

   $body = '{{ "query": "{0}" }}' -f $query

   $response = invoke-webrequest `
       https://api.github.com/graphql                          `
      -method         POST                                     `
      -contentType    application/json                         `
      -headers @{Authorization = "Bearer $token"}              `
      -body           $body

 #
 # Note: response might be '200 OK' even if repository was not created.
 #
   write-host "$($response.StatusCode) $($response.StatusDescription)"
}
