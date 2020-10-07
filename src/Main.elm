module Main exposing (Model, Msg(..), init, main, subscriptions, update, view, viewLink)

import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Page.Review
import Url
import Url.Parser exposing ((</>), Parser, int, map, oneOf, parse, s, string)



-- MAIN


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }



-- MODEL


type alias Model =
    { key : Nav.Key
    , url : Url.Url
    , name : String
    }


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    ( Model key url "", Cmd.none )


type Route
    = Home
    | Profile
    | Review Page.Review.Model


routeParser : Parser (Route -> a) a
routeParser =
    oneOf
        [ map Profile (s "profile")
        , map Review (s "reviews" </> string)
        ]


toRoute : Url.Url -> Route
toRoute url =
    Maybe.withDefault Home (parse routeParser url)



-- UPDATE


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    handleInternalUrl model url

                Browser.External href ->
                    ( model, Nav.load href )

        UrlChanged url ->
            ( { model | url = url }
            , Cmd.none
            )


handleInternalUrl model url =
    let
        a =
            1
    in
    ( model, Nav.pushUrl model.key (Url.toString url) )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


view : Model -> Browser.Document Msg
view model =
    case toRoute model.url of
        Review review ->
            Page.Review.view review

        _ ->
            defaultView model


defaultView model =
    { title = "Url Interceptor"
    , body =
        [ text (String.concat [ "Hi ", model.name, " The current URL is: " ])
        , p [] [ b [] [ text (Debug.toString (toRoute model.url)) ] ]
        , p [] [ b [] [ text (Url.toString model.url) ] ]
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
