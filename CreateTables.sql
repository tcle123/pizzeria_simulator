/** Taylor Le **/
CREATE SCHEMA IF NOT EXISTS PizzasRUs;
use PizzasRUs;

CREATE TABLE customer (
	CustomerID INT NOT NULL UNIQUE AUTO_INCREMENT,
    CustomerName VARCHAR(30) NOT NULL,
    CustomerPhone VARCHAR(30) NOT NULL,
    PRIMARY KEY (CustomerID)
);

CREATE TABLE topping (
	ToppingName VARCHAR(30) NOT NULL UNIQUE,
    ToppingPrice FLOAT NOT NULL,
    ToppingCost FLOAT NOT NULL,
    ToppingInventory INT NOT NULL,
    ToppingSM FLOAT NOT NULL,
    ToppingMD FLOAT NOT NULL,
    ToppingLG FLOAT NOT NULL,
    ToppingXLG FLOAT NOT NULL,
    ToppingMin INT NOT NULL,
    PRIMARY KEY (ToppingName)
);

CREATE TABLE discount (
	DiscountName VARCHAR(30) NOT NULL UNIQUE,
    DiscountPercent INT,
    DiscountDollar FLOAT,
    PRIMARY KEY (DiscountName)
);

CREATE TABLE baseprice (
	BasePriceSize VARCHAR(30) NOT NULL,
    BasePriceCrust VARCHAR(30) NOT NULL,
    BasePricePrice FLOAT NOT NULL,
    BasePriceCost FLOAT NOT NULL,
    PRIMARY KEY (BasePriceSize, BasePriceCrust)
);

CREATE TABLE orders (
	OrderID INT NOT NULL UNIQUE AUTO_INCREMENT,
    OrderCost FLOAT NOT NULL,
    OrderPrice FLOAT NOT NULL,
    OrderCustomerID INT,
    OrderTime TIME NOT NULL,
    OrderType VARCHAR(30) NOT NULL,
    OrderDate DATE NOT NULL,
    PRIMARY KEY (OrderID),
    FOREIGN KEY (OrderCustomerID) REFERENCES customer(CustomerID)
);

CREATE TABLE dinein (
	DineInID INT NOT NULL,
    DineInTable INT NOT NULL,
    PRIMARY KEY (DineInID),
    FOREIGN KEY (DineInID) REFERENCES orders(OrderID)
);

CREATE TABLE pickup (
	PickUpID INT NOT NULL,
    PRIMARY KEY (PickUpID),
    FOREIGN KEY (PickUpID) REFERENCES orders(OrderID)
);

CREATE TABLE delivery (
	DeliveryID INT NOT NULL,
    DeliveryAddress VARCHAR(50) NOT NULL,
    PRIMARY KEY (DeliveryID),
    FOREIGN KEY (DeliveryID) REFERENCES orders(OrderID)
);

CREATE TABLE pizza (
	PizzaID INT NOT NULL UNIQUE AUTO_INCREMENT,
    PizzaSize VARCHAR(30) NOT NULL,
    PizzaCrust VARCHAR(30) NOT NULL,
    PizzaPrice FLOAT NOT NULL,
    PizzaCost FLOAT NOT NULL,
    PizzaState BOOLEAN NOT NULL,
    PizzaOrderNum INT NOT NULL,
    PRIMARY KEY (PizzaID),
    FOREIGN KEY (PizzaSize, PizzaCrust) REFERENCES baseprice(BasePriceSize, BasePriceCrust),
	FOREIGN KEY (PizzaOrderNum) REFERENCES orders(OrderID)
);

/** Pizza Discount bridge table 
PizzaDiscName is discount name
PizzaDiscID is pizza id
**/
CREATE TABLE pizzadisc(
	PizzaDiscName VARCHAR(30) NOT NULL,
    PizzaDiscID INT NOT NULL,
    PRIMARY KEY (PizzaDiscName, PizzaDiscID),
    FOREIGN KEY (PizzaDiscName) REFERENCES discount(DiscountName),
	FOREIGN KEY (PizzaDiscID) REFERENCES pizza(PizzaID)
);

/** Pizza Topping bridge table 
PizzaToppingID is pizza id
PizzaToppingName is topping name
**/
CREATE TABLE pizzatopping(
	PizzaToppingID INT NOT NULL,
    PizzaToppingName VARCHAR(30) NOT NULL,
    PizzaToppingDoubled BOOLEAN NOT NULL,
    PRIMARY KEY (PizzaToppingID, PizzaToppingName),
    FOREIGN KEY (PizzaToppingID) REFERENCES pizza(PizzaID),
	FOREIGN KEY (PizzaToppingName) REFERENCES topping(ToppingName)
);

/** Order Discount bridge table
OrderDiscName is discount name
OrderDiscID is order ID
**/
CREATE TABLE orderdisc (
	OrderDiscName VARCHAR(30) NOT NULL,
    OrderDiscID INT NOT NULL,
    PRIMARY KEY (OrderDiscName, OrderDiscID),
    FOREIGN KEY (OrderDiscName) REFERENCES discount(DiscountName),
    FOREIGN KEY (OrderDiscID) REFERENCES orders(OrderID)
);