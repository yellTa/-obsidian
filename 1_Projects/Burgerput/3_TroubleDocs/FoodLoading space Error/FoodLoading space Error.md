---
progress:
  - end
Created time: Invalid date
Last edited time: Invalid date
Review여부: false
post됨: false
post할까?: false
created: 2024-03-12T20:37:00
updated: 2024-08-27T14:36
---
# Issue

FoodLoading Failed on 오버이지에그패티

![[Untitled 42.png|Untitled 42.png]]

Couldn’t load these.

  

# Reason

Extract the temperature the the result was

```Shell
"140                                        "
```

the temp with space.

  

# Solution

![[Untitled 1 15.png|Untitled 1 15.png]]

Remove the “ “(space) with trim() method.

  

then it worked!!