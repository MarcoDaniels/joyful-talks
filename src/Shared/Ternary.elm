module Shared.Ternary exposing (ternary)


ternary : Bool -> t -> t -> t
ternary conditional trueCase falseCase =
    if conditional then
        trueCase

    else
        falseCase
