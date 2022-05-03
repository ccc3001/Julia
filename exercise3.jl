### A Pluto.jl notebook ###
# v0.18.4

using Markdown
using InteractiveUtils

# ╔═╡ 2f61761a-6f14-11eb-3249-6f2fd9f0c645
begin
	using PlutoUI
	
	PlutoUI.TableOfContents()
end

# ╔═╡ 7e20e0ba-6d3e-11eb-3a05-93a480b44495
md"""
# Scientific Programming - Types and Multiple-Dispatch

[Institute for Biomedical Imaging](https://www.tuhh.de/ibi/home.html), Hamburg University of Technology

* 👨‍🏫 Prof. Dr.-Ing. Tobias Knopp
+ 👨‍🏫 Dr. rer. nat. Martin Möddel

The due date of this exercise is 10.05 at 0:00. Please submit your solution to [Stud.IP](https://e-learning.tuhh.de/studip/dispatch.php/course/files/index/031251f16bdb9858457bfa19c5b9fe0d?cid=2da322cacb476a5b1341a14ae4d853e2). For troubleshooting and general tips, you can join the exercise at 06.05.
"""

# ╔═╡ 94b7f3fe-6d3e-11eb-279d-8bd23405df1e
md"""
Many mathematical and other objects can be represented by a tuples of numbers, for example space-time has 4 components, so has a RGB color with alpha channel. Each of these could naturally be represented by a tuple $(a, b, c, d)$ of four numbers.

If we stick to tuples, we have to remind ourselves what each of these represent. This is especially tricky if we have multiple tuples of the same size representing different objects, which look the same but should behave very differently.

In Julia we can distinguish between different types of objects with different behaviors by using its type system.
"""

# ╔═╡ b578d4a0-6d3e-11eb-2222-53b5b0acc974
md"""
## Types

Here, we are going to explore the basic concepts of Julia's type system by trying to represent quaternions, which are an extension to the complex numbers.

A quaternion is an expression of the form

$a+b\,\mathbf{i} +c\,\mathbf{j} +d\,\mathbf{k}$

where $a,b,c,d \in \mathbb R$ and $\mathbf{i}$, $\mathbf{j}$, $\mathbf{k}$, are symbols. 
"""

# ╔═╡ eaea1b8a-6d3e-11eb-1a6a-adc83cc2877f
md"""
Before we start, we need to familiarize ourself with Julia's [abstract types](https://docs.julialang.org/en/v1/manual/types/#man-abstract-types), which serve only as nodes in the type graph, thereby describing sets of related concrete types.

Recall that Julia has a number of primitive numeric types. These types are more than just a collection of object implementations. They form the conceptual hierarchy.
"""

# ╔═╡ c68c0b0e-6d3e-11eb-2cbe-7734bb315ab6
md"""
### Task 1

We can find the place of any type within this hierarchy by
"""

# ╔═╡ cab34cc4-6d3e-11eb-1e09-25246a7c339f
supertypes(Float64)

# ╔═╡ fad652ca-6d3e-11eb-25da-93b1b4bc3064
md"""
In this instance `Float64` is a subtype of `AbstractFloat`, which is a subtype of `Real`, and so on. We find that most of these types are abstract types.
"""

# ╔═╡ 2315066e-6d3f-11eb-22fa-85f51d8ba78a
isabstracttype.(supertypes(Float64))

# ╔═╡ 2645fa82-6d3f-11eb-2546-552bef005522
md"""
🎓 Find the first common supertype of `Float64` and `Int64` in the type hierarchy and assign it to `T1`.
"""

# ╔═╡ 32963018-6d3f-11eb-2985-978ef321da48
T1 = missing

# ╔═╡ 39e08cb0-6d3f-11eb-3f3a-2d1b723a3f04
md"""
🎓 Do the same for `UInt8` and `UInt16` and assign the result to `T2`.
"""

# ╔═╡ 485d19ac-6d3f-11eb-29e5-d31c7a47f7db
T2 = missing

# ╔═╡ a26c2d54-6d3f-11eb-2bb4-9ba311ef418c
md"""
We can also find the subtypes of any type.
"""

# ╔═╡ a87b9d5e-6d3f-11eb-3160-f9768bbfbc47
subtypes(Number)

# ╔═╡ ae251154-6d3f-11eb-0fa2-233b4f3ffd6f
md"""
If we want to make the best use of Julia's type system in our case we first create an `abstract type Quaternion end` and put it as a child node below the abstract type `Number` by adding `<: Number`.
"""

# ╔═╡ b3731c82-6d3f-11eb-17ae-db3acbc39f93
abstract type AbstractQuaternion <: Number end

# ╔═╡ b58a70b0-6d3f-11eb-38e0-49ea3a76cb9b
md"""
`Number` should now have an additional child and `Quaternion` is right next to `Real` and `Complex`.
"""

# ╔═╡ be6d559e-6d3f-11eb-2e40-1f00aa70680c
subtypes(Number)

# ╔═╡ d9ef2b14-6d3f-11eb-0a20-5fcfe5623b10
md"""
### Task 2

In order handle quaternions it is now time to make use of [composite types](https://docs.julialang.org/en/v1/manual/types/#Composite-Types).

🎓 Complete the definition of `struct SQuaternion <: AbstractQuaternion` by adding the fields `a`, `b`, `c` and `d`. Leave out type annotations for the fields for now.
"""

# ╔═╡ e154ed1a-6d3f-11eb-3156-3f5560929e13
struct SQuaternion <: AbstractQuaternion
end

# ╔═╡ e98cd524-6d3f-11eb-1b29-03b3342ad6f8
md"""
If done correctly the following two code blocks should assign an `SQuaternion` to `q1` and `q2`, respectively.
"""

# ╔═╡ ebf2e218-6d3f-11eb-1b7d-451e7484c541
q1 = SQuaternion(1.0,1.0,1.0,1.0)

# ╔═╡ f3a7f75a-6d3f-11eb-2861-451df65db481
q2 = SQuaternion(0.0,-1.0,-1.0,-1.0)

# ╔═╡ f4e2820e-6d3f-11eb-0a67-11e15b51a1eb
md"""
### Task 3

Now suppose we want to change the value of the first field of `q1` to zero.
"""

# ╔═╡ fc80e0a8-6d3f-11eb-01d5-2330c0abe84d
q1.a = 0.0

# ╔═╡ fd927fec-6d3f-11eb-2138-d5743cf4e6bc
md"""
Julia complains that fields of objects of type `Quaternion` cannot be modified. They are immutable, which is the standard behavior.

🎓 Use the `mutable` keyword to define a new mutable struct `MQuaternion` with the same fields as `Quaternion`.
"""

# ╔═╡ 02cdf05e-6d40-11eb-3676-a9a3999c2405
missing

# ╔═╡ 0ba4619a-6d40-11eb-3a5f-61c2629ede16
md"""
In this way we can alter the fields of a `MQuaternion`.
"""

# ╔═╡ 0fed6424-6d40-11eb-0e0e-6361a2111c71
let mq = MQuaternion(1.0,1.0,1.0,1.0)
	setfield!(mq,:a,0.0)
	mq.a == 0
end

# ╔═╡ 2d02edb6-6d40-11eb-3fbc-47c6c8f6db21
md"""
### Task 4

An important and powerful feature of Julia's type system are [parametric types](https://docs.julialang.org/en/v1/manual/types/#Parametric-Types). I.e. types can take parameters, so that type declarations actually introduce a whole family of new types.

As to why this is useful consider the following two code blocks.
"""

# ╔═╡ 319662c2-6d40-11eb-25cf-8354bde59197
SQuaternion("Hi",Complex(1.0,1),'c',1.0)

# ╔═╡ 34d025c2-6d40-11eb-14f1-3ba009438881
Complex("Hi",1)

# ╔═╡ 3881d0c4-6d40-11eb-1359-6d9cfd2442de
md"""
As you can see, we can initialize our `SQuaternion` with any combination of values, no matter their types. Contrary, the `Complex` type can only be initialized with real values.

This behavior originates from its definition as parametric type as shown [here](https://github.com/JuliaLang/julia/blob/master/base/complex.jl) and some additional constructor methods.
"""

# ╔═╡ 3c37d990-6d40-11eb-2cd7-a934e032eb0f
md"""
🎓 Use the definition of Complex numbers as a  template to define a parametric type `Quaternion`, which has the field type as parameter. Restrict this parameter to accept subtypes of `Real` only.
"""

# ╔═╡ 435d8cd8-6d40-11eb-1bde-3f145a4bcc41
missing

# ╔═╡ 47c7e002-6d40-11eb-0835-27bb3a89b5b7
md"""
## Single-Dispatch

In Julia we have the ability to write code that can operate on different types, which is called generic programming. Next, we will explore single-dispatch, which is when a method is polymorphic on the type of one parameter.
"""

# ╔═╡ 4c992230-6d40-11eb-2359-3734f8736dc2
md"""
### Task 5

A constructor is a special function that is called to create an object. The default constructor methods of `Quaternion` is

```julia
Quaternion(a::T, b::T, c::T, d::T) where T<:Real
```

E.g.
"""

# ╔═╡ 522d2746-6d40-11eb-193d-d5a3e0f6fce7
Quaternion(1.0,1.0,1.0,1.0)

# ╔═╡ 562b7faa-6d40-11eb-1243-cbd8ad5032f1
md"""
Next, consider the case, where we need to initialize quaternions with $b = c = d = 0$, e.g.
"""

# ╔═╡ 5ae0b7ae-6d40-11eb-165c-814e77209341
Quaternion(42.42,0.0,0.0,0.0)

# ╔═╡ 5bf1d09c-6d40-11eb-0c11-3b8c23d02237
md"""
To this end it would be nice to have a constructor, which allows
"""

# ╔═╡ 672dc4ac-6d40-11eb-3f23-7558cb630166
Quaternion(42.42)

# ╔═╡ 6bf4a0c8-6d40-11eb-2e2b-e79f21305788
md"""
Unless implemented by us, Julia will tell us that there is no method matching `Quaternion(::Float64)`.

🎓 Add a new constructor method `Quaternion(x::Float64)` to the definition of the Quaternion above. Due to limitations of the Pluto notebook struct definition and constructor methods must be defined inside the same `begin`-`end`-block.
"""

# ╔═╡ 9b595e9e-6d40-11eb-1623-4f1ea31b2795
md"""
### Task 6

Now that this problem is solved, what happens if we try to initialize a quaternion with a single precision number, instead of julia's standard double precision `Float64`?
"""

# ╔═╡ 9c7f77ae-6d40-11eb-1010-7f2719cb4c21
Quaternion(42.42f0)

# ╔═╡ a3934480-6d40-11eb-3c4d-4939c78dd46e
md"""
We get another error. This time there is no method matching Quaternion(::Float32).

Of cause we could add another method `Quaternion(x::Float32)`, however considering the vast number of numerical types this approach would be quite laborious. A better alternative is to make use of Julia's generic programming capabilities documented [here](https://docs.julialang.org/en/v1/manual/methods/#Parametric-Methods).

🎓 Add a new single argument constructor method to the definition of the Quaternion above, which works for all inputs with a type subtype to `Real`.
"""

# ╔═╡ a77859fa-6d40-11eb-1646-5b3c9bbf016b
md"""
### Task 7
To be precise, we have not really done any real dispatch at this point, since the last method implemented makes `Quaternion(x::Float64)` redundant.

🎓 Go on and check if the box for task 5 is still green after uncommenting the definition for `Quaternion(x::Float64)`
"""

# ╔═╡ ab581c22-6d40-11eb-18b7-1f1b763d9812
md"""
Next, let us consider the case, where we initialize quaternions from complex numbers

$x + y\,\mathbf{i}$

by mapping

$x + y\,\mathbf{i} \mapsto x + y\,\mathbf{i} + 0\,\mathbf{j} + 0\,\mathbf{k}.$

Right now this fails.
"""

# ╔═╡ 969546de-6d40-11eb-16f6-951ca8b43a0d
md"""
We have not yet defined a method to handle [complex numbers](https://docs.julialang.org/en/v1/manual/complex-and-rational-numbers/#Complex-Numbers) as input type.

🎓 Add a new single argument constructor method to the definition of the Quaternion above, which works for complex inputs. Take into account that `Complex{T<:Real}` is a parametric type. So make sure the method works for any specific instance of this type.
"""

# ╔═╡ cc90db52-6d40-11eb-007b-b5059f65f36d
md"""
## Multiple-Dispatch

Next, we will explore how to implement different behavior for a function depending on the types of multiple arguments. This is called multiple dispatch.

"""

# ╔═╡ d1b9511a-6d40-11eb-0a64-8710463c6877
md"""
### Task 8

To this end let us come back to our standard constructor method

```julia
Quaternion(a::T, b::T, c::T, d::T) where T<:Real
```

which only allows to construct a Quaternion, if all the input values have the same real type, e.g.
"""

# ╔═╡ d5498c5a-6d40-11eb-3f09-f12a2acd9e67
Quaternion(1.0,1.0,1.0,1.0)

# ╔═╡ d904fb86-6d40-11eb-2ce7-8518c06a206d
md"""
Without an additional constructor method to following will fail.
"""

# ╔═╡ dfa7cf66-6d40-11eb-2afc-17be33455809
Quaternion(1,1.0,1.0,1.0)

# ╔═╡ e37013c6-6d40-11eb-1537-ad536ec449fc
md"""
However, we can apply the generic programming paradigms used in the last section to multi-argument functions to solve this issue.


🎓 Add a new 4-argument constructor method to the definition of the Quaternion above, which works for all inputs, where each individual input type is a subtype of `Real`.
"""

# ╔═╡ e9b8bd0a-6d40-11eb-3b96-bb01cce4144c
begin
	import Base.:+
	missing
end

# ╔═╡ eafbf290-6d40-11eb-1979-f18ba55e3c45
Quaternion(1+im)

# ╔═╡ ee8ef628-6d40-11eb-1f33-4f255043e426
md"""
### Task 9

All of Julia's standard functions and operators, have many methods defining their behavior over various possible combinations of argument type and count. E.g. Julia's `+` function has $(length(methods(+))) methods, which can be listed by `methods(+)`.

By defining additional [methods](https://docs.julialang.org/en/v1/manual/methods/#Defining-Methods), you can specify the behavior of operators on programmer-defined types.

🎓 Extend the `+`-operator with a method for adding two `Quaternions` together. Quaternions are added component wise.
"""

# ╔═╡ f3509388-6d40-11eb-33a1-956efa2c304f
md"""
Now there is one method more, which will be used, whenever `+` is called by two quaternions. 
"""

# ╔═╡ f702b3bc-6d40-11eb-0618-e7ea2c756b49
md"""
### Task 10

So far we have been operating on our own type. In order to appreciate the elegance of Julia's type system and multiple-dispatch let us try to extend `+` such that we are able to add Julia's build in real parametric types to one of our quaternions. Currently, this will fail
"""

# ╔═╡ fb27e1ba-6d40-11eb-389b-75b3e4e2cb27
Quaternion(1,1,1,1) + 1

# ╔═╡ ffe4402a-6d40-11eb-3d1f-656e4782ac31
md"""
The short workaround is to simply add the missing method.

🎓 Add a method `+(q::Quaternion,x::Real)` for adding a real value and a quaternion into the block importing `+` above. Real numbers and quaternions add up by adding the real value to the first component of the quaternion.
"""

# ╔═╡ 05dabd76-6d41-11eb-2412-3ff7f509105b
md"""
### Task 11

Now let us put everything together and see if it works.

🎓 Initialize `p1` by the quadruple of numbers 1,1,1,0.
"""

# ╔═╡ 0ca8ec36-6d41-11eb-0be9-5faaec60182c
p1 = missing

# ╔═╡ 0de0fa44-6d41-11eb-16af-3523c547ea6c
md"""
🎓 Next, initialize `p2` by the complex number `1+im`.
"""

# ╔═╡ 14e4f124-6d41-11eb-2612-07d5aebf6f97
p2 = missing

# ╔═╡ 1890b9a2-6d41-11eb-3d63-97a86ac9d7f7
md"""
🎓 Add up `p1`, `p2` and the integer number `1` and appreciate, what you have done.
"""

# ╔═╡ 1bed7646-6d41-11eb-1d13-c576a1da76a9
p3 = missing

# ╔═╡ c067fdc8-6d40-11eb-3409-bdd5311ab6be
md"""
Live long and prosper🖖!
"""

# ╔═╡ 27c95794-6d41-11eb-007a-5b01469d7e4e
md"""
#### Notebook Helper Functions
"""

# ╔═╡ 424da5aa-6d41-11eb-0d16-ddfb6c15b0d9
begin
	hint(text) = Markdown.MD(Markdown.Admonition("hint", "Hint", [text]))
	not_defined(variable_name) = Markdown.MD(Markdown.Admonition("danger", "Oh, oh! 😱", [md"Variable **$(Markdown.Code(string(variable_name)))** is not defined. You should probably do something about this."]))
	still_missing(text=md"Replace `missing` with your solution.") = Markdown.MD(Markdown.Admonition("warning", "Let's go!", [text]))
	keep_working(text=md"The answer is not quite right.") = Markdown.MD(Markdown.Admonition("danger", "Keep working on it!", [text]))
	yays = [md"Great! 🥳", md"Correct! 👏", md"Tada! 🎉"]
	correct(text=md"$(rand(yays)) Let's move on to the next task.") = Markdown.MD(Markdown.Admonition("correct", "Got it!", [text]))
end;

# ╔═╡ 9a96cb1c-6d41-11eb-0cf0-4385ab882ac4
if !@isdefined(T1)
	not_defined(:T1)
elseif ismissing(T1)
	still_missing()
elseif typeof(T1) != DataType
	keep_working(md"`T1` has not been assigned a `DataType`.")
elseif T1 != Real
	keep_working(md"`T1` has not been assigned the correct `DataType`.")
else
	correct()
end

# ╔═╡ a736ee88-6d41-11eb-37b8-a3f0edd59cf2
if !@isdefined(T2)
	not_defined(:T2)
elseif ismissing(T2)
	still_missing()
elseif typeof(T2) != DataType
	keep_working(md"`T1` has not been assigned a `DataType`.")
elseif T2 != Unsigned
	keep_working(md"`T1` has not been assigned the correct `DataType`.")
else
	correct()
end

# ╔═╡ c7c130aa-6d41-11eb-1b5f-8b4d44cfe7b4
if !@isdefined(SQuaternion)
	not_defined(:SQuaternion)
elseif typeof(SQuaternion) != DataType
	keep_working(md"`SQuaternion` is defined as variable rather than as struct.")
elseif !hasfield(SQuaternion,:a)
	keep_working(md"`SQuaternion` is missing field `a`.")
elseif !hasfield(SQuaternion,:b)
	keep_working(md"`SQuaternion` is missing field `b`.")
elseif !hasfield(SQuaternion,:c)
	keep_working(md"`SQuaternion` is missing field `c`.")
elseif !hasfield(SQuaternion,:d)
	keep_working(md"`SQuaternion` is missing field `d`.")
else
	correct()
end

# ╔═╡ da978a30-6d41-11eb-34fb-19884b763a5f
if !@isdefined(MQuaternion)
	not_defined(:MQuaternion)
elseif typeof(MQuaternion) != DataType
	keep_working(md"`MQuaternion` is defined as variable rather than as struct.")
elseif !ismutable(MQuaternion)
	keep_working(md"`MQuaternion` is immutable.")
elseif !hasfield(MQuaternion,:a)
	keep_working(md"`MQuaternion` is missing field `a`.")
elseif !hasfield(MQuaternion,:b)
	keep_working(md"`MQuaternion` is missing field `b`.")
elseif !hasfield(MQuaternion,:c)
	keep_working(md"`MQuaternion` is missing field `c`.")
elseif !hasfield(MQuaternion,:d)
	keep_working(md"`MQuaternion` is missing field `d`.")
else
	correct()
end

# ╔═╡ e8467650-6d41-11eb-0b44-81a59345c17c
if !@isdefined(Quaternion)
	not_defined(:Quaternion)
elseif typeof(Quaternion) == DataType
	keep_working(md"`Quaternion` is no data type.")
elseif isconcretetype(Quaternion)
	keep_working(md"`Quaternion` is no parametric type.")
elseif !isconcretetype(Quaternion{Float64})
	keep_working(md"`Quaternion{Float64}` should be a concrete type.")
elseif !hasfield(Quaternion{Float64},:a)
	keep_working(md"`Quaternion` is missing field `a`.")
elseif !hasfield(Quaternion{Float64},:b)
	keep_working(md"`Quaternion` is missing field `b`.")
elseif !hasfield(Quaternion{Float64},:c)
	keep_working(md"`Quaternion` is missing field `c`.")
elseif !hasfield(Quaternion{Float64},:d)
	keep_working(md"`Quaternion` is missing field `d`.")
else
	correct()
end

# ╔═╡ f9182f00-6d41-11eb-3c60-1f46ba32f34d
if !@isdefined(Quaternion)
	not_defined(:Quaternion)
elseif typeof(Quaternion) == DataType
	keep_working(md"`Quaternion` is no parametric type.")
elseif !hasmethod(Quaternion, Tuple{Float64})
	keep_working(md"There is still no method `Quaternion(::Float64)`.")
else
	let x = rand()
		q = Quaternion(x)
		if q.a != x
			keep_working(md"Initialized quaternion is expected to have field value `a` being equal to input argument.")
		elseif q.b != 0
			keep_working(md"Initialized quaternion is expected to have field value `b` being equal to zero.")
		elseif q.c != 0
			keep_working(md"Initialized quaternion is expected to have field value `c` being equal to zero.")
		elseif q.d != 0
			keep_working(md"Initialized quaternion is expected to have field value `d` being equal to zero.")
		else
			correct()
		end
	end
end

# ╔═╡ 59a4327a-6d41-11eb-1dbc-2f5ec07dca1c
hint(md"For inspiration on how to define this method have a look into the source code of for [complex numbers](https://github.com/JuliaLang/julia/blob/master/base/complex.jl).")

# ╔═╡ 147cb838-6d42-11eb-1cd1-d73192c43748
if !@isdefined(Quaternion)
	not_defined(:Quaternion)
elseif typeof(Quaternion) == DataType
	keep_working(md"`Quaternion` is no parametric type.")
elseif !hasmethod(Quaternion, Tuple{Float32})
	keep_working(md"There is still no method `Quaternion(::Float32)`.")
elseif !hasmethod(Quaternion, Tuple{Int32})
	keep_working(md"There is still no method `Quaternion(::Int32)`.")
elseif !hasmethod(Quaternion, Tuple{UInt8})
	keep_working(md"There is still no method `Quaternion(::UInt8)`.")
else
	let x = rand(UInt8)
		q = Quaternion(x)
		if q.a != x
			keep_working(md"initialized quaternion is expected to have field value `a` being equal to input argument.")
		elseif q.b != 0
			keep_working(md"initialized quaternion is expected to have field value `b` being equal to zero.")
		elseif q.c != 0
			keep_working(md"initialized quaternion is expected to have field value `c` being equal to zero.")
		elseif q.d != 0
			keep_working(md"initialized quaternion is expected to have field value `d` being equal to zero.")
		else
			correct()
		end
	end
end


# ╔═╡ 262fe1ae-6d42-11eb-235e-2b55bd8bf15d
if !@isdefined(Quaternion)
	not_defined(:Quaternion)
elseif typeof(Quaternion) == DataType
	keep_working(md"`Quaternion` is no parametric type.")
elseif !hasmethod(Quaternion, Tuple{Complex{Float64}})
	keep_working(md"There is still no method `Quaternion(::Complex{Float64})`.")
elseif !hasmethod(Quaternion, Tuple{Complex{Int64}})
	keep_working(md"There is still no method `Quaternion(::Complex{Int64})`.")
elseif !hasmethod(Quaternion, Tuple{Complex{UInt8}})
	keep_working(md"There is still no method `Quaternion(::Complex{UInt8})`.")
else
	let x = rand(ComplexF64)
		q = Quaternion(x)
		if q.a != real(x)
			keep_working(md"Initialized quaternion is expected to have field value `a` being equal to real part of input argument.")
		elseif q.b != imag(x)
			keep_working(md"Initialized quaternion is expected to have field value `b` being equal to imaginary part of input argument.")
		elseif q.c != 0
			keep_working(md"Initialized quaternion is expected to have field value `c` being equal to zero.")
		elseif q.d != 0
			keep_working(md"Initialized quaternion is expected to have field value `d` being equal to zero.")
		else
			correct()
		end
	end
end

# ╔═╡ 6bcd7a5a-6d42-11eb-0d02-4be57722286a
if !@isdefined(Quaternion)
	not_defined(:Quaternion)
elseif typeof(Quaternion) == DataType
	keep_working(md"`Quaternion` is no parametric type.")
elseif !hasmethod(Quaternion, Tuple{Int64,Float64,UInt8,Float64})
	keep_working(md"There is still no method matching `Quaternion(::Int64, ::Float64, ::UInt8, ::Float64)`.")
else
	q = Quaternion(1,1.0,0x01,1.0)
	if q.a != 1
		keep_working(md"Initialized quaternion `Quaternion(1,1.0,0x01,1.0)` is expected to have field value `a` being equal to one.")
	elseif q.b != 1
		keep_working(md"Initialized quaternion `Quaternion(1,1.0,0x01,1.0)` is expected to have field value `b` being equal to one.")
	elseif q.c != 1
		keep_working(md"Initialized quaternion `Quaternion(1,1.0,0x01,1.0)` is expected to have field value `c` being equal to one.")
	elseif q.d != 1
		keep_working(md"Initialized quaternion `Quaternion(1,1.0,0x01,1.0)` is expected to have field value `d` being equal to one.")
	else
		correct()
	end
end

# ╔═╡ d41c1b3c-6d49-11eb-3116-cd8e65ddce3c
hint(md"For inspiration on how to define this method have a look into the source code of for [complex numbers](https://github.com/JuliaLang/julia/blob/master/base/complex.jl).")

# ╔═╡ f36c62ca-6d42-11eb-0c87-1b73e0dfb7f8
if !@isdefined(Quaternion)
	not_defined(:Quaternion)
elseif typeof(Quaternion) == DataType
	keep_working(md"`Quaternion` is no parametric type.")
elseif !hasmethod(+, Tuple{Quaternion{Float64},Quaternion{Float64}})
	keep_working(md"There is no method for adding up two `Quaternion{Float64}`.")
else
	let q = Quaternion(1,1,1,1), p = Quaternion(-1.0,-1.0,-1.0,-1.0)
		r = p+q
		if r.a == 0 && r.b == 0 && r.c == 0 && r.d == 0 
			correct()
		else
			keep_working(md"`q = Quaternion(1,1,1,1)` and `p = Quaternion(-1.0,-1.0,-1.0,-1.0)` do not add up to `Quaternion(0,0,0,0)`.")
		end
	end
end

# ╔═╡ 72b5b480-6d43-11eb-3da4-e9c3683f87d1
if !@isdefined(Quaternion)
	not_defined(:Quaternion)
elseif typeof(Quaternion) == DataType
	keep_working(md"`Quaternion` is no parametric type.")
elseif !hasmethod(+, Tuple{Quaternion{Int64},Int64})
	keep_working(md"There is no method for adding up a `Quaternion{Int64}` and `Int64`.")
else
	let q = Quaternion(1,1,1,1), x = -1
		r = q+x
		if r.a == 0 && r.b == 1 && r.c == 1 && r.d == 1 
			correct()
		else
			keep_working(md"`q = Quaternion(1,1,1,1)` and `x = -1` do not add up to `Quaternion(0,1,1,1)`.")
		end
	end
end

# ╔═╡ 6cdfee08-cdee-4e93-9585-d529dcde6e52
if !@isdefined(p1)
	not_defined(:p1)
elseif ismissing(p1)
	still_missing()
elseif !(typeof(p1)<:Quaternion)
	keep_working(md"`p1` needs to be a `Quaternion`.")
elseif p1.a != 1
	keep_working(md"`p1.a` is not equal to 1")
elseif p1.b != 1
	keep_working(md"`p1.b` is not equal to 1")
elseif p1.c != 1
	keep_working(md"`p1.c` is not equal to 1")
elseif p1.d != 0
	keep_working(md"`p1.d` is not equal to 0")
else
	correct()
end

# ╔═╡ 8f0e376f-d314-41d4-9f4e-c3673b3ca793
if !@isdefined(p2)
	not_defined(:p2)
elseif ismissing(p2)
	still_missing()
elseif !(typeof(p2)<:Quaternion)
	keep_working(md"`p2` needs to be a `Quaternion`.")
elseif p2.a != 1
	keep_working(md"`p2.a` is not equal to 1")
elseif p2.b != 1
	keep_working(md"`p2.b` is not equal to 1")
elseif p2.c != 0
	keep_working(md"`p2.c` is not equal to 0")
elseif p2.d != 0
	keep_working(md"`p2.d` is not equal to 0")
else
	correct()
end

# ╔═╡ 9cd03350-0e58-4b5d-8ec0-4294662937a2
if !@isdefined(p3)
	not_defined(:p3)
elseif ismissing(p3)
	still_missing()
elseif !(typeof(p3)<:Quaternion)
	keep_working(md"`p3` needs to be a `Quaternion`.")
elseif p3.a != 3
	keep_working(md"`p3.a` is not equal to 3")
elseif p3.b != 2
	keep_working(md"`p3.b` is not equal to 2")
elseif p3.c != 1
	keep_working(md"`p3.c` is not equal to 1")
elseif p3.d != 0
	keep_working(md"`p1.d` is not equal to 0")
else
	correct()
end

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
PlutoUI = "~0.7.37"
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

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "024fe24d83e4a5bf5fc80501a314ce0d1aa35597"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.0"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

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

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "3c837543ddb02250ef42f4738347454f95079d4e"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.3"

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
# ╟─7e20e0ba-6d3e-11eb-3a05-93a480b44495
# ╠═2f61761a-6f14-11eb-3249-6f2fd9f0c645
# ╟─94b7f3fe-6d3e-11eb-279d-8bd23405df1e
# ╟─b578d4a0-6d3e-11eb-2222-53b5b0acc974
# ╟─eaea1b8a-6d3e-11eb-1a6a-adc83cc2877f
# ╟─c68c0b0e-6d3e-11eb-2cbe-7734bb315ab6
# ╠═cab34cc4-6d3e-11eb-1e09-25246a7c339f
# ╟─fad652ca-6d3e-11eb-25da-93b1b4bc3064
# ╠═2315066e-6d3f-11eb-22fa-85f51d8ba78a
# ╟─2645fa82-6d3f-11eb-2546-552bef005522
# ╠═32963018-6d3f-11eb-2985-978ef321da48
# ╟─9a96cb1c-6d41-11eb-0cf0-4385ab882ac4
# ╟─39e08cb0-6d3f-11eb-3f3a-2d1b723a3f04
# ╠═485d19ac-6d3f-11eb-29e5-d31c7a47f7db
# ╟─a736ee88-6d41-11eb-37b8-a3f0edd59cf2
# ╟─a26c2d54-6d3f-11eb-2bb4-9ba311ef418c
# ╠═a87b9d5e-6d3f-11eb-3160-f9768bbfbc47
# ╟─ae251154-6d3f-11eb-0fa2-233b4f3ffd6f
# ╠═b3731c82-6d3f-11eb-17ae-db3acbc39f93
# ╟─b58a70b0-6d3f-11eb-38e0-49ea3a76cb9b
# ╠═be6d559e-6d3f-11eb-2e40-1f00aa70680c
# ╟─d9ef2b14-6d3f-11eb-0a20-5fcfe5623b10
# ╠═e154ed1a-6d3f-11eb-3156-3f5560929e13
# ╟─c7c130aa-6d41-11eb-1b5f-8b4d44cfe7b4
# ╟─e98cd524-6d3f-11eb-1b29-03b3342ad6f8
# ╠═ebf2e218-6d3f-11eb-1b7d-451e7484c541
# ╠═f3a7f75a-6d3f-11eb-2861-451df65db481
# ╟─f4e2820e-6d3f-11eb-0a67-11e15b51a1eb
# ╠═fc80e0a8-6d3f-11eb-01d5-2330c0abe84d
# ╟─fd927fec-6d3f-11eb-2138-d5743cf4e6bc
# ╠═02cdf05e-6d40-11eb-3676-a9a3999c2405
# ╟─da978a30-6d41-11eb-34fb-19884b763a5f
# ╟─0ba4619a-6d40-11eb-3a5f-61c2629ede16
# ╠═0fed6424-6d40-11eb-0e0e-6361a2111c71
# ╟─2d02edb6-6d40-11eb-3fbc-47c6c8f6db21
# ╠═319662c2-6d40-11eb-25cf-8354bde59197
# ╠═34d025c2-6d40-11eb-14f1-3ba009438881
# ╟─3881d0c4-6d40-11eb-1359-6d9cfd2442de
# ╟─3c37d990-6d40-11eb-2cd7-a934e032eb0f
# ╠═435d8cd8-6d40-11eb-1bde-3f145a4bcc41
# ╟─e8467650-6d41-11eb-0b44-81a59345c17c
# ╟─47c7e002-6d40-11eb-0835-27bb3a89b5b7
# ╟─4c992230-6d40-11eb-2359-3734f8736dc2
# ╠═522d2746-6d40-11eb-193d-d5a3e0f6fce7
# ╟─562b7faa-6d40-11eb-1243-cbd8ad5032f1
# ╠═5ae0b7ae-6d40-11eb-165c-814e77209341
# ╟─5bf1d09c-6d40-11eb-0c11-3b8c23d02237
# ╠═672dc4ac-6d40-11eb-3f23-7558cb630166
# ╟─6bf4a0c8-6d40-11eb-2e2b-e79f21305788
# ╟─f9182f00-6d41-11eb-3c60-1f46ba32f34d
# ╟─59a4327a-6d41-11eb-1dbc-2f5ec07dca1c
# ╟─9b595e9e-6d40-11eb-1623-4f1ea31b2795
# ╠═9c7f77ae-6d40-11eb-1010-7f2719cb4c21
# ╟─a3934480-6d40-11eb-3c4d-4939c78dd46e
# ╟─147cb838-6d42-11eb-1cd1-d73192c43748
# ╟─a77859fa-6d40-11eb-1646-5b3c9bbf016b
# ╟─ab581c22-6d40-11eb-18b7-1f1b763d9812
# ╟─969546de-6d40-11eb-16f6-951ca8b43a0d
# ╟─262fe1ae-6d42-11eb-235e-2b55bd8bf15d
# ╠═eafbf290-6d40-11eb-1979-f18ba55e3c45
# ╟─cc90db52-6d40-11eb-007b-b5059f65f36d
# ╟─d1b9511a-6d40-11eb-0a64-8710463c6877
# ╠═d5498c5a-6d40-11eb-3f09-f12a2acd9e67
# ╟─d904fb86-6d40-11eb-2ce7-8518c06a206d
# ╠═dfa7cf66-6d40-11eb-2afc-17be33455809
# ╟─e37013c6-6d40-11eb-1537-ad536ec449fc
# ╟─6bcd7a5a-6d42-11eb-0d02-4be57722286a
# ╟─d41c1b3c-6d49-11eb-3116-cd8e65ddce3c
# ╟─ee8ef628-6d40-11eb-1f33-4f255043e426
# ╠═e9b8bd0a-6d40-11eb-3b96-bb01cce4144c
# ╟─f36c62ca-6d42-11eb-0c87-1b73e0dfb7f8
# ╟─f3509388-6d40-11eb-33a1-956efa2c304f
# ╟─f702b3bc-6d40-11eb-0618-e7ea2c756b49
# ╠═fb27e1ba-6d40-11eb-389b-75b3e4e2cb27
# ╟─ffe4402a-6d40-11eb-3d1f-656e4782ac31
# ╟─72b5b480-6d43-11eb-3da4-e9c3683f87d1
# ╟─05dabd76-6d41-11eb-2412-3ff7f509105b
# ╠═0ca8ec36-6d41-11eb-0be9-5faaec60182c
# ╟─6cdfee08-cdee-4e93-9585-d529dcde6e52
# ╟─0de0fa44-6d41-11eb-16af-3523c547ea6c
# ╠═14e4f124-6d41-11eb-2612-07d5aebf6f97
# ╟─8f0e376f-d314-41d4-9f4e-c3673b3ca793
# ╟─1890b9a2-6d41-11eb-3d63-97a86ac9d7f7
# ╠═1bed7646-6d41-11eb-1d13-c576a1da76a9
# ╟─9cd03350-0e58-4b5d-8ec0-4294662937a2
# ╟─c067fdc8-6d40-11eb-3409-bdd5311ab6be
# ╟─27c95794-6d41-11eb-007a-5b01469d7e4e
# ╟─424da5aa-6d41-11eb-0d16-ddfb6c15b0d9
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
