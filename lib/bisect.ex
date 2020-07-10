defmodule Bisect do
  @moduledoc File.read!("README.md")

  import Bitwise,
    only: [
      >>>: 2
    ]

  @doc ~S"""
  Executes binary search in list `enumerable` by passing list elements
  to the `function` for comparison, assuming the list is sorted.

  ### Options

    - `access_keys`: Specifies path of value in `term`,
    to be passed to the `function` for comparison.

    See `Kernel.get_in/2` function and `Access.fetch/2` callback
    for more information about access keys.

  ### Examples

      iex> Bisect.binary_search([1, 2], fn term ->
      ...>   term >= 1
      ...> end)
      0

      iex> Bisect.binary_search([1, 2], fn term ->
      ...>   term > 1
      ...> end)
      1

      iex> Bisect.binary_search([2, 1], fn term ->
      ...>   term < 0
      ...> end)
      2

      iex> Bisect.binary_search([%{value: 1}, %{value: 2}], fn term ->
      ...>   term > 1
      ...> end, access_keys: [:value])
      1

  """
  @doc since: "0.2.0"
  @spec binary_search(Enum.t(), (term -> boolean), keyword) :: non_neg_integer
  def binary_search(enumerable, function, opts \\ []) do
    do_binary_search(enumerable, function, 0, length(enumerable), opts)
  end

  defp do_binary_search(enumerable, function, low, high, opts)
       when low < high do
    middle = (low + high) >>> 0x1
    element = Enum.at(enumerable, middle)

    case apply_traversal(function, element, opts[:access_keys]) do
      true ->
        do_binary_search(enumerable, function, low, middle, opts)

      false ->
        do_binary_search(enumerable, function, middle + 1, high, opts)
    end
  end

  defp do_binary_search(_enumerable, _function, low, _high, _opts) do
    low
  end

  defp apply_traversal(function, element, access_keys) do
    apply(function, [access_value(element, access_keys)])
  end

  defp access_value(element, access_keys)
       when access_keys in [nil, []] do
    element
  end

  defp access_value(element, access_keys) do
    get_in(element, access_keys)
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

  See `Bisect.binary_search/3` for options.

  """
  @doc since: "0.1.0"
  @spec bisect_left(Enum.t(), term, keyword) :: non_neg_integer
  def bisect_left(enumerable, term, opts \\ []) do
    access_keys = opts[:access_keys]

    binary_search(
      enumerable,
      fn element ->
        element >= access_value(term, access_keys)
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

  See `Bisect.binary_search/3` for options.

  """
  @doc since: "0.1.0"
  @spec bisect_right(Enum.t(), term, keyword) :: non_neg_integer
  def bisect_right(enumerable, term, opts \\ []) do
    access_keys = opts[:access_keys]

    binary_search(
      enumerable,
      fn element ->
        element > access_value(term, access_keys)
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

      iex> Bisect.insort_left([%{value: 2}, %{value: 4}], %{value: 0}, access_keys: [:value])
      [%{value: 0}, %{value: 2}, %{value: 4}]

  See `Bisect.binary_search/3` for options.

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

      iex> Bisect.insort_right([%{value: 2}, %{value: 4}], %{value: 0}, access_keys: [:value])
      [%{value: 0}, %{value: 2}, %{value: 4}]

  See `Bisect.binary_search/3` for options.

  """
  @doc since: "0.1.0"
  @spec insort_right(Enum.t(), term, keyword) :: Enum.t()
  def insort_right(enumerable, term, opts \\ []) do
    index = bisect_right(enumerable, term, opts)
    List.insert_at(enumerable, index, term)
  end
end
