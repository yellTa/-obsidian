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

![[images/Untitled 47.png|Untitled 47.png]]

- Food Loaded only 2… (not perfectly loaded even Error occurred!)
- the Result return true… so Db updated with wrong value

# When

- executing FoodLoadingZenput

# Reason

- LoadingZenput’s catch statement catch the Error but doesn’t throw Exception  
    So LoadingController recognize Exception is not exist!!! so the db-setup with wrong value.  
    

  

---

# Solution

1. LoadingZenput has to throw Exception when error occurred
2. LoadingController handle the Exception and Error occurred return false

  

# 1. throw Exception to LoadingZenput

  

```Shell
 catch (Exception e) {
            log.info("Food GetInfo Error occurred !");
            log.info(e.toString());

            throw new Exception(e); // -> Added line for trhow Exception
        }
```

Add throw Exception to getInfo logic()

Error occurred when doing getInfo logic then, catch statement executed print the log and throw Excpetion.

then The loading controller take the exception and handle it

  

# 2. Loading controller’s error handle

```Shell
//Loading controller's logic
       
        log.info("Loading Logic Start  ={}", LocalDateTime.now());
        //Start Loading Logic
        //loading zenput Page's Data first
        Map<String, String> resultMap = new LinkedHashMap<>();
        resultMap.put("result", "true");
        try {
            log.info("MACHINE DATA GET STASRT");
            Map<Integer, Machine> machineInfo = machineLoadingAndEnterZenput.getInfo();
            log.info("loaded Machine Map info : {}", machineInfo);

            log.info("FOOD DATA GET STASRT");
            Map<Integer, Food> foodInfo = foodLoadingAndEnterZenput.getInfo();
            log.info("Loaded Food Map info : {}", foodInfo);

            if (machineInfo.size() == 1 || foodInfo.size() ==1) {
                //false
                log.info("FALSE RESULT RETURN = false");
                resultMap.put("result", "false");

                return resultMap;
            }
            //====================loading logic================================
//        addMachine Logic=================================================
            ArrayList<Map> addMap = alertLoading.addMachine(machineInfo);
//
//        //del Machine logic
            ArrayList<Map> delMap = alertLoading.delMachine(machineInfo);
//
//        //editMachine logic=====================================
            ArrayList<Map> editMap = alertLoading.editMachine(machineInfo);
//
            //machine data를 로딩한 것으로 변경함
//      saveData.machinezenputdatasave(machineInfo);

            //====================Food logic start===========================
            ArrayList<Map> addFoodMap = alertLoading.addFood(foodInfo);
            ArrayList<Map> delFoodMap = alertLoading.delFood(foodInfo);
            ArrayList<Map> editFoodMap = alertLoading.editFood(foodInfo);

            ArrayList<Map> foodMaps = alertInfo(addFoodMap, delFoodMap, editFoodMap);

//=============save result To DB
//apply to DB -//only execute deleteMap(delete from customMachine and save whole machine data
            alertFoodInfoToDb(delFoodMap);
            alertMachineInfoToDb(delMap);

            saveData.machinezenputdatasave(machineInfo);
            saveData.foodZenputDataSave(foodInfo);

            log.info("Db Set-up END ");
//            response.sendRedirect(BURGERPUTSITE);

        } catch (Exception e) {
            resultMap.put("result", "false");
            log.info("Error from loading Controller!!! ");
            log.info(e.toString());
        }

        log.info("return value ={}", resultMap.get("result"));
        return resultMap;
```

  

## 2-1. Divide food getinfo logic and machine get info logic

### 2-1.a Divide Machine Logic

```Shell
try{
            log.info("MACHINE DATA GET STASRT");
            Map<Integer, Machine> machineInfo = machineLoadingAndEnterZenput.getInfo();
            log.info("loaded Machine Map info : {}", machineInfo);

            if (machineInfo.size() == 1) {
                //page loading fail case
                //false
                log.info("Machine Enter Page = false");
                resultMap.put("result", "false");

                return resultMap;
            }

            ArrayList<Map> addMap = alertLoading.addMachine(machineInfo);

            ArrayList<Map> delMap = alertLoading.delMachine(machineInfo);

            ArrayList<Map> editMap = alertLoading.editMachine(machineInfo);

            log.info("Add map Info :", addMap);
            log.info("Del MAP Info : ", delMap);
            log.info("Edited Map Info", editMap);


            alertMachineInfoToDb(delMap);
            saveData.machinezenputdatasave(machineInfo);

        }catch(Exception e){
            log.info("FALSE RESULT RETURN MACHINE= false");
            resultMap.put("result", "false");

            return resultMap;
        }
```

When getInfo logic Started if machineInfo map’s size ==1 then the result is false.

And when Exception occurred catch statement executed and the result turn to false from true.

  

addMap, delMap, editMap are the info, modified from previous Machine data list.

  

### 2-1.b Divide food logic

```Shell
try {
            log.info("FOOD DATA GET STASRT");
            Map<Integer, Food> foodInfo = foodLoadingAndEnterZenput.getInfo();
            log.info("Loaded Food Map info : {}", foodInfo);

            if (foodInfo.size() ==1) {
                //false
                log.info("FALSE RESULT RETURN = false");
                resultMap.put("result", "false");

                return resultMap;
            }


            ArrayList<Map> addFoodMap = alertLoading.addFood(foodInfo);
            ArrayList<Map> delFoodMap = alertLoading.delFood(foodInfo);
            ArrayList<Map> editFoodMap = alertLoading.editFood(foodInfo);

            ArrayList<Map> foodMaps = alertInfo(addFoodMap, delFoodMap, editFoodMap);

            log.info("Food DB set-up ");

            alertFoodInfoToDb(delFoodMap);
            saveData.foodZenputDataSave(foodInfo);

        } catch (Exception e) {
            resultMap.put("result", "false");
            log.info("Error from loading Controller!!! ");
            log.info(e.toString());
        }
```

  

  

# 2-2. final code

```Shell
 public Map<String,String> loading(HttpServletRequest request, HttpServletResponse response) throws IOException {

        log.info("Loading Logic Start  ={}", LocalDateTime.now());
        //Start Loading Logic
        //loading zenput Page's Data first
        Map<String, String> resultMap = new LinkedHashMap<>();
        resultMap.put("result", "true");

        try{
            log.info("MACHINE DATA GET STASRT");
            Map<Integer, Machine> machineInfo = machineLoadingAndEnterZenput.getInfo();
            log.info("loaded Machine Map info : {}", machineInfo);

            if (machineInfo.size() == 1) {
                //page loading fail case
                //false
                log.info("Machine Enter Page = false");
                resultMap.put("result", "false");

                return resultMap;
            }

            ArrayList<Map> addMap = alertLoading.addMachine(machineInfo);

            ArrayList<Map> delMap = alertLoading.delMachine(machineInfo);

            ArrayList<Map> editMap = alertLoading.editMachine(machineInfo);

            log.info("Add map Info :", addMap);
            log.info("Del MAP Info : ", delMap);
            log.info("Edited Map Info", editMap);

            log.info("Machine DB set-up ");
            alertMachineInfoToDb(delMap);
            saveData.machinezenputdatasave(machineInfo);

        }catch(Exception e){
            log.info("Machine getInfo logic False");
            log.info(e.toString());
            resultMap.put("result", "false");

            return resultMap;
        }

        try {
            log.info("FOOD DATA GET STASRT");
            Map<Integer, Food> foodInfo = foodLoadingAndEnterZenput.getInfo();
            log.info("Loaded Food Map info : {}", foodInfo);

            if (foodInfo.size() ==1) {
                //false
                log.info("Food Enter Page = false");
                resultMap.put("result", "false");

                return resultMap;
            }


            ArrayList<Map> addFoodMap = alertLoading.addFood(foodInfo);
            ArrayList<Map> delFoodMap = alertLoading.delFood(foodInfo);
            ArrayList<Map> editFoodMap = alertLoading.editFood(foodInfo);

            ArrayList<Map> foodMaps = alertInfo(addFoodMap, delFoodMap, editFoodMap);

            log.info("Food DB set-up ");

            alertFoodInfoToDb(delFoodMap);
            saveData.foodZenputDataSave(foodInfo);

        } catch (Exception e) {
            resultMap.put("result", "false");
            log.info("Food getInfo logic false");
            log.info(e.toString());

            return resultMap;
        }

        log.info("return value ={}", resultMap.get("result"));
        return resultMap;
    }
    
```

  

  

  

---

> [!info] [Spring Boot] JdbcSQLSyntaxErrorException: Syntax error in SQL statement ... expected "identifier" 해결  
> [Spring Boot] @DataJpaTest 잘못된 사용 오류 해결  
> [https://velog.io/@jwkim/spring-boot-datajpatest-error](https://velog.io/@jwkim/spring-boot-datajpatest-error)  

와 나 Spring jpa Table 안마들어져서 개고생했는데 I set-up test file @SpringbootTest instead of @JPADataTest then it worrkd r아아아아ㅏㅏ아ㅏ아