---
created: 2024-10-04 17:48
updated: 2024-10-04T17:48
---

# 간단한 폴더(날짜만)

 ```dataview 
table 
dateformat(file.ctime, "yyyy-MM-dd") as "생성 날짜", 
dateformat(file.mtime, "yyyy-MM-dd") as "수정 날짜" 

FROM "1_Projects/제로베이스 대기업 취업 특별반/멘토링/Boost코스"
WHERE file.name != "Boost코스"
```

