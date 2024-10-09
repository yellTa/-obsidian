---
created: 2024-10-08T22:13
updated: 2024-10-09T11:13
---

# REVIEW
```dataviewjs
//3,4 라인의 폴더 이름만 바꿔주면 된다.
const pages = dv.pages('"1_Projects/제로베이스 대기업 취업 특별반/멘토링/Boost코스/Ch2/Review"')
  .where(p => p.file.name !== "Review")
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