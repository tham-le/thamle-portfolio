---
title: "Python-for-Data-Science"
date: 2024-06-08T19:08:02Z
lastmod: 2025-02-24T12:18:45Z
description: "No description available"
image: ""
showFeatureImage: true
links:
  - title: "GitHub Repository"
    description: "View source code and documentation"
    website: "https://github.com/tham-le/Python-for-Data-Science"
    image: "https://github.githubassets.com/favicons/favicon.svg"
categories:
  - "Projects"
  - "Data Science"
tags:
    - "Python"
    - "GitHub"
weight: 1
stats:
    stars: 0
    forks: 0
    language: Python
---

# Piscine python for data science

This repository contains a series of Python projects organized into modules, designed to progressively build data science skills.  It follows a "piscine" style of learning, where each module focuses on a particular aspect of Python and its application to data science.

## Modules Overview

### Python-0-Starting: Introduction to Python Basics

This module covers the fundamentals of Python programming:

*   **ex00/Hello.py:** Introduces basic Python data structures (lists, tuples, sets, dictionaries) and their mutability.
*   **ex01/format_ft_time.py:** Demonstrates how to work with time, including formatting and scientific notation.
*   **ex02/find_ft_type.py:** Shows how to determine the type of a Python object.
*   **ex03/NULL_not_found.py:**  Explores handling of NULL values and other special data types (NaN, empty strings, False, 0).
*   **ex04/whatis.py:**  Uses command-line arguments (`sys.argv`) and exception handling to determine if a number is even or odd.
*   **ex05/building.py:**  Performs string manipulation to count characters (uppercase, lowercase, punctuation, spaces, digits).  Handles user input and potential errors (EOFError).
*   **ex06/filterstring.py:** Filters words in a string based on length, using a custom `ft_filter` function and lambda expressions.
*   **ex06/ft_filter.py:**  Implements a custom filter function, mimicking the built-in `filter` function.
*   **ex07/sos.py:** Encodes a string into Morse code using a dictionary.
*   **ex08/Loading.py:** Creates a custom progress bar (`ft_tqdm`) using `sys.stdout.write` and `os.get_terminal_size`.
*   **ex09/usage.py:** Demonstrates the usage of the `ft_package`.
*   **ex09/ft_package/:**  Contains a simple Python package with a single function (`count_in_list`) to count the occurrences of an item in a list. Includes `pyproject.toml` for building the package.

### Python-1-Array: Working with Arrays and Image Manipulation

This module focuses on using NumPy arrays and basic image processing with `matplotlib`:

*   **ex00/give_bmi.py:** Calculates BMI from lists of height and weight, with error handling.  Includes a function to apply a limit and return a boolean array.
*   **ex01/array2D.py:** Slices a 2D array (represented as a list of lists) and prints its shape, mimicking NumPy array slicing.
*   **ex02/load_image.py:** Loads an image using `matplotlib.image` and prints its shape.  Basic error handling.
*   **ex03/load_image.py:**  Loads an image with improved error handling (raising exceptions).
*   **ex03/zoom.py:** Loads an image, zooms into the center, converts it to grayscale, and displays the results using `matplotlib.pyplot`.
*   **ex04/load_image.py:** Same as ex03/load_image.py.
*   **ex04/rotate.py:** Loads an image, cuts out a square, converts it to grayscale, rotates it by 90 and -90 degrees (implemented manually), and displays the results.
*   **ex05/load_image.py:**  Same as ex03/load_image.py.
*   **ex05/pimp_image.py:**  Provides functions to manipulate images: invert colors, isolate red/green/blue channels, and convert to grayscale.

### Python-2-DataTable: Data Loading, Manipulation, and Visualization

This module uses the `pandas` library to work with tabular data:

*   **income_per_person_gdppercapita_ppp_inflation_adjusted.csv:**  CSV file containing GDP per capita data.
*   **life_expectancy_years.csv:** CSV file containing life expectancy data.
*   **population_total.csv:** CSV file containing population data.
*   **ex00/load_csv.py:** A function to load a CSV file into a pandas DataFrame, with error handling.
*   **ex01/aff_life.py:** Loads life expectancy data and plots the projection for France.
*   **ex01/load_csv.py:**  Same as ex00/load_csv.py.
*   **ex02/aff_pop.py:**  Loads population data and plots the population of France and Belgium, with custom formatting for the y-axis.
*   **ex02/load_csv.py:** Same as ex00/load_csv.py.
*   **ex03/load_csv.py:** A slightly modified version of ex00/load_csv.py, raising exceptions instead of printing errors.
*   **ex03/projection_life.py:**  Loads life expectancy and GDP data, and creates a scatter plot showing the relationship between the two for the year 1900.

### Python-3-OOP: Object-Oriented Programming

This module introduces object-oriented programming concepts in Python:

*   **ex00/S1E9.py:** Defines an abstract base class `Character` with an abstract method `die()`, and a concrete class `Stark` inheriting from it.
*   **ex00/tester.py:** Tests the `Character` and `Stark` classes.
*   **ex01/S1E7.py:** Defines `Baratheon` and `Lannister` classes, inheriting from `Character`, with specific attributes and a `create_lannister` class method.
*   **ex01/S1E9.py:** Same as ex00/S1E9.py.
*   **ex01/tester.py:** Tests the `Baratheon` and `Lannister` classes.
*   **ex02/DiamondTrap.py:** Defines a `King` class that inherits from both `Baratheon` and `Lannister`, demonstrating multiple inheritance. Includes getter and setter methods.
*   **ex02/S1E7.py:**  Slightly modified versions of the `Baratheon` and `Lannister` classes.
*   **ex02/S1E9.py:** Same as ex00/S1E9.py.
*   **ex02/tester.py:**  Tests the `King` class.
*   **ex03/ft_calculator.py:** Implements a `calculator` class that performs element-wise operations (+, -, \*, /) on a list (acting like a vector) with a scalar. Uses dunder methods (`__add__`, `__mul__`, `__sub__`, `__truediv__`).
*   **ex03/tester.py:** Tests the `calculator` class.
*   **ex04/ft_calculator.py:**  Implements a `calculator` class with static methods to perform dot product, vector addition, and vector subtraction.
*   **ex04/tester.py:** Tests the `calculator` class.

### Python-4-DOD: Data-Oriented Design

This module explores data-oriented design principles:

*   **ex00/statistics.py:**  Defines a function `ft_statistics` that calculates mean, median, quartile, standard deviation, and variance of a variable number of numerical arguments. Uses keyword arguments to specify which statistics to calculate.
*   **ex00/tester.py:** Tests the `ft_statistics` function.
*   **ex01/in_out.py:**  Demonstrates nested functions and closures.  The `outer` function returns an inner function that maintains a count and applies a given function to it repeatedly.
*   **ex01/tester.py:**  Tests the `outer` function with `square` and `pow`.
*   **ex02/callLimit.py:**  Creates a decorator `callLimit` that limits the number of times a function can be called.
*   **ex02/tester.py:** Tests the `callLimit` decorator.
*   **ex03/new_student.py:**  Defines a `Student` dataclass with fields for name, surname, active status, login, and a randomly generated ID. The login is automatically generated in `__post_init__`.
*   **ex03/tester.py:** Tests the `Student` dataclass.
