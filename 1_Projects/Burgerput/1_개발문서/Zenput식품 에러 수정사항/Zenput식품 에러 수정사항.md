---
Created time: Invalid date
Last edited time: Invalid date
Progress:
  - end
on Naver: false
업로드할까?: false
created: 2024-01-09T14:37:00
updated: 2024-08-27T17:54
---
In recent days! I struggled with this problem

### The SendValueV2 from FoodLoadingAndSendValue

  

I found the different from the log picture

  

### SendMachine

![[Untitled 24.png|Untitled 24.png]]

  

## SendFood

![[Untitled 1 4.png|Untitled 1 4.png]]

  

for the last content, the Food Driver recognized the field doesn’t have a value…

So the button didin’t click.(maybe)

  

```Java
input.sendKeys(customMap.get("temp"));
                        input.sendKeys(Keys.TAB);  -> added tab key

                        Thread.sleep(250);
                        customMap.remove(id);
                        break;
```

hopefully works…

  

  

## It worked!!!!