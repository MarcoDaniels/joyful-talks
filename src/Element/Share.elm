module Element.Share exposing (shareView)

import Context exposing (Element)
import Element.Icon exposing (Icons(..), iconView)
import Html exposing (a, div, span, text)
import Html.Attributes exposing (class, href, rel, target)
import Shared.Types exposing (PostPage)


shareView : PostPage -> Element
shareView post =
    div [ class "post-share font-m" ]
        [ span [] [ text "Be awesome! Let others know about it:" ]
        , a
            [ target "_blank"
            , rel "noopener noreferrer"
            , href
                ("https://www.facebook.com/sharer/sharer.php?u="
                    ++ post.url
                    ++ "&p[title]="
                    ++ post.title
                )
            ]
            [ iconView Facebook { size = "15", color = "#000" }
            ]
        , a
            [ target "_blank"
            , rel "noopener noreferrer"
            , href
                ("http://twitter.com/share?text="
                    ++ post.title
                    ++ "&url="
                    ++ post.url
                )
            ]
            [ iconView Twitter { size = "15", color = "#000" }
            ]
        , a
            [ target "_blank"
            , rel "noopener noreferrer"
            , href
                ("http://pinterest.com/pin/create/button/?url="
                    ++ post.url
                    ++ "&media="
                    ++ post.asset.path
                    ++ "&description="
                    ++ post.description
                )
            ]
            [ iconView Pinterest { size = "15", color = "#000" }
            ]
        , a
            [ target "_blank"
            , rel "noopener noreferrer"
            , href
                ("http://www.linkedin.com/shareArticle?mini=true&url="
                    ++ post.url
                    ++ "&title="
                    ++ post.title
                    ++ "&summary="
                    ++ post.description
                )
            ]
            [ iconView LinkedIn { size = "15", color = "#000" }
            ]
        ]
