# Manual

## Model Specification

## Recursion

## Links

Links are reparametrizations utilized to ensure certain parameter is within its original domain. For instance, for a particular distribution, one might want to ensure that the time varying parameter is positive: ``f \in \mathbb{R}^+``. The way to do this is to model ``\tilde{f} = \ln{f}``. More generally, one can establish that ``\tilde{f} = h(f)``. We refer to this procedure as **linking**. When a parameter is linked, the GAS recursion happens in the domain of ``\tilde{f}`` and then one can recover the original parameter by ``f = \left(h\right)^-1(\tilde f)``. We refer to this procedure as **unlinking**. The new recursion becomes:

```math
\begin{equation*}\left\{\begin{array}{ccl}
    f_{t} &=& h^{-1}(\tilde f_t), \\
    \tilde f_{t+1} &=& \omega + \sum_{i=1}^p A_{i}\tilde s_{t-i+1} + \sum_{j=1}^q B_{j}\tilde f_{t-j+1}
    \end{array}
    \right.
\end{equation*}
```

Notice that a different parametrization alters the dynamics of the model. For example, the GAS(1,1) model with Normal distribution and scaling ``d = 1`` is equivalent to the well-known GARCH(1, 1) model. Conversely, if a different parametrization is utilized, the model will no longer be equivalent.

### Types of links

The abstract type `Link` subsumes any type of link that can be expressed.

```@docs
ScoreDrivenModels.IdentityLink
ScoreDrivenModels.LogLink
ScoreDrivenModels.LogitLink
```

### Link functions

```@docs
ScoreDrivenModels.link
ScoreDrivenModels.unlink
ScoreDrivenModels.jacobian_link
```
