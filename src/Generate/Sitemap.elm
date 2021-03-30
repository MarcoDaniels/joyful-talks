module Generate.Sitemap exposing (sitemap)

import Body.Decoder exposing (bodyDecoder)
import Body.Type exposing (BodyData(..))
import Context exposing (MetadataGenerate, StaticRequestGenerate)
import Dict
import Generate.Shared exposing (keyStringXML)
import Settings exposing (settings)
import Shared.Ternary exposing (ternary)
import Xml as XML
import Xml.Encode exposing (list, null, object, string)


sitemapItem : String -> String -> XML.Value
sitemapItem loc priority =
    object
        [ ( "url"
          , Dict.empty
          , list
                [ keyStringXML "loc" loc
                , keyStringXML "changefreq" "monthly"
                , keyStringXML "priority" priority
                ]
          )
        ]


sitemap : MetadataGenerate -> String
sitemap metadata =
    object
        [ ( "urlset"
          , Dict.singleton "xmlns" (string "http://www.sitemaps.org/schemas/sitemap/0.9")
          , metadata
                |> List.map
                    (\item ->
                        case bodyDecoder item.body of
                            Ok content ->
                                case content.data of
                                    BodyDataBase bodyBase ->
                                        -- only include pages with /about and index in sitemap
                                        ternary (String.contains "/about" bodyBase.url || bodyBase.url == "/")
                                            (sitemapItem (settings.baseURL ++ bodyBase.url) "0.9")
                                            null

                                    BodyDataPost bodyPost ->
                                        sitemapItem (settings.baseURL ++ bodyPost.url) "0.7"

                                    _ ->
                                        null

                            Err _ ->
                                null
                    )
                |> list
          )
        ]
        |> Xml.Encode.encode 0
