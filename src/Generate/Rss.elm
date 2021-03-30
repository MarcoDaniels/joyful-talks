module Generate.Rss exposing (rss)

import Body.Decoder exposing (bodyDecoder)
import Body.Type exposing (BodyData(..))
import Context exposing (MetadataGenerate, StaticRequestGenerate)
import Dict
import Generate.Shared exposing (formatDateRss, keyStringXML, withCDATA)
import Pages exposing (images)
import Pages.ImagePath as ImagePath
import Settings exposing (settings)
import Xml
import Xml.Encode exposing (list, null, object, string)


channelInfo : List Xml.Value
channelInfo =
    [ keyStringXML "title" settings.title
    , keyStringXML "link" (withCDATA settings.baseURL)
    , keyStringXML "description" settings.description
    , object
        [ ( "atom:link"
          , Dict.fromList
                [ ( "href", string (settings.baseURL ++ "/rss") )
                , ( "rel", string "self" )
                ]
          , null
          )
        ]
    , object
        [ ( "image"
          , Dict.empty
          , list
                [ keyStringXML "url" (settings.baseURL ++ "/" ++ ImagePath.toString images.iconPng)
                , keyStringXML "title" settings.title
                , keyStringXML "link" settings.baseURL
                ]
          )
        ]
    , keyStringXML "language" "en"
    , keyStringXML "lastBuildDate" (formatDateRss Pages.builtAt)
    ]


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
                  , [ [ channelInfo ]
                    , metadata
                        |> List.map
                            (\item ->
                                case bodyDecoder item.body of
                                    Ok content ->
                                        case content.data of
                                            BodyDataPost bodyPost ->
                                                [ object
                                                    [ ( "item"
                                                      , Dict.empty
                                                      , list
                                                            [ keyStringXML "title" bodyPost.title
                                                            , keyStringXML "link" (settings.baseURL ++ bodyPost.url)
                                                            , object
                                                                [ ( "guid"
                                                                  , Dict.singleton "isPermaLink" (string "true")
                                                                  , string (settings.baseURL ++ bodyPost.url)
                                                                  )
                                                                ]
                                                            , keyStringXML "description" (withCDATA bodyPost.description)
                                                            , object
                                                                [ ( "dc:creator"
                                                                  , Dict.singleton "xmlns:dc" (string "http://purl.org/dc/elements/1.1/")
                                                                  , string settings.title
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
                    ]
                        |> List.concat
                        |> List.concat
                        |> list
                  )
                ]
          )
        ]
        |> Xml.Encode.encode 0
