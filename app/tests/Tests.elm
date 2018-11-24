module Tests exposing (suite)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
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
            ]
        ]
