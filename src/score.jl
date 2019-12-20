const SCORE_BIG_NUM = 1e5

function score_tilde!(score_til::Matrix{T}, y::T, links::Vector{<:Link}, 
                      D::Type{<:Distribution}, scaling::Real,
                      param::Matrix{T}, aux::AuxiliaryLinAlg{T}, t::Int) where T

    if scaling == SCALINGS[1] # 0.0
        scaling_identity!(score_til, y, links, D, aux, param, t)
    elseif scaling == SCALINGS[2] # 1/2
        scaling_invsqrt!(score_til, y, links, D, aux, param, t)
    elseif scaling == SCALINGS[3] # 1
        scaling_inv!(score_til, y, links, D, aux, param, t)
    end

    NaN2zero!(score_til, t)
    big_threshold!(score_til, SCORE_BIG_NUM, t)
    small_threshold!(score_til, SMALL_NUM, t)
    return
end

# Scalings
function scaling_identity!(score_til::Matrix{T}, y::T, links::Vector{<:Link}, D::Type{<:Distribution},
                           aux::AuxiliaryLinAlg{T}, param::Matrix{T}, t::Int) where T
    jacobian_link!(aux, links, param, t)
    score!(score_til, y, D, param, t)
    for p in eachindex(aux.jac)
        score_til[t, p] = score_til[t, p]/aux.jac[p]
    end
end

function scaling_invsqrt!(score_til::Matrix{T}, y::T, links::Vector{<:Link}, D::Type{<:Distribution},
                          aux::AuxiliaryLinAlg{T}, param::Matrix{T}, t::Int) where T
    # Evaluate jacobian, score and FI
    jacobian_link!(aux, links, param, t)
    score!(score_til, y, D, param, t)
    fisher_information!(aux, D, param, t)

    for p in eachindex(aux.score_til_t)
        aux.score_til_t[p] = score_til[t, p]
    end

    cholesky!(aux.fisher) # Overwrite aux.fisher with it upper triangular cholesky factorization
    LinearAlgebra.LAPACK.posv!('U', aux.fisher, aux.score_til_t)
    for p in eachindex(aux.score_til_t)
        score_til[t, p] = aux.score_til_t[p]
    end
    return
end

function scaling_inv!(score_til::Matrix{T}, y::T, links::Vector{<:Link}, D::Type{<:Distribution},
                      aux::AuxiliaryLinAlg{T}, param::Matrix{T}, t::Int) where T
    # Evaluate jacobian, score and FI
    jacobian_link!(aux, links, param, t)
    score!(score_til, y, D, param, t)
    fisher_information!(aux, D, param, t)
    for p in eachindex(aux.score_til_t)
        aux.score_til_t[p] = score_til[t, p]
    end
    # Solve for inv(FI)*score_til
    LinearAlgebra.LAPACK.posv!('U', aux.fisher, aux.score_til_t)
    for p in eachindex(aux.jac)
        score_til[t, p] = aux.jac[p] * aux.score_til_t[p]
    end
    return
end