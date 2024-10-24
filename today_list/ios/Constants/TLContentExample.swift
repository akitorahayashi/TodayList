//
//  TLContentExample.swift
//  Runner
//
//  Created by 林 明虎 on 2024/10/05.
//

import Foundation

let noneId = "---n"

let kTLContentExample = """
[
  {
    "id": "workspace1",
    "name": "ToDo",
    "bigCategories": [
      { "id": "noneId", "title": "なし" },
      { "id": "superMarcketId", "title": "スーパー" },
      { "id": "hundredStoreId", "title": "100均" }
    ],
    "smallCategories": {
      "---n": [],
      "superMarcketId": [
        { "id": "vegetableId", "title": "野菜" }
      ],
      "hundredStoreId": []
    },
    "toDos": {
      "---n": {
        "toDosInToday": [
          {
            "id": "todo1",
            "title": "パスタ",
            "isChecked": false,
            "steps": [
              { "id": "step1", "title": "スパゲッティ", "isChecked": false },
              { "id": "step2", "title": "オリーブオイル", "isChecked": false }
            ]
          }
        ],
        "toDosInWhenever": []
      }
    }
  }
]
""";
