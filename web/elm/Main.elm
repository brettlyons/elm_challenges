module Main exposing (..)

import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Keyboard exposing (..)
import Char exposing (fromCode)
import Http


-- import Mouse exposing (Position)

import Svg exposing (..)
import Svg.Attributes exposing (width, height, viewBox, cx, cy, r, fill)
import Random exposing (..)


-- import Task
-- import Window exposing (Size)

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
      , langauges = []
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
            ( model, getRandomPos 10 380 380 )

        TextInput name ->
            ( { model | textEntry = name }, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    div []
        []


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
