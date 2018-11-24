module Tests exposing (suite)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Json.Encode as Encode exposing (Value)
import Main exposing (..)
import Test exposing (..)
import Test.Html.Event as Event
import Test.Html.Query as Query
import Test.Html.Selector as Selector


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
                        enterKey =
                            13

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
                        |> Event.simulate (Event.custom "keydown" <| simulatedKeyDownEventObject enterKey)
                        |> Event.expect (KeyDownNewTodo enterKey)
            ]
        , describe "updateKeyDownNewTodo"
            [ test "押されたキーがエンターキーだったとき、TODOアイテムの内容は空になる" <|
                \_ ->
                    let
                        enterKey =
                            13

                        actual =
                            updateKeyDownNewTodo enterKey "abc"

                        expected =
                            ""
                    in
                    Expect.equal actual expected
            , test "押されたキーがエンターキーではなかったとき、TODOアイテムの内容はそのまま" <|
                \_ ->
                    let
                        anotherKey =
                            12

                        actual =
                            updateKeyDownNewTodo anotherKey "abc"

                        expected =
                            "abc"
                    in
                    Expect.equal actual expected
            ]
        ]
