export score_driven_recursion, fitted_mean, simulate_recursion

"""
score_driven_recursion(sd_model::SDM, observations::Vector{T}) where T

start with the stationary params for a 
"""
function score_driven_recursion(gas::GAS{D, T}, observations::Vector{T};
                                 initial_params::Matrix{T} = stationary_initial_params(gas)) where {D, T}
    @assert gas.scaling in SCALINGS
    # Allocations
    n = length(observations)
    n_params = num_params(D)
    param = Matrix{T}(undef, n + 1, n_params)
    param_tilde = Matrix{T}(undef, n + 1, n_params)
    scores_tilde = Matrix{T}(undef, n, n_params)
    aux = AuxiliaryLinAlg{T}(n_params)

    # Query the biggest lag
    biggest_lag = number_of_lags(gas)

    # initial_values  
    for i in 1:biggest_lag
        for p in 1:n_params
            param[i, p] = initial_params[i, p]
        end
        link!(param_tilde, gas, param, i)
        score_tilde!(scores_tilde, observations[i], gas, param, aux, i)
    end
    
    update_param_tilde!(param_tilde, gas.ω, gas.A, gas.B, scores_tilde, biggest_lag)

    for i in biggest_lag + 1:n
        univariate_score_driven_update!(param, param_tilde, scores_tilde, observations[i], aux, gas, i)
    end
    update_param!(param, param_tilde, gas, n + 1)

    return param
end


function simulate_recursion(gas::GAS{D, T}, n::Int; 
                            initial_params::Matrix{T} = stationary_initial_params(gas), 
                            update::Function = sample_observation) where {D, T}
    # Allocations
    serie = zeros(n)
    n_params = num_params(D)
    param = Matrix{T}(undef, n, n_params)
    param_tilde = Matrix{T}(undef, n, n_params)
    scores_tilde = Matrix{T}(undef, n, n_params)
    
    aux = AuxiliaryLinAlg{T}(n_params)

    # Auxiliary Allocation
    param_dist = zeros(T, 1, n_params)

    biggest_lag = number_of_lags(gas)

    # initial_values  
    for t in 1:biggest_lag
        for p in 1:n_params
            param[t, p] = initial_params[t, p]
        end
        link!(param_tilde, gas, param, t)
        # Sample
        updated_dist = update_dist(D, param, t)
        serie[t] = update(updated_dist)
        score_tilde!(scores_tilde, serie[t], gas, param, aux, t)
    end
    
    update_param_tilde!(param_tilde, gas.ω, gas.A, gas.B, scores_tilde, biggest_lag)
    unlink!(param, gas, param_tilde, biggest_lag + 1)
    updated_dist = update_dist(D, param, biggest_lag + 1)
    serie[biggest_lag + 1] = update(updated_dist)

    for i in biggest_lag + 1:n-1
        # update step
        univariate_score_driven_update!(param, param_tilde, scores_tilde, serie[i], aux, gas, i)
        # Sample from the updated distribution
        unlink!(param, gas, param_tilde, i + 1)
        updated_dist = update_dist(D, param, i + 1)
        serie[i + 1] = update(updated_dist)
    end
    update_param!(param, param_tilde, gas, n)

    return serie, param
end

function univariate_score_driven_update!(param::Matrix{T}, param_tilde::Matrix{T},
                                         scores_tilde::Matrix{T},
                                         observation::T, aux::AuxiliaryLinAlg{T},
                                         gas::GAS{D, T}, i::Int) where {D <: Distribution, T <: AbstractFloat}
    # update param 
    update_param!(param, param_tilde, gas, i)
    # evaluate score
    score_tilde!(scores_tilde, observation, gas, param, aux, i)
    # update param_tilde
    update_param_tilde!(param_tilde, gas.ω, gas.A, gas.B, scores_tilde, i)
    return 
end

function update_param!(param::Matrix{T}, param_tilde::Matrix{T}, gas::GAS{D, T}, i::Int) where {D, T}
    unlink!(param, gas, param_tilde, i)
    # Some treatments 
    NaN2zero!(param, i)
    big_threshold!(param, BIG_NUM, i)
    small_threshold!(param, SMALL_NUM, i)
    return
end

function update_param_tilde!(param_tilde::Matrix{T}, ω::Vector{T}, A::Dict{Int, Matrix{T}}, 
                             B::Dict{Int, Matrix{T}}, scores_tilde::Matrix{T}, i::Int) where T
    for p in eachindex(ω)
        param_tilde[i + 1, p] = ω[p]
    end
    for (lag, mat) in A
        for p in axes(mat, 1)
            param_tilde[i + 1, p] += mat[p, p] * scores_tilde[i - lag + 1, p]
        end
    end
    for (lag, mat) in B
        for p in axes(mat, 1)
            param_tilde[i + 1, p] += mat[p, p] * param_tilde[i - lag + 1, p]
        end
    end
    return 
end

"""
    fitted_mean(gas::GAS{D, T}, observations::Vector{T}, initial_params::Vector{T}) where {D, T}

return the fitted mean.. #TODO
"""
function fitted_mean(gas::GAS{D, T}, observations::Vector{T}; 
                     initial_params::Matrix{T} = stationary_initial_params(gas)) where {D, T}
    params_fitted = score_driven_recursion(gas, observations; initial_params = initial_params)
    n = size(params_fitted, 1)
    fitted_mean = Vector{T}(undef, n)

    for t in axes(params_fitted, 1)
        sdm_dist = update_dist(D, params_fitted, t)
        fitted_mean[t] = mean(sdm_dist)
    end
    
    return fitted_mean
end