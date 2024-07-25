---
created: 2024-07-23 23:47
updated: 2024-07-25T01:05
tags:
  - study
  - develop
  - html
  - cs
출처:
  - chatgpt
---
# Subject/Object
DOM이란 무엇인가?
# 나의 생각
HTML,XML 문서의 프로그래밍 인터페이스로서 문서의 구조를 계층적 트리 형태로 나타내는 모델이다. 프로그래머는 스크립트를 사용하여 문서의 콘텐츠, 구조 및 스타일을 접근하고 수정할 수 있다.

```
<!DOCTYPE html>
<html>
  <head>
    <title>Document</title>
  </head>
  <body>
    <h1>Hello, World!</h1>
    <p>This is a paragraph.</p>
  </body>
</html>

```

이 HTML 문서는 다음과 같은 DOM 트리로 표현됩니다:

### 주요 개념

1. **노드(Node)**: DOM은 노드로 구성된 트리 구조입니다. 각 노드는 문서의 요소를 나타냅니다. 노드는 여러 유형이 있습니다:
    
    - **요소 노드(Element Node)**: HTML 태그를 나타냅니다. 예: `<div>`, `<p>`.
    - **텍스트 노드(Text Node)**: 요소의 텍스트 콘텐츠를 나타냅니다.
    - **속성 노드(Attribute Node)**: 요소의 속성을 나타냅니다. 예: `id`, `class`.
    - **주석 노드(Comment Node)**: HTML 주석을 나타냅니다.

1. **트리 구조**: DOM은 문서의 계층 구조를 트리 형태로 나타냅니다. 최상위 노드는 문서 자체이며, 모든 요소와 텍스트는 이 트리의 노드로 표현됩니다.
    
    - **루트 노드(Root Node)**: 최상위 노드로, HTML 문서에서는 `<html>` 요소가 됩니다.
    - **부모 노드(Parent Node)**와 **자식 노드(Child Node)**: 각 노드는 자신을 포함하는 부모 노드와 자신이 포함하는 자식 노드를 가질 수 있습니다.
    - **형제 노드(Sibling Node)**: 동일한 부모를 공유하는 노드들입니다.
    
- `html`
    - `head`
        - `title`
            - `Document` (텍스트 노드)
    - `body`
        - `h1`
            - `Hello, World!` (텍스트 노드)
        - `p`
            - `This is a paragraph.` (텍스트 노드)

자바스크립트를 사용하여 DOM에 접근할 수 있다.

# 참고 문헌
chat gpt
# 연결 문서

