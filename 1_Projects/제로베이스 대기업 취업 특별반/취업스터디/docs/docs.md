---
created: 2024-10-04T01:05
updated: 2024-10-04T01:05
---
 ```dataview 
table 
dateformat(file.ctime, "yyyy-MM-dd") as "생성 날짜", 
dateformat(file.mtime, "yyyy-MM-dd") as "수정 날짜" 

FROM "1_Projects/제로베이스 대기업 취업 특별반/취업스터디/docs"
WHERE file.name != "docs"

```
