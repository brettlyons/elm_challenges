module Main exposing (..)

import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (class, placeholder)
import Html.Events exposing (onClick, onInput)
import Keyboard exposing (..)
import Http
import Time exposing (Time, second)


-- MODEL


type alias Model =
    { textEntry : String
    , userName : String
    , avatarUrl : String
    , languages : List String
    }


init : ( Model, Cmd Msg )
init =
    ( { textEntry = ""
      , userName = ""
      , avatarUrl = ""
      , languages = []
      }
    , Cmd.none
    )



-- UPDATE


type Msg
    = TextInput String
    | Tick Time


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick time ->
            ( model, Cmd.none )

        TextInput name ->
            ( { model | textEntry = name }, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    div [ class "container" ]
        [ div [ class "row" ]
            [ input
                [ placeholder "Github Username", onInput TextInput ]
                []
            ]
        , div
            [ class "row" ]
            [ text ("Fresh Text! : " ++ model.textEntry) ]
        ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch [ Time.every second Tick ]


main : Program Never
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
