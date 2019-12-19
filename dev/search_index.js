var documenterSearchIndex = {"docs":
[{"location":"examples/#Examples-1","page":"Examples","title":"Examples","text":"","category":"section"},{"location":"examples/#Water-inflow-1","page":"Examples","title":"Water inflow","text":"","category":"section"},{"location":"examples/#","page":"Examples","title":"Examples","text":"Let's model some monthly water inflow data from the Northeast of Brazil using a Lognormal GAS model. Since inflow is a highly seasonal phenomenon, we will utilize lags 1 and 12. The former aims to characterize the short-term evolution of the series, while the latter characterizes the seasonality. The full code is in the examples folder.","category":"page"},{"location":"examples/#","page":"Examples","title":"Examples","text":"# Convert data to vector\ny = Vector{Float64}(vec(inflow'))\n\n# Specify GAS model: here we use lag 1 for trend characterization and \n# lag 12 for seasonality characterization\ngas = GAS([1, 12], [1, 12], LogNormal, 0.0)\n\n# Estimate the model via MLE\nfit!(gas, y)\n\n# Obtain in-sample estimates for the inflow\ny_gas = fitted_mean(gas, y, dynamic_initial_params(y, gas))\n\n# Compare observations and in-sample estimates\nplot(y)\nplot!(y_gas)","category":"page"},{"location":"examples/#","page":"Examples","title":"Examples","text":"The result can be seen in the following plot.","category":"page"},{"location":"examples/#","page":"Examples","title":"Examples","text":"(Image: Historical inflow data vs. in-sample estimates)","category":"page"},{"location":"manual/#Manual-1","page":"Manual","title":"Manual","text":"","category":"section"},{"location":"manual/#Model-Specification-1","page":"Manual","title":"Model Specification","text":"","category":"section"},{"location":"manual/#Recursion-1","page":"Manual","title":"Recursion","text":"","category":"section"},{"location":"manual/#Links-1","page":"Manual","title":"Links","text":"","category":"section"},{"location":"manual/#","page":"Manual","title":"Manual","text":"Links are reparametrizations utilized to ensure certain parameter is within its original domain, i.e. in a distribution one would like to ensure that the time varying parameter f in mathbbR^+. The way to do this is to model tildef = lnf. More generally one can stablish that tildef = h(f). We refer to this procedure as linking. When the parameter is linked the GAS recursion happens in the domain of tildef and then one can recover the orginal parameter by f = left(hright)^-1(tilde f). We refer to this procedure as unlinking. The new GAS recursion becomes.","category":"page"},{"location":"manual/#","page":"Manual","title":"Manual","text":"beginequation*leftbeginarrayccl\n    f_t = h^-1(tilde f_t) \n    tilde f_t+1 = omega + sum_i=1^p A_itilde s_t-i+1 + sum_j=1^q B_jtilde f_t-j+1\n    endarray\n    right\nendequation*","category":"page"},{"location":"manual/#","page":"Manual","title":"Manual","text":"Notice that the change in parametrization changes the dynamics of the model. The GAS(1,1) for a Normal distribution with inverse scaling d = 1 is equivalent to the GARCH(1, 1) model, but only on the original parameter, if you work with a different parametrization the model is no longer equivalent.","category":"page"},{"location":"manual/#Types-of-links-1","page":"Manual","title":"Types of links","text":"","category":"section"},{"location":"manual/#","page":"Manual","title":"Manual","text":"The abstract type Link subsumes any type of link that can be expressed.","category":"page"},{"location":"manual/#","page":"Manual","title":"Manual","text":"ScoreDrivenModels.IdentityLink\nScoreDrivenModels.LogLink\nScoreDrivenModels.LogitLink","category":"page"},{"location":"manual/#ScoreDrivenModels.IdentityLink","page":"Manual","title":"ScoreDrivenModels.IdentityLink","text":"IdentityLink <: Link\n\nDefine the map tildef = f where f in mathbbR and tildef in mathbbR\n\n\n\n\n\n","category":"type"},{"location":"manual/#ScoreDrivenModels.LogLink","page":"Manual","title":"ScoreDrivenModels.LogLink","text":"LogLink <: Link\n\nDefine the map tildef = ln(f - a) where f in a infty) a in mathbbR and tildef in mathbbR\n\n\n\n\n\n","category":"type"},{"location":"manual/#ScoreDrivenModels.LogitLink","page":"Manual","title":"ScoreDrivenModels.LogitLink","text":"LogitLink <: Link\n\nDefine the map tildef = -ln(fracb - af + a - 1) where f in a b a b in mathbbR and tildef in mathbbR\n\n\n\n\n\n","category":"type"},{"location":"manual/#Link-functions-1","page":"Manual","title":"Link functions","text":"","category":"section"},{"location":"manual/#","page":"Manual","title":"Manual","text":"ScoreDrivenModels.link\nScoreDrivenModels.unlink\nScoreDrivenModels.jacobian_link","category":"page"},{"location":"manual/#ScoreDrivenModels.link","page":"Manual","title":"ScoreDrivenModels.link","text":"link(args...)\n\nThe link function is a map that brings a parameter f in a subspace mathcalF subset mathbbR to mathbbR.\n\n\n\n\n\n","category":"function"},{"location":"manual/#ScoreDrivenModels.unlink","page":"Manual","title":"ScoreDrivenModels.unlink","text":"unlink(args...)\n\nThe unlink function is the inverse map of link. It brings tildef in mathbbR to the subspace mathcalF subset mathbbR.\n\n\n\n\n\n","category":"function"},{"location":"manual/#ScoreDrivenModels.jacobian_link","page":"Manual","title":"ScoreDrivenModels.jacobian_link","text":"jacobian_link(args...)\n\nEvaluates the derivative of the link with respect to the parameter f.\n\n\n\n\n\n","category":"function"},{"location":"#ScoreDrivenModels.jl-Documentation-1","page":"Home","title":"ScoreDrivenModels.jl Documentation","text":"","category":"section"},{"location":"#","page":"Home","title":"Home","text":"ScoreDrivenModels.jl is a Julia package for modeling, forecasting and simulating time series with score-driven models, also known as dynamic conditional score models (DCS) or generalized autoregressive score models (GAS). Implementations are based on the paper Generalized Autoregressive Models with Applications by D. Creal, S. J. Koopman and A. Lucas.","category":"page"},{"location":"#Features-1","page":"Home","title":"Features","text":"","category":"section"},{"location":"#","page":"Home","title":"Home","text":"SARIMA structure\nMaximum likelihood estimation\nMonte Carlo simulation\nSeveral available distributions:\nNormal\nLognormal\nPoisson\nBeta\nGamma","category":"page"},{"location":"#Roadmap-1","page":"Home","title":"Roadmap","text":"","category":"section"},{"location":"#","page":"Home","title":"Home","text":"Weibull distribution\nUnobserved components structure","category":"page"}]
}
