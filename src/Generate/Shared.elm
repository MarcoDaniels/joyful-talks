module Generate.Shared exposing (..)

import Dict
import Imf.DateTime
import Time exposing (Posix)
import Xml
import Xml.Encode exposing (object, string)


keyStringXML : String -> String -> Xml.Value
keyStringXML key value =
    object [ ( key, Dict.empty, string value ) ]


withCDATA : String -> String
withCDATA content =
    "<![CDATA[" ++ content ++ "]]>"


formatDateRss : Posix -> String
formatDateRss date =
    Imf.DateTime.fromPosix Time.utc date
