module Main exposing
    ( KeyCode
    , Model
    , Msg(..)
    , TaskItem(..)
    , enterKeyCode
    , todoHeaderView
    , todoItemListView
    , todoItemView
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


type TaskItem
    = Active String
    | Complete String


type alias Model =
    { newTodoContent : String, taskItemList : List TaskItem }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { newTodoContent = ""
      , taskItemList =
            [ Active "Buy a unicorn"
            , Complete "Taste JavaScript"
            ]
      }
    , Cmd.none
    )



---- UPDATE ----


type alias KeyCode =
    Int


type Msg
    = ChangeNewTodoItem String
    | KeyDownNewTodo KeyCode


enterKeyCode : Int
enterKeyCode =
    13


updateKeyDownNewTodo : KeyCode -> Model -> Model
updateKeyDownNewTodo keyCode { newTodoContent, taskItemList } =
    if keyCode == enterKeyCode then
        { newTodoContent = "", taskItemList = taskItemList }

    else
        { newTodoContent = newTodoContent, taskItemList = taskItemList }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg ({ newTodoContent } as model) =
    case msg of
        ChangeNewTodoItem content ->
            ( { model | newTodoContent = content }, Cmd.none )

        KeyDownNewTodo keyCode ->
            ( updateKeyDownNewTodo keyCode model, Cmd.none )



---- VIEW ----


view : Model -> Html Msg
view { taskItemList, newTodoContent } =
    section [ class "todoapp" ]
        [ todoHeaderView newTodoContent
        , section [ class "main" ]
            [ input [ id "toggle-all", class "toggle-all", type_ "checkbox" ] []
            , label [ for "togglea-ll" ] [ text "Mark all as complete" ]
            , todoItemListView taskItemList
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


todoItemView : TaskItem -> Html Msg
todoItemView taskItem =
    let
        { liClass, toggleAttributes, content } =
            case taskItem of
                Active c ->
                    { liClass = ""
                    , toggleAttributes = [ class "toggle", type_ "checkbox" ]
                    , content = c
                    }

                Complete c ->
                    { liClass = "completed"
                    , toggleAttributes = [ class "toggle", type_ "checkbox", checked True ]
                    , content = c
                    }
    in
    li [ class liClass ]
        [ div [ class "view" ]
            [ input toggleAttributes []
            , label [] [ text content ]
            , button [ class "destroy" ] []
            ]
        , input [ class "edit", value "" ] []
        ]


todoItemListView : List TaskItem -> Html Msg
todoItemListView taskItemList =
    ul [ class "todo-list" ]
        (taskItemList |> List.reverse |> List.map todoItemView)


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
