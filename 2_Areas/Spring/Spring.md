---
created: 2024-09-15T15:09
updated: 2024-09-15T15:09
---

# Spring 
```dataviewjs
//3,4 라인의 폴더 이름만 바꿔주면 된다.
const pages = dv.pages('"2_Areas/알고리즘/Spring"')
  .where(p => p.file.name !== "Spring")
  .sort(p => p.file.ctime, 'asc'); // 생성 날짜 기준으로 오름차순 정렬

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
      new Date(p.file.ctime).toISOString().split('T')[0], // 생성 날짜
      new Date(p.file.mtime).toISOString().split('T')[0], // 수정 날짜
      progress
    ];
  })
);




```