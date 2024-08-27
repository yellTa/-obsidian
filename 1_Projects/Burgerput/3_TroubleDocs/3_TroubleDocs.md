---
created: 2024-08-03T14:38
updated: 2024-08-27T18:15
---
# 3_TroubleDocs
 
```dataviewjs
const pages = dv.pages('"1_Projects/Burgerput/3_TroubleDocs"')
  .where(p => p.file.name !== "3_TroubleDocs")
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
 