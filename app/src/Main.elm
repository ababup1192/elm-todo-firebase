module Main exposing (Msg(..), todoHeaderView)

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
import Html.Events exposing (onInput)



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


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )



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
