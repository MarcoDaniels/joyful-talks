module Generate.Rss exposing (generateRss)

import Body.Decoder exposing (bodyDecoder)
import Body.Type exposing (BodyData(..))
import Context exposing (MetadataGenerate, StaticRequestGenerate)
import Dict
import Generate.Shared exposing (formatDateRss, keyStringXML, withCDATA)
import Metadata.Type exposing (Metadata(..))
import Pages exposing (images)
import Pages.ImagePath as ImagePath
import Pages.StaticHttp as StaticHttp
import Shared.Ternary exposing (ternary)
import Xml.Encode exposing (list, null, object, string)


generateRss : MetadataGenerate -> StaticHttp.Request StaticRequestGenerate
generateRss metadata =
    StaticHttp.succeed
        [ Ok { path = [ "rss.xml" ], content = rssChannel metadata } ]


rssChannel : MetadataGenerate -> String
rssChannel metadata =
    object
        [ ( "rss"
          , Dict.fromList
                [ ( "xmlns:dc", string "http://purl.org/dc/elements/1.1/" )
                , ( "xmlns:content", string "http://purl.org/rss/1.0/modules/content/" )
                , ( "xmlns:atom", string "http://www.w3.org/2005/Atom" )
                , ( "version", string "2.0" )
                ]
          , object
                [ ( "channel"
                  , Dict.empty
                  , metadata
                        |> List.map
                            (\item ->
                                case bodyDecoder item.body of
                                    Ok content ->
                                        case ( item.frontmatter.metadata, content.data ) of
                                            ( MetadataBase metaBase, BodyDataBase bodyBase ) ->
                                                -- create base channel only for landing page
                                                ternary (bodyBase.url == "/")
                                                    [ keyStringXML "title" metaBase.settings.site.title
                                                    , keyStringXML "link" (withCDATA metaBase.settings.site.baseURL)
                                                    , keyStringXML "description" metaBase.settings.site.description
                                                    , object
                                                        [ ( "atom:link"
                                                          , Dict.fromList
                                                                [ ( "href", string (metaBase.settings.site.baseURL ++ "/rss") )
                                                                , ( "rel", string "self" )
                                                                ]
                                                          , null
                                                          )
                                                        ]
                                                    , object
                                                        [ ( "image"
                                                          , Dict.empty
                                                          , list
                                                                [ keyStringXML "url" (metaBase.settings.site.baseURL ++ "/" ++ ImagePath.toString images.iconPng)
                                                                , keyStringXML "title" metaBase.settings.site.title
                                                                , keyStringXML "link" metaBase.settings.site.baseURL
                                                                ]
                                                          )
                                                        ]
                                                    , keyStringXML "language" "en"
                                                    , keyStringXML "lastBuildDate" (formatDateRss Pages.builtAt)
                                                    ]
                                                    [ null ]

                                            ( MetadataPost metaPost, BodyDataPost bodyPost ) ->
                                                [ object
                                                    [ ( "item"
                                                      , Dict.empty
                                                      , list
                                                            [ keyStringXML "title" bodyPost.title
                                                            , keyStringXML "link" (metaPost.settings.site.baseURL ++ bodyPost.url)
                                                            , object
                                                                [ ( "guid"
                                                                  , Dict.singleton "isPermaLink" (string "true")
                                                                  , string (metaPost.settings.site.baseURL ++ bodyPost.url)
                                                                  )
                                                                ]
                                                            , keyStringXML "description" (withCDATA bodyPost.description)
                                                            , object
                                                                [ ( "dc:creator"
                                                                  , Dict.singleton "xmlns:dc" (string "http://purl.org/dc/elements/1.1/")
                                                                  , string metaPost.settings.site.title
                                                                  )
                                                                ]
                                                            , case bodyPost.published of
                                                                Just published ->
                                                                    keyStringXML "pubDate" (formatDateRss published)

                                                                Nothing ->
                                                                    null
                                                            ]
                                                      )
                                                    ]
                                                ]

                                            _ ->
                                                [ null ]

                                    Err _ ->
                                        [ null ]
                            )
                        |> List.concat
                        |> list
                  )
                ]
          )
        ]
        |> Xml.Encode.encode 0
