module Main exposing (..)

import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Mouse exposing (Position)
import Svg exposing (Svg, circle)
import Svg.Attributes exposing (viewBox, cx, cy, r)
import Random exposing (..)
import Task
import Window exposing (Size)


-- MODEL


type alias Model =
    { clickCount : Int
    , pos : Position
    , winSize : Size
    }


init : ( Model, Cmd Msg )
init =
    ( { clickCount = 0
      , pos = Position 0 0
      , winSize = Size 0 0
      }
    , getWinWidth
    )



-- Helper fn to get the window size, useful as a Cmd .


getWinWidth : Cmd Msg
getWinWidth =
    Task.perform identity CurrentSize Window.size



-- getRandomPos : Cmd Msg
-- getRandomPos =
--     Random.generate NewCircle (Random.pair (Random.int 1 380) (Random.int 1 380))
-- UPDATE


type Msg
    = Increment
    | Decrement
    | Reset
    | CurrentPos Position
    | CurrentSize Size



-- | NewCircle ( Int, Int )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Increment ->
            ( { model | clickCount = model.clickCount + 1 }, Cmd.none )

        Decrement ->
            ( { model | clickCount = model.clickCount - 1 }, Cmd.none )

        Reset ->
            ( { model | clickCount = 0 }, Cmd.none )

        CurrentPos position ->
            ( { model | pos = position }, Cmd.none )

        CurrentSize size ->
            ( { model | winSize = size }, Cmd.none )



-- NewCircle {x, y} ->
--     ( {model | })
-- VIEW


view : Model -> Html Msg
view model =
    let
        halfWidth =
            model.winSize.width // 2
    in
        div []
            [ button
                [ class "btn btn-lg btn-primary", onClick Decrement ]
                [ text " - " ]
            , div [] [ text (toString model.clickCount) ]
            , button
                [ class "btn btn-lg btn-info", onClick Increment ]
                [ text " + " ]
            , p [] []
            , button
                [ class "btn btn-lg btn-danger", onClick Reset ]
                [ text "Reset" ]
            , p [] []
            , code [] [ text (toString model.pos) ]
            , code [] [ text (toString model.winSize.width) ]
            , code [] [ text (toString halfWidth) ]
            , p [] []
            , (if halfWidth > model.pos.x then
                plate "Navy" "On The Left"
               else
                plate "Tomato" "On The Right"
              )
            , p [] []
            , div [] [ text "Next thiny goes here?" ]
            ]



-- in this case, pos happens to be a conveniently defined type
-- from Mouse -- even though I won't actually use Mouse.position
-- for this.


smallCircleMaker : Int -> Position -> Svg Msg
smallCircleMaker radius pos =
    Svg.svg
        [ width 400, height 400, viewBox "0 0 400 400" ]
        [ Svg.circle [ cx (toString pos.x), cy (toString pos.y), r "10" ] [] ]


plate : String -> String -> Html Msg
plate color displayText =
    div
        [ style (plateStyle color) ]
        [ text displayText ]


plateStyle : String -> List ( String, String )
plateStyle color =
    [ ( "background", color )
    , ( "color", "white" )
    , ( "width", "100%" )
    , ( "height", "400px" )
    , ( "display", "flex" )
    , ( "align-items", "center" )
    , ( "justify-content", "center" )
    ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch [ Mouse.moves CurrentPos, Window.resizes CurrentSize ]


main : Program Never
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
