---
layout: post
tags: [linux, commands]
title: Typescript setup and short tutorial
---

This is a just memorandum of my personal study. You can find the original contents in the references. 

## Basic

### Install

```
yarn global add typescript 
```

### Setup

make a 'tsconfig.json' file for your project, and modify appropriately.
```
{
    "compilerOptions": {
        "module": "commonjs",
        "target": "ES2015",
        "sourceMap": true,
        "outDir": "dist"
    },
    "include": [
        "src/**/*"
    ],
    "exclude": ["dist/node_modules"]
}
```

### Programming (incl. simple grammar explanation)
make a 'index.ts' file. You can choose any file name, but use '.ts' extension.

```
alert('hello')
```

#### variable

상수 또는 함수를 선언할 때는 
```
const fuckyeah:string = '개눌당 뒤져라';
```
일반적인 변수를 선언할 때,
```
let fuckyeah:string;
```
배열/리스트 변수를 선언할 때,
```
let fuckyeah:[string];
let fuckyeah:[my_class];
...
```

#### make a function

```
const hello = (iam, youare, sheis?) {
    console.log(`I am ${iam}, and you are ${you are}`);
}
```

함수 파라미터에 ?를 넣으면 optional임을 의미함.

#### strict parameter type
```
const hello = (iam:string, youare:string, sheis:number?):void {
    console.log(`I am ${iam}, and you are ${you are}`);
}
```
:void는 return이 없음을 의미.


#### make an object
```
const person = {
    name = "my name",
    gender = "male",
    age = 90
}
```
#### make an interface
```
interface Human = {
    name:string,
    gender:string,
    age:number
}
const hello = (person:Human):string => {
    return `${person.name}:${person.gender}:${person.age}`
}
hello(person)
```

#### make a class
```
class Human = {
    public name:string;
    public gender:string;
    public age:number;
    constructor(name:string, gender:string, age:number) {
       this.name = name;
       this.gender = gender;
       this.age = age;
   }
}
const ass = Human('fuckin','개눌당', 18);
const hello = (person:Human):string => {
    return `${person.name}:${person.gender}:${person.age}`
}
hello(ass)
```

### Compile (Convert '.ts' file to '.js' file)
this will make index.js and index.js.map files in the same directory.
```
$ tsc
```

## Enhanced 

### Using yarn (optional)

You can use yarn (just like 'npm') for building and executing your code. Make a 'package.json' as follows and touch them as you need.
```
{
    "name": "typechain",
    "version": "1.0.0",
    "description": "Learning TS by making BC",
    "main": "index.js",
    "repository": "https://github",
    "author": "Nicol",
    "license": "MIT",
    "scripts": {
        "start": "node index.js",
        "prestart": "tsp"
    },

}
```
when you type 'yarn start', the 'prestart' script will run precedently.


### Using tsc-watch(optional)


소스 코드를 고칠 때 마다 매번 'yarn start' 치는 것이 번거로울때 사용.
```
yar add tsc-watch --dev
```
그리고, package.json을 아래처럼 바꿔줌.
```
{
    "name": "typechain",
    "version": "1.0.0",
    "description": "Learning TS by making BC",
    "main": "index.js",
    "repository": "https://github",
    "author": "Nicol",
    "license": "MIT",
    "scripts": {
        "start": "tsc-watch --onSuccess \"node dist/index.js\" "
    },
    "dependencies": {
        "crypto-js": "^3.1.9-1",
        "typescript": "^3.6.4",
        "yarn": "^1.19.1"
    },
    "devDependencies": {
        "tsc-watch": "^4.0.0"
    }
}
```



[References]

