defmodule Kruskal do
  def generate(completeness) do
    nodes = for x <- 0..3, y <- 0..3, into: %{}, do: {{x, y}, 0}
    generate(nodes, connections(nodes), [], completeness)
  end

  defp generate(nodes, connections, kept, completeness) do
    if 24 - completeness == Enum.count(connections) do
      kept
    else
      [a, b] = Enum.random(connections)

      if Enum.max([nodes[a], nodes[b]]) > 1 do # Too many connections already
        generate(nodes, connections -- [[a, b]], kept, completeness)
      else # Join these nodes by 'activating' the connection between them
        nodes = Map.update(nodes, a, 1, fn neighbors -> neighbors + 1 end)
        nodes = Map.update(nodes, b, 1, fn neighbors -> neighbors + 1 end)

        generate(nodes, connections -- [[a, b]], [[a, b] | kept], completeness)
      end
    end
  end

  def draw(gleeph) do
    draw_nodes()
    |> draw_connections(gleeph)
    |> Enum.map(&(&1 ++ ["\n"]))
    |> List.to_string()
    |> IO.puts()
  end

  # Helpers
  defp connections(nodes) when is_map(nodes) do
    connections(Map.keys(nodes), [])
  end

  defp connections([ {x, y} | rest ], connection_list) do
    connection_list = [[{x, y}, {x - 1, y}], [{x, y}, {x + 1, y}], [{x, y}, {x, y - 1}], [{x, y}, {x, y + 1}] | connection_list ]

    connections(rest, connection_list)
  end

  defp connections([], connection_list) do
    connection_list
    |> Enum.map(&(Enum.sort(&1)))
    |> Enum.uniq
    |> Enum.filter(fn([{a, b}, {x, y}]) -> Enum.min([a, b, x, y]) >= 0 && Enum.max([a, b, x, y]) <= 3 end)
  end

  defp draw_nodes() do
    line = List.duplicate(["##", "  "], 3) ++ ["##"] |> List.flatten
    draw_nodes([line, line])
  end

  defp draw_nodes(content) do
    if Enum.count(content) > 13 do
      content
    else
      emptyline = List.duplicate(["  "], 7)
      nodeline = List.duplicate(["##", "  "], 3) ++ ["##"] |> List.flatten

      draw_nodes(content ++ [ emptyline, emptyline, nodeline, nodeline ])
    end
  end

  defp draw_connections(content, []) do
    content
  end

  defp draw_connections(content, [[{x1, y1}, {x2, y2}] | connections]) do
    cond do
      x1 == x2 -> # Horizontal connection
        line = content |> Enum.fetch!(4 * x1) |> List.replace_at(y1 + y2, "##")
        content = List.replace_at(content, 4 * x1, line) |> List.replace_at(4 * x1 + 1, line)
        draw_connections(content, connections)
      y1 == y2 -> # Vertical connection
        line = content |> Enum.fetch!((x1 + x2) * 2) |> List.replace_at(2 * y1, "##")
        content = List.replace_at(content, (x1 + x2) * 2, line) |> List.replace_at((x1 + x2) * 2 + 1, line)
        draw_connections(content, connections)
    end
  end
end

Kruskal.generate(Enum.random(8..24)) |> Kruskal.draw()
