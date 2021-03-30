module Generate.Robots exposing (robots)

import Context exposing (MetadataGenerate)
import Settings exposing (settings)


robots : MetadataGenerate -> String
robots _ =
    [ "User-agent: *"
    , "Sitemap: "
        ++ settings.baseURL
        ++ "/sitemap.xml"
    , "Host: " ++ settings.baseURL
    , "Disallow: /___preview"
    ]
        |> String.join "\n"
