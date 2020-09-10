defmodule ElixlsxView.Style do
  @moduledoc """
  Allows to define styles for cell classes so you don't have to repeat
  styles when setting every row.
  """

  alias Elixlsx.Sheet

  @doc """
  Apply styles to the sheet

  In example below we do not set styles directly when assigning a
  value to A1 cell, but just provide a list of classes for this cell.
  The sheet we'll get in the output will have all the styles
  according to `@styles` table.

  ## Example

      @styles [
        cell1: [bold: true]
      ]

      alias Elixlsx.Sheet
      alias ElixlsxView.Style

      def render(sheet) do
        sheet
        |> Sheet.set_at(0, 0, "value", classes: [:cell1])
        |> Style.apply(@styles)
      end
  """
  def apply(%Sheet{rows: rows} = sheet, styles) do
    %{sheet | rows: do_apply_styles(rows, styles)}
  end

  defp do_apply_styles(rows, styles) do
    for cols <- rows do
      for cell <- cols do
        apply_styles_to_cell(cell, styles)
      end
    end
  end

  defp apply_styles_to_cell(nil, _styles) do
    nil
  end

  defp apply_styles_to_cell(cell, styles) do
    Enum.reduce(cell_classes(cell), cell, fn class, cell ->
      case Keyword.get(styles, class) do
        nil -> cell
        opts when is_list(opts) -> append_to_cell(cell, opts)
        _ -> raise ArgumentError, "expected styles to be keyword lists"
      end
    end)
  end

  defp cell_classes([_ | kv]) do
    Keyword.get(kv, :classes, [])
  end

  defp append_to_cell([value | old_opts], opts) do
    [value | Keyword.merge(old_opts, opts)]
  end
end
