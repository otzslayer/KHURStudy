# Chapter 8. Optimization for Training Deep Models

[TOC]

## 8.1 How Learning Differs from Pure Optimization

- Optimization algorithms used for training of deep models differ from traditional optimization algorithms

  - In ML, we care about some performance measure $P$, that is defined with respect to the test set and may also be intractable. (optimize $P​$ only indirectly)
    - Reduce a different cost function $J(\boldsymbol{theta})$ in the hope that doing so will reduce $P$.
  - In pure optimization, minimizing $J$ is a goal in and of itself.

- Typically, the cost function can be written as an average over the training set, such as
  $$
  J(\boldsymbol{\theta}) = \mathbb{E}_{(\boldsymbol{x}, y) \sim \hat{p}_\text{data}} L(f(\boldsymbol{x}; \boldsymbol{\theta}), y),
  $$
  where $L$ is the per-example loss function, $f(\boldsymbol{x}, \boldsymbol{\theta})$ is the predicted output when the input is $\boldsymbol{x}$, $\hat{p}_\text{data}$ is the empirical distribution.

  - We would usually prefer to minimize the corresponding objective function where the expectation is taken across *the data generating distribution* $p_\text{data}$ rather than just over the finite training set:
    $$
    J^*(\boldsymbol{\theta}) = \mathbb{E}_{(\boldsymbol{x}, y_ \sim p_\text{data})} L(f(\boldsymbol{x}; \boldsymbol{\theta}), y).
    $$

### 8.1.1 Empirical Risk Minimization

- The goal of a machine learning algorithm is to reduce the expected generalization error, as known as **risk**.

  - If we knew the true distribution $p_\text{data}(\boldsymbol{x}, y)$, risk minimization would be an optimization task solvable by an optimization algorithm.
  - However, when we do not know $p_\text{data}(\boldsymbol{x}, y)$ but only have a training set of samples, we have a machine learning problem.

- **Empirical risk**

  - Replacing the true distribution $p(\boldsymbol{x}, y)$ with the empirical distribution $\hat{p}(\boldsymbol{x}, y)$ defined by the training set.
    $$
    \mathbb{E}_{\boldsymbol{x}, y \sim \hat{p}_\text{data}(\boldsymbol{x}, y)}[L(f(\boldsymbol{x}; \boldsymbol{\theta}), y)] = \frac{1}{m} \sum^m_{i=1} L(f(\boldsymbol{x}^{(i)}; \boldsymbol{\theta}), y^{(i)}).
    $$

  - The training process based on minimizing this average training error is known as **empirical risk minimization**.

    - In this setting, machine learning is still very similar to straightforward optimization.

  - Two problems of empirical risk minimization => So rarely used in deep learning.

    - Empirical risk minimization is prone to overfitting.
      - Models with high capacity can simply memorize the training set.
    - In many case, empirical risk minimization is not really feasible.
      - Many useful loss functions, such as 0-1 loss, have no useful derivatives in schemes based on gradient descent.
    - 

### 8.1.2 Surrogate Loss Functions and Early Stopping 

### 8.1.3 Batch and Minibatch Algorithms

## 8.2 Challenges in Neural Network Optimization

### 8.2.1 Ill-Conditioning

### 8.2.2 Local Minima

### 8.2.3 Plateaus, Saddle Points and Other Flat Regions

### 8.2.4 Cliffs and Exploding Gradients

### 8.2.5 Long-Term Dependencies

### 8.2.6 Inexact Gradients

### 8.2.7 Poor Correspondence between Local and Global Structure

### 8.2.8 Theoretical Limits of Optimization

## 8.3 Basic Algorithm

### 8.3.1 Stochastic Gradient Descent

### 8.3.2 Momentus

### 8.3.3 Nesterov Momentus

## 8.4 Parameter Initialization Strategies

## 8.5 Algorithms with Adaptive Learning Rates

### 8.5.1 AdaGrad

### 8.5.2 RMSProp

### 8.5.3 Adam

### 8.5.4 Choosing the Right Optimization Algorithm

## 8.6 Approximate Second-Order Methods

### 8.6.1 Newton's Method

### 8.6.2 Conjugate Gradients

### 8.6.3 BFGS

## 8.7 Optimization Strategies and Meta-Algorithms

### 8.7.1 Batch Normalization

### 8.7.2 Coordinate Descent

### 8.7.3 Polyak Averaging

### 8.7.4 Supervised Pretraining

### 8.7.5 Designing Models to Aid Optimization

### 8.7.6 Continuation Meethods and Curriculum Learning



