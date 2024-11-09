# 🛢️ Predicting Mud Loss with Regression & CART 🌍

Hey there! Welcome to my project where we dive into the world of drilling operations and tackle the problem of predicting mud loss. It's a cool mix of data wrangling, modelling, and evaluation—all done in R! 🔧📊

## Project Overview 🖼️

In the oil & gas industry, mud is this thick fluid mix that’s used to carry rock cuttings to the surface, cool the drill bit, and even lubricate. But here’s the catch: sometimes mud escapes into the surrounding rock (called Lost Circulation or Mud Loss), causing some seriously costly issues. This project uses Linear Regression and Classification and Regression Tree (CART) to predict mud loss and figure out what’s really driving it.

## The Dataset 📊

- **20 Variables**: Stuff like depth, pressure, location, and more.
- **2000+ Observations**: Both continuous and categorical data

## Project Breakdown 🌟

Here’s how I tackled the problem step-by-step:

### Data Wrangling 🧹

- Cleaned up missing values and converted variables to categorical where relevant.

### Exploratory Data Analysis (EDA) 🔍

- Visualised patterns and correlations to better understand what impacts mud loss.
- Found highly correlated variables, requiring some care with multicollinearity.

### Modelling 🤖

#### Linear Regression:
- Selected variables iteratively, but…
  - **Overfitting**: The test set error was slightly higher than the train set error, probably because the model struggled to fit complex patterns with a simple linear function.
  - **Categorical Variables**: Linear Regression encodes categorical variables as dummy variables, which can limit how well it captures relationships.

#### CART (Classification and Regression Tree) 🌳
- Built a flexible decision tree model that naturally handles categorical variables and non-linear relationships.
- **No Multicollinearity Concerns**: CART doesn’t assume specific relationships between variables, making it more robust to correlated variables.

## Results 🏆

After comparing both models, CART performed better in capturing complex, non-linear patterns, leading to lower error (test RMSE).

### Why CART Wins 🎉

CART was more suitable for this dataset with 20 variables and complex relationships. As a non-parametric model, it:

- **Handles Multicollinearity**: CART’s binary splits ignore the multicollinearity issues that can affect linear regression.
- **Fits Complex Data**: By modelling non-linear patterns and splits, CART gave more accurate predictions with less effort on preprocessing.

### When to Use Linear Regression 🤔

Linear Regression is still valuable in simpler scenarios where relationships are linear and the dataset is smaller or more interpretable. However, it required more vigilance here for handling multicollinearity and categorical variables.

## Highlights and Hiccups 💡

### Limitations 🚧
- Only a single 70-30 train-test split was used; cross-validation would add robustness.
- Linear Regression struggled with non-linear patterns, limiting its accuracy on this dataset.

### Key Takeaways 📝

- **CART > Linear Regression** when it comes to complex, non-linear data with lots of categorical variables.
- **Data wrangling** is crucial—clean data is happy data!
- **Overfitting** can sneak up on you, so always keep an eye on the test/train error gap.
- Don’t be afraid to try **non-parametric models** (like CART) when linear regression just isn’t cutting it.

## Final Thoughts 💭

This was such a fun project to work on! 🎉 I got to play around with data, build models, and really see the power of decision trees (CART). It also taught me that Linear Regression isn’t always the magic bullet, especially when things get complicated.

---
Thanks for checking it out! Hope you had as much fun reading this as I did working on it! 🚀
