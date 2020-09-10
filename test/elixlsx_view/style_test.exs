defmodule ElixlsxView.StyleTest do
  @moduledoc false

  use ExUnit.Case

  alias Elixlsx.Sheet
  alias ElixlsxView.Style

  describe "apply/2" do
    test "applies styles to a sheet" do
      sheet = %Sheet{
        rows: [
          [["cell1", {:classes, [:cell1, :default]}, {:bold, true}]],
          [nil, ["cell2", {:classes, [:cell2]}]]
        ]
      }

      styles = [
        default: [font: "Arial", size: 14],
        cell1: [bold: true],
        cell2: [bg_color: "#fee"]
      ]

      assert %Sheet{
               rows: [
                 [
                   [
                     "cell1",
                     {:classes, [:cell1, :default]},
                     {:bold, true},
                     {:font, "Arial"},
                     {:size, 14}
                   ]
                 ],
                 [
                   nil,
                   ["cell2", {:classes, [:cell2]}, {:bg_color, "#fee"}]
                 ]
               ]
             } = Style.apply(sheet, styles)
    end
  end
end
