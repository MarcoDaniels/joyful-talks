module Generate.Rss exposing (..)

import Context exposing (MetadataGenerate, StaticRequestGenerate)
import Dict
import Generate.Shared exposing (keyValueXML, withCDATA)
import Pages.StaticHttp as StaticHttp
import Xml.Encode exposing (list, object, string)


generateRss : MetadataGenerate -> StaticHttp.Request StaticRequestGenerate
generateRss metadata =
    StaticHttp.succeed
        [ Ok { path = [ "rss.xml" ], content = cont } ]


items : MetadataGenerate -> List String
items meta =
    -- meta |> List.map (\item -> item.frontmatter.seo.title)
    [ "" ]


cont : String
cont =
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
                  , [ [ keyValueXML "title" "TODO: title"
                      , keyValueXML "description" "TODO: description"
                      , keyValueXML "link" (withCDATA "TODO: link")
                      , keyValueXML "lastBuildDate" "TODO: last build"
                      ]
                    ]
                        |> List.concat
                        |> list
                  )
                ]
          )
        ]
        |> Xml.Encode.encode 0
