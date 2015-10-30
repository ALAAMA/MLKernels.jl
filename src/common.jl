# Symmetrize the lower half of matrix S using the upper half of S
function syml!(S::Matrix)
    (p = size(S,1)) == size(S,2) || throw(ArgumentError("S ∈ ℝ$(p)×$(size(S, 2)) must be square"))
    @inbounds for j = 1:(p - 1), i = (j + 1):p 
        S[i, j] = S[j, i]
    end
    S
end
syml(S::Matrix) = syml!(copy(S))

# Symmetrize the upper off-diagonal of matrix S using the lower half of S
function symu!(S::Matrix)
    (p = size(S,1)) == size(S,2) || throw(ArgumentError("S ∈ ℝ$(p)×$(size(S, 2)) must be square"))
    @inbounds for j = 2:p, i = 1:(j-1)
        S[i,j] = S[j,i]
    end
    S
end
symu(S::Matrix) = symu!(copy(S))

# Return vector of dot products for each row of A
function dot_rows{T<:AbstractFloat}(A::Matrix{T})
    n, m = size(A)
    aᵀa = zeros(T, n)
    @inbounds for j = 1:m, i = 1:n
        aᵀa[i] += A[i,j] * A[i,j]
    end
    aᵀa
end

# Return vector of dot products for each row of A
function dot_rows{T<:AbstractFloat}(A::Matrix{T}, w::Array{T})
    n, m = size(A)
    length(w) == m || throw(DimensionMismatch("w must have the same length as A's rows."))
    aᵀa = zeros(T, n)
    @inbounds for j = 1:m, i = 1:n
        aᵀa[i] += A[i,j] * A[i,j] * w[j]
    end
    aᵀa
end

# Return vector of dot products for each column of A
function dot_columns{T<:AbstractFloat}(A::Matrix{T})
    n, m = size(A)
    aᵀa = zeros(T, m)
    @inbounds for j = 1:m, i = 1:n
        aᵀa[j] += A[i,j] * A[i,j]
    end
    aᵀa
end

# Return vector of dot products for each column of A
function dot_columns{T<:AbstractFloat}(A::Matrix{T}, w::Array{T})
    n, m = size(A)
    length(w) == n || throw(DimensionMismatch("w must have the same length as A's rows."))
    aᵀa = zeros(T, m)
    @inbounds for j = 1:m, i = 1:n
        aᵀa[j] += A[i,j] * A[i,j] * w[i]
    end
    aᵀa
end


#==========================================================================
  Matrix Operations
==========================================================================#

# Overwrite A with the Hadamard product of A and B. Returns A
function matrix_prod!{T<:AbstractFloat}(A::Array{T}, B::Array{T})
    length(A) == length(B) || error("A and B must be of the same length.")
    @inbounds for i = 1:length(A)
        A[i] *= B[i]
    end
    A
end

# Overwrite A with the Hadamard product of A and B, for symmetric matrices. Returns A
function matrix_prod!{T<:AbstractFloat}(A::Matrix{T}, B::Matrix{T}, is_upper::Bool, symmetrize::Bool = true)
    (n = size(A,1)) == size(A,2) == size(B,1) == size(B,2) || throw(DimensionMismatch("A and B must be square and of same order."))
    if is_upper
        @inbounds for j = 1:n, i = 1:j
            A[i,j] *= B[i,j]
        end
        symmetrize ? syml!(A) : A
    else
        @inbounds for j = 1:n, i = j:n
            A[i,j] *= B[i,j]
        end
        symmetrize ? symu!(A) : A
    end
end

# Overwrite A with the matrix sum of A and B. Returns A
function matrix_sum!{T<:AbstractFloat}(A::Array{T}, B::Array{T})
    length(A) == length(B) || error("A and B must be of the same length.")
    @inbounds for i = 1:length(A)
        A[i] += B[i]
    end
    A
end

# Overwrite A with the matrix sum of A and B, for symmetric matrices. Returns A
function matrix_sum!{T<:AbstractFloat}(A::Matrix{T}, B::Matrix{T}, is_upper::Bool, symmetrize::Bool = true)
    (n = size(A,1)) == size(A,2) == size(B,1) == size(B,2) || throw(DimensionMismatch("A and B must be square and of same order."))
    if is_upper
        @inbounds for j = 1:n, i = 1:j
            A[i,j] += B[i,j]
        end
        symmetrize ? syml!(A) : A
    else
        @inbounds for j = 1:n, i = j:n
            A[i,j] += B[i,j]
        end
        symmetrize ? symu!(A) : A
    end
end

function translate!{T<:AbstractFloat}(A::Array{T}, b::T)
    @inbounds for i = 1:length(A)
        A[i] += b
    end
    A
end
translate!{T<:AbstractFloat}(b::T, A::Array{T}) = translate!(A, b)

function translate!{T<:AbstractFloat}(b::Vector{T}, A::Matrix{T})
    (n = size(A,1)) == length(b) || throw(DimensionMismatch("first dimension of A does not match length of b"))
    @inbounds for j = 1:size(A,2), i = 1:n
        A[i,j] += b[i]
    end
    A
end

function translate!{T<:AbstractFloat}(A::Matrix{T}, b::Vector{T})
    (n = size(A,2)) == length(b) || throw(DimensionMismatch("second dimension of A does not match length of b"))
    @inbounds for j = 1:n, i = 1:size(A,1)
        A[i,j] += b[j]
    end
    A
end
