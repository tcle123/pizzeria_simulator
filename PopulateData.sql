/** Taylor Le **/
use PizzasRUs;

DELIMITER //
/** in here i will add the pizza's size, crust, pizza state, and what order num it is in **/
CREATE PROCEDURE create_pizza (IN OrderID INT, IN PizzaSize VARCHAR(30), IN PizzaCrust VARCHAR(30), IN PizzaPrice FLOAT, IN PizzaCost FLOAT)
BEGIN
	INSERT INTO pizza(PizzaSize, PizzaCrust, PizzaPrice, PizzaCost, PizzaState, PizzaOrderNum)
    VALUES(
    (SELECT BasePriceSize FROM baseprice WHERE BasePriceCrust = PizzaCrust AND BasePriceSize = PizzaSize),
    (SELECT BasePriceCrust FROM baseprice WHERE BasePriceCrust = PizzaCrust AND BasePriceSize = PizzaSize), 
    PizzaPrice, PizzaCost, 1, OrderID);
END
//

/** this inserts the customer into the table with their info 
you only make a customer for pickup and delivery orders !! **/
CREATE PROCEDURE create_customer(IN CustomerName VARCHAR(30), IN CustomerPhone VARCHAR(30))
BEGIN
	INSERT INTO customer(CustomerName, CustomerPhone)
    VALUES(CustomerName, CustomerPhone);
END
//

/** THIS inserts into the pizza topping bridge entity **/
CREATE PROCEDURE create_topping(IN PizzaToppingID INT, IN PizzaToppingName VARCHAR(30), IN PizzaToppingDoubled BOOLEAN)
BEGIN
	INSERT INTO pizzatopping(PizzaToppingID, PizzaToppingName, PizzaToppingDoubled)
    VALUES( PizzaToppingID, (SELECT ToppingName FROM topping WHERE ToppingName = PizzaToppingName), PizzaToppingDoubled);
END
// 

/** inserts all the toppings **/
INSERT INTO topping
VALUES
("Pepperoni", 1.25, 0.2, 100, 2, 2.75, 3.5, 4.5, 10),
("Sausage", 1.25, 0.15, 100, 2.5, 3, 3.5, 4.25, 10),
("Ham", 1.5, 0.15, 78, 2, 2.5, 3.25, 4, 10),
("Chicken", 1.75, 0.25, 56, 1.5, 2, 2.25, 3, 10),
("Green Pepper", 0.5, 0.02, 79, 1, 1.5, 2, 2.5, 10),
("Onion", 0.5, 0.02, 85, 1, 1.5, 2, 2.75, 10),
("Roma Tomato", 0.75, 0.03, 86, 2, 3, 3.5, 4.5, 10),
("Mushrooms", 0.75, 0.1, 52, 1.5, 2, 2.5, 3, 10),
("Black Olives", 0.6, 0.1, 39, 0.75, 1, 1.5, 2, 10),
("Pineapple", 1, 0.25, 15, 1, 1.25, 1.75, 2, 10),
("Jalapenos", 0.5, 0.05, 64, 0.5, 0.75, 1.25, 1.75, 10),
("Banana Peppers", 0.5, 0.05, 36, 0.6, 1, 1.3, 1.75, 10),
("Regular Cheese", 1.5, 0.12, 250, 2, 3.5, 5, 7, 10),
("Four Cheese Blend", 2, 0.15, 150, 2, 3.5, 5, 7, 10),
("Feta Cheese", 2, 0.18, 75, 1.75, 3, 4, 5.5, 10),
("Goat Cheese", 2, 0.2, 54, 1.6, 2.75, 4, 5.5, 10),
("Bacon", 1.5, 0.25, 89, 1, 1.5, 2, 3, 10)
;

/** inserts all the discounts **/
INSERT INTO discount
VALUES
("Employee", 15, NULL),
("Lunch Special Medium", NULL, 1.00),
("Lunch Special Large", NULL, 2.00),
("Specialty Pizza", NULL, 1.50),
("Gameday Special", 20, NULL)
;

/** inserts base price and cost for size and crust **/
INSERT INTO baseprice
VALUES
("small", "Thin", 3, 0.5),
("small", "Original", 3, 0.75),
("small", "Pan", 3.5, 1),
("small", "Gluten-Free", 4, 2),
("medium", "Thin", 5, 1),
("medium", "Original", 5, 1.5),
("medium", "Pan", 6, 2.25),
("medium", "Gluten-Free", 6.25, 3),
("large", "Thin", 8, 1.25),
("large", "Original", 8, 2),
("large", "Pan", 9, 3),
("large ", "Gluten-Free", 9.5, 4),
("x-large", "Thin", 10, 2),
("x-large", "Original", 10, 3),
("x-large", "Pan", 11.5, 4.5),
("x-large", "Gluten-Free", 12.5, 6)
;

/** inserts all of the orders **/
/** for reference

CREATE TABLE orders (
	OrderID INT NOT NULL UNIQUE AUTO_INCREMENT,
    OrderCost FLOAT NOT NULL,
    OrderPrice FLOAT NOT NULL,
    OrderCustomerID INT NOT NULL,
    OrderTime TIME NOT NULL,
    OrderType VARCHAR(15) NOT NULL,
    OrderDate DATE NOT NULL,
    PRIMARY KEY (OrderID),
    FOREIGN KEY (OrderCustomerID) REFERENCES customer(CustomerID)
);
**/

/**
On March 5th at 12:03 pm there was a dine-in order for a large thin crust pizza with Regular Cheese 
(extra), Pepperoni, and Sausage (Price: 13.50, Cost: 3.68 ). They used the “Lunch Special Large” discount 
They sat at Table 14.
**/
/** make the order **/
INSERT INTO orders (OrderCost, OrderPrice, OrderTime, OrderType, OrderDate)
VALUES (3.68, 13.50, "12:03:00", "dinein", "2023-03-05");

/** fiol in dinein table since dinein order **/
INSERT INTO dinein(DineInID, DineInTable)
VALUES((SELECT MAX(OrderID) FROM orders), 14);

/** put pizza in the table **/
CALL create_pizza ((SELECT MAX(OrderID) FROM orders), "large", "thin", 13.50, 3.68);

/** put all the toppings on the pizza **/
CALL create_topping((SELECT MAX(PizzaID) FROM pizza), "Regular Cheese",  1);
CALL create_topping((SELECT MAX(PizzaID) FROM pizza), "Pepperoni",  0);
CALL create_topping((SELECT MAX(PizzaID) FROM pizza), "Sausage",  0);

/** put the discount for the order in **/
INSERT INTO pizzadisc(PizzaDiscName, PizzaDiscID)
VALUES((SELECT DiscountName FROM discount WHERE DiscountName = "Lunch Special Large"), (SELECT MAX(PizzaID) FROM pizza));

/**INSERT INTO orderdisc(OrderDiscName, OrderDiscID)
VALUES((SELECT DiscountName FROM discount WHERE DiscountName = "Lunch Special Large"), (SELECT MAX(OrderID) FROM orders));**/

/** On March 3rd at 12:05 pm there was a dine-in order At table 4. They ordered a medium pan pizza with
Feta Cheese, Black Olives, Roma Tomatoes, Mushrooms and Banana Peppers (P: 10.60, C: 3.23). They get 
the “Lunch Special Medium”and the “Specialty Pizza” discounts. They also ordered a small original crust 
pizza with Regular Cheese, Chicken and Banana Peppers (P: 6.75, C: 1.40)**/

INSERT INTO orders (OrderCost, OrderPrice, OrderTime, OrderType, OrderDate)
VALUES (4.63, 17.35, "12:05:00", "dinein", "2023-03-03");

INSERT INTO dinein(DineInID, DineInTable)
VALUES((SELECT MAX(OrderID) FROM orders), 4);

/** put pizza in the table **/
CALL create_pizza ((SELECT MAX(OrderID) FROM orders), "medium", "Pan", 10.60, 3.23);

/** put all the toppings on the pizza **/
CALL create_topping((SELECT MAX(PizzaID) FROM pizza), "Feta Cheese",  0);
CALL create_topping((SELECT MAX(PizzaID) FROM pizza), "Black Olives",  0);
CALL create_topping((SELECT MAX(PizzaID) FROM pizza), "Roma Tomato",  0);
CALL create_topping((SELECT MAX(PizzaID) FROM pizza), "Mushrooms",  0);
CALL create_topping((SELECT MAX(PizzaID) FROM pizza), "Banana Peppers",  0);

INSERT INTO pizzadisc(PizzaDiscName, PizzaDiscID)
VALUES((SELECT DiscountName FROM discount WHERE DiscountName = "Lunch Special Medium"), (SELECT MAX(PizzaID) FROM pizza));

INSERT INTO pizzadisc(PizzaDiscName, PizzaDiscID)
VALUES((SELECT DiscountName FROM discount WHERE DiscountName = "Specialty Pizza"), (SELECT MAX(PizzaID) FROM pizza));

/** make the secopmd pizza **/
CALL create_pizza ((SELECT MAX(OrderID) FROM orders), "small", "Original", 6.75, 1.40);

/** put all the toppings on the second pizza **/
CALL create_topping((SELECT MAX(PizzaID) FROM pizza), "Regular Cheese",  0);
CALL create_topping((SELECT MAX(PizzaID) FROM pizza), "Chicken",  0);
CALL create_topping((SELECT MAX(PizzaID) FROM pizza), "Banana Peppers",  0);

/** On March 3rd at 9:30 pm Ellis Beck places an order for pickup of 6 large original crust pizzas with Regular
Cheese and Pepperoni (Price: 10.75, Cost:3.30 each). Ellis’ phone number is 864-254-5861. **/
CALL create_customer("Ellis Beck", "864-254-5861");
INSERT INTO orders (OrderCost, OrderPrice, OrderCustomerID, OrderTime, OrderType, OrderDate)
VALUES (19.8, 64.5, (SELECT CustomerID FROM customer WHERE CustomerName = "Ellis Beck"), "09:30:00", "pickup", "2023-03-03");

/** INTO THE PICKUP TABLE **/
INSERT INTO pickup (PickUpID)
VALUES((SELECT MAX(OrderID) FROM orders));

/** put first pizza in the table **/
CALL create_pizza ((SELECT MAX(OrderID) FROM orders), "large", "Original", 10.75, 3.30);
CALL create_topping((SELECT MAX(PizzaID) FROM pizza), "Regular Cheese",  0);
CALL create_topping((SELECT MAX(PizzaID) FROM pizza), "Pepperoni",  0);

/** second **/
CALL create_pizza ((SELECT MAX(OrderID) FROM orders), "large", "Original", 10.75, 3.30);
CALL create_topping((SELECT MAX(PizzaID) FROM pizza), "Regular Cheese",  0);
CALL create_topping((SELECT MAX(PizzaID) FROM pizza), "Pepperoni",  0);

/** third **/
CALL create_pizza ((SELECT MAX(OrderID) FROM orders), "large", "Original", 10.75, 3.30);
CALL create_topping((SELECT MAX(PizzaID) FROM pizza), "Regular Cheese",  0);
CALL create_topping((SELECT MAX(PizzaID) FROM pizza), "Pepperoni",  0);

/** 4 **/
CALL create_pizza ((SELECT MAX(OrderID) FROM orders), "large", "Original", 10.75, 3.30);
CALL create_topping((SELECT MAX(PizzaID) FROM pizza), "Regular Cheese",  0);
CALL create_topping((SELECT MAX(PizzaID) FROM pizza), "Pepperoni",  0);

/** 5 **/
CALL create_pizza ((SELECT MAX(OrderID) FROM orders), "large", "Original", 10.75, 3.30);
CALL create_topping((SELECT MAX(PizzaID) FROM pizza), "Regular Cheese",  0);
CALL create_topping((SELECT MAX(PizzaID) FROM pizza), "Pepperoni",  0);

/** 6 **/
CALL create_pizza ((SELECT MAX(OrderID) FROM orders), "large", "Original", 10.75, 3.30);
CALL create_topping((SELECT MAX(PizzaID) FROM pizza), "Regular Cheese",  0);
CALL create_topping((SELECT MAX(PizzaID) FROM pizza), "Pepperoni",  0);

/** On March 5th at 7:11 pm there was a delivery order made by Ellis Beck for 1 x-large pepperoni and 
Sausage pizza (P 14.50, C 5.59), one x-large pizza with Ham (extra) and Pineapple (extra) pizza (P: 17, C: 
5.59), and one x-large Jalapeno and Bacon pizza (P: 14.00, C: 5.68). All the pizzas have the Four Cheese
Blend on it and are original crust. The order has the “Gameday Special” discount applied to it, and the
ham and pineapple pizza has the “Specialty Pizza” discount applied to it. The pizzas were delivered to 115
Party Blvd, Anderson SC 29621. His phone number is the same as before. OMG..... **/
INSERT INTO orders (OrderCost, OrderPrice, OrderCustomerID, OrderTime, OrderType, OrderDate)
VALUES (16.86, 45.5, (SELECT CustomerID FROM customer WHERE CustomerName = "Ellis Beck"), "07:11:00", "delivery", "2023-03-03");

INSERT INTO delivery (DeliveryID, DeliveryAddress)
VALUES ((SELECT MAX(OrderID) FROM orders), "115 Party Blvd, Anderson SC 29621");

/** pepperoni and ssageuge **/
CALL create_pizza ((SELECT MAX(OrderID) FROM orders), "x-large", "Original", 14.50, 5.59);
CALL create_topping((SELECT MAX(PizzaID) FROM pizza), "Four Cheese Blend",  0);
CALL create_topping((SELECT MAX(PizzaID) FROM pizza), "Pepperoni",  0);
CALL create_topping((SELECT MAX(PizzaID) FROM pizza), "Sausage",  0);

/** ham nad pineaple**/
CALL create_pizza ((SELECT MAX(OrderID) FROM orders), "x-large", "Original", 17, 5.59);
CALL create_topping((SELECT MAX(PizzaID) FROM pizza), "Four Cheese Blend",  0);
CALL create_topping((SELECT MAX(PizzaID) FROM pizza), "Ham",  0);
CALL create_topping((SELECT MAX(PizzaID) FROM pizza), "Pineapple",  0);

INSERT INTO pizzadisc(PizzaDiscName, PizzaDiscID)
VALUES((SELECT DiscountName FROM discount WHERE DiscountName = "Specialty Pizza"), (SELECT MAX(PizzaID) FROM pizza));

/** bacon and jalapeno **/
CALL create_pizza ((SELECT MAX(OrderID) FROM orders), "x-large", "Original", 14, 5.68);
CALL create_topping((SELECT MAX(PizzaID) FROM pizza), "Four Cheese Blend",  0);
CALL create_topping((SELECT MAX(PizzaID) FROM pizza), "Bacon",  0);
CALL create_topping((SELECT MAX(PizzaID) FROM pizza), "Jalapenos",  0);

INSERT INTO orderdisc(OrderDiscName, OrderDiscID)
VALUES((SELECT DiscountName FROM discount WHERE DiscountName = "Gameday Special"), (SELECT MAX(OrderID) FROM orders));

/**
On March 2nd at 5:30 pm Kurt McKinney placed an order for pickup for an x-large pizza with Green Pepper,
Onion, Roma Tomatoes, Mushrooms, and Black Olives on it. He wants the Goat Cheese on it, and a Gluten 
Free Crust (P: 16.85, C:7.85). The “Specialty Pizza” discount is applied to the pizza. Kurt’s phone number is 
864-474-9953
**/
CALL create_customer("Kurt McKinney", "864-474-9953");
INSERT INTO orders (OrderCost, OrderPrice, OrderCustomerID, OrderTime, OrderType, OrderDate)
VALUES (7.85, 16.85, (SELECT CustomerID FROM customer WHERE CustomerName = "Kurt McKinney"), "05:30:00", "pickup", "2023-03-02");

INSERT INTO pickup (PickUpID)
VALUES((SELECT MAX(OrderID) FROM orders));

CALL create_pizza ((SELECT MAX(OrderID) FROM orders), "x-large", "Gluten-Free", 16.85, 7.85);
CALL create_topping((SELECT MAX(PizzaID) FROM pizza), "Goat Cheese",  0);
CALL create_topping((SELECT MAX(PizzaID) FROM pizza), "Green Pepper",  0);
CALL create_topping((SELECT MAX(PizzaID) FROM pizza), "Onion",  0);
CALL create_topping((SELECT MAX(PizzaID) FROM pizza), "Roma Tomato",  0);
CALL create_topping((SELECT MAX(PizzaID) FROM pizza), "Mushrooms",  0);
CALL create_topping((SELECT MAX(PizzaID) FROM pizza), "Black Olives",  0);

INSERT INTO pizzadisc(PizzaDiscName, PizzaDiscID)
VALUES((SELECT DiscountName FROM discount WHERE DiscountName = "Specialty Pizza"), (SELECT MAX(PizzaID) FROM pizza));

/** 
On March 2nd at 6:17 pm Calvin Sanders places on order for delivery of one large pizza with Chicken, 
Green Peppers, Onions, and Mushrooms. He wants the Four Cheese Blend (extra) and thin crust (P: 
13.25, C: 3.20). The pizza was delivered to 6745 Wessex St Anderson SC 29621. Calvin’s phone number is 
864-232-8944
**/
CALL create_customer("Calvin Sanders", "864-232-8944");
INSERT INTO orders (OrderCost, OrderPrice, OrderCustomerID, OrderTime, OrderType, OrderDate)
VALUES (3.20, 13.25, (SELECT CustomerID FROM customer WHERE CustomerName = "Calvin Sanders"), "06:17:00", "delivery", "2023-03-02");

INSERT INTO delivery (DeliveryID, DeliveryAddress)
VALUES ((SELECT MAX(OrderID) FROM orders), "6745 Wessex St Anderson SC 29621");

CALL create_pizza ((SELECT MAX(OrderID) FROM orders), "large", "Thin", 13.25, 3.20);
CALL create_topping((SELECT MAX(PizzaID) FROM pizza), "Four Cheese Blend",  1);
CALL create_topping((SELECT MAX(PizzaID) FROM pizza), "Green Pepper",  0);
CALL create_topping((SELECT MAX(PizzaID) FROM pizza), "Onion",  0);
CALL create_topping((SELECT MAX(PizzaID) FROM pizza), "Chicken",  0);
CALL create_topping((SELECT MAX(PizzaID) FROM pizza), "Mushrooms",  0);

/**
On March 6th at 8:32 pm Lance Benton ordered two large thin crust pizzas. One had the Four Cheese
Blend on it (extra) (P: 12, C: 3.75), the other was Regular Cheese and Pepperoni (extra) (P:12, C: 2.55). He 
used the “Employee” discount on his order. He had them delivered to 8879 Suburban Home, Anderson, 
SC 29621. His phone number is 864-878-5679
**/
CALL create_customer("Lance Benton", "864-878-5679");
INSERT INTO orders (OrderCost, OrderPrice, OrderCustomerID, OrderTime, OrderType, OrderDate)
VALUES (6.3, 24, (SELECT CustomerID FROM customer WHERE CustomerName = "Lance Benton"), "08:32:00", "delivery", "2023-03-06");

INSERT INTO delivery (DeliveryID, DeliveryAddress)
VALUES ((SELECT MAX(OrderID) FROM orders), "8879 Suburban Home, Anderson, SC 29621");

/** first **/
CALL create_pizza ((SELECT MAX(OrderID) FROM orders), "large", "Thin", 12, 3.75);
CALL create_topping((SELECT MAX(PizzaID) FROM pizza), "Four Cheese Blend",  1);

/** sec **/
CALL create_pizza ((SELECT MAX(OrderID) FROM orders), "large", "Thin", 12, 2.55);
CALL create_topping((SELECT MAX(PizzaID) FROM pizza), "Regular Cheese",  0);
CALL create_topping((SELECT MAX(PizzaID) FROM pizza), "Pepperoni",  1);

