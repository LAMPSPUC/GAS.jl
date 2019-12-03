@testset "Score" begin
    for dist in SDM.DISTS
        @testset "$dist" begin
            test_score_mean(dist)
        end
    end
end

@testset "Log-likelihood" begin
    for dist in SDM.DISTS
        @testset "$dist" begin
            test_loglik(dist)
        end
    end
end
