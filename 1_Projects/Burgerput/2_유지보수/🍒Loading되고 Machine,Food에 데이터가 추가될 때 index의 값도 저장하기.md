---
created: 2024-10-06 23:39
updated: 2024-10-07T00:08
tags:
  - develop
Progress:
  - ongoing
---
# OBJECT/SUBJECT:
## branch = feat/customIndex
# 구현할 기능:
Loading되고 Machine, Food에 데이터가 추가될 때 index의 값도 저장하기
# ANALYSIS:
## 설계
Loading에서 save를 할 때 Machine, Food열에 index도 함께 추가되도록 설정한다. 

``` java
int idx=0;  
for (WebElement field : elements) {  
  
    String id = field.getAttribute("id");  
    if (id.equals("field_295")) {  
        break;  
    } else {  
        Food contents = extractIdTitle(field);  
        if (!(contents.getName() == null)) {  
            idx++;  
            contents.setIndexValue(idx);  
            result.put(contents.getId(), contents);  
        }  
    }  
}
```

Loadinglogic에서 elements를 읽어오는 부분에 idx 변수를 지정하고 값을 다 불러온 후 idx를 추가하는 방식으로 수행했다.

--- 
# 서버에서 결과 확인하기 


---
# CONCLUSION:

## 원인 :

## 작업 :

## 결과 :

# 결론:
>[!important]


# REVIEW:


---
# References

# 연결문서
[[🌳기기, 식품 update후 맨 밑으로 가는거 해결하기...]]