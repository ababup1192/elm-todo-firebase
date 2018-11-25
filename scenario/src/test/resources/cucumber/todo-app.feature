Feature: TODOアプリ

  Scenario: 初期状態では、TODOリストは空である
    Given TODO アプリを開く
    Then すると、TODOリストは空である

  Scenario: 初期状態では、フッターが表示されない
    Given TODO アプリを開く
    Then フッターは空である

  Scenario: タスクアイテムの入力フォームは、Submit時にクリアされる。
    Given TODO アプリを開く
    When オートフォーカスされている入力フォームに、"new todo"と入力し、
    And エンターキーを押し
    Then すると、入力フォームから入力内容は消える

  Scenario: タスクアイテムの入力フォームに入力された内容が、Submit時にTODOリストの最後に追加される。
    Given TODO アプリを開く
    When オートフォーカスされている入力フォームに、"new todo"と入力し、
    And エンターキーを押し
    Then すると、TODOリストの最後に、内容が"new todo"のActiveなタスクが追加される

  Scenario: タスクアイテムの入力フォームが空だったとき、Submit時にTODOリストには追加されない。
    Given TODO アプリを開く
    Then エンターキーを押し
    Then すると、TODOリストは空である

  Scenario: タスクアイテムの入力フォームに入力された内容が、Submit時にTODOリストの最後に追加される。
    Given TODO アプリを開く
    When オートフォーカスされている入力フォームに、"new todo"と入力し、
    And エンターキーを押し
    Then すると、TODOリストの最後に、内容が"new todo"のActiveなタスクが追加される

  Scenario: タスクアイテムにチェック入れた場合、チェックが入り取り消し線が入る。
    Given TODO アプリを開く
    When オートフォーカスされている入力フォームに、"new todo"と入力し、
    And エンターキーを押し
    And 新しく追加されたタスクアイテムにチェックを入れる
    Then すると、TODOリストの最後に、内容が"new todo"のまま、取り消し線が入る
