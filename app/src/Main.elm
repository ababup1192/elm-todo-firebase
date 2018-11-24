module Main exposing
    ( Msg(..)
    , todoHeaderView
    , updateKeyDownNewTodo
    )

import Browser
import Html exposing (..)
import Html.Attributes
    exposing
        ( autofocus
        , checked
        , class
        , for
        , href
        , id
        , placeholder
        , src
        , type_
        , value
        )
import Html.Events exposing (keyCode, on, onInput)
import Json.Decode as Decode



---- MODEL ----


type alias Model =
    { newTodoContent : String }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { newTodoContent = "" }, Cmd.none )



---- UPDATE ----


type alias KeyCode =
    Int


type Msg
    = ChangeNewTodoItem String
    | KeyDownNewTodo KeyCode


updateKeyDownNewTodo : KeyCode -> String -> String
updateKeyDownNewTodo keyCode content =
    ""


update : Msg -> Model -> ( Model, Cmd Msg )
update msg ({ newTodoContent } as model) =
    case msg of
        ChangeNewTodoItem content ->
            ( { model | newTodoContent = content }, Cmd.none )

        KeyDownNewTodo keyCode ->
            ( { model | newTodoContent = updateKeyDownNewTodo keyCode newTodoContent }, Cmd.none )



---- VIEW ----


view : Model -> Html Msg
view { newTodoContent } =
    section [ class "todoapp" ]
        [ todoHeaderView newTodoContent
        , section [ class "main" ]
            [ input [ id "toggle-all", class "toggle-all", type_ "checkbox" ] []
            , label [ for "togglea-ll" ] [ text "Mark all as complete" ]
            , ul [ class "todo-list" ]
                [ li [ class "completed" ]
                    [ div [ class "view" ]
                        [ input [ class "toggle", type_ "checkbox", checked True ] []
                        , label [] [ text "Taste JavaScript" ]
                        , button [ class "destroy" ] []
                        ]
                    , input [ class "edit", value "Create a TodoMVC template" ] []
                    ]
                , li [ class "" ]
                    [ div [ class "view" ]
                        [ input [ class "toggle", type_ "checkbox" ] []
                        , label [] [ text "Buy a unicorn" ]
                        , button [ class "destroy" ] []
                        ]
                    , input [ class "edit", value "Rule the web" ] []
                    ]
                ]
            ]
        , footer [ class "footer" ]
            [ span [ class "todo-count" ]
                [ strong [] [ text "0" ]
                , text " item left"
                ]
            , ul [ class "filters" ]
                [ li []
                    [ a [ class "selected", href "#/" ] [ text "All" ]
                    ]
                , li []
                    [ a [ href "#/active" ] [ text "Active" ]
                    ]
                , li []
                    [ a [ href "#/completed" ] [ text "Completed" ]
                    ]
                ]
            , button [ class "clear-completed" ] [ text "Clear completed" ]
            ]
        ]


onKeyDown : (Int -> msg) -> Attribute msg
onKeyDown tagger =
    on "keydown" (Decode.map tagger keyCode)


todoHeaderView : String -> Html Msg
todoHeaderView newTodoContent =
    header [ class "header" ]
        [ h1 [] [ text "todos" ]
        , input
            [ class "new-todo"
            , placeholder "What needs to be done?"
            , value newTodoContent
            , autofocus True
            , onInput ChangeNewTodoItem
            , onKeyDown KeyDownNewTodo
            ]
            []
        ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }
