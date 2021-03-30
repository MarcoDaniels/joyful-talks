module Generate.Robots exposing (robots)

import Context exposing (MetadataGenerate)


robots : MetadataGenerate -> String
robots metadata =
    List.head metadata
        |> (\maybeMeta ->
                case maybeMeta of
                    Just item ->
                        [ "User-agent: *"
                        , "Sitemap: "
                            ++ item.frontmatter.site.baseURL
                            ++ "/sitemap.xml"
                        , "Host: " ++ item.frontmatter.site.baseURL
                        , "Disallow: /___preview"
                        ]
                            |> String.join "\n"

                    Nothing ->
                        ""
           )
