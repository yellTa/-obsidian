---
created: "{{date}} {{time}}"
updated: 2024-09-08T01:22
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

# True를 블럭으로 표시하는 리스트 - 폴더이름만 바꿔주면 됨
```dataviewjs
// 데이터를 누적할 배열을 선언
let rows = [];

// 페이지를 순회하며 데이터를 배열에 추가
for (let page of dv.pages('"1_Projects/제로베이스 대기업 취업 특별반/멘토링"').where(p => p.file.name != "멘토링")) {
    let createdDate = new Date(page.file.ctime);
    let modifiedDate = new Date(page.file.mtime);
    
    // 한 페이지에 대한 데이터를 배열에 추가
    rows.push([
        page.file.link,  // 파일 이름을 클릭 가능한 링크로 변환
        createdDate.toLocaleDateString("en-CA"),  // 'yyyy-MM-dd' 형식으로 출력
        modifiedDate.toLocaleDateString("en-CA"),  // 'yyyy-MM-dd' 형식으로 출력
        page.멘토링날 ? `<span style="color:white; background-color:green; padding:2px; border-radius:4px;">True</span>` : page.멘토링날
    ]);
}

// 누적된 데이터를 한 번에 테이블로 출력
dv.table(["제목", "생성 날짜", "수정 날짜", "멘토링 날"], rows);

```

