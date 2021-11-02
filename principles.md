---
currentMenu: solid
layout: default
title: Devops01
subTitle: Solid
---
## Solid

Basics of Coding Principles

![Basics](https://raw.githubusercontent.com/c4xp/Devops01/master/assets/coding_principles.png)

## Discussion

What problems are solved or avoided by applying SOLID?

Software may start with a clean and elegant design but over time they become hard to maintain, often requiring costly redesigns. Robert Martin, who's credited with writing down the SOLID principles, points out some symptoms of rotting design due to improperly managed dependencies across modules:

- Rigidity: Implementing even a small change is difficult since it's likely to translate into a cascade of changes.
- Fragility: Any change tends to break the software in many places, even in areas not conceptually related to the change.
- Immobility: We're unable to reuse modules from other projects or within the same project because those modules have lots of dependencies.
- Viscosity: When code changes are needed, developers will prefer the easier route even if they break existing design.

Antipatterns and improper understanding of design principles can lead to STUPID code: Singleton, Tight Coupling, Untestability, Premature Optimization, Indescriptive Naming, and Duplication. SOLID can help developers stay clear of these.

The essence of SOLID is managing dependencies. This is done via interfaces and abstractions. Modules and classes should not be tightly coupled.

SOLID Principles from Bob Martin[^1] who literally wrote the book[^4].

The first five principles are principles of class design. They are:

| Code  | Name                                   | Description   |
| :---: | ---                                    |          ---  |
| SRP   | The Single Responsibility Principle    | A class should have one, and only one, reason to change               |
| OCP   | The Open Closed Principle              | You should be able to extend a class behavior, without modifying it   |
| LSP   | The Liskov Substitution Principle      | Derived classes must be substitutable for their base classes          |
| ISP   | The Interface Segregation Principle    | Make fine grained interfaces that are client specific                 |
| DIP   | The Liskov Substitution Principle      | Depend on abstractions, not on concretions                            |

## Single Responsability Principle
### A class should have one, and only one, reason to change

Tom DeMarco[^2] and Melir Page-Jones[^3] described it cohesion, defined as the functional relatedness of the elements of a module -> forces that cause a module / class to change

[Wikipedia - Single responsibility principle](https://en.wikipedia.org/wiki/Single-responsibility_principle)

A class should have one and only one reason to change, meaning that a class should have only one job.
It means that if our class assumes more than one responsibility we will have a high coupling. The cause is that our code will be fragile at any changes.

Suppose we have a User class like the following:
```php
class User {
    private $email;
    // Getter and setter...
    public function store() {
        // Store attributes into a database...
    }
}
```

In this case, the method `store` is out of the scope and this responsibility should belong to a class that manages the database. The solution here is to create two classes each with proper responsibilities.
```php
class User {
    private $email;
    // Getter and setter...
}
class UserDB {
    public function store(User $user) {
        // Store the user into a database...
    }
}
```

## Open-closed Principle
### You should be able to extend a class behavior, without modifying it

Ivar Jacobson said that all systems change during their life cycles. This must be borne in mind when developing systems expected to last longer than the first version​.

Objects or entities should be open for extension but closed for modification

According to this principle, a software entity must be easily extensible with new features without having to modify its existing code in use.

Suppose we have to calculate the total area of some objects and to do that we need an AreaCalculator class that does only a sum of each shape area. The issue here is that each shape has a different method to calculate its own area.

```php

class Rectangle {
    public $width;
    public $height;
    public function __construct($width, $height) {
        $this->width = $width;
        $this->height = $height;
    }
}

class Square {
    public $length;
    public function __construct($length) {
        $this->length = $length;
    }
}


class AreaCalculator {
    protected $shapes;
    public function __construct($shapes = array()) {
        $this->shapes = $shapes;
    }
    public function sum() {
        $area = [];
        foreach($this->shapes as $shape) {
            if ($shape instanceof Square) {
                $area[] = pow($shape->length, 2);
            } else if($shape instanceof Rectangle) {
                $area[] = $shape->width * $shape->height;
            }
        }
        return array_sum($area);
    }
}
```

If we add another shape like a Circle we have to change the AreaCalculator in order to calculate the new shape area and this is not sustainable. The solution here is to create a simple Shape interface that has the area method and will be implemented by all other shapes. In this way, we will use only one method to calculate the sum and if we need to add a new shape it will just implement the Shape interface.

```php
interface Shape {
    public function area();
}

class Rectangle implements Shape {
    private $width;
    private $height;
    public function __construct($width, $height) {
        $this->width = $width;
        $this->height = $height;
    }
    public function area() {
        return $this->width * $this->height;
    }
}

class Square implements Shape {
    private $length;
    public function __construct($length) {
        $this->length = $length;
    }
    public function area() {
        return pow($this->length, 2);
    }
}

class AreaCalculator {
    protected $shapes;
    public function __construct($shapes = array()) {
        $this->shapes = $shapes;
    }
    public function sum() {
        $area = [];
        foreach($this->shapes as $shape) {
            $area[] = $shape->area();
        }
        return array_sum($area);
    }
}

```

## Liskov Substitution Principle
### Derived classes must be substitutable for their base classes

Barbara Liskov said that what is wanted here is something like the following substitution property:
Let q(x) be a property provable about objects of x of type T. Then q(y) should be provable for objects y of type S where S is a subtype of T.

The principle says that **objects must be replaceable by instances of their subtypes without altering the correct functioning of our system**.

Imagine managing two types of coffee machine. According to the user plan, we will use a basic or a premium coffee machine, the only difference is that the premium machine makes a good vanilla coffee plus than the basic machine. The main program behavior must be the same for both machines.

```php
interface CoffeeMachineInterface {
    public function brewCoffee($selection);
}

class BasicCoffeeMachine implements CoffeeMachineInterface {
    public function brewCoffee($selection) {
        switch ($selection) {
            case 'ESPRESSO':
                return $this->brewEspresso();
            default:
                throw new CoffeeException('Selection not supported');
        }
    }
    protected function brewEspresso() {
        // Brew an espresso...
    }
}

class PremiumCoffeeMachine extends BasicCoffeeMachine {
    public function brewCoffee($selection) {
        switch ($selection) {
            case 'ESPRESSO':
                return $this->brewEspresso();
            case 'VANILLA':
                return $this->brewVanillaCoffee();
            default:
                throw new CoffeeException('Selection not supported');
        }
    }
    protected function brewVanillaCoffee() {
        // Brew a vanilla coffee...
    }
}

function getCoffeeMachine(User $user) {
    switch ($user->getPlan()) {
        case 'PREMIUM':
            return new PremiumCoffeeMachine();
        case 'BASIC':
        default:
            return new BasicCoffeeMachine();
    }
}

function prepareCoffee(User $user, $selection) {
    $coffeeMachine = getCoffeeMachine($user);
    return $coffeeMachine->brewCoffee($selection);
}
```

## Interface Segregation Principle
### Make fine grained interfaces that are client specific

A client should never be forced to implement an interface that it doesn’t use or clients shouldn’t be forced to depend on methods they do not use.

This principle defines that **a class should never implement an interface that does not go to use**. In that case, means that in our implementations we will have methods that don’t need. The solution is to **develop specific interfaces instead of general-purpose interfaces**.

Imagine we invent the FutureCar that can both fly and drive…

```php
interface VehicleInterface {
    public function drive();
    public function fly();
}

class FutureCar implements VehicleInterface {
    public function drive() {
        echo 'Driving a future car!';
    }
    public function fly() {
        echo 'Flying a future car!';
    }
}

class Car implements VehicleInterface {
    public function drive() {
        echo 'Driving a car!';
    }
    public function fly() {
        throw new Exception('Not implemented method');
    }
}

class Airplane implements VehicleInterface {
    public function drive() {
        throw new Exception('Not implemented method');
    }
    public function fly() {
        echo 'Flying an airplane!';
    }
}
```

The main issue, as you can see, is that the Car and Airplane have methods that don’t use. The solution is to split the VehicleInterface into two more specific interfaces that are used only when it’s necessary, like the following:

```php
interface CarInterface {
    public function drive();
}

interface AirplaneInterface {
    public function fly();
}

class FutureCar implements CarInterface, AirplaneInterface {
    public function drive() {
        echo 'Driving a future car!';
    }
    public function fly() {
        echo 'Flying a future car!';
    }
}

class Car implements CarInterface {
    public function drive() {
        echo 'Driving a car!';
    }
}

class Airplane implements AirplaneInterface {
    public function fly() {
        echo 'Flying an airplane!';
    }
}
```

## Dependency Inversion Principle
### Depend on abstractions, not on concretions

Entities must depend on abstractions not on concretions. It states that the high level module must not depend on the low level module, but they should depend on abstractions.

This principle means that a particular class should not depend directly on another class but on an abstraction of this class. This principle allows for decoupling and more code reusability.

Let’s get the first example of the UserDB class. This class could depend on a DB connection:

```php
class UserDB {
    private $dbConnection;
    public function __construct(MySQLConnection $dbConnection) {
        $this->$dbConnection = $dbConnection;
    }
    public function store(User $user) {
        // Store the user into a database...
    }
}
```

In this case, the UserDB class depends directly from the MySQL database. That means that if we would change the database engine in use we need to rewrite this class and violate the Open-Close Principle.

The solution is to develop an abstraction of database connection:

```php
interface DBConnectionInterface {
    public function connect();
}

class MySQLConnection implements DBConnectionInterface {
    public function connect() {
        // Return the MySQL connection...
    }
}

class UserDB {
    private $dbConnection;
    public function __construct(DBConnectionInterface $dbConnection) {
        $this->dbConnection = $dbConnection;
    }
    public function store(User $user) {
        // Store the user into a database...
    }
}
```

## Criticisms

![Solid Criticism](https://raw.githubusercontent.com/c4xp/Devops01/master/assets/solid_criticism.png)

Too much separation and abstraction can make code unreadable

[Think IDEALS Rather than SOLID](https://www.infoq.com/articles/microservices-design-ideals/)

Paulo Merson notes in a blog article that SOLID was designed OOP. It may not exactly fit microservices. For microservices, he therefore proposes IDEALS: interface segregation, deployability (is on you), event-driven, availability over consistency, loose-coupling, and single responsibility.

![Ideals](https://raw.githubusercontent.com/c4xp/Devops01/master/assets/ideals.png)

I hope this article helps you to better understand what code quality is and maybe to improve your coding ability! Happy coding! 

Bibliography:

[^1]: [UncleBob - Principles Of Ood](http://butunclebob.com/ArticleS.UncleBob.PrinciplesOfOod)
[^2]: Structured Analysis and System Specification, Tom DeMarco, Yourdon Press Computing Series, 1979
[^3]: The Practical Guide to Structured Systems Design, 2d. ed., Meilir Page-Jones, Yourdon Press Computing Series, 1988
[^4]: Agile Software Development: Principles, Patterns, and Practices, Robert C. Martin and Micah Martin, 2002
