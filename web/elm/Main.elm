module Main exposing (..)

import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (..)
import Mouse exposing (Position)
import Task
import Window exposing (Size)


-- MODEL


type alias Model =
    { pos : Position
    , winSize : Size
    }


init : ( Model, Cmd Msg )
init =
    ( { pos = Position 0 0
      , winSize = Size 0 0
      }
    , getWindowWidth
    )



-- Helper fn to get the window size, useful as a Cmd


getWindowWidth : Cmd Msg
getWindowWidth =
    Window.size |> Task.perform identity CurrentSize



-- UPDATE


type Msg
    = CurrentSize Size
    | CurrentPos Position


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        CurrentSize size ->
            ( { model | winSize = size }, Cmd.none )

        CurrentPos pos ->
            ( { model | pos = pos }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch [ Mouse.moves CurrentPos, Window.resizes CurrentSize ]



-- VIEW


view : Model -> Html Msg
view model =
    let
        halfWidth =
            model.winSize.width // 2
    in
        div []
            [ code [] [ text (toString model.pos) ]
            , code [] [ text (toString model.winSize) ]
            , code [] [ text (toString halfWidth) ]
            , p [] []
            , (if halfWidth > model.pos.x then
                plate "Green" "Right"
               else
                plate "Navy" "Left"
              )
            , p [] []
            ]


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


main : Program Never
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
