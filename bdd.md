---
currentMenu: bdd
layout: default
title: Devops01
subTitle: Bdd
---

## What is BDD?

BDD is a way for software teams to work that closes the gap between business people and technical people.

![Lets do it](https://raw.githubusercontent.com/c4xp/Devops01/master/assets/lets_abcd.png)

- Encouraging collaboration across roles to build shared understanding of the the problem to be solved
- Working in rapid, small iterations to increase feedback and the flow of value
- Producing system documentation that is automatically checked against the system's behaviour

## Gherkin

Gherkin uses a set of special keywords to give structure and meaning to executable specifications. Each keyword is translated to many spoken languages; in this reference we’ll use English.

```
Feature
├── ..
├── Scenario
│   ├── Given
│   │   └── And
│   ├── When
│   │   └── And
│   └── Then
│       └── And
└── Scenario
    └── ..
```

## Gherkin pattern

- Describe an initial context (Given ..)
- Describe an event (When ..)
- Describe an expected outcome (Then ..)

## Exercitiu

```
composer update
vendor\bin\behat -dl
```

![Questions](https://raw.githubusercontent.com/c4xp/Devops01/master/assets/questions.png)

[Recap→](recap.md)