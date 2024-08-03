---
progress:
  - end
Created time: Invalid date
Last edited time: Invalid date
Review여부: false
post됨: false
post할까?: false
---
# OBJECT:

```Java
# Edit this file to introduce tasks to be run by cron.
#
# Each task to run has to be defined through a single line
# indicating with different fields when the task will be run
# and what command to run for the task
#
# To define the time you can provide concrete values for
# minute (m), hour (h), day of month (dom), month (mon),
# and day of week (dow) or use '*' in these fields (for 'any').
#
# Notice that tasks will be started based on the cron's system
# daemon's notion of time and timezones.
#
# Output of the crontab jobs (including errors) is sent through
# email to the user the crontab file belongs to (unless redirected).
#
# For example, you can run a backup of all your user accounts
# at 5 a.m every week with:
# 0 5 * * 1 tar -zcf /var/backups/home.tgz /home/
#
# For more information see the manual pages of crontab(5) and cron(8)
#
# m h  dom mon dow   command
25 14 * * * /root/scripts/autoLoadingScript.sh
```

crontab이 14분 25분으로 설정되어 있다.

실제 버거풋 페이지는 8:35분에 정상수행된다.

# ANALYSIS:

처음 Burgerput을 수행할 때 timezone을 korea로 설정하지 않았었다. 그 이유로 시차를 적용해서 crontab을 적용했었었다.

현재는 로그를 편하게 보기위해서 timezone을 korea로 바꿔놓았다. log는 korea시간대로 나오고 있다.

# CONCLUSION:

5월 17일 기준 내가 서버를 함부로 건드릴 수 없는 상황이다. 처음에 putty로 접속했을 때 System reboot가 필요하다고 했던 것을 보면 현재 crontab은 시차가 적용된 상태로 재설정이 되지 않은것 같다.

# SOLVE:

서버를 테스트해봐야할 것 같다. 하지만 실제 프로젝트가 돌아가고있는 만큼 신중해야하는 것도 사실이다.

  

  

# REVIEW:

```Java
34 8 * * * . /root/scripts/autoLoadingScript.sh
00 4 * * *  pkill chrome
```

코드보니까 이렇게 세팅되어있었다 내가 잘못본것이 아니라 root계정으로 수행하면 이렇게 보인다.

계정별로 cron을 다르게 사욯하기 때문에 일어난 일이다.