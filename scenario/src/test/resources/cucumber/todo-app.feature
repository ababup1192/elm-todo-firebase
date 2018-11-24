Feature: TODOアプリ

  Scenario: Submitしたとき、TODOアイテムの入力フォームから入力内容は消える。
    Given TODO アプリを開き
    When オートフォーカスされている入力フォームに、"new todo"と入力し、
    And エンターキーを押すと
    Then 入力フォームから入力内容は消える

  Scenario: Submitしたとき、入力されたTODOアイテムはTODOリストの最後に追加される。
    Given TODO アプリを開き
    When オートフォーカスされている入力フォームに、"new todo"と入力し、
    And エンターキーを押すと
    Then TODOリストの最後に、内容が"new todo"のActiveなタスクが追加される
