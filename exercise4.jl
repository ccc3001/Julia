### A Pluto.jl notebook ###
# v0.19.0

using Markdown
using InteractiveUtils

# ╔═╡ 876b3aa1-ca0c-44b7-9072-954d0539c8df
begin
	using PlutoUI, BenchmarkTools, Profile, ProfileSVG, LinearAlgebra
	
	PlutoUI.TableOfContents()
end

# ╔═╡ 516919ff-f9a2-4454-85a4-1f5d837fce9d
using SparseArrays

# ╔═╡ 7081e4e8-66f1-11eb-3670-fb58d677f045
md"""
# Scientific Programming - Sparse Arrays

[Institute for Biomedical Imaging](https://www.tuhh.de/ibi/home.html), Hamburg University of Technology

* 👨‍🏫 Prof. Dr.-Ing. Tobias Knopp
* 👨‍🏫 Dr. rer. nat. Martin Möddel

The due date of this exercise is 17.05 at 0:00. Please submit your solution to [Stud.IP](https://e-learning.tuhh.de/studip/dispatch.php/course/files/index/031251f16bdb9858457bfa19c5b9fe0d?cid=2da322cacb476a5b1341a14ae4d853e2). For troubleshooting and general tips, you can join the exercise at 13.05.
"""

# ╔═╡ 8e2679c8-f455-44b8-9163-90f6c494e542
md"""

## Sparse Matrices

Julia has native support for sparse vectors and sparse matrices in the [`SparseArrays`](https://docs.julialang.org/en/v1/stdlib/SparseArrays/) standard library module, so we can simply call
"""

# ╔═╡ 02a4ce54-54e6-493d-88b6-a299903dcb9f
md"""
without the need to install any additional packages.

### Task 1

In Julia, sparse matrices are stored in the Compressed Sparse Column ([CSC](https://docs.julialang.org/en/v1/stdlib/SparseArrays/#man-csc)) format.

A less commonly used format is the Coordinate list ([COO](https://en.wikipedia.org/wiki/Sparse_matrix#Coordinate_list_(COO))) format, which stores row indices, column indices, and values.

🎓 Add a type `SparseMatrixCOO{Tv,Ti<:Integer} <: AbstractSparseMatrix{Tv,Ti}` with a constructor method `SparseMatrixCOO(I,J,V,m,n)`, where `I` is a vector of the row indices, `J` is a vector of column indices, and `V` is a vector of value, `m` is the number of rows, and `n` is the number of columns.
"""

# ╔═╡ 2258971e-4b08-42ba-aa5c-76cf45a37720
begin
	struct SparseMatrixCOO{Tv, Ti<:Integer} <: AbstractSparseMatrix{Tv,Ti}
		vec::Vector{Tuple{Ti,Ti,Tv}}
		m::Ti 						
		n::Ti 						
		function SparseMatrixCOO(I::Vector{Ti}, J::Vector{Ti}, V::Vector{Tv}, m::Int, n::Int) where {Tv,Ti}
			if(m < 1)
				throw(DomainError(m,"Sparse matrix needs to be initialized with a positive number of rows"))
			elseif(n < 1)
				throw(DomainError(n,"Sparse matrix needs to be initialized with a positive number of columns"))
			elseif(!(length(I) == length(J) == length(V)))
				throw(DomainError(length(I),"Sparse matrix needs to be initialized with vectors of same length"))
			elseif(max(I...) > m )
				throw(DomainError(max(I...), "Index in I is out of bound"))
			elseif(max(J...) > n)
				throw(DomainError(max(J...), "Index in J is out of bound"))
			end

			tuple_vec = Vector{Tuple{Ti,Ti,Tv}}()
			for i=1:length(I)
				push!(tuple_vec, (I[i], J[i], V[i]))
			end
			return new{Tv,Ti}(tuple_vec,m,n)
		end
		
		function SparseMatrixCOO(I::Vector{Ti}, J::Vector{Ti}, V::Vector{Tv}) where {Tv,Ti}
			m = length(I)
			n = length(J)
			tuple_vec = Vector{Tuple{Ti,Ti,Tv}}()
			for i=1:length(I)
				push!(tuple_vec, (I[i], J[i], V[i]))
			end
			return new{Tv,Ti}(tuple_vec,m,n)
		end

		function Base.size(S::SparseMatrixCOO)
			return (S.m, S.n)
		end

		function Base.getindex(S::SparseMatrixCOO{Tv,Ti},i::Integer,j::Integer) where {Tv,Ti}
			if(i < 0 || i > S.m)
				throw(DomainError(i, "Index i is out of bound"))
			elseif(j < 0 || j > S.n)
				throw(DomainError(i, "Index j is out of bound"))
			end
			for it=1:length(S.vec)
				if(S.vec[it][1] == i && S.vec[it][2] == j)
					return S.vec[it][3]
				end
			end
			return 0
		end

		function LinearAlgebra.mul!(y::Vector,A::SparseMatrixCOO,x::Vector)

			for it=1:length(y)
				y[it] = 0
			end
			for it=1:length(A.vec)
				y[A.vec[it][1]] += (A.vec[it][3] * x[A.vec[it][2]])
			end
			return y
		end
		
	end
end

# ╔═╡ e8ab1879-64be-49f6-bee1-f7c026da97a8
md"""
### Task 2

With this new type and constructor method in place, we can initialize a sparse matrix.
"""

# ╔═╡ c867f9c3-3af7-447c-898d-5a676d414ed4
begin
	Is = [1, 4, 3, 4, 5] 
	Js = [4, 7, 18, 6, 9] 
	V = Float64[1, 2, -5, 4, 3]
end;

# ╔═╡ 2ba136f9-248e-4711-b936-0d10c2cabeaf
S = SparseMatrixCOO(Is,Js,V,5,18);

# ╔═╡ f9ed0daa-8f51-4c85-adf0-88f304500778
md"""
At this point it is important to keep the `;´ at the end of the line! We will get to this point later.

What is also possible is the initialization of a nonsense sparse matrix. E.g. one, where `m` and `n` are negative or zero.
"""

# ╔═╡ ddcb466b-4268-4c35-a99a-7e2ddc94f1f4
Scorrupted = SparseMatrixCOO(Is,Js,V,0,-5);

# ╔═╡ 0585afe2-110a-481a-bb5c-3d89c2bd4d23
md"""
🎓 Rewrite the constructor method `SparseMatrixCOO(I,J,V,m,n)` to include the following checks:
* `m` and `n` must be positive numbers.
* All indices in `I` and `J` need to fall into the bounds defined by the number of rows `m` and columns `n`.
* `I`, `J`, and `V` should have the same length.
If any of these tests fail the constructor method should `throw` an `DomainError` like this one.
"""

# ╔═╡ 4f5b3fe8-7cc3-43e1-97af-da00974179b1
let m = 0
	throw(DomainError(m,"Sparse matrix needs to be initialized with a positive number of rows"))
end

# ╔═╡ bfaa92d5-189d-4944-a3b5-0212af61d7f4
md"""
### Task 3

🎓 For convenience it would be great to have an additional constructor `SparseMatrixCOO(I,J,V)`, which sets `m` and `n` to `maximum(I)` and `maximum(J)` respectively.
"""

# ╔═╡ 23faf295-e5c7-45e8-9d9b-ddff6d3e046a
SparseMatrixCOO(Is,Js,V);

# ╔═╡ 9c544085-f923-4356-9fc3-fc7031e83e45
md"""
### Task 4

So why is it, that we need to keep the `;´ at the end of the line? Let us have look
"""

# ╔═╡ 70f1240f-8780-49ed-aa54-e185a53b0e39
SparseMatrixCOO(Is,Js,V)

# ╔═╡ 40f4778b-ff73-48bd-802f-8e26a888fc26
md"""
We get an `MethodError: no method matching size(::SparseMatrixCOO{Int64, Int64})`. But why is this?

Further analysis of the stack trace reveals that the method `show` for printing out arrays was called. This is due to the fact that we defined our sparse matrix type as subtype of `<: AbstractSparseMatrix`, which comes with a number of generic methods for subtypes of this abstract type, such as a method for printing out matrices. For these generic methods to work we need to provide some interface functions.

🎓 To this end define `Base.size(S::SparseMatrixCOO)` returning a tuple containing the dimensions of S.
"""

# ╔═╡ 7e235378-79f7-4dda-ac31-050cd16b0075
begin
	# dummy variable forces reevaluation of cells below
	a4 = rand()
	
	#Base.size(S::SparseMatrixCOO) = missing
end;

# ╔═╡ 9e206357-80ac-4796-bce5-eaa22693a0ec
md"""
### Task 5

If we try again a new error arises.
"""

# ╔═╡ 4ef05880-26e1-44df-9a8a-d729b6b4cb95
SparseMatrixCOO(Is,Js,V)

# ╔═╡ 9c227b7a-d27b-432a-9017-37714cef778b
md"""
The cause of this error remains the same. However, this time we are missing a method `getindex`.

🎓 Implement the `function getindex(S::SparseMatrixCOO{Tv,Ti},i::Integer,j::Integer) where {Tv,Ti}` returning the value of the sparse matrix `S` at index (`i`,`j`). If trying to access sparse matrix out of bounds `throw` a `BoundsError`.
"""

# ╔═╡ 5c253d6b-86e2-42ec-b0b0-67827bc07034
begin 
	# dummy variable forces reevaluation of cells below
	a5 = rand()
	
#	function Base.getindex(S::SparseMatrixCOO{Tv,Ti},i::Integer,j::Integer) where {Tv,Ti}
#		return (42,42)
#	end
end

# ╔═╡ 0a6cd496-b6d5-4a96-8685-c48a86f6908e
md"""
If we reevaluate this cell we should see a nicely formatted matrix.
"""

# ╔═╡ 1a7e599f-a26a-4378-92ac-a486d06b488f
begin
	a5 # forces reevaluation
	SparseMatrixCOO(Is,Js,V)
end

# ╔═╡ bf52dddb-e981-41f8-9eb1-43bf2da21f4d
md"""
### Task 6

Interestingly, now that we have `size` and `getindex` defined we get a rudimentary matrix-vector-multiplication for free.
"""

# ╔═╡ f33f5ab9-e309-4b50-9ac1-79e66b6f5c46
let Is = [1, 4, 3, 3, 4, 5]; Js = [4, 7, 7, 10, 6, 9] ; V = Float64[1, 2, 5, -5, 4, 3]; S = SparseMatrixCOO(Is,Js,V,5,10); Sdense = Float64[0  0  0  1  0  0  0  0  0   0
0  0  0  0  0  0  0  0  0   0
0  0  0  0  0  0  5  0  0  -5
0  0  0  0  0  4  2  0  0   0
0  0  0  0  0  0  0  0  3   0]; v = Float64[0,1,2,3,4,5,6,7,8,9];
	with_terminal() do
		a4
		a5
		println("If implemented correctly, these two matrix-vector-multiplication should yield the same result.")
		@show S*v
		@show Sdense*v
		
		println()
		println("benchmark sparse matrix-vector-multiplication")
		@btime $S*$v
		println("benchmark dense matrix-vector-multiplication")
		@btime $Sdense*$v
	end
end

# ╔═╡ e5d7b732-452e-4da0-b2ef-ad47b8577f2c
md"""
However, if we benchmark the multiplications, we find that the operation involving the dense matrix outperforms the sparse one.

Why this is the case can be figured out by by using julia's build in [statistical profiler](https://docs.julialang.org/en/v1/manual/profile/#Profiling). It works by periodically taking a back trace during the execution of any task. Each back trace captures the currently-running function and line number, plus the complete chain of function calls that led to this line, and hence is a "snapshot" of the current state of execution, which allows to identify bottlenecks.

However, the native output of julia's built-in sampling profiler is quite hard to read. To this end, we are going to visualize profiling data collected as a [flame graph](https://queue.acm.org/detail.cfm?id=2927301) using the package `ProfileSVG`. Here, the output involving the dense matrix: 
"""

# ╔═╡ 5034c65d-e416-4bc1-8ae0-e40c6633ec4d
let v = Float64[0,1,2,3,4,5,6,7,8,9]; Sdense = Float64[0  0  0  1  0  0  0  0  0   0
0  0  0  0  0  0  0  0  0   0
0  0  0  0  0  0  5  0  0  -5
0  0  0  0  0  4  2  0  0   0
0  0  0  0  0  0  0  0  3   0];
	 @profview for i=1:1000000; Sdense*v; end
end

# ╔═╡ fe334f27-b943-4ab4-bc6c-1bcbb97480c0
md"""
Take your time to take in the flam graph.

We are mostly interested in the left top part of the graph, starting with the `* in matmul.jl` label. On top, we find two distinct boxes, each of which represents a specific sub-methods executed within the `*`-method.
* The `similar` method is creating a vector for the output of our computation,
* while `mul!` method calls the BLAS-method `gemv!` for fast matrix-vector multiplication.

In case we use the sparse matrix for multiplication, we obtain this graph
"""

# ╔═╡ 47a38d9d-0359-4025-a221-9f38562eff53
let Is = [1, 4, 3, 3, 4, 5]; Js = [4, 7, 7, 10, 6, 9] ; V = Float64[1, 2, 5, -5, 4, 3]; S = SparseMatrixCOO(Is,Js,V,5,10); v = Float64[0,1,2,3,4,5,6,7,8,9];
	a4
	a5
	@profview for i=1:1000000; S*v; end
end

# ╔═╡ ed560ece-1f58-47d4-9ff9-f4d32761a2d2
md"""

We find that matrix-vector-multiplication (label `* in matmul.jl`) is performed by a generic fallback method called `generic_matvecmul!`, which spends most of its time calling the `getindex` method. So in conclusion, the reason why the dense matrix-vector-multiplication outperforms the sparse one is, that there is no specialized/optimized method available for the latter.

🎓 Add a method `LinearAlgebra.mul!(y::Vector,A::SparseMatrixCOO,x::Vector)` that calculates the matrix vector product `A*x` and stores the result in `y`. Assume that `y` does already has the correct size and length.
"""

# ╔═╡ 6ec72195-54ac-4871-9988-c08685a00713
begin
	# dummy variable forces reevaluation of cells below
	a6 = rand()
	
#	function LinearAlgebra.mul!(y::Vector,A::SparseMatrixCOO,x::Vector)
#		return y
#	end
end

# ╔═╡ 104224ee-1699-47c6-afb9-5e9cc3386bcd
md"""
If implemented correctly, the method should outperform the dense matrix-vector-multiplication
"""

# ╔═╡ 84efc13b-c8f0-43fd-a421-c5247b7fbdf7
let Is = [1, 4, 3, 3, 4, 5]; Js = [4, 7, 7, 10, 6, 9] ; V = Float64[1, 2, 5, -5, 4, 3]; S = SparseMatrixCOO(Is,Js,V,5,10); Sdense = Float64[0  0  0  1  0  0  0  0  0   0
0  0  0  0  0  0  0  0  0   0
0  0  0  0  0  0  5  0  0  -5
0  0  0  0  0  4  2  0  0   0
0  0  0  0  0  0  0  0  3   0]; v = Float64[0,1,2,3,4,5,6,7,8,9];
	with_terminal() do
		a6
		println("If implemented correctly, these two matrix-vector-multiplication should yield the same result.")
		@show S*v
		@show Sdense*v
		
		println()
		println("benchmark sparse matrix-vector-multiplication")
		@btime $S*$v
		println("benchmark dense matrix-vector-multiplication")
		@btime $Sdense*$v
	end
end

# ╔═╡ a2c25f3e-1bbc-4d77-9107-296a14293c59
md"""
Moreover, the `generic_matvecmul!` should be gone from the flame graph!
"""

# ╔═╡ 39146a45-4e62-4bf7-b3a7-e4e4807360b9
let Is = [1, 4, 3, 3, 4, 5]; Js = [4, 7, 7, 10, 6, 9] ; V = Float64[1, 2, 5, -5, 4, 3]; S = SparseMatrixCOO(Is,Js,V,5,10); v = Float64[0,1,2,3,4,5,6,7,8,9];
	a6
	@profview for i=1:1000000; S*v; end
end

# ╔═╡ b7de1eb0-66f1-11eb-2729-d7dcd1668d97
md"""
#### Notebook Helper Functions
"""

# ╔═╡ 480cd239-ccb4-495c-a805-78eb68321327
begin
	hint(text) = Markdown.MD(Markdown.Admonition("hint", "Hint", [text]))
	not_defined(variable_name) = Markdown.MD(Markdown.Admonition("danger", "Oh, oh! 😱", [md"Variable **$(Markdown.Code(string(variable_name)))** is not defined. You should probably do something about this."]))
	still_missing(text=md"Replace `missing` with your solution.") = Markdown.MD(Markdown.Admonition("warning", "Let's go!", [text]))
	keep_working(text=md"The answer is not quite right.") = Markdown.MD(Markdown.Admonition("danger", "Keep working on it!", [text]))
	yays = [md"Great! 🥳", md"Correct! 👏", md"Tada! 🎉"]
	correct(text=md"$(rand(yays)) Let's move on to the next task.") = Markdown.MD(Markdown.Admonition("correct", "Got it!", [text]))
end;

# ╔═╡ 76df0574-c6fa-4a99-af80-190c4044844d
hint(md"For reference you can take a look at the implementation of [`SparseVector`](https://docs.julialang.org/en/v1/stdlib/SparseArrays/#Sparse-Vector-Storage)")

# ╔═╡ 84ae0337-6b74-435e-9772-6d1971f43421
if !@isdefined(SparseMatrixCOO)
	not_defined(:SparseMatrixCOO)
elseif !hasmethod(SparseMatrixCOO, Tuple{Vector{Int},Vector{Int},Vector{Float64},Int,Int})
	still_missing(md"There is still no constructor method `SparseMatrixCOO(I,J,V,m,n)`.")
else
	let I = [1, 4, 3, 4, 5]; J = [4, 7, 18, 6, 9] ; V = Float64[1, 2, -5, 4, 3]; S = SparseMatrixCOO(I,J,V,6,20)
		if !(typeof(S) <: SparseMatrixCOO)
			keep_working(md"constructor method `SparseMatrixCOO(I,J,V,m,n)` does not return object of type `SparseMatrixCOO`")
		else
			correct()
		end
	end
end

# ╔═╡ a05c7147-2ebe-4806-89db-fe05bf1b29bb
if !@isdefined(SparseMatrixCOO)
	not_defined(:SparseMatrixCOO)
elseif !hasmethod(SparseMatrixCOO, Tuple{Vector{Int},Vector{Int},Vector{Float64},Int,Int})
	still_missing(md"There is still no constructor method `SparseMatrixCOO(I,J,V,m,n)`.")
else
	let I = [1, 4]; J = [6, 1]; V = Float64[1, 2]; 
		try 
			# initialize with negative m and n
			SparseMatrixCOO(I,J,V,0,1)
			SparseMatrixCOO(I,J,V,1,0)
			still_missing(md"no error thrown on negative `m` and `n`.")		
		catch e1
			if typeof(e1) == DomainError
				try 
					# initialize with indices out of bounds
					SparseMatrixCOO(I,J,V,3,6)
					SparseMatrixCOO(I,J,V,3,6)
					still_missing(md"no error thrown on indices out of bounds.")
				catch e2
					if typeof(e2) == DomainError
						try
							# initialize with indices out of bounds
							SparseMatrixCOO(I,J,V[1:1],4,6)
							still_missing(md"no error thrown on I, J, and V having different lengths")
						catch e3
							if typeof(e3) == DomainError
								correct()
							else
								keep_working(md"Wrong error type thrown.")
							end
						end						
					else
						keep_working(md"Wrong error type thrown.")
					end
				end
			else
				keep_working(md"Wrong error type thrown.")
			end
		end
	end
end

# ╔═╡ cac50dfa-b7d1-406e-bf86-b6a6b3083080
if !@isdefined(SparseMatrixCOO)
	not_defined(:SparseMatrixCOO)
elseif !hasmethod(SparseMatrixCOO, Tuple{Vector{Int},Vector{Int},Vector{Float64}})
	still_missing(md"There is still no constructor method `SparseMatrixCOO(I,J,V)`.")
else
	let I = [1, 4, 3, 4, 5]; J = [4, 7, 18, 6, 9] ; V = Float64[1, 2, -5, 4, 3]; S = SparseMatrixCOO(I,J,V)
		if !(typeof(S) <: SparseMatrixCOO)
			keep_working(md"constructor method `SparseMatrixCOO(I,J,V,m,n)` does return object of type `SparseMatrixCOO`")
		else
			correct()
		end
	end
end

# ╔═╡ 1425f61f-2bb8-4f7f-a6a9-133ad7b1101a
if !@isdefined(SparseMatrixCOO)
	not_defined(:SparseMatrixCOO)
elseif !hasmethod(Base.size, Tuple{SparseMatrixCOO})
	still_missing(md"There is still no method `Base.size(::SparseMatrixCOO)`.")
elseif !(typeof(size(S)) <: Tuple)
	keep_working(md"Type error `size` is expected to return a tuple.")
else
	let I = [1, 4, 3, 4, 5]; J = [4, 7, 18, 6, 9] ; V = Float64[1, 2, -5, 4, 3]; S = SparseMatrixCOO(I,J,V,6,20)
		a4
		if size(S) != (6,20)
			keep_working(md"`size(S)` is expected to return (6,20).")
		else
			correct()
		end
	end
end

# ╔═╡ 8ea880f2-b4f2-4f62-a7c1-e5c8b3ae7b5d
if !@isdefined(SparseMatrixCOO)
	not_defined(:SparseMatrixCOO)
else
	try v = getindex(S,1,1)
		
		let I = [1, 4, 3, 3, 4, 5]; J = [4, 7, 7, 10, 6, 9] ; V = Float64[1, 2, 5, -5, 4, 3]; S = SparseMatrixCOO(I,J,V,5,10); Sdense = Float64[0  0  0  1  0  0  0  0  0   0
0  0  0  0  0  0  0  0  0   0
0  0  0  0  0  0  5  0  0  -5
0  0  0  0  0  4  2  0  0   0
0  0  0  0  0  0  0  0  3   0]
			a5
			# test if bounds are checked
			try S[6,5]; S[5,11]
				keep_working(md"trying to access sparse matrix out of bounds should `throw` a `BoundsError`")
			catch
				if S != Sdense
					keep_working(md"`S` is not equal `Sdense` = $Sdense. ")
				else
					correct()
				end
			end
		end
	catch
		still_missing(md"There is still no method `getindex` for `::SparseMatrixCOO`.")
	end
end

# ╔═╡ 184f492a-ec24-471f-879e-04643317ea22
if which(LinearAlgebra.mul!, Tuple{Vector,SparseMatrixCOO,Vector}) == which(LinearAlgebra.mul!, Tuple{Vector,AbstractSparseMatrix,Vector})
	a6
	keep_working(md"No specialized method `LinearAlgebra.mul!` available for input types (`Vector`, `AbstractSparseMatrix` , `Vector`)")
else
	correct(md"New method successfully defined. Check out if it does, what it should!")
end

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
BenchmarkTools = "6e4b80f9-dd63-53aa-95a3-0cdb28fa8baf"
LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
Profile = "9abbd945-dff8-562f-b5e8-e1ebf5ef1b79"
ProfileSVG = "132c30aa-f267-4189-9183-c8a63c7e05e6"
SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[compat]
BenchmarkTools = "~1.3.1"
PlutoUI = "~0.7.37"
ProfileSVG = "~0.2.1"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.7.2"
manifest_format = "2.0"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "8eaf9f1b4921132a4cff3f36a1d9ba923b14a481"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.4"

[[deps.AbstractTrees]]
git-tree-sha1 = "03e0550477d86222521d254b741d470ba17ea0b5"
uuid = "1520ce14-60c1-5f80-bbc7-55ef81b5835c"
version = "0.3.4"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.BenchmarkTools]]
deps = ["JSON", "Logging", "Printf", "Profile", "Statistics", "UUIDs"]
git-tree-sha1 = "4c10eee4af024676200bc7752e536f858c6b8f93"
uuid = "6e4b80f9-dd63-53aa-95a3-0cdb28fa8baf"
version = "1.3.1"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "024fe24d83e4a5bf5fc80501a314ce0d1aa35597"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.0"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "417b0ed7b8b838aa6ca0a87aadf1bb9eb111ce40"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.8"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[deps.FileIO]]
deps = ["Pkg", "Requires", "UUIDs"]
git-tree-sha1 = "80ced645013a5dbdc52cf70329399c35ce007fae"
uuid = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
version = "1.13.0"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.FlameGraphs]]
deps = ["AbstractTrees", "Colors", "FileIO", "FixedPointNumbers", "IndirectArrays", "LeftChildRightSiblingTrees", "Profile"]
git-tree-sha1 = "d9eee53657f6a13ee51120337f98684c9c702264"
uuid = "08572546-2f56-4bcf-ba4e-bab62c3a3f89"
version = "0.2.10"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[deps.HypertextLiteral]]
git-tree-sha1 = "2b078b5a615c6c0396c77810d92ee8c6f470d238"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.3"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "f7be53659ab06ddc986428d3a9dcc95f6fa6705a"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.2"

[[deps.IndirectArrays]]
git-tree-sha1 = "012e604e1c7458645cb8b436f8fba789a51b257f"
uuid = "9b13fd28-a010-5f03-acff-a1bbcff69959"
version = "1.0.0"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "3c837543ddb02250ef42f4738347454f95079d4e"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.3"

[[deps.LeftChildRightSiblingTrees]]
deps = ["AbstractTrees"]
git-tree-sha1 = "b864cb409e8e445688bc478ef87c0afe4f6d1f8d"
uuid = "1d6d02ad-be62-4b6b-8a6d-2f90e265016e"
version = "0.1.3"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"

[[deps.Parsers]]
deps = ["Dates"]
git-tree-sha1 = "85b5da0fa43588c75bb1ff986493443f821c70b7"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.2.3"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "bf0a1121af131d9974241ba53f601211e9303a9e"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.37"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.Profile]]
deps = ["Printf"]
uuid = "9abbd945-dff8-562f-b5e8-e1ebf5ef1b79"

[[deps.ProfileSVG]]
deps = ["Colors", "FlameGraphs", "Profile", "UUIDs"]
git-tree-sha1 = "e4df82a5dadc26736f106f8d7fc97c42cc6c91ae"
uuid = "132c30aa-f267-4189-9183-c8a63c7e05e6"
version = "0.2.1"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
"""

# ╔═╡ Cell order:
# ╟─7081e4e8-66f1-11eb-3670-fb58d677f045
# ╠═876b3aa1-ca0c-44b7-9072-954d0539c8df
# ╟─8e2679c8-f455-44b8-9163-90f6c494e542
# ╠═516919ff-f9a2-4454-85a4-1f5d837fce9d
# ╟─02a4ce54-54e6-493d-88b6-a299903dcb9f
# ╠═2258971e-4b08-42ba-aa5c-76cf45a37720
# ╟─76df0574-c6fa-4a99-af80-190c4044844d
# ╟─84ae0337-6b74-435e-9772-6d1971f43421
# ╟─e8ab1879-64be-49f6-bee1-f7c026da97a8
# ╠═c867f9c3-3af7-447c-898d-5a676d414ed4
# ╠═2ba136f9-248e-4711-b936-0d10c2cabeaf
# ╟─f9ed0daa-8f51-4c85-adf0-88f304500778
# ╠═ddcb466b-4268-4c35-a99a-7e2ddc94f1f4
# ╟─0585afe2-110a-481a-bb5c-3d89c2bd4d23
# ╠═4f5b3fe8-7cc3-43e1-97af-da00974179b1
# ╟─a05c7147-2ebe-4806-89db-fe05bf1b29bb
# ╟─bfaa92d5-189d-4944-a3b5-0212af61d7f4
# ╠═23faf295-e5c7-45e8-9d9b-ddff6d3e046a
# ╟─cac50dfa-b7d1-406e-bf86-b6a6b3083080
# ╟─9c544085-f923-4356-9fc3-fc7031e83e45
# ╠═70f1240f-8780-49ed-aa54-e185a53b0e39
# ╟─40f4778b-ff73-48bd-802f-8e26a888fc26
# ╠═7e235378-79f7-4dda-ac31-050cd16b0075
# ╟─1425f61f-2bb8-4f7f-a6a9-133ad7b1101a
# ╟─9e206357-80ac-4796-bce5-eaa22693a0ec
# ╠═4ef05880-26e1-44df-9a8a-d729b6b4cb95
# ╟─9c227b7a-d27b-432a-9017-37714cef778b
# ╠═5c253d6b-86e2-42ec-b0b0-67827bc07034
# ╟─8ea880f2-b4f2-4f62-a7c1-e5c8b3ae7b5d
# ╟─0a6cd496-b6d5-4a96-8685-c48a86f6908e
# ╠═1a7e599f-a26a-4378-92ac-a486d06b488f
# ╟─bf52dddb-e981-41f8-9eb1-43bf2da21f4d
# ╠═f33f5ab9-e309-4b50-9ac1-79e66b6f5c46
# ╟─e5d7b732-452e-4da0-b2ef-ad47b8577f2c
# ╠═5034c65d-e416-4bc1-8ae0-e40c6633ec4d
# ╟─fe334f27-b943-4ab4-bc6c-1bcbb97480c0
# ╠═47a38d9d-0359-4025-a221-9f38562eff53
# ╟─ed560ece-1f58-47d4-9ff9-f4d32761a2d2
# ╠═6ec72195-54ac-4871-9988-c08685a00713
# ╟─184f492a-ec24-471f-879e-04643317ea22
# ╟─104224ee-1699-47c6-afb9-5e9cc3386bcd
# ╠═84efc13b-c8f0-43fd-a421-c5247b7fbdf7
# ╟─a2c25f3e-1bbc-4d77-9107-296a14293c59
# ╠═39146a45-4e62-4bf7-b3a7-e4e4807360b9
# ╟─b7de1eb0-66f1-11eb-2729-d7dcd1668d97
# ╟─480cd239-ccb4-495c-a805-78eb68321327
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
