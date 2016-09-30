module Main exposing (..)

import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Keyboard exposing (..)
import Char exposing (fromCode)


-- import Mouse exposing (Position)

import Svg exposing (..)
import Svg.Attributes exposing (width, height, viewBox, cx, cy, r, fill)
import Random exposing (..)


-- import Task
-- import Window exposing (Size)

import Time exposing (Time, second)


-- MODEL


type alias CircleCenter =
    ( Int, Int )


type alias Model =
    { circles : List CircleCenter
    , keypressed : KeyCode
    , paused : Bool
    }


init : ( Model, Cmd Msg )
init =
    ( { circles = [], paused = False, keypressed = 0 }, Cmd.none )


getRandomPos : Int -> Int -> Int -> Cmd Msg
getRandomPos min maxWidth maxHeight =
    Random.generate NewCircle (Random.pair (Random.int min maxWidth) (Random.int min maxHeight))



-- UPDATE


type Msg
    = NewCircle ( Int, Int )
    | Tick Time
    | ButtonPress KeyCode


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NewCircle xy ->
            if model.paused then
                ( model, Cmd.none )
            else
                ( { model | circles = xy :: model.circles }, Cmd.none )

        Tick time ->
            ( model, getRandomPos 10 380 380 )

        ButtonPress key ->
            let
                togglePause =
                    if key == 112 then
                        not model.paused
                    else
                        model.paused
            in
                if key == 114 then
                    ( { model | circles = [] }, Cmd.none )
                else
                    ( { model | paused = togglePause }, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    let
        pauseText =
            if model.paused then
                "Unpause"
            else
                "Pause"
    in
        div []
            [ div
                []
                [ Html.text ("Paused: " ++ (toString model.paused)) ]
            , Svg.svg
                [ width "400", height "400", viewBox "0 0 400 400" ]
                (List.map smallCircleMaker model.circles)
            , div [ class "row" ]
                [ button
                    [ class "btn btn-lg btn-info", onClick (ButtonPress 112) ]
                    [ Html.text pauseText ]
                , button
                    [ class "btn btn-lg btn-danger pull-right", onClick (ButtonPress 114) ]
                    [ Html.text "Clear field and restart" ]
                ]
            ]


smallCircleMaker : ( Int, Int ) -> Svg Msg
smallCircleMaker pos =
    circleMaker 10 pos


circleMaker : Int -> ( Int, Int ) -> Svg Msg
circleMaker radius pos =
    circle [ cx (toString (fst pos)), cy (toString (snd pos)), r (toString radius), fill "#0B79CE" ] []


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch [ Time.every second Tick, Keyboard.presses ButtonPress ]


main : Program Never
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
