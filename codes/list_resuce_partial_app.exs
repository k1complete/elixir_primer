Enum.reduce [1,2,3], 1, &1 * &2
Enum.reduce [1,2,3], 1, &(&1 * &2)
