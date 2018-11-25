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


updateKeyDownNewTodoTest : TestCase -> KeyCode -> Model -> Model -> Test
updateKeyDownNewTodoTest testCase keyCode model newModel =
    test testCase <|
        \_ ->
            let
                actual =
                    updateKeyDownNewTodo keyCode model

                expected =
                    newModel
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
                "押されたキーがエンターキーだったとき、TODOアイテムの内容は空になり、Activeなタスクとしてリストの先頭に追加される"
                enterKeyCode
                (Model "abc" [ Complete "def" ])
                (Model "" [ Active "abc", Complete "def" ])
            , updateKeyDownNewTodoTest
                "押されたキーがエンターキーではなかったとき、TODOアイテムの内容はそのまま"
                12
                (Model "abc" [])
                (Model "abc" [])
            , updateKeyDownNewTodoTest
                "TODOアイテムの内容が空かつ、押されたキーがエンターキーだったとき、タスクリストは変わらない"
                enterKeyCode
                (Model "" [])
                (Model "" [])
            ]
        , describe "todoItemView" <|
            [ describe "完了していない 'new todo' タスクがあるとき" <|
                let
                    taskItem =
                        Active "new todo"
                in
                [ test "<li>は 'completed' class を持たない" <|
                    \_ ->
                        todoItemView taskItem
                            |> Query.fromHtml
                            |> Query.hasNot [ Selector.class "completed" ]
                , test "input.toggleは 'checked' を持たない" <|
                    \_ ->
                        todoItemView taskItem
                            |> Query.fromHtml
                            |> Query.find [ Selector.tag "input", Selector.class "toggle" ]
                            |> Query.hasNot [ Selector.checked True ]
                , test "<label>のTextは 'new todo' を持つ" <|
                    \_ ->
                        todoItemView taskItem
                            |> Query.fromHtml
                            |> Query.find [ Selector.tag "label" ]
                            |> Query.has [ Selector.text "new todo" ]
                ]
            , describe "完了している 'old todo' タスクがあるとき" <|
                let
                    taskItem =
                        Complete "old todo"
                in
                [ test "liは 'completed' class を持つ" <|
                    \_ ->
                        todoItemView taskItem
                            |> Query.fromHtml
                            |> Query.has [ Selector.class "completed" ]
                , test "input.toggleは 'checked' を持つ" <|
                    \_ ->
                        todoItemView taskItem
                            |> Query.fromHtml
                            |> Query.find [ Selector.tag "input", Selector.class "toggle" ]
                            |> Query.has [ Selector.checked True ]
                , test "labelのTextは 'old todo' を持つ" <|
                    \_ ->
                        todoItemView taskItem
                            |> Query.fromHtml
                            |> Query.find [ Selector.tag "label" ]
                            |> Query.has [ Selector.text "old todo" ]
                ]
            ]
        , describe "todoItemListView" <|
            [ describe "タスクアイテムが複数あるとき" <|
                let
                    taskItemList =
                        [ Active "Buy a unicorn"
                        , Complete "Taste JavaScript"
                        ]

                    taskItemListHtml =
                        todoItemListView taskItemList
                            |> Query.fromHtml
                            |> Query.findAll [ Selector.tag "li" ]

                    firstTaskLabel =
                        taskItemListHtml
                            |> Query.index 0
                            |> Query.find [ Selector.tag "label" ]

                    secondTaskLabel =
                        taskItemListHtml
                            |> Query.index 1
                            |> Query.find [ Selector.tag "label" ]
                in
                [ test "最初に表示されるアイテムは、'Teste JavaScript' である" <|
                    \_ ->
                        firstTaskLabel
                            |> Query.has [ Selector.text "Taste JavaScript" ]
                , test "２番目に表示されるアイテムは、'Buy a unicorn' である" <|
                    \_ ->
                        secondTaskLabel
                            |> Query.has [ Selector.text "Buy a unicorn" ]
                ]
            ]
        , describe "footerView" <|
            [ describe "タスクアイテムが無いとき" <|
                [ test "<footer>は、非表示である" <|
                    \_ ->
                        footerView []
                            |> Query.fromHtml
                            |> Query.has [ Selector.style "display" "none" ]
                ]
            ]
        ]
