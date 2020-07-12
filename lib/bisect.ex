defmodule Bisect do
  @moduledoc File.read!("README.md")

  import Bitwise,
    only: [
      >>>: 2
    ]

  defp extract_key(:lhs, opts) do
    key = opts[:key]
    opts[:lhs_key] || key
  end

  defp extract_key(:rhs, opts) do
    key = opts[:key]
    opts[:rhs_key] || key
  end

  defp access_value(term, key)
       when key in [nil, []] do
    term
  end

  defp access_value(term, key)
       when not is_list(key) do
    access_value(term, [key])
  end

  defp access_value(term, key) do
    get_in(term, key)
  end

  @doc ~S"""
  Executes binary search in list `enumerable` by passing list elements
  to the `function` for comparison, assuming the list is sorted.

  ### Options

    - `key` or `lhs_key`: Path of the value to be compared,
    by being passed to `function` while iteration.

    See `Kernel.get_in/2`

  ### Examples

      iex> Bisect.search([1, 2, 4], fn x ->
      ...>   x == 4
      ...> end)
      2

      iex> Bisect.search([1, 2, 4, 8], fn x ->
      ...>   x == 7
      ...> end)
      4

      iex> Bisect.search([1, 2], fn x ->
      ...>   x >= 1
      ...> end)
      0

      iex> Bisect.search([1, 2], fn x ->
      ...>   x > 1
      ...> end)
      1

      iex> Bisect.search([2, 1], fn x ->
      ...>   x < 0
      ...> end)
      2

      iex> Bisect.search(
      ...>   [%{value: 1}, %{value: 2}],
      ...>   fn x ->
      ...>     x > 1
      ...>   end,
      ...>   lhs_key: [:value]
      ...> )
      1

  """
  @doc since: "0.4.0"
  @spec search(Enum.t(), (term -> boolean), keyword) :: non_neg_integer
  def search(enumerable, function, opts \\ []) do
    do_search(enumerable, function, 0, length(enumerable), opts)
  end

  defp do_search(enumerable, function, low, high, opts)
       when low < high do
    middle = (low + high) >>> 0x1
    lhs = Enum.at(enumerable, middle)
    lhs_key = extract_key(:lhs, opts)
    lhs_value = access_value(lhs, lhs_key)

    case apply(function, [lhs_value]) do
      true ->
        do_search(enumerable, function, low, middle, opts)

      false ->
        do_search(enumerable, function, middle + 1, high, opts)
    end
  end

  defp do_search(_enumerable, _function, low, _high, _opts) do
    low
  end

  @doc ~S"""
  Returns the leftmost index where to insert `term` in list `enumerable`,
  assuming the list is sorted.

  ### Examples

      iex> Bisect.bisect_left([1, 2], 1)
      0

      iex> Bisect.bisect_left([1, 2], 2)
      1

      iex> Bisect.bisect_left([1, 2], 4)
      2

  ### Options

    - `rhs_key`: Path of the value of `term` to be compared.

    See `Kernel.get_in/2`

  See `Bisect.search/3` for more options.

  """
  @doc since: "0.1.0"
  @spec bisect_left(Enum.t(), term, keyword) :: non_neg_integer
  def bisect_left(enumerable, term, opts \\ []) do
    rhs_key = extract_key(:rhs, opts)
    rhs_value = access_value(term, rhs_key)

    search(
      enumerable,
      fn x ->
        x >= rhs_value
      end,
      opts
    )
  end

  @doc ~S"""
  Returns the rightmost index where to insert `term` in list `enumerable`,
  assuming the list is sorted.

  ### Examples

      iex> Bisect.bisect_right([1, 2], 1)
      1

      iex> Bisect.bisect_right([1, 2, 2, 4], 4)
      4

      iex> Bisect.bisect_right([2, 4], 0)
      0

  ### Options

    - `rhs_key`: Path of the value of `term` to be compared.

    See `Kernel.get_in/2`

  See `Bisect.search/3` for more options.

  """
  @doc since: "0.1.0"
  @spec bisect_right(Enum.t(), term, keyword) :: non_neg_integer
  def bisect_right(enumerable, term, opts \\ []) do
    rhs_key = extract_key(:rhs, opts)
    rhs_value = access_value(term, rhs_key)

    search(
      enumerable,
      fn x ->
        x > rhs_value
      end,
      opts
    )
  end

  @doc ~S"""
  Inserts `term` into list `enumerable`, and keeps it sorted
  assuming the list is already sorted.

  If `term` is already in `enumerable`, inserts it to the left of the leftmost `term`.

  ### Examples

      iex> Bisect.insort_left([1, 2], 1)
      [1, 1, 2]

      iex> Bisect.insort_left([1, 2, 2, 4], 4)
      [1, 2, 2, 4, 4]

      iex> Bisect.insort_left([2, 4], 0)
      [0, 2, 4]

      iex> Bisect.insort_left(
      ...>   [%{value: 2}, %{value: 4}],
      ...>   %{value: 0},
      ...>   key: [:value]
      ...> )
      [%{value: 0}, %{value: 2}, %{value: 4}]

  ### Options

  See `Bisect.bisect_left/3`

  """
  @doc since: "0.1.0"
  @spec insort_left(Enum.t(), term, keyword) :: Enum.t()
  def insort_left(enumerable, term, opts \\ []) do
    index = bisect_left(enumerable, term, opts)
    List.insert_at(enumerable, index, term)
  end

  @doc ~S"""
  Inserts `term` into list `enumerable`, and keeps it sorte
  assuming the list is already sorted.

  If `term` is already in `enumerable`, inserts it to the right of the rightmost `term`.

  ### Examples

      iex> Bisect.insort_right([1, 2], 1)
      [1, 1, 2]

      iex> Bisect.insort_right([1, 2, 2, 4], 4)
      [1, 2, 2, 4, 4]

      iex> Bisect.insort_right([2, 4], 0)
      [0, 2, 4]

      iex> Bisect.insort_right(
      ...>   [%{value: 2}, %{value: 4}],
      ...>   %{value: 0},
      ...>   key: [:value]
      ...> )
      [%{value: 0}, %{value: 2}, %{value: 4}]

  ### Options

  See `Bisect.bisect_right/3`

  """
  @doc since: "0.1.0"
  @spec insort_right(Enum.t(), term, keyword) :: Enum.t()
  def insort_right(enumerable, term, opts \\ []) do
    index = bisect_right(enumerable, term, opts)
    List.insert_at(enumerable, index, term)
  end
end
