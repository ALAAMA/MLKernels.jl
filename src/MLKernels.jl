#===================================================================================================
  Kernel Functions Module
===================================================================================================#

module MLKernels

import Base: call, convert, eltype, show, *, +

export
    # Functions
    ismercer,
    isnegdef,
    attainszero,
    ispositive,
    isnonnegative,
    isnonpositive,
    isnegative,
    kernel,
    kernelmatrix,
    centerkernelmatrix!,
    centerkernelmatrix,
    nystrom,

    # Kernel Types
    Kernel,
        StandardKernel,
            BaseKernel,
                AdditiveKernel,
                    SquaredDistanceKernel,
                    SineSquaredKernel,
                    ChiSquaredKernel,
                    SeparableKernel,
                        ScalarProductKernel,
                        MercerSigmoidKernel,
                ARD,
            CompositeKernel,
                ExponentialKernel,
                RationalQuadraticKernel,
                MaternKernel,
                ExponentiatedKernel,
                PolynomialKernel,
                LogKernel,
                PowerKernel,
                SigmoidKernel,
        CombinationKernel,
            KernelProduct,
            KernelSum,
        # Kernel Constructors
        GaussianKernel,
        RadialBasisKernel,
        LaplacianKernel,
        LinearKernel

include("common.jl")
include("meta.jl")
include("kernels.jl")
include("pairwise.jl")
include("kernelfunctions.jl")
include("kernelapproximation.jl")

end # MLKernels
