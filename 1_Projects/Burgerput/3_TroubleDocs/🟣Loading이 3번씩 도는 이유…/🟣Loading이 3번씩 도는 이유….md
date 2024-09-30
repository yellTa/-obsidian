---
progress:
  - end
Created time: Invalid date
Last edited time: Invalid date
Review여부: false
post됨: false
post할까?: true
created: 2024-07-12T14:37:00
updated: 2024-09-30T10:02
---
현재 내가 진행하는 프로젝트는 매일 아침 홈페이지를 자동으로 검사하는 웹 크롤링 로직이 있다. cron을 이용해서 어떤 도메인으로 진입하면 크롤링이 수행되도록 설정했고 수행의 결과를 Body에 뿌려서 성공 → 로딩 완료 메일 보내기

실패 → 3번까지 수행해보고 안되면 더 이상 로딩을 수행하지 않음


하지만 큰 문제가 발생했는데 로딩이 성공이 됐어도 실패로 체크했던 것이다. 그래서 매일 아침 의미없는 로딩이 약 2회가량 수행되었고 로딩이 수행되는 도중에 크롤링하는 웹페이지를 사용하게 되면 페이지에 진입을 할 수 없어(사용자가 제출을 누르면 해당 웹페이지는 진입 불가상태가 됨 ㅠ) 잘못된 로딩 결과를 가져온 것이다. 실제로는 제대로 수행이 된 적이 있음에도…


# OBJECT:

# 1. 무한 로딩인줄 알았는데 아니더라구요

7월 10일 기준 매일 아침 로딩이 정상적으로 수행되었음에도 불구하고 3번씩도는 현상이 발생했다.(로딩이 도는 중간에 zenput을 입력해서 로딩이 3번째 로딩때 실패가 되어버렸다. - 진입할 수 없는 페이지를 검사하려 했기 때문)

처음엔 단순히 무한으로 도는줄 알았지만 11일 12일 확인해본 결과 매일 아침 3번씩 도는 것을 확인했다.

# 2. 로딩 결과 메일은 언제나 공란
로딩 결과 메일은 원래 Success!가 오도록 되어있다. 물론 성공한 경우에는 하지만 하지만 메일의 결과는 언제나 공란으로 오고 있었다.  

# ANALYSIS:

> [!important]  
> /root/scripts/autoLoadingScript.sh  

```Java
#!/bin/bash

API_URL="나의 도메인/loading"
LOG_FILE="/root/run.log"
MAX_RETRIES=3
RETRIES=0

echo "Cron Script Start"
while [ $RETRIES -lt $MAX_RETRIES ]
do
  response=$(curl -L -X GET $API_URL)
  result=$(echo "$response" | jq -r '.result')
  current_time=$(date "+%Y-%m-%d %H:%M:%S")

  # loading 값 확인
  if [ "$result" == true ]; then
    echo "[$current_time] Loading is true. Exiting the loop." >> $LOG_FILE
    sh Loading_Success.sh > sys.log
    ssmtp gojimin3095@gmail.com < sys.log
    ssmtp bbubboru22@gmail.com < sys.log
    break
  else
    echo "[$current_time] Loading is false. Retrying..." >> $LOG_FILE
    RETRIES=$((RETRIES + 1))
  fi

  # 일정 시간 대기 후 다음 시도
  sleep 5
done

if [ $RETRIES -eq $MAX_RETRIES ]; then
  echo "[$current_time] Reached maximum retries. Exiting without success." >> $LOG_FILE
  sh Loading_Failed.sh > sys.log
  ssmtp gojimin3095@gmail.com < sys.log
  ssmtp bbubboru22@gmail.com < sys.log
fi
```

cron에 8시 34분에 돌도록 설정해놓은 코드이다. 이제 한 줄 한 줄 뜯어보자(어짜피로딩의 결과 메일도 공란으로 와서 고쳐야했다.)

우선 로그 파일의 결과도 함께 확인해보자

> [!important]  
> /root/run.log  

![[Untitled 46.png|Untitled 46.png]]

처참한 결과

서버를 옮기면서 Loading의 결과가 메일로 항상 공란으로 오고 있었다. 그저 잠시 오류때문에 그런거고 웹페이지를 봤을 때 큰 문제가 없었기 때문에 넘겼는데 언제나 로딩에 실패해서 3번씩 돌고있었다…

## 처음 서버가 올라왔을 때 부터 항상…

사태의 심각성을 지금 깨달아버렸다.

# Script파일 분석하기

아침에 수행되는 autoLoadingScript.sh의 파일의 정확한 분석이 필요했다.

```Java
#!/bin/bash
//수행할 도메인 링크
API_URL="나의 도메인/loading"
//로그를 저장할 파일
LOG_FILE="/root/run.log"
//로딩의 최대 시도
MAX_RETRIES=3
//현재 시도 값
RETRIES=0


echo "Cron Script Start"
//RETRIES의 값이 MAX_RETIRES가 될 때 까지 수행 즉 3번
while [ $RETRIES -lt $MAX_RETRIES ]
do
//API_RUL에 요청을 보내고 응답을 response에 저장한다.
  response=$(curl -L -X GET $API_URL)
  //response에서 JSON필드 result값을 추출해서 result변수에 저장
  result=$(echo "$response" | jq -r '.result')
  //현재 시간과 시간의 형식으로 current_time변수에 저장
  current_time=$(date "+%Y-%m-%d %H:%M:%S")

  # loading 값 확인
  //result값이 true인지 확인 
  if [ "$result" == true ]; then
    echo "[$current_time] Loading is true. Exiting the loop." >> $LOG_FILE
    //sh Loading_scurress.sh를 실행하고 그 결과를 sys.log파일에 저장한다.
    sh Loading_Success.sh > sys.log
    //sys.log의 파일 내용을 메일에게 전달한다.
    ssmtp gojimin3095@gmail.com < sys.log
    ssmtp bbubboru22@gmail.com < sys.log
    //루프 종료
    break
  else
  //현재 시간을 포함해서 로그 파일에 Loading Retrying을 보낸다.
    echo "[$current_time] Loading is false. Retrying..." >> $LOG_FILE
		//재시도 횟수를 1 증가시킨다.
    RETRIES=$((RETRIES + 1))
  fi

  # 일정 시간 대기 후 다음 시도
  sleep 5
done

//최대 재시도 횟수에 도달한 경우 로그파일에 echo의 내용 기록
if [ $RETRIES -eq $MAX_RETRIES ]; then
  echo "[$current_time] Reached maximum retries. Exiting without success." >> $LOG_FILE
	//Loading_failed.sh를 수행하고 sys.log파일에 저장
  sh Loading_Failed.sh > sys.log
  //파일의 내용 보내기...
  ssmtp gojimin3095@gmail.com < sys.log
  ssmtp bbubboru22@gmail.com < sys.log
fi
```

## 여기서 확인할 수 있는 로딩이 세 번 도는 이유:

```Java
  if [ "$result" == true ]; then
```

해당 부분에서 걸리지 않기 때문에 세 번씩 도는것…

  

그렇다면 코드를 먼저 봐보자

> [!important]  
> (Project Source) LoadingController.java  

```Java
        //로딩의 결과를 저장할 JSONArray 객체*/
        Map<String, String> resultMap = new LinkedHashMap<>();
        resultMap.put("result", "true");
        JSONArray jsonArray = new JSONArray();

        try{
            //getInfo로 데이터 가져오기
            Map<Integer, Machine> infoMachine = machineLoadingAndEnterZenput.getInfo();

            //반환값을 jsonArray를 인자로 보내 저장
            alertLoading.MachineJsonMakerandDBSet(infoMachine, jsonArray);

        }catch(Exception e){
            log.info("Machine getInfo logic False");
            log.info(e.toString());
            resultMap.put("result", "false");

            return resultMap;
        }
        
      
```

일부만 가져왔다 어짜피 기기/식품 여부만 다르고 위와 같은 로직이 2번 돌아가게 된다.

그러면 명확하게 resultMap에서

key : result

value : “true” or “false”

값을 가지게 된다.

  
---

# false값으로 script결과 확인해보기…

현재 시간으로 12시34분 기준 true의 값은 매장 직원분들이 사용한 뒤라서 확인이 불가능하다. 그럼 false값으로 확인해보자

> [!important]  
> autoLoadingScript.sh  

```Java

#!/bin/bash

API_URL="https://burback.shop:8080/loading"
LOG_FILE="/root/run.log"
MAX_RETRIES=3
RETRIES=0

echo "Cron Script Start"
while [ $RETRIES -lt $MAX_RETRIES ]
do
  response=$(curl -L -X GET $API_URL)
  result=$(echo "$response" | jq -r '.result')
  current_time=$(date "+%Y-%m-%d %H:%M:%S")

  # loading 값 확인
  if [ "$result" == true ]; then
    echo "[$current_time] Loading is true. Exiting the loop." >> $LOG_FILE
    sh Loading_Success.sh > sys.log
    ssmtp gojimin3095@gmail.com < sys.log
    ssmtp bbubboru22@gmail.com < sys.log
    break
    //아래의 로직 추가!!!!
 elif ["%result" == false];then
    echo "[$current_time] Loading is false. Retrying..." >> $LOG_FILE
    RETRIES=$((RETRIES + 1))
    break;
 else
         echo "[$current_time] unknown value!!!" >> $LOG_FILE
         break;
  fi

  # 일정 시간 대기 후 다음 시도
  sleep 5
done

if [ $RETRIES -eq $MAX_RETRIES ]; then
  echo "[$current_time] Reached maximum retries. Exiting without success." >> $LOG_FILE
  sh Loading_Failed.sh > sys.log
  ssmtp gojimin3095@gmail.com < sys.log
  ssmtp bbubboru22@gmail.com < sys.log
fi
```

  

```Java
 elif ["%result" == false];then
    echo "[$current_time] Loading is false. Retrying..." >> $LOG_FILE
    RETRIES=$((RETRIES + 1))
    break;
 else
         echo "[$current_time] unknown value!!!" >> $LOG_FILE
         break;
  fi
```

result의 값이 false인 경우 (어짜피 response의 값은 문자열 true or false이다.) Loading is false가 나온다. 지금상황에서는 false만 수행할 수 있으니 로그파일에 해당 문구가 들어가면 성공이다.

  

어느 경우도 아닌 경우에는 unknown value가 들어가도록 설정했다.

이제 cron을 이용해 체크해보자!…

> [!important]  
> root의 crontab -e  

```Java


#  45 8 * * * /root/autoLoadingScript.sh
34 8 * * * . /root/scripts/autoLoadingScript.sh
00 4 * * *  pkill chrome
\#32 14 * * * touch /home/ubuntu/burgerput/croncron

42 12 * * * . /root/scripts/autoLoadingScript.sh


~
~
```

12시 42분에 수행되도록 설정했다…

  

```Java

root@burgerB:~/scripts# service cron status
● cron.service - Regular background program processing daemon
     Loaded: loaded (/lib/systemd/system/cron.service; enabled; vendor preset: enabled)
     Active: active (running) since Fri 2024-07-12 12:41:52 KST; 4s ago
       Docs: man:cron(8)
   Main PID: 682795 (cron)
      Tasks: 1 (limit: 1121)
     Memory: 356.0K
        CPU: 2ms
     CGroup: /system.slice/cron.service
             └─682795 /usr/sbin/cron -f -P
```

cron을 수정하고 restart하는 것을 잊지 말자!…

  

## 결과!…

  

> [!important]  
> /root/run.log → script에 지정된 로그파일  

```Java
[2024-07-12 08:37:42] Loading is false. Retrying...
[2024-07-12 08:37:42] Reached maximum retries. Exiting without success.
[2024-07-12 12:43:26] unknown value!!!
```

unkown value가 가고 있는 것을 확인할 수 있다.

# Script의 $result값을 문자열이라고 정확하게 명시해보기

이제 unknown value로 가는 것을 확인했다. 그렇다면 이번에는 문자열임을 정확하게 명시해보는 방법을 사용해보자
### 참고

중간에 값을 불러오지 못함에도 결과값이 true로 반환되는 현상이 있었다. 해당 부분은 예외처리를 통해서 다시 설정해놓았다.

  

```Java
            if (section.isEmpty()) {
                throw new NoSuchElementException("Can't enter the zenput Food list page");
//                Food food = new Food();
//                food.setId(-1);
//                food.setName("no");
//                food.setMin(0);
//                food.setMax(0);
//                result.put(food.getId(), food);
```

section이 비어있는 경우 food객체를 기존에 생성했었는데 throw NoSuchElementExcpetion을 던져서 LoadingController에서 result를 false로 변경하도록 설정했다…

  

기존에는 예외 처리라는 방향을 생각하지 못했었다.
  

> [!important]  
> autoLoadingScripts.sh  

```Java
#!/bin/bash

API_URL="https://burback.shop:8080/loading"
LOG_FILE="/root/run.log"
MAX_RETRIES=3
RETRIES=0

echo "Cron Script Start"
while [ $RETRIES -lt $MAX_RETRIES ]
do
  response=$(curl -L -X GET $API_URL)
  result=$(echo "$response" | jq -r '.result')
  current_time=$(date "+%Y-%m-%d %H:%M:%S")

  # loading 값 확인
  if [ "$result" == "true" ]; then
    echo "[$current_time] Loading is true. Exiting the loop." >> $LOG_FILE
    sh Loading_Success.sh > sys.log
    ssmtp gojimin3095@gmail.com < sys.log
    ssmtp bbubboru22@gmail.com < sys.log
    break
 elif [ "$result" == "false" ];then
    echo "[$current_time] Loading is false. Retrying..." >> $LOG_FILE
    RETRIES=$((RETRIES + 1))
    break;
 else
         echo "[$current_time] unknown value!!!" >> $LOG_FILE
         break;
  fi

  # 일정 시간 대기 후 다음 시도
  sleep 5
done

if [ $RETRIES -eq $MAX_RETRIES ]; then
  echo "[$current_time] Reached maximum retries. Exiting without success." >> $LOG_FILE
  sh Loading_Failed.sh > sys.log
  ssmtp gojimin3095@gmail.com < sys.log
  ssmtp bbubboru22@gmail.com < sys.log
fi

~
```

true false를 문자열로 명시해줬다.

  

```Java
[2024-07-12 14:14:45] unknown value!!!
```

결과는 그래도 unknown이다. 이제는 확실하게 result의 값으로 어떤 값이 들어오는지 확인해야한다…
  

```Java
#!/bin/bash

API_URL="https://burback.shop:8080/loading"
LOG_FILE="/root/run.log"
MAX_RETRIES=3
RETRIES=0

echo "Cron Script Start"
while [ $RETRIES -lt $MAX_RETRIES ]
do
  response=$(curl -L -X GET $API_URL)
  result=$(echo "$response" | jq -r '.result')
  current_time=$(date "+%Y-%m-%d %H:%M:%S")
//추가된 디버깅 라인
  echo "[$current_time] Extracted result: '$result'" >> $LOG_FILE  # Debugging line

  # loading 값 확인
  if [ "$result" == "true" ]; then
    echo "[$current_time] Loading is true. Exiting the loop." >> $LOG_FILE
    echo "result value:$result" >> $LOG_FILE

    sh Loading_Success.sh > sys.log
    ssmtp gojimin3095@gmail.com < sys.log
    ssmtp bbubboru22@gmail.com < sys.log
    break
 elif [ "$result" == "false" ];then
    echo "[$current_time] Loading is false. Retrying..." >> $LOG_FILE
    echo "result value:$result" >> $LOG_FILE
    RETRIES=$((RETRIES + 1))
    break;
 else
         echo "[$current_time] unknown value!!!" >> $LOG_FILE
         echo "result value:$result" >> $LOG_FILE
         break;
  fi

  # 일정 시간 대기 후 다음 시도
  sleep 5
done

if [ $RETRIES -eq $MAX_RETRIES ]; then
  echo "[$current_time] Reached maximum retries. Exiting without success." >> $LOG_FILE
  sh Loading_Failed.sh > sys.log
  ssmtp gojimin3095@gmail.com < sys.log
  ssmtp bbubboru22@gmail.com < sys.log
fi
```

  

unknown에서 result가 false로 들어오는지 체크하고 그리고 if구문이 시작하기 전에 result에 어떤 값이 들어갔는지 확인해볼 필요가 있다.

```Java
[2024-07-12 14:21:53] Loading is false. Retrying...
[2024-07-12 14:24:45] unknown value!!!
result value:false
[2024-07-12 14:30:35] Extracted result: 'false'
[2024-07-12 14:30:35] unknown value!!!
result value:false
```

차이점이 있다. 바로 위쪽은 Loading is false가 뜬 것

그리고 아래쪽은 unknown value가 떳다.

  

## 둘의 차이점

우선 첫 번째 제대로 정상작동한 것은

### 스크립트를 직접 수행

  

두 번째는

### cron을 이용해서 수행

이 차이점이 있었다. 그렇다면 autoLoading의 로직 자체에는 문제가 없지만 cron과 <span style="color:rgb(255, 128, 128)">스크립트를 직접 작동하는 방향에 있어서 문제가 발생한다는 뜻이었다.</span>

## crontab과 직접 실행의 차이

cron은 사용자의 셀 환경을 완벽하게 상속받지 않는다. 즉 필요한 환경변수, 경로 설정이 누락될 수 있다. 이로 인해서 autoLoadingScript에서 사용하는 jq같은 명령어가 제대로 작동하지 않을 수 있다.

  

## 방법 1. jq를 절대경로로 사용해보자

```Java
root@burgerB:~/scripts# which jq
/usr/bin/jq
```

해당 경로롤 autoScrtip에 직접 적용해보자

  

> [!important]  
> autoLoadingScripts.sh  

```Java

LOG_FILE="/root/run.log"
MAX_RETRIES=3
RETRIES=0
JQ_PATH="/usr/bin/jq"  # jq의 절대 경로

echo "Cron Script Start"
while [ $RETRIES -lt $MAX_RETRIES ]
doi
  response=$(curl -L -X GET $API_URL)
  //절대경로를 통해서 사용하도록 설정
  result=$(echo "$response" | $JQ_PATH -r '.result')
```

  

하지만 작동하지 않았다…

  

## 방법2. cron에서 수행방법을 바꿔보자!

. (source)를 사용하는 것과 cron에서 수행하는 것이 분명히 차이가 있다고 생각이 들었다. 그래서

```Java
00 15 * * * /bin/bash /root/scripts/autoLoadingScript.sh
```

/bin/bash로 수행방법을 바꿔보았다.

```Java
[2024-07-12 15:00:44] Extracted result: 'false'
[2024-07-12 15:00:44] Loading is false. Retrying...
result value:false
```

다행스럽게도 이제는 정상작동 하는 것을 확인할 수 있었다…

  

> [!important]  
> autoLoadingScripts.sh  

```Java

#!/bin/bash

API_URL="https://burback.shop:8080/loading"
LOG_FILE="/root/run.log"
MAX_RETRIES=3
RETRIES=0
JQ_PATH="/usr/bin/jq"  # jq의 절대 경로

echo "Cron Script Start"
while [ $RETRIES -lt $MAX_RETRIES ]
do
  response=$(curl -L -X GET $API_URL)
  result=$(echo "$response" | $JQ_PATH -r '.result')
  current_time=$(date "+%Y-%m-%d %H:%M:%S")

  echo "[$current_time] Extracted result: '$result'" >> $LOG_FILE  # Debugging line

  # loading 값 확인
  if [ "$result" == "true" ]; then
    echo "[$current_time] Loading is true. Exiting the loop." >> $LOG_FILE
    echo "result value:$result" >> $LOG_FILE

    sh Loading_Success.sh > sys.log
    ssmtp gojimin3095@gmail.com < sys.log
    ssmtp bbubboru22@gmail.com < sys.log
    break
 elif [ "$result" == "false" ];then
    echo "[$current_time] Loading is false. Retrying..." >> $LOG_FILE
    echo "result value:$result" >> $LOG_FILE
    RETRIES=$((RETRIES + 1))
  fi

  # 일정 시간 대기 후 다음 시도
  sleep 5
done

if [ $RETRIES -eq $MAX_RETRIES ]; then
  echo "[$current_time] Reached maximum retries. Exiting without success." >> $LOG_FILE
  sh Loading_Failed.sh > sys.log
  ssmtp gojimin3095@gmail.com < sys.log
  ssmtp bbubboru22@gmail.com < sys.log
fi
```

  

  

> [!important]  
> crontab의 설정내용  

```Java

#  45 8 * * * /root/autoLoadingScript.sh
34 8 * * * /bin/bash /root/scripts/autoLoadingScript.sh
00 4 * * *  pkill chrome
\#32 14 * * * touch /home/ubuntu/burgerput/croncron

\#00 15 * * * /bin/bash /root/scripts/autoLoadingScript.sh

```


# CONCLUSION:

## 원인 :
cron에서의 작업 환경은 실제 내가 사용하는 쉘의 환경을 상속받지 않는다. 따라서 cron을 수행했을 때 제대로 수행되지 않는 부분이 있었고 그 부분때문에 원했던 결과가 나오지 않았던 것이다.

## 작업 :

### 1. 원인을 찾기 위한 autoLoadingScript디버깅 과정

autoLoadingScripts.sh가 제대로 작동하지 않으니 에러가 난 것이라고 판단했다. 따라서 autoLaodingScript를 하나하나 뜯어보며 디버깅을 수행하고 조건의 중요한 변수가 되는 result값을 디버깅하고 찾아보았다.
  

참고로 이 과정중에서 실제 프로젝트 에러 처리 관련 bug도 고쳤다. 값을 가져올 수 없을때 Exception을 throw해서 false로 나오도록 처리했다.(기존에는 DB에 냅다 no라고 적어 넣어버렸었다. 결과는 true로 나왔었음)

### 2. 기다리기 귀찮아서 source 명령어로 수행한 autoLoadingScripts

우리 서비스 환경은 언제나 cron으로 수행되기 때문에 직접 수행할 생각은 하지 못했다. 하지만 cron으로 수행하면 언제나 시간을 지정하고 1분정도 기다려야하고 그게 귀찮아서 다이렉트로 실행했는데 작동했었다(그리고 정상작동 함).

  

### 3. crontab에 source가 아닌 /bin/bash로 명령수행

source를 사용하던 crontab에 /bin/bash를 통해서 쉘을 수행했다.

  

## 결과 :

정상작동하는 것을 확인했다…

# 결론:

## /bin/bash를 사용하는 것과 . (source)의 차이

### 1. /bin/bash

독립적인 Bash 셸에서 실행한다.

스크립트는 현재 쉘 환경을 상속받지 않는다.

스크립트 내에서 설정된 환경 변수가 함수는 부모 셸에 영향을 미치지 않는다.

  

### 2. . (source)

현재 셸에서 스크립트를 실행한다.

스크립트는 현재 셸의 환경을 상속받는다. 스크립트 내에서 설정된 환경 변수가 함수는 부모 셸에 영향을 미친다.

cron에서 . source를 사용할 경우 Conetab의 셸 환경에서 스크립트를 실행한다.

즉!

cron작업에서 . (source)를 사용할 때에는 예상치 못한 환경 변수등의 문제로 스크립트가 제대로 수행되지 않을 가능성이 있다. 따라서 cron에서 스크립트를 수행할때에는 독립적인 셸에서 스크립트를 수행해야 한다

  

> [!important]
> _**cron에서 스크립트를 사용할 때에는 환경 변수, 셸 설정 등의 문제로 독립적인 셸 /bin/bash를 사용하는 것이 일반적이다. . (source)사용은 권장되지 않는다.**_

  

# REVIEW:

뭔가 오래걸렸지만 정답은 별 것 아니었고(비록 내가 모르고 있었지만) 생각보다 그리 어려운 것도 아니었던 것… 지금까지 .(source) 명령어를 이용해서 항상 스크립트를 수행해왔었기 때문에 cron이 가지고 있는 환경 문제라는 것을 전혀 생각하지 않고있었다. 생각해보면 window에서 자바프로젝트 할 때도 환경변수 설정하고 c++할때도 환경변수 지정하는데 OS를 다루면서 환경변수 문제는 미처 생각하지 못했던 것 같다. 그냥 지정하라고 시켜서 지정했을 뿐 아니면 프로그램이 알아서 잘 지정해줬거나.

  

어찌 됐던 이번 경험으로 환경변수는 뭔가 다른 사람같다고 느껴졌다… 내가 불닭을 먹으면 매워서 먹지를 못하지만 다른 친구들은 좋아하는 것 처럼… OS환경도 그렇다는 것을 잊지 말자

  

## OS환경은 불닭을 먹는 사람과 같다. A는 매워하고 B는 안매워한다. 서로 갖고 있는 특징(환경 변수)가 달라서그렇다. 그래서 회사가 원한 의도(매워했으면 좋겠어~~)와 다른 결과가 나온 것! 잊지말자!…