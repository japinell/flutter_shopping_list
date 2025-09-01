# Flutter Shopping List

## Description

This is a cross-platform shopping list application built with **Flutter** and **Dart**. It demonstrates state management, asynchronous data fetching, and CRUD operations with a remote database. The app allows users to add, view, and remove grocery items, organized by category.

## User Stories

```
As a user
I want to add grocery items to my shopping list
So that I can keep track of what I need to buy
```

```
As a user
I want to categorize items
So that my shopping list is organized and easy to use
```

```
As a user
I want to remove items from my list
So that I can manage my shopping efficiently
```

## Design

```
--\lib\models\category.dart:

Defines a category with a name and color for display purposes.
```

![Flutter shopping list - Category model.](./assets/images/category-model.png)

```
--\lib\models\grocery_item.dart:

Defines a grocery item with id, name, quantity, and category.
```

![Flutter shopping list - Grocery Item model.](./assets/images/grocery-item-model.png)

## Main Screens

```
--\lib\widgets\grocery_list.dart:

Main screen. Displays the list of grocery items, allows adding and removing items.
```

![Flutter shopping list - Grocery List screen.](./assets/images/grocery-list-screen.png)

```
--\lib\widgets\new_item.dart:

Screen for adding a new grocery item to the list.
```

![Flutter shopping list - New Item screen.](./assets/images/new-item-screen.png)

## License

This project is licensed under The MIT License. Refer to https://opensource.org/licenses/MIT for more information.

## Contributing Guidelines

Want to contribute? Clone or fork the project on GitHub. See the license information above.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
