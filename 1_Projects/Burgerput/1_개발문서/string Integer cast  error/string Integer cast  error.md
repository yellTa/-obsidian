---
Created time: Invalid date
Last edited time: Invalid date
Progress:
  - end
on Naver: false
업로드할까?: false
created: 2023-12-29T14:37:00
updated: 2024-08-27T17:53
---
# 💯

## SaveDataV1.java[CustomCheatMachine(Food)DataSave()]

![[Untitled 7.png|Untitled 7.png]]

Map으로 받아올 떄 String, String으로 받아왔다.

String.valueOf로 캐스팅해주지 않을 경우에는

  

> [!important]  
> java.lang.Integer cannot be cast to java.lang.String  

해당 에러가 발생했었다. 이미 Map으로 변환될 때 캐스팅 해줬지만 강제적으로 한 번 더 캐스팅해 준후 Int형태로 바꿔주면 된다.