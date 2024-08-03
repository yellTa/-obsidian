---
created: 2024-08-03T14:38
updated: 2024-08-03T14:44
---
# 3_TroubleDocs
 
```dataview 
table dateformat(file.ctime, "yyyy-MM-dd") as "생성 날짜", dateformat(file.mtime, "yyyy-MM-dd") as "수정 날짜" FROM "1_Projects/Burgerput/3_TroubleDocs"
WHERE file.name != "3_TroubleDocs"
```
 