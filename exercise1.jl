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

# ╔═╡ 96ec00fc-6f14-11eb-329e-19e4835643db
begin
	using PlutoUI
	
	PlutoUI.TableOfContents()
end

# ╔═╡ fec108ca-6f97-11eb-06d9-6fe1646f8b98
using Plots

# ╔═╡ 349d7534-6212-11eb-2bc5-db5be39b6bb6
md"""
# Scientific Programming - Basic Programming Concepts in Julia

[Institute for Biomedical Imaging](https://www.tuhh.de/ibi/home.html), Hamburg University of Technology

* 👨‍🏫 Prof. Dr.-Ing. Tobias Knopp
* 👨‍🏫 Dr. rer. nat. Martin Möddel

The due date of this exercise is 26.04 at 0:00. Please submit your solution to [Stud.IP](https://e-learning.tuhh.de/studip/dispatch.php/course/files/index/031251f16bdb9858457bfa19c5b9fe0d?cid=2da322cacb476a5b1341a14ae4d853e2). For troubleshooting and general tips, you can join the exercise at 22.04.
"""

# ╔═╡ 237ef27e-6266-11eb-3cf4-1b2223eabfd9
md"
## Assignment Statements

An assignment statement creates a new variable and assigns a value to it. E.g.
"

# ╔═╡ 6c060eec-6266-11eb-0b23-e5be08d78823
text = "Hello World!"

# ╔═╡ 830c9ed0-6266-11eb-27ba-07773c842fed
md"""
assigns `"Hello World!"` to the variable `text`.

Variable names can be as long as you like. They can contain almost all Unicode characters, but must not begin with a number. It is allowed to use upper case letters, but it is common to use only lower case letters for variable names.
"""

# ╔═╡ f4270146-6216-11eb-391e-01a476fcfccd
md"### Task 1
🎓 Assign the number `10` to the Variable `n`.
"

# ╔═╡ b5fff126-6215-11eb-1018-bd2e4f638f65
n = 10

# ╔═╡ 3249157e-6267-11eb-3dca-8949d7c0e3c9
md"
### Task 2

Unicode characters can be entered using the tab completion of $\mathrm{\LaTeX}$-like abbreviations.

🎓 Assign a value to the Unicode character for the small alpha.
"

# ╔═╡ ce1d05da-6267-11eb-136c-23c5c54a1559
 α =1

# ╔═╡ 1695a810-6268-11eb-3932-fb8885097f70
md"""
## Arithmetic Operators

Arithmetic operations such as addition, subtraction, multiplication, division, and exponentiation can be performed by the operators `+`, `-`, `*`, `/`, and `^`, respectively. E.g.
"""

# ╔═╡ 77cefbd4-662e-11eb-1b1d-91da61cc3823
a1 = 2+2

# ╔═╡ 88776120-662e-11eb-1542-fd26e4f126b1
md"""
stores the result of $2+2$ in the variable `a1`. A full list of supported operations can be found [here](https://docs.julialang.org/en/v1/manual/mathematical-operations/).
"""

# ╔═╡ 874a1a5c-6632-11eb-2705-e914f01b9762
md"""
For mathematical operators, Julia follows mathematical conventions. Therefore, the following two expressions are equivalent.
"""

# ╔═╡ 812bbd7e-6632-11eb-29f8-3f48329f0ac9
2*a1

# ╔═╡ aeaa97ae-6632-11eb-0ea2-7febd8b3e965
2a1

# ╔═╡ b0d35a9a-662e-11eb-34f5-c9a5fd9bb9a6
md"
### Task 3

🎓 Calculate $2^8$ with Julia and store the result in the variable `a2`.
"

# ╔═╡ d285737a-662f-11eb-390e-1d1e2437de71
a2 = 2^8

# ╔═╡ 5d04cbea-6630-11eb-3bee-c182aa912653
md"
### Task 4

When an expression contains more than one operator, the order of evaluation depends on the operator precedence.

🎓 Make use of parentheses `()` to group addition and exponentiation correctly to calculate $2^{4+4}$ with Julia and store the result in the variable `a3`.
"

# ╔═╡ 0ae0cf56-6632-11eb-262a-191ea74ec517
a3 = 2^(4+4)

# ╔═╡ 0fe8c31e-663a-11eb-1acb-17d3d7615e64
md"""
## Functions

In Julia, a function is an object that maps a tuple of argument values to a return value. They are not pure mathematical functions, because they can alter and be affected by the global state of the program. 

The basic syntax for defining functions in Julia is:
"""

# ╔═╡ 478dde3c-663a-11eb-3244-e7449c93b3a5
function f(x,y)
     return x + y
end

# ╔═╡ 68f2b1b0-663a-11eb-1b6d-b176d905f65b
md"
### Task 5

🎓 Write a function `double(x)` that multiplies its input argument by 2.
"

# ╔═╡ 8d509116-663b-11eb-0e98-dd27598740fe
function double(x)
	return 2 * x
end

# ╔═╡ 06c9bcec-663d-11eb-3062-85c0983a79eb
md"""
## Conditional Evaluation

Conditional evaluation allows portions of code to be evaluated or not evaluated depending on the value of a boolean expression. 

### Task 6

Read the julia documentation on [Conditional Evaluation](https://docs.julialang.org/en/v1/manual/control-flow/#man-conditional-evaluation)

🎓 Define the Heaviside step function `heaviside(x)`, whose value is `0` for negative arguments and `1` for non-negative arguments. 
"""

# ╔═╡ 9fd96950-6651-11eb-25f7-c964ab504b4a
function heaviside(x)
	if x >= 0
		return 1
	else 
		return 0
	end
end

# ╔═╡ 34824462-6654-11eb-2b38-19d14aa309af
md"""
## Iteration

There are two constructs for repeated evaluation of expressions: the while loop and the for loop. Both are documented [here](https://docs.julialang.org/en/v1/manual/control-flow/#man-loops).

### Task 7

A prime number is only evenly divisible by itself and 1.

🎓 Implement a function `isprime(x)` that returns `true` for any prime input and `false` else. 
"""

# ╔═╡ 6895356c-6655-11eb-3849-b3fa387df754
function isprime(x) 
	if x == 1
		return false
	end
	for i = 1:(x-1) 
		if  (i != 1 && mod(x,i)==0)
			return false
		end
	end 
return true
end

# ╔═╡ 9687bc24-666c-11eb-3b1e-edb5c448bad8
md"""
If you have trouble figuring out a solution you may find this hint helpful. However, first try solving the problem on your own!
"""

# ╔═╡ 9d3e9a92-6469-11eb-2952-b37367644c48
md"""
## Primitive Numeric Types

In the documentation on [Integers and Floating-Point Numbers](https://docs.julialang.org/en/v1/manual/integers-and-floating-point-numbers/#Integers-and-Floating-Point-Numbers) we find:

> Julia provides a broad range of primitive numeric types, and a full complement of arithmetic and bitwise operators as well as standard mathematical functions are defined over them. These map directly onto numeric types and operations that are natively supported on modern computers, thus allowing Julia to take full advantage of computational resources.

You can inspect the type of any variable or value by using the `typeof` function
"""

# ╔═╡ f3cd5320-66d6-11eb-191c-4b4d8cba940d
typeof(1)

# ╔═╡ f5805956-66d6-11eb-04e8-b1faae8f0d3c
typeof(1.0)

# ╔═╡ c72359f4-66d7-11eb-395f-b3a1983a6eea
typeof(1+1.0)

# ╔═╡ bdea6774-66d7-11eb-1c62-8f0e935f98ef
md"""
### Task 8
🎓 Take a look into the documentation and assign an 8-bit unsigned integer of any value to the variable `m`. 
"""

# ╔═╡ fb73ea0c-66d7-11eb-001c-23033aee228a
m = typemax(UInt8)

# ╔═╡ 2b99da2c-666d-11eb-1c64-337654a9d8f2
md"""
## Ranges

In Julia one can use range objects to represent a sequence of numbers. These can then be used to iterate through a loop. E.g.
"""

# ╔═╡ d39fbca0-66db-11eb-1aae-7b29f559cb01
for i in 1:5
	continue # this does nothing and skips to the next iteration
end

# ╔═╡ 1bcd317c-66e8-11eb-10df-c132d5f79155
md"""
### Task 9
🎓 Use a range object to sum up all values from `1` to `n` in the function `sumup(n)`.
"""

# ╔═╡ 66c4f3fc-66db-11eb-0927-ebe1d40eeb3b
function sumup(n)
	x=0
	for i = 1 : n
		x+=i
	end 
	return x
end

# ╔═╡ 575d9e52-6468-11eb-2f95-63cd3920f91a
md"""
## Vectors

Often we want to store and process multiple values. In Julia one can combine a a sequence of values of any type into a vector.

There are several ways to create a new array, the simplest is to enclose the elements in square brackets.
"""

# ╔═╡ 2e6c3c30-66e6-11eb-10f0-ddaa1752cff9
["first element",2,3.0]

# ╔═╡ d701d778-66e7-11eb-16c2-ab49fc06e992
md"""
### Task 10
🎓 Create a vector `v` containing the numbers 1 to 10 in ascending order. 
"""

# ╔═╡ 055baa32-66e7-11eb-20fc-575565bda51b
v = 1:10

# ╔═╡ 91c222ea-66e6-11eb-28ce-c1f1424525c8
md"""
## Comprehensions

[Comprehensions](https://docs.julialang.org/en/v1/manual/arrays/#man-comprehensions) provide a general and powerful way to construct arrays. Comprehension syntax is similar to set construction notation in mathematics.
"""

# ╔═╡ b5db566a-66e6-11eb-35fb-17d3fc4e258c
A = [π*i for i in 1:5]

# ╔═╡ a44eb7ea-66e9-11eb-10fa-2b0936b9f489
md"""
### Task 11
🎓 Create a vector `w` containing the numbers 2,4,6,... to 1000 in ascending order. 
"""

# ╔═╡ d8f306ca-66e9-11eb-3728-156d0328250b
w = [2*i for i in 1:500]

# ╔═╡ 673cc322-666e-11eb-107f-2b9bd6826ad5
md"""
## Broadcasting

[Broadcasting](https://docs.julialang.org/en/v1/manual/arrays/#Broadcasting) enables the convenient vectorization of mathematical and other operations. To this end Julia provides the dot syntax, e.g.
"""

# ╔═╡ 1bf921be-66eb-11eb-089a-97dfe9418b32
sin.(A)

# ╔═╡ 455d0b7c-66eb-11eb-3167-4b204ac741a5
md"""
for element wise operations over arrays
"""

# ╔═╡ 529a7324-66eb-11eb-0c1f-c37639e37a6e
md"""
### Task 12
🎓 Use the dot syntax to divide all elements of `A` by π and store the result in the variable `B`. 
"""

# ╔═╡ a87e36c4-66eb-11eb-223e-a1b077dca672
B = broadcast(/,A,π )

# ╔═╡ 0aa99f86-6f97-11eb-2141-2d35c3e0857d
md"""
## Julia eco system

Julia has a wide ecosystem of packages, maintained by a wide variety of people. In the best of academic ideals, Julia users from across the world come together to create mutually compatible and supporting packages for their domains. To manage these collections of packages they often use GitHub organizations and various other communication channels, most also have channels on the main Julia Slack channel, and sub-forums on the main Julia Discourse forum (see [Community](https://discourse.julialang.org/)).

### Pkg 
Pkg is Julia's built-in package manager and handles operations such as installing, updating and removing packages.

As long as we are working within these Pluto notebooks package installation will be handled in the background. We can start `using` methods and objects exported by packages by
"""

# ╔═╡ 1559f57e-6f98-11eb-3539-1b1ae82c439b
md"""
## Plotting

[Plots](https://github.com/JuliaPlots/Plots.jl) is a visualization interface and tool set. It sits above other backends, like GR, PyPlot, PGFPlotsX, or Plotly, connecting commands with implementation. If one backend does not support your desired features or make the right trade-offs, you can just switch to another backend with one command. No need to change your code. No need to learn a new syntax.

The goals with the package are:

* Powerful. Do more with less. Complex visualizations become easy.
* Intuitive. Start generating plots without reading volumes of documentation. Commands should "just work."
* Concise. Less code means fewer mistakes and more efficient development and analysis.
* Consistent. Don't commit to one graphics package. Use the same code and access the strengths of all backends.

A `Plots` cheat sheet is available [here](https://github.com/sswatson/cheatsheets/blob/master/plotsjl-cheatsheet.pdf).
"""

# ╔═╡ 36e6783c-6f98-11eb-0b09-db56907e370d
md"""
### Task 13

Data are supplied to the `plot` function as arguments (`x`, or `x`,`y`, or `x`,`y`,`z`). To this end let us consider the following arguments
"""

# ╔═╡ 3f4422ce-6f98-11eb-111f-4d1624a326c7
begin
	x = range(0,2π,length=100)
	y = map(sin,x)
	z = map(cos,x)
end;

# ╔═╡ 50cc4f32-6f98-11eb-25a4-ebaf581955ea
plot(x)

# ╔═╡ 5733a026-6f98-11eb-1b50-c75f87fbabe5
plot(x,y,z)

# ╔═╡ 6824d1f2-6f98-11eb-12f1-adf1271af917
md"""
Arguments are interpreted flexibly. We have already seen that we can plot `x`, which is no `Vector`, but an iterable object.

🎓 Plot the `exp` function over the range given by `x` by passing `x` and `exp` directly.
"""


# ╔═╡ 6b497cf9-be7e-4bce-8da2-9b543a267943
plot(map(exp,x))

# ╔═╡ 77d17b00-6f98-11eb-37ad-dd347db13fb3
md"""
### Task 14
Data can be plotted together as series, as is the default. There are different series types available to change the way the data is visualized.

🎓 This can be achieved by using the `seriestype` keyword argument. Taker your time and explore the different `seriestype` options listed.
"""

# ╔═╡ 8b852fd4-6f98-11eb-1b3a-7ff47c51e99e
@bind seriestype1 Select(["line" => :line,"path" => :path, "steppre" => :steppre, "steppost" => :steppost, "sticks" => :sticks, "scatter" => :scatter])

# ╔═╡ 8f566768-6f98-11eb-20ae-45d6f39cd210
plot(y,z,
	seriestype=seriestype1,
	label="label")

# ╔═╡ 961e9cd2-6f98-11eb-362c-517edab85a8c
md"""
We can modify [attributes](https://docs.juliaplots.org/latest/attributes/) of a plot by passing keyword arguments (for example, `plot(y, color = :blue)`). 

🎓 Add a label to the plot above using the keyword `label`. Pass the `String` `"circle"` to the argument.
"""

# ╔═╡ a32f2a4a-6f98-11eb-18f9-efb51aac288c
plot(y,z,
	seriestype=seriestype1,
	label="circle")

# ╔═╡ acc530cc-6f98-11eb-330e-077fcaf5bd62
md"""
### Task 15

In most cases, passing a (`n` × `m`) matrix of values (numbers, etc) will create `m` series, each with `n` data points.

🎓 Take your time and explore how the different options affect the plot.
"""

# ╔═╡ e5ca1bf8-6f98-11eb-1bd9-6f2f1fbe55c9
# 100 data points in 4 series
yseries = [sin.(x) cos.(x) 2sin.(x) 2cos.(x)]

# ╔═╡ eba05204-6f98-11eb-1e7c-4f7b49962f23
@bind seriestype2 Select(["line" => :line,"path" => :path, "steppre" => :steppre, "steppost" => :steppost, "sticks" => :sticks, "scatter" => :scatter])

# ╔═╡ f22b7874-6f98-11eb-0417-1de0d171c4ad
plot(yseries,z, seriestype=seriestype2)

# ╔═╡ f8265ba4-6f98-11eb-3938-0b38b2b93285
md"""
We can pass attributes for each element in a series by passing a row vector

🎓 Add a labels `["circle" "ellipse" "line1" "line2"]` to the plot above.
"""

# ╔═╡ fd8522ec-6f98-11eb-0a3c-01a91ee48de9
plot(yseries,z, seriestype=seriestype2, label =["circle" "line1" "ellipse" "line2"])

# ╔═╡ 0cce95b2-6f99-11eb-1161-1d446c3bbe44
md"""
### Task 16

Using Plots we can also visualize rectangular data arrays using the heatmap function. This could be a map of temperatures, or population density for example. 

Here a simple academic example of such an array
"""

# ╔═╡ 1a12d5a8-6f99-11eb-0e46-1529f881a3b0
begin
	function pyramid(x,y)
		u = abs(x)
		v = abs(y)
		return (1-max(u,v))
	end
	
	xs = -1.95:0.1:1.95
	ys = -1.95:0.1:1.95
	zs = [pyramid(x,y) for x in xs, y in ys]
end;

# ╔═╡ 214ce458-6f99-11eb-0963-7965b5fba93a
md"""
and its visualization
"""

# ╔═╡ 29efc990-6f99-11eb-0633-63fb74c5bebf
heatmap(xs,ys,zs)

# ╔═╡ 2f3b762e-6f99-11eb-12f0-2d42ed8237e0
md"""
Colorizing images helps the human visual system pick out detail, estimate quantitative values, and notice patterns in data in a more intuitive fashion. However, the choice of color map can have a significant impact on a given task.

To this end `Plots` has a very large number of color maps available. A complete list of readily available schemes can be found [here](https://docs.juliaplots.org/latest/generated/colorschemes/).

🎓 Explore the different color maps. Do they influence your perception of the linear rise flanks of the pyramid?
"""

# ╔═╡ 372fa56c-6f99-11eb-115d-275699f1c05c
begin
	colors = Dict("viridis" => :viridis, "blackbody" => :blackbody, "temperaturemap" => :temperaturemap, "thermometer" => :thermometer, "turbo" => :turbo, "vangogh" => :vangogh, "vermeer" => :vermeer, "pastel" => :pastel, "coffee" => :coffee);
	@bind cname Select(collect(keys(colors)))
end

# ╔═╡ 473b6dec-6f99-11eb-04f0-07006f1996ba
heatmap(xs, ys, zs,
	c = colors[cname],
	xlims = (-2,2),
	ylims = (-2,2),
	aspect_ratio = 1,
	xlabel = "x",
	ylabel = "y"
)

# ╔═╡ d760869e-6212-11eb-09d4-5f40a0edc641
md"""
#### Notebook Helper Functions
"""

# ╔═╡ bf493588-6f14-11eb-3ddf-b7ce036aff36
begin
	hint(text) = Markdown.MD(Markdown.Admonition("hint", "Hint", [text]))
	not_defined(variable_name) = Markdown.MD(Markdown.Admonition("danger", "Oh, oh! 😱", [md"Variable **$(Markdown.Code(string(variable_name)))** is not defined. You should probably do something about this."]))
	still_missing(text=md"Replace `missing` with your solution.") = Markdown.MD(Markdown.Admonition("warning", "Let's go!", [text]))
	keep_working(text=md"The answer is not quite right.") = Markdown.MD(Markdown.Admonition("danger", "Keep working on it!", [text]));
	yays = [md"Great! 🥳", md"Correct! 👏", md"Tada! 🎉"]
	correct(text=md"$(rand(yays)) Let's move on to the next task.") = Markdown.MD(Markdown.Admonition("correct", "Got it!", [text]))
end;

# ╔═╡ b9dbaf62-6215-11eb-3a7d-0b882b1a10b0
if !@isdefined(n)
	not_defined(:n)
elseif ismissing(n)
	still_missing()
elseif !(n isa Number)
	keep_working(md"`n` has not been assigned a number.")
elseif n != 10
	keep_working(md"`n` has been assigned the wrong value.")
else
	correct()
end

# ╔═╡ cf933c04-6267-11eb-3317-ed1a42e8c64e
if !@isdefined(α)
	not_defined(:α)
else
	correct()
end

# ╔═╡ de2a045c-662f-11eb-1d80-65fe7d8e0db3
if !@isdefined(a2)
	not_defined(:a2)
elseif ismissing(a2)
	still_missing()
elseif !(a2 isa Number)
	keep_working(md"`a2` has not been assigned a number.")
elseif a2 != 256
	keep_working(md"`a2` has been assigned the wrong value.")
else
	correct()
end

# ╔═╡ f279b1ee-6631-11eb-0809-bf0699c636f2
if !@isdefined(a3)
	not_defined(:a3)
elseif ismissing(a3)
	still_missing()
elseif !(a3 isa Number)
	keep_working(md"`a3` has not been assigned a number.")
elseif a3 != 256
	keep_working(md"`a3` has been assigned the wrong value.")
else
	correct()
end

# ╔═╡ bb8694b8-663b-11eb-03a1-49713346bdf3
let x = rand()
	if !@isdefined(double)
		not_defined(:double)
	elseif !hasmethod(double,Tuple{Int})
		keep_working(md"No method `double` with a single input argument defined.")
	elseif ismissing(double(0))
		still_missing()
	elseif double(0) !=0 || double(x) != 2x
		keep_working(md"`double(x)` does not return twice its value.")
	else
		correct()
	end
end

# ╔═╡ de2903cc-6652-11eb-30c3-7114b15fa6e1
if !@isdefined(heaviside)
	not_defined(:heaviside)
elseif ismissing(heaviside(0))
	still_missing()
elseif heaviside(0) !=1
	keep_working(md"`heaviside(0)` does not return 1.")
elseif heaviside(-1) != 0
	keep_working(md"`heaviside(-1)` does not return 0")
elseif heaviside(1) != 1
	keep_working(md"`heaviside(0)` does not return 1.")
else
	correct()
end

# ╔═╡ 6b9a4b64-6656-11eb-10ce-7b4a8b3cd6a4
if !@isdefined(isprime)
	not_defined(:isprime)
elseif ismissing(isprime(1))
	still_missing()
elseif typeof(isprime(1)) != Bool
	keep_working(md"`isprime(1)` does return neither `true` or `false`.")
elseif isprime(1)
	keep_working(md"`isprime(1)` does not return `false`.")
elseif !isprime(2)
	keep_working(md"`isprime(2)` does not return `true`.")
elseif !isprime(2)
	keep_working(md"`isprime(3)` does not return `true`.")
elseif isprime(4)
	keep_working(md"`isprime(4)` does not return `false`.")
elseif !isprime(999331)
	keep_working(md"`isprime(999331)` does not return `true`.")
else
	correct()
end

# ╔═╡ a4a9afe4-6656-11eb-0664-83cb32ce934b
hint(md"Take a look at the documentations of the functions `rem` and `sqrt`. They might be helpful.")

# ╔═╡ 07491ca8-66d8-11eb-3304-99f911b4bd1d
if !@isdefined(m)
	not_defined(:m)
elseif ismissing(m)
	still_missing()
elseif !(m isa UInt8)
	keep_working(md"`m` is not assigned a 8-bit unsigned integer.")
else
	correct()
end

# ╔═╡ 2c63db0a-66dc-11eb-1a45-7902d591c3e1
if !@isdefined(sumup)
	not_defined(:sumup)
elseif ismissing(sumup(0))
	still_missing()
elseif sumup(0) != 0
	keep_working(md"`sumup(0)` is expected to return 0.")
elseif sumup(100) != 5050
	keep_working(md"`sumup(100)` is expected to return 5050.")
else
	correct()
end

# ╔═╡ 6a3905f4-66e6-11eb-0607-5534821caee6
if !@isdefined(v)
	not_defined(:v)
elseif ismissing(v)
	still_missing()
elseif !(typeof(v) <: AbstractVector)
	keep_working(md"`v` is no vector.")
elseif diff(v) != ones(9) || v[1] != 1
	keep_working(md"`v` does not seem to contain the numbers 1 to 10.")
else
	correct()
end

# ╔═╡ 2561d38a-66ea-11eb-10ab-27db1a87970b
if !@isdefined(w)
	not_defined(:w)
elseif ismissing(w)
	still_missing()
elseif !(typeof(w) <: AbstractVector)
	keep_working(md"`w` is no vector.")
elseif diff(w) != 2*ones(499) || w[1] != 2
	keep_working(md"`w` does not seem to contain the numbers 2,4,6,... to 1000.")
else
	correct()
end

# ╔═╡ b135affc-66eb-11eb-188b-a32ef1478ee6
if !@isdefined(B)
	not_defined(:B)
elseif ismissing(B)
	still_missing()
elseif !(typeof(B) <: AbstractVector)
	keep_working(md"`B` is no vector.")
elseif diff(B) != ones(4) || B[1] != 1
	keep_working(md"`B` is expected to contain 1,2,3,4,5.")
else
	correct()
end

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
Plots = "~1.27.2"
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

[[deps.Adapt]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "af92965fb30777147966f58acb05da51c5616b5f"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "3.3.3"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "19a35467a82e236ff51bc17a3a44b69ef35185a2"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+0"

[[deps.Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "4b859a208b2397a7a623a03449e4636bdb17bcf2"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.16.1+1"

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

[[deps.ColorSchemes]]
deps = ["ColorTypes", "Colors", "FixedPointNumbers", "Random"]
git-tree-sha1 = "12fc73e5e0af68ad3137b886e3f7c1eacfca2640"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.17.1"

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

[[deps.Compat]]
deps = ["Base64", "Dates", "DelimitedFiles", "Distributed", "InteractiveUtils", "LibGit2", "Libdl", "LinearAlgebra", "Markdown", "Mmap", "Pkg", "Printf", "REPL", "Random", "SHA", "Serialization", "SharedArrays", "Sockets", "SparseArrays", "Statistics", "Test", "UUIDs", "Unicode"]
git-tree-sha1 = "96b0bc6c52df76506efc8a441c6cf1adcb1babc4"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "3.42.0"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[deps.Contour]]
deps = ["StaticArrays"]
git-tree-sha1 = "9f02045d934dc030edad45944ea80dbd1f0ebea7"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.5.7"

[[deps.DataAPI]]
git-tree-sha1 = "cc70b17275652eb47bc9e5f81635981f13cea5c8"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.9.0"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "3daef5523dd2e769dad2365274f760ff5f282c7d"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.11"

[[deps.DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.DelimitedFiles]]
deps = ["Mmap"]
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"

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

[[deps.EarCut_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "3f3a2501fa7236e9b911e0f7a588c657e822bb6d"
uuid = "5ae413db-bbd1-5e63-b57d-d24a61df00f5"
version = "2.2.3+0"

[[deps.Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ae13fcbc7ab8f16b0856729b050ef0c446aa3492"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.4.4+0"

[[deps.FFMPEG]]
deps = ["FFMPEG_jll"]
git-tree-sha1 = "b57e3acbe22f8484b4b5ff66a7499717fe1a9cc8"
uuid = "c87230d0-a227-11e9-1b43-d7ebe4e7570a"
version = "0.4.1"

[[deps.FFMPEG_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "Pkg", "Zlib_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "d8a578692e3077ac998b50c0217dfd67f21d1e5f"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "4.4.0+0"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Fontconfig_jll]]
deps = ["Artifacts", "Bzip2_jll", "Expat_jll", "FreeType2_jll", "JLLWrappers", "Libdl", "Libuuid_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "21efd19106a55620a188615da6d3d06cd7f6ee03"
uuid = "a3f928ae-7b40-5064-980b-68af3947d34b"
version = "2.13.93+0"

[[deps.Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

[[deps.FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "87eb71354d8ec1a96d4a7636bd57a7347dde3ef9"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.10.4+0"

[[deps.FriBidi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "aa31987c2ba8704e23c6c8ba8a4f769d5d7e4f91"
uuid = "559328eb-81f9-559d-9380-de523a88c83c"
version = "1.0.10+0"

[[deps.GLFW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libglvnd_jll", "Pkg", "Xorg_libXcursor_jll", "Xorg_libXi_jll", "Xorg_libXinerama_jll", "Xorg_libXrandr_jll"]
git-tree-sha1 = "51d2dfe8e590fbd74e7a842cf6d13d8a2f45dc01"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.3.6+0"

[[deps.GR]]
deps = ["Base64", "DelimitedFiles", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Pkg", "Printf", "Random", "RelocatableFolders", "Serialization", "Sockets", "Test", "UUIDs"]
git-tree-sha1 = "9f836fb62492f4b0f0d3b06f55983f2704ed0883"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.64.0"

[[deps.GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Pkg", "Qt5Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "a6c850d77ad5118ad3be4bd188919ce97fffac47"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.64.0+0"

[[deps.GeometryBasics]]
deps = ["EarCut_jll", "IterTools", "LinearAlgebra", "StaticArrays", "StructArrays", "Tables"]
git-tree-sha1 = "83ea630384a13fc4f002b77690bc0afeb4255ac9"
uuid = "5c1252a2-5f33-56bf-86c9-59e7332b4326"
version = "0.4.2"

[[deps.Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[deps.Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "a32d672ac2c967f3deb8a81d828afc739c838a06"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.68.3+2"

[[deps.Graphite2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "344bf40dcab1073aca04aa0df4fb092f920e4011"
uuid = "3b182d85-2403-5c21-9c21-1e1f0cc25472"
version = "1.3.14+0"

[[deps.Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[deps.HTTP]]
deps = ["Base64", "Dates", "IniFile", "Logging", "MbedTLS", "NetworkOptions", "Sockets", "URIs"]
git-tree-sha1 = "0fa77022fe4b511826b39c894c90daf5fce3334a"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "0.9.17"

[[deps.HarfBuzz_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "Graphite2_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg"]
git-tree-sha1 = "129acf094d168394e80ee1dc4bc06ec835e510a3"
uuid = "2e76f6c2-a576-52d4-95c1-20adfe4de566"
version = "2.8.1+1"

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

[[deps.IniFile]]
git-tree-sha1 = "f550e6e32074c939295eb5ea6de31849ac2c9625"
uuid = "83e8ac13-25f8-5344-8a64-a9f2b223428f"
version = "0.5.1"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

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

[[deps.IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

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

[[deps.JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b53380851c6e6664204efb2e62cd24fa5c47e4ba"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "2.1.2+0"

[[deps.LAME_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f6250b16881adf048549549fba48b1161acdac8c"
uuid = "c1c5ebd0-6772-5130-a774-d5fcae4a789d"
version = "3.100.1+0"

[[deps.LERC_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bf36f528eec6634efc60d7ec062008f171071434"
uuid = "88015f11-f218-50d7-93a8-a6af411a945d"
version = "3.0.0+1"

[[deps.LZO_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e5b909bcf985c5e2605737d2ce278ed791b89be6"
uuid = "dd4b983a-f0e5-5f8d-a1b7-129d4a5fb1ac"
version = "2.10.1+0"

[[deps.LaTeXStrings]]
git-tree-sha1 = "f2355693d6778a178ade15952b7ac47a4ff97996"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.0"

[[deps.Latexify]]
deps = ["Formatting", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "Printf", "Requires"]
git-tree-sha1 = "4f00cc36fede3c04b8acf9b2e2763decfdcecfa6"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.15.13"

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

[[deps.Libffi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "0b4a5d71f3e5200a7dff793393e09dfc2d874290"
uuid = "e9f186c6-92d2-5b65-8a66-fee21dc1b490"
version = "3.2.2+1"

[[deps.Libgcrypt_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgpg_error_jll", "Pkg"]
git-tree-sha1 = "64613c82a59c120435c067c2b809fc61cf5166ae"
uuid = "d4300ac3-e22c-5743-9152-c294e39db1e4"
version = "1.8.7+0"

[[deps.Libglvnd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll", "Xorg_libXext_jll"]
git-tree-sha1 = "7739f837d6447403596a75d19ed01fd08d6f56bf"
uuid = "7e76a0d4-f3c7-5321-8279-8d96eeed0f29"
version = "1.3.0+3"

[[deps.Libgpg_error_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c333716e46366857753e273ce6a69ee0945a6db9"
uuid = "7add5ba3-2f88-524e-9cd5-f83b8a55f7b8"
version = "1.42.0+0"

[[deps.Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "42b62845d70a619f063a7da093d995ec8e15e778"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.16.1+1"

[[deps.Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9c30530bf0effd46e15e0fdcf2b8636e78cbbd73"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.35.0+0"

[[deps.Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "LERC_jll", "Libdl", "Pkg", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "c9551dd26e31ab17b86cbd00c2ede019c08758eb"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.3.0+1"

[[deps.Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7f3efec06033682db852f8b3bc3c1d2b0a0ab066"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.36.0+0"

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

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "3d3e902b31198a27340d0bf00d6ac452866021cf"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.9"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "Random", "Sockets"]
git-tree-sha1 = "1c38e51c3d08ef2278062ebceade0e46cefc96fe"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.0.3"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[deps.Measures]]
git-tree-sha1 = "e498ddeee6f9fdb4551ce855a46f54dbd900245f"
uuid = "442fdcdd-2543-5da2-b0f3-8c86c306513e"
version = "0.3.1"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "bf210ce90b6c9eed32d25dbcae1ebc565df2687f"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.0.2"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[deps.NaNMath]]
git-tree-sha1 = "737a5957f387b17e74d4ad2f440eb330b39a62c5"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.0.0"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[deps.Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "887579a3eb005446d514ab7aeac5d1d027658b8f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+1"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ab05aa4cc89736e95915b01e7279e61b1bfe33b8"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "1.1.14+0"

[[deps.Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "51a08fb14ec28da2ec7a927c4337e4332c2a4720"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.3.2+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[deps.PCRE_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b2a7af664e098055a7529ad1a900ded962bca488"
uuid = "2f80f16e-611a-54ab-bc61-aa92de5b98fc"
version = "8.44.0+0"

[[deps.Parsers]]
deps = ["Dates"]
git-tree-sha1 = "85b5da0fa43588c75bb1ff986493443f821c70b7"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.2.3"

[[deps.Pixman_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b4f5d02549a10e20780a24fce72bea96b6329e29"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.40.1+0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[deps.PlotThemes]]
deps = ["PlotUtils", "Requires", "Statistics"]
git-tree-sha1 = "a3a964ce9dc7898193536002a6dd892b1b5a6f1d"
uuid = "ccf2f8ad-2431-5c83-bf29-c5338b663b6a"
version = "2.0.1"

[[deps.PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "Printf", "Random", "Reexport", "Statistics"]
git-tree-sha1 = "bb16469fd5224100e422f0b027d26c5a25de1200"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.2.0"

[[deps.Plots]]
deps = ["Base64", "Contour", "Dates", "Downloads", "FFMPEG", "FixedPointNumbers", "GR", "GeometryBasics", "JSON", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "Pkg", "PlotThemes", "PlotUtils", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "Requires", "Scratch", "Showoff", "SparseArrays", "Statistics", "StatsBase", "UUIDs", "UnicodeFun", "Unzip"]
git-tree-sha1 = "90021b03a38f1ae9dbd7bf4dc5e3dcb7676d302c"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.27.2"

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

[[deps.Qt5Base_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Fontconfig_jll", "Glib_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "OpenSSL_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libxcb_jll", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_keysyms_jll", "Xorg_xcb_util_renderutil_jll", "Xorg_xcb_util_wm_jll", "Zlib_jll", "xkbcommon_jll"]
git-tree-sha1 = "ad368663a5e20dbb8d6dc2fddeefe4dae0781ae8"
uuid = "ea2cea3b-5b76-57ae-a6ef-0a8af62496e1"
version = "5.15.3+0"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.RecipesBase]]
git-tree-sha1 = "6bf3f380ff52ce0832ddd3a2a7b9538ed1bcca7d"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.2.1"

[[deps.RecipesPipeline]]
deps = ["Dates", "NaNMath", "PlotUtils", "RecipesBase"]
git-tree-sha1 = "dc1e451e15d90347a7decc4221842a022b011714"
uuid = "01d81517-befc-4cb6-b9ec-a95719d0359c"
version = "0.5.2"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.RelocatableFolders]]
deps = ["SHA", "Scratch"]
git-tree-sha1 = "cdbd3b1338c72ce29d9584fdbe9e9b70eeb5adca"
uuid = "05181044-ff0b-4ac5-8273-598c1e38db00"
version = "0.1.3"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[deps.Scratch]]
deps = ["Dates"]
git-tree-sha1 = "0b4b7f1393cff97c33891da2a0bf69c6ed241fda"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.1.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[deps.Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

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

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "Random", "Statistics"]
git-tree-sha1 = "6976fab022fea2ffea3d945159317556e5dad87c"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.4.2"

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

[[deps.StructArrays]]
deps = ["Adapt", "DataAPI", "StaticArrays", "Tables"]
git-tree-sha1 = "57617b34fa34f91d536eb265df67c2d4519b8b98"
uuid = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"
version = "0.6.5"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[deps.TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[deps.Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "OrderedCollections", "TableTraits", "Test"]
git-tree-sha1 = "5ce79ce186cc678bbb5c5681ca3379d1ddae11a1"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.7.0"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.URIs]]
git-tree-sha1 = "97bbe755a53fe859669cd907f2d96aee8d2c1355"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.3.0"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.UnicodeFun]]
deps = ["REPL"]
git-tree-sha1 = "53915e50200959667e78a92a418594b428dffddf"
uuid = "1cfade01-22cf-5700-b092-accc4b62d6e1"
version = "0.4.1"

[[deps.Unzip]]
git-tree-sha1 = "34db80951901073501137bdbc3d5a8e7bbd06670"
uuid = "41fe7b60-77ed-43a1-b4f0-825fd5a5650d"
version = "0.1.2"

[[deps.Wayland_jll]]
deps = ["Artifacts", "Expat_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "3e61f0b86f90dacb0bc0e73a0c5a83f6a8636e23"
uuid = "a2964d1f-97da-50d4-b82a-358c7fce9d89"
version = "1.19.0+0"

[[deps.Wayland_protocols_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4528479aa01ee1b3b4cd0e6faef0e04cf16466da"
uuid = "2381bf8a-dfd0-557d-9999-79630e7b1b91"
version = "1.25.0+0"

[[deps.XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "1acf5bdf07aa0907e0a37d3718bb88d4b687b74a"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.9.12+0"

[[deps.XSLT_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgcrypt_jll", "Libgpg_error_jll", "Libiconv_jll", "Pkg", "XML2_jll", "Zlib_jll"]
git-tree-sha1 = "91844873c4085240b95e795f692c4cec4d805f8a"
uuid = "aed1982a-8fda-507f-9586-7b0439959a61"
version = "1.1.34+0"

[[deps.Xorg_libX11_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll", "Xorg_xtrans_jll"]
git-tree-sha1 = "5be649d550f3f4b95308bf0183b82e2582876527"
uuid = "4f6342f7-b3d2-589e-9d20-edeb45f2b2bc"
version = "1.6.9+4"

[[deps.Xorg_libXau_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4e490d5c960c314f33885790ed410ff3a94ce67e"
uuid = "0c0b7dd1-d40b-584c-a123-a41640f87eec"
version = "1.0.9+4"

[[deps.Xorg_libXcursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXfixes_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "12e0eb3bc634fa2080c1c37fccf56f7c22989afd"
uuid = "935fb764-8cf2-53bf-bb30-45bb1f8bf724"
version = "1.2.0+4"

[[deps.Xorg_libXdmcp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fe47bd2247248125c428978740e18a681372dd4"
uuid = "a3789734-cfe1-5b06-b2d0-1dd0d9d62d05"
version = "1.1.3+4"

[[deps.Xorg_libXext_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "b7c0aa8c376b31e4852b360222848637f481f8c3"
uuid = "1082639a-0dae-5f34-9b06-72781eeb8cb3"
version = "1.3.4+4"

[[deps.Xorg_libXfixes_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "0e0dc7431e7a0587559f9294aeec269471c991a4"
uuid = "d091e8ba-531a-589c-9de9-94069b037ed8"
version = "5.0.3+4"

[[deps.Xorg_libXi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXfixes_jll"]
git-tree-sha1 = "89b52bc2160aadc84d707093930ef0bffa641246"
uuid = "a51aa0fd-4e3c-5386-b890-e753decda492"
version = "1.7.10+4"

[[deps.Xorg_libXinerama_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll"]
git-tree-sha1 = "26be8b1c342929259317d8b9f7b53bf2bb73b123"
uuid = "d1454406-59df-5ea1-beac-c340f2130bc3"
version = "1.1.4+4"

[[deps.Xorg_libXrandr_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "34cea83cb726fb58f325887bf0612c6b3fb17631"
uuid = "ec84b674-ba8e-5d96-8ba1-2a689ba10484"
version = "1.5.2+4"

[[deps.Xorg_libXrender_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "19560f30fd49f4d4efbe7002a1037f8c43d43b96"
uuid = "ea2f1a96-1ddc-540d-b46f-429655e07cfa"
version = "0.9.10+4"

[[deps.Xorg_libpthread_stubs_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "6783737e45d3c59a4a4c4091f5f88cdcf0908cbb"
uuid = "14d82f49-176c-5ed1-bb49-ad3f5cbd8c74"
version = "0.1.0+3"

[[deps.Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "XSLT_jll", "Xorg_libXau_jll", "Xorg_libXdmcp_jll", "Xorg_libpthread_stubs_jll"]
git-tree-sha1 = "daf17f441228e7a3833846cd048892861cff16d6"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.13.0+3"

[[deps.Xorg_libxkbfile_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "926af861744212db0eb001d9e40b5d16292080b2"
uuid = "cc61e674-0454-545c-8b26-ed2c68acab7a"
version = "1.1.0+4"

[[deps.Xorg_xcb_util_image_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "0fab0a40349ba1cba2c1da699243396ff8e94b97"
uuid = "12413925-8142-5f55-bb0e-6d7ca50bb09b"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll"]
git-tree-sha1 = "e7fd7b2881fa2eaa72717420894d3938177862d1"
uuid = "2def613f-5ad1-5310-b15b-b15d46f528f5"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_keysyms_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "d1151e2c45a544f32441a567d1690e701ec89b00"
uuid = "975044d2-76e6-5fbe-bf08-97ce7c6574c7"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_renderutil_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "dfd7a8f38d4613b6a575253b3174dd991ca6183e"
uuid = "0d47668e-0667-5a69-a72c-f761630bfb7e"
version = "0.3.9+1"

[[deps.Xorg_xcb_util_wm_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "e78d10aab01a4a154142c5006ed44fd9e8e31b67"
uuid = "c22f9ab0-d5fe-5066-847c-f4bb1cd4e361"
version = "0.4.1+1"

[[deps.Xorg_xkbcomp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxkbfile_jll"]
git-tree-sha1 = "4bcbf660f6c2e714f87e960a171b119d06ee163b"
uuid = "35661453-b289-5fab-8a00-3d9160c6a3a4"
version = "1.4.2+4"

[[deps.Xorg_xkeyboard_config_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xkbcomp_jll"]
git-tree-sha1 = "5c8424f8a67c3f2209646d4425f3d415fee5931d"
uuid = "33bec58e-1273-512f-9401-5d533626f822"
version = "2.27.0+4"

[[deps.Xorg_xtrans_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "79c31e7844f6ecf779705fbc12146eb190b7d845"
uuid = "c5fb5394-a638-5e4d-96e5-b29de1b5cf10"
version = "1.4.0+3"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[deps.Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e45044cd873ded54b6a5bac0eb5c971392cf1927"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.2+0"

[[deps.libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "5982a94fcba20f02f42ace44b9894ee2b140fe47"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.15.1+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"

[[deps.libfdk_aac_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "daacc84a041563f965be61859a36e17c4e4fcd55"
uuid = "f638f0a6-7fb0-5443-88ba-1cc74229b280"
version = "2.0.2+0"

[[deps.libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "94d180a6d2b5e55e447e2d27a29ed04fe79eb30c"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.38+0"

[[deps.libvorbis_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Ogg_jll", "Pkg"]
git-tree-sha1 = "b910cb81ef3fe6e78bf6acee440bda86fd6ae00c"
uuid = "f27f6e37-5d2b-51aa-960f-b287f2bc3b7a"
version = "1.3.7+1"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"

[[deps.x264_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fea590b89e6ec504593146bf8b988b2c00922b2"
uuid = "1270edf5-f2f9-52d2-97e9-ab00b5d0237a"
version = "2021.5.5+0"

[[deps.x265_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ee567a171cce03570d77ad3a43e90218e38937a9"
uuid = "dfaa095f-4041-5dcd-9319-2fabd8486b76"
version = "3.5.0+0"

[[deps.xkbcommon_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Wayland_jll", "Wayland_protocols_jll", "Xorg_libxcb_jll", "Xorg_xkeyboard_config_jll"]
git-tree-sha1 = "ece2350174195bb31de1a63bea3a41ae1aa593b6"
uuid = "d8fb68d0-12a3-5cfd-a85a-d49703b185fd"
version = "0.9.1+5"
"""

# ╔═╡ Cell order:
# ╟─349d7534-6212-11eb-2bc5-db5be39b6bb6
# ╠═96ec00fc-6f14-11eb-329e-19e4835643db
# ╟─237ef27e-6266-11eb-3cf4-1b2223eabfd9
# ╠═6c060eec-6266-11eb-0b23-e5be08d78823
# ╟─830c9ed0-6266-11eb-27ba-07773c842fed
# ╟─f4270146-6216-11eb-391e-01a476fcfccd
# ╠═b5fff126-6215-11eb-1018-bd2e4f638f65
# ╟─b9dbaf62-6215-11eb-3a7d-0b882b1a10b0
# ╟─3249157e-6267-11eb-3dca-8949d7c0e3c9
# ╠═ce1d05da-6267-11eb-136c-23c5c54a1559
# ╟─cf933c04-6267-11eb-3317-ed1a42e8c64e
# ╟─1695a810-6268-11eb-3932-fb8885097f70
# ╠═77cefbd4-662e-11eb-1b1d-91da61cc3823
# ╟─88776120-662e-11eb-1542-fd26e4f126b1
# ╟─874a1a5c-6632-11eb-2705-e914f01b9762
# ╠═812bbd7e-6632-11eb-29f8-3f48329f0ac9
# ╠═aeaa97ae-6632-11eb-0ea2-7febd8b3e965
# ╟─b0d35a9a-662e-11eb-34f5-c9a5fd9bb9a6
# ╠═d285737a-662f-11eb-390e-1d1e2437de71
# ╟─de2a045c-662f-11eb-1d80-65fe7d8e0db3
# ╟─5d04cbea-6630-11eb-3bee-c182aa912653
# ╠═0ae0cf56-6632-11eb-262a-191ea74ec517
# ╟─f279b1ee-6631-11eb-0809-bf0699c636f2
# ╟─0fe8c31e-663a-11eb-1acb-17d3d7615e64
# ╠═478dde3c-663a-11eb-3244-e7449c93b3a5
# ╟─68f2b1b0-663a-11eb-1b6d-b176d905f65b
# ╠═8d509116-663b-11eb-0e98-dd27598740fe
# ╟─bb8694b8-663b-11eb-03a1-49713346bdf3
# ╟─06c9bcec-663d-11eb-3062-85c0983a79eb
# ╠═9fd96950-6651-11eb-25f7-c964ab504b4a
# ╟─de2903cc-6652-11eb-30c3-7114b15fa6e1
# ╟─34824462-6654-11eb-2b38-19d14aa309af
# ╠═6895356c-6655-11eb-3849-b3fa387df754
# ╟─6b9a4b64-6656-11eb-10ce-7b4a8b3cd6a4
# ╟─9687bc24-666c-11eb-3b1e-edb5c448bad8
# ╟─a4a9afe4-6656-11eb-0664-83cb32ce934b
# ╟─9d3e9a92-6469-11eb-2952-b37367644c48
# ╠═f3cd5320-66d6-11eb-191c-4b4d8cba940d
# ╠═f5805956-66d6-11eb-04e8-b1faae8f0d3c
# ╠═c72359f4-66d7-11eb-395f-b3a1983a6eea
# ╟─bdea6774-66d7-11eb-1c62-8f0e935f98ef
# ╠═fb73ea0c-66d7-11eb-001c-23033aee228a
# ╟─07491ca8-66d8-11eb-3304-99f911b4bd1d
# ╟─2b99da2c-666d-11eb-1c64-337654a9d8f2
# ╠═d39fbca0-66db-11eb-1aae-7b29f559cb01
# ╟─1bcd317c-66e8-11eb-10df-c132d5f79155
# ╠═66c4f3fc-66db-11eb-0927-ebe1d40eeb3b
# ╟─2c63db0a-66dc-11eb-1a45-7902d591c3e1
# ╟─575d9e52-6468-11eb-2f95-63cd3920f91a
# ╠═2e6c3c30-66e6-11eb-10f0-ddaa1752cff9
# ╟─d701d778-66e7-11eb-16c2-ab49fc06e992
# ╠═055baa32-66e7-11eb-20fc-575565bda51b
# ╟─6a3905f4-66e6-11eb-0607-5534821caee6
# ╟─91c222ea-66e6-11eb-28ce-c1f1424525c8
# ╠═b5db566a-66e6-11eb-35fb-17d3fc4e258c
# ╟─a44eb7ea-66e9-11eb-10fa-2b0936b9f489
# ╠═d8f306ca-66e9-11eb-3728-156d0328250b
# ╟─2561d38a-66ea-11eb-10ab-27db1a87970b
# ╟─673cc322-666e-11eb-107f-2b9bd6826ad5
# ╠═1bf921be-66eb-11eb-089a-97dfe9418b32
# ╟─455d0b7c-66eb-11eb-3167-4b204ac741a5
# ╟─529a7324-66eb-11eb-0c1f-c37639e37a6e
# ╠═a87e36c4-66eb-11eb-223e-a1b077dca672
# ╟─b135affc-66eb-11eb-188b-a32ef1478ee6
# ╟─0aa99f86-6f97-11eb-2141-2d35c3e0857d
# ╠═fec108ca-6f97-11eb-06d9-6fe1646f8b98
# ╟─1559f57e-6f98-11eb-3539-1b1ae82c439b
# ╟─36e6783c-6f98-11eb-0b09-db56907e370d
# ╠═3f4422ce-6f98-11eb-111f-4d1624a326c7
# ╠═50cc4f32-6f98-11eb-25a4-ebaf581955ea
# ╠═5733a026-6f98-11eb-1b50-c75f87fbabe5
# ╠═6824d1f2-6f98-11eb-12f1-adf1271af917
# ╠═6b497cf9-be7e-4bce-8da2-9b543a267943
# ╟─77d17b00-6f98-11eb-37ad-dd347db13fb3
# ╟─8b852fd4-6f98-11eb-1b3a-7ff47c51e99e
# ╠═8f566768-6f98-11eb-20ae-45d6f39cd210
# ╟─961e9cd2-6f98-11eb-362c-517edab85a8c
# ╠═a32f2a4a-6f98-11eb-18f9-efb51aac288c
# ╟─acc530cc-6f98-11eb-330e-077fcaf5bd62
# ╠═e5ca1bf8-6f98-11eb-1bd9-6f2f1fbe55c9
# ╟─eba05204-6f98-11eb-1e7c-4f7b49962f23
# ╠═f22b7874-6f98-11eb-0417-1de0d171c4ad
# ╟─f8265ba4-6f98-11eb-3938-0b38b2b93285
# ╠═fd8522ec-6f98-11eb-0a3c-01a91ee48de9
# ╟─0cce95b2-6f99-11eb-1161-1d446c3bbe44
# ╠═1a12d5a8-6f99-11eb-0e46-1529f881a3b0
# ╟─214ce458-6f99-11eb-0963-7965b5fba93a
# ╠═29efc990-6f99-11eb-0633-63fb74c5bebf
# ╟─2f3b762e-6f99-11eb-12f0-2d42ed8237e0
# ╟─372fa56c-6f99-11eb-115d-275699f1c05c
# ╠═473b6dec-6f99-11eb-04f0-07006f1996ba
# ╟─d760869e-6212-11eb-09d4-5f40a0edc641
# ╟─bf493588-6f14-11eb-3ddf-b7ce036aff36
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
