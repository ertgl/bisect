defmodule Bisect do
	@moduledoc """
	Bisection algorithms ported from Python.

	[![Hex Version](https://img.shields.io/hexpm/v/bisect.svg?style=flat-square)](https://hex.pm/packages/bisect) [![Docs](https://img.shields.io/badge/api-docs-orange.svg?style=flat-square)](https://hexdocs.pm/bisect) [![Hex downloads](https://img.shields.io/hexpm/dt/bisect.svg?style=flat-square)](https://hex.pm/packages/bisect) [![GitHub](https://img.shields.io/badge/vcs-GitHub-blue.svg?style=flat-square)](https://github.com/ertgl/bisect) [![MIT License](https://img.shields.io/hexpm/l/bisect.svg?style=flat-square)](LICENSE.txt)

	Source: <a href="https://github.com/python/cpython/blob/3.6/Lib/bisect.py" target="_blank">
		cpython/Lib/bisect.py
	</a>
	"""

	@doc """
	Return the index where to insert item x in list a, assuming a is sorted.
	The return value i is such that all e in a[:i] have e < x, and all e in
	a[i:] have e >= x.  So if x already appears in the list, a.insert(x) will
	insert just before the leftmost x already there.
	Optional keywords :lo (default 0) and :hi (default len(a)) bound the
	slice of a to be searched.

	## Examples

		iex> Bisect.bisect_left([1, 2], 1)
		0

		iex> Bisect.bisect_left([1, 2], 2)
		1

		iex> Bisect.bisect_left([1, 2], 4)
		2

	"""
    def bisect_left(a, x, opts \\ [])
	when is_list(a) do
        lo = Keyword.get(opts, :lo, 0)
        hi = Keyword.get(opts, :hi, nil)
        {_a, _x, lo, _hi} = do_bisect_left(a, x, lo, hi)
        lo
    end

    @doc false
    defp do_bisect_left(_a, _x, lo, _hi)
    when is_integer(lo) == false do
        {:error, "lo must be positive integer"}
    end

    @doc false
    defp do_bisect_left(_a, _x, lo, _hi)
    when lo < 0 do
        {:error, "lo must be positive integer"}
    end

    @doc false
    defp do_bisect_left(a, x, lo, hi)
    when is_nil(hi) do
        do_bisect_left(a, x, lo, length(a))
    end

    @doc false
    defp do_bisect_left(_a, _x, _lo, hi)
    when is_integer(hi) == false do
        {:error, "hi must be integer"}
    end

    @doc false
    defp do_bisect_left(a, x, lo, hi)
	when (lo < hi) == true
    do
		mid = div((lo + hi), 2)
		{timely_lo, timely_hi} = case Enum.at(a, mid) < x do
			true ->
				{mid + 1, hi}
			false ->
				{lo, mid}
		end
        do_bisect_left(a, x, timely_lo, timely_hi)
    end

	@doc false
    defp do_bisect_left(a, x, lo, hi)
	when (lo < hi) == false
    do
        {a, x, lo, hi}
    end

	@doc """
	Return the index where to insert item x in list a, assuming a is sorted.
	The return value i is such that all e in a[:i] have e <= x, and all e in
	a[i:] have e > x.  So if x already appears in the list, a.insert(x) will
	insert just after the rightmost x already there.
	Optional keywords :lo (default 0) and :hi (default len(a)) bound the
	slice of a to be searched.

	## Examples

		iex> Bisect.bisect_right([1, 2], 1)
		1

		iex> Bisect.bisect_right([1, 2, 3], 4)
		3

	"""
    def bisect_right(a, x, opts \\ [])
	when is_list(a) do
        lo = Keyword.get(opts, :lo, 0)
        hi = Keyword.get(opts, :hi, nil)
        {_a, _x, lo, _hi} = do_bisect_right(a, x, lo, hi)
        lo
    end

    @doc false
    defp do_bisect_right(_a, _x, lo, _hi)
    when is_integer(lo) == false do
        {:error, "lo must be positive integer"}
    end

    @doc false
    defp do_bisect_right(_a, _x, lo, _hi)
    when lo < 0 do
        {:error, "lo must be positive integer"}
    end

    @doc false
    defp do_bisect_right(a, x, lo, hi)
    when is_nil(hi) do
        do_bisect_right(a, x, lo, length(a))
    end

    @doc false
    defp do_bisect_right(_a, _x, _lo, hi)
    when is_integer(hi) == false do
        {:error, "hi must be integer"}
    end

    @doc false
    defp do_bisect_right(a, x, lo, hi)
	when (lo < hi) == true
    do
		mid = div((lo + hi), 2)
		{timely_lo, timely_hi} = case x < Enum.at(a, mid) do
			true ->
				{lo, mid}
			false ->
				{mid + 1, hi}
		end
        do_bisect_right(a, x, timely_lo, timely_hi)
    end

	@doc false
    defp do_bisect_right(a, x, lo, hi)
	when (lo < hi) == false
    do
        {a, x, lo, hi}
    end

	@doc """
	Insert item x in list a, and keep it sorted assuming a is sorted.
	If x is already in a, insert it to the left of the leftmost x.
	Optional keywords :lo (default 0) and :hi (default len(a)) bound the
	slice of a to be searched.

	## Examples

		iex> Bisect.insort_left([1, 2, 3], 4)
		[1, 2, 3, 4]

		iex> Bisect.insort_left([2, 3, 4], 1)
		[1, 2, 3, 4]

	"""
    def insort_left(a, x, opts \\ [])
	when is_list(a) do
        lo = Keyword.get(opts, :lo, 0)
        hi = Keyword.get(opts, :hi, nil)
        {a, _x, _lo, _hi} = do_insort_left(a, x, lo, hi)
        a
    end

    @doc false
    defp do_insort_left(_a, _x, lo, _hi)
    when is_integer(lo) == false do
        {:error, "lo must be positive integer"}
    end

    @doc false
    defp do_insort_left(_a, _x, lo, _hi)
    when lo < 0 do
        {:error, "lo must be positive integer"}
    end

    @doc false
    defp do_insort_left(a, x, lo, hi)
    when is_nil(hi) do
        do_insort_left(a, x, lo, length(a))
    end

    @doc false
    defp do_insort_left(_a, _x, _lo, hi)
    when is_integer(hi) == false do
        {:error, "hi must be integer"}
    end

    @doc false
    defp do_insort_left(a, x, lo, hi)
	when (lo < hi) == true
    do
		mid = div((lo + hi), 2)
		{timely_lo, timely_hi} = case Enum.at(a, mid) < x do
			true ->
				{mid + 1, hi}
			false ->
				{lo, mid}
		end
        do_insort_left(a, x, timely_lo, timely_hi)
    end

	@doc false
    defp do_insort_left(a, x, lo, hi)
	when (lo < hi) == false
    do
        {List.insert_at(a, lo, x), x, lo, hi}
    end

	@doc """
	Insert item x in list a, and keep it sorted assuming a is sorted.
	If x is already in a, insert it to the right of the rightmost x.
	Optional keywords :lo (default 0) and :hi (default length(a)) bound the
	slice of a to be searched.

	## Examples

		iex> Bisect.insort_right([1, 2], 3)
		[1, 2, 3]

		iex> Bisect.insort_right([1, 2, 3], 0)
		[0, 1, 2, 3]

	"""
    def insort_right(a, x, opts \\ [])
	when is_list(a) do
        lo = Keyword.get(opts, :lo, 0)
        hi = Keyword.get(opts, :hi, nil)
        {a, _x, _lo, _hi} = do_insort_right(a, x, lo, hi)
        a
    end

    @doc false
    defp do_insort_right(_a, _x, lo, _hi)
    when is_integer(lo) == false do
        {:error, "lo must be positive integer"}
    end

    @doc false
    defp do_insort_right(_a, _x, lo, _hi)
    when lo < 0 do
        {:error, "lo must be positive integer"}
    end

    @doc false
    defp do_insort_right(a, x, lo, hi)
    when is_nil(hi) do
        do_insort_right(a, x, lo, length(a))
    end

    @doc false
    defp do_insort_right(_a, _x, _lo, hi)
    when is_integer(hi) == false do
        {:error, "hi must be integer"}
    end

    @doc false
    defp do_insort_right(a, x, lo, hi)
	when (lo < hi) == true
    do
		mid = div((lo + hi), 2)
		{timely_lo, timely_hi} = case x < Enum.at(a, mid) do
			true ->
				{lo, mid}
			false ->
				{mid + 1, hi}
		end
        do_insort_right(a, x, timely_lo, timely_hi)
    end

	@doc false
    defp do_insort_right(a, x, lo, hi)
	when (lo < hi) == false
    do
        {List.insert_at(a, lo, x), x, lo, hi}
    end

end
