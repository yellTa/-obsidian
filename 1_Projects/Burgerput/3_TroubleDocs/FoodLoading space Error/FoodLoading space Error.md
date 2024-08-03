---
progress:
  - end
Created time: Invalid date
Last edited time: Invalid date
Review여부: false
post됨: false
post할까?: false
---
# Issue

FoodLoading Failed on 오버이지에그패티

![[images/Untitled 42.png|Untitled 42.png]]

Couldn’t load these.

  

# Reason

Extract the temperature the the result was

```Shell
"140                                        "
```

the temp with space.

  

# Solution

![[images/Untitled 1 15.png|Untitled 1 15.png]]

Remove the “ “(space) with trim() method.

  

then it worked!!