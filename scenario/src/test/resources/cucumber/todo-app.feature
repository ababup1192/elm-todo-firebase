Feature: TODOアプリ

  Scenario: 初期状態では、TODOリストは空である
    Given TODO アプリを開き
    Then TODOリストは空である

  Scenario: 初期状態では、フッターが表示されない
    Given TODO アプリを開き
    Then フッターは空である

  Scenario: TODOアイテムの入力フォームは、Submit時にクリアされる。
    Given TODO アプリを開き
    When オートフォーカスされている入力フォームに、"new todo"と入力し、
    And エンターキーを押すと
    Then 入力フォームから入力内容は消える

  Scenario: TODOアイテムの入力フォームに入力された内容が、Submit時にTODOリストの最後に追加される。
    Given TODO アプリを開き
    When オートフォーカスされている入力フォームに、"new todo"と入力し、
    And エンターキーを押すと
    Then TODOリストの最後に、内容が"new todo"のActiveなタスクが追加される


