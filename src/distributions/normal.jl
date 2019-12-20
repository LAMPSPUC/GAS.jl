"""
Proof somewhere 
parametrized in \\mu and \\sigma^2
"""
function score!(score_til::Matrix{T}, y::T, ::Type{Normal}, param::Matrix{T}, t::Int) where T
    score_til[t, 1] = (y - param[t, 1])/param[t, 2]
    score_til[t, 2] = -(0.5/param[t, 2]) * (1 - ((y - param[t, 1])^2)/param[t, 2])
    return
end

"""
Proof somewhere
"""
function fisher_information!(aux::AuxiliaryLinAlg{T}, ::Type{Normal}, param::Matrix{T}, t::Int) where T
    aux.fisher[1, 1] = 1 / (param[t, 2])
    aux.fisher[2, 2] = 1 / (2 * (param[t, 2] ^ 2))
    aux.fisher[2, 1] = 0
    aux.fisher[1, 2] = 0
    return
end

"""
Proof:
p = 1/sqrt(2πσ²) exp(-0.5(y-μ)²/σ²)

ln(p) = -0.5ln(2πσ²)-0.5(y-μ)²/σ²
"""
function log_likelihood(::Type{Normal}, y::Vector{T}, param::Matrix{T}, n::Int) where T
    loglik = -0.5 * n * log(2 * pi)
    for t in 1:n
        loglik -= 0.5 * (log(param[t, 2]) + (1 / param[t, 2]) * (y[t] - param[t, 1]) ^ 2)
    end
    return -loglik
end

function default_links(::Type{Normal})
    return [IdentityLink(); LogLink(0.0)]
end

# utils 
function update_dist(::Type{Normal}, param::Matrix{T}, t::Int) where T
    # normal here is parametrized as sigma^2
    return Normal(param[t, 1], sqrt(param[t, 2]))
end 

function num_params(::Type{Normal})
    return 2
end