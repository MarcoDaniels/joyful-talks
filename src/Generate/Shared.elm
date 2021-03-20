module Generate.Shared exposing (..)

import Dict
import Imf.DateTime
import Time exposing (Posix)
import Xml
import Xml.Encode exposing (object, string)


cleanTextXML : String -> String
cleanTextXML input =
    String.replace "&" "&amp;" input


keyStringXML : String -> String -> Xml.Value
keyStringXML key value =
    object [ ( key, Dict.empty, string (cleanTextXML value) ) ]


withCDATA : String -> String
withCDATA content =
    "<![CDATA[ " ++ cleanTextXML content ++ " ]]>"


formatDateRss : Posix -> String
formatDateRss date =
    Imf.DateTime.fromPosix Time.utc date
