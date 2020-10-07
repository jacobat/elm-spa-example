module Page.Review exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)


type alias Model =
    String


view reviewName =
    { title = "Review"
    , body =
        [ text (String.concat [ "Review of ", reviewName ])
        , ul []
            [ viewLink "/home"
            , viewLink "/profile"
            , viewLink "/reviews/the-century-of-the-self"
            , viewLink "/reviews/public-opinion"
            , viewLink "/reviews/shah-of-shahs"
            ]
        ]
    }


viewLink : String -> Html msg
viewLink path =
    li [] [ a [ href path ] [ text path ] ]
