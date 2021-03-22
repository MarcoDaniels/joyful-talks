module Generate.Rss exposing (rss)

import Body.Decoder exposing (bodyDecoder)
import Body.Type exposing (BodyData(..))
import Context exposing (MetadataGenerate, StaticRequestGenerate)
import Dict
import Generate.Shared exposing (formatDateRss, keyStringXML, withCDATA)
import Pages exposing (images)
import Pages.ImagePath as ImagePath
import Shared.Ternary exposing (ternary)
import Xml.Encode exposing (list, null, object, string)


rss : MetadataGenerate -> String
rss metadata =
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
                                        case content.data of
                                            BodyDataBase bodyBase ->
                                                -- create base channel only for landing page
                                                ternary (bodyBase.url == "/")
                                                    [ keyStringXML "title" content.settings.site.title
                                                    , keyStringXML "link" (withCDATA content.settings.site.baseURL)
                                                    , keyStringXML "description" content.settings.site.description
                                                    , object
                                                        [ ( "atom:link"
                                                          , Dict.fromList
                                                                [ ( "href", string (content.settings.site.baseURL ++ "/rss") )
                                                                , ( "rel", string "self" )
                                                                ]
                                                          , null
                                                          )
                                                        ]
                                                    , object
                                                        [ ( "image"
                                                          , Dict.empty
                                                          , list
                                                                [ keyStringXML "url" (content.settings.site.baseURL ++ "/" ++ ImagePath.toString images.iconPng)
                                                                , keyStringXML "title" content.settings.site.title
                                                                , keyStringXML "link" content.settings.site.baseURL
                                                                ]
                                                          )
                                                        ]
                                                    , keyStringXML "language" "en"
                                                    , keyStringXML "lastBuildDate" (formatDateRss Pages.builtAt)
                                                    ]
                                                    [ null ]

                                            BodyDataPost bodyPost ->
                                                [ object
                                                    [ ( "item"
                                                      , Dict.empty
                                                      , list
                                                            [ keyStringXML "title" bodyPost.title
                                                            , keyStringXML "link" (content.settings.site.baseURL ++ bodyPost.url)
                                                            , object
                                                                [ ( "guid"
                                                                  , Dict.singleton "isPermaLink" (string "true")
                                                                  , string (content.settings.site.baseURL ++ bodyPost.url)
                                                                  )
                                                                ]
                                                            , keyStringXML "description" (withCDATA bodyPost.description)
                                                            , object
                                                                [ ( "dc:creator"
                                                                  , Dict.singleton "xmlns:dc" (string "http://purl.org/dc/elements/1.1/")
                                                                  , string content.settings.site.title
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
