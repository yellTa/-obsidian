---
Created time: Invalid date
Last edited time: Invalid date
Progress:
  - end
on Naver: false
업로드할까?: false
created: 2023-11-15T14:37:00
updated: 2024-08-27T17:52
---
# A tag click error

![[Untitled 3.png|Untitled 3.png]]

I found the element but I clicked it through Selenium then it’s not working

  

# The reason…

If a tag has href=”…” like specific link then click() method works but using javascript instead of href option then click method is not working.

  

## 💯Use Xpath

> [!important]  
> I tired a lots of ways… 1. mouse click selenium logic2. javascript logic  

But selenium can’t find element using class and id so I decided to use xPath instead of it. and It worked!…