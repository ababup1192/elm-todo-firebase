module Tests exposing (suite)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Json.Encode as Encode exposing (Value)
import Main exposing (..)
import Test exposing (..)
import Test.Html.Event as Event
import Test.Html.Query as Query
import Test.Html.Selector as Selector


type alias TestCase =
    String


updateKeyDownNewTodoTest : TestCase -> KeyCode -> String -> String -> Test
updateKeyDownNewTodoTest testCase keyCode content newContent =
    test testCase <|
        \_ ->
            let
                actual =
                    updateKeyDownNewTodo keyCode content

                expected =
                    newContent
            in
            Expect.equal actual expected


suite : Test
suite =
    describe "The Main module"
        [ describe "todoHeaderView"
            -- Nest as many descriptions as you like.
            [ test "TODOアイテム内容の入力をおこなったとき、ChangeNewTodoItem Msgが発行される" <|
                \_ ->
                    todoHeaderView ""
                        |> Query.fromHtml
                        |> Query.find [ Selector.tag "input" ]
                        |> Event.simulate (Event.input "new todo")
                        |> Event.expect (ChangeNewTodoItem "new todo")
            , test "TODOアイテム内容の入力時にエンターキー(KeyDownイベント時)を押したとき、KeyDownNewTodo Msgが発行される" <|
                \_ ->
                    let
                        simulatedKeyDownEventObject : Int -> Value
                        simulatedKeyDownEventObject key =
                            Encode.object
                                [ ( "keyCode"
                                  , Encode.int key
                                  )
                                ]
                    in
                    todoHeaderView ""
                        |> Query.fromHtml
                        |> Query.find [ Selector.tag "input" ]
                        |> Event.simulate (Event.custom "keydown" <| simulatedKeyDownEventObject enterKeyCode)
                        |> Event.expect (KeyDownNewTodo enterKeyCode)
            ]
        , describe "updateKeyDownNewTodo"
            [ updateKeyDownNewTodoTest
                "押されたキーがエンターキーだったとき、TODOアイテムの内容は空になる"
                enterKeyCode
                "abc"
                ""
            , updateKeyDownNewTodoTest
                "押されたキーがエンターキーではなかったとき、TODOアイテムの内容はそのまま"
                12
                "abc"
                "abc"
            ]
        , describe "todoItemView" <|
            [ describe "完了していない 'new todo' タスクがあるとき" <|
                let
                    taskItem =
                        TaskItem False "new todo"
                in
                [ test "liは 'completed' class を持つ" <|
                    \_ ->
                        todoItemView taskItem
                            |> Query.fromHtml
                            |> Query.has [ Selector.class "completed" ]
                , test "input.toggleは 'checked' を持たない" <|
                    \_ ->
                        todoItemView taskItem
                            |> Query.fromHtml
                            |> Query.find [ Selector.tag "input", Selector.class "toggle" ]
                            |> Query.hasNot [ Selector.checked True ]
                , test "labelのTextは 'new todo' を持つ" <|
                    \_ ->
                        todoItemView taskItem
                            |> Query.fromHtml
                            |> Query.find [ Selector.tag "label" ]
                            |> Query.has [ Selector.text "new todo" ]
                ]
            ]
        ]
