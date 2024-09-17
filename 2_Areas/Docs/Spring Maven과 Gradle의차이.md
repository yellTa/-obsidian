---
created: 2024-09-17 12:57
updated: 2024-09-17T16:02
tags:
  - Spring
출처: 
---
# Spring Maven과 Gradle의 차이
## 빌드관리 도구란?
프로젝트에서 작성한 JAVA 코드와 프로젝트 내에 필요한 각종 xml, properties, jar파일을 JVM이나 WAS가 인식할 수 있도록 도와주는 과정 -> 빌드 자동화 도구

- 프로젝트 생성, 테스트 빌드, 배포 등의 작업을 위한 전용 프로그램
- 개발에 필요한 다양한 외부 라이브러리를 다운로드
- 빌드 도구 설정파일에 필요한 라이브러리의 종류, 버전, 종속성 정보를 명시해 필요한 라이브러리들을 설정파일을 통해 자동으로 다운로드해 간편하게 관리해주는 도구
## Maven
- 빌드 중인 프로젝트, 빌드 순서, 다양한 외부 라이브러리 종속성 관계를 pom.xml파일에 명시한다.
- 외부 저장소에서 필요한 라이브러리와 플러그인들을 다운로드 한 다음, 로컬 시스템의 캐싱에 모두 저장한다.
## Gradle
- Maven보다 코드가 간결하다.
- 큰 규모로 예상되는 multi-project빌드를 도울 수 있도록 디자인 되었다.
- 프로젝트의 어느 부분이 업데이트 되었는지 알 수 있어서 빌드에 점진적으로 추가할 수 있다.
- 업데이트가 이미 반영된 빌드의 부분은 더이상 재실행되지 않는다.(빌드시간이 단축될 수 있다.)
## Maven vs Gradle
Gradle ->  작업 의존성 그래프를 기반으로 함
Maven -> 고정적이고 선형적인 단계의 모델을 기반으로 함

Gradle은 어떤 task가 업데이트 되었고 안되었는지 체크하기 때문에 incremental build를 허용한다.
이미 업데이트된 태스크에 대해서는 작업이 실행되지 않아 빌드시간이 훨씬 단축된다.

### Maven 코드
```  java
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/maven-v4_0_0.xsd">
    <modelVersion>4.0.0</modelVersion>
    <groupId>com.programming.mitra</groupId>
    <artifactId>java-build-tools</artifactId>
    <packaging>jar</packaging>
    <version>1.0</version>
    <dependencies>
        <dependency>
            <groupId>junit</groupId>
            <artifactId>junit</artifactId>
            <version>4.11</version>
        </dependency>
    </dependencies>
    <build>
        <plugins>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-compiler-plugin</artifactId>
                <version>2.3.2</version>
            </plugin>
        </plugins>
    </build>
</project>
```

### Gradle
``` java
apply plugin:'java'
apply plugin:'checkstyle'
apply plugin:'findbugs'
apply plugin:'pmd'
version ='1.0'
repositories {
    mavenCentral()
}
dependencies {
    testCompile group:'junit', name:'junit', version:'4.11'
}
```
# 결론
![[Pasted image 20240917160213.png]]

인크리멘탈 빌드는 변경된 부분만 감지해 그 부분만 다시 빌드해 효율성을 높인다.

# REVIEW


---
# 참고
[Spring Maven과 Gradle비교하기](https://jisooo.tistory.com/entry/Spring-%EB%B9%8C%EB%93%9C-%EA%B4%80%EB%A6%AC-%EB%8F%84%EA%B5%AC-Maven%EA%B3%BC-Gradle-%EB%B9%84%EA%B5%90%ED%95%98%EA%B8%B0)

# 연결문서