---
created: 2024-09-14 12:45
updated: 2024-09-14T12:48
tags:
  - 코딩테스트준비
출처: https://school.programmers.co.kr/learn/courses/30/lessons/12951#
---
# JadenCase 문자열 만들기
``` java
class Solution {
    //소문자 97~ 122
    //대문자 65~ 90 A to Z
    public String solution(String s) {
        String answer ="";
        s = s.toLowerCase();
        
        char[] c = s.toCharArray();
        
        //첫글자를 대문자로
        if(c[0]<=122 && c[0]>=97){
            int x  =c[0];
            x = x-32; //대문자로 바꿈
            c[0] = (char)x;
        }
        
        //나머지 문자를 계산하기
        boolean flag = false;
        
        for(int i=0; i< c.length; i++){
            if(c[i] ==' '){
                flag = true;
            }else if(flag&& c[i]<=122 && c[i] >=97){//공백 다음 문자에 도달한 경우 
                flag = false;
                int x  = c[i];
                x =x-32;
                c[i] =(char)x;
                
            }else flag = false;
        
        }
        
        return new String(c);
    }
}
```


## IDEA
1. 모든 문자열을 소문자로 바꾼다.
2. 첫 번째 문자열을 대문자로 바꾼다.(이거 딱히 따로 처리 안해도 됐었던듯ㅋ)
3. 공백 다음에 오는 문자열을 대문자로 처리한다.(이때 공백 다음에 숫자가 올 수도 있음)


``` java
//나머지 문자를 계산하기
        boolean flag = false;
        
        for(int i=0; i< c.length; i++){
            if(c[i] ==' '){
                flag = true;
            }else if(flag&& c[i]<=122 && c[i] >=97){//공백 다음 문자에 도달한 경우 
                flag = false;
                int x  = c[i];
                x =x-32;
                c[i] =(char)x;
                
            }else flag = false;
        
        }
        
```
문자열을 쪼개고 공백이 나타났을때 flag를 True로 변경한다.

flag가 true이면서 소문자 범위에 있는 애들은 대문자로 변경해야할 애들이다.
그래서 대문자로 변경해줌

flag가 true인데 소문자 범위에 있지 않은 애들도 있다. 얘네는 숫자의 경우 이런 경우는 대문자로 변경할 수 없으니 flag를 false로 지정한다.

# REVIEW
코드는 잘 짯으나 엣지케이스를 잘 못짯다 ㅋ ㅠㅠ
