---
created: 2024-08-02T23:47
updated: 2024-08-02T23:55
---

```dataview 
table dateformat(file.ctime, "yyyy-MM-dd") as "생성 날짜", dateformat(file.mtime, "yyyy-MM-dd") as "수정 날짜" FROM "1_Projects/Burgerput/개발문서/AWS Files"
WHERE file.name != "AWS Files"
```
