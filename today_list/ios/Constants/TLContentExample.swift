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
            "title": "パスタ",
            "isChecked": false,
            "steps": [
              { "title": "スパゲッティ", "isChecked": false },
              { "title": "オリーブオイル", "isChecked": false }
            ]
          },
          { "title": "キャベツ", "isChecked": false, "steps": [] },
          { "title": "にんじん", "isChecked": false, "steps": [] },
          { "title": "のり", "isChecked": false, "steps": [] },
          { "title": "まくらカバー", "isChecked": false, "steps": [] }
        ],
        "toDosInWhenever": []
      },
      "superMarcketId": {
        "toDosInToday": [],
        "toDosInWhenever": []
      },
      "vegetableId": {
        "toDosInToday": [],
        "toDosInWhenever": []
      },
      "hundredStoreId": {
        "toDosInToday": [
          { "title": "お皿", "isChecked": false, "steps": [] }
        ],
        "toDosInWhenever": []
      }
    }
  }
]
""";

