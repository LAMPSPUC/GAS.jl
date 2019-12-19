using ScoreDrivenModels, Plots

# Some data on monthly inflow from Northeastern Brazil
inflow = [
    16793 22630 19211 11104 7009 5310 4297 3607 3031 2632 3175 4538
    10409 15919 13250 10156 6066 4459 3775 3117 2501 3281 5614 8825
    16253 19438 11266 5226 4381 3351 2943 2681 2375 2123 2729 4174
    12511 24177 17504 8959 5326 3675 3142 2895 2299 2609 7933 12582
    15317 14803 15911 18009 9081 5572 4499 3853 3205 4011 7769 12028
    12412 17865 19442 14468 7998 5758 4626 4078 3516 3542 5396 7563
    14675 13619 12863 13044 8220 4613 3896 3374 2904 2700 4616 12336
    16367 14647 20515 16158 7400 5038 4355 3947 3723 3758 5854 13611
    10164 12920 13701 8099 5165 3905 3431 3025 2568 2657 6742 15584
    19265 19019 15047 7905 6042 4405 3917 3395 3147 4668 9338 8853
    5270 4500 5320 5178 3788 2770 2640 2283 2276 3239 7507 18137
    15730 8458 9984 8876 5911 3859 3380 3176 2645 3882 5717 12050
    13663 11239 10975 13725 6673 4450 3784 3089 2534 3746 9425 13162
    13717 10814 12720 18223 10307 5442 4232 3723 3282 3265 5693 7521
    12656 12213 8454 7474 6388 3811 3827 2988 2475 2879 6858 8374
    6181 6033 6381 5470 3179 3075 2467 2292 2647 4520 6496 13694
    15114 18114 7080 6813 6113 4131 3541 2881 2718 3618 4187 8420
    16890 16523 20532 12570 8533 6845 4689 4492 3629 4461 6169 11194
    18895 29515 46244 23462 11406 8314 6774 5894 5856 6030 9560 9908
    18616 30803 32685 13975 10935 7147 6605 5632 5010 5326 6674 13797
    17437 15454 14649 18947 8930 6251 5091 4548 4209 5392 12710 18116
    21133 23345 22227 20862 12374 8070 6339 5363 4908 5028 5059 5517
    14610 22724 28136 21402 14006 8126 6320 5725 4503 5910 11280 17501
    19163 9709 8414 12462 6342 4395 3884 3483 4184 4451 5497 11575
    18561 24976 22084 22033 9929 6174 4920 4416 4228 5483 6925 11422
    18697 22751 15553 7630 5660 4240 3923 3864 3660 3234 3751 5711
    9719 7972 8213 9154 5591 3736 3426 2761 2699 3095 4531 10743
    16144 10963 13619 10375 6481 3918 3333 3334 3202 3287 5143 8165
    11195 7855 9535 6027 4214 3292 3239 3018 2827 3092 5351 20447
    28066 12447 9684 6658 4263 3403 3496 3215 3238 3547 4457 5188
    10432 15733 14341 15656 7794 4838 3860 3524 3295 4174 6199 9604
    15182 29911 39281 13269 8673 5730 4634 4246 4261 5673 12705 16230
    18068 13812 12532 7949 5717 4338 3792 3629 3240 3813 4036 5836
    15089 14584 14949 15323 6896 4953 4219 3448 3421 2703 3053 9121
    8982 8891 9309 8447 5581 4259 3322 2937 2344 2780 5084 9730
    13800 7082 6498 5738 4019 3153 2644 2096 2046 2458 5113 10190
    17760 14927 13824 13653 7954 5300 4077 3663 3218 3327 3882 9220
    10337 9770 9556 4850 3615 2868 2501 2299 2052 2097 5877 9932
    9341 5690 11712 7668 3950 2799 2391 2089 2335 1880 4862 10069
    13150 15038 13523 11029 5502 3712 2928 3008 2788 2470 5287 11422
]

# Convert data to vector
y = Vector{Float64}(vec(inflow'))

# Specify GAS model: here we use lag 1 for trend characterization and lag 12 for seasonality characterization
gas = GAS([1, 12], [1, 12], LogNormal, 0.0)

# Estimate the model via MLE
fit!(gas, y)

# Obtain in-sample estimates for the inflow
y_gas = fitted_mean(gas, y, dynamic_initial_params(y, gas))

# Compare observations and in-sample estimates
plot(y, label = "historical inflow")
plot!(y_gas, label = "in-sample estimates")