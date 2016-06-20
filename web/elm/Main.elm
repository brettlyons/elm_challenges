module Main exposing (..)

import Html exposing (..)
import Html.App as Html


-- import Html.Attributes exposing (..)

import Html.Events exposing (onClick)
import Mouse exposing (Position)
import Svg exposing (..)
import Svg.Attributes exposing (width, height, viewBox, cx, cy, r, fill)
import Random exposing (..)
import Task
import Window exposing (Size)
import Time exposing (Time, second)


-- MODEL


type alias CircleCenter =
    ( Int, Int )


type alias Model =
    { circles : List CircleCenter
    }


init : ( Model, Cmd Msg )
init =
    ( { circles = [] }
    , Cmd.none
    )


getRandomPos : Int -> Int -> Int -> Cmd Msg
getRandomPos min maxWidth maxHeight =
    Random.generate NewCircle (Random.pair (Random.int min maxWidth) (Random.int min maxHeight))



-- UPDATE


type Msg
    = NewCircle ( Int, Int )
    | Tick Time


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NewCircle xy ->
            ( { model | circles = xy :: model.circles }, Cmd.none )

        Tick time ->
            ( model, getRandomPos 10 380 380 )



-- VIEW


view : Model -> Html Msg
view model =
    Svg.svg
        [ width "400", height "400", viewBox "0 0 400 400" ]
        (List.map smallCircleMaker model.circles)


smallCircleMaker : ( Int, Int ) -> Svg Msg
smallCircleMaker pos =
    circleMaker 10 pos


circleMaker : Int -> ( Int, Int ) -> Svg Msg
circleMaker radius pos =
    circle [ cx (toString (fst pos)), cy (toString (snd pos)), r (toString radius), fill "#0B79CE" ] []


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
