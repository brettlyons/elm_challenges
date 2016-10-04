module Main exposing (..)

import Html exposing (..)
import String exposing (..)
import Html.App as Html
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Json.Decode exposing (..)
import Task


-- import Keyboard exposing (..)

import Http
import Time exposing (Time, second)


-- MODEL


type alias Model =
    { textEntry : String
    , userInfo : UserInfo
    , seconds : Int
    }


type alias UserInfo =
    { userName : String
    , avatarUrl : String
    }


init : ( Model, Cmd Msg )
init =
    ( { textEntry = ""
      , userInfo = UserInfo "" ""
      , seconds = 0
      }
    , Cmd.none
    )



-- HTTP


getUserInfo : String -> Cmd Msg
getUserInfo userName =
    let
        url =
            "https://api.github.com/users/" ++ userName
    in
        Task.perform FetchFail FetchSucceed (Http.get decodeRemoteUserInfo url)


decodeRemoteUserInfo : Decoder UserInfo
decodeRemoteUserInfo =
    object2 UserInfo
        ("name" := string)
        ("avatar_url" := string)



-- UPDATE


type Msg
    = TextInput String
    | Tick Time
    | FetchFail Http.Error
    | FetchSucceed UserInfo


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick time ->
            ( if model.seconds < 4 then
                { model | seconds = model.seconds + 1 }
              else
                model
            , if model.seconds > 2 && model.seconds < 4 && (String.length model.textEntry) > 5 then
                (getUserInfo model.textEntry)
              else
                Cmd.none
            )

        TextInput name ->
            ( { model | textEntry = name, seconds = 0 }, Cmd.none )

        FetchFail _ ->
            ( model, Cmd.none )

        FetchSucceed newUserInfo ->
            ( { model | userInfo = newUserInfo, seconds = 0 }, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    let
        imgContents =
            if String.length model.userInfo.avatarUrl > 3 then
                [ img [ src model.userInfo.avatarUrl ] [] ]
            else
                []
    in
        div [ class "container" ]
            [ div [ class "row" ]
                [ input
                    [ placeholder "Github Username", onInput TextInput ]
                    []
                ]
            , div
                [ class "row" ]
                [ text ("Debug: model.seconds: " ++ (toString model.seconds)) ]
            , div [ class "row" ]
                [ text ("Name: " ++ model.userInfo.userName) ]
            , div [ class "row" ]
                imgContents
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
