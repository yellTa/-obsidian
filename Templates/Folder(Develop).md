---
created: "{{date}} {{time}}"
updated: 2024-09-04T16:45
---
# DataView(Progress에 따라서 색상까지)
```dataviewjs
//3,4 라인의 폴더 이름만 바꿔주면 된다.
const pages = dv.pages('"폴더의 경로"')
  .where(p => p.file.name !== "폴더의 이름")
.sort(p => p.created, 'asc'); // created 태그 기준으로 오름차순 정렬

dv.table(
  ["파일 이름", "생성 날짜", "수정 날짜", "Progress"],
  pages.map(p => {
    const progress = p.progress ? String(p.progress) : "";
    let fileName;

    if (progress.toLowerCase() === "unsolved") {
      fileName = `<a href="${p.file.path}" class="internal-link unsolved-link">${p.file.name}</a>`;
    } else if (progress.toLowerCase() === "ongoing") {
      fileName = `<a href="${p.file.path}" class="internal-link ongoing-link">${p.file.name}</a>`;
    } else {
      fileName = `<a href="${p.file.path}" class="internal-link">${p.file.name}</a>`;
    }

    return [
      fileName,
      new Date(p.created).toISOString().split('T')[0], // 생성 날짜
      new Date(p.updated).toISOString().split('T')[0], // 수정 날짜
      progress
    ];
  })
);




```

# 간단한 폴더(날짜만)

 ```dataview 
table 
dateformat(file.ctime, "yyyy-MM-dd") as "생성 날짜", 
dateformat(file.mtime, "yyyy-MM-dd") as "수정 날짜" 

FROM "1_Projects/제로베이스 대기업 취업 특별반/정기회의"
WHERE file.name != "정기회의"
```