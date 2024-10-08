---
created: 2024-10-04 17:49
updated: 2024-10-08T18:35
---
# Ch2 과제
 ```dataview 
table 
dateformat(file.ctime, "yyyy-MM-dd") as "생성 날짜", 
dateformat(file.mtime, "yyyy-MM-dd") as "수정 날짜" 

FROM "1_Projects/제로베이스 대기업 취업 특별반/멘토링/Boost코스/Ch2"
WHERE file.name != "Ch2"
```

