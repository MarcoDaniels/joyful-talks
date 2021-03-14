module Generate.Shared exposing (..)

import Dict
import Xml
import Xml.Encode exposing (object, string)


keyValueXML : String -> String -> Xml.Value
keyValueXML key value =
    object [ ( key, Dict.empty, string value ) ]


withCDATA : String -> String
withCDATA content =
    "<![CDATA[" ++ content ++ "]]>"
