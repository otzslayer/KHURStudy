# Chapter 7. Regularization for Deep Learning

## 7.1 Parameter Norm Penalties

- The regularized objective function $\tilde{J}​$:
  $$
  \tilde{J}(\boldsymbol{\theta} ; \mathbf{X}, \mathbf{y}) = J(\boldsymbol{\theta}; \mathbf{X}, \mathbf{y}) + \alpha \Omega(\boldsymbol{\theta})
  $$
  where $\alpha \in [0, \infty)$ is a hyperparameter that weights the relative contribution of the norm penalty term $\Omega$.

- Note that for neural networks, we typically choose to use a parameter norm penalty $\Omega​$ that penalizes *only the weights* of the affine transformation at each layer and leaves the biases unregularized.

  - The reason that bias of each weight is excluded in penalty terms:
    - The biases typically require less data to fit than the weights
    - Each weight specifies how two variables interact while biases specify interact of one variables
    - Regularizing the bias parameters can cause underfitting.

### 7.1.1 $L^2$ Parameter Regularization

- $L^2$ parameter norm penalty commonly known as **weight decay**, **ridge regression** or **Tikhonov regularization**.

  - Such a model has the following total objective function:

  $$
  \tilde{J}(\boldsymbol{w}; \boldsymbol{X}, \boldsymbol{y}) = \frac{\alpha}{2} \boldsymbol{w}^\top \boldsymbol{w} + J(\boldsymbol{w}; \boldsymbol{X}, \boldsymbol{y}),
  $$

    	with the corresponding parameter gradient
  $$
  \nabla_\boldsymbol{w} \tilde{J}(\boldsymbol{w}; \boldsymbol{X}, \boldsymbol{y}) = \alpha \boldsymbol{w} + \nabla_\boldsymbol{w} J(\boldsymbol{w}; \boldsymbol{X}, \boldsymbol{y}).
  $$

  - To take a single gradient step to update the weights, we perform this update:

  $$
  \boldsymbol{w} \leftarrow \boldsymbol{w} - \varepsilon(\alpha \boldsymbol{w} + \nabla_\boldsymbol{w} J(\boldsymbol{w}; \boldsymbol{X}, \boldsymbol{y})).
  $$

- $\hat{J}$, the approximation of $J$, is given by
  $$
  \hat{J}(\boldsymbol{\theta}) = J(\boldsymbol{w}^*) + \frac{1}{2}(\boldsymbol{w} - \boldsymbol{w}^*)^\top \boldsymbol{H}(\boldsymbol{w} - \boldsymbol{w}^*),
  $$
  where $\boldsymbol{H}$ is the Hessian matrix of $J$ with respect to $\boldsymbol{w}$ evaluated at $\boldsymbol{w}^*$.

  - The minimum of $\hat{J}$ occurs where its gradient
    $$
    \nabla_\boldsymbol{w} \hat{J}(\boldsymbol{w}) = \boldsymbol{H} (\boldsymbol{w} - \boldsymbol{w}^*) = 0
    $$

  - Find the minimum of the regularized version of $\hat{J}$.
    $$
    \begin{aligned}
    \alpha\tilde{\boldsymbol{w}} + \boldsymbol{H}(\tilde{\boldsymbol{w}} - \boldsymbol{w}^*) = 0 \\
    (\boldsymbol{H} + \alpha \boldsymbol{I}) \tilde{\boldsymbol{w}} = \boldsymbol{Hw}^* \\
    \tilde{\boldsymbol{w}} = (\boldsymbol{H} + \alpha \boldsymbol{I})^{-1} \boldsymbol{Hw}^*
    \end{aligned}
    $$

    - As $\alpha \to 0$, $\tilde{\boldsymbol{w}} \sim \boldsymbol{w}^*$.

    - Since $\boldsymbol{H}$ is real and symmetric, it can be decomposed into a diagonal matrix $\Lambda$ and an orthonormal basis of eigenvectors $Q$ such that $\boldsymbol{H} = \boldsymbol{Q\Lambda Q}^\top$.

      - Note that an orthogonal matrix is invertible with inverse its transpose.

      $$
      \begin{aligned}
      \tilde{\boldsymbol{w}} &= (\boldsymbol{Q\Lambda Q}^\top + \alpha \boldsymbol{I})^{-1} \boldsymbol{Q\Lambda Q}^\top \boldsymbol{w}^* \\
      &= \left[ \boldsymbol{Q}(\boldsymbol{\Lambda} + \alpha\boldsymbol{I}) \boldsymbol{Q}^\top \right]^{-1} \boldsymbol{Q\Lambda Q}^\top \boldsymbol{w}^* \\
      &= \boldsymbol{Q}(\boldsymbol{\Lambda} + \alpha\boldsymbol{I})^{-1} \boldsymbol{\Lambda Q}^\top \boldsymbol{w}^*.
      \end{aligned}
      $$

      - If $\lambda_i$, the $i$-th eigenvector of $\boldsymbol{H}$, is larger than $\alpha$, then the effect of regularization is relatively small. However, components with $\lambda_i << \alpha$ will be shrunk to have nearly zero magnitude.

### 7.1.2 $L^1$ Regularization

- Formally, $L^1$ regularization on the model parameter $\boldsymbol{w}$ is defined as:
  $$
  \Omega(\boldsymbol{\theta}) = \| \boldsymbol{w} \|_1 = \sum_i |w_i|.
  $$

- The regularized objective function $\tilde{J}(\boldsymbol{w}; \boldsymbol{X}, \boldsymbol{y})​$ is given by 
  $$
  \tilde{J}(\boldsymbol{w}; \boldsymbol{X}, \boldsymbol{y}) = \alpha \| \boldsymbol{w} \|_1 + J(\boldsymbol{w}; \boldsymbol{X}, \boldsymbol{y}),
  $$
  with the corresponding gradient:
  $$
  \nabla_\boldsymbol{w} \tilde{J}(\boldsymbol{w}; \boldsymbol{X}, \boldsymbol{y}) = \alpha \cdot \text{sign}(\boldsymbol{w}) + \nabla_\boldsymbol{w} J(\boldsymbol{X}, \boldsymbol{y}; \boldsymbol{w})
  $$

- Since the $L^1$ penalty does not admit clean algebraic expressions in the case of a fully general Hessian, we will also make the further simplifying assumption that the Hessian is diagonal, $\boldsymbol{H} = \text{diag}([H_{1, 1}, \cdots, H_{n, n}])$, where each $H_{i, i} > 0$.

  - The quadratic approximation of the $L^1$ regularized objective function decomposes into a sum over the parameters:
    $$
    \hat{J}(\boldsymbol{w}; \boldsymbol{X}, \boldsymbol{y}) = J(\boldsymbol{w}^*; \boldsymbol{X}, \boldsymbol{y}) + \sum_i \left[ \frac{1}{2} H_{i, i} (\boldsymbol{w}_i - \boldsymbol{w}_i^*)^2 + \alpha |w_i| \right].
    $$

  - The problem of minimizing this approximate cost function has an analytical solution, with the following form:
    $$
    w_i = \text{sign}(w_i^*) \cdot \max\left\{ |w_i^*| - \frac{\alpha}{H_{i, i}}, 0 \right\}.
    $$

    - Consider the situation where $w_i^* > 0​$ for all $i​$. There are two possible outcomes:
      - The case where $w_i^* \leq \frac{\alpha}{H_{i, i}}$.
        : The optimal value of $w_i$ under the regularized objective is $w_i = 0$. This occurs because the contribution of $J(\boldsymbol{w}; \boldsymbol{X}, \boldsymbol{y})$ to the regularized objective $\tilde{J}$ is overwhelmed.
      - The case where $w_i^* > \frac{\alpha}{\H_{i, i}}$.
        : The regularization does not move the optimal value of $w_i$ to zero but instead it just shifts it in that direction by a distance equal to $\frac{\alpha}{H_{i, i}}$.

- In comparison to $L^2$ regularization, $L^1$ regularization results in a solution that is more **sparse** with the fact that some parameters have an optimal value of zero.

  - The sparsity property induces by $L^1​$ regularization has been used extensively as a **feature selection** mechanism.

## 7.2 Norm Penalties as Constrained Optimization

- If we wanted to constraint $\Omega(\boldsymbol{\theta})$ to be less than some constant $k$, we could construct a generalized Lagrange function
  $$
  \mathcal{L}(\boldsymbol{\theta}, \alpha; \boldsymbol{X}, \boldsymbol{y}) = J(\boldsymbol{\theta}; \boldsymbol{X}, \boldsymbol{y}) + \alpha(\Omega(\boldsymbol{\theta}) - k).
  $$

  - The solution to the constrained problem is given by
    $$
    \boldsymbol{\theta}^* = \operatorname{arg min}_\boldsymbol{\theta} \max_{\alpha, \alpha \geq 0} \mathcal{L}(\boldsymbol{\theta}, \alpha).
    $$

  - $\alpha$ must increase whenever $\Omega(\boldsymbol{\theta}) > k$ and decrease whenever $\Omega(\boldsymbol{\theta}) < k$ .

  - All positive $\alpha$ encourage $\Omega(\boldsymbol{\theta})$ to shrink.

    - The optimal value $\alpha^*$ will encourage $\Omega(\boldsymbol{\theta})$ to shrink, but not so strongly to make $\Omega(\boldsymbol{\theta})$ become less than $k$.

  - To gain some insight into the effect of the constraint, we can fix $\alpha^*$ and view the problem as just a function of $\boldsymbol{\theta}$:
    $$
    \boldsymbol{\theta}^* = \operatorname{arg min}_\boldsymbol{\theta} \mathcal{L}(\boldsymbol{\theta}, \alpha^*) = \operatorname{arg min}_\boldsymbol{\theta} J(\boldsymbol{\theta}; \boldsymbol{X}, \boldsymbol{y}) + \alpha^* \Omega(\boldsymbol{\theta}).
    $$
    

## 7.3 Regularization and Under-Constrained Problems

## 7.4 Dataset Augmentation

- Dataset augmentation has been a particularly effective technique for a specific classification problem: objective recognition.
- One must be careful not to apply transformations that would change the correct class.
  - 'b' and 'd' / '6' and '9'
- Dataset augmentation is effective for speech recognition task as well.
- Injecting noise in the input to a neural network can also be seen as a form of data augmentation.

## 7.5 Noise Robustness

- Noise injection can be much more powerful than simply shrinking the parameters, especially when the noise is added to the hidden units.

- In the context of RNN, the technique that adding the noise to the weights has been used primarily.

  - It can be interpreted as a stochastic implementation of Bayesian inference over the weights.

- Noise applied to the weights can also be interpreted as equivalent to a more traditional form of regularization.

  - With the regression setting, consider the least-squares cost function:
    $$
    J = \mathbb{E}_{p(x, y)}[(\hat{y}(\boldsymbol{x}) - y)^2].
    $$

  - Assume that with each input presentation we also include a random perturbation $\varepsilon_\boldsymbol{W} \sim \mathcal{N}(\boldsymbol{\varepsilon}; \mathbf{0}, \eta\boldsymbol{I})$ of the network weights.

    - For small $\eta$, the minimization of $J$ with added weight noise is equivalent to minimization of $J$ with an additional regularization term: $\eta \mathbb{E}_{p(\boldsymbol{x}, y)}[\| \nabla_\boldsymbol{W} \hat{y}(\boldsymbol{x}) \|^2]​$.

### 7.5.1 Injecting Noise at the Output Targets

- If label $y$ has some amount of mistakes, it can be harmful to maximize $\log p(y \mid \boldsymbol{x})$.
  - One way to prevent this is to explicitly model the noise on the labels.
  - **Label Smoothing**
    - It regularizes a model based on a softmax with $k$ output values by replacing the hard $0$ and $1$ classification targets with targets of $\frac{\epsilon}{k-1}$ and $1-\epsilon​$, respectively.
      - Maximum likelihood learning with a softmax classifier and hard targets may actually never converge.

## 7.6 Semi-Supervised Learning

- Both unlabeled examples from $P(\boldsymbol{x})$ and labels examples from $P(\boldsymbol{x}, \boldsymbol{y})$ are used to estimate $P(\boldsymbol{y} \mid \boldsymbol{x})$ or predict $\boldsymbol{y}$ from $\boldsymbol{x}$.
  - In the context of deep learning, semi-supervised learning usually refers to learning a representation $\boldsymbol{h} = f(\boldsymbol{x})$.

## 7.7 Multi-Task Learning

- Multi-task learning is a way to improve generalization by pooling the examples arising out of several tasks.
- Different supervised tasks share the same input $\boldsymbol{x}$, as well as some intermediate-level representation $\boldsymbol{h}^\text{shared}$ capturing a common pool of factors.

## 7.8 Early Stopping

## 7.9 Parameter Tying and Parameter Sharing

- **Parameter Tying**

  - Assume that we have model $A$ with parameters $\boldsymbol{w}^{(A)}$ and model $B$ with parameters $\boldsymbol{w}^{(B)}​$.

  - The two models map the input to two different, but related outputs: $\hat{y}^{(A)} = f(\boldsymbol{w}^{(A)}, \boldsymbol{x})$ and  $\hat{y}^{(B)} = g(\boldsymbol{w}^{(B)}, \boldsymbol{x})$.

    - Let us imagine that the tasks are similar enough. Then we can leverage this information through regularization:
      $$
      \Omega(\boldsymbol{w}^{(A)}, \boldsymbol{w}^{(B)}) = \|\boldsymbol{w}^{(A)} - \boldsymbol{w}^{(B)}\|^2_2.
      $$

  - Approach was used for regularizing the parameters of one model, trained as a supervised classifier, to be close to the parameters of another model, trained in an unsupervised paradigm.

- **Parameter Sharing**

  - A method to force sets of parameters to be equal for using constraints.
  - Significant Advantage: Only a subset of the parameters need to be stored in memory.
    - In CNN schemes, this can lead to significant reduction in memory footprint of the model.
    - Parameter sharing has allowed CNNs to dramatically lower the number of unique model parameters and to significantly increase network sizes without requiring a corresponding increase in training data.

## 7.10 Sparse Representations

## 7.11 Bagging and Other Ensemble Methods

- **Bagging** (**Bootstrap aggregation**)

  -  A technique for reducing generalization error by combining several models.

    - The idea is to train several different models separately, than have all of the models vote on the output for test examples. (**Model averaging**)
    - Model averaging works because different models will not make the same mistake.

  - Consider set of $k​$ regression models:

    - Suppose that each model makes an error $\varepsilon_i$ on each example, with the errors drawn from a zero-mean multivariate normal distribution with variance $\mathbb{E}[\varepsilon^2_i] = v$ and covariances $\mathbb{E}[\varepsilon_i \varepsilon_j] = c$.

    - Then the error made by the average prediction of all the ensemble models is $\frac{1}{k} \sum_i \varepsilon_i$.

    - The expected squared error of the ensemble predictor is 
      $$
      \mathbb{E} \left[ \left( \frac{1}{k} \sum_i \varepsilon_i \right)^2 \right] = \frac{1}{k^2} \left[ \sum_i \left( \varepsilon_i^2 + \sum_{j \neq 1} \varepsilon_1 \varepsilon_j \right) \right] = \frac{1}{k}v + \frac{k-1}{k}c.
      $$

      - If errors are perfectly correlated, $c = v$, and mean squared error reduces to $v$, so model averaging does not help.
      - If errors are perfectly uncorrelated and $c=0$, expected squared error of ensemble is only $\frac{v}{k}$.
      <center><img src="./imgs/7_01.png" height=20%></center>

- Neural networks with Bagging

  - Neural nets often benefit from model averaging even if all of the models are trained on the same datasets because they reach a wide enough variety of solution points.
    - Differences in random initialization, random selection of minibatches, differences in hyperparameters, or different outcomes of non-deterministic implementations.

## 7.12 Dropout

- 

## 7.13 Adversarial Training

## 7.14 Tangent Distance, Tangent Prop, and Manifold Tangent Classifier

