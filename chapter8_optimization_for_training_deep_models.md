# Chapter 8. Optimization for Training Deep Models

[TOC]

## 8.1 How Learning Differs from Pure Optimization

- Optimization algorithms used for training of deep models differ from traditional optimization algorithms

  - In ML, we care about some performance measure $P$, that is defined with respect to the test set and may also be intractable. (optimize $P​$ only indirectly)
    - Reduce a different cost function $J(\boldsymbol{\theta})$ in the hope that doing so will reduce $P$.
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

### 8.1.2 Surrogate Loss Functions and Early Stopping 

- Sometimes, the loss function we actually care about is not one that can be optimized efficiently.
  - In such situations, one typically optimizes a **surrogate loss function** instead, which acts as a proxy but has advantages.
    (e.g. the negative log-likelihood is used as a surrogate for the 0-1 loss.)
    - In some cases, a surrogate loss function actually results in being able to learn more. 
- A very important difference between optimization in general and optimization as we use it for training algorithms is that training algorithms do not usually halt at a local minimum.
  - Instead, a machine learning algorithm usually minimizes a surrogate loss function but halts when a convergence criterion based on early stopping is satisfied.
    - Training often halts while the surrogate loss function still has large derivatives, which is very different from the pure optimization setting.

### 8.1.3 Batch and Minibatch Algorithms

- Optimization algorithms for machine learning typically compute each update to the parameters based on an expected value of the cost function estimated using only a subset of the terms of the full cost function.

- Maximum likelihood estimation problems decompose into a sum over each examples:
  $$
  \boldsymbol{\theta}_\text{ML} = \arg\max_\boldsymbol{\theta} \sum^m_{i=1} \log p_\text{model} (\boldsymbol{x}^{(i)}, y^{(i)}; \boldsymbol{\theta}).
  $$

  - Maximizing this sum is equivalent to maximizing the expectation over the empirical distribution defined by the training set:
    $$
    J(\boldsymbol{\theta}) = \mathbb{E}_{\boldsymbol{x}, y \sim \hat{p}_\text{data}} \log p_\text{model}(\boldsymbol{x}, y; \boldsymbol{\theta}).
    $$

    - Gradient of $J(\boldsymbol{\theta})$:
      $$
      \nabla_\boldsymbol{\theta} J(\boldsymbol{\theta}) = \mathbb{E}_{\boldsymbol{x}, y \sim \hat{p}_\text{data}} \nabla_\boldsymbol{\theta} \log p_\text{model} (\boldsymbol{x}, y; \boldsymbol{\theta}).
      $$

      - Computing this expectation exactly is very expensive.
      - In practice, we can compute these expectations by randomly sampling a small number of examples.

- Motivation of minibatch algorithms

  - The standard error of the mean estimated from $n$ samples is given by $\sigma / \sqrt{n}$.
    - With 100 examples and 10000 samples, the latter requires 100 times more computation than the former, but reduces the standard error of the mean only by a factor of 10.
  - Redundancy in the training set
    - In practice, we may find large numbers of examples that all make very similar contributions to the gradient.

- Terminology

  - Optimization algorithms that use the entire training set are called **batch** or **deterministic** gradient methods.
  - Optimization algorithms that use only a single example at a time are sometimes called **stochastic** or sometimes **online** methods.
  - Optimization algorithms that use more than one but less than all of the training examples are called **minibatch** or **minibatch stochastic** methods.

- Minibatch sizes are generally driven by the following factors:

  - Larger batches provide a more accurate estimate of the gradient, but with less than linear returns.
  - Multicore architectures are usually underutilized by extremely small batches.
  - If all examples in the batch are to be processed in parallel, then the amount of memory scales with the batch size.
  - Small batches can offer a regularizing effect.
    - Perhaps, due to the noise they add to the learning process.
    - Generalization error is often best for a batch size of 1.
    - Training with such a small batch size might require a small learning rate.
      - To maintain stability due to the high size variance in the estimate of the gradient.
    - The total runtime can be very high due to the need to make more steps.

- Use of minibatch information

  - Algorithms using only the gradient $\boldsymbol{g}$ are usually relatively robust and can handle smaller batch sizes like 100.
  - Second-order methods suing the Hessian matrix $\boldsymbol{H}$ require much larger batch sizes like 10,000.
    - Larger batch sizes are required to minimize fluctuations in the estimates of $\boldsymbol{H}^{-1} \boldsymbol{g}​$.

- Random selection of minibatches

  - It is crucial that the minibatches be selected randomly.
    - Computing an unbiased estimate of the expected gradient from a set of samples requires that those samples be independent.
    - Many datasets are arranged with successive samples highly correlated.
    - For very large datasets, in practice, it is usually sufficient to shuffle the order of the dataset once and then store it in shuffled fashion.

- Generalization error

  - Minibatch stochastic gradient descent is that it follows the gradient of the true *generalization error* so long as no examples are repeated.

  - In most implementations of SGD

    - Shuffle the dataset once and then pass through it multiple times.
      - On the first pass, each minibatch is used to compute an unbiased estimate of the true generalization error.
      - On the second pass, the estimate becomes biased.

  - SGD minimizes generalization error

    - Suppose that both $\boldsymbol{x}$ and $y$ are discrete.

    - The generalization error can be written as a sum
      $$
      J^*(\boldsymbol{\theta}) = \sum_\boldsymbol{x} \sum_y p_\text{data} (\boldsymbol{x}, y) L(f(\boldsymbol{x}; \boldsymbol{\theta}), y),
      $$
      with the exact gradient
      $$
      \boldsymbol{g} = \nabla_\boldsymbol{\theta} J^*(\boldsymbol{\theta}) = \sum_\boldsymbol{x} \sum_y p_\text{data} (\boldsymbol{x}, y) \nabla_\boldsymbol{\theta} L(f(\boldsymbol{x}; \boldsymbol{\theta}), y).
      $$

    - We've already seen the same fact demonstrated for the log-likelihood., so it holds for other functions $L$ besides the likelihood.

- With a minibatch $\{ \boldsymbol{x}^{(1)}, \cdots, \boldsymbol{x}^{(m)} \}$ with corresponding targets $y^{(i)}$, 
  $$
  \hat{\boldsymbol{g}} = \frac{1}{m} \nabla_{\boldsymbol{\theta}} \sum_i L(f(\boldsymbol{x}^{(i)}; \boldsymbol{\theta}), y^{(i)}).
  $$

  - Updating $\boldsymbol{\theta}$ in the direction of $\hat{\boldsymbol{g}}$ performs SGD on the generalization error.

## 8.2 Challenges in Neural Network Optimization

### 8.2.1 Ill-Conditioning

- Ill-conditioning of the Hessian matrix $\boldsymbol{H}$ is the most prominent challenge.

  - Ill-conditioning can manifest by causing SGD to get "stuck" in the sense that even very small steps increase the cost function.

- A second-order Taylor series expansion of the cost function predicts that a gradient descent step of $-\varepsilon \boldsymbol{g}$ will add
  $$
  \frac{1}{2} \varepsilon^2 \boldsymbol{g}^\top \boldsymbol{Hg} - \varepsilon \boldsymbol{g}^\top \boldsymbol{g}
  $$
  to the cost.

  - Ill-conditioning of the gradient becomes a problem when
    $$
    \frac{1}{2} \varepsilon^2 \boldsymbol{g}^\top \boldsymbol{Hg} > \varepsilon \boldsymbol{g}^\top \boldsymbol{g}.
    $$

  - To determine whether ill-conditioning is detrimental, monitor $\boldsymbol{g}^\top \boldsymbol{g}$ and $\boldsymbol{g}^\top \boldsymbol{Hg}$.

    - The gradient norm does not shrink significantly, but $\boldsymbol{g}^\top \boldsymbol{Hg}$ term grows by more than an order of magnitude.
    - Learning becomes very slow despite the presence of a strong gradient because the learning rate must be shrunk to compensate for even stronger curvature.

### 8.2.2 Local Minima

- One of the most prominent features of a convex optimization problem is that it can be reduced to the problem of finding a local minimum.
- Any deep model is essentially guaranteed to have an extremely large number of local minima.
  - But, this is not necessarily a major problem.
- **Model identifiability**
  - A sufficiently large training set can rule out all but one setting of the model's parameters.
  - Models with latent variables are often not identifiable.
    - Equivalent models can be obtained by exchanging latent variables with each other.
  - **Weight space symmetry**
- These model identifiability issues mean that there can be an extremely large or even uncountably infinite amount of local minima in a neural network.
  - All of these local minima arising from non-identifiability are equivalent to each other in cost function value.
    - As a result, these local minima are not a problematic form of non-convexity.
    - These can be problematic if they have high cost in comparison the the global minimum.

### 8.2.3 Plateaus, Saddle Points and Other Flat Regions

- For many high-dimensional non-convex functions, local minima (and maxima) are rare compared to another kind of point with zero gradient: a saddle point.
  - At a saddle point, the Hessian matrix has both positive and negative eigenvalues.
    - Positive eigenvalues : Cost greater than the saddle point.
    - Negative eigenvalues : Lower values

- Patterns in terms of dimensionality
  - In low-dimensional spaces, local minima are common.
  - In higher dimensional spaces, local minima are rare and saddle points are more common.

- Shallow autoencoders with no nonlinearlities have global minima and saddle points but no local minima with higher cost than the global minimum.

- On the saddle point :
  - For first-order optimization algorithms that use only gradient information, the gradient can often become very small near a saddle points.
  - Gradient descent empirically seems to be able to escape saddle points in many cases.
  - For Newton's method, it is clear that saddle points constitute a problem.
    - Newton's method is designed to solve for a point where the gradient is zero.
    - It explains why second-order methods have not succeeded in replacing gradient descent for neural network training.
      - **Saddle-free Newton method**

### 8.2.4 Cliffs and Exploding Gradients

- Neural networks with many layers often have extremely steep regions resembling cliffs.
  - The gradient update step can move the parameters extremely far, usually jumping off of the cliff structure.
  - By using the **gradient clipping** heuristic, the most serious consequences can be avoided.
    - The basic idea is to recall that the gradient does not specify the optimal step size, but only the optimal direction within an infinitesimal region.

### 8.2.5 Long-Term Dependencies

- Another difficulty that neural network optimization algorithms must overcome arises when the computational graph becomes extremely deep.
  - In RNN, very deep computational graphs are constructed by repeatedly applying the same operation at each time step of a long temporal sequence.
- **Vanishing and exploding gradient problem**
  - Suppose that a computational graph contains a path that consists of repeatedly multiplying by a matrix $\boldsymbol{W}$.
  - Suppose that $\boldsymbol{W}$ has an eigendecomposition $\boldsymbol{W} = \boldsymbol{V}\text{diag}(\boldsymbol{\lambda}) \boldsymbol{V}^{-1}$.
  - After $t$ steps, we obtain
  $$
    \boldsymbol{W}^t = (\boldsymbol{V} \text{diag}(\boldsymbol{\lambda})\boldsymbol{V}^{-1})^t = \boldsymbol{V} \text{diag}(\boldsymbol{\lambda})^t \boldsymbol{V}^{-1}.
  $$
  - Any eigenvalues $\lambda_i$ that are not near an absolute value of 1 will either explode or vanish.

### 8.2.6 Inexact Gradients

- Most optimization algorithms are designed with the assumption that we have access to the exact gradient of Hessian matrix.
  - In practice, we usually only have a noisy or even biased estimate of these quantities.
- The objective function is actually intractable.
  - When the objective function is intractable, its gradient is typically intractable as well.
    - In such cases, we can only approximate the gradient.

### 8.2.7 Poor Correspondence between Local and Global Structure

- It is possible to overcome all of these problems at a single point and still perform poorly if the direction that results in the most improvement locally does not point toward distant regions of much lower cost.
- Much of research into the difficulties of optimization has focused on whether training arrives at a global minimum, a local minimum, or a saddle point.
  - But, in practice, neural networks do not arrive at a critical point of any kind.

### 8.2.8 Theoretical Limits of Optimization

## 8.3 Basic Algorithm

### 8.3.1 Stochastic Gradient Descent

- Stochastic gradient descent (SGD) and its variants are probably the most used optimization algorithms for machine learning.
- It is possible to obtain an unbiased estimate of the gradient by taking the average gradient on a minibatch of $m$ examples drawn i.i.d from the data generating distribution.

>- **Algorithm 8.1** Stochastic gradient descent (SGD) update at training iteration $k$  
>&emsp;**Require:** Learning rate $\epsilon_k$.  
>&emsp;**Require:** Initial parameter $\boldsymbol{\theta}$  
>&emsp;&emsp;**while** stopping criterion not met **do**  
>&emsp;&emsp;&emsp;Sample a minibatch of $m$ examples from the training set $\{\boldsymbol{x}^{(1)}, \cdots, \boldsymbol{x}^{(m)}\}$ with corresponding targets $\boldsymbol{y}^{(i)}$.  
>&emsp;&emsp;&emsp;Compute gradient estimate: $\hat{\boldsymbol{g}} \leftarrow +\frac{1}{m} \nabla_\boldsymbol{\theta} \sum_i L(f(\boldsymbol{x}^{(i)}; \boldsymbol{\theta}), \boldsymbol{y}^{(i)})$  
>&emsp;&emsp;&emsp;Apply update: $\boldsymbol{\theta} \leftarrow \boldsymbol{\theta} - \epsilon \hat{\boldsymbol{g}}$  
>&emsp;&emsp;**end while**

- In practice, it is necessary to gradually decrease the learning rate over time.
  - It is common to decay the learning rate linearly until iteration $\tau$:
    $$
    \epsilon_k = (1-\alpha) \epsilon_0 + \alpha \epsilon_\tau
    $$
    with $\alpha = \frac{k}{\tau}$.
    - After iteration $\tau$, it is common to leave $\epsilon$ constant.
    - When using the linear schedule, the parameters to choose are $\epsilon_0$, \epsilon_\tau$, and $\tau$.
      - Usually $\tau$ may be set to the number of iterations required to make a few hundred passes through the training set.
      - Usually $\epsilon_\tau$ should be set to roughly 1% the value of $\epsilon_0$.
- A sufficient condition to guarantee convergence of SGD is that $\sum \epsilon_k = \infty$ and $\sum \epsilon_k^2 < \infty$.
- The most important property of SGD :
  - Computation time per update does not grow with the number of training examples.
    - This allows convergence even when the number of training examples become very large.


### 8.3.2 Momentum

- While SGD remains a very popular optimization strategy, learning with it can be slow.
  - Momentum is designed to accelerate learning, especially in the face of high curvature, small but consistent gradients, or noisy gradients.
  - The momentum algorithm accumulates an exponentially decaying moving average of past gradients and continues to move in their direction.
- Formal definition
  - Let $v$ be the velocity.
    - The velocity is set to an exponentially decaying average of the negative gradient.
  - The name **momentum** derives from a physical analogy, in which the negative gradient is a force moving a particle through parameter space.
    - Momentum in physics is mass times velocity.
    - We assume unit mass, so the velocity vector $\boldsymbol{v}$ may also be regarded as the momentum of the particle.
  - A hyperparameter $\alpha \in [0, 1)$ determines how quickly the contributions of previous gradients exponentially decay.
  - The update rules is given by :
    $$
      \begin{aligned}
      \boldsymbol{v} &\leftarrow \alpha \boldsymbol{v} - \epsilon\nabla_\boldsymbol{\theta} \left(\frac{1}{m} \sum^m_{i=1} L(\boldsymbol{f}(\boldsymbol{x}^{(i)}; \boldsymbol{\theta}), \boldsymbol{y}^{(i)}) \right), \\
      \theta &\leftarrow \boldsymbol{\theta} + \boldsymbol{v}
      \end{aligned}
    $$
    - The velocity $\boldsymbol{v}$ accumulates the gradient element $\nabla_\boldsymbol{\theta} \left(\frac{1}{m} \sum^m_{i=1} L(\boldsymbol{f}(\boldsymbol{x}^{(i)}; \boldsymbol{\theta}), \boldsymbol{y}^{(i)}) \right)$.
    - The larger $\alpha$ is relative to $\epsilon$, the more previous gradients affect the current direction.
- If the momentum algorithm always observes gradient $\boldsymbol{g}$, then it will accelerate in the direction of $-\boldsymbol{g}$, until reaching a terminal velocity where the size of each step is $\frac{\epsilon \|\boldsymbol{g}\|}{1-\alpha}$.
  - For example, $\alpha = .9$ corresponds to multiplying the maximum speed by 10 relative to the gradient descent algorithm.
    - Common values of $\alpha$ used in practice include .5, .9, and .99.

>- **Algorithm 8.2** Stochastic gradient descent (SGD) with momentum  
>&emsp;**Require:** Learning rate $\epsilon$, momentum parameter $\alpha$.  
>&emsp;**Require:** Initial parameter $\boldsymbol{\theta}$, initial velocity $\boldsymbol{v}$.  
>&emsp;&emsp;**while** stopping criterion not met **do**  
>&emsp;&emsp;&emsp;Sample a minibatch of $m$ examples from the training set $\{\boldsymbol{x}^{(1)}, \cdots, \boldsymbol{x}^{(m)}\}$ with corresponding targets $\boldsymbol{y}^{(i)}$.  
>&emsp;&emsp;&emsp;Compute gradient estimate: $\hat{\boldsymbol{g}} \leftarrow \frac{1}{m} \nabla_\boldsymbol{\theta} \sum_i L(f(\boldsymbol{x}^{(i)}; \boldsymbol{\theta}), \boldsymbol{y}^{(i)})$  
>&emsp;&emsp;&emsp;Compute velocity update: $\boldsymbol{v} \leftarrow \alpha\boldsymbol{v} - \epsilon \boldsymbol{g}$  
>&emsp;&emsp;&emsp;Apply update: $\boldsymbol{\theta} \leftarrow \boldsymbol{\theta} + \boldsymbol{v}$  
>&emsp;&emsp;**end while**

### 8.3.3 Nesterov Momentum

- The update rules is given by :
  $$
    \begin{aligned}
    \boldsymbol{v} &\leftarrow \alpha \boldsymbol{v} - \epsilon\nabla_\boldsymbol{\theta} \left(\frac{1}{m} \sum^m_{i=1} L(\boldsymbol{f}(\boldsymbol{x}^{(i)}; \boldsymbol{\theta}), \boldsymbol{y}^{(i)}) \right), \\
    \theta &\leftarrow \boldsymbol{\theta} + \boldsymbol{v}
    \end{aligned}
  $$
  where the parameters $\alpha$ and $\epsilon$ play a similar role as in the standard momentum method.
    - The difference between Nesterov momentum and standard momentum is where the gradient is evaluated.
    - With Nesterov momentum the gradient is evaluated after the current velocity is applied.
    - In the stochastic gradient case, Nesterov momentum does not improve the rate of convergence.

>- **Algorithm 8.3** Stochastic gradient descent (SGD) with Nesterov momentum  
>&emsp;**Require:** Learning rate $\epsilon$, momentum parameter $\alpha$.  
>&emsp;**Require:** Initial parameter $\boldsymbol{\theta}$, initial velocity $\boldsymbol{v}$.  
>&emsp;&emsp;**while** stopping criterion not met **do**  
>&emsp;&emsp;&emsp;Sample a minibatch of $m$ examples from the training set $\{\boldsymbol{x}^{(1)}, \cdots, \boldsymbol{x}^{(m)}\}$ with corresponding targets $\boldsymbol{y}^{(i)}$.  
>&emsp;&emsp;&emsp;Apply interim update: $\tilde{\boldsymbol{\theta}} \leftarrow \boldsymbol{\theta} + \alpha \boldsymbol{v}$  
>&emsp;&emsp;&emsp;Compute gradient estimate (at interim point):  ${\boldsymbol{g}} \leftarrow \frac{1}{m} \nabla_\boldsymbol{\tilde{\theta}} \sum_i L(f(\boldsymbol{x}^{(i)}; \boldsymbol{\tilde{\theta}}), \boldsymbol{y}^{(i)})$  
>&emsp;&emsp;&emsp;Compute velocity update: $\boldsymbol{v} \leftarrow \alpha\boldsymbol{v} - \epsilon \boldsymbol{g}$  
>&emsp;&emsp;&emsp;Apply update: $\boldsymbol{\theta} \leftarrow \boldsymbol{\theta} + \boldsymbol{v}$  
>&emsp;&emsp;**end while**

## 8.4 Parameter Initialization Strategies

- Types of initialization
  - Non-iterative optimization requires no initialization
    - Simply solve for a solution point
  - Iterative but converge regardless of initialization
    - Acceptable solutions in acceptable time
  - Iterative but affected by choice of initialization
    - Deep learning algorithms are strongly affected by the choice of initialization.
    - The initial point can determine whether the algorithm converges at all or not.
      - When learning does converge, the initial point can determine how quickly learning converges and whether it converges to a point with high or low cost.
    - The initial point can affect the generalization as well.

- Modern initialization strategies
  - Simple and heuristic
  - Based on achieving some nice properties when the network initialized.
  - Some initial points may be beneficial from the viewpoint of optimization but detrimental from the viewpoint of generalization.

- Break symmetry
  - The only property known with complete certainty is that the initial parameters need to "break symmetry" between different units.
  - If two hidden units with the same activation function are connected to the same inputs, then these units must have different initial parameters.
  - It is usually best to initialize each unit to compute a different function from all of the other units.
  - This motivates random initialization of the parameters.
    - Random initialization from a high-entropy distribution over a high-dimensional space is computationally cheaper and unlikely to assign any units to compute the same function as each other.

- Choice of biases
  - Typically, the biases for each unit to heuristically chosen constants, and initialize only the weights randomly.
    - Extra parameters are usually set to heuristically chosen constants much like the biases are.

- Weight initialization
  - Weights are initialized randomly from a Gaussian or uniform distribution.
  - Larger initial weights will yield a stronger symmetry breaking effect, helping to avoid redundant units.

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

### 8.7.6 Continuation Methods and Curriculum Learning
