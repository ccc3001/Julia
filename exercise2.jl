### A Pluto.jl notebook ###
# v0.19.0

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ a6448cac-67fd-11eb-00f3-43f56fe0178e
begin
	using BenchmarkTools, FFTW, Images, LinearAlgebra, PlutoUI
	
	PlutoUI.TableOfContents() #print table of contents
end

# ╔═╡ 08bc5e4a-6801-11eb-0b97-b127b6fd83b3
md"""
# Scientific Programming - Arrays

[Institute for Biomedical Imaging](https://www.tuhh.de/ibi/home.html), Hamburg University of Technology

* 👨‍🏫 Prof. Dr.-Ing. Tobias Knopp
* 👨‍🏫 Dr. rer. nat. Martin Möddel

The due date of this exercise is 03.05 at 0:00. Please submit your solution to [Stud.IP](https://e-learning.tuhh.de/studip/dispatch.php/course/files/index/031251f16bdb9858457bfa19c5b9fe0d?cid=2da322cacb476a5b1341a14ae4d853e2). For troubleshooting and general tips, you can join the exercise at 29.04.
"""

# ╔═╡ 72204898-6a26-11eb-063c-15de4895974c
md"""
Let us set up a new temporary package environment.
"""

# ╔═╡ 65a3de4c-6aba-11eb-3edd-b78b1fe70276
md"""
## Array Manipulation

Julia, like most technical computing languages, provides a first-class array implementation, where an array is a sequence of objects of the same type stored in a multi-dimensional grid.

As an example let us consider the output of the your webcam (or a fallback image), which we bind to the variable `raw_camera_dict`.
"""

# ╔═╡ 2d05404c-6abc-11eb-12a9-b1b93645aa6c
md"""
As the name suggests the variable `raw_camera_dict` is a [dictionary](https://docs.julialang.org/en/v1/base/collections/#Dictionaries). An unordered container, which stores key-value pairs.

At this point we are not going into more detail. The important part is that this container hold the actual raw camera data
"""

# ╔═╡ b258e294-6abc-11eb-1a43-730c7cd2f14f
md"""
as well as the width and height of the image this data represents. 
"""

# ╔═╡ 4cd1e508-6ac1-11eb-2fc3-b95d83bb49cf
md"""
### Task 1

The raw image data is a very long byte array with element type `UInt8`. We can see this by calling the `size` function on `raw_camera_data`, which returns a tuple containing the dimensions of `raw_camera_data`.
"""

# ╔═╡ 0e467baa-6abf-11eb-2421-978a24cc1f4b
md"""
We get a tuple with a single entry, i.e. a one-dimensional array.

The encoding of the raw byte stream is
* every 4 bytes are a single pixel
* every pixel has 4 values (in that order): Red, Green, Blue, Alpha

🎓 Calculate the number of pixels from the `length` of `raw_camera_data` and assign your solution to the variable `N`.
"""

# ╔═╡ 01ecb23c-6ac1-11eb-216e-cf71d79767aa
md"""
### Task 2

Next, we aim split up the individual channels of our array. This can be achieved by indexing with any of the [supported index types](https://docs.julialang.org/en/v1/manual/arrays/#man-supported-index-types). In our case ranges are probably our best choice.

🎓 Use the encoding information to construct range objects `Ir`, `Ig`, and `Ib`, which allow us to extract the red, green, and blue color channel, respectively.
"""

# ╔═╡ 01d671e6-6ad5-11eb-3175-e7ba17bd5363
md"""
### Task 3
Next, we can actually perform the splitting by indexing with the range object
"""

# ╔═╡ 45613d44-6ad5-11eb-1714-0de397bed28d
md"""
or the equivalent function syntax
"""

# ╔═╡ a41e0aec-6ad5-11eb-3dae-d5851e3e54d5
md"""
In either case data is copied from its original location `raw_camera_data` into a new array bound to `raw_red_camera_data` respectively `raw_green_camera_data`.

Sometimes, we would like to avoid copying. This can be done by creating a `SubArray`, that performs indexing by sharing memory with the original array rather than by copying it.

🎓 Such a `SubArray` can be created using the `view` function. Read its documentation and create a view on the blue channel contained within `raw_camera_data`. Bind this view to the variable `raw_blue_camera_data`.
"""

# ╔═╡ 67afb97a-6ad0-11eb-225b-5503c368532d
md"""
### Task 4

So far we have left the data stream 1D. However, this data actually represents an image, so it is time to bring the data back into shape. In Julia this can be achieved by using the `reshape` function, which does not copy data and is therefore almost free to call.

🎓 Use the width `w` and height `h` to `reshape` the 1D array `raw_red_camera_data` into a `w`$\times$`h` 2D array (matrix). Assign your result to the variable `red_camera_data`.
"""

# ╔═╡ 6e5395e6-6ad8-11eb-0245-47879f360f86
md"""
### Task 5

Now that we have the data in the correct shape we may try to visualize it by broadcasting it with the `Gray` function, which is available with the `Images` package.
"""

# ╔═╡ 168eb0e6-6ada-11eb-3a9a-cb27f579af5b
md"""
However, a direct broadcast fails, since `Gray` is expecting a numeric type representing values between 0 and 1.

In contrast the element type of our Array is `UInt8`, which represents values in between 
"""

# ╔═╡ 346835f0-6ae0-11eb-3f37-1faff4958d69
Int(typemin(UInt8))

# ╔═╡ 95230726-6ae0-11eb-14bd-13ce33160c0f
md"""
and
"""

# ╔═╡ 1b8af5fe-6ae0-11eb-24ca-fda3c7bccc8d
Int(typemax(UInt8))

# ╔═╡ b3d552a0-6ae0-11eb-2df4-35cbd169d7ff
md"""
We can solve this issue by normalizing these values as pointed out in the error message.

🎓 Use either of the methods pointed out in the error message above to normalize the values, broadcast the normalized values using the `Gray` function and assign the result to the variable `red_image_data`.
"""

# ╔═╡ 32f22538-6af3-11eb-1fd9-43d86761061e
md"""
### Task 6

What we observe is that the image is flipped to its side. This occurs, since multidimensional arrays in Julia are stored in column-major order, whereas the `camera_input` function is actually a small piece of java code, which has a row-major layout.

🎓 Transpose `red_image_data` in order achieve the correct interpretation of the data and assign the result to the variable `red_image_data_transpose`.
"""

# ╔═╡ 0720d5da-6b07-11eb-0d4e-f907bfc19a76
md"""
### Task 7

Now let us put everything together.

🎓 Write a function `process_raw_camera_data(raw_camera_data, w, h)` that processes `raw_camera_data` into a `Gray` image. To this end, combine all color channels into a single one. This can be done by weighting the channels red, green, and blue by `N0f8(0.212)`, `N0f8(0.714)`, `N0f8(0.074)`, respectively and summing up the result.
"""

# ╔═╡ b576cebe-6b07-11eb-208f-5f94d361b322
function process_raw_camera_data(raw_camera_data, w, h)
	N::Int = length(raw_camera_data)/4
	Ir = range(1, step=4, length=N)
	Ig = range(2, step=4, length=N)
	Ib = range(3, step=4, length=N)
	red_image_data = reinterpret(N0f8, reshape(raw_camera_data[Ir] , w , h)) 
	green_image_data = reinterpret(N0f8, reshape(raw_camera_data[Ig] , w , h))
	blue_image_data = reinterpret(N0f8, reshape(raw_camera_data[Ib] , w , h))
	return transpose(Gray.(N0f8(0.212)*red_image_data+N0f8(0.714)*green_image_data+N0f8(0.074)*blue_image_data))
end

# ╔═╡ 301d6c16-6b0f-11eb-3b8b-0fa0812605bc
md"""
### Task 8

As a last exercise on array manipulation let us now convert the `raw_camera_data` into a colored image.

🎓 Write a function `process_raw_camera_data_color(raw_camera_data, w, h)` that processes `raw_camera_data` into a RGBA image. Reinterpret the raw data stream as `RGBA{N0f8}` and bring it into the correct shape.
"""

# ╔═╡ 64bb481c-6b0f-11eb-1967-1fc3c22200f0
function process_raw_camera_data_color(raw_camera_data, w, h)
	N::Int = length(raw_camera_data)/4
	Ir = range(1, step=4, length=N)
	Ig = range(2, step=4, length=N)
	Ib = range(3, step=4, length=N)
	Ia = range(4, step=4, length=N)
	red_image_data = reinterpret(N0f8, reshape(raw_camera_data[Ir] , w , h)) 
	green_image_data = reinterpret(N0f8, reshape(raw_camera_data[Ig] , w , h))
	blue_image_data = reinterpret(N0f8, reshape(raw_camera_data[Ib] , w , h))
	alpha_image_data = reinterpret(N0f8, reshape(raw_camera_data[Ia] , w , h))
	return transpose(RGBA.(red_image_data,green_image_data,blue_image_data,alpha_image_data))
end

# ╔═╡ 67508718-6b0f-11eb-336d-5b0596efcbfd
md"""
## JPEG compression

The JPEG standard specifies the codec, which defines how an image is compressed into a stream of bytes and decompressed back into an image. At its core it operates on small image blocks, which make it a good example to practice the skills we just obtained. To this end, let us dissect a simplified version of the JPEG compression algorithm considering the following $16\times 16$ gray scale image
"""

# ╔═╡ 71164f4e-6b19-11eb-0a24-61af7e816b64
image = Gray.(load("compression.png"))

# ╔═╡ 7e8ae448-6d3d-11eb-308d-b3ae2dff8759
md"""
### Task 9

The actual compression algorithm does work on $8\times 8$-blocks. So in order to illustrate JPEG encoding and decoding, we are going to consider to the upper left part of the image only.

🎓 Create a `view` on the upper left $8\times 8$-block of the image and assign it to the variable `imagetl`.
"""

# ╔═╡ b6fcc2aa-6b18-11eb-26b8-87976eed1b4c
imagetl = view(image , 1:8 , 1:8)

# ╔═╡ 6777e362-6d4e-11eb-1522-edc03b2a743f
md"""
### Task 10

As we have seen before, pixel values in our gray scale image lie in $[0,1]$. The first step of encoding is to bring these back into the unsigned integer range $[0,255]$.

🎓 `reinterpret` the pixel values of `imagetl` as 8-bit unsigned integers and assign the resulting array to `imagetlU8`.
"""

# ╔═╡ 1ca07ab6-6b19-11eb-2667-d751db42b5b9
imagetlU8 = reinterpret(UInt8,imagetl)

# ╔═╡ 9e624ae0-6b7b-11eb-1f76-8bc9423aec69
md"""
### Task 11

The next step in the encoding is to shift from a positive range $[0,255]$ to one centered on zero $[-128,127]$.

🎓 Subtract `128` from each element in `imagetlU8` and assign the result to `imagetlU8valueshift`.
"""

# ╔═╡ feb6a160-6b18-11eb-3104-01a6b3df8568
imagetlU8valueshift = imagetlU8 .-128

# ╔═╡ aa7e7286-6b7b-11eb-0ca2-8b9b87032500
md"""
### Task 12

Next, we perform a basis transformation of the sub-image into frequency domain by using a two-dimensional type-II discrete cosine transform (DCT).

In Julia this transform is provided by the `dct` method within the `FFTW` package.
"""

# ╔═╡ 1e16a2b6-6b1f-11eb-16ea-afb26da7b615
D = dct(imagetlU8valueshift)

# ╔═╡ b98e9d64-6b7b-11eb-0434-093f2635b1c9
md"""
The actual compression is done after the basis transform. Let $\mathbf D \in \mathbb R^{8\times 8}$ be the DCT transformed sub-image and $\mathbf Q \in \mathbb R^{8\times 8}$ be a quantization matrix. Then the compressed DCT coefficients are given by $\mathbf B \in \mathbb R^{8\times 8}$

$\mathbf B_{i,j} = \mathrm{round} \left( \frac{\mathbf D_{i,j}}{\mathbf Q_{i,j}} \right),$

where

$\mathbf Q = \begin{bmatrix}
 16 & 11 & 10 & 16 & 24 & 40 & 51 & 61 \\
 12 & 12 & 14 & 19 & 26 & 58 & 60 & 55 \\
 14 & 13 & 16 & 24 & 40 & 57 & 69 & 56 \\
 14 & 17 & 22 & 29 & 51 & 87 & 80 & 62 \\
 18 & 22 & 37 & 56 & 68 & 109 & 103 & 77 \\
 24 & 35 & 55 & 64 & 81 & 104 & 113 & 92 \\
 49 & 64 & 78 & 87 & 103 & 121 & 120 & 101 \\
 72 & 92 & 95 & 98 & 112 & 100 & 103 & 99
\end{bmatrix}$

and the rounding is done to the nearest integer value.

🎓 Calculate $\mathbf B$, store the result in an `Int8` `Array` and assign it the variable `B`.
"""

# ╔═╡ 70fe0c24-6b1f-11eb-1146-7f49e53cb83a
Q = [[16,12,14,14,18,24,49,72]  [11,12,13,17,22,35,64,92] [10,14,16,22,37,55,78,95] [16,19,24,29,56,64,87,98] [24,26,40,51,68,81,103,112] [40,58,57,87,109,104,121,100] [51,60,69,80,103,113,120,103] [61,55,56,62,77,92,101,99]]

# ╔═╡ 25e9a0cc-6b23-11eb-045f-836b69c7cdf6
B =round.(D./Q) 

# ╔═╡ 08cc5ac8-6d71-11eb-2035-ff52fa753c56
md"""
We notice a lot of small values, which occur repeatedly, e.g. 0 (20 times), -1 (10 times), 1 (7 times). These can be compressed lossless, which reduces the size required to store $\mathbf B$, which is now the actual compression step.
"""

# ╔═╡ e638ea94-6d70-11eb-04d4-cd0c95304409
md"""
### Task 13

Next, we can decode the compressed image. To this end we need to
* approximate $\mathbf D_{i,j} \approx \mathbf B_{i,j}\mathbf Q_{i,j}$,
* calculate the inverse DCT `idct` of $\mathbf D$,
* add 128, 
* clip the output values so as to keep them within the range of $[0 , 255]$ of the original bit depth,
* `round` the values to the nearest `UInt8` value.
* reinterpret `UInt8` `Array` as `N0f8` and broadcast the result using the `Gray` function.

🎓 Write a `decode(B)` method, which outputs the decoded gray image given the quantized input matrix `B`.
"""

# ╔═╡ ec0c3920-6d73-11eb-3657-3551fb5efd48
function decode(B)
	D=round.(B.*Q)
	inverseDCT = idct(D)
	inverseDCT = inverseDCT.+ 128
	for i=1:size(inverseDCT,1) , j=1:size(inverseDCT,1)
		if inverseDCT[i,j] > 255 
			inverseDCT[i,j] = 255
		end
		if inverseDCT[i,j] < 0
			inverseDCT[i,j] = 0
		end 
	end 
	inverseDCT= round.(UInt8, inverseDCT)
	inverseDCTN0f8 = reinterpret(N0f8 , inverseDCT)

	return Gray.(inverseDCTN0f8)
	
end

# ╔═╡ 02e51660-6d74-11eb-3505-53c2b5cdd527
decode(B)

# ╔═╡ 26ffaf0a-6d75-11eb-39fa-6f6014ca06b8
md"""
### Task 14

Put everything together

🎓 Write another method `encode(imageblock)`, which outputs the JPEG encoded matrix $\mathbf B$ given an $8\times 8$ `imageblock` as input. 
"""

# ╔═╡ 57f78ea6-6d76-11eb-0ce9-1da763bb82a3
function encode(imageblock)
	imagetlU8 = reinterpret(UInt8,imageblock)
	imagetlU8valueshift = imagetlU8 .-128
	D = dct(imagetlU8valueshift)
	B =round.(D./Q) 
	return B
end

# ╔═╡ 9e4cb2b8-6d77-11eb-31df-ffe2db5ec780
md"""
🎓 Split the `image` into 4 $8\times 8$ blocks and run each trough the JPEG encoding and decoding. Concatenate all blocks into a final image `compressionartifacts`.
"""

# ╔═╡ 07399581-b7e3-4606-af35-02311bc424f1
begin
	m1=view(image , 1:8 , 1:8)
	m2=view(image , 1:8 , 9:16)
	m3=view(image , 9:16 , 1:8)
	m4=view(image , 9:16, 9:16)
	m1=decode(encode(m1))
	m2=decode(encode(m2))
	m3=decode(encode(m3))
	m4=decode(encode(m4))
	image1=cat(cat(m1,m2,dims=(2,2)),cat(m3,m4,dims=(2,2)),dims=(1,1))
end 

# ╔═╡ 2f106cfa-71eb-11eb-2beb-a58e9bcd44c3
compressionartifacts = image1

# ╔═╡ 27f457c8-6c3d-11eb-0394-41799ec3e62a
md"""
## Linear Algebra

In addition to and as part of its support for multi-dimensional arrays, Julia provides native implementations of many common and useful linear algebra operations.

Here, we are going to explore some of Julia's linear algebra capabilities. To this end let us consider a consistent linear system of equations

$\mathbf A \mathbf x = \mathbf b,$

where $\mathbf A\in \mathbb R^{N,N}$, $\mathbf x, \mathbf b \in \mathbb R^N$, $N\in \mathbb N_+$.
"""

# ╔═╡ 359bf110-6c3d-11eb-0653-c922639fadb9
begin
	A = randn(100,100)
	x = randn(100)
	b = A*x
end;

# ╔═╡ 5949e6d6-6c41-11eb-293d-b1b3d380d82a
md"""
### Task 15

Gaußian elimination reduces a system to upper triangular form which is then easy to solve.

🎓 Implement a function `gaußian_elimination(A)`, which transforms `A` into an upper triangular matrix.
"""

# ╔═╡ 3c6c5958-6c3d-11eb-0145-ad6810fd1feb
function gaußian_elimination(A)
	row = size(A,1)
	for i in 1:row-1
		pivot = A[i,i]
		for j in i+1:row
			base = A[j,i]/pivot
			A[j,:]=A[j,:]- (base.*A[i,:])
		end
	end
	return A   
end

# ╔═╡ b5daed82-6c46-11eb-02f5-bd16dcaea96b
md"""
### Task 16

Using Gaußian elimination we can reduce the augmented matrix $\pmatrix{\mathbf A & \mathbf b}$
"""

# ╔═╡ 11bfd09d-3569-4d94-af7c-db37f43f39e0
Abreduced = gaußian_elimination(hcat(A,b))

# ╔═╡ cbe6f94e-6c4c-11eb-3374-7d407f486762
md"""
We can find a solution for the linear system $\mathbf A \mathbf x = \mathbf b$ by backwards substitution.

🎓 Implement a function `backward_substitution(Abreduced)` that returns the solution of a linear system with reduced augmented matrix `Abreduced`.
"""

# ╔═╡ 497249b4-6c3d-11eb-252b-f755ccaac847
function backward_substitution(Abreduced)
	n = size(Abreduced,1)
	x = zeros(n)
	b = Abreduced[:,n+1]
	A = Abreduced[:, 1:n]
	x[n]=b[n]/A[n,n]
	for i in (n-1):-1:1
		x[i] = (b[i] - A[i,i+1:n]' * x[i+1:n]) /A[i,i]
	end
	return x
end

# ╔═╡ 9f49f4c6-6c52-11eb-1def-ed52905ce363
md"""
If implemented correctly, we are now able to obtain the solution of the linear system of equations.
"""

# ╔═╡ 5de3fb4a-6c3d-11eb-1195-edb411d2ce1d
xsol = backward_substitution(Abreduced)

# ╔═╡ b3ecbcda-6c53-11eb-2b18-971bd185d061
md"""
Let us quickly compare with the true solution `x`.
"""

# ╔═╡ 68460e8f-a60d-4a4e-91f9-978638787966
isapprox(xsol,x)

# ╔═╡ a2b0e77e-6c3d-11eb-3dd0-a7ee2eebb0d3
md"""
### Task 17

However, Gaußian elimination is usually not used to solve linear systems of equation, since there are equally fast more efficient methods available.

For systems with a square matrix $\mathbf A$, one usually factors $\mathbf A$ into a product of a lower triangular matrix $\mathbf L$ and an upper triangular matrix $\mathbf U$

$\mathbf A = \mathbf L \mathbf U$

The linear system $\mathbf A \mathbf x = \mathbf b$ can then be solved by 
1.  $\mathbf L \mathbf y = \mathbf b$ (forward substitution),
2.  $\mathbf U \mathbf x = \mathbf y$ (backward substitution).

🎓 The LU factorization of a matrix $\mathbf A$ can be calculated using a [modified form of Gaußian elimination ](https://en.wikipedia.org/wiki/LU_decomposition#Using_Gaussian_elimination). Implement `gaußian_lu(A)`, which returns $L$ and $U$.
"""

# ╔═╡ b4aca7c6-6c3d-11eb-1a2c-9b6ec6f4040b
function gaußian_lu(A)
	A = convert.(Float64,A)
	L = zeros(eltype(A),size(A))
	U=zeros(eltype(A),size(A))
	n= size(A,1)
	for i in 1:(n-1)
		L[i,i] = 1
		L[i+1:n,i]=A[i+1:n,1]/A[i,i]
	end
	L[n,n]=1
	U = gaußian_elimination(A)
	return L, U
end

# ╔═╡ c8cf01c0-6c5b-11eb-0c81-bb4826223084
md"""
### Task 18

Now let us put everything together to create our own solver. However, this time we are going to make use of Julia's linear algebra routines for forward and backward substitution. These are a bit hidden inside the matrix division method `\`.

If we plug in a square `Matrix` `A` and right hand side `b`, then `\` performs exactly what we aim for. A LU-decomposition followed by forward and backwards substitution.
"""

# ╔═╡ 25577f96-6c69-11eb-1b97-775ab27898ee
\(A,b)

# ╔═╡ 8173a232-6c69-11eb-204b-498a9a1c9bda
md"""
If on the other hand  `A` is `UpperTriangular` or `LowerTriangular` or `Diagonal`, no factorization of `A` is done and the system is solved with either forward or backward substitution.

🎓 Implement a `solve(A,b)`, which returns the solution of the linear system of the equations above. Calculate the LU-factorization of `A` using `gaußian_lu` and use these factors to solve the linear system. Make use of `\` for two substitution steps mentioned in the last task.
"""

# ╔═╡ 7f7836a4-6c67-11eb-0668-8f3f62306d04
function solve(A,b)
	A=hcat(A,b)
	F =lu(A)
	A=F.U
	@show 
	
		#@show Abreduced
	row = size(A,1)
	#@show row
	col = size(A,2)
	#@show col
	x =	zeros(row)
	for i in 1 : row
		j = row+1-i
		x[j] = A[j,col] / A[j,j]
		
		for k in 1 : (row-i)
			A[k,col] = A[k,col] - x[j] * A[k,j]
		end
	end
	round(x)
	@show x
	return x
end

# ╔═╡ ec78f35a-6c6b-11eb-22dd-8ffc50fb995e
md"""
If everything works as intended we should get a good approximation of `x`
"""

# ╔═╡ 2655dfde-6c6c-11eb-319b-af6253c872e1
isapprox(solve(A,b),x)

# ╔═╡ afe19a78-6c6b-11eb-20f7-09ccb3418b22
md"""
### Remark

There are actually a lot of linear algebra problems, which can be solved using Julia's standard package `LinearAlgebra`. More information on this package can be found [here](https://docs.julialang.org/en/v1/stdlib/LinearAlgebra/).

This package builds upon basic linear algebra subprograms ([OpenBLAS](https://github.com/xianyi/OpenBLAS)), which contains many hand-crafted optimizations for specific processor types. This is also the reason, why it often outperforms self-written algorithms by a lot.

As an example we can compare the minimum run time of the build in LU-decomposition
"""

# ╔═╡ ca76fc44-6c3d-11eb-3d07-f5bf46fc06fa
@benchmark lu($A,$(Val(false)))

# ╔═╡ d6bb848c-6c76-11eb-3e0c-1f4c3eebb465
md"""
with our own implementation
"""

# ╔═╡ c47bf6b4-6c3d-11eb-1e3d-37443c5dc984
# uncomment next line to run your implementation
#@benchmark gaußian_lu($A)

# ╔═╡ 064494fa-6c77-11eb-2901-21777655aa94
md"""
So until we learn how to write well performing code, it is a good idea to try to stick to the linear algebra routines from `LinearAlgebra`.
"""

# ╔═╡ a107b80a-6801-11eb-39c4-6bab244b6c3b
md"""
#### Notebook Helper Functions
"""

# ╔═╡ 415f778e-6b88-11eb-1680-bb8612b363a9
# default image returned by camera
#https://commons.wikimedia.org/wiki/File:John_Vanbrugh.png
default_url="https://upload.wikimedia.org/wikipedia/commons/thumb/2/2a/John_Vanbrugh2.png/361px-John_Vanbrugh2.png";

# ╔═╡ 720eb566-67fa-11eb-2ca7-ed77be7d4993
function camera_input(;max_size=500, default_url=default_url)
"""
<span class="pl-image waiting-for-permission">
<style>
	
	.pl-image.popped-out {
		position: fixed;
		top: 0;
		right: 0;
		z-index: 5;
	}
	.pl-image #video-container {
		width: 250px;
	}
	.pl-image video {
		border-radius: 1rem 1rem 0 0;
	}
	.pl-image.waiting-for-permission #video-container {
		display: none;
	}
	.pl-image #prompt {
		display: none;
	}
	.pl-image.waiting-for-permission #prompt {
		width: 250px;
		height: 200px;
		display: grid;
		place-items: center;
		font-family: monospace;
		font-weight: bold;
		text-decoration: underline;
		cursor: pointer;
		border: 5px dashed rgba(0,0,0,.5);
	}
	.pl-image video {
		display: block;
	}
	.pl-image .bar {
		width: inherit;
		display: flex;
		z-index: 6;
	}
	.pl-image .bar#top {
		position: absolute;
		flex-direction: column;
	}
	
	.pl-image .bar#bottom {
		background: black;
		border-radius: 0 0 1rem 1rem;
	}
	.pl-image .bar button {
		flex: 0 0 auto;
		background: rgba(255,255,255,.8);
		border: none;
		width: 2rem;
		height: 2rem;
		border-radius: 100%;
		cursor: pointer;
		z-index: 7;
	}
	.pl-image .bar button#shutter {
		width: 3rem;
		height: 3rem;
		margin: -1.5rem auto .2rem auto;
	}
	.pl-image video.takepicture {
		animation: pictureflash 200ms linear;
	}
	@keyframes pictureflash {
		0% {
			filter: grayscale(1.0) contrast(2.0);
		}
		100% {
			filter: grayscale(0.0) contrast(1.0);
		}
	}
</style>
	<div id="video-container">
		<div id="top" class="bar">
			<button id="stop" title="Stop video">✖</button>
			<button id="pop-out" title="Pop out/pop in">⏏</button>
		</div>
		<video playsinline autoplay></video>
		<div id="bottom" class="bar">
		<button id="shutter" title="Click to take a picture">📷</button>
		</div>
	</div>
		
	<div id="prompt">
		<span>
		Enable webcam
		</span>
	</div>
<script>
	// based on https://github.com/fonsp/printi-static (by the same author)
	const span = currentScript.parentElement
	const video = span.querySelector("video")
	const popout = span.querySelector("button#pop-out")
	const stop = span.querySelector("button#stop")
	const shutter = span.querySelector("button#shutter")
	const prompt = span.querySelector(".pl-image #prompt")
	const maxsize = $(max_size)
	const send_source = (source, src_width, src_height) => {
		const scale = Math.min(1.0, maxsize / src_width, maxsize / src_height)
		const width = Math.floor(src_width * scale)
		const height = Math.floor(src_height * scale)
		const canvas = html`<canvas width=\${width} height=\${height}>`
		const ctx = canvas.getContext("2d")
		ctx.drawImage(source, 0, 0, width, height)
		span.value = {
			width: width,
			height: height,
			data: ctx.getImageData(0, 0, width, height).data,
		}
		span.dispatchEvent(new CustomEvent("input"))
	}
	
	const clear_camera = () => {
		window.stream.getTracks().forEach(s => s.stop());
		video.srcObject = null;
		span.classList.add("waiting-for-permission");
	}
	prompt.onclick = () => {
		navigator.mediaDevices.getUserMedia({
			audio: false,
			video: {
				facingMode: "environment",
			},
		}).then(function(stream) {
			stream.onend = console.log
			window.stream = stream
			video.srcObject = stream
			window.cameraConnected = true
			video.controls = false
			video.play()
			video.controls = false
			span.classList.remove("waiting-for-permission");
		}).catch(function(error) {
			console.log(error)
		});
	}
	stop.onclick = () => {
		clear_camera()
	}
	popout.onclick = () => {
		span.classList.toggle("popped-out")
	}
	shutter.onclick = () => {
		const cl = video.classList
		cl.remove("takepicture")
		void video.offsetHeight
		cl.add("takepicture")
		video.play()
		video.controls = false
		console.log(video)
		send_source(video, video.videoWidth, video.videoHeight)
	}
	
	
	document.addEventListener("visibilitychange", () => {
		if (document.visibilityState != "visible") {
			clear_camera()
		}
	})
	// Set a default image
	const img = html`<img crossOrigin="anonymous">`
	img.onload = () => {
	console.log("hello")
		send_source(img, img.width, img.height)
	}
	img.src = "$(default_url)"
	console.log(img)
</script>
</span>
""" |> HTML
end;

# ╔═╡ 68d9006e-67fa-11eb-05d7-1933fddfe8ad
@bind raw_camera_dict camera_input()

# ╔═╡ 98b3602c-6abb-11eb-321b-354ca57dce8e
raw_camera_data = raw_camera_dict["data"]

# ╔═╡ 14343566-6ac1-11eb-004f-d577af5d4bcf
size(raw_camera_data)

# ╔═╡ 3cd7e918-6abf-11eb-34df-43d0375c13d2
N::Int = length(raw_camera_data)/4

# ╔═╡ 04ef21b2-6ac2-11eb-0c0a-63e26ace9bd5
Ir = range(1, step=4, length=N)

# ╔═╡ 72a07900-6ad0-11eb-05e9-93add2a50013
Ig = range(2, step=4, length=N)

# ╔═╡ 7669023c-6ad0-11eb-093f-ffd78d40f882
Ib = range(3, step=4, length=N)

# ╔═╡ b4ead108-6ad4-11eb-16dd-71ae476b2989
raw_red_camera_data = raw_camera_data[Ir]

# ╔═╡ c65b535c-6ad4-11eb-24c2-f13fa59bedd4
raw_green_camera_data = getindex(raw_camera_data,Ig)

# ╔═╡ dc157882-6ad4-11eb-1a86-157a2851833a
raw_blue_camera_data = view(raw_camera_data , Ib) 

# ╔═╡ 83650edc-6abb-11eb-3a15-d1ec709d6528
w = raw_camera_dict["width"]

# ╔═╡ dbf71676-6abb-11eb-3566-d36184515e11
h = raw_camera_dict["height"]

# ╔═╡ ae9345da-6ad2-11eb-098d-17862bfb276d
red_camera_data = reshape(raw_red_camera_data , w , h)

# ╔═╡ 863d3ad8-6ad9-11eb-2f10-47d534c5183c
Gray.(red_camera_data)

# ╔═╡ c617cd06-6ad1-11eb-0bb4-71f538340041
red_image_data = Gray.(reinterpret( N0f8, red_camera_data))

# ╔═╡ d67a95e8-e927-48ab-a0dc-986ff966ac39
red_image_data_transpose = transpose(red_image_data)

# ╔═╡ 2c9ebede-6b08-11eb-03e0-9733a7486a00
process_raw_camera_data(raw_camera_data, w, h)

# ╔═╡ cd89a384-6b0f-11eb-0fba-2be93043f371
process_raw_camera_data_color(raw_camera_data, w, h)

# ╔═╡ affc8ac2-6801-11eb-2f0b-adb643485e0c
begin
	hint(text) = Markdown.MD(Markdown.Admonition("hint", "Hint", [text]))
	not_defined(variable_name) = Markdown.MD(Markdown.Admonition("danger", "Oh, oh! 😱", [md"Variable **$(Markdown.Code(string(variable_name)))** is not defined. You should probably do something about this."]))
	still_missing(text=md"Replace `missing` with your solution.") = Markdown.MD(Markdown.Admonition("warning", "Let's go!", [text]))
	keep_working(text=md"The answer is not quite right.") = Markdown.MD(Markdown.Admonition("danger", "Keep working on it!", [text]));
	yays = [md"Great! 🥳", md"Correct! 👏", md"Tada! 🎉"]
	correct(text=md"$(rand(yays)) Let's move on to the next task.") = Markdown.MD(Markdown.Admonition("correct", "Got it!", [text]))
end;

# ╔═╡ 23edd3a8-6ac0-11eb-37d7-f3d6fe49df0c
if !@isdefined(N)
	not_defined(:N)
elseif ismissing(N)
	still_missing()
elseif N > w*h
	keep_working(md"This number is too large.")
elseif N < w*h
	keep_working(md"This number is too small.")
else
	correct()
end

# ╔═╡ 44fb2478-6ad0-11eb-211d-15a83ca5b52c
if !@isdefined(Ir)
	not_defined(:Ir)
elseif !@isdefined(Ig)
	not_defined(:Ig)
elseif !@isdefined(Ib)
	not_defined(:Ib)
elseif ismissing(Ir) || ismissing(Ig) || ismissing(Ib)
	still_missing()
elseif !(typeof(Ir) <: AbstractRange)
	keep_working(md"`Ir` is no range object.")
elseif !(typeof(Ir) <: AbstractRange)
	keep_working(md"`Ig` is no range object.")
elseif !(typeof(Ir) <: AbstractRange)
	keep_working(md"`Ib` is no range object.")
elseif first(Ir) != 1
	keep_working(md"`Ir` does start with the wrong index.")
elseif first(Ig) != 2
	keep_working(md"`Ig` does start with the wrong index.")
elseif first(Ib) != 3
	keep_working(md"`Ib` does start with the wrong index.")
elseif last(Ir) != length(raw_camera_data)-3
	keep_working(md"`Ir` does stop with the wrong index.")
elseif last(Ig) != length(raw_camera_data)-2
	keep_working(md"`Ig` does stop with the wrong index.")
elseif last(Ib) != length(raw_camera_data)-1
	keep_working(md"`Ib` does stop with the wrong index.")
else
	correct()
end

# ╔═╡ 8e205b98-6ad6-11eb-1fe1-9d8d4efc7490
if !@isdefined(raw_blue_camera_data)
	not_defined(:raw_blue_camera_data)
elseif ismissing(raw_blue_camera_data) 
	still_missing()
elseif !(typeof(raw_blue_camera_data) <: SubArray)
	keep_working(md"`raw_blue_camera_data` is no `SubArray`.")
else
	correct()
end

# ╔═╡ 871a6014-6ad8-11eb-2788-a7071f5f70b7
if !@isdefined(red_camera_data)
	not_defined(:red_camera_data)
elseif ismissing(red_camera_data) 
	still_missing()
elseif ndims(red_camera_data) != 2
	keep_working(md"`red_camera_data` not two-dimensional.")
elseif size(red_camera_data) != (w,h)
	keep_working(md"`red_camera_data` is expected to have size `(w,h)`.")
else
	correct()
end

# ╔═╡ cb3b6c4c-6af0-11eb-3eef-4bfe3aa16af2
if !@isdefined(red_image_data)
	not_defined(:red_image_data)
elseif ismissing(red_image_data) 
	still_missing()
elseif eltype(red_image_data) != Gray{Normed{UInt8,8}}
	keep_working(md"`red_image_data` is expected to have elements of type `Gray{Normed{UInt8,8}}`.")
else
	correct()
end

# ╔═╡ 2abb3cea-6af5-11eb-20aa-671e662f58c5
if !@isdefined(red_image_data_transpose)
	not_defined(:red_image_data_transpose)
elseif ismissing(red_image_data_transpose) 
	still_missing()
elseif size(red_image_data_transpose) != (h,w)
	keep_working(md"`red_image_data_transpose` is expected to have `size` of `(h,w)`.")
else
	correct()
end

# ╔═╡ 536862c4-6b0b-11eb-101c-d134fa76766b
if !@isdefined(process_raw_camera_data)
	not_defined(:process_raw_camera_data)
elseif !hasmethod(process_raw_camera_data, Tuple{Array{UInt8,1},Int,Int})
	keep_working(md"No method `process_raw_camera_data` for input type `Array{UInt8,1}`.")
elseif ismissing(process_raw_camera_data(raw_camera_data, w, h)) 
	still_missing()
elseif size(process_raw_camera_data(rand(UInt8,440), 11, 10)) != (10,11)
	keep_working(md"Size of output array must be `(h,w)`.")
elseif process_raw_camera_data(UInt8[255,0,0,0], 1, 1)[1,1] != Gray(N0f8(0.212))
	keep_working(md"`UInt8[255,0,0,0]` expected to convert to `Gray(N0f8(0.212))`.")
elseif process_raw_camera_data(UInt8[0,255,0,0], 1, 1)[1,1] != Gray(N0f8(0.714))
	keep_working(md"`UInt8[0,255,0,0]` expected to convert to `Gray(N0f8(0.714))`.")
elseif process_raw_camera_data(UInt8[0,0,255,0], 1, 1)[1,1] != Gray(N0f8(0.074))
	keep_working(md"`UInt8[0,0,255,0]` expected to convert to `Gray(N0f8(0.074))`.")
else
	correct()
end

# ╔═╡ f7ab4012-6b16-11eb-00fc-f5b24dfb7635
if !@isdefined(process_raw_camera_data_color)
	not_defined(:process_raw_camera_data_color)
elseif !hasmethod(process_raw_camera_data_color, Tuple{Array{UInt8,1},Int,Int})
	keep_working(md"No method `process_raw_camera_data_color` for input type `Array{UInt8,1}`.")
elseif ismissing(process_raw_camera_data_color(raw_camera_data, w, h)) 
	still_missing()
elseif size(process_raw_camera_data_color(rand(UInt8,440), 11, 10)) != (10,11)
	keep_working(md"Size of output array must be `(h,w)`.")
elseif process_raw_camera_data_color(UInt8[255,0,0,0], 1, 1)[1,1] != RGBA{N0f8}(1,0,0,0)
	keep_working(md"`UInt8[255,0,0,0]` expected to convert to `RGBA{N0f8}(1,0,0,0)`.")
elseif process_raw_camera_data_color(UInt8[0,255,0,0], 1, 1)[1,1] != RGBA{N0f8}(0,1,0,0)
	keep_working(md"`UInt8[0,255,0,0]` expected to convert to `RGBA{N0f8}(0,1,0,0)`.")
elseif process_raw_camera_data_color(UInt8[0,0,255,0], 1, 1)[1,1] != RGBA{N0f8}(0,0,1,0)
	keep_working(md"`UInt8[0,0,255,0]` expected to convert to `RGBA{N0f8}(0,0,1,0)`.")
elseif process_raw_camera_data_color(UInt8[0,0,0,255], 1, 1)[1,1] != RGBA{N0f8}(0,0,0,1)
	keep_working(md"`UInt8[0,0,0,255]` expected to convert to `RGBA{N0f8}(0,0,0,1)`.")
else
	correct()
end

# ╔═╡ bc1bfbe8-6d4d-11eb-006b-331c821ae053
if !@isdefined(imagetl)
	not_defined(:imagetl)
elseif ismissing(imagetl)
	still_missing()
elseif !(typeof(imagetl) <: SubArray)
	keep_working(md"`imagetl` has not been assigned a sub-array.")
elseif size(imagetl) != (8,8)
	keep_working(md"`imagetl` is expected to have the size `(8,8)`.")
elseif imagetl != image[1:8,1:8]
	keep_working(md"`imagetl` is expected to contain the upper left part of the image.")
else
	correct()
end

# ╔═╡ ed14785e-6d4f-11eb-1c8d-bf2ffdfd087e
if !@isdefined(imagetlU8)
	not_defined(:imagetlU8)
elseif ismissing(imagetlU8)
	still_missing()
elseif !(typeof(imagetlU8) <: Base.ReinterpretArray)
	keep_working(md"Have you been using `reinterpret` to obtain `imagetlU8`?")
elseif size(imagetlU8) != (8,8)
	keep_working(md"`imagetlU8` is expected to have the size `(8,8)`.")
elseif eltype(imagetlU8) != UInt8
	keep_working(md"The elements of `imagetlU8` are expected to have type `UInt8`.")
else
	correct()
end

# ╔═╡ 4466633c-6d51-11eb-1794-d341f6f8a56d
let res = [127   127   127   127  127  127  127  127
 127   -82   -82   -82  -82  -82  127  127
 127   -82   127    89   69  -82  127  127
 127   -82    87    70   69   21  -78  127
 127   -82    71    71   71   89   22  -82
 127   -82   -20    21   71  127   89   90
 127  -100  -106   -20   89   89   87   72
 127   127   127  -106   89   89   70   70]
	if !@isdefined(imagetlU8valueshift)
		not_defined(:imagetlU8valueshift)
	elseif ismissing(imagetlU8valueshift)
		still_missing()
	elseif !(typeof(imagetlU8valueshift) <: AbstractMatrix)
		keep_working(md"`imagetlU8valueshift` is no longer a `Matrix`.")
	elseif size(imagetlU8valueshift) != (8,8)
		keep_working(md"`imagetlU8valueshift` is expected to have the size `(8,8)`.")
	elseif imagetlU8valueshift != res
		keep_working(md"The array values are not correct.")
	else
		correct()
	end
end

# ╔═╡ 4becdf5a-6d6f-11eb-355c-c76f313d6215
let res = [26  -7  14   8   7   3   3   2
  4   1   3  -8   2   1  -1   0
  8  -2   8   1  -3  -2  -1   0
  4  -3  -4   5   0   0   0  -2
  8   7  -4  -1  -1  -1   1   0
  4  -1  -1   0   1   0   0   0
  4   0  -1  -1   0   0   0   0
  1   0  -1   0   0   1   0   0]
	if !@isdefined(B)
		not_defined(:B)
	elseif ismissing(B)
		still_missing()
	elseif !(typeof(B) <: AbstractMatrix)
		keep_working(md"`B` is no longer a `Matrix`")
	elseif size(B) != (8,8)
		keep_working(md"`B` is expected to have the size `(8,8)`")
	elseif B != res
		keep_working(md"The array values are not correct")
	else
		correct()
	end
end

# ╔═╡ 2d681834-6d73-11eb-33a7-e99a5068574d
let res = N0f8[1.0    0.933  0.984  1.0    1.0    1.0    0.91   1.0
 0.969  0.349  0.173  0.027  0.176  0.204  0.902  0.929
 1.0    0.129  0.929  0.984  0.698  0.22   1.0    1.0
 1.0    0.224  0.894  0.639  0.812  0.451  0.294  0.839
 0.976  0.11   0.824  0.886  0.749  0.969  0.455  0.322
 0.969  0.231  0.263  0.643  0.796  1.0    0.8    0.839
 1.0    0.102  0.086  0.345  0.753  0.902  0.925  0.725
 0.984  0.902  1.0    0.133  0.824  0.882  0.667  0.835], 
B = [26  -7  14   8   7   3   3   2
  4   1   3  -8   2   1  -1   0
  8  -2   8   1  -3  -2  -1   0
  4  -3  -4   5   0   0   0  -2
  8   7  -4  -1  -1  -1   1   0
  4  -1  -1   0   1   0   0   0
  4   0  -1  -1   0   0   0   0
  1   0  -1   0   0   1   0   0]
	if !@isdefined(decode)
		not_defined(:decode)
	elseif !hasmethod(decode,Tuple{Matrix})
		keep_working(md"There is no method `decode` for inputs of type `Matrix`.")
	elseif ismissing(decode(B))
		still_missing()
	elseif !(typeof(decode(B)) <: AbstractMatrix)
		keep_working(md"`decode(B)` is expected to a 2D array.")
	elseif size(decode(B)) != (8,8)
		keep_working(md"`decode(B)` is expected to return image of size `(8,8)`.")
	elseif decode(B) != N0f8.(res)
		keep_working(md"The image values are not correct.")
	else
		correct()
	end
end

# ╔═╡ 22dd1bf4-6d77-11eb-0a0d-4794e366112f
let imageblock = N0f8[1.0  1.0   1.0    1.0    1.0    1.0    1.0    1.0
 1.0  0.18  0.18   0.18   0.18   0.18   1.0    1.0
 1.0  0.18  1.0    0.851  0.773  0.18   1.0    1.0
 1.0  0.18  0.843  0.776  0.773  0.584  0.196  1.0
 1.0  0.18  0.78   0.78   0.78   0.851  0.588  0.18
 1.0  0.18  0.424  0.584  0.78   1.0    0.851  0.855
 1.0  0.11  0.086  0.424  0.851  0.851  0.843  0.784
 1.0  1.0   1.0    0.086  0.851  0.851  0.776  0.776], 
B = [26  -7  14   8   7   3   3   2
  4   1   3  -8   2   1  -1   0
  8  -2   8   1  -3  -2  -1   0
  4  -3  -4   5   0   0   0  -2
  8   7  -4  -1  -1  -1   1   0
  4  -1  -1   0   1   0   0   0
  4   0  -1  -1   0   0   0   0
  1   0  -1   0   0   1   0   0]
	if !@isdefined(encode)
		not_defined(:encode)
	elseif !hasmethod(encode,Tuple{Matrix})
		keep_working(md"There is no method `encode` for inputs of type `Matrix`.")
	elseif ismissing(encode(imageblock))
		still_missing()
	elseif !(typeof(encode(imageblock)) <: AbstractMatrix)
		keep_working(md"`encode(imageblock)` is expected to a 2D array.")
	elseif size(encode(imageblock)) != (8,8)
		keep_working(md"`encode(imageblock)` is expected to return image of size `(8,8)`.")
	elseif encode(imageblock) != B
		keep_working(md"The encoded matrix values are not correct.")
	else
		correct()
	end
end

# ╔═╡ 5bdc91e4-6d79-11eb-14fb-1d57204e80b0
let ref = N0f8[1.0 0.933 0.984 1.0 1.0 1.0 0.91 1.0 1.0 1.0 0.992 0.973 0.922 1.0 1.0 0.945; 0.969 0.349 0.173 0.027 0.176 0.204 0.902 0.929 0.922 0.867 0.2 0.318 0.055 0.176 0.227 0.976; 1.0 0.129 0.929 0.984 0.698 0.22 1.0 1.0 1.0 1.0 0.11 0.988 1.0 0.698 0.063 1.0; 1.0 0.224 0.894 0.639 0.812 0.451 0.294 0.839 0.859 0.259 0.502 0.875 0.561 0.902 0.094 1.0; 0.976 0.11 0.824 0.886 0.749 0.969 0.455 0.322 0.267 0.588 0.749 0.753 0.847 0.765 0.259 0.949; 0.969 0.231 0.263 0.643 0.796 1.0 0.8 0.839 0.875 0.682 0.878 0.757 0.627 0.404 0.184 0.992; 1.0 0.102 0.086 0.345 0.753 0.902 0.925 0.725 0.714 0.949 0.659 0.8 0.388 0.071 0.157 1.0; 0.984 0.902 1.0 0.133 0.824 0.882 0.667 0.835 0.843 0.722 0.804 0.804 0.055 1.0 0.922 0.976; 0.953 1.0 0.886 0.098 0.867 0.835 0.8 0.733 0.776 0.773 0.835 0.592 0.129 0.906 1.0 1.0; 1.0 1.0 1.0 0.0 0.839 0.635 0.757 0.871 0.776 0.792 0.667 0.584 0.008 1.0 1.0 0.894; 0.988 0.843 1.0 0.243 0.522 0.925 0.827 0.686 0.796 0.941 0.471 0.631 0.2 1.0 0.702 1.0; 1.0 1.0 0.949 0.043 0.376 0.62 0.573 0.592 0.475 0.624 0.514 0.439 0.133 1.0 1.0 0.933; 0.953 1.0 0.922 0.965 0.212 0.459 0.573 0.588 0.643 0.62 0.514 0.008 0.827 0.949 1.0 1.0; 0.941 1.0 1.0 0.984 0.988 0.059 0.129 0.145 0.122 0.035 0.106 1.0 0.973 1.0 0.851 0.984; 1.0 0.871 0.937 1.0 1.0 0.882 0.988 0.914 0.922 0.988 1.0 0.839 1.0 0.886 1.0 1.0; 0.976 1.0 1.0 0.878 0.906 1.0 1.0 1.0 1.0 1.0 0.992 1.0 0.957 1.0 1.0 0.953]
	if !@isdefined(compressionartifacts)
		not_defined(:compressionartifacts)
	elseif ismissing(compressionartifacts)
		still_missing()
	elseif !(typeof(compressionartifacts) <: AbstractMatrix)
		keep_working(md"`compressionartifacts` is expected to a 2D array")
	elseif size(compressionartifacts) != (16,16)
		keep_working(md"`compressionartifacts` is expected to return image of size `(16,16)`")
	elseif compressionartifacts != ref
		keep_working(md"The image values in your image are not correct")
	else
		correct()
	end
end

# ╔═╡ cee8a0b8-6c45-11eb-1821-070abcf8dce9
let A = Float64[[1,2] [1,3]], Areduced = Float64[[1,0] [1,1]]
	if !@isdefined(gaußian_elimination)
		not_defined(:gaußian_elimination)
	elseif !hasmethod(gaußian_elimination, Tuple{Matrix{Float64}})
		keep_working(md"No method `gaußian_elimination` for input type `Matrix{Float64}`.")
	elseif ismissing(gaußian_elimination(A))
		still_missing()
	elseif gaußian_elimination(A) != Areduced
		keep_working(md"`[[1,2] [1,3]]` expected to reduce into `[[1,0] [1,1]]`.")
	else
		correct()
	end
end

# ╔═╡ 42921908-6c51-11eb-253f-c59d162f921d
let Abreduced = Float64[[2,0,0] [1,0.5,0] [-1,0.5,-1] [8,1,1]], x = Float64[2,3,-1]
	if !@isdefined(backward_substitution)
		not_defined(:backward_substitution)
	elseif !hasmethod(backward_substitution, Tuple{Matrix{Float64}})
		keep_working(md"No method `backward_substitution` for input type `Matrix{Float64}`.")
	elseif ismissing(backward_substitution(Abreduced))
		still_missing()
	elseif backward_substitution(Abreduced) != x
		keep_working(md"`[[2,0,0] [1,0.5,0] [-1,0.5,-1] [8,1,1]]` expected to return `[2,3,-1]`.")
	else
		correct()
	end
end

# ╔═╡ 9315eab8-6c5a-11eb-0272-99f39b551b6f
let A = Float64[[4,6] [3,3]], L = Float64[[1,1.5] [0,1]], U = Float64[[4,0] [3,-1.5]]
	if !@isdefined(gaußian_lu)
		not_defined(:gaußian_lu)
	elseif !hasmethod(gaußian_lu, Tuple{Matrix{Float64}})
		keep_working(md"No method `gaußian_lu` for input type `Matrix{Float64}`.")
	elseif ismissing(gaußian_lu(A))
		still_missing()
	elseif gaußian_lu(A)[1] != L
		keep_working(md"`[[4,6] [3,3]]` expected to return the lower triangular matrix `[[1,1.5] [0,1]]`.")
	elseif gaußian_lu(A)[2] != U
		keep_working(md"`[[4,6] [3,3]]` expected to return the upper triangular matrix `[[4,0] [3,-1.5]]`.")
	else
		correct()
	end
end

# ╔═╡ 3513db98-6c6c-11eb-2dfc-ebd0a3dce829
let A = Float64[[2,-3,-2] [1,-1,1] [-1,2,2]], b = Float64[8,-11,-3], x = Float64[2,3,-1]
	if !@isdefined(solve)
		not_defined(:solve)
	elseif !hasmethod(solve, Tuple{Matrix{Float64},Vector{Float64}})
		keep_working(md"No method `solve` for input type `Matrix{Float64}`.")
	elseif ismissing(solve(A,b))
		still_missing()
	elseif solve(A,b) != x
		keep_working(md"`solve([[2,-3,-2] [1,-1,1] [-1,2,2]],[8,-11,-3])` expected to return `[2,3,-1]`.")
	else
		correct()
	end
end

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
BenchmarkTools = "6e4b80f9-dd63-53aa-95a3-0cdb28fa8baf"
FFTW = "7a1cc6ca-52ef-59f5-83cd-3a7055c09341"
Images = "916415d5-f1e6-5110-898d-aaa5f9f070e0"
LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
BenchmarkTools = "~1.3.1"
FFTW = "~1.4.6"
Images = "~0.25.1"
PlutoUI = "~0.7.37"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.7.2"
manifest_format = "2.0"

[[deps.AbstractFFTs]]
deps = ["ChainRulesCore", "LinearAlgebra"]
git-tree-sha1 = "6f1d9bc1c08f9f4a8fa92e3ea3cb50153a1b40d4"
uuid = "621f4979-c628-5d54-868e-fcf4e3e8185c"
version = "1.1.0"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "8eaf9f1b4921132a4cff3f36a1d9ba923b14a481"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.4"

[[deps.Adapt]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "af92965fb30777147966f58acb05da51c5616b5f"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "3.3.3"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[deps.ArnoldiMethod]]
deps = ["LinearAlgebra", "Random", "StaticArrays"]
git-tree-sha1 = "62e51b39331de8911e4a7ff6f5aaf38a5f4cc0ae"
uuid = "ec485272-7323-5ecc-a04f-4719b315124d"
version = "0.2.0"

[[deps.ArrayInterface]]
deps = ["Compat", "IfElse", "LinearAlgebra", "Requires", "SparseArrays", "Static"]
git-tree-sha1 = "d49f55ff9c7ee06930b0f65b1df2bfa811418475"
uuid = "4fba245c-0d91-5ea0-9b3e-6abc04ee57a9"
version = "4.0.4"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.AxisAlgorithms]]
deps = ["LinearAlgebra", "Random", "SparseArrays", "WoodburyMatrices"]
git-tree-sha1 = "66771c8d21c8ff5e3a93379480a2307ac36863f7"
uuid = "13072b0f-2c55-5437-9ae7-d433b7a33950"
version = "1.0.1"

[[deps.AxisArrays]]
deps = ["Dates", "IntervalSets", "IterTools", "RangeArrays"]
git-tree-sha1 = "d127d5e4d86c7680b20c35d40b503c74b9a39b5e"
uuid = "39de3d68-74b9-583c-8d2d-e117c070f3a9"
version = "0.4.4"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.BenchmarkTools]]
deps = ["JSON", "Logging", "Printf", "Profile", "Statistics", "UUIDs"]
git-tree-sha1 = "4c10eee4af024676200bc7752e536f858c6b8f93"
uuid = "6e4b80f9-dd63-53aa-95a3-0cdb28fa8baf"
version = "1.3.1"

[[deps.CEnum]]
git-tree-sha1 = "215a9aa4a1f23fbd05b92769fdd62559488d70e9"
uuid = "fa961155-64e5-5f13-b03f-caf6b980ea82"
version = "0.4.1"

[[deps.Calculus]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "f641eb0a4f00c343bbc32346e1217b86f3ce9dad"
uuid = "49dc2e85-a5d0-5ad3-a950-438e2897f1b9"
version = "0.5.1"

[[deps.CatIndices]]
deps = ["CustomUnitRanges", "OffsetArrays"]
git-tree-sha1 = "a0f80a09780eed9b1d106a1bf62041c2efc995bc"
uuid = "aafaddc9-749c-510e-ac4f-586e18779b91"
version = "0.2.2"

[[deps.ChainRulesCore]]
deps = ["Compat", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "9950387274246d08af38f6eef8cb5480862a435f"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.14.0"

[[deps.ChangesOfVariables]]
deps = ["ChainRulesCore", "LinearAlgebra", "Test"]
git-tree-sha1 = "bf98fa45a0a4cee295de98d4c1462be26345b9a1"
uuid = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
version = "0.1.2"

[[deps.Clustering]]
deps = ["Distances", "LinearAlgebra", "NearestNeighbors", "Printf", "SparseArrays", "Statistics", "StatsBase"]
git-tree-sha1 = "75479b7df4167267d75294d14b58244695beb2ac"
uuid = "aaaa29a8-35af-508c-8bc3-b662a17a0fe5"
version = "0.14.2"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "024fe24d83e4a5bf5fc80501a314ce0d1aa35597"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.0"

[[deps.ColorVectorSpace]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "SpecialFunctions", "Statistics", "TensorCore"]
git-tree-sha1 = "3f1f500312161f1ae067abe07d13b40f78f32e07"
uuid = "c3611d14-8923-5661-9e6a-0046d554d3a4"
version = "0.9.8"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "417b0ed7b8b838aa6ca0a87aadf1bb9eb111ce40"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.8"

[[deps.Compat]]
deps = ["Base64", "Dates", "DelimitedFiles", "Distributed", "InteractiveUtils", "LibGit2", "Libdl", "LinearAlgebra", "Markdown", "Mmap", "Pkg", "Printf", "REPL", "Random", "SHA", "Serialization", "SharedArrays", "Sockets", "SparseArrays", "Statistics", "Test", "UUIDs", "Unicode"]
git-tree-sha1 = "96b0bc6c52df76506efc8a441c6cf1adcb1babc4"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "3.42.0"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[deps.ComputationalResources]]
git-tree-sha1 = "52cb3ec90e8a8bea0e62e275ba577ad0f74821f7"
uuid = "ed09eef8-17a6-5b46-8889-db040fac31e3"
version = "0.3.2"

[[deps.CoordinateTransformations]]
deps = ["LinearAlgebra", "StaticArrays"]
git-tree-sha1 = "681ea870b918e7cff7111da58791d7f718067a19"
uuid = "150eb455-5306-5404-9cee-2592286d6298"
version = "0.6.2"

[[deps.CustomUnitRanges]]
git-tree-sha1 = "1a3f97f907e6dd8983b744d2642651bb162a3f7a"
uuid = "dc8bdbbb-1ca9-579f-8c36-e416f6a65cce"
version = "1.0.2"

[[deps.DataAPI]]
git-tree-sha1 = "cc70b17275652eb47bc9e5f81635981f13cea5c8"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.9.0"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "3daef5523dd2e769dad2365274f760ff5f282c7d"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.11"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.DelimitedFiles]]
deps = ["Mmap"]
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"

[[deps.Distances]]
deps = ["LinearAlgebra", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "3258d0659f812acde79e8a74b11f17ac06d0ca04"
uuid = "b4f34e82-e78d-54a5-968a-f98e89d6e8f7"
version = "0.10.7"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "b19534d1895d702889b219c382a6e18010797f0b"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.8.6"

[[deps.Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[deps.DualNumbers]]
deps = ["Calculus", "NaNMath", "SpecialFunctions"]
git-tree-sha1 = "5837a837389fccf076445fce071c8ddaea35a566"
uuid = "fa6b7ba4-c1ee-5f82-b5fc-ecf0adba8f74"
version = "0.6.8"

[[deps.EllipsisNotation]]
deps = ["ArrayInterface"]
git-tree-sha1 = "d7ab55febfd0907b285fbf8dc0c73c0825d9d6aa"
uuid = "da5c29d0-fa7d-589e-88eb-ea29b0a81949"
version = "1.3.0"

[[deps.FFTViews]]
deps = ["CustomUnitRanges", "FFTW"]
git-tree-sha1 = "cbdf14d1e8c7c8aacbe8b19862e0179fd08321c2"
uuid = "4f61f5a4-77b1-5117-aa51-3ab5ef4ef0cd"
version = "0.3.2"

[[deps.FFTW]]
deps = ["AbstractFFTs", "FFTW_jll", "LinearAlgebra", "MKL_jll", "Preferences", "Reexport"]
git-tree-sha1 = "505876577b5481e50d089c1c68899dfb6faebc62"
uuid = "7a1cc6ca-52ef-59f5-83cd-3a7055c09341"
version = "1.4.6"

[[deps.FFTW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c6033cc3892d0ef5bb9cd29b7f2f0331ea5184ea"
uuid = "f5851436-0d7a-5f13-b9de-f02708fd171a"
version = "3.3.10+0"

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

[[deps.Ghostscript_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "78e2c69783c9753a91cdae88a8d432be85a2ab5e"
uuid = "61579ee1-b43e-5ca0-a5da-69d92c66a64b"
version = "9.55.0+0"

[[deps.Graphics]]
deps = ["Colors", "LinearAlgebra", "NaNMath"]
git-tree-sha1 = "1c5a84319923bea76fa145d49e93aa4394c73fc2"
uuid = "a2bd30eb-e257-5431-a919-1863eab51364"
version = "1.1.1"

[[deps.Graphs]]
deps = ["ArnoldiMethod", "Compat", "DataStructures", "Distributed", "Inflate", "LinearAlgebra", "Random", "SharedArrays", "SimpleTraits", "SparseArrays", "Statistics"]
git-tree-sha1 = "57c021de207e234108a6f1454003120a1bf350c4"
uuid = "86223c79-3864-5bf0-83f7-82e725a168b6"
version = "1.6.0"

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

[[deps.IfElse]]
git-tree-sha1 = "debdd00ffef04665ccbb3e150747a77560e8fad1"
uuid = "615f187c-cbe4-4ef1-ba3b-2fcf58d6d173"
version = "0.1.1"

[[deps.ImageAxes]]
deps = ["AxisArrays", "ImageBase", "ImageCore", "Reexport", "SimpleTraits"]
git-tree-sha1 = "c54b581a83008dc7f292e205f4c409ab5caa0f04"
uuid = "2803e5a7-5153-5ecf-9a86-9b4c37f5f5ac"
version = "0.6.10"

[[deps.ImageBase]]
deps = ["ImageCore", "Reexport"]
git-tree-sha1 = "b51bb8cae22c66d0f6357e3bcb6363145ef20835"
uuid = "c817782e-172a-44cc-b673-b171935fbb9e"
version = "0.1.5"

[[deps.ImageContrastAdjustment]]
deps = ["ImageCore", "ImageTransformations", "Parameters"]
git-tree-sha1 = "0d75cafa80cf22026cea21a8e6cf965295003edc"
uuid = "f332f351-ec65-5f6a-b3d1-319c6670881a"
version = "0.3.10"

[[deps.ImageCore]]
deps = ["AbstractFFTs", "ColorVectorSpace", "Colors", "FixedPointNumbers", "Graphics", "MappedArrays", "MosaicViews", "OffsetArrays", "PaddedViews", "Reexport"]
git-tree-sha1 = "9a5c62f231e5bba35695a20988fc7cd6de7eeb5a"
uuid = "a09fc81d-aa75-5fe9-8630-4744c3626534"
version = "0.9.3"

[[deps.ImageDistances]]
deps = ["Distances", "ImageCore", "ImageMorphology", "LinearAlgebra", "Statistics"]
git-tree-sha1 = "7a20463713d239a19cbad3f6991e404aca876bda"
uuid = "51556ac3-7006-55f5-8cb3-34580c88182d"
version = "0.2.15"

[[deps.ImageFiltering]]
deps = ["CatIndices", "ComputationalResources", "DataStructures", "FFTViews", "FFTW", "ImageBase", "ImageCore", "LinearAlgebra", "OffsetArrays", "Reexport", "SparseArrays", "StaticArrays", "Statistics", "TiledIteration"]
git-tree-sha1 = "15bd05c1c0d5dbb32a9a3d7e0ad2d50dd6167189"
uuid = "6a3955dd-da59-5b1f-98d4-e7296123deb5"
version = "0.7.1"

[[deps.ImageIO]]
deps = ["FileIO", "JpegTurbo", "Netpbm", "OpenEXR", "PNGFiles", "QOI", "Sixel", "TiffImages", "UUIDs"]
git-tree-sha1 = "464bdef044df52e6436f8c018bea2d48c40bb27b"
uuid = "82e4d734-157c-48bb-816b-45c225c6df19"
version = "0.6.1"

[[deps.ImageMagick]]
deps = ["FileIO", "ImageCore", "ImageMagick_jll", "InteractiveUtils", "Libdl", "Pkg", "Random"]
git-tree-sha1 = "5bc1cb62e0c5f1005868358db0692c994c3a13c6"
uuid = "6218d12a-5da1-5696-b52f-db25d2ecc6d1"
version = "1.2.1"

[[deps.ImageMagick_jll]]
deps = ["Artifacts", "Ghostscript_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pkg", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "f025b79883f361fa1bd80ad132773161d231fd9f"
uuid = "c73af94c-d91f-53ed-93a7-00f77d67a9d7"
version = "6.9.12+2"

[[deps.ImageMetadata]]
deps = ["AxisArrays", "ImageAxes", "ImageBase", "ImageCore"]
git-tree-sha1 = "36cbaebed194b292590cba2593da27b34763804a"
uuid = "bc367c6b-8a6b-528e-b4bd-a4b897500b49"
version = "0.9.8"

[[deps.ImageMorphology]]
deps = ["ImageCore", "LinearAlgebra", "Requires", "TiledIteration"]
git-tree-sha1 = "7668b123ecfd39a6ae3fc31c532b588999bdc166"
uuid = "787d08f9-d448-5407-9aad-5290dd7ab264"
version = "0.3.1"

[[deps.ImageQualityIndexes]]
deps = ["ImageContrastAdjustment", "ImageCore", "ImageDistances", "ImageFiltering", "OffsetArrays", "Statistics"]
git-tree-sha1 = "1d2d73b14198d10f7f12bf7f8481fd4b3ff5cd61"
uuid = "2996bd0c-7a13-11e9-2da2-2f5ce47296a9"
version = "0.3.0"

[[deps.ImageSegmentation]]
deps = ["Clustering", "DataStructures", "Distances", "Graphs", "ImageCore", "ImageFiltering", "ImageMorphology", "LinearAlgebra", "MetaGraphs", "RegionTrees", "SimpleWeightedGraphs", "StaticArrays", "Statistics"]
git-tree-sha1 = "36832067ea220818d105d718527d6ed02385bf22"
uuid = "80713f31-8817-5129-9cf8-209ff8fb23e1"
version = "1.7.0"

[[deps.ImageShow]]
deps = ["Base64", "FileIO", "ImageBase", "ImageCore", "OffsetArrays", "StackViews"]
git-tree-sha1 = "d0ac64c9bee0aed6fdbb2bc0e5dfa9a3a78e3acc"
uuid = "4e3cecfd-b093-5904-9786-8bbb286a6a31"
version = "0.3.3"

[[deps.ImageTransformations]]
deps = ["AxisAlgorithms", "ColorVectorSpace", "CoordinateTransformations", "ImageBase", "ImageCore", "Interpolations", "OffsetArrays", "Rotations", "StaticArrays"]
git-tree-sha1 = "42fe8de1fe1f80dab37a39d391b6301f7aeaa7b8"
uuid = "02fcd773-0e25-5acc-982a-7f6622650795"
version = "0.9.4"

[[deps.Images]]
deps = ["Base64", "FileIO", "Graphics", "ImageAxes", "ImageBase", "ImageContrastAdjustment", "ImageCore", "ImageDistances", "ImageFiltering", "ImageIO", "ImageMagick", "ImageMetadata", "ImageMorphology", "ImageQualityIndexes", "ImageSegmentation", "ImageShow", "ImageTransformations", "IndirectArrays", "IntegralArrays", "Random", "Reexport", "SparseArrays", "StaticArrays", "Statistics", "StatsBase", "TiledIteration"]
git-tree-sha1 = "11d268adba1869067620659e7cdf07f5e54b6c76"
uuid = "916415d5-f1e6-5110-898d-aaa5f9f070e0"
version = "0.25.1"

[[deps.Imath_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "87f7662e03a649cffa2e05bf19c303e168732d3e"
uuid = "905a6f67-0a94-5f89-b386-d35d92009cd1"
version = "3.1.2+0"

[[deps.IndirectArrays]]
git-tree-sha1 = "012e604e1c7458645cb8b436f8fba789a51b257f"
uuid = "9b13fd28-a010-5f03-acff-a1bbcff69959"
version = "1.0.0"

[[deps.Inflate]]
git-tree-sha1 = "f5fc07d4e706b84f72d54eedcc1c13d92fb0871c"
uuid = "d25df0c9-e2be-5dd7-82c8-3ad0b3e990b9"
version = "0.1.2"

[[deps.IntegralArrays]]
deps = ["ColorTypes", "FixedPointNumbers", "IntervalSets"]
git-tree-sha1 = "cf737764159c66b95cdbf5c10484929b247fecfe"
uuid = "1d092043-8f09-5a30-832f-7509e371ab51"
version = "0.1.3"

[[deps.IntelOpenMP_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "d979e54b71da82f3a65b62553da4fc3d18c9004c"
uuid = "1d5cc7b8-4909-519e-a0f8-d0f5ad9712d0"
version = "2018.0.3+2"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.Interpolations]]
deps = ["AxisAlgorithms", "ChainRulesCore", "LinearAlgebra", "OffsetArrays", "Random", "Ratios", "Requires", "SharedArrays", "SparseArrays", "StaticArrays", "WoodburyMatrices"]
git-tree-sha1 = "b15fc0a95c564ca2e0a7ae12c1f095ca848ceb31"
uuid = "a98d9a8b-a2ab-59e6-89dd-64a1c18fca59"
version = "0.13.5"

[[deps.IntervalSets]]
deps = ["Dates", "EllipsisNotation", "Statistics"]
git-tree-sha1 = "bcf640979ee55b652f3b01650444eb7bbe3ea837"
uuid = "8197267c-284f-5f27-9208-e0e47529a953"
version = "0.5.4"

[[deps.InverseFunctions]]
deps = ["Test"]
git-tree-sha1 = "91b5dcf362c5add98049e6c29ee756910b03051d"
uuid = "3587e190-3f89-42d0-90ee-14403ec27112"
version = "0.1.3"

[[deps.IrrationalConstants]]
git-tree-sha1 = "7fd44fd4ff43fc60815f8e764c0f352b83c49151"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.1.1"

[[deps.IterTools]]
git-tree-sha1 = "fa6287a4469f5e048d763df38279ee729fbd44e5"
uuid = "c8e1da08-722c-5040-9ed9-7db0dc04731e"
version = "1.4.0"

[[deps.JLD2]]
deps = ["FileIO", "MacroTools", "Mmap", "OrderedCollections", "Pkg", "Printf", "Reexport", "TranscodingStreams", "UUIDs"]
git-tree-sha1 = "81b9477b49402b47fbe7f7ae0b252077f53e4a08"
uuid = "033835bb-8acc-5ee8-8aae-3f567f8a3819"
version = "0.4.22"

[[deps.JLLWrappers]]
deps = ["Preferences"]
git-tree-sha1 = "abc9885a7ca2052a736a600f7fa66209f96506e1"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.4.1"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "3c837543ddb02250ef42f4738347454f95079d4e"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.3"

[[deps.JpegTurbo]]
deps = ["CEnum", "FileIO", "ImageCore", "JpegTurbo_jll", "TOML"]
git-tree-sha1 = "a77b273f1ddec645d1b7c4fd5fb98c8f90ad10a5"
uuid = "b835a17e-a41a-41e7-81f0-2f016b05efe0"
version = "0.1.1"

[[deps.JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b53380851c6e6664204efb2e62cd24fa5c47e4ba"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "2.1.2+0"

[[deps.LERC_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bf36f528eec6634efc60d7ec062008f171071434"
uuid = "88015f11-f218-50d7-93a8-a6af411a945d"
version = "3.0.0+1"

[[deps.LazyArtifacts]]
deps = ["Artifacts", "Pkg"]
uuid = "4af54fe1-eca0-43a8-85a7-787d91b784e3"

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

[[deps.Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "LERC_jll", "Libdl", "Pkg", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "c9551dd26e31ab17b86cbd00c2ede019c08758eb"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.3.0+1"

[[deps.LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.LogExpFunctions]]
deps = ["ChainRulesCore", "ChangesOfVariables", "DocStringExtensions", "InverseFunctions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "58f25e56b706f95125dcb796f39e1fb01d913a71"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.10"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.MKL_jll]]
deps = ["Artifacts", "IntelOpenMP_jll", "JLLWrappers", "LazyArtifacts", "Libdl", "Pkg"]
git-tree-sha1 = "e595b205efd49508358f7dc670a940c790204629"
uuid = "856f044c-d86e-5d09-b602-aeab76dc8ba7"
version = "2022.0.0+0"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "3d3e902b31198a27340d0bf00d6ac452866021cf"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.9"

[[deps.MappedArrays]]
git-tree-sha1 = "e8b359ef06ec72e8c030463fe02efe5527ee5142"
uuid = "dbb5928d-eab1-5f90-85c2-b9b0edb7c900"
version = "0.4.1"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[deps.MetaGraphs]]
deps = ["Graphs", "JLD2", "Random"]
git-tree-sha1 = "2af69ff3c024d13bde52b34a2a7d6887d4e7b438"
uuid = "626554b9-1ddb-594c-aa3c-2596fe9399a5"
version = "0.7.1"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "bf210ce90b6c9eed32d25dbcae1ebc565df2687f"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.0.2"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MosaicViews]]
deps = ["MappedArrays", "OffsetArrays", "PaddedViews", "StackViews"]
git-tree-sha1 = "b34e3bc3ca7c94914418637cb10cc4d1d80d877d"
uuid = "e94cdb99-869f-56ef-bcf0-1ae2bcbe0389"
version = "0.3.3"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[deps.NaNMath]]
git-tree-sha1 = "b086b7ea07f8e38cf122f5016af580881ac914fe"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "0.3.7"

[[deps.NearestNeighbors]]
deps = ["Distances", "StaticArrays"]
git-tree-sha1 = "ded92de95031d4a8c61dfb6ba9adb6f1d8016ddd"
uuid = "b8a86587-4115-5ab1-83bc-aa920d37bbce"
version = "0.4.10"

[[deps.Netpbm]]
deps = ["FileIO", "ImageCore"]
git-tree-sha1 = "18efc06f6ec36a8b801b23f076e3c6ac7c3bf153"
uuid = "f09324ee-3d7c-5217-9330-fc30815ba969"
version = "1.0.2"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[deps.OffsetArrays]]
deps = ["Adapt"]
git-tree-sha1 = "043017e0bdeff61cfbb7afeb558ab29536bbb5ed"
uuid = "6fe1bfb0-de20-5000-8ca7-80f57d26f881"
version = "1.10.8"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"

[[deps.OpenEXR]]
deps = ["Colors", "FileIO", "OpenEXR_jll"]
git-tree-sha1 = "327f53360fdb54df7ecd01e96ef1983536d1e633"
uuid = "52e1d378-f018-4a11-a4be-720524705ac7"
version = "0.3.2"

[[deps.OpenEXR_jll]]
deps = ["Artifacts", "Imath_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "923319661e9a22712f24596ce81c54fc0366f304"
uuid = "18a262bb-aa17-5467-a713-aee519bc75cb"
version = "3.1.1+0"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"

[[deps.OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[deps.PNGFiles]]
deps = ["Base64", "CEnum", "ImageCore", "IndirectArrays", "OffsetArrays", "libpng_jll"]
git-tree-sha1 = "eb4dbb8139f6125471aa3da98fb70f02dc58e49c"
uuid = "f57f5aa1-a3ce-4bc8-8ab9-96f992907883"
version = "0.3.14"

[[deps.PaddedViews]]
deps = ["OffsetArrays"]
git-tree-sha1 = "03a7a85b76381a3d04c7a1656039197e70eda03d"
uuid = "5432bcbf-9aad-5242-b902-cca2824c8663"
version = "0.5.11"

[[deps.Parameters]]
deps = ["OrderedCollections", "UnPack"]
git-tree-sha1 = "34c0e9ad262e5f7fc75b10a9952ca7692cfc5fbe"
uuid = "d96e819e-fc66-5662-9728-84c9c7592b0a"
version = "0.12.3"

[[deps.Parsers]]
deps = ["Dates"]
git-tree-sha1 = "85b5da0fa43588c75bb1ff986493443f821c70b7"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.2.3"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[deps.PkgVersion]]
deps = ["Pkg"]
git-tree-sha1 = "a7a7e1a88853564e551e4eba8650f8c38df79b37"
uuid = "eebad327-c553-4316-9ea0-9fa01ccd7688"
version = "0.1.1"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "bf0a1121af131d9974241ba53f601211e9303a9e"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.37"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "d3538e7f8a790dc8903519090857ef8e1283eecd"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.2.5"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.Profile]]
deps = ["Printf"]
uuid = "9abbd945-dff8-562f-b5e8-e1ebf5ef1b79"

[[deps.ProgressMeter]]
deps = ["Distributed", "Printf"]
git-tree-sha1 = "d7a7aef8f8f2d537104f170139553b14dfe39fe9"
uuid = "92933f4c-e287-5a05-a399-4b506db050ca"
version = "1.7.2"

[[deps.QOI]]
deps = ["ColorTypes", "FileIO", "FixedPointNumbers"]
git-tree-sha1 = "18e8f4d1426e965c7b532ddd260599e1510d26ce"
uuid = "4b34888f-f399-49d4-9bb3-47ed5cae4e65"
version = "1.0.0"

[[deps.Quaternions]]
deps = ["DualNumbers", "LinearAlgebra", "Random"]
git-tree-sha1 = "522770af103809e8346aefa4b25c31fbec377ccf"
uuid = "94ee1d12-ae83-5a48-8b1c-48b8ff168ae0"
version = "0.5.3"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.RangeArrays]]
git-tree-sha1 = "b9039e93773ddcfc828f12aadf7115b4b4d225f5"
uuid = "b3c3ace0-ae52-54e7-9d0b-2c1406fd6b9d"
version = "0.3.2"

[[deps.Ratios]]
deps = ["Requires"]
git-tree-sha1 = "dc84268fe0e3335a62e315a3a7cf2afa7178a734"
uuid = "c84ed2f1-dad5-54f0-aa8e-dbefe2724439"
version = "0.4.3"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.RegionTrees]]
deps = ["IterTools", "LinearAlgebra", "StaticArrays"]
git-tree-sha1 = "4618ed0da7a251c7f92e869ae1a19c74a7d2a7f9"
uuid = "dee08c22-ab7f-5625-9660-a9af2021b33f"
version = "0.3.2"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.Rotations]]
deps = ["LinearAlgebra", "Quaternions", "Random", "StaticArrays", "Statistics"]
git-tree-sha1 = "a167638e2cbd8ac41f9cd57282cab9b042fa26e6"
uuid = "6038ab10-8711-5258-84ad-4b1120ba62dc"
version = "1.3.0"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[deps.SimpleTraits]]
deps = ["InteractiveUtils", "MacroTools"]
git-tree-sha1 = "5d7e3f4e11935503d3ecaf7186eac40602e7d231"
uuid = "699a6c99-e7fa-54fc-8d76-47d257e15c1d"
version = "0.9.4"

[[deps.SimpleWeightedGraphs]]
deps = ["Graphs", "LinearAlgebra", "Markdown", "SparseArrays", "Test"]
git-tree-sha1 = "a6f404cc44d3d3b28c793ec0eb59af709d827e4e"
uuid = "47aef6b3-ad0c-573a-a1e2-d07658019622"
version = "1.2.1"

[[deps.Sixel]]
deps = ["Dates", "FileIO", "ImageCore", "IndirectArrays", "OffsetArrays", "REPL", "libsixel_jll"]
git-tree-sha1 = "8fb59825be681d451c246a795117f317ecbcaa28"
uuid = "45858cf5-a6b0-47a3-bbea-62219f50df47"
version = "0.1.2"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "b3363d7460f7d098ca0912c69b082f75625d7508"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.0.1"

[[deps.SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.SpecialFunctions]]
deps = ["ChainRulesCore", "IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "5ba658aeecaaf96923dce0da9e703bd1fe7666f9"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.1.4"

[[deps.StackViews]]
deps = ["OffsetArrays"]
git-tree-sha1 = "46e589465204cd0c08b4bd97385e4fa79a0c770c"
uuid = "cae243ae-269e-4f55-b966-ac2d0dc13c15"
version = "0.1.1"

[[deps.Static]]
deps = ["IfElse"]
git-tree-sha1 = "65068e4b4d10f3c31aaae2e6cb92b6c6cedca610"
uuid = "aedffcd0-7271-4cad-89d0-dc628f76c6d3"
version = "0.5.6"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "Random", "Statistics"]
git-tree-sha1 = "4f6ec5d99a28e1a749559ef7dd518663c5eca3d5"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.4.3"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "c3d8ba7f3fa0625b062b82853a7d5229cb728b6b"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.2.1"

[[deps.StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "8977b17906b0a1cc74ab2e3a05faa16cf08a8291"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.33.16"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[deps.TensorCore]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1feb45f88d133a655e001435632f019a9a1bcdb6"
uuid = "62fd8b95-f654-4bbd-a8a5-9c27f68ccd50"
version = "0.1.1"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.TiffImages]]
deps = ["ColorTypes", "DataStructures", "DocStringExtensions", "FileIO", "FixedPointNumbers", "IndirectArrays", "Inflate", "OffsetArrays", "PkgVersion", "ProgressMeter", "UUIDs"]
git-tree-sha1 = "aaa19086bc282630d82f818456bc40b4d314307d"
uuid = "731e570b-9d59-4bfa-96dc-6df516fadf69"
version = "0.5.4"

[[deps.TiledIteration]]
deps = ["OffsetArrays"]
git-tree-sha1 = "5683455224ba92ef59db72d10690690f4a8dc297"
uuid = "06e1c1a7-607b-532d-9fad-de7d9aa2abac"
version = "0.3.1"

[[deps.TranscodingStreams]]
deps = ["Random", "Test"]
git-tree-sha1 = "216b95ea110b5972db65aa90f88d8d89dcb8851c"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.9.6"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.UnPack]]
git-tree-sha1 = "387c1f73762231e86e0c9c5443ce3b4a0a9a0c2b"
uuid = "3a884ed6-31ef-47d7-9d2a-63182c4928ed"
version = "1.0.2"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.WoodburyMatrices]]
deps = ["LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "de67fa59e33ad156a590055375a30b23c40299d3"
uuid = "efce3f68-66dc-5838-9240-27a6d6f5f9b6"
version = "0.5.5"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[deps.Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e45044cd873ded54b6a5bac0eb5c971392cf1927"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.2+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"

[[deps.libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "94d180a6d2b5e55e447e2d27a29ed04fe79eb30c"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.38+0"

[[deps.libsixel_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "78736dab31ae7a53540a6b752efc61f77b304c5b"
uuid = "075b6546-f08a-558a-be8f-8157d0f608a5"
version = "1.8.6+1"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
"""

# ╔═╡ Cell order:
# ╟─08bc5e4a-6801-11eb-0b97-b127b6fd83b3
# ╟─72204898-6a26-11eb-063c-15de4895974c
# ╠═a6448cac-67fd-11eb-00f3-43f56fe0178e
# ╟─65a3de4c-6aba-11eb-3edd-b78b1fe70276
# ╠═68d9006e-67fa-11eb-05d7-1933fddfe8ad
# ╟─2d05404c-6abc-11eb-12a9-b1b93645aa6c
# ╠═98b3602c-6abb-11eb-321b-354ca57dce8e
# ╟─b258e294-6abc-11eb-1a43-730c7cd2f14f
# ╠═83650edc-6abb-11eb-3a15-d1ec709d6528
# ╠═dbf71676-6abb-11eb-3566-d36184515e11
# ╟─4cd1e508-6ac1-11eb-2fc3-b95d83bb49cf
# ╠═14343566-6ac1-11eb-004f-d577af5d4bcf
# ╟─0e467baa-6abf-11eb-2421-978a24cc1f4b
# ╠═3cd7e918-6abf-11eb-34df-43d0375c13d2
# ╟─23edd3a8-6ac0-11eb-37d7-f3d6fe49df0c
# ╟─01ecb23c-6ac1-11eb-216e-cf71d79767aa
# ╠═04ef21b2-6ac2-11eb-0c0a-63e26ace9bd5
# ╠═72a07900-6ad0-11eb-05e9-93add2a50013
# ╠═7669023c-6ad0-11eb-093f-ffd78d40f882
# ╟─44fb2478-6ad0-11eb-211d-15a83ca5b52c
# ╟─01d671e6-6ad5-11eb-3175-e7ba17bd5363
# ╠═b4ead108-6ad4-11eb-16dd-71ae476b2989
# ╟─45613d44-6ad5-11eb-1714-0de397bed28d
# ╠═c65b535c-6ad4-11eb-24c2-f13fa59bedd4
# ╟─a41e0aec-6ad5-11eb-3dae-d5851e3e54d5
# ╠═dc157882-6ad4-11eb-1a86-157a2851833a
# ╟─8e205b98-6ad6-11eb-1fe1-9d8d4efc7490
# ╟─67afb97a-6ad0-11eb-225b-5503c368532d
# ╠═ae9345da-6ad2-11eb-098d-17862bfb276d
# ╟─871a6014-6ad8-11eb-2788-a7071f5f70b7
# ╟─6e5395e6-6ad8-11eb-0245-47879f360f86
# ╠═863d3ad8-6ad9-11eb-2f10-47d534c5183c
# ╟─168eb0e6-6ada-11eb-3a9a-cb27f579af5b
# ╠═346835f0-6ae0-11eb-3f37-1faff4958d69
# ╟─95230726-6ae0-11eb-14bd-13ce33160c0f
# ╠═1b8af5fe-6ae0-11eb-24ca-fda3c7bccc8d
# ╟─b3d552a0-6ae0-11eb-2df4-35cbd169d7ff
# ╠═c617cd06-6ad1-11eb-0bb4-71f538340041
# ╟─cb3b6c4c-6af0-11eb-3eef-4bfe3aa16af2
# ╟─32f22538-6af3-11eb-1fd9-43d86761061e
# ╠═d67a95e8-e927-48ab-a0dc-986ff966ac39
# ╟─2abb3cea-6af5-11eb-20aa-671e662f58c5
# ╟─0720d5da-6b07-11eb-0d4e-f907bfc19a76
# ╠═b576cebe-6b07-11eb-208f-5f94d361b322
# ╟─536862c4-6b0b-11eb-101c-d134fa76766b
# ╠═2c9ebede-6b08-11eb-03e0-9733a7486a00
# ╟─301d6c16-6b0f-11eb-3b8b-0fa0812605bc
# ╠═64bb481c-6b0f-11eb-1967-1fc3c22200f0
# ╟─f7ab4012-6b16-11eb-00fc-f5b24dfb7635
# ╠═cd89a384-6b0f-11eb-0fba-2be93043f371
# ╟─67508718-6b0f-11eb-336d-5b0596efcbfd
# ╟─71164f4e-6b19-11eb-0a24-61af7e816b64
# ╟─7e8ae448-6d3d-11eb-308d-b3ae2dff8759
# ╠═b6fcc2aa-6b18-11eb-26b8-87976eed1b4c
# ╟─bc1bfbe8-6d4d-11eb-006b-331c821ae053
# ╟─6777e362-6d4e-11eb-1522-edc03b2a743f
# ╠═1ca07ab6-6b19-11eb-2667-d751db42b5b9
# ╟─ed14785e-6d4f-11eb-1c8d-bf2ffdfd087e
# ╟─9e624ae0-6b7b-11eb-1f76-8bc9423aec69
# ╠═feb6a160-6b18-11eb-3104-01a6b3df8568
# ╟─4466633c-6d51-11eb-1794-d341f6f8a56d
# ╟─aa7e7286-6b7b-11eb-0ca2-8b9b87032500
# ╠═1e16a2b6-6b1f-11eb-16ea-afb26da7b615
# ╟─b98e9d64-6b7b-11eb-0434-093f2635b1c9
# ╟─70fe0c24-6b1f-11eb-1146-7f49e53cb83a
# ╠═25e9a0cc-6b23-11eb-045f-836b69c7cdf6
# ╟─4becdf5a-6d6f-11eb-355c-c76f313d6215
# ╟─08cc5ac8-6d71-11eb-2035-ff52fa753c56
# ╟─e638ea94-6d70-11eb-04d4-cd0c95304409
# ╠═ec0c3920-6d73-11eb-3657-3551fb5efd48
# ╟─2d681834-6d73-11eb-33a7-e99a5068574d
# ╠═02e51660-6d74-11eb-3505-53c2b5cdd527
# ╟─26ffaf0a-6d75-11eb-39fa-6f6014ca06b8
# ╠═57f78ea6-6d76-11eb-0ce9-1da763bb82a3
# ╟─22dd1bf4-6d77-11eb-0a0d-4794e366112f
# ╟─9e4cb2b8-6d77-11eb-31df-ffe2db5ec780
# ╠═07399581-b7e3-4606-af35-02311bc424f1
# ╠═2f106cfa-71eb-11eb-2beb-a58e9bcd44c3
# ╟─5bdc91e4-6d79-11eb-14fb-1d57204e80b0
# ╟─27f457c8-6c3d-11eb-0394-41799ec3e62a
# ╠═359bf110-6c3d-11eb-0653-c922639fadb9
# ╟─5949e6d6-6c41-11eb-293d-b1b3d380d82a
# ╠═3c6c5958-6c3d-11eb-0145-ad6810fd1feb
# ╟─cee8a0b8-6c45-11eb-1821-070abcf8dce9
# ╟─b5daed82-6c46-11eb-02f5-bd16dcaea96b
# ╠═11bfd09d-3569-4d94-af7c-db37f43f39e0
# ╟─cbe6f94e-6c4c-11eb-3374-7d407f486762
# ╠═497249b4-6c3d-11eb-252b-f755ccaac847
# ╟─42921908-6c51-11eb-253f-c59d162f921d
# ╟─9f49f4c6-6c52-11eb-1def-ed52905ce363
# ╠═5de3fb4a-6c3d-11eb-1195-edb411d2ce1d
# ╟─b3ecbcda-6c53-11eb-2b18-971bd185d061
# ╠═68460e8f-a60d-4a4e-91f9-978638787966
# ╟─a2b0e77e-6c3d-11eb-3dd0-a7ee2eebb0d3
# ╠═b4aca7c6-6c3d-11eb-1a2c-9b6ec6f4040b
# ╠═9315eab8-6c5a-11eb-0272-99f39b551b6f
# ╟─c8cf01c0-6c5b-11eb-0c81-bb4826223084
# ╠═25577f96-6c69-11eb-1b97-775ab27898ee
# ╟─8173a232-6c69-11eb-204b-498a9a1c9bda
# ╠═7f7836a4-6c67-11eb-0668-8f3f62306d04
# ╠═3513db98-6c6c-11eb-2dfc-ebd0a3dce829
# ╟─ec78f35a-6c6b-11eb-22dd-8ffc50fb995e
# ╠═2655dfde-6c6c-11eb-319b-af6253c872e1
# ╟─afe19a78-6c6b-11eb-20f7-09ccb3418b22
# ╠═ca76fc44-6c3d-11eb-3d07-f5bf46fc06fa
# ╟─d6bb848c-6c76-11eb-3e0c-1f4c3eebb465
# ╠═c47bf6b4-6c3d-11eb-1e3d-37443c5dc984
# ╟─064494fa-6c77-11eb-2901-21777655aa94
# ╟─a107b80a-6801-11eb-39c4-6bab244b6c3b
# ╟─415f778e-6b88-11eb-1680-bb8612b363a9
# ╟─720eb566-67fa-11eb-2ca7-ed77be7d4993
# ╟─affc8ac2-6801-11eb-2f0b-adb643485e0c
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
