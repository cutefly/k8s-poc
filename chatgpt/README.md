# ChatGPT

## prompt 예시

### ex-1

```
1. 한글이름을 영어로 변환
2. 답변은 json으로 eng_name에 결과를 추가
3. 다른 설명은 제외
```

### ex-2

```
1. change korean name '최철원' to english name
2. response json with eng_name
3. remove '-' between words
4. 많이 사용하는 순으로 정렬
```

### ex-3

```
1. romanize korean name to english name
2. Commonly used expressions in Korean names
3. remove '-' between characters
4. response json with eng_name
```

### ex-4

```
1. romanize korean names to english name
2. Commonly used expressions in Korean names
3. remove '-' between characters
4. rsponse json with eng_name

```

### ex-5

```
1. Commonly used expressions in Korean names
2. romanize korean names to json with eng_name without '-' between characters
```

## one line prompt

````
1. romanize korean name to english name and reponse json format with eng_name without '-' between characters

2. romanize korean name delimited by `to english name and reponse json format with eng_name without '-' between characters`조성모```

3. romanize korean name delimited by `to english name which many peoples are using english expression and reponse json format with eng_name without '-' between characters`조성모```

4. romanize korean names delimited by `to json format with eng_name without '-' between characters`조성훈```

5. romanize korean name to english name and reponse json format with eng_name without - between characters
````

## chat api examples

- request

````text
You will be provided with a name in Korean delimited by `, and your task is to romanize it into English with only result. `최철원```
````

- response

````json
    {
      "role": "system",
      "content": "You will be provided with a name in Korean, and your task is to romanize it into English using json with eng_name."
    },
    {
      "role": "user",
      "content": "What is the english name of '최철원'?"
    }

    {"role": "system", "content": "You are a helpful assistant."},
    {"role": "user", "content": "romanize korean names delimited by ``` to json format with eng_name without '-' between characters? ```조성모```"}
````

### translation 예제

> https://platform.openai.com/docs/examples/default-translation
