---
created: 2024-08-13T12:21
updated: 2024-08-14T01:14
---


```dataviewjs
//const pages, where의 폴더 경로만 바꿔주면 됨
const pages = dv.pages('"1_Projects/제로베이스 대기업 취업 특별반/Study/Algorithm"')
  .where(p => p.file.name !== "Algorithm");

dv.table(
  ["파일 이름", "생성 날짜", "수정 날짜", "Progress"],
  pages.map(p => {
    const progress = p.progress ? String(p.progress) : "";
    let fileName;
//progress가 unsolved일때랑 ongoing일때 css적용해준다. css는 custom-data-table.css
    if (progress.toLowerCase() === "unsolved") {
      fileName = `[[${p.file.path}|${p.file.name}]]`; // Markdown 링크 생성
      fileName = `<span class="unsolved-link">${fileName}</span>`;
    } else if (progress.toLowerCase() === "ongoing") {
      fileName = `[[${p.file.path}|${p.file.name}]]`;
      fileName = `<span class="ongoing-link">${fileName}</span>`;
    } else {
      fileName = `[[${p.file.path}|${p.file.name}]]`;
    }

    return [
      fileName,
      new Date(p.file.ctime).toISOString().split('T')[0],
      new Date(p.file.mtime).toISOString().split('T')[0],
      progress
    ];
  })
);


```
