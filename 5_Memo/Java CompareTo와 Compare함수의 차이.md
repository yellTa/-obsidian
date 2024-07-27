---
created: 2024-07-28 02:36
updated: 2024-07-28T02:42
tags:
  - java
  - algorithm
---
# Java CompareTo와 Compare함수의 차이

# 설명

## CompareTo
- 객체 내부에서 사용한다. 
-  implements Comparable<객체이름>
- 자연순서를 정의한다. 즉 객체 안에 정의해 놓으면 객체에 값이 들어갈 때 자동으로 정렬해준다는 뜻

```
class Person implements Comparable<Person> {//implements함
    private String name;
    private int age;


    @Override
    public int compareTo(Person other) {
        return Integer.compare(this.age, other.age);
    }

    @Override
    public String toString() {
        return name + " : " + age;
    }
// toString오버라이드도 잘 알아두자.
```


## Comparator
- 객체 외부에서 정렬 기준을 정의한다.
- 여러가지 정렬기준/특정상황을 정렬한다.

```
 List<Person> people = new ArrayList<>();
        people.add(new Person("Alice", 30));
        people.add(new Person("Bob", 25));
        people.add(new Person("Charlie", 35));
        people.add(new Person("David", 25));
        people.add(new Person("Edward", 30));

        // 나이로만 정렬하는 Comparator
        Comparator<Person> ageComparator = new Comparator<Person>() {
            @Override
            public int compare(Person p1, Person p2) {
                return Integer.compare(p1.getAge(), p2.getAge());
            }
        };

        Collections.sort(people, ageComparator);
```

# 출처/참고
chatgpt

# 연결 문서
[[java Map.EntrySet이란]]
[[Java HashMap을 정렬하는 법]]

