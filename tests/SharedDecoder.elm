module SharedDecoder exposing (suite)

import Expect
import OptimizedDecoder exposing (decodeString)
import Shared.Decoder exposing (fieldDecoder, linkDecoder)
import Test exposing (..)
import Utils exposing (matchResult)


suite : Test
suite =
    describe "Shared Decoder"
        [ describe "Decode Field"
            [ test "success" <|
                \_ ->
                    let
                        decodedOutput =
                            decodeString fieldDecoder """{ "type" : "text", "label" : "Text" }"""
                    in
                    Expect.equal decodedOutput
                        (Ok { fieldType = "text", label = "Text" })
            , test "error" <|
                \_ ->
                    let
                        decodedOutput =
                            decodeString fieldDecoder """{ "types" : "text", "label" : "Text" }"""
                    in
                    Expect.equal (matchResult decodedOutput) False
            ]
        , describe "Decode Link"
            [ test "success" <|
                \_ ->
                    let
                        decodedOutput =
                            decodeString linkDecoder """{ "title" : "Go to link", "url" : "/go-to-link" }"""
                    in
                    Expect.equal decodedOutput
                        (Ok { text = "Go to link", url = "/go-to-link" })
            , test "error" <|
                \_ ->
                    let
                        decodedOutput =
                            decodeString linkDecoder """{ "text" : "Go to link", "url" : "/go-to-link" }"""
                    in
                    Expect.equal (matchResult decodedOutput) False
            ]
        ]
